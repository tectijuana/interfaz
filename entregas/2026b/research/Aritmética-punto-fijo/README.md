# Aritmética de punto fijo (Q15/Q31) para DSP en microcontroladores ARM

## Introducción

El procesamiento digital de señales, conocido como **DSP (Digital Signal Processing)**, se utiliza en sistemas embebidos para realizar tareas como filtrado de audio, procesamiento de sensores, control de motores, comunicaciones digitales, transformadas rápidas de Fourier y análisis de señales. En un microcontrolador, estas operaciones deben ejecutarse frecuentemente en tiempo real y con recursos limitados de memoria, capacidad de cómputo y consumo de energía.

Una forma de realizar estos cálculos es mediante números de punto flotante. Sin embargo, otra técnica ampliamente utilizada es la **aritmética de punto fijo**, en la cual los números fraccionarios se almacenan internamente como enteros y se interpreta que una determinada cantidad de bits representa la parte fraccionaria.

Dentro de los microcontroladores ARM se utilizan con frecuencia los formatos **Q15 y Q31**, especialmente en aplicaciones DSP. La biblioteca oficial **CMSIS-DSP de Arm** define `q15_t` como un dato fraccionario de 16 bits en formato 1.15 y `q31_t` como un dato de 32 bits en formato 1.31. CMSIS-DSP proporciona además funciones de filtrado, operaciones matemáticas, transformadas, procesamiento matricial y otras operaciones optimizadas para procesadores Cortex-M y Cortex-A. [1], [2]

---

## ¿Qué es la aritmética de punto fijo?

En punto fijo, la posición del punto binario se establece de manera implícita. El procesador almacena solamente un número entero, pero el programa interpreta una cantidad determinada de sus bits como parte fraccionaria.

De manera general, un número con `F` bits fraccionarios puede interpretarse mediante:

\[
x = \frac{X}{2^F}
\]

donde:

- `X` es el número entero almacenado.
- `F` es la cantidad de bits utilizados para la parte fraccionaria.
- `x` es el valor real representado.

Por ejemplo, en Q15 existen 15 bits fraccionarios. Por lo tanto:

\[
x = \frac{X}{2^{15}}
\]

Si se desea representar el valor decimal **0.75**:

\[
X = 0.75(2^{15})
\]

\[
X = 24576
\]

El número almacenado es entonces '245760' que en hexadecimal corresponde a:

```text
0x6000
```

Aunque el procesador trabaja con el entero 24576, el programa lo interpreta como 0.75.

Esta técnica permite implementar cálculos fraccionarios utilizando principalmente operaciones enteras, desplazamientos y multiplicaciones.

---

## Formato Q15

CMSIS-DSP define `q15_t` como un entero con signo de 16 bits utilizado en formato **1.15**. Esto significa que existe un bit asociado al signo y 15 bits para representar la fracción. [2]

Su resolución es:

\[
2^{-15} = 0.000030517578125
\]

Por lo tanto, el rango representable es:

\[
-1.0 \leq x \leq 1-2^{-15}
\]

es decir:

```text
Mínimo: -1.000000
Máximo:  0.999969482421875
```

Algunos ejemplos son:

| Decimal | Q15 entero | Hexadecimal |
|---:|---:|---:|
| 0.0 | 0 | `0x0000` |
| 0.25 | 8192 | `0x2000` |
| 0.50 | 16384 | `0x4000` |
| 0.75 | 24576 | `0x6000` |
| -0.50 | -16384 | `0xC000` |
| Máximo positivo | 32767 | `0x7FFF` |
| -1.0 | -32768 | `0x8000` |

CMSIS-DSP convierte un valor Q15 a `float` dividiendo el entero almacenado entre 32768, lo que confirma directamente la escala \(2^{15}\). [3]

---

## Formato Q31

Q31 utiliza 32 bits y CMSIS-DSP lo define como formato **1.31** mediante el tipo `q31_t`. [2]

La resolución es:

\[
2^{-31} \approx 4.656612873 \times 10^{-10}
\]

y su rango es:

