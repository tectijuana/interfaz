# Arreglos multidimensionales: Cálculo de índices y recorrido en ensamblador

## Introducción

Cuando se programa en lenguajes de alto nivel como C, Java o Python, acceder a un elemento de una matriz mediante una notación como `matriz[i][j]` parece una operación trivial. Sin embargo, la memoria RAM es un espacio lineal de direcciones consecutivas: no existe el concepto de "fila" o "columna" a nivel de hardware. Por lo tanto, cada vez que se accede a un arreglo multidimensional, el compilador (o, en ausencia de él, el propio programador) debe traducir los índices lógicos a una única dirección de memoria. Comprender este proceso es fundamental para programar en ensamblador y para escribir código de alto nivel más eficiente.

## Desarrollo Técnico

El manejo de arreglos multidimensionales en lenguaje ensamblador requiere calcular explícitamente la dirección de cada elemento a partir de sus índices, así como construir manualmente la lógica de recorrido mediante bucles basados en comparaciones y saltos condicionales. Los ejemplos siguientes usan la arquitectura **AArch64 (ARM64)**, con registros de 32 bits (`w0`-`w3`) para datos y registros de 64 bits (`x0`-`x3`) para direcciones e índices.

### 1. Representación en memoria: row-major y column-major

Existen dos convenciones para almacenar un arreglo multidimensional en memoria lineal. En **row-major** (orden por filas), los elementos de una misma fila se almacenan de forma contigua; es el esquema utilizado por C, C++ y Java. En **column-major** (orden por columnas), son los elementos de una misma columna los que quedan contiguos; es el esquema de Fortran y MATLAB. Esta elección no es un detalle menor: determina tanto la fórmula para calcular direcciones como el orden de recorrido más eficiente, ya que el acceso secuencial a memoria aprovecha mejor la caché del procesador gracias a la localidad espacial de referencia.

### 2. Cálculo de índices: de coordenadas a dirección lineal

Para un arreglo bidimensional `A` de `F` filas por `C` columnas almacenado en row-major, la posición lineal (offset, en elementos) de `A[i][j]` es:

```
offset(i, j) = i × C + j
```

La dirección real se obtiene multiplicando el offset por el tamaño en bytes del elemento (`tam`) y sumándolo a la dirección base:

```
dirección = base + (i × C + j) × tam
```

Por ejemplo, en una matriz de enteros de 4 bytes con 4 columnas, base `0x1000`, el elemento `A[2][1]` está en `0x1000 + (2×4 + 1)×4 = 0x1024`. Esta fórmula se generaliza a n dimensiones multiplicando cada índice por el producto de las dimensiones que le siguen; es exactamente el cálculo que realiza un compilador de forma automática al traducir `matriz[i][j][k]`.

### 3. Modos de direccionamiento en ARM64 para arreglos

AArch64 ofrece, a nivel de hardware, el modo de **direccionamiento con registro-offset escalado**, pensado específicamente para el acceso a arreglos. Su forma general con la instrucción `LDR`/`STR` es:

```
LDR  Wt, [Xn, Xm, LSL #escala]
```

Donde `Xn` es el registro base (dirección de inicio del arreglo), `Xm` es el registro índice (el offset ya calculado) y `LSL #escala` desplaza los bits de `Xm` para multiplicarlo por el tamaño del elemento (`#0` para bytes, `#1` para halfwords de 2 bytes, `#2` para words de 4 bytes, `#3` para doublewords de 8 bytes). Gracias a esto, el procesador calcula en una sola instrucción una dirección equivalente a `base + índice × tam`, sin necesitar una multiplicación aparte.

Acceso a un vector (caso base), con `x1 = i`, `x2` = base del vector:

```
// w0 = vector[i]   (vector de word, 4 bytes)
LDR   w0, [x2, x1, LSL #2]
```

Para un arreglo bidimensional `A[F][C]` de word, en row-major, acceder a `A[i][j]` requiere primero calcular el offset `i × C + j` y luego usar ese offset como índice escalado. Con `x1 = i`, `x2 = j`, `x3` = base, `C = 6`:

```
// w0 = A[i][j], con C = 6 columnas
// x1 = i, x2 = j, x3 = base de la matriz
MOV   x4, #6              // x4 = C (número de columnas)
MUL   x5, x1, x4          // x5 = i * C
ADD   x5, x5, x2          // x5 = i * C + j   (offset en elementos)
LDR   w0, [x3, x5, LSL #2]   // w0 = A[i][j]  (escala 4 = sizeof(word))
```

