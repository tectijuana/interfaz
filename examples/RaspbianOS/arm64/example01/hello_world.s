/*=======================================================
 * Programa:     hello_world.s
 * Autor:        RENE SOLIS
 * Fecha:        14 de septiembre de 2024
 * Descripción:  Este programa en ensamblador ARM64 imprime
 *               el mensaje "Hello, World!" en la consola 
 *               usando llamadas al sistema en Linux.
 * Compilación:  as -o hello_world.o hello_world.s
 *               ld -o hello_world hello_world.o
 * Ejecución:    ./hello_world
 * Versión:      1.0
 * 
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int main() {
 *     printf("Hello, World!\n");
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

.section .data
msg:
    .asciz "Hello, World!\n"    // Definimos el mensaje a imprimir

.section .text
.global _start

_start:
    // Syscall para escribir en stdout
    mov x0, #1              // El descriptor de archivo 1 es stdout (salida estándar)
    ldr x1, =msg            // Cargamos la dirección del mensaje a imprimir
    mov x2, #14             // Longitud del mensaje (14 caracteres, incluyendo el salto de línea)
    mov x8, #64             // Número de syscall para 'write' (64 en ARM64)
    svc #0                  // Realizamos la llamada al sistema

    // Syscall para salir del programa
    mov x0, #0              // Código de estado 0 (indica éxito)
    mov x8, #93             // Número de syscall para 'exit' (93 en ARM64)
    svc #0                  // Realizamos la llamada al sistema
