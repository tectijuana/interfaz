# Recursión en ensamblador: factorial y Fibonacci con manejo explícito de pila

## Introducción

La recursión es una técnica de programación en la que una función se llama a sí misma para resolver un problema mediante una reducción progresiva de la entrada hasta alcanzar uno o más casos base. En lenguajes de alto nivel, gran parte de la administración asociada a una llamada de función es realizada por el compilador y el entorno de ejecución. En ensamblador, en cambio, es necesario comprender cómo se utilizan los registros, la dirección de retorno y la pila de ejecución.

Este tema es especialmente útil en AArch64 porque permite observar de forma directa qué información debe conservarse entre llamadas recursivas. La convención de llamadas AAPCS64 establece, entre otras reglas, el uso de `x0`–`x7` para argumentos y resultados, `x29` como *Frame Pointer* (FP), `x30` como *Link Register* (LR) y `SP` como *Stack Pointer*. También establece restricciones de alineación y preservación de registros que deben respetarse para que una función pueda interoperar correctamente con otras rutinas [1].

Dos ejemplos clásicos para estudiar este comportamiento son el factorial y la sucesión de Fibonacci. El factorial realiza una sola llamada recursiva por nivel, mientras que la implementación recursiva ingenua de Fibonacci realiza dos. Por esa razón, Fibonacci permite observar con mayor claridad la necesidad de conservar valores intermedios mientras se ejecuta otra llamada recursiva.

El objetivo de esta investigación es explicar cómo implementar ambos algoritmos en ensamblador AArch64, mostrando el manejo explícito de la pila, la conservación de los datos necesarios para continuar después de una llamada y la relación de estas decisiones con la convención AAPCS64. Los ejemplos se presentan con sintaxis de GNU assembler (GAS) y utilizan registros de 64 bits.

---

## Desarrollo técnico

### 1. La pila y las llamadas recursivas en AArch64

La pila (*stack*) es una región de memoria utilizada para almacenar información temporal durante la ejecución de las funciones. Su comportamiento es LIFO (*Last In, First Out*): el último elemento colocado es el primero que puede recuperarse.

En AArch64 no existen instrucciones generales llamadas `PUSH` y `POP`. La arquitectura proporciona instrucciones de carga y almacenamiento por pares, `LDP` (*Load Pair*) y `STP` (*Store Pair*), que pueden utilizarse para construir operaciones equivalentes sobre la pila [2]. Un patrón habitual para conservar el *Frame Pointer* y el *Link Register* es:

```asm
stp x29, x30, [sp, #-16]!
mov x29, sp

...

ldp x29, x30, [sp], #16
ret
```

La instrucción `BL` (*Branch with Link*) realiza una llamada y guarda la dirección de retorno en `x30`. Por ello, una función que realiza otra llamada mediante `BL` debe conservar el valor anterior de `x30` antes de hacerlo. `RET` utiliza el registro de retorno para regresar al llamador [2].

La AAPCS64 identifica `x29` como `FP`, `x30` como `LR`, `x19`–`x28` como registros preservados por la función llamada (*callee-saved*) y `x0`–`x7` como registros de argumentos y resultados [1]. En una rutina recursiva, esta información es fundamental porque una nueva llamada puede modificar los registros de uso temporal. Los valores que todavía son necesarios después de la llamada deben guardarse en un lugar que permanezca disponible, como la propia pila o un registro que la convención obligue a preservar.

El *Stack Pointer* también tiene una restricción de alineación. AAPCS64 exige que la pila permanezca alineada a 16 bytes en los puntos establecidos por la convención [1]. Por ello, en los ejemplos de este trabajo se reservan 32 bytes por marco, una cantidad que conserva la alineación mientras permite guardar tanto el contexto de la función como los valores específicos del algoritmo.

---

### 2. Factorial recursivo

El factorial de un entero no negativo `n` se define como:

```text
n! = n × (n - 1)!
```

con el caso base:

```text
0! = 1
1! = 1
```

Por ejemplo:

```text
5! = 5 × 4 × 3 × 2 × 1
5! = 120
```

La versión recursiva tiene una sola llamada por nivel. En pseudocódigo:

```text
factorial(n):
    si n <= 1:
        devolver 1
    devolver n × factorial(n - 1)
```

En AArch64, `x0` se utiliza como argumento de entrada y también como registro de retorno. Como la llamada recursiva modifica `x0`, el valor original de `n` debe guardarse antes de ejecutar `BL`.

Una implementación compatible con AArch64 y respetuosa de la alineación de pila es:

```asm
.global factorial
.type factorial, %function

factorial:
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    str x0, [sp, #16]

    cmp x0, #1
    b.le .Lfactorial_base

    sub x0, x0, #1
    bl factorial

    ldr x1, [sp, #16]
    mul x0, x0, x1
    b .Lfactorial_done

.Lfactorial_base:
    mov x0, #1

.Lfactorial_done:
    ldp x29, x30, [sp], #32
    ret
```

El marco utiliza la siguiente distribución:

