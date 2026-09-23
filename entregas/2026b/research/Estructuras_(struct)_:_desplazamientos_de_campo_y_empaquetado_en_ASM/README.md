Estructuras (struct): desplazamientos de campo y empaquetado en ASM ARM64

Introduccion
En lenguaje ensamblador (ASM) para la arquitectura ARM64, las estructuras sirven para guardar varios tipos de datos relacionados dentro de una misma unidad de memoria. Esto es util cuando tenemos datos que tienen alguna relacion entre si, por ejemplo, los datos de un alumno como su id, edad y promedio. En lugar de tener todos los datos separados, podemos agruparlos dentro de una sola estructura en la memoria.
Las estructuras trabajan directamente con la memoria ram, por lo que es importante saber en que posicion se encuentra cada dato. Cada campo de una estructura tiene una posicion determinada dentro de ella. A esta posicion se le conoce como desplazamiento u offset. El desplazamiento indica cuantos bytes existen desde el inicio de la estructura hasta el comienzo de un campo determinado.
Tambien es importante conocer el empaquetado o la forma en que los datos se organizan dentro de la memoria. En ARM64 no existe una directiva STRUCT igual a la de otros ensambladores de alto nivel, por lo que el usuario define los espacios manualmente o el ensamblador ajusta los espacios. Dependiendo de las reglas de alineacion utilizadas por la arquitectura ARM64, pueden existir espacios entre algunos campos. Estos espacios reciben el nombre de relleno o padding.
Comprender los desplazamientos y el empaquetado permite conocer exactamente como se organizan los datos en memoria y facilita el acceso a los diferentes campos de una estructura usando las instrucciones del procesador ARM64.

Desarrollo
¿Que es una estructura en ASM ARM64?
Una estructura es un tipo de dato compuesto que permite agrupar varios campos dentro de una misma unidad de memoria contigua. Los campos pueden ser de diferentes tipos y tamaños.
En ARM64, cuando usamos herramientas como GNU Assembler (gas), declaramos las estructuras reservando espacio en la seccion .data con directivas de tamaño como .byte (1 byte), .hword (2 bytes), .word (4 bytes) y .xword (8 bytes).
Por ejemplo, podemos declarar la informacion de un Alumno en ARM64 de la siguiente manera:

    .data
    .align 3
alumno1:
    .word   1001
    .byte   20
    .skip   3
    .xword  95

En este ejemplo, la estructura contiene tres campos:
id, que ocupa un .word de 4 bytes.
edad, que ocupa un .byte de 1 byte.
promedio, que utiliza un .xword de 8 bytes.
Se utiliza .skip 3 para meter un relleno manual de 3 bytes para que el promedio quede bien alineado. El ensamblador GNU Assembler permite organizar estos campos directamente en la memoria del procesador [1].

Desplazamiento u offset
El desplazamiento (offset) representa la distancia, expresada en bytes, entre el comienzo de una estructura y el comienzo de uno de sus campos.
Por ejemplo, si tenemos una estructura sencilla en ARM64:

datos1:
    .byte   10
    .byte   15

Si no se introduce ningun espacio adicional entre los campos, el primer byte comenzaria en el desplazamiento 0 y el segundo byte comenzaria en el desplazamiento 1.
Esto significa que el desplazamiento permite localizar un campo dentro de la estructura sin tener que buscarlo desde el principio de la memoria.
En lenguaje ensamblador ARM64 esto es especialmente importante porque el programador trabaja directamente con registros de 64 bits (como x0 o x1), direcciones y posiciones de memoria. Conocer la posicion de cada campo permite acceder correctamente a la informacion almacenada usando sumas de desplazamientos [1].

