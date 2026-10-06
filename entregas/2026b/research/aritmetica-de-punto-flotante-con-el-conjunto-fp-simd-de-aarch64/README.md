# Aritmética de Punto Flotante con el Conjunto FP/SIMD en AArch64

**Alumno:** Ballesteros Cruz Aldo Juventino.

**Matricula:** 23211920.

**Carrera:** Ingeniería en Sistemas Computacionales.

**Materia:** Lenguajes de Interfaz.

**Docente:** Rene Solis Reyes.

---

## Introducción: ¿Qué es la aritmética de punto flotante y cómo funciona en AArch64?


La **aritmética de punto flotante** es una forma de representar y realizar operaciones con números reales dentro de los sistemas informáticos. Este tipo de representación permite trabajar con valores que contienen partes fraccionarias y con números que pueden tener magnitudes muy grandes o muy pequeñas.

El término "punto flotante" hace referencia a que la posición del punto decimal puede variar dentro del número. Esto permite representar un rango amplio de valores utilizando una cantidad limitada de bits.

Los números de punto flotante son esenciales en informática debido a que una gran cantidad de aplicaciones científicas, de ingeniería, gráficas y financieras necesitan trabajar con valores que no necesariamente son números enteros.

En arquitecturas modernas como **AArch64**, estas operaciones pueden realizarse mediante el conjunto de instrucciones **FP/SIMD**, que permite tanto realizar operaciones escalares de punto flotante como procesar múltiples datos simultáneamente mediante SIMD.

---

## Desarrollo: Representación de números de punto flotante

La idea general de la representación de punto flotante consiste en dividir un número en diferentes componentes.

Las partes principales son:

* **Mantisa:** contiene los dígitos significativos del número.
* **Exponente:** determina la posición del punto decimal respecto a la mantisa.

En los sistemas informáticos, los números de punto flotante normalmente se representan utilizando **base 2**, es decir, mediante el sistema binario.

Por ejemplo, el número decimal:

```text
0.125
```

puede representarse en binario como:

```text
0.001
```

La representación binaria permite que el hardware pueda realizar operaciones aritméticas utilizando los circuitos digitales del procesador.

Los números de punto flotante también pueden representarse conceptualmente mediante una notación similar a la notación científica, utilizando una parte significativa y un exponente.

---

## ¿Qué es AArch64?


**AArch64** es el estado de ejecución de 64 bits de la arquitectura **ARMv8-A** y de arquitecturas ARM posteriores.

Esta arquitectura proporciona un conjunto de instrucciones de 64 bits, registros más grandes, direccionamiento de memoria mejorado, características de seguridad y mejoras de rendimiento respecto al estado de ejecución AArch32.

AArch64 se encuentra principalmente en procesadores de la familia **ARM Cortex-A**, utilizados en sistemas operativos como Linux, Android y Windows para ARM, además de diferentes plataformas integradas.

### Características principales de AArch64

* **Ejecución de instrucciones de 64 bits.**
* **Registros de 64 bits.**
* **Instrucciones de longitud fija de 32 bits.**
* **Espacio de direcciones virtuales más grande.**
* **Mejora del manejo de excepciones.**
* **Mejor rendimiento de punto flotante.**
* **Soporte avanzado de SIMD mediante NEON.**
* **Funciones de seguridad mejoradas.**

---

## Procesadores ARM que soportan AArch64

Diversos procesadores basados en **ARMv8-A** y **ARMv9-A** son compatibles con AArch64.

Algunos ejemplos son:

* Cortex-A53.
* Cortex-A55.
* Cortex-A57.
* Cortex-A72.
* Cortex-A73.
* Cortex-A76.
* Serie Cortex-X.
* Serie Neoverse.
* Apple M1, M2, M3 y procesadores posteriores.

---

## ¿Qué es SIMD?

**SIMD** (*Single Instruction, Multiple Data*) es una técnica de procesamiento paralelo que permite realizar una misma operación sobre múltiples elementos de datos mediante una sola instrucción.

En lugar de procesar cada dato de forma individual y secuencial, SIMD permite trabajar con varios datos simultáneamente.

Por ejemplo, si tenemos cuatro valores:

```text
A = [1, 2, 3, 4]
B = [5, 6, 7, 8]
```

una operación vectorial puede realizar las cuatro sumas al mismo tiempo:

```text
A + B = [6, 8, 10, 12]
```

Esto permite aprovechar el **paralelismo a nivel de datos** y puede mejorar el rendimiento en aplicaciones que realizan grandes cantidades de operaciones similares.

### Características principales de SIMD