```text
Dirección relativa al SP del marco
+-----------------------+
| [sp, #0]  x29 guardado|
+-----------------------+
| [sp, #8]  x30 guardado|
+-----------------------+
| [sp, #16] n original  |
+-----------------------+
| [sp, #24] reservado   |
+-----------------------+
```

El procedimiento comienza guardando `x29` y `x30` y reservando 32 bytes. A continuación, guarda `n` en `[sp, #16]`. Si `n` es 0 o 1, retorna 1. En caso contrario, decrementa `x0` y realiza la llamada a `factorial`.

Cuando la llamada recursiva termina, `x0` contiene el resultado de `(n-1)!`. El valor original de `n` se recupera desde la pila en `x1`, y la instrucción `MUL` realiza la multiplicación:

```text
x0 = (n - 1)! × n
```

Finalmente se restaura `x29` y `x30`, se libera el marco de la función y se ejecuta `RET`.

La complejidad temporal de esta versión es `O(n)` porque existe una llamada recursiva por cada valor desde `n` hasta el caso base. La profundidad máxima de la pila también es `O(n)`.

---

### 3. Fibonacci recursivo

La sucesión de Fibonacci se define mediante:

```text
F(0) = 0
F(1) = 1
F(n) = F(n - 1) + F(n - 2)
```

Los primeros términos son:

```text
0, 1, 1, 2, 3, 5, 8, 13, 21, 34...
```

La versión recursiva ingenua puede expresarse como:

```text
fibonacci(n):
    si n == 0:
        devolver 0
    si n == 1:
        devolver 1

    a = fibonacci(n - 1)
    b = fibonacci(n - 2)

    devolver a + b
```

A diferencia del factorial, aquí la función debe conservar el resultado de `F(n-1)` mientras calcula `F(n-2)`. Además, debe conservar el valor original de `n`, porque después de la primera llamada `x0` contiene el resultado y ya no contiene el argumento inicial.

Una implementación en AArch64 es:

```asm
.global fibonacci
.type fibonacci, %function

fibonacci:
    stp x29, x30, [sp, #-32]!
    mov x29, sp

    str x0, [sp, #16]

    cmp x0, #0
    b.eq .Lfibonacci_zero

    cmp x0, #1
    b.eq .Lfibonacci_one

    sub x0, x0, #1
    bl fibonacci

    str x0, [sp, #24]

    ldr x0, [sp, #16]
    sub x0, x0, #2
    bl fibonacci

    ldr x1, [sp, #24]
    add x0, x0, x1
    b .Lfibonacci_done

.Lfibonacci_zero:
    mov x0, #0
    b .Lfibonacci_done

.Lfibonacci_one:
    mov x0, #1

.Lfibonacci_done:
    ldp x29, x30, [sp], #32
    ret
```

En este caso el marco se utiliza de la siguiente manera:

```text
Dirección relativa al SP del marco
+----------------------------+
| [sp, #0]  x29 guardado     |
+----------------------------+
| [sp, #8]  x30 guardado     |
+----------------------------+
| [sp, #16] n original       |
+----------------------------+
| [sp, #24] F(n - 1) guardado|
+----------------------------+
```

El flujo de la función puede explicarse en siete pasos:

1. Se crea el marco y se guardan `x29` y `x30`.
2. Se almacena el valor original de `n`.
3. Se comprueban los casos base `n = 0` y `n = 1`.
4. Se calcula `F(n-1)`.
5. El resultado obtenido se guarda en `[sp, #24]`.
6. Se recupera el `n` original, se calcula `n-2` y se ejecuta `F(n-2)`.
7. Se recupera `F(n-1)`, se suman ambos resultados y se retorna el valor en `x0`.

La conservación de `F(n-1)` es la parte central del manejo de la pila en este ejemplo. Si ese valor se dejara únicamente en un registro temporal que pudiera ser modificado por la segunda llamada, el resultado se perdería.

La cantidad total de llamadas de la implementación recursiva ingenua crece exponencialmente. Su recurrencia temporal puede expresarse aproximadamente como:

```text
T(n) = T(n - 1) + T(n - 2) + O(1)
```

Por simplicidad suele describirse como `O(2^n)`, aunque una caracterización más ajustada está relacionada con el crecimiento de la sucesión de Fibonacci. En contraste, el factorial solo genera una llamada por nivel y mantiene un crecimiento lineal [3].

Es importante diferenciar tiempo de ejecución y profundidad de pila. Aunque Fibonacci realiza una cantidad exponencial de llamadas en total, la profundidad máxima de llamadas activas sigue siendo `O(n)`. Por ello, el consumo simultáneo de pila no crece de forma exponencial.

---

### 4. Manejo explícito de la pila

La comparación de ambos algoritmos permite observar tres responsabilidades importantes de una función recursiva en AArch64:

**Conservar la dirección de retorno.**  
`BL` coloca la dirección de retorno en `x30`. Antes de efectuar otra llamada, la función conserva ese valor en el marco de pila para poder recuperarlo posteriormente [1], [2].

