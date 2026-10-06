# Funciones hash sencillas (djb2, FNV-1a) implementadas en ASM

## Introducción

Las funciones hash son algoritmos que reciben una entrada, como una cadena de caracteres o un conjunto de bytes, y producen como resultado un valor numérico de tamaño fijo. Su objetivo principal es transformar los datos de entrada de una manera rápida y determinista, de modo que una misma entrada produzca siempre el mismo hash. Estas funciones son utilizadas en estructuras de datos, tablas hash, sistemas de búsqueda, comprobación de integridad y diferentes aplicaciones de software.

Una función hash no garantiza que dos entradas diferentes produzcan valores diferentes. Cuando dos entradas producen el mismo resultado se presenta una **colisión**. Por esta razón, las funciones hash sencillas deben analizarse de acuerdo con su distribución, velocidad y el contexto donde serán utilizadas. Algoritmos como djb2 y FNV-1a son utilizados principalmente como funciones hash no criptográficas y no deben confundirse con algoritmos diseñados para proteger contraseñas o información sensible. En particular, djb2 no es considerado un algoritmo criptográficamente seguro. [1]

En esta investigación se estudian dos funciones hash sencillas: **djb2** y **FNV-1a**, enfocándose en su funcionamiento y en la manera en que pueden implementarse mediante lenguaje ensamblador ARM. La implementación permite observar cómo operaciones que normalmente se escriben en un lenguaje de alto nivel pueden convertirse en instrucciones de bajo nivel que trabajan directamente con registros, memoria y operaciones aritméticas y lógicas.

Para la parte de ensamblador se utiliza como referencia el conjunto de instrucciones Thumb de un procesador ARM Cortex-M3. ARM documenta instrucciones como `LDRB`, `LSL`, `ADD`, `EOR` y `MUL`, que permiten realizar las operaciones necesarias para ambas funciones. [2]

---

## 1. ¿Qué es una función hash?

Una función hash puede representarse conceptualmente de la siguiente manera:

```text
Entrada de bytes
       |
       v
+----------------+
| Función hash   |
+----------------+
       |
       v
Valor de tamaño fijo
```

Por ejemplo, una cadena como:

```text
"hola"
```

se procesa byte por byte. En cada iteración se actualiza un valor interno denominado normalmente `hash`.

Una característica importante es que el resultado depende de toda la entrada. Si cambia un carácter, aunque sea solamente uno, el valor final normalmente también cambia.

Sin embargo, una función hash no es una función de cifrado. El objetivo no es recuperar el mensaje original a partir del resultado, sino generar una representación numérica que pueda utilizarse para diferentes operaciones.

También es importante considerar que existen colisiones. Una colisión ocurre cuando:

```text
entrada A != entrada B

pero

hash(A) == hash(B)
```

Por esta razón, un hash sencillo no debe utilizarse como sustituto de mecanismos criptográficos cuando se necesita seguridad.

---

# 2. Algoritmo djb2

djb2 es una función hash para cadenas asociada con Daniel J. Bernstein. Una de sus implementaciones tradicionales utiliza un valor inicial de `5381` y procesa cada byte mediante la operación:

```text
hash = hash * 33 + byte
```

La expresión puede escribirse de una forma conveniente para una implementación de bajo nivel:

```text
hash = (hash << 5) + hash + byte
```

Esto ocurre porque:

```text
hash << 5 = hash * 32

hash * 32 + hash = hash * 33
```

Por lo tanto, una multiplicación por 33 puede construirse utilizando un desplazamiento y una suma. La implementación clásica de djb2 utiliza precisamente esta transformación. [1]

### 2.1 Funcionamiento

El algoritmo puede resumirse así:

```text
hash = 5381

para cada byte:
    hash = hash * 33 + byte

regresar hash
```

Si se utiliza un valor de 32 bits, las operaciones se mantienen dentro de ese tamaño. En la implementación sobre un registro ARM de 32 bits, el resultado queda naturalmente limitado a 32 bits.