\[
-1.0 \leq x \leq 1-2^{-31}
\]

aproximadamente:

```text
Mínimo: -1.0000000000
Máximo:  0.999999999534
```

Para representar nuevamente 0.75:

\[
0.75(2^{31}) = 1610612736
\]

Por lo tanto:

```text
Decimal:      0.75
Q31 entero:   1610612736
Hexadecimal:  0x60000000
```

CMSIS-DSP realiza la conversión inversa dividiendo el entero Q31 entre 2147483648, equivalente a \(2^{31}\). [4]

La principal diferencia entre Q15 y Q31 es la precisión. Q31 dispone de **16 bits fraccionarios adicionales**, por lo que puede representar diferencias mucho menores entre números.

---

## Comparación entre Q15 y Q31

| Característica | Q15 | Q31 |
|---|---:|---:|
| Tamaño | 16 bits | 32 bits |
| Formato CMSIS | 1.15 | 1.31 |
| Tipo CMSIS | `q15_t` | `q31_t` |
| Bits fraccionarios | 15 | 31 |
| Resolución | \(2^{-15}\) | \(2^{-31}\) |
| Valor mínimo | -1 | -1 |
| Máximo aproximado | 0.999969 | 0.999999999534 |
| Producto intermedio | 2.30 | 2.62 |
| Memoria por muestra | 2 bytes | 4 bytes |
| Precisión | Menor | Mayor |
| Costo de almacenamiento | Menor | Mayor |

No debe concluirse simplemente que Q31 siempre es mejor. Su mayor precisión exige más memoria y las multiplicaciones necesitan normalmente resultados intermedios de 64 bits. Q15, por otro lado, puede ser especialmente eficiente cuando la arquitectura ARM dispone de instrucciones DSP capaces de procesar dos valores de 16 bits simultáneamente.

---

## Suma y resta

Cuando dos números tienen exactamente el mismo formato Q, la suma puede realizarse directamente sobre sus representaciones enteras.

Por ejemplo:

```text
0.25 Q15 = 8192
0.50 Q15 = 16384

8192 + 16384 = 24576
24576 / 32768 = 0.75
```

El problema aparece cuando el resultado supera el intervalo disponible.

Por ejemplo:

\[
0.75+0.50=1.25
\]

Q15 no puede representar 1.25.

Si una implementación simplemente permite que el entero se desborde, el valor puede cambiar de signo y producir una señal completamente incorrecta. En procesamiento digital de señales suele preferirse la **saturación**, donde cualquier resultado mayor que el máximo se fija en `0x7FFF`, mientras que uno inferior al mínimo se fija en `0x8000`.

CMSIS-DSP utiliza aritmética con saturación en diversas operaciones Q15 y Q31. Por ejemplo, sus funciones de multiplicación saturan automáticamente los resultados que exceden el rango permitido. [5]

---

## Multiplicación Q15

Uno de los aspectos más importantes de la aritmética de punto fijo es que una multiplicación aumenta el número de bits fraccionarios.

Una multiplicación Q15 produce inicialmente:

\[
1.15 \times 1.15 = 2.30
\]

Considérese:

\[
0.75 \times -0.5 = -0.375
\]

Sus valores Q15 son:

```text
0.75 = 24576
-0.5 = -16384
```

Multiplicando los enteros:

```text
24576 × -16384 = -402653184
```

Este resultado todavía se encuentra escalado por \(2^{30}\). Para volver a Q15 se desplaza 15 bits hacia la derecha:

```text
-402653184 >> 15 = -12288
```

Finalmente:

\[
\frac{-12288}{32768}=-0.375
\]

Por tanto, la operación puede representarse conceptualmente como:

```text
resultadoQ15 = (a × b) >> 15
```

utilizando un registro de al menos 32 bits para almacenar el producto antes del desplazamiento.

---

## Multiplicación Q31

El mismo principio se aplica a Q31:

\[
1.31 \times 1.31 = 2.62
\]

Por ello se requiere un resultado intermedio de 64 bits.

Conceptualmente:

```text
producto64 = (int64)a * b;
resultadoQ31 = producto64 >> 31;
```