Acceso a los campos de una estructura
A diferencia de otros lenguajes, en ARM64 no se accede a los campos escribiendo algo como alumno1.edad. En su lugar, el programador carga la direccion base de la estructura en un registro usando instrucciones como adrp y add, y luego accede a cada campo usando una instruccion de carga como LDR con un desplazamiento numerico.
Por ejemplo:

    // x0 tiene la direccion base de alumno1
    ldr w1, [x0, #0]
    ldrb w2, [x0, #4]
    ldr x3, [x0, #8]
    

En este codigo:
w1 recibe el id desde el desplazamiento 0 usando un registro de 32 bits.
w2 recibe la edad desde el desplazamiento 4 usando ldrb para leer solo un byte.
x3 recibe el promedio desde el desplazamiento 8 usando un registro x de 64 bits.
Es importante distinguir entre la direccion de memoria donde inicia la variable alumno1 y los desplazamientos (#0, #4, #8) que nos mueven hacia cada campo.

Empaquetado de datos
El empaquetado se refiere a la manera en que los diferentes campos de una estructura quedan organizados dentro de la memoria en la arquitectura ARM64.
Los datos en ARM64 tienen diferentes tamaños normalizados:
Un .byte ocupa 1 byte.
Un .hword ocupa 2 bytes.
Un .word ocupa 4 bytes.
Un .xword ocupa 8 bytes.
Cuando se colocan datos de diferentes tamaños dentro de una estructura, la posicion de cada campo depende de las reglas de organizacion del estandar AAPCS64 (Procedure Call Standard for the Arm 64-bit Architecture) [2].
Segun esta regla, un dato de 2 bytes debe ir en una direccion divisible entre 2, uno de 4 bytes en una direccion divisible entre 4, y uno de 8 bytes en una direccion divisible entre 8. Cuando un dato no queda en la direccion correcta, el ensamblador o el programador meten bytes que no contienen informacion util. Estos bytes se conocen como padding o relleno.
El relleno se utiliza para cumplir las condiciones de alineacion de ARM64 mediante directivas como .balign o .p2align [1]. Por esta razon, el tamaño total de una estructura no siempre es la simple suma de los tamaños de sus campos.

Ejemplo de desplazamientos
Consideremos la siguiente estructura conceptual en ARM64:

    .data
    .balign 4
datos2:
    .byte   1
    .skip   1
    .hword  500
    .byte   2

Tenemos tres campos de datos:
un byte: 1 byte.
un hword: 2 bytes.
un byte: 1 byte.
El primer campo comienza en el desplazamiento 0.
Como el siguiente campo es de 2 bytes (.hword), la regla de ARM64 exige que comience en una direccion divisible entre 2 [2]. Por eso se usa .skip 1 para meter 1 byte de padding.
Luego el campo hword queda en el desplazamiento 2.
Finalmente el ultimo campo de 1 byte queda en el desplazamiento 4.
Un ejemplo conceptual de la organizacion seria:
Desplazamiento 0 byte
Desplazamiento 1 padding
Desplazamiento 2 hword
Desplazamiento 3 hword
Desplazamiento 4 byte
La disposicion exacta depende de las reglas de alineacion y de la directiva de empaquetado que usemos.

Importancia del padding
El padding puede hacer que una estructura ocupe mas memoria de la que ocuparian sus campos si simplemente se sumaran sus tamaños, pero es necesario en ARM64 para no afectar al hardware [3].
Si una estructura tiene un campo .byte seguido de un .xword (8 bytes), el sistema necesitara meter hasta 7 bytes de padding para que el dato de 8 bytes quede alineado a un numero multiplo de 8 [2].
Si no se administra bien el padding en ARM64, se pueden perder muchos bytes de memoria o se pueden generar errores grave al pasar datos entre programas de C y ensamblador.
Por lo tanto, cuando se trabaja con estructuras a bajo nivel en ARM64, es importante conocer:
El tamaño de cada tipo de dato (.byte, .hword, .word, .xword).
El desplazamiento de cada campo.
Las reglas de alineacion de la ABI de ARM64 (AAPCS64) [2].
El uso de directivas como .align, .balign y .skip [1].
El tamaño total de la estructura en la memoria.
La documentacion de GNU Assembler para ARM proporciona las directivas necesarias para manejar estos espacios [1].

Relacion entre estructuras y memoria
Las estructuras son muy importantes en ARM64 porque permiten representar datos complejos de forma organizada sin perder el control del hardware.
Por ejemplo, una estructura para representar un alumno en memoria podria verse asi:

    .data
    .align 3
alumno_ref:
    .word   1001
    .byte   20
    .skip   3
    .xword  95

En la memoria del procesador ARM64, los campos van uno despues del otro siguiendo las reglas de la arquitectura. Conocer los desplazamientos nos permite calcular exactamente las direcciones para poner en las instrucciones ldr o str.
Esto es indispensable al programar en sistemas ARM de 64 bits modernos como los que usan los celulares o computadoras actuales [3].

Ejemplo sencillo
Podemos considerar una estructura sencilla con informacion basica en ARM64:

    .data
    .balign 4
persona:
    .byte   15
    .skip   1
    .hword  170
    .byte   1

La estructura contiene tres campos con diferentes tamaños.
Conceptualmente, la memoria en ARM64 se podria organizar de esta forma:

+-------------------+ | edad (byte) | 1 byte +-------------------+ | padding | 1 byte +-------------------+ | estatura (hword) | 2 bytes +-------------------+ | activo (byte) | 1 byte +-------------------+
El campo edad comienza al inicio de la estructura en el offset 0. Luego sigue un byte de padding para que estatura empiece en el offset 2 (multiplo de 2). Finalmente activo se coloca en el offset 4.
Este ejemplo permite observar por que no basta con sumar los datos. Tambien es necesario revisar como estan alineados segun las reglas del procesador ARM64 [2].

Efectos en el hardware ARM64
Los procesadores ARM64 (arquitecturas ARMv8-A y ARMv9-A) leen la memoria mediante bus de datos de 64 o 128 bits [3].
Aunque los procesadores ARM64 modernos pueden leer algunos datos desalineados sin trabarse inmediatamente, hacer esto provoca un problema de rendimiento llamado cruzamiento de lineas de cache (Cache Line Split) [3]. Cuando un dato mal alineado cruza el limite de 64 bytes de una linea de cache, la memoria tiene que hacer el doble de trabajo y la computadora se vuelve mas lenta.
Ademas, hay instrucciones de ARM64 que fallan de forma obligatoria si los datos no estan bien alineados. Por ejemplo, las instrucciones atómicas LDXR/STXR o las instrucciones de pares LDP/STP provocan un error grave del sistema llamado Alignment Fault Exception si la direccion esta desalineada [3]. Lo mismo pasa cuando se trabaja con memoria de dispositivos de entrada y salida (Device Memory) [3].
Por estas razones, usar bien el padding en ARM64 evita que el programa falle o se vuelva lento [3].

Ventajas de utilizar estructuras
Las estructuras ofrecen varias ventajas cuando se programa en ensamblador ARM64:
Permiten organizar datos relacionados en bloques de memoria contiguos.
Facilitan la lectura y comprension del codigo al calcular desplazamientos fijos.
Permiten trabajar con tipos de datos de varios tamaños (.byte, .word, .xword).
Facilitan el acceso a las variables desde registros como x0, x1 o w0.
Ayudan a conectar el codigo de ensamblador con programas escritos en lenguaje C.
Permiten comprender mejor la relacion entre los datos y la memoria RAM del procesador.
Sin embargo, como el ensamblador ARM64 esta tan cerca del hardware, el programador siempre debe revisar los desplazamientos y los rellenos manualmente.

Conclusion
Las estructuras o struct son una herramienta importante en lenguaje ensamblador ARM64 porque permiten organizar diferentes datos relacionados dentro de una misma unidad de memoria.
Los desplazamientos u offsets indican la posicion exacta de cada campo con respecto al inicio de la estructura. Esto permite que instrucciones como LDR o STR puedan leer o guardar informacion directo en la memoria usando registros.
Por otra parte, el empaquetado determina como se acomodan los campos dentro de la RAM. Debido a las reglas de alineacion de la interfaz binaria AAPCS64 y la arquitectura ARMv8-A/ARMv9-A, se deben poner espacios vacios llamados padding o relleno para cumplir con los multiplos de bytes necesarios.
Por lo tanto, para trabajar correctamente con estructuras en ARM64 es necesario conocer el tamaño de los datos, calcular bien los desplazamientos y respetar las reglas de alineacion del procesador.
Comprender estos conceptos es fundamental para entender como se maneja la memoria a bajo nivel en sistemas ARM de 64 bits. La documentacion oficial de ARM sobre la ABI AAPCS64 y los manuales de la arquitectura ARMv8-A/ARMv9-A brindan toda la informacion tecnica para programar estas estructuras correctamente.

Referencias
[1] ARM Limited, "GNU Assembler Directives," GNU Toolchain Reference Documentation, 2024. Disponible en: [https://sourceware.org/binutils/docs/as/ARM-Directives.html](https://sourceware.org/binutils/docs/as/ARM-Directives.html?utm_source=gemini)
[2] ARM Limited, "Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64)," Arm Architecture Reference Documentation, 2024. Disponible en: [https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst?utm_source=gemini)
[3] ARM Limited, "Arm Architecture Reference Manual for A-profile architecture," Arm Reference Documentation, 2024. Disponible en: [https://developer.arm.com/documentation/ddi0487/latest](https://developer.arm.com/documentation/ddi0487/latest?utm_source=gemini)