### 2.2 Ejemplo conceptual

Supongamos que se tiene:

```text
"AB"
```

Los bytes correspondientes a los caracteres son procesados individualmente.

Primero:

```text
hash = 5381
```

Después se procesa `A`:

```text
hash = 5381 * 33 + 'A'
```

Posteriormente se procesa `B`:

```text
hash = hash_anterior * 33 + 'B'
```

El resultado final representa el hash de la entrada.

La implementación clásica publicada para djb2 utiliza precisamente el valor inicial `5381` y la operación `((hash << 5) + hash) + c`. [1]

---

# 3. Algoritmo FNV-1a

FNV significa **Fowler-Noll-Vo**. FNV-1a es una variante de la familia FNV diseñada para producir valores hash de diferentes tamaños.

Para FNV de 32 bits se utilizan dos constantes principales:

```text
Offset basis = 2166136261
FNV prime    = 16777619
```

La documentación de FNV especifica que la multiplicación se realiza módulo `2^n`, donde `n` corresponde al tamaño del hash. Para 32 bits, esto significa que el resultado se mantiene dentro de un entero sin signo de 32 bits. [3]

La característica principal que diferencia FNV-1a de FNV-1 es el orden de las operaciones. En FNV-1a primero se realiza un XOR entre el hash y el byte de entrada y posteriormente se realiza la multiplicación:

```text
hash = hash XOR byte
hash = hash * FNV_prime
```

Por lo tanto:

```text
hash = (hash XOR byte) * 16777619
```

### 3.1 Funcionamiento

El algoritmo FNV-1a de 32 bits puede resumirse como:

```text
hash = 2166136261

para cada byte:
    hash = hash XOR byte
    hash = hash * 16777619

regresar hash
```

La especificación de FNV recomienda utilizar FNV-1a frente a FNV-1 cuando sea posible. [3]

---

# 4. Comparación entre djb2 y FNV-1a

| Característica             | djb2                               | FNV-1a                                                |
| -------------------------- | ---------------------------------- | ----------------------------------------------------- |
| Tipo                       | Hash no criptográfico              | Hash no criptográfico                                 |
| Tamaño utilizado           | 32 bits                            | 32 bits                                               |
| Valor inicial              | 5381                               | 2166136261                                            |
| Operación principal        | Multiplicación por 33 y suma       | XOR y multiplicación                                  |
| Constante principal        | 33                                 | 16777619                                              |
| Procesamiento              | Byte por byte                      | Byte por byte                                         |
| Operaciones ARM relevantes | LSL, ADD                           | EOR, MUL                                              |
| Uso típico                 | Tablas hash y estructuras de datos | Tablas hash, identificadores y procesamiento de datos |
| Seguridad criptográfica    | No                                 | No                                                    |

La diferencia más importante desde el punto de vista de la implementación ARM es que djb2 puede aprovechar un desplazamiento de bits para calcular `hash * 33`, mientras que FNV-1a necesita una operación XOR y una multiplicación por una constante.

---

# 5. Implementación en lenguaje ensamblador ARM

Para demostrar la implementación se utiliza sintaxis GNU Assembly para ARM Thumb y se toma como referencia un Cortex-M3.

La sintaxis unificada de GNU Assembler puede seleccionarse mediante:

```asm
.syntax unified
```

y el modo Thumb mediante:

```asm
.thumb
```

GNU Assembler permite seleccionar el procesador mediante `.cpu` y el conjunto Thumb mediante `.thumb`. [4]

## 5.1 Implementación de djb2

Una implementación sencilla puede recibir en `r0` la dirección de una cadena terminada en cero y regresar el hash de 32 bits en `r0`.

