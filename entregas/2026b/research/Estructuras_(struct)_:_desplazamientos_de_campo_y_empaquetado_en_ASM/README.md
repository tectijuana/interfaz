Estructuras (struct): desplazamientos de campo y empaquetado en ASM
Introducción

En lenguaje ensamblador (ASM), las estructuras o struct sirven para guardar varios tipos de datos relacionados dentro de una misma unidad de memoria. Esto es útil cuando tenemos datos que tienen alguna relación entre sí, por ejemplo, los datos de un alumno como su nombre, edad y grado. En lugar de tener todos los datos separados, podemos agruparlos dentro de una sola estructura.

Las estructuras trabajan directamente con la memoria, por lo que es importante saber en qué posición se encuentra cada dato. Cada campo de una estructura tiene una posición determinada dentro de ella. A esta posición se le conoce como desplazamiento u offset. El desplazamiento indica cuántos bytes existen desde el inicio de la estructura hasta el comienzo de un campo determinado.

También es importante conocer el empaquetado o la forma en que los datos se organizan dentro de la memoria. Dependiendo del ensamblador y de las reglas de alineación utilizadas, pueden existir espacios entre algunos campos. Estos espacios reciben el nombre de relleno o padding.

Comprender los desplazamientos y el empaquetado permite conocer exactamente cómo se organizan los datos en memoria y facilita el acceso a los diferentes campos de una estructura.

Desarrollo
¿Qué es una estructura en ASM?

Una estructura es un tipo de dato compuesto que permite agrupar varios campos dentro de una misma unidad. Los campos pueden ser de diferentes tipos y tamaños.

Por ejemplo, en MASM podemos declarar una estructura llamada Alumno de la siguiente manera:

Alumno STRUCT
    edad    BYTE ?
    grado   WORD ?
    nombre  BYTE 20 DUP(?)
Alumno ENDS


En este ejemplo, la estructura contiene tres campos:

edad, que ocupa 1 byte.

grado, que utiliza un dato de tipo WORD, normalmente de 2 bytes.

nombre, que reserva 20 bytes mediante BYTE 20 DUP(?).

La directiva STRUCT permite declarar la estructura y ENDS indica el final de su declaración. MASM permite utilizar estructuras para organizar diferentes campos de datos bajo un mismo tipo de estructura (Microsoft, 2025).

Desplazamiento u offset

El desplazamiento (offset) representa la distancia, expresada en bytes, entre el comienzo de una estructura y el comienzo de uno de sus campos.

Por ejemplo, si tenemos una estructura sencilla:

Datos STRUCT
    edad    BYTE ?
    grado   BYTE ?
    Datos ENDS


Si no se introduce ningún espacio adicional entre los campos, edad comenzaría en el desplazamiento 0 y grado comenzaría en el desplazamiento 1.

Esto significa que el desplazamiento permite localizar un campo dentro de la estructura sin tener que buscarlo desde el principio de la memoria.

En lenguaje ensamblador esto es especialmente importante porque el programador trabaja directamente con registros, direcciones y posiciones de memoria. Conocer la posición de cada campo permite acceder correctamente a la información almacenada.

Acceso a los campos de una estructura

Cuando se utiliza una estructura en MASM, sus campos pueden ser identificados mediante sus nombres. Por ejemplo:

Alumno STRUCT
    edad    BYTE ?
    grado   WORD ?
    nombre  BYTE 20 DUP(?)
Alumno ENDS


La estructura define los campos edad, grado y nombre. Posteriormente, al trabajar con una variable que utilice esta estructura, podemos acceder a sus campos mediante sus nombres.

Por ejemplo:

alumno1 Alumno <>


Después podemos utilizar los campos de la estructura para trabajar con sus datos.

Es importante distinguir entre el tipo de estructura y una variable de ese tipo. Alumno define cómo estarán organizados los campos, mientras que alumno1 representa una instancia concreta de esa estructura.

Empaquetado de datos

El empaquetado se refiere a la manera en que los diferentes campos de una estructura quedan organizados dentro de la memoria.

Los datos pueden tener diferentes tamaños. Por ejemplo:

Un BYTE ocupa 1 byte.

Un WORD ocupa 2 bytes.

Un DWORD ocupa 4 bytes.

Cuando se colocan datos de diferentes tamaños dentro de una estructura, la posición de cada campo depende de las reglas de organización y alineación utilizadas por el ensamblador.

En algunos casos pueden existir bytes que no contienen información útil entre dos campos. Estos bytes se conocen como padding o relleno.

El relleno puede utilizarse para cumplir determinadas condiciones de alineación. La alineación permite colocar ciertos datos en direcciones que resultan adecuadas para la arquitectura y las reglas utilizadas por el ensamblador.

Por esta razón, el tamaño total de una estructura no siempre debe calcularse simplemente sumando el tamaño de todos sus campos. Es necesario considerar también las reglas de alineación y empaquetado.

Ejemplo de desplazamientos

Consideremos la siguiente estructura:

Datos STRUCT
    edad    BYTE ?
    altura  WORD ?
    activo  BYTE ?
Datos ENDS


Tenemos tres campos:

edad: 1 byte.

altura: 2 bytes.

activo: 1 byte.

El campo edad comienza en el desplazamiento 0.

Después se encuentra el campo altura. Su desplazamiento dependerá de las reglas de alineación que se estén utilizando. Si se requiere una determinada alineación, el ensamblador puede colocar bytes de relleno entre edad y altura.