Cuando el número de columnas es potencia de dos (por ejemplo `C = 8`), la multiplicación puede sustituirse por un desplazamiento de bits (`LSL`), más eficiente que `MUL`:

```
// Igual que el ejemplo anterior, pero con C = 8 (potencia de 2)
LSL   x5, x1, #3          // x5 = i * 8   (equivalente a i * C, C=8)
ADD   x5, x5, x2          // x5 = i*8 + j
LDR   w0, [x3, x5, LSL #2]   // w0 = A[i][j]
```

### 4. Recorrido con bucles anidados

Al no existir una instrucción `for`, el recorrido de una matriz en ensamblador se construye combinando registros como contadores de fila y columna, la instrucción `CMP` para comparar contra el límite, y saltos condicionales (`B.GE`, `B`) que emulan el bucle. La estructura típica anida un ciclo externo (filas) y uno interno (columnas), y aprovecha que, en row-major, avanzar el puntero en 4 bytes en cada paso del ciclo interno recorre la fila completa de forma secuencial.

### 5. Ejemplo práctico: suma de los elementos de una matriz

El siguiente programa en AArch64 (sintaxis GNU) recorre una matriz de `F` filas por `C` columnas y acumula la suma de todos sus elementos en `w0`, avanzando el puntero de forma secuencial:

```
.data
matriz: .word 1,2,3,4, 5,6,7,8, 9,10,11,12   // 3x4, row-major

.text
.global _start
_start:
    MOV   w0, #0              // acumulador de la suma
    MOV   x1, #0              // i = 0 (índice de fila)
    ADRP  x2, matriz          // x2 = dirección base de la matriz
    ADD   x2, x2, :lo12:matriz

fila_loop:
    CMP   x1, #3               // F = 3 filas
    B.GE  fin_fila_loop

    MOV   x3, #0               // j = 0 (índice de columna)
col_loop:
    CMP   x3, #4                // C = 4 columnas
    B.GE  fin_col_loop

    LDR   w4, [x2]              // cargar matriz[i][j]
    ADD   w0, w0, w4            // acumular
    ADD   x2, x2, #4            // avanzar el puntero al siguiente word
    ADD   x3, x3, #1            // j++
    B     col_loop

fin_col_loop:
    ADD   x1, x1, #1            // i++
    B     fila_loop

fin_fila_loop:
    // w0 contiene la suma total de los elementos
```

## Conclusión

Desarrollar esta investigación permite ver lo que ocurre realmente detrás de una simple expresión como `matriz[i][j]`. Lo que en un lenguaje de alto nivel es una sola línea de código, en ensamblador se traduce en un cálculo explícito de direcciones y en una estructura de bucles construida manualmente con comparaciones y saltos.

Comprender la fórmula `offset = i×C + j`, el papel del modo de direccionamiento con registro-offset escalado del procesador, y el impacto del orden de recorrido sobre la localidad de la caché, ofrece una perspectiva mucho más profunda de cómo la computadora maneja las estructuras de datos. Esta base es esencial no solo para programar en ensamblador, sino también para escribir código de alto nivel más consciente del rendimiento real del hardware.

## Bibliografía

[1] Wikipedia contributors, "Row- and column-major order," *Wikipedia*. [En línea]. Disponible en: <https://en.wikipedia.org/wiki/Row-_and_column-major_order>. [Accedido: 14-sep-2026].

[2] Arm Limited, "Addressing modes — Arm A-profile A64 Instruction Set Architecture," *developer.arm.com*. [En línea]. Disponible en: <https://developer.arm.com/documentation/ddi0602/latest>. [Accedido: 15-sep-2026].

[3] R. Ferrer, "Exploring AArch64 assembler – Chapter 5 (Load and store instructions)," *Think In Geek*, 2016. [En línea]. Disponible en: <https://thinkingeek.com/2016/11/13/exploring-aarch64-assembler-chapter-5/>. [Accedido: 15-sep-2026].

[4] GeeksforGeeks, "Row Major Order and Column Major Order," *GeeksforGeeks*. [En línea]. Disponible en: <https://www.geeksforgeeks.org/dsa/row-major-order-and-column-major-order/>. [Accedido: 14-sep-2026].

[5] MathWorks, "Row-Major and Column-Major Array Layouts," *MATLAB & Simulink Documentation*. [En línea]. Disponible en: <https://www.mathworks.com/help/coder/ug/what-are-column-major-and-row-major-representation-1.html>. [Accedido: 14-sep-2026].
