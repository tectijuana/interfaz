### CAPÍTULO 6: **Manejo de Excepciones y Llamadas al Sistema en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a las excepciones en ARM64](#introducción-a-las-excepciones-en-arm64)
2. [Tipos de excepciones](#tipos-de-excepciones)
3. [Llamadas al sistema (syscalls)](#llamadas-al-sistema-syscalls)
4. [Manejo de excepciones en ensamblador](#manejo-de-excepciones-en-ensamblador)
5. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a las excepciones en ARM64

Una **excepción** es un evento que interrumpe el flujo normal de ejecución de un programa. En ARM64, las excepciones pueden generarse debido a errores del sistema, instrucciones especiales o eventos de hardware, como interrupciones. Entender y manejar excepciones es crucial para crear programas robustos, especialmente en sistemas embebidos como el Raspberry Pi 5.

ARM64 tiene varios niveles de privilegio para manejar excepciones, y el código de usuario normalmente ejecuta en el nivel más bajo, conocido como **EL0** (Exception Level 0). Cuando ocurre una excepción, el procesador pasa a un nivel superior de privilegio, como **EL1** (nivel de sistema operativo), para gestionar la excepción.

---

## Tipos de excepciones

Las excepciones en ARM64 se dividen en varias categorías, dependiendo de la causa que las genera:

1. **Excepciones síncronas**:
   - Son generadas por instrucciones específicas dentro del programa.
   - Ejemplos: errores de división por cero, errores de memoria (segmentation faults), llamadas al sistema.
   
2. **Interrupciones**:
   - Son señales externas que indican al procesador que debe atender un evento urgente.
   - Ejemplos: teclados, temporizadores, dispositivos de red.

3. **Abortos**:
   - Ocurren cuando hay errores graves que impiden la ejecución del programa.
   - Ejemplos: intentos de acceso a memoria no válida.

---

## Llamadas al sistema (syscalls)

En ARM64, las **llamadas al sistema** (syscalls) permiten a los programas de usuario interactuar con el sistema operativo. Son un mecanismo clave para realizar tareas como la gestión de archivos, la comunicación con dispositivos, y la gestión de procesos.

### Estructura de una syscall en ARM64:

Para realizar una syscall, se sigue el siguiente esquema en ensamblador:

1. Cargar el número de la syscall en el registro **x8**.
2. Cargar los argumentos de la syscall en los registros **x0** a **x7** (dependiendo de cuántos argumentos se necesiten).
3. Ejecutar la instrucción `svc #0` para hacer la llamada al sistema.

### Ejemplo de syscall:

A continuación, un ejemplo de cómo realizar una syscall para finalizar un programa usando el número de syscall 93 (que corresponde a `exit` en Linux):

```assembly
mov x0, #0         // Argumento: código de salida 0 (éxito)
mov x8, #93        // Número de syscall para "exit"
svc #0             // Llamada al sistema
```

Este código hará que el programa termine con un código de salida de éxito.

### Algunas syscalls comunes:

1. **Exit** (número de syscall 93): Finaliza el programa.
   ```assembly
   mov x0, #0    // Código de salida
   mov x8, #93   // Syscall para exit
   svc #0
   ```

2. **Write** (número de syscall 64): Escribe en un archivo o en la salida estándar.
   ```assembly
   mov x0, #1            // Descripor de archivo (1 para stdout)
   ldr x1, =mensaje      // Dirección del mensaje a imprimir
   mov x2, #13           // Longitud del mensaje
   mov x8, #64           // Syscall para write
   svc #0
   ```

---

## Manejo de excepciones en ensamblador

Cuando ocurre una excepción, ARM64 salta a una dirección específica para ejecutar un manejador de excepciones. El **manejador de excepciones** es un conjunto de instrucciones que determina cómo el sistema responde a la excepción.

### Pasos básicos para manejar una excepción:

1. **Guardar el contexto**: Antes de hacer cualquier cosa, se deben guardar los registros importantes, como los valores de los registros generales, en la pila.
2. **Procesar la excepción**: Dependiendo de la excepción, el código debe manejar el error o realizar las acciones necesarias.
3. **Restaurar el contexto**: Una vez manejada la excepción, se restauran los registros y el flujo de ejecución original.
4. **Retornar al flujo normal**: Después de manejar la excepción, el programa vuelve al flujo de ejecución normal.

### Ejemplo de manejo de excepción:

Un manejo sencillo de excepción podría ser interceptar una división por cero y evitar que el programa se cuelgue. Aunque los sistemas operativos modernos gestionan esto, un manejo a bajo nivel podría parecerse a esto:

```assembly
_start:
    mov x0, #10      // Cargar 10 en x0
    mov x1, #0       // Cargar 0 en x1 (causará división por cero)
    udiv x2, x0, x1  // Intentar dividir (provoca excepción)
    b manejo_error   // Saltar a la rutina de manejo de error

manejo_error:
    mov x0, #1       // Código de error (división por cero)
    mov x8, #93      // Llamada al sistema para terminar el programa
    svc #0           // Ejecutar syscall exit
```

---

## Ejercicios prácticos

### Ejercicio 1: Llamada al sistema para escribir en pantalla
Escribe un programa en ensamblador que utilice una syscall para escribir el mensaje "Hola, ARM64" en la salida estándar.

#### Pseudocódigo:
1. Cargar el descriptor de archivo (1 para stdout).
2. Cargar la dirección del mensaje en un registro.
3. Realizar la syscall para escribir el mensaje.

#### Solución en ensamblador:
```assembly
.section .data
mensaje:    .ascii "Hola, ARM64\n"

.section .text
.global _start

_start:
    mov x0, #1          // Descriptor de archivo (stdout)
    ldr x1, =mensaje     // Dirección del mensaje
    mov x2, #11          // Longitud del mensaje (11 caracteres)
    mov x8, #64          // Syscall para escribir
    svc #0               // Llamada al sistema

    // Termina el programa
    mov x0, #0           // Código de salida
    mov x8, #93          // Syscall para exit
    svc #0
```

### Ejercicio 2: Manejo de excepción por división por cero
Escribe un programa que intente realizar una división por cero y, cuando se produzca la excepción, realice una syscall para terminar el programa con un código de error.

#### Solución en ensamblador:
```assembly
_start:
    mov x0, #20          // Valor del numerador
    mov x1, #0           // Valor del denominador (causa división por cero)
    udiv x2, x0, x1      // Intentar dividir (genera excepción)

    // Si ocurre la excepción, salta a la rutina de manejo de error
manejo_error:
    mov x0, #1           // Código de salida de error
    mov x8, #93          // Syscall para exit
    svc #0               // Llamada al sistema para salir
```

---

## Resumen

Este capítulo te brinda los conocimientos básicos sobre la interacción con el sistema operativo y el manejo de eventos imprevistos, elementos fundamentales para escribir código más robusto y estable.