Finalmente se encuentra el campo activo, cuyo desplazamiento dependerá de la posición final de altura.

Un ejemplo conceptual de la organización podría ser:

Desplazamiento
     0       edad
     1       padding
     2       altura
     3       altura
     4       activo


Este ejemplo solamente representa una posible organización. La disposición exacta depende de las reglas de alineación y empaquetado configuradas.

Importancia del padding

El padding puede hacer que una estructura ocupe más memoria de la que ocuparían sus campos si simplemente se sumaran sus tamaños.

Por ejemplo, si tenemos un campo de 1 byte seguido de un campo que necesita estar alineado a una dirección determinada, pueden ser necesarios uno o más bytes de relleno.

Por lo tanto, cuando se trabaja con estructuras a bajo nivel, es importante conocer:

El tamaño de cada tipo de dato.

El desplazamiento de cada campo.

Las reglas de alineación utilizadas.

El tamaño total de la estructura.

La manera en que el ensamblador organiza los campos en memoria.

La documentación de MASM proporciona directivas relacionadas con la declaración y organización de estructuras y otros tipos de datos (Microsoft, 2026).

Relación entre estructuras y memoria

Las estructuras son especialmente importantes en ensamblador porque permiten representar información compleja de una manera organizada sin perder el control sobre la memoria.

Por ejemplo, una estructura para representar un alumno podría contener:

Alumno STRUCT
    edad    BYTE ?
    grado   WORD ?
    nombre  BYTE 20 DUP(?)
Alumno ENDS


En memoria, los campos se encuentran uno después de otro siguiendo las reglas establecidas por el ensamblador. Por esta razón, conocer los desplazamientos permite determinar dónde comienza cada campo.

Esto es importante en programas que trabajan directamente con memoria, registros, direcciones y estructuras de datos.

La arquitectura Intel 64 e IA-32 utiliza diferentes tamaños de datos, registros y mecanismos de direccionamiento, por lo que comprender la organización de los datos en memoria es fundamental para programar correctamente en ensamblador (Intel Corporation, 2026).

Ejemplo sencillo

Podemos considerar una estructura que almacene información básica:

Persona STRUCT
    edad      BYTE ?
    estatura  WORD ?
    activo    BYTE ?
Persona ENDS


La estructura contiene tres campos de diferentes tamaños.

Conceptualmente, la memoria podría organizarse de esta forma:

+-------------------+
| edad              | 1 byte
+-------------------+
| padding           | si es necesario
+-------------------+
| estatura          | 2 bytes
+-------------------+
| activo            | 1 byte
+-------------------+


El campo edad comienza al inicio de la estructura. El campo estatura comienza después de edad y de cualquier relleno que sea necesario. Finalmente, activo se encuentra después de estatura.

Este ejemplo permite observar por qué no es suficiente conocer únicamente el tamaño de los campos. También es necesario conocer cómo se encuentran alineados dentro de la estructura.

Ventajas de utilizar estructuras

Las estructuras ofrecen varias ventajas cuando se programa en ensamblador:

Permiten organizar datos relacionados.

Facilitan la lectura y comprensión del código.

Permiten trabajar con diferentes tipos de datos dentro de una misma estructura.

Facilitan el acceso a los campos mediante nombres.

Ayudan a representar objetos o registros complejos.

Permiten comprender mejor la relación entre los datos y las posiciones de memoria.

Sin embargo, debido a que el ensamblador trabaja a un nivel muy cercano al hardware, el programador debe prestar atención al tamaño y posición de cada campo.

Conclusión

Las estructuras o struct son una herramienta importante en lenguaje ensamblador porque permiten organizar diferentes datos relacionados dentro de una misma unidad. Cada estructura está formada por campos que pueden tener diferentes tipos y tamaños.

Los desplazamientos u offsets indican la posición de cada campo con respecto al comienzo de la estructura. Esto permite localizar los datos directamente en memoria y acceder a ellos de manera organizada.

Por otra parte, el empaquetado determina cómo se acomodan los diferentes campos dentro de la memoria. Debido a las reglas de alineación, pueden aparecer espacios adicionales conocidos como padding o relleno. Estos espacios pueden modificar el tamaño total de una estructura.

Por lo tanto, para trabajar correctamente con estructuras en ASM es necesario conocer el tamaño de los tipos de datos, los desplazamientos de los campos y las reglas de alineación utilizadas por el ensamblador.

Comprender estos conceptos es fundamental para aprender cómo se organizan los datos en memoria y para desarrollar programas en ensamblador de manera correcta. La documentación oficial de Microsoft sobre MASM y los manuales de arquitectura de Intel proporcionan información técnica para comprender estos mecanismos y su relación con la programación de bajo nivel.

Referencias
Intel Corporation, "Intel® 64 and IA-32 Architectures Software Developer's Manual," Combined Volumes: 1, 2A, 2B, 2C, 2D, 3A, 3B, 3C, 3D, and 4, Jun. 2024. Disponible en: https://cdrdv2-public.intel.com/825743/325462-sdm-vol-1-2abcd-3abcd-4.pdf

Microsoft, "STRUCT (MASM)," Microsoft Learn, Aug. 03, 2021. Disponible en: https://learn.microsoft.com/en-us/cpp/assembler/masm/struct-masm

Microsoft, "Directives Reference (MASM)," Microsoft Learn, 2023. Disponible en: https://learn.microsoft.com/en-us/cpp/assembler/masm/directives-reference
