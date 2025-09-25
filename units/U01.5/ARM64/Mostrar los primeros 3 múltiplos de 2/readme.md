# =======================================
# Mostrar los primeros 3 múltiplos de 2
# =======================================
#  💻 Asignatura: Lenguajes de Interfaz en TECNM Campus ITT
#  ✍️ Autor: Kain Alejandro Novelo Astorga
#  📅 Fecha: 2025/09/25
#  📜 Descripción: Programa en ARM64 que muestra
#     los primeros 3 múltiplos de 2 en Linux AWS/RPi.
#
#  🎥 Grabación en Asciinema:
#     🔗 https://asciinema.org/a/743551
#
# =======================================

## 🖥️ Código ensamblador

```asm
# ===============================
# Programa: multiplos.s
# Autor: Kain Alejandro Novelo Astorga
# Descripción: Muestra los primeros 3 múltiplos de 2 en ARM64 (Linux AWS/RPi)
# ===============================

# --- Versión C (para referencia) ---
# int main() {
#     int i;
#     int n = 2;
#     for (i = 1; i <= 3; i++) {
#         printf("%d\n", n * i);
#     }
#     return 0;
# }

        .data
n:      .word 2                  // base = 2
fmt:    .asciz "%d\n"            // formato para printf

        .text
        .global main
main:
        stp     x29, x30, [sp, -16]!    // prologue
        mov     x29, sp

        mov     w19, 1            // i = 1
        ldr     w20, n            // n = 2

loop:
        mul     w0, w20, w19      // w0 = n * i
        ldr     x1, =fmt          // puntero al formato
        mov     x2, x0            // valor calculado (promovido a 64 bits)
        mov     x0, x1            // primer argumento = formato
        mov     x1, x2            // segundo argumento = número
        bl      printf            // llamar a printf

        add     w19, w19, 1       // i++
        cmp     w19, 4            // ¿i <= 3?
        b.lt    loop              // si sí, repetir

        ldp     x29, x30, [sp], 16  // epilogue
        mov     w0, 0
        ret
