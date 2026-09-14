# Arreglos multidimensionales: Cálculo de índices y recorrido en ensamblador

## Introducción

Cuando se programa en lenguajes de alto nivel como C, Java o Python, acceder a un elemento de una matriz mediante una notación como `matriz[i][j]` parece una operación trivial. Sin embargo, la memoria RAM es un espacio lineal de direcciones consecutivas: no existe el concepto de "fila" o "columna" a nivel de hardware. Por lo tanto, cada vez que se accede a un arreglo multidimensional, el compilador (o, en ausencia de él, el propio programador) debe traducir los índices lógicos a una única dirección de memoria. Comprender este proceso es fundamental para programar en ensamblador y para escribir código de alto nivel más eficiente.

## Desarrollo Técnico

El manejo de arreglos multidimensionales en lenguaje ensamblador requiere calcular explícitamente la dirección de cada elemento a partir de sus índices, así como construir manualmente la lógica de recorrido mediante bucles basados en comparaciones y saltos condicionales.

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

### 3. Modos de direccionamiento en x86 para arreglos

Las arquitecturas x86 e x86-64 incluyen un modo de direccionamiento pensado específicamente para el acceso a arreglos, conocido como **base-índice-escala** (SIB, *Scale-Index-Base*). Su forma general en sintaxis NASM es:

```
[base + índice*escala + desplazamiento]
```

Donde `escala` solo puede valer 1, 2, 4 u 8 (el tamaño de byte, word, dword o qword). Gracias a este modo, el procesador calcula en una sola instrucción una dirección equivalente a `base + índice × tam`, sin necesitar una multiplicación explícita cuando el elemento mide 1, 2, 4 u 8 bytes:

```
; EAX = A[i][j], con C = 6 columnas
; EAX = i, EBX = j, ESI = base de la matriz
imul  edx, eax, 6        ; EDX = i * C
add   edx, ebx            ; EDX = i * C + j
mov   eax, [esi + edx*4]  ; EAX = A[i][j]
```

Cuando el número de columnas es potencia de dos, la multiplicación puede reemplazarse por un desplazamiento de bits (`shl`), más eficiente que `imul` en muchos procesadores.

### 4. Recorrido con bucles anidados

Al no existir una instrucción `for`, el recorrido de una matriz en ensamblador se construye combinando registros como contadores de fila y columna, la instrucción `cmp` para comparar contra el límite, y saltos condicionales (`jge`, `jmp`) que emulan el bucle. La estructura típica anida un ciclo externo (filas) y uno interno (columnas), y aprovecha que, en row-major, avanzar el puntero en 4 bytes en cada paso del ciclo interno recorre la fila completa de forma secuencial.

### 5. Ejemplo práctico: suma de los elementos de una matriz

El siguiente programa en NASM recorre una matriz de `F` filas por `C` columnas y acumula la suma de todos sus elementos en `EAX`, avanzando el puntero de forma secuencial:

```
section .data
    F       equ 3
    C       equ 4
    matriz  dd 1,2,3,4, 5,6,7,8, 9,10,11,12   ; 3x4, row-major

section .text
    global _start
_start:
    xor   eax, eax        ; acumulador de la suma
    xor   ecx, ecx        ; i = 0
    lea   esi, [matriz]   ; puntero al elemento actual

fila_loop:
    cmp   ecx, F
    jge   fin_fila_loop

    xor   edx, edx        ; j = 0
col_loop:
    cmp   edx, C
    jge   fin_col_loop

    add   eax, [esi]      ; acumular matriz[i][j]
    add   esi, 4          ; avanzar al siguiente dword
    inc   edx
    jmp   col_loop

fin_col_loop:
    inc   ecx
    jmp   fila_loop

fin_fila_loop:
    ; EAX contiene la suma total de los elementos
```

## Conclusión

Desarrollar esta investigación permite ver lo que ocurre realmente detrás de una simple expresión como `matriz[i][j]`. Lo que en un lenguaje de alto nivel es una sola línea de código, en ensamblador se traduce en un cálculo explícito de direcciones y en una estructura de bucles construida manualmente con comparaciones y saltos.

Comprender la fórmula `offset = i×C + j`, el papel del modo de direccionamiento base-índice-escala del procesador, y el impacto del orden de recorrido sobre la localidad de la caché, ofrece una perspectiva mucho más profunda de cómo la computadora maneja las estructuras de datos. Esta base es esencial no solo para programar en ensamblador, sino también para escribir código de alto nivel más consciente del rendimiento real del hardware.

## Bibliografía

[1] Wikipedia contributors, "Row- and column-major order," *Wikipedia*. [En línea]. Disponible en: <https://en.wikipedia.org/wiki/Row-_and_column-major_order>. [Accedido: 14-sep-2026].

[2] Oracle Corporation, "Addressing Modes — IA-32 Assembly Language Reference Manual," *docs.oracle.com*. [En línea]. Disponible en: <https://docs.oracle.com/cd/E19455-01/806-3773/assemblersyntax-21/index.html>. [Accedido: 14-sep-2026].

[3] E. Morris, "How x86_64 addresses memory," *ENOSUCHBLOG*, 2020. [En línea]. Disponible en: <https://blog.yossarian.net/2020/06/13/How-x86_64-addresses-memory>. [Accedido: 14-sep-2026].

[4] GeeksforGeeks, "Row Major Order and Column Major Order," *GeeksforGeeks*. [En línea]. Disponible en: <https://www.geeksforgeeks.org/dsa/row-major-order-and-column-major-order/>. [Accedido: 14-sep-2026].

[5] MathWorks, "Row-Major and Column-Major Array Layouts," *MATLAB & Simulink Documentation*. [En línea]. Disponible en: <https://www.mathworks.com/help/coder/ug/what-are-column-major-and-row-major-representation-1.html>. [Accedido: 14-sep-2026].
