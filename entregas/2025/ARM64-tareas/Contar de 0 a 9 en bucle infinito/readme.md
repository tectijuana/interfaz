El programa está escrito para la arquitectura ARM64 y su objetivo es mostrar cómo se implementa un bucle infinito que contiene otro bucle para contar de 0 a 9, imprimiendo cada número.
El código es equivalente al ejemplo en C proporcionado.

-----

### Código ARM64 Contar de 0 a 9 en bucle infinito

```armasm
/***************************************
 * Autor: [Casimiro Morales Alexandra Daniela]
 * Fecha: Septiembre 2025
 * Descripción:
 * Programa ARM64 en Linux (Ubuntu/Raspbian)
 * que cuenta de 0 a 9 en bucle infinito.
 *
 * Versión en C (referencia):
 * ------------------------------------
 * #include <stdio.h>
 * int main() {
 * while (1) {
 * for (int i = 0; i < 10; i++) {
 * printf("%d\n", i);
 * }
 * }
 * return 0;
 * }
 ***************************************/

    .section .rodata
msg:    .asciz "%d\n"             // Define la cadena de formato para printf, terminada en nulo.

    .text
    .global main
main:
    stp     x29, x30, [sp, -16]!  // Guarda el puntero de marco (frame pointer, x29) y la dirección de retorno (link register, x30) en la pila.
    mov     x29, sp               // Establece el puntero de marco en la dirección actual del stack pointer.

loop_infinito:
    mov     w19, 0                // Inicializa el registro w19 a 0. Este registro actuará como el contador 'i' del bucle for.

for_loop:
    cmp     w19, 10               // Compara el valor de 'i' (w19) con 10.
    bge     loop_infinito         // Si 'i' es mayor o igual que 10, salta a 'loop_infinito' para reiniciar el conteo.

    // preparar parámetros para printf
    adrp    x0, msg               // Carga la parte superior de 64 bits de la dirección de 'msg' en x0.
    add     x0, x0, :lo12:msg     // Añade la parte inferior de 12 bits de la dirección de 'msg' a x0. x0 ahora contiene la dirección completa de la cadena de formato.
    mov     w1, w19               // Mueve el valor del contador 'i' (w19) al registro w1. Los argumentos para llamadas a funciones en ARM64 se pasan en los registros x0-x7.
    bl      printf                // Llama a la función 'printf' para imprimir el número.

    add     w19, w19, 1           // Incrementa el contador 'i' en 1.
    b       for_loop              // Salta incondicionalmente al inicio del bucle 'for_loop' para la siguiente iteración.

    // Este código nunca se alcanza debido al bucle infinito
    ldp     x29, x30, [sp], 16    // Restaura el puntero de marco y la dirección de retorno.
    mov     w0, 0                 // Mueve 0 al registro w0, el registro de retorno de la función.
    ret                           // Retorna del programa principal.

```
