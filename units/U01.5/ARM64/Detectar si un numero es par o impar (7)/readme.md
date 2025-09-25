# 🖥️ Lenguajes de Interfaz - Retro Terminal Header

# =============================================================================
#  _________________________________________________________________
# |  _   _  _   _   _   _   _   _   _   _   _   _   _   _   _   _  |
# | | | | || |_| | /_\ | \ | |_  |_  /_\ | \ | |_   _|  ___  _  | |
# | | |_| ||  _  |/ _ \|  \| | | |  _/ _ \|  \| | | |    | | | | |
# | |____/ |_| |_|_/ \_\_|\__|_| |_| /_/ \_\_|\__| |_|    |_| |_| |
# |_______________________________________________________________|
# =============================================================================
#
# 🎨 Tema ambientado : Retro Terminal / Cyberpunk
# 💬 Asignatura       : Lenguajes de interfaz
# ✍️ Autor           : Miguel Angel Lopez Garibay
# 🆔 Número de control: 21212576
# 📅 Fecha           : 2025/09/24
# Link asciinema: https://asciinema.org/a/UenRyhqo2QeA8HFmCAYcLdMYW
#
# 📌 Descripción:
#   Código en ARM64 (sistema operativo: Ubuntu) que verifica si el número 7
#   es par o impar y muestra el resultado por consola.
#
# 🔗 Enlace de simulación en Wokwi (editable / ficticio):
#   https://wokwi.com/projects/arm64/21212576-retro-check7
#
# -----------------------------------------------------------------------------
#   ┌──────────────────────────────┐
#   │  Retro Mode: ASCII Kernel v1 │
#   └──────────────────────────────┘
#
#   Ejemplo de uso:
#     $ ./check7_arm64       # Ejecuta la rutina que comprueba par/impar
#
# 🎯 Título de la serie/módulo:
#   "Módulo: BitQuest — Aventuras en el Núcleo"
#
# =============================================================================

---

## 📋 Comentarios generales del desarrollo de la práctica  

La actividad fue fácil de realizar.  
Como pasos generales se ejecuta la instancia, se crea el archivo ejecutable donde se ingresa el código, se compila y ensambla, y finalmente se ejecuta. ¡Eso es todo! 🚀  

---

## 💻 Código fuente

### 📌 Comentarios generales en C  
```c
/* 
Programador:   Miguel Angel Lopez Garibay
Fecha:         2025-09-24
Descripción:   Detecta si el número 7 es par o impar y lo imprime.
Entorno:       Ubuntu ARM64 (AWS Graviton) con gcc disponible.
*/

/* ----- Solución en C (comentada) ----- */
#include <stdio.h>
int main(void) {
    int n = 7;
    if (n % 2 == 0)
        printf("%d es par\n", n);
    else
        printf("%d es impar\n", n);
    return 0;
}
    .section .rodata
even_fmt:
    .asciz "%d es par\n"
odd_fmt:
    .asciz "%d es impar\n"

    .text
    .global main
    .type main, %function

main:
    stp x29, x30, [sp, #-16]!   // guardar FP y LR en la pila
    mov x29, sp                 // establecer frame pointer

    mov x1, #7                  // x1 = 7 (número a comprobar)
    and x2, x1, #1              // x2 = x1 & 1 (bit menos significativo)
    cbz x2, is_even             // si x2 == 0 → es par

    // Caso impar
    ldr x0, =odd_fmt            // x0 = dirección de la cadena "%d es impar\n"
    bl printf                   // llamar a printf(format, n)
    b done

is_even:
    ldr x0, =even_fmt           // x0 = dirección de la cadena "%d es par\n"
    bl printf                   // llamar a printf(format, n)

done:
    mov w0, #0                  // return 0
    ldp x29, x30, [sp], #16     // restaurar FP y LR
    ret

    # Link asciinema: https://asciinema.org/a/UenRyhqo2QeA8HFmCAYcLdMYW