* **Paralelismo de datos.**
* **Instrucciones SIMD.**
* **Unidades de procesamiento SIMD.**
* **Procesamiento de múltiples elementos simultáneamente.**
* **Aplicaciones en gráficos, procesamiento multimedia y cálculos científicos.**

En resumen, SIMD permite aprovechar el paralelismo a nivel de datos para realizar determinadas operaciones de manera más eficiente.

---

## Conjunto FP/SIMD en AArch64

En AArch64, la unidad **FP/SIMD** utiliza un banco de **32 registros de 128 bits**, denominados **V0-V31**.

Estos registros pueden utilizarse de diferentes maneras dependiendo de la precisión y del modo de operación.

| Sufijo |   Tamaño | Precisión         | Uso típico                                     |
| ------ | -------: | ----------------- | ---------------------------------------------- |
| `B`    |   8 bits | Byte              | Enteros pequeños                               |
| `H`    |  16 bits | Media precisión   | Audio y aplicaciones de aprendizaje automático |
| `S`    |  32 bits | Simple precisión  | Gráficos y videojuegos                         |
| `D`    |  64 bits | Doble precisión   | Cálculo científico                             |
| `Q`    | 128 bits | Registro completo | Operaciones SIMD                               |

Esta flexibilidad permite seleccionar el nivel de precisión adecuado dependiendo de las necesidades de la aplicación.

Por ejemplo, los gráficos 3D pueden utilizar valores de **32 bits** para realizar operaciones de manera eficiente, mientras que determinadas aplicaciones científicas requieren **64 bits** para obtener una mayor precisión.

El mismo registro Vn puede interpretarse de distintas formas según el sufijo:
- `Vn.16B` → 16 bytes
- `Vn.8H` → 8 medias palabras
- `Vn.4S` → 4 palabras simples
- `Vn.2D` → 2 palabras dobles

Además, los 128 bits se pueden acceder parcialmente como `Qn` (128), `Dn` (64), `Sn` (32), `Hn` (16) o `Bn` (8).

---

## Modos de operación

El conjunto FP/SIMD de AArch64 puede utilizarse principalmente mediante dos formas de operación:

### Modo escalar

En el **modo escalar**, una instrucción trabaja con un solo valor de punto flotante.

Por ejemplo:

```text
FADD S0, S1, S2
```

Esta instrucción realiza una suma entre valores almacenados en registros de precisión simple.

### Modo vectorial

En el **modo vectorial**, una instrucción puede operar sobre varios valores almacenados dentro de un registro SIMD.

Por ejemplo:

```text
FADD V0.4S, V1.4S, V2.4S
```

En este caso, la operación se realiza sobre cuatro elementos de 32 bits simultáneamente.

---

## Instrucciones FP escalares

| Instrucción | Descripción          | Ejemplo           |
| ----------- | -------------------- | ----------------- |
| `FADD`      | Suma                 | `FADD S0, S1, S2` |
| `FSUB`      | Resta                | `FSUB S0, S1, S2` |
| `FMUL`      | Multiplicación       | `FMUL S0, S1, S2` |
| `FDIV`      | División             | `FDIV S0, S1, S2` |
| `FMLA`      | Multiplicar-acumular | `FMLA S0, S1, S2` |
| `FSQRT`     | Raíz cuadrada        | `FSQRT S0, S1`    |
| `FCMP`      | Comparación          | `FCMP S0, S1`     |
| `SCVTF`     | Entero → Flotante    | `SCVTF S0, W0`    |
| `FCVTZS`    | Flotante → Entero    | `FCVTZS W0, S0`   |

Estas instrucciones permiten realizar operaciones aritméticas y conversiones entre valores enteros y de punto flotante.

---

## Instrucciones SIMD vectoriales

| Instrucción | Descripción                    | Ejemplo                    |
| ----------- | ------------------------------ | -------------------------- |
| `LD1`       | Carga vectorial                | `LD1 {V0.4S}, [X0]`        |
| `ST1`       | Almacenamiento vectorial       | `ST1 {V0.4S}, [X0]`        |
| `FADD`      | Suma vectorial                 | `FADD V0.4S, V1.4S, V2.4S` |
| `FMUL`      | Multiplicación vectorial       | `FMUL V0.4S, V1.4S, V2.4S` |
| `FMLA`      | Multiplicar-acumular vectorial | `FMLA V0.4S, V1.4S, V2.4S` |
| `FADDV`     | Reducción horizontal           | `FADDV S0, V0.4S`          |

Las instrucciones vectoriales permiten aprovechar los registros V0-V31 para trabajar con varios elementos al mismo tiempo.
---
## Ejemplo práctico: suma de vectores con SIMD