```asm
.syntax unified
.cpu cortex-m3
.thumb

.global djb2
.type djb2, %function

djb2:
    push {r4, lr}

    mov r1, r0
    ldr r2, =5381

djb2_loop:
    ldrb r3, [r1]
    adds r1, r1, #1

    cmp r3, #0
    beq djb2_done

    lsls r4, r2, #5
    adds r2, r2, r4
    adds r2, r2, r3

    b djb2_loop

djb2_done:
    mov r0, r2

    pop {r4, pc}
```

La parte fundamental se encuentra en:

```asm
lsls r4, r2, #5
adds r2, r2, r4
adds r2, r2, r3
```

Estas instrucciones equivalen conceptualmente a:

```text
r4 = hash << 5
hash = hash + r4
hash = hash + byte
```

Por lo tanto:

```text
hash = hash * 32 + hash + byte
```

y finalmente:

```text
hash = hash * 33 + byte
```

Esta transformación permite implementar djb2 sin utilizar una instrucción de multiplicación para el factor 33.

---

# 6. Implementación de FNV-1a

Para FNV-1a se utiliza el valor inicial:

```text
2166136261
```

y la constante:

```text
16777619
```

La implementación ARM puede escribirse de la siguiente manera:

```asm
.syntax unified
.cpu cortex-m3
.thumb

.global fnv1a
.type fnv1a, %function

fnv1a:
    push {r4, lr}

    mov r1, r0
    ldr r2, =2166136261
    ldr r4, =16777619

fnv1a_loop:
    ldrb r3, [r1]
    adds r1, r1, #1

    cmp r3, #0
    beq fnv1a_done

    eors r2, r2, r3
    muls r2, r2, r4

    b fnv1a_loop

fnv1a_done:
    mov r0, r2

    pop {r4, pc}
```

Las instrucciones importantes son:

```asm
eors r2, r2, r3
muls r2, r2, r4
```

La primera realiza:

```text
hash = hash XOR byte
```

y la segunda:

```text
hash = hash * 16777619
```

De esta manera se reproduce el procedimiento de FNV-1a directamente sobre registros de 32 bits.

La documentación de ARM identifica `EOR`, `MUL` y `LDRB` entre las instrucciones disponibles para Cortex-M3. [2]

---

# 7. Relación entre el algoritmo y el ensamblador

Una de las ventajas de implementar estas funciones en ASM es que permite observar directamente cómo una expresión de alto nivel se convierte en operaciones sobre registros.

Por ejemplo, en djb2:

```text
hash = ((hash << 5) + hash) + byte
```

se transforma en:

```asm
lsls r4, r2, #5
adds r2, r2, r4
adds r2, r2, r3
```

Mientras que en FNV-1a:

```text
hash = hash XOR byte
hash = hash * 16777619
```

se transforma en:

```asm
eors r2, r2, r3
muls r2, r2, r4
```

Esto permite relacionar directamente los conceptos de programación de alto nivel con la arquitectura del procesador.

Además, `LDRB` permite cargar un byte desde memoria, lo cual resulta apropiado porque las cadenas están compuestas por bytes. Los registros generales de Cortex-M son de 32 bits, por lo que el valor hash puede mantenerse directamente en uno de estos registros. [2]

---

# 8. Ventajas y limitaciones

## djb2

Entre las ventajas de djb2 se encuentra su sencillez. La operación principal utiliza una constante pequeña, 33, que puede calcularse mediante desplazamiento y suma. Esto facilita su implementación en ensamblador.

Sin embargo, djb2 no es una función criptográfica y puede producir colisiones. Su utilidad se encuentra principalmente en aplicaciones donde se requiere una función rápida y sencilla para distribuir datos.

## FNV-1a

FNV-1a también presenta una implementación sencilla. Su procedimiento utiliza únicamente una operación XOR y una multiplicación después de procesar cada byte. La especificación oficial de FNV define constantes para diferentes tamaños de hash y establece el comportamiento modular de las operaciones. [3]

