Grabacion de asciinema

https://asciinema.org/a/743740

Irving Alejandro Santos Duarte





// ===============================================
// Programa: multiplos.s
// Autor: Irving Alejandro Santos Duarte
// Objetivo: Calcular y mostrar los primeros 3 múltiplos de 2
// Plataforma: Linux Ubuntu 24.04 LTS ARM64 (aarch64)
// ===============================================
//
// --- Equivalente en C ---
// int main() {
//     for (int i = 1; i <= 3; i++) {
//         printf("%d ", i * 2);
//     }
//     printf("\n");
//     return 0;
// }

        .global _start

.section .bss
buffer: .skip 4        // espacio para convertir número a texto

.section .text
_start:
        mov     x19, 1          // i = 1
        mov     x20, 3          // límite = 3

loop:
        // calcular i*2
        mov     x0, x19
        lsl     x0, x0, 1       // x0 = i * 2  (desplazar a la izquierda 1 bit)

        // convertir número a ASCII decimal en buffer
        bl      int_to_ascii

        // imprimir número
        mov     x0, 1           // fd = stdout
        ldr     x1, =buffer     // puntero al buffer
        mov     x2, 1           // longitud = 1 (solo dígito)
        mov     x8, 64          // syscall write
        svc     0

        // imprimir espacio
        mov     x0, 1
        ldr     x1, =space
        mov     x2, 1
        mov     x8, 64
        svc     0

        // incrementar i
        add     x19, x19, 1
        cmp     x19, x20
        ble     loop

        // salto de línea
        mov     x0, 1
        ldr     x1, =newline
        mov     x2, 1
        mov     x8, 64
        svc     0

        // salir
        mov     x0, 0
        mov     x8, 93
        svc     0

//------------------------------------------------
// Subrutina: int_to_ascii
// Entrada: x0 = número (0–9)
// Salida: buffer[0] = carácter ASCII
//------------------------------------------------
int_to_ascii:
        add     x0, x0, '0'     // convertir a ASCII
        ldr     x1, =buffer
        strb    w0, [x1]        // guardar byte en buffer
        ret

//------------------------------------------------
// Datos constantes
//------------------------------------------------
.section .rodata
space:   .asciz " "
newline: .asciz "\n"

