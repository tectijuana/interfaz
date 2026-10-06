# Impacto de los niveles de optimización `-O0`, `-O2` y `-Os` de GCC en la generación de código y en la microarquitectura de ejecución sobre ARM (AArch32 y AArch64)

**Tipo de documento:** Informe de investigación técnica (revisión de literatura y análisis de casos)
**Área:** Ingeniería de compiladores · Sistemas embebidos · Arquitectura de computadores
**Palabras clave:** GCC, ARM, AArch32, AArch64, Thumb-2, `-O0`, `-O2`, `-Os`, tamaño de código, consumo energético, caché de instrucciones, autovectorización

---

## Resumen (Abstract)

Este trabajo analiza las diferencias sistemáticas en el código máquina generado por GCC (GNU Compiler Collection) al compilar con las banderas `-O0`, `-O2` y `-Os` para las arquitecturas ARM de 32 bits (AArch32, incluyendo Thumb-2) y de 64 bits (AArch64). Se describe el pipeline de compilación de GCC (GENERIC → GIMPLE → RTL), se detallan las transformaciones habilitadas en cada nivel según la documentación oficial, y se contrasta el ensamblador generado para un bucle de acumulación sobre un arreglo. Posteriormente se sintetizan los hallazgos de la literatura académica sobre rendimiento, consumo de energía y comportamiento de la caché de instrucciones. Se concluye que ningún nivel es universalmente superior: `-O0` se justifica solo para depuración, `-O2` suele ser el punto de equilibrio en plataformas con memoria abundante, y `-Os` es la opción habitual en microcontroladores con Flash y SRAM restringidas, aunque su ventaja de velocidad depende de la microarquitectura y debe validarse empíricamente.

---

## Tabla de contenidos

