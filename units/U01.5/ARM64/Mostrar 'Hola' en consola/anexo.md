Prompts

Mostrar 'Hola' en consola
ARM64 Assembly Tutor for RaspbianOS Linux dijo:

Perfecto 🚀. Para mostrar "Hola" en la consola usando ARM64 Assembly en Raspberry Pi OS (Linux) necesitamos usar la llamada al sistema write. Te dejo el código completo con el encabezado del programador, primero en C (como comentario) y luego en ensamblador AArch64:

/**********************************************************************
 * Autor: [Tu Nombre]
 * Fecha: 23/09/2025
 * Descripción: Programa en ARM64 Assembly que muestra "Hola" en consola
 **********************************************************************/

/*
   Versión en C equivalente:

   #include <unistd.h>
   int main() {
       write(1, "Hola\n", 5);   // fd=1 (stdout), mensaje, longitud
       return 0;
   }
*/

.global _start

.section .data
msg:    .ascii  "Hola\n"          // Cadena a imprimir
len = . - msg                     // Longitud de la cadena

.section .text
_start:
    // write(int fd, const void *buf, size_t count)
    mov     x8, 64        // syscall number (write en AArch64 Linux)
    mov     x0, 1         // file descriptor 1 = stdout
    ldr     x1, =msg      // dirección del mensaje
    mov     x2, len       // longitud del mensaje
    svc     0             // llamada al sistema

    // exit(0)
    mov     x8, 93        // syscall number (exit en AArch64 Linux)
    mov     x0, 0         // código de salida 0
    svc     0

🔧 Pasos para compilar y ejecutar en tu Raspberry Pi OS:

Guarda el archivo como hola.s

Ensambla y enlaza:

as -o hola.o hola.s
ld -o hola hola.o


Ejecuta:

./hola


Deberías ver:

Hola

Reflexión

La ia me ayudo bastante a realizar la practica, al darme el codigo para correrlo en ARM64, facilitandome demasiado el trabajo realizado
