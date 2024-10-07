

#  Asciinema de programa 1

Depositar su programa en ASCIINEMA en IDOCEO


```assembly

// ChatGTP 4o - Fecha: 2024-10-07
// Programa en ARM64 Assembly para RaspbianOS

.data
    prompt:    .asciz "Ingrese su nombre: "  // Mensaje que se mostrará al usuario para solicitar su nombre
    buffer:    .space 100                    // Espacio reservado para almacenar el nombre ingresado por el usuario (máximo 100 caracteres)

.text
    .global _start

_start:
    // Desplegar el mensaje "Ingrese su nombre: "
    ldr x0, =1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =prompt             // Cargar en x1 la dirección del mensaje "prompt" para mostrarlo
    mov x2, #18                 // Cargar en x2 la longitud del mensaje (18 caracteres)
    mov x8, #64                 // Cargar en x8 el número de syscall para 'write' (64), que escribe en la salida estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Leer el nombre del usuario
    ldr x0, =0                  // Cargar en x0 el descriptor de archivo 0 (STDIN), que es la entrada estándar
    ldr x1, =buffer             // Cargar en x1 la dirección del buffer donde se almacenará el nombre ingresado
    mov x2, #100                // Cargar en x2 la longitud máxima a leer (100 caracteres)
    mov x8, #63                 // Cargar en x8 el número de syscall para 'read' (63), que lee de la entrada estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Desplegar el nombre ingresado
    ldr x0, =1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =buffer             // Cargar en x1 la dirección del buffer que contiene el nombre ingresado
    mov x2, #100                // Cargar en x2 la longitud máxima a desplegar (100 caracteres)
    mov x8, #64                 // Cargar en x8 el número de syscall para 'write' (64), que escribe en la salida estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Terminar el programa
    mov x8, #93                 // Cargar en x8 el número de syscall para 'exit' (93), que termina el programa
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

```