El siguiente programa en ensamblador AArch64 suma dos vectores de 4 números flotantes de precisión simple: **C[i] = A[i] + B[i]**. Usa instrucciones vectoriales de la unidad FP/SIMD (`LD1`, `FADD`, `ST1`) para realizar las cuatro sumas en una sola operación.

### Código (suma_vectores.s)

```asm
// suma_vectores.s
// Suma dos vectores de 4 floats: C = A + B
// Convención de llamada AAPCS64:
//   X0 = dirección base del vector A
//   X1 = dirección base del vector B
//   X2 = dirección base del vector C (resultado)

        .global suma_vectores
        .type   suma_vectores, %function

suma_vectores:
        LD1   {V0.4S}, [X0]         // carga A[0..3] en V0 (4 floats)
        LD1   {V1.4S}, [X1]         // carga B[0..3] en V1 (4 floats)
        FADD  V2.4S, V0.4S, V1.4S   // V2 = V0 + V1 (4 sumas en paralelo)
        ST1   {V2.4S}, [X2]         // guarda C[0..3] desde V2
        RET                         // regresa al llamador
```

### Explicación línea por línea

| Instrucción | Qué hace |
|-------------|----------|
| `LD1 {V0.4S}, [X0]` | Carga 4 valores de 32 bits (cuatro *single*) desde la memoria apuntada por X0 hacia el registro V0. El sufijo `.4S` indica 4 elementos de precisión simple. |
| `LD1 {V1.4S}, [X1]` | Igual que la anterior, pero carga el vector B en V1. |
| `FADD V2.4S, V0.4S, V1.4S` | Realiza **4 sumas de punto flotante en una sola instrucción**, una por cada carril del vector. Es el corazón del paralelismo SIMD. |
| `ST1 {V2.4S}, [X2]` | Almacena los 4 resultados en la dirección de C. |
| `RET` | Retorna al código que llamó a la función. |

### Ventaja frente a la versión escalar

La misma operación con instrucciones escalares requeriría 4 cargas, 4 sumas y 4 almacenamientos, además de calcular el desplazamiento de cada elemento:

```asm
// Versión escalar equivalente (sin SIMD)
        LDR   S0, [X0]            // A[0]
        LDR   S1, [X1]            // B[0]
        FADD  S2, S0, S1
        STR   S2, [X2]            // C[0]

        LDR   S0, [X0, #4]        // A[1]
        LDR   S1, [X1, #4]        // B[1]
        FADD  S2, S0, S1
        STR   S2, [X2, #4]        // C[1]

        LDR   S0, [X0, #8]        // A[2]
        LDR   S1, [X1, #8]        // B[2]
        FADD  S2, S0, S1
        STR   S2, [X2, #8]        // C[2]

        LDR   S0, [X0, #12]       // A[3]
        LDR   S1, [X1, #12]       // B[3]
        FADD  S2, S0, S1
        STR   S2, [X2, #12]       // C[3]
        RET
```

### Comparación

| Aspecto | Versión escalar | Versión SIMD |
|---------|----------------|--------------|
| Instrucciones de carga | 4 (`LDR`) | 1 (`LD1`) |
| Instrucciones de suma | 4 (`FADD`) | 1 (`FADD`) |
| Instrucciones de almacenamiento | 4 (`STR`) | 1 (`ST1`) |
| Total de instrucciones | 12 + cálculo de offsets | 5 |
| Paralelismo | Ninguno | 4 operaciones simultáneas |

Con 4 elementos la diferencia es notable; con vectores de 8 o 16 floats la ventaja de SIMD se vuelve mucho mayor, ya que el número de instrucciones permanece casi constante mientras el escalar crece de forma lineal.

### Cómo se ejecutaría

Compilación y enlace con `gcc` para AArch64:

```bash
aarch64-linux-gnu-gcc -c suma_vectores.s -o suma_vectores.o
aarch64-linux-gnu-gcc suma_vectores.o main.c -o demo
```

Donde `main.c` podría ser:

```c
#include <stdio.h>

extern void suma_vectores(float *A, float *B, float *C);

int main(void) {
    float A[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float B[4] = {10.0f, 20.0f, 30.0f, 40.0f};
    float C[4] = {0};

    suma_vectores(A, B, C);

    for (int i = 0; i < 4; i++)
        printf("C[%d] = %.1f\n", i, C[i]);

    return 0;
}
```

Salida esperada:

```
C[0] = 11.0
C[1] = 22.0
C[2] = 33.0
C[3] = 44.0
```

---

## Modos de redondeo

