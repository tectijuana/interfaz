# Manejo de cadenas y buffers en ensamblador ARM64 sin biblioteca estándar

## Introducción
Como programadores, estamos acostumbrados a utilizar funciones predefinidas y bibliotecas para realizar tareas complejas de manera inmediata. Sin embargo, es necesario comprender que internamente estas rutinas se traducen en una serie de instrucciones de bajo nivel. Por lo que se vuelve fundamental explorar cómo se manipulan directamente las cadenas de texto y los bloques de almacenamiento temporal, conocidos como buffers, utilizando lenguaje ensamblado

## Desarrollo Técnico
El manejo de cadenas y buffers en lenguaje ensamblador AArch64 sin el uso de una biblioteca estándar requiere una comprensión profunda de la arquitectura del procesador y del sistema operativo. Al no contar con rutinas predefinidas, el programador debe gestionar explícitamente la memoria, manipular los registros nativos y estructurar de forma manual las llamadas al sistema.

### 1. Representación de Cadenas y Buffers en Memoria
En ensamblador puro, no existe el tipo de dato abstracto para representar texto. Las cadenas se almacenan como arreglos contiguos de bytes en la memoria, generalmente en la sección .data para datos inicializados o en la sección .bss para buffers dinámicos.

### 2. Gestión de Registros y Punteros
La arquitectura ARM64 cuenta con 31 registros de propósito general de 64 bits (X0 a X30), los cuales pueden ser accedidos como registros de 32 bits (W0 a W30) cuando se requiere manipular datos más pequeños. Para trabajar con buffers, los registros asumen el rol de punteros. Mediante la instrucción ldr (Load Register), se carga la dirección base del buffer en un registro (por ejemplo, X1). A partir de ese momento, el registro funciona como un índice que apunta a la ubicación física de la memoria, permitiendo recorrer la cadena sumando desplazamientos (offsets) numéricos a su valor base.

### 3. Lógica de Recorrido e Instrucciones Nativas
Dado que no se cuenta con abstracciones como strlen para conocer el tamaño de una cadena, es necesario construir un algoritmo iterativo manual que recorra el buffer byte por byte hasta encontrar el terminador nulo. Esto se logra leyendo el contenido de la memoria hacia un registro mediante la instrucción ldrb (Load Register Byte), comparando dicho valor con cero a través de la instrucción cmp, y utilizando saltos condicionales como cbz (Compare and Branch on Zero) para salir del bucle en el momento exacto

> ```armasm
> // Asumiendo que X1 contiene la dirección base del buffer
>    mov x2, #0          // Inicializar el contador de longitud en 0
>loop:
>    ldrb w3, [x1, x2]   // Cargar un byte del buffer (dirección x1 + offset x2)
>    cbz w3, fin         // Si el byte es 0 (terminador nulo), salir del bucle
>    add x2, x2, #1      // Incrementar el contador de longitud
>    b loop              // Repetir el ciclo
>fin:
>// Al finalizar la rutina, X2 contiene la longitud exacta de la cadena
>```

### 4. Salida de Datos mediante Llamadas al Sistema (Syscalls)
Una vez que se tiene la cadena y se conoce la cantidad de bytes que se quieren mostrar, es necesario solicitar al sistema operativo que escriba esos datos en la salida estándar.

Cuando se trabaja directamente con ensamblador y no se utilizan funciones de bibliotecas de alto nivel como printf, se puede utilizar una llamada al sistema, o syscall. Una syscall permite que un programa solicite al kernel de Linux realizar determinadas operaciones, como escribir datos, abrir archivos o terminar un proceso.

### 5. Ejemplo práctico: Hola Mundo 
El siguiente código muestra un ejemplo básico de cómo imprimir el mensaje `"Hola Mundo"` utilizando ensamblador ARM64 y una llamada al sistema de Linux.

```armasm
.global _start
.text

_start:
    // 1. Cargar la dirección de la cadena en X1
    ldr x1, =mensaje

    // 2. Definir la longitud de la cadena
    // "Hola Mundo\n" = 11 bytes
    mov x2, #11

    // 3. Configurar el descriptor de archivo para stdout
    mov x0, #1

    // 4. Configurar el número de syscall para 'write' en ARM64
    mov x8, #64

    // 5. Solicitar al kernel que escriba el mensaje
    svc #0

    // 6. Configurar la syscall para 'exit'
    // Código de salida 0 = ejecución exitosa
    mov x0, #0
    mov x8, #93

    // 7. Solicitar al kernel terminar el programa
    svc #0

.data

// Cadena almacenada como una secuencia de bytes
mensaje:
    .ascii "Hola Mundo\n"
```
## Conclusión
Desarrollar la investigacion permite ver lo que sucede realmente en los lenguajes de programación modernos. Al trabajar sin bibliotecas estándar, queda claro que tareas que parecen simples, como mostrar un texto en pantalla, requieren en realidad un control absoluto del hardware y la memoria. 

Aprender a reservar el espacio de los buffers, recorrer cadenas contando cada byte de forma manual y comunicarnos directamente con el sistema operativo a través de las llamadas al sistema (*syscalls*) en ARM64, otorga una perspectiva mucho más profunda de cómo procesa la información la computadora. Entender estos fundamentos a tan bajo nivel es una base esencial para mejorar la lógica de programación y comprender la verdadera eficiencia del software.

## Bibliografía
[1] Arm Ltd., “Documentation – Arm Developer,” Arm Developer. [En línea]. Disponible en: https://support.arm.com/documentation/102374/0103/. [Accedido: 12-sep-2026].

[2] digispin, “First ARM ASM Program - Problems with using labels (armasm64),” Stack Overflow, 2025. [En línea]. Disponible en: https://stackoverflow.com/questions/79559381/first-arm-asm-program-problems-with-using-labels-armasm64. [Accedido: 12-sep-2026]. 
S
Stack Overflow

[3] “Manejo de Strings,” Scribd. [En línea]. Disponible en: https://es.scribd.com/presentation/607362090/Manejo-de-Strings. [Accedido: 12-sep-2026].

[4] V. Keleshev, “ARM Assembly Programming,” en Compiling to Assembly from Scratch, 2024. [En línea]. Disponible en: https://keleshev.com/compiling-to-assembly-from-scratch/07-arm-assembly-programming. [Accedido: 12-sep-2026]. 
K
Keleshev
+1

[5] M. Kerrisk, “syscall(2) — Linux manual page,” Linux man-pages. [En línea]. Disponible en: https://man7.org/linux/man-pages/man2/syscall.2.html. [Accedido: 12-sep-2026]. 
M
man7.org