Después debe comprobarse si es necesario saturar el resultado.

Un caso límite importante es:

\[
-1 \times -1 = +1
\]

pero ni Q15 ni Q31 pueden representar exactamente `+1.0`; su máximo es ligeramente menor. Por esa razón una implementación DSP correcta debe saturar esta operación al máximo positivo, en lugar de permitir que ocurra un desbordamiento.

Este ejemplo demuestra por qué no basta con utilizar enteros y desplazamientos: es necesario considerar explícitamente **escalado, precisión, redondeo y saturación**.

---

## Acumulación y operaciones MAC

Una operación fundamental en DSP es **MAC (Multiply-Accumulate)**:

\[
acumulador = acumulador + (a \times b)
\]

Esta operación aparece repetidamente en filtros FIR, filtros IIR, convoluciones, productos punto y transformadas.

Un filtro FIR puede expresarse como:

\[
y[n] = \sum_{k=0}^{N-1}h[k]x[n-k]
\]

Cada muestra de entrada se multiplica por un coeficiente y posteriormente todos los productos se acumulan.

La acumulación constituye uno de los principales riesgos de la aritmética de punto fijo. Aunque cada producto individual esté dentro del rango permitido, la suma de numerosos productos puede superar el tamaño del acumulador.

CMSIS-DSP muestra claramente esta diferencia. La implementación estándar `arm_fir_q15()` utiliza productos 1.15 × 1.15 que generan resultados 2.30 y los acumula internamente utilizando 64 bits en formato 34.30. En cambio, determinadas versiones rápidas reducen las protecciones contra desbordamiento a cambio de mayor velocidad. [6]

Para Q31 la situación es todavía más delicada. `arm_fir_q31()` utiliza un acumulador de 64 bits en formato 2.62, pero dispone únicamente de un bit de guarda. La propia documentación recomienda reducir previamente la amplitud de entrada cuando sea necesario para impedir un desbordamiento del acumulador. [6]

Esto demuestra que elegir Q31 por su mayor precisión no elimina los problemas numéricos. En algunos algoritmos incluso puede requerir una planificación más cuidadosa del escalado.

---

## 9. Saturación frente a desbordamiento

Existen dos comportamientos posibles cuando un resultado supera el rango:

### Desbordamiento o wrap-around

Un valor que supera el máximo vuelve al extremo negativo.

Conceptualmente:

```text
32767 + 1 → -32768
```

En una señal de audio o de un sensor este cambio abrupto puede generar una distorsión extremadamente grande.

### Saturación

El resultado se limita al máximo permitido:

```text
32767 + 1 → 32767
```

Para DSP, este comportamiento suele ser más apropiado porque evita discontinuidades producidas exclusivamente por el desbordamiento binario.

CMSIS-DSP utiliza saturación en operaciones como multiplicación y suma de offset para Q15 y Q31. [5]

---

## Redondeo y cuantización

Cuando un número real se convierte a Q15 o Q31 se produce una **cuantización**, debido a que solamente existen determinados valores representables.

La conversión conceptual puede escribirse como:

\[
Q15 = round(x2^{15})
\]

y:

\[
Q31 = round(x2^{31})
\]

Por ejemplo, un valor como `0.123456789` no necesariamente posee una representación binaria exacta dentro de Q15.

El error entre el número original y el valor representado se conoce como **error de cuantización**.

Q31 presenta un error potencial mucho menor debido a sus 31 bits fraccionarios. Sin embargo, esto no significa que deba utilizarse automáticamente. Si las muestras provienen, por ejemplo, de un ADC de 12 o 16 bits, Q15 puede ser suficiente dependiendo de la precisión que exija el algoritmo.

La documentación de CMSIS-DSP permite convertir entre punto flotante y Q15/Q31 e indica además que sus rutinas de conversión pueden configurarse para aplicar redondeo. [7]

---

## Uso de instrucciones DSP en ARM

Una ventaja importante de ciertos procesadores ARM Cortex-M es la existencia de instrucciones especializadas para DSP.

CMSIS-Core ofrece intrínsecos como:

```c
__SMLAD()
```

Esta operación puede realizar **dos multiplicaciones con signo de 16 bits y sumar ambos productos a un acumulador de 32 bits**. Es especialmente útil cuando dos valores Q15 se empaquetan dentro de una palabra de 32 bits. [8]

También existe:

```c
__SMLALD()
```

que permite realizar dos multiplicaciones de 16 bits utilizando un acumulador de 64 bits. [8]

Esto resulta adecuado para implementar filtros, correlaciones y productos punto de manera eficiente.

Sin embargo, existe un punto importante: **no todos los microcontroladores Cortex-M tienen el mismo conjunto de instrucciones DSP**. Por ejemplo, no debe diseñarse una implementación suponiendo automáticamente que cualquier Cortex-M ejecutará `SMLAD`. La optimización debe hacerse considerando el núcleo concreto utilizado.

CMSIS proporciona implementaciones optimizadas para diferentes familias Cortex y permite que el desarrollador utilice una interfaz común en C sin escribir todas las operaciones directamente en ensamblador. [1], [8]

---

## Uso de CMSIS-DSP

Un ejemplo sencillo de multiplicación Q15 utilizando CMSIS-DSP sería:

```c
#include "arm_math.h"

q15_t entradaA[4] = {
    16384,   // 0.50
    24576,   // 0.75
    -16384,  // -0.50
    8192     // 0.25
};

q15_t entradaB[4] = {
    16384,   // 0.50
    16384,   // 0.50
    16384,   // 0.50
    16384    // 0.50
};

q15_t resultado[4];

arm_mult_q15(
    entradaA,
    entradaB,
    resultado,
    4
);
```

Los resultados representan aproximadamente:

```text
0.50 × 0.50  =  0.25
0.75 × 0.50  =  0.375
-0.50 × 0.50 = -0.25
0.25 × 0.50  =  0.125
```

La función `arm_mult_q15()` utiliza aritmética saturada para impedir que los resultados fuera del rango válido se conviertan accidentalmente en valores de signo contrario. [5]

CMSIS-DSP ofrece además funciones Q15 y Q31 para filtros, convoluciones, operaciones vectoriales, matrices, transformadas y funciones matemáticas.

---

## Q15 frente a Q31 en una aplicación DSP

### Conviene utilizar Q15 cuando:

- La precisión de 15 bits fraccionarios es suficiente.
- Se necesita disminuir el consumo de memoria.
- Se procesan grandes cantidades de muestras.
- El procesador dispone de instrucciones SIMD/DSP de 16 bits.
- Los datos originales provienen de sensores o convertidores con una resolución similar.
- Se busca aumentar el número de datos que caben en memoria o caché.

### Conviene utilizar Q31 cuando:

- Se necesita una precisión numérica considerablemente mayor.
- El error de cuantización de Q15 resulta significativo.
- Se dispone de suficiente memoria.
- Las operaciones internas de 64 bits no representan un problema importante de rendimiento.
- El algoritmo requiere conservar pequeños cambios en amplitud o coeficientes.

Una mala decisión sería utilizar Q31 únicamente porque “tiene más bits”. En procesamiento de señales debe analizarse también el tamaño del acumulador, los márgenes de desbordamiento y el costo computacional.

---

## Punto fijo frente a punto flotante

La aritmética de punto fijo presenta ventajas importantes:

- Representación compacta.
- Control explícito sobre la precisión.
- Operaciones enteras eficientes.
- Comportamiento numérico predecible.
- Aprovechamiento de instrucciones DSP/SIMD.
- Reducción del uso de memoria con Q15.

Sin embargo, también presenta desventajas:

- El programador debe administrar manualmente el escalado.
- Existe riesgo de desbordamiento.
- Se debe controlar la saturación.
- La multiplicación cambia temporalmente el formato.
- Los algoritmos complejos requieren estudiar el rango de cada etapa.
- Puede introducirse error de cuantización.

Por otro lado, el punto flotante administra automáticamente un intervalo de exponentes mucho mayor y facilita la programación.