1. [Introducción y objetivos](#1-introducción-y-objetivos)
2. [Marco teórico: el pipeline de GCC](#2-marco-teórico-el-pipeline-de-gcc)
3. [Fundamentos de la arquitectura ARM relevantes para el análisis](#3-fundamentos-de-la-arquitectura-arm-relevantes-para-el-análisis)
4. [Transformaciones por nivel de optimización](#4-transformaciones-por-nivel-de-optimización)
5. [Comparativa técnica de generación de código](#5-comparativa-técnica-de-generación-de-código)
6. [Estudio de caso: análisis del ensamblador generado](#6-estudio-de-caso-análisis-del-ensamblador-generado)
7. [Hallazgos de la literatura académica](#7-hallazgos-de-la-literatura-académica)
8. [Metodología recomendada para reproducir el estudio](#8-metodología-recomendada-para-reproducir-el-estudio)
9. [Criterios de selección en ingeniería de software](#9-criterios-de-selección-en-ingeniería-de-software)
10. [Amenazas a la validez y limitaciones](#10-amenazas-a-la-validez-y-limitaciones)
11. [Conclusiones](#11-conclusiones)
12. [Referencias](#12-referencias)

---

## 1. Introducción y objetivos

La elección del nivel de optimización del compilador es una de las decisiones de mayor impacto y menor costo en el desarrollo de software para ARM. Un mismo código fuente en C puede producir binarios que difieren en más de un factor de dos en tamaño y en tiempo de ejecución según la bandera empleada [1]. En sistemas embebidos, donde la memoria Flash, la SRAM y la energía son recursos limitados, esta decisión afecta directamente el costo del hardware y la autonomía del dispositivo.

**Objetivos:**

1. Describir los mecanismos por los cuales GCC transforma el código en cada nivel (`-O0`, `-O2`, `-Os`).
2. Comparar el código ensamblador resultante en AArch32/Thumb-2 para un caso de estudio concreto.
3. Sintetizar la evidencia académica sobre rendimiento, energía y tamaño de código.
4. Proponer criterios prácticos de selección y una metodología reproducible de evaluación.

**Pregunta de investigación:** ¿Cómo cambian la estructura del código generado y su comportamiento en la microarquitectura ARM al pasar de `-O0` a `-O2` y `-Os`, y bajo qué condiciones `-Os` supera a `-O2` en velocidad?

---

## 2. Marco teórico: el pipeline de GCC

GCC traduce el código fuente a través de varias representaciones intermedias (IR). El flujo simplificado es el siguiente [2], [3]:

```text
 Código C/C++
      │  (front-end)
      ▼
   GENERIC          ← árbol independiente del lenguaje
      │
      ▼
   GIMPLE           ← código de tres direcciones (simplificado)
      │
      ▼
 GIMPLE en forma SSA  ◄── Pases "tree-ssa": propagación de constantes,
      │                    DCE, CSE/PRE, inlining, vectorización, etc.
      ▼
   RTL              ◄── Pases de bajo nivel: selección de instrucciones,
      │                  planificación (scheduling), asignación de
      ▼                  registros (IRA/LRA), peephole
 Ensamblador ARM / AArch64
```

Aspectos relevantes:

- **GIMPLE** no es un AST puro: es una representación de tres direcciones, y en la mayoría de los pases de optimización de alto nivel se mantiene en forma **SSA** (*Static Single Assignment*), lo que facilita análisis como propagación de constantes y eliminación de código muerto [2], [4].
- **RTL** (*Register Transfer Language*) es la IR de bajo nivel, cercana a la máquina. Aquí operan la asignación de registros (IRA y LRA), la planificación de instrucciones y la selección final de instrucciones para el destino [3].
- Cada bandera `-O*` es, en esencia, un **conjunto predefinido de pases y parámetros** (*flags* individuales como `-fipa-cp`, `-finline-functions`, `-fschedule-insns2`, etc.) documentados en la sección *Optimize Options* del manual de GCC [5].

---

## 3. Fundamentos de la arquitectura ARM relevantes para el análisis

| Aspecto | AArch32 (ARMv7-A/R/M) | AArch64 (ARMv8-A) |
|---|---|---|
| Registros de propósito general | r0–r12, sp (r13), lr (r14), pc (r15) | x0–x30 (más `sp` y `xzr`) |
| Registros preservados por el llamado (*callee-saved*) | r4–r11 | x19–x28 (más x29/FP) |
| Puntero de marco (FP) por convención | r11 (modo ARM), r7 (Thumb) | x29 |
| Conjuntos de instrucciones | ARM (32 bits), Thumb/Thumb-2 (16/32 bits) | A64 (instrucciones fijas de 32 bits) |
| Ejecución condicional | Amplia en modo ARM; bloques `IT` en Thumb-2 | Reducida (`CSEL`, `CCMP`, etc.) |
| Modos de direccionamiento | Pre/post-indexado, registro escalado | Pre/post-indexado, registro extendido/escalado |

Fuente de la tabla: manuales de referencia de la arquitectura [6], [7].

Puntos clave para este estudio:

1. **Thumb-2** mezcla instrucciones de 16 y 32 bits y ofrece una densidad de código notablemente mejor que el modo ARM clásico, con un rendimiento comparable [8]. Los núcleos Cortex-M solo ejecutan Thumb/Thumb-2.
2. **AArch64 no tiene Thumb**: todas las instrucciones miden 32 bits, por lo que la densidad de código depende de la selección de instrucciones y no del ancho de codificación.
3. La selección entre modo ARM y Thumb **no la decide `-Os`**, sino banderas como `-mthumb`, `-marm` o `-mcpu`/`-march` [5]. En un Cortex-M, Thumb-2 es el único modo posible, independientemente del nivel de optimización.

---

## 4. Transformaciones por nivel de optimización

### 4.1 `-O0` — Sin optimización (valor por defecto)

- **Objetivo:** compilación rápida y correspondencia directa entre código fuente y código de máquina para facilitar la depuración con GDB.
- **Comportamiento típico:**
  - Las variables locales residen en la **pila**; cada lectura/escritura genera un `LDR`/`STR` explícito.
  - Se mantiene el **puntero de marco** (FP) activo.
  - No se aplican transformaciones significativas de propagación de constantes, eliminación de subexpresiones comunes ni inlining (salvo funciones marcadas `always_inline`).
- **Nota:** para depuración, GCC ofrece `-Og`, que aplica optimizaciones que no interfieren de forma importante con la experiencia de depuración y suele producir código considerablemente mejor que `-O0`.

### 4.2 `-O2` — Optimización orientada a rendimiento

- **Objetivo:** mejorar el rendimiento sin las transformaciones más agresivas que aumentan mucho el tamaño (que se reservan para `-O3`).
- **Comportamiento típico (según [5]):**
  - Asignación global de registros (IRA/LRA): las variables viven en registros.
  - Omisión del puntero de marco (`-fomit-frame-pointer`, activado desde `-O1` en la mayoría de los destinos).
  - Eliminación de subexpresiones comunes (CSE/GCSE), propagación de constantes, DCE.
  - Planificación de instrucciones (`-fschedule-insns2`) para reducir *stalls* de *pipeline*.
  - *Inlining* de funciones (`-finline-functions`, habilitado en `-O2` desde GCC 10) con heurísticas moderadas.
  - Alineación de funciones, bucles y saltos (`-falign-*`).
  - **Autovectorización:** desde GCC 12, `-O2` habilita `-ftree-vectorize` con el modelo de costos `very-cheap`, que solo vectoriza cuando no se espera aumento de tamaño de código; antes de GCC 12, la vectorización comenzaba en `-O3`.
- **Precisión importante:** `-O2` **no** habilita `-funroll-loops`. El desenrollado explícito de bucles se activa con `-funroll-loops` o de forma parcial con `-O3`/`-fpeel-loops`. Lo que `-O2` sí puede hacer es el *complete unrolling* de bucles con pocas iteraciones constantes cuando no incrementa el tamaño.

### 4.3 `-Os` — Optimización orientada a tamaño

- **Objetivo:** minimizar el tamaño del binario.
- **Comportamiento (según la documentación de GCC [5]):** `-Os` habilita todas las optimizaciones de `-O2` **excepto** aquellas que suelen aumentar el tamaño del código, y añade otras dirigidas a reducirlo. En particular:
  - No activa `-falign-functions`, `-falign-jumps`, `-falign-loops` ni `-falign-labels`, evitando el relleno con `NOP`.
  - Reduce significativamente la agresividad del *inlining* y de la duplicación de código.
  - Usa una reordenación de bloques básicos simple (`-freorder-blocks-algorithm=simple`) en lugar de la variante orientada a rendimiento.
  - Mantiene técnicas de fusión de código común (*cross-jumping* / *tail merging*), y favorece prólogos/epílogos compactos con `PUSH`/`POP` múltiples y *shrink-wrapping*.
- **Sobre Thumb-2:** el ahorro de tamaño típico en ARM proviene en gran medida de que el destino ya use Thumb-2; `-Os` **no** cambia el conjunto de instrucciones, pero el selector de instrucciones sí prefiere codificaciones de 16 bits cuando las hay disponibles.

### 4.4 Relación con `-O3` (contexto académico)

Gran parte de la literatura compara `-O2` frente a `-O3`. `-O3` activa una vectorización más agresiva (NEON/SVE), *loop unrolling*/*peeling* y más *inlining*, con un incremento potencialmente importante del tamaño [5]. Diversos estudios encuentran que `-O3` no siempre mejora el rendimiento o la energía respecto a `-O2` [1].

---

## 5. Comparativa técnica de generación de código

| Dimensión técnica | `-O0` | `-O2` | `-Os` |
|---|---|---|---|
| **Uso de pila / marco** | Alto: marco activo, FP reservado (r7/r11 o x29) | Mínimo: se omite el FP; solo se guarda lo necesario | Mínimo: prólogos/epílogos compactos con `PUSH`/`POP` múltiples |
| **Ubicación de variables** | Memoria (pila) | Registros | Registros |
| **Presión de registros** | Nula (todo pasa por memoria) | Alta: aprovecha registros temporales y preservados | Alta, con preferencia por registros bajos (r0–r7) para codificaciones de 16 bits en Thumb |
| **IPC efectivo (cualitativo)** | Bajo: dependencias `STR`→`LDR` y accesos a memoria frecuentes | Alto: instrucciones reordenadas para ocultar latencias | Moderado: prioriza brevedad sobre latencia |
| **Estructura de bucles** | Condición evaluada al inicio, `CMP` + `B` explícitos | Inversión de bucle (*loop inversion*), posible vectorización | Similar a `-O2`, sin *unrolling* ni alineación; puede usar `SUBS`+`BNE` si el compilador puede demostrar que es seguro |
| **Modos de direccionamiento** | Desplazamientos inmediatos sobre SP/FP | Registro escalado (`[r0, r3, lsl #2]`) | Post-indexado (`[r0], #4`) cuando reduce instrucciones |
| **Inlining** | Prácticamente nulo | Moderado | Mínimo |
| **Alineación de código** | Por defecto | Sí (relleno con `NOP`) | No |
| **Depuración con GDB** | Excelente | Limitada (variables optimizadas fuera) | Limitada |

---

## 6. Estudio de caso: análisis del ensamblador generado

Se analiza un bucle de acumulación sobre un arreglo de enteros:

```c
int acumular(const int *datos, int n) {
    int total = 0;
    for (int i = 0; i < n; i++) {
        total += datos[i];
    }
    return total;
}
```

### 6.1 Generación en `-O0` (AArch32)

```asm
acumular:
    push    {r7, lr}
    sub     sp, sp, #24
    add     r7, sp, #0
    str     r0, [r7, #4]        @ guarda 'datos' en la pila
    str     r1, [r7, #0]        @ guarda 'n' en la pila
    mov     r3, #0
    str     r3, [r7, #16]       @ total = 0
    mov     r3, #0
    str     r3, [r7, #20]       @ i = 0
    b       .L2
.L3:                            @ cuerpo del bucle
    ldr     r3, [r7, #20]       @ carga 'i'
    lsl     r3, r3, #2          @ i * 4
    ldr     r2, [r7, #4]        @ carga base de 'datos'
    add     r3, r2, r3          @ dirección de datos[i]
    ldr     r2, [r3]            @ carga datos[i]
    ldr     r3, [r7, #16]       @ carga 'total'
    add     r3, r3, r2          @ total + datos[i]
    str     r3, [r7, #16]       @ guarda 'total'
    ldr     r3, [r7, #20]       @ carga 'i'
    add     r3, r3, #1          @ i++
    str     r3, [r7, #20]       @ guarda 'i'
.L2:                            @ condición
    ldr     r2, [r7, #20]       @ carga 'i'
    ldr     r3, [r7, #0]        @ carga 'n'
    cmp     r2, r3
    blt     .L3
    ldr     r3, [r7, #16]       @ valor de retorno
    mov     r0, r3
    add     r7, r7, #24
    mov     sp, r7
    pop     {r7, pc}
```

**Análisis:** cada iteración completa ejecuta **9 accesos a memoria**: 8 sobre la pila (6 cargas de variables locales: `i` ×3, `datos`, `total` y `n`; y 2 almacenamientos: `total` e `i`) más la lectura real de `datos[i]`. De ellos, solo esta última es trabajo útil; el resto es tráfico generado por la política «una variable, una posición de memoria». Además, aparecen dependencias `STR`→`LDR` a la misma dirección (por ejemplo, `i` se guarda y se vuelve a cargar inmediatamente), que en núcleos en orden pueden generar *stalls* y, en núcleos con *store-to-load forwarding*, aún consumen ancho de banda de la unidad de carga/almacenamiento.

### 6.2 Generación en `-O2` (AArch32 / Thumb-2)

```asm
acumular:
    cmp     r1, #0
    ble     .L2
    mov     r2, #0              @ total = 0
    mov     r3, #0              @ i = 0
.L3:
    ldr     r12, [r0, r3, lsl #2] @ carga con índice escalado
    add     r3, r3, #1          @ i++
    add     r2, r2, r12         @ total += datos[i]
    cmp     r1, r3              @ ¿i == n?
    bne     .L3
    mov     r0, r2
    bx      lr
.L2:
    mov     r0, #0
    bx      lr
```

**Análisis:** el acceso a pila desaparece por completo. Las tres variables (`total`, `i`, puntero base) viven en registros y el único acceso a memoria del bucle es la lectura útil de `datos[i]`. El modo de direccionamiento de registro escalado permite calcular la dirección y cargar en una sola instrucción, evitando el `LSL` + `ADD` explícitos de `-O0`. Se observa además la comprobación previa `n <= 0` (efecto de la inversión de bucle), que garantiza la semántica correcta cuando `n` es cero o negativo.

### 6.3 Generación en `-Os` (AArch32 / Thumb-2)

```asm
acumular:
    movs    r2, #0              @ total = 0
    cmp     r1, #0
    ble     .L3                 @ si n <= 0, no hay iteraciones
.L2:
    ldr     r3, [r0], #4        @ carga datos[i] y avanza el puntero
    adds    r2, r2, r3          @ total += datos[i]
    subs    r1, r1, #1          @ n-- (actualiza banderas)
    bne     .L2                 @ repite mientras n != 0
.L3:
    mov     r0, r2
    bx      lr
```

**Análisis:**

- **Reducción del bucle a 4 instrucciones** mediante dos técnicas: (1) transformar el contador ascendente `i < n` en un contador descendente, de modo que `SUBS` produzca las banderas y se elimine el `CMP` explícito; y (2) usar direccionamiento **post-indexado** (`[r0], #4`), que fusiona la carga con la actualización del puntero.
- **Corrección importante:** la reducción a un contador descendente con `BNE` solo es válida si el compilador garantiza `n > 0` al entrar al bucle. Por eso se conserva la comprobación `cmp r1, #0` + `ble`. Una comprobación de igualdad a cero como `cbz` **no** sería semánticamente equivalente a `i < n` si `n` fuese negativo, ya que el contador descendente tardaría del orden de 2³² iteraciones en llegar a cero.
- **Codificación:** en Thumb-2, `movs`, `adds` y `subs` con registros bajos admiten codificación de 16 bits, mientras que `ldr r3, [r0], #4` (post-indexado) se codifica en **32 bits**. El ahorro global de tamaño proviene de la mezcla, no de que todas las instrucciones sean de 16 bits.
- **Consecuencia microarquitectónica:** menos instrucciones significan menos huella en la caché de instrucciones y en Flash, pero en núcleos superescalares el cuerpo de `-O2` (con más paralelismo de instrucciones) puede ejecutarse igual o más rápido.

### 6.4 Resumen cuantitativo del caso (instrucciones del bucle)

| Nivel | Instrucciones en el cuerpo del bucle | Accesos a memoria por iteración | Uso de pila |
|---|---|---|---|
| `-O0` | ~16 (cuerpo + condición) | 9 | Sí (marco de 24 bytes) |
| `-O2` | 5 | 1 | No |
| `-Os` | 4 | 1 | No |

*(Los conteos corresponden a los listados ilustrativos; verifique con su versión de GCC.)*

---

## 7. Hallazgos de la literatura académica

### 7.1 Rendimiento y energía

- Pallister *et al.* [1] evaluaron el efecto de las banderas de GCC sobre el consumo de energía en varias plataformas embebidas, utilizando el conjunto de pruebas **BEEBS** [9]. Sus resultados indican que los niveles de optimización reducen sustancialmente la energía respecto a `-O0`, pero que **el mejor nivel varía según la plataforma y el programa**, y que `-O3` no es sistemáticamente la mejor opción energética frente a `-O2`.
- Los accesos a memoria son una fuente relevante de energía en sistemas embebidos: al eliminar los `LDR`/`STR` de pila, `-O2` y `-Os` reducen el tráfico de memoria y, generalmente, el producto energía-retardo (*Energy-Delay Product*, EDP) frente a `-O0` [1], [10].
- **Sobre las magnitudes:** las mejoras concretas (por ejemplo, la reducción del tiempo de ejecución de `-O2` frente a `-O0`) dependen fuertemente del benchmark y del núcleo. Aunque es común encontrar reducciones de tiempo de varias decenas de puntos porcentuales, no existe una cifra universal; se recomienda medir con la carga de trabajo propia en lugar de asumir un rango fijo (véase la sección 8).

### 7.2 Tamaño de código frente a caché de instrucciones

- El principio general, descrito en la literatura de arquitectura [11], es que un código más compacto reduce la presión sobre la caché de instrucciones y los *fetch stalls*. En núcleos con caché de instrucciones limitada o con acceso a Flash con estados de espera (*wait states*), `-Os` **puede** igualar o superar a `-O2` en velocidad.
- Este efecto es **condicional**: depende de que el conjunto de trabajo del programa exceda la caché o de que la Flash sea el cuello de botella. En núcleos Cortex-M sin caché (M0, M3, M4) el rendimiento depende de aceleradores de Flash/prefetch del fabricante; en el Cortex-M7 la caché de instrucciones es opcional y su tamaño lo define el fabricante del SoC [8].
- En muchos programas pequeños con bucles calientes que caben en caché, `-O2` conserva la ventaja gracias a un mejor *scheduling* y a la eliminación de dependencias.

### 7.3 Autovectorización y SIMD

- La vectorización automática con NEON (AArch32/AArch64) o SVE (AArch64) depende de la versión de GCC, de `-ftree-vectorize` y de los modelos de costos (`very-cheap`, `cheap`, `dynamic`). Como se indicó en la sección 4.2, desde GCC 12 `-O2` incluye una vectorización conservadora; `-O3` habilita modelos más agresivos, con mayor riesgo de crecimiento de código [5].
- En AArch32, NEON requiere `-mfpu=neon` (o equivalente en `-mcpu`) y un objetivo que lo soporte; en AArch64, Advanced SIMD forma parte de la arquitectura base de ARMv8-A [7].

### 7.4 Selección de flags y auto-ajuste

- Ashouri *et al.* [12] presentan una revisión de técnicas de **autotuning** de compiladores mediante aprendizaje automático, mostrando que los niveles estándar (`-O2`, `-O3`, `-Os`) son solo puntos fijos de un espacio de optimización enorme, y que para aplicaciones específicas se pueden lograr mejoras adicionales seleccionando subconjuntos de flags.

---

## 8. Metodología recomendada para reproducir el estudio

### 8.1 Generación de ensamblador

```bash
# AArch32 / Thumb-2 (Cortex-M4)
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -O0 -S acumular.c -o acumular_O0.s
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -O2 -S acumular.c -o acumular_O2.s
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -Os -S acumular.c -o acumular_Os.s

# AArch64 (Cortex-A53/A72)
aarch64-linux-gnu-gcc -mcpu=cortex-a53 -O0 -S acumular.c -o acumular_a64_O0.s
aarch64-linux-gnu-gcc -mcpu=cortex-a53 -O2 -S acumular.c -o acumular_a64_O2.s
aarch64-linux-gnu-gcc -mcpu=cortex-a53 -Os -S acumular.c -o acumular_a64_Os.s
```

### 8.2 Medición del tamaño

```bash
arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -Os -c programa.c -o programa.o
arm-none-eabi-size programa.o          # text / data / bss
arm-none-eabi-objdump -d programa.o    # inspección del desensamblado
```

### 8.3 Medición de rendimiento y energía

- **Ciclos:** contador de ciclos DWT (`DWT->CYCCNT`) en Cortex-M o PMU (`perf stat`) en Cortex-A.
- **Energía:** analizador de potencia o placa con medición integrada, siguiendo protocolos como los de BEEBS [9].
- **Buenas prácticas:** fijar la frecuencia de reloj, repetir cada medición varias veces, reportar media y desviación estándar, y documentar versión de GCC, `-mcpu`, estados de espera de Flash y estado de la caché.

---

## 9. Criterios de selección en ingeniería de software

| Escenario | Nivel recomendado | Justificación |
|---|---|---|
| Depuración local paso a paso | `-O0` (o `-Og`) | Correspondencia 1:1 con el código fuente y variables observables |
| Linux embebido en Cortex-A, memoria abundante | `-O2` | Buen equilibrio entre velocidad y tamaño; es el nivel de compilación habitual en muchas distribuciones |
| Microcontroladores Cortex-M con Flash/SRAM limitadas | `-Os` | Menor huella de memoria; en ocasiones también mayor velocidad por menor presión sobre Flash/caché |
| Bucles numéricos críticos con soporte SIMD | `-O2`/`-O3` + `-ftree-vectorize` (según versión) | Aprovecha NEON/SVE; verificar tamaño y correctitud |
| Código con requisitos de seguridad funcional (p. ej., certificación) | El nivel validado por el proceso de calificación | Los niveles altos pueden complicar la trazabilidad código–binario |

**Regla de oro:** los criterios anteriores son puntos de partida. La decisión final debe basarse en mediciones sobre el hardware y la carga de trabajo reales.

---

## 10. Amenazas a la validez y limitaciones

- **Dependencia de la versión de GCC:** las heurísticas de *inlining*, vectorización y *scheduling* cambian entre versiones (por ejemplo, el cambio en `-O2` a partir de GCC 12).
- **Dependencia del destino:** los resultados obtenidos en Cortex-M no se extrapolan directamente a Cortex-A, ni de AArch32 a AArch64.
- **Representatividad de los benchmarks:** un bucle sencillo como el del caso de estudio ilustra el mecanismo, pero no representa el comportamiento de aplicaciones completas.
- **Ruido de medición:** interrupciones, contención de bus, DVFS y estados de espera de Flash pueden alterar las medidas si no se controlan.
- **Listados ilustrativos:** el ensamblador presentado en la sección 6 no proviene de una ejecución específica y puede diferir de la salida real.

---

## 11. Conclusiones

1. `-O0` produce un código dominado por accesos a pila (en el caso estudiado, 9 accesos a memoria por iteración frente a 1 en `-O2`/`-Os`), lo que lo hace inadecuado para producción por rendimiento, tamaño y energía.
2. `-O2` maximiza el rendimiento de forma equilibrada mediante asignación de registros, *scheduling*, CSE e *inlining* moderado, sin el crecimiento de código de `-O3`.
3. `-Os` reduce el tamaño y suele ser la elección natural en microcontroladores; en ciertos escenarios (caché reducida o Flash lenta) puede igualar o superar a `-O2` en velocidad, pero no de forma universal.
4. La evidencia académica sugiere que **el mejor nivel depende de la plataforma y de la aplicación** [1], por lo que la evaluación empírica es un paso obligatorio del diseño.
5. Trabajo futuro: ampliar el estudio a `-O3`, `-Oz` (en LLVM/Clang), LTO (`-flto`) y comparar GCC con Clang en AArch64.

---

## 12. Referencias

[1] J. Pallister, S. J. Hollis, and J. Bennett, "Identifying compiler options to minimize energy consumption for embedded platforms," *Comput. J.*, vol. 58, no. 1, pp. 95–109, 2015.

[2] D. Novillo, "Tree SSA: A new optimization infrastructure for GCC," in *Proc. GCC Developers' Summit*, 2003.

[3] Free Software Foundation, *GCC Internals Manual*. [Online]. Available: https://gcc.gnu.org/onlinedocs/gccint/

[4] K. D. Cooper and L. Torczon, *Engineering a Compiler*, 2nd ed. Burlington, MA, USA: Morgan Kaufmann, 2011.

[5] Free Software Foundation, "Optimize Options," in *Using the GNU Compiler Collection (GCC)*. [Online]. Available: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html

[6] ARM Ltd., *ARM Architecture Reference Manual, ARMv7-A and ARMv7-R Edition*, Doc. DDI 0406C, 2012. [Online]. Available: https://developer.arm.com/documentation/ddi0406

[7] Arm Ltd., *Arm Architecture Reference Manual for A-profile Architecture*, Doc. DDI 0487, 2023. [Online]. Available: https://developer.arm.com/documentation/ddi0487

[8] J. Yiu, *The Definitive Guide to ARM Cortex-M3 and Cortex-M4 Processors*, 3rd ed. Oxford, U.K.: Newnes, 2013.

[9] J. Pallister, S. J. Hollis, and J. Bennett, "BEEBS: Open benchmarks for energy measurements on embedded platforms," 2013, *arXiv:1308.5174*. [Online]. Available: https://arxiv.org/abs/1308.5174

[10] K. Georgiou, S. Kerrison, Z. Chamski, and K. Eder, "Energy transparency for deeply embedded programs," *ACM Trans. Archit. Code Optim.*, vol. 14, no. 1, Art. no. 8, 2017.

[11] J. L. Hennessy and D. A. Patterson, *Computer Architecture: A Quantitative Approach*, 6th ed. Cambridge, MA, USA: Morgan Kaufmann, 2017.

[12] A. H. Ashouri, W. Killian, J. Cavazos, G. Palermo, and C. Silvano, "A survey on compiler autotuning using machine learning," *ACM Comput. Surv.*, vol. 51, no. 5, Art. no. 96, 2018, doi: 10.1145/3197978.

---