Las operaciones de punto flotante pueden requerir redondeo cuando el resultado exacto no puede representarse completamente con la precisión disponible.

Entre los modos de redondeo se encuentran:

* **Redondeo al más cercano:** es el modo utilizado de forma predeterminada.
* **Redondeo hacia cero:** el resultado se aproxima hacia cero.
* **Redondeo hacia +infinito:** el resultado se aproxima hacia el infinito positivo.
* **Redondeo hacia -infinito:** el resultado se aproxima hacia el infinito negativo.

* El comportamiento de las operaciones de punto flotante se controla mediante dos registros especiales:
- **FPCR** (Floating-point Control Register): define el modo de redondeo activo y habilita excepciones.
- **FPSR** (Floating-point Status Register): registra banderas de excepción (inexacto, desbordamiento, división por cero, etc.).

Las instrucciones que aplican explícitamente cada modo de redondeo son:
- `FRINTN` → redondeo al más cercano
- `FRINTZ` → redondeo hacia cero
- `FRINTP` → redondeo hacia +infinito
- `FRINTM` → redondeo hacia -infinito

Los modos de redondeo pueden ser importantes en aplicaciones científicas y numéricas, donde pequeñas diferencias en los resultados pueden acumularse durante una gran cantidad de operaciones.

---

## Relación entre punto flotante y SIMD

El conjunto **FP/SIMD** combina dos capacidades importantes.

Por un lado, permite realizar operaciones de **punto flotante** con diferentes niveles de precisión. Por otro, mediante SIMD permite aplicar una misma operación sobre varios datos de forma simultánea.

La diferencia puede observarse de la siguiente manera:

```text
Modo escalar

S1 ─────┐
        ├── FADD ──> S0
S2 ─────┘


Modo vectorial

V1.4S ─────┐
            ├── FADD ──> V0.4S
V2.4S ─────┘

   4 operaciones simultáneas
```

De esta manera, una aplicación que realiza repetidamente la misma operación sobre grandes cantidades de datos puede aprovechar el procesamiento vectorial para mejorar su rendimiento.

---

## Aplicaciones del conjunto FP/SIMD

Las operaciones de punto flotante y SIMD pueden ser utilizadas en diferentes áreas donde se requiere procesar grandes cantidades de datos.

Algunos ejemplos son:

* **Gráficos 2D y 3D.**
* **Videojuegos.**
* **Procesamiento de imágenes.**
* **Procesamiento de audio y video.**
* **Cálculos científicos.**
* **Simulaciones.**
* **Aplicaciones de aprendizaje automático.**
* **Procesamiento de señales.**

El beneficio de SIMD depende del tipo de algoritmo utilizado. Los algoritmos que realizan operaciones independientes sobre múltiples elementos pueden aprovechar mejor este tipo de procesamiento.

---

## Conclusiones personales

Aprender cómo funciona la **aritmética de punto flotante y las extensiones SIMD en AArch64** permite comprender mejor cómo los procesadores modernos realizan operaciones numéricas de manera eficiente.

Me pareció interesante comprender la diferencia entre el **modo escalar y el modo vectorial**, ya que permite observar cómo una misma operación puede realizarse sobre un solo dato o sobre varios datos simultáneamente.

También resulta importante conocer los registros especializados **V0-V31** y las diferentes formas en que pueden utilizarse dependiendo de la precisión requerida. Esto permite entender mejor cómo se pueden optimizar determinadas aplicaciones de alto rendimiento.

Además, los diferentes **modos de redondeo** muestran que la representación de números de punto flotante no siempre produce resultados exactos, por lo que es importante considerar la precisión utilizada en aplicaciones científicas y numéricas.

Finalmente, aunque SIMD puede proporcionar ventajas importantes de rendimiento, no todos los algoritmos pueden vectorizarse de manera eficiente. Por esta razón, es necesario evaluar si una optimización manual es conveniente o si el compilador puede realizarla automáticamente.

---

## Referencias

[1] Arm Ltd., *Arm Architecture Reference Manual for A-profile architecture*, 
    ARM DDI 0487, 2024. [En línea]. Disponible en: 
    https://developer.arm.com/documentation/ddi0487/latest/

[2] Arm Ltd., “AArch64 floating-point and SIMD registers,” Arm Developer. 
    [En línea]. Disponible en: 
    https://developer.arm.com/documentation/dui0801/latest/

[3] IIES, “AArch64: A deep dive into its architecture and design,” IIES, 
    5 sep. 2024. [En línea]. Disponible en: 
    https://iies.in/blog/aarch64-a-deep-dive-into-its-architecture-and-design/#What_Is_AArch64_Architecture