Su principal limitación es que tampoco está diseñado para seguridad criptográfica. Por lo tanto, no debe utilizarse para almacenar contraseñas ni como mecanismo de protección de información sensible.

---

# 9. Aplicaciones

Las funciones hash no criptográficas pueden utilizarse en diferentes situaciones donde se necesita convertir datos en valores numéricos de manera rápida.

Algunos ejemplos son:

* Tablas hash.
* Estructuras de datos.
* Búsqueda rápida.
* Identificación de cadenas.
* Distribución de elementos en estructuras hash.
* Procesamiento de datos en sistemas embebidos.
* Comparación preliminar de datos.

En sistemas embebidos, una implementación en ensamblador también puede utilizarse como ejercicio para estudiar el acceso a memoria, registros, desplazamientos, operaciones lógicas y multiplicaciones.

---

# 10. Importancia de la implementación en ASM

Implementar djb2 y FNV-1a en ensamblador permite comprender que un algoritmo aparentemente sencillo está compuesto por varias operaciones elementales.

En ambos casos existe un ciclo que:

1. Obtiene un byte de memoria.
2. Comprueba si terminó la entrada.
3. Actualiza el valor del hash.
4. Avanza hacia el siguiente byte.
5. Repite el proceso.

La diferencia está en cómo se actualiza el registro que contiene el hash.

En djb2 se utilizan principalmente desplazamientos y sumas:

```text
desplazamiento + suma + suma
```

En FNV-1a se utilizan operaciones lógicas y aritméticas:

```text
XOR + multiplicación
```

Esta comparación demuestra cómo la elección de un algoritmo también determina qué instrucciones de procesador serán necesarias para implementarlo.

---

# Conclusiones

Las funciones djb2 y FNV-1a son ejemplos adecuados para estudiar la relación entre algoritmos de alto nivel y lenguaje ensamblador. Ambas procesan los datos byte por byte y producen un valor hash de tamaño fijo, pero utilizan operaciones diferentes para actualizar su estado interno.

djb2 utiliza el valor inicial `5381` y una multiplicación conceptual por 33, que puede implementarse eficientemente mediante un desplazamiento de cinco posiciones y sumas. Esta característica resulta especialmente interesante en ensamblador porque permite observar cómo una multiplicación puede expresarse mediante operaciones más simples.

FNV-1a utiliza el valor inicial `2166136261` y la constante `16777619` para su versión de 32 bits. Su procedimiento realiza primero un XOR con el byte actual y después una multiplicación. Esta diferencia permite estudiar directamente instrucciones ARM como `EOR` y `MUL`.

Finalmente, ambas funciones deben considerarse hashes no criptográficos. Su utilidad está relacionada con velocidad, simplicidad y distribución de datos, pero no con la protección de información sensible. La implementación en ARM permite comprender mejor el funcionamiento de registros, memoria e instrucciones y demuestra cómo un algoritmo puede traducirse a operaciones directamente ejecutables por el procesador.

---

# Bibliografía

[1] D. J. Bernstein, “Hash Functions,” University of York, disponible en: https://www.cse.yorku.ca/~oz/hash.html. [Accedido: 8-sep-2026].

[2] Arm Ltd., “Arm Cortex-M3 Processor Technical Reference / Instruction Set,” Arm Developer, disponible en: https://developer.arm.com/. [Accedido: 8-sep-2026].

[3] P. J. Weinberger, L. Peter Deutsch, and E. S. Noll, “FNV Hash,” disponible en: https://www.isthe.com/chongo/tech/comp/fnv/. [Accedido: 8-sep-2026].

[4] GNU Project, “Using as: GNU Assembler,” GNU Binutils Documentation, disponible en: https://sourceware.org/binutils/docs/as/. [Accedido: 8-sep-2026].

[5] Zephyr Project, “32-bit djb2 Hash Function,” Zephyr Project Documentation/Source Code, disponible en: https://github.com/zephyrproject-rtos/zephyr. [Accedido: 8-sep-2026].