Por ello tampoco es correcto afirmar que punto fijo siempre será más rápido que `float`. En microcontroladores ARM que incorporan una FPU eficiente, el procesamiento en punto flotante puede ser competitivo y reducir considerablemente la complejidad del código.

La elección correcta depende del núcleo ARM, frecuencia, FPU disponible, memoria, número de muestras, precisión requerida y algoritmo.

---

## Buenas prácticas para implementar DSP con Q15/Q31

Para desarrollar correctamente un algoritmo de punto fijo se recomienda:

1. Determinar primero el rango máximo y mínimo de las señales.
2. Definir claramente el formato Q utilizado en cada variable.
3. Reservar margen o *headroom* antes de acumulaciones grandes.
4. Utilizar registros más amplios para los productos intermedios.
5. Reescalar correctamente después de las multiplicaciones.
6. Utilizar saturación cuando corresponda.
7. Considerar el efecto del redondeo y la cuantización.
8. Probar casos límite como `-1 × -1`.
9. Comparar los resultados con una implementación de referencia en `float`.
10. Verificar los peores casos de acumulación de filtros y convoluciones.
11. Utilizar CMSIS-DSP antes de implementar manualmente una rutina crítica.
12. Revisar qué instrucciones DSP están disponibles en el Cortex-M específico utilizado.

En filtros de muchos coeficientes, una prueba con señales pequeñas no garantiza que el sistema sea seguro. Es indispensable comprobar señales cercanas a escala completa y combinaciones de coeficientes que produzcan el máximo valor posible del acumulador.

---

## Conclusiones

La aritmética de punto fijo Q15 y Q31 continúa siendo una herramienta importante para desarrollar aplicaciones DSP en microcontroladores ARM. Su principal característica consiste en almacenar valores fraccionarios mediante números enteros con una escala binaria conocida, evitando la necesidad de representar directamente un exponente como ocurre en punto flotante.

Q15 utiliza 16 bits y proporciona una alternativa eficiente en memoria, además de permitir aprovechar instrucciones ARM capaces de trabajar con dos operandos de 16 bits simultáneamente. Q31 utiliza 32 bits y ofrece una precisión considerablemente mayor, aunque aumenta el consumo de memoria y normalmente requiere productos intermedios y acumuladores de 64 bits.

El aspecto más importante de trabajar con punto fijo no es simplemente realizar multiplicaciones y desplazamientos, sino controlar correctamente el **escalado, la saturación, el redondeo, la cuantización y los desbordamientos de los acumuladores**.

El análisis de las implementaciones de CMSIS-DSP demuestra además que mayor precisión no significa automáticamente mayor seguridad. Por ejemplo, determinados algoritmos Q31 disponen de poco margen de guarda durante la acumulación y requieren escalar las señales previamente para evitar desbordamientos.

Por lo tanto, la selección entre Q15, Q31 y punto flotante debe realizarse con base en los requisitos reales del sistema y en las características específicas del microcontrolador ARM. Una implementación correcta debe comprobarse con datos límite y compararse con una referencia de mayor precisión antes de utilizarse en una aplicación real.

---

## Bibliografía

[1] Arm Ltd., “CMSIS-DSP: Overview,” *CMSIS-DSP Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.

[2] Arm Ltd., “Generic Types: q15_t and q31_t,” *CMSIS-DSP Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.

[3] Arm Ltd., “Convert 16-bit fixed point value,” *CMSIS-DSP Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.

[4] Arm Ltd., “Convert 32-bit fixed point value,” *CMSIS-DSP Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.

[5] Arm Ltd., “Vector Multiplication,” *CMSIS-DSP Documentation*, ver. 1.16.2. [En línea]. Consultado: 5-sep-2026.

[6] Arm Ltd., “Finite Impulse Response (FIR) Filters,” *CMSIS-DSP Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.

[7] Arm Ltd., “Convert 32-bit floating point value,” *CMSIS-DSP Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.

[8] Arm Ltd., “Intrinsic Functions for SIMD Instructions,” *CMSIS-Core Documentation*, 2026. [En línea]. Consultado: 5-sep-2026.