**Conservar argumentos o valores temporales.**  
`x0` se utiliza para recibir el argumento y devolver el resultado. Por lo tanto, una llamada recursiva reemplaza su contenido. Si el llamador todavía necesita el valor original, debe guardarlo antes de realizar `BL`.

**Mantener la estructura del marco.**  
El uso de `x29` como *Frame Pointer* permite identificar de manera estable el marco de la función durante la ejecución. Aunque una función sencilla puede utilizar la pila sin un *Frame Pointer*, en un ejercicio sobre recursión su uso facilita observar qué información pertenece a cada nivel de llamada [1].

Para `factorial(4)`, conceptualmente se genera una cadena de llamadas:

```text
factorial(4)
    |
    +-- factorial(3)
            |
            +-- factorial(2)
                    |
                    +-- factorial(1)
                            |
                            +-- retorna 1
                    retorna 2
            retorna 6
    retorna 24
```

Cada nivel conserva su propio `n` en su marco. Al regresar la llamada más profunda, cada nivel recupera su dato y termina la operación pendiente.

En Fibonacci la estructura es más amplia:

```text
F(4)
├── F(3)
│   ├── F(2)
│   │   ├── F(1)
│   │   └── F(0)
│   └── F(1)
└── F(2)
    ├── F(1)
    └── F(0)
```

En este caso, un nivel que ya obtuvo `F(n-1)` debe conservar ese resultado mientras se ejecuta la rama `F(n-2)`. La pila funciona como almacenamiento temporal asociado a cada activación de la función.

Un error en estas operaciones puede producir resultados incorrectos, pérdida de la dirección de retorno, corrupción de datos o un crecimiento excesivo del consumo de pila. En aplicaciones reales, una profundidad recursiva demasiado grande puede terminar provocando un *stack overflow*.

---

### 5. Limitaciones de los ejemplos

Los programas mostrados trabajan con valores enteros de 64 bits y realizan las operaciones sobre `x0` y otros registros de 64 bits. Por ello, el resultado matemático puede dejar de representarse en 64 bits cuando `n` es suficientemente grande.

En particular:

- `20!` todavía cabe en un entero sin signo de 64 bits, mientras que `21!` ya no.
- En Fibonacci, `F(93)` cabe en un entero sin signo de 64 bits, pero `F(94)` supera el máximo representable.

Los ejemplos no implementan comprobación explícita de desbordamiento. Su objetivo es estudiar la recursión, las llamadas de función y el manejo de la pila, no desarrollar una biblioteca completa de enteros multiprecisión.

Otra limitación es que la versión recursiva ingenua de Fibonacci repite muchos cálculos. Para aplicaciones reales, una versión iterativa o una versión con memoización reduce de manera considerable el trabajo necesario.

---

## Conclusiones

La implementación de recursión en AArch64 permite observar directamente aspectos que normalmente quedan ocultos en lenguajes de alto nivel. El factorial muestra un caso sencillo en el que cada activación necesita conservar el argumento pendiente mientras espera el retorno de una única llamada recursiva. Fibonacci añade la necesidad de conservar tanto el argumento original como un resultado intermedio durante una segunda llamada.

El manejo explícito de la pila es fundamental para preservar la información de cada activación. En AArch64, la ausencia de `PUSH` y `POP` generales se resuelve utilizando instrucciones como `STP` y `LDP`, mientras que `x29`, `x30` y `SP` permiten estructurar el marco de la función de acuerdo con las reglas de la AAPCS64 [1], [2].

La comparación también muestra que la recursión no implica por sí misma un costo exponencial de memoria. En el caso de Fibonacci, el número total de llamadas crece exponencialmente, pero la profundidad máxima de la pila permanece lineal respecto a `n`. El factorial presenta tanto tiempo como profundidad de pila `O(n)`.

Finalmente, este ejercicio demuestra por qué una implementación en ensamblador debe analizarse no solo desde el punto de vista del algoritmo, sino también desde el punto de vista de la arquitectura y la convención de llamadas. Una rutina recursiva correcta debe conservar exactamente la información que necesitará después de cada llamada y restaurar el estado requerido antes de retornar.

---

## Bibliografía

[1] Arm Limited, *Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64)*, release 2025Q4, Jan. 23, 2026. [Online]. Disponible: https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst

[2] Arm Limited, *Armv8-A Instruction Set Architecture*, Learn the Architecture, Issue 1.1. [Online]. Disponible: https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20Instruction%20Set%20Architecture.pdf

[3] T. H. Cormen, C. E. Leiserson, R. L. Rivest, and C. Stein, *Introduction to Algorithms*, 4th ed. Cambridge, MA, USA: MIT Press, 2022.

[4] D. E. Knuth, *The Art of Computer Programming, Vol. 1: Fundamental Algorithms*, 3rd ed. Reading, MA, USA: Addison-Wesley, 1997.

[5] Arm Limited, *Arm Architecture Reference Manual for A-profile architecture*. [Online]. Disponible: https://developer.arm.com/documentation/ddi0487/latest
