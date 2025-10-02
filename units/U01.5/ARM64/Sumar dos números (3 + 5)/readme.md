# =============================================================================
#   ██████  ██    ██ ███    ███  █████   ██████   ██████   ██████
#  ██    ██ ██    ██ ████  ████ ██   ██ ██       ██    ██ ██    ██
#  ██    ██ ██    ██ ██ ████ ██ ███████ ██   ███ ██    ██ ██    ██
#  ██ ▄▄ ██ ██    ██ ██  ██  ██ ██   ██ ██    ██ ██    ██ ██    ██
#   ██████   ██████  ██      ██ ██   ██  ██████   ██████   ██████
#      ▀▀
#
#   ░█▀▄░█░█░█▀▀░█▀█░█▀▄░█░█░█▀█░█▀█   ░█▀▀░█▀▄░█░░░█▀▀░█▀▀░█▀▀░█▀█░█▀▀
#   ░█░█░█▄█░█▀▀░█▀▄░█▀▄░█▄█░█▀▀░█▀▄   ░█░░░█▀▄░█░░░█░█░█░█░█░█░█▀█░█░█
#   ░▀▀░░▀░▀░▀▀▀░▀░▀░▀▀░░▀░▀░▀░░░▀░▀   ░▀▀▀░▀░▀░▀▀▀░▀▀░░▀▀░░▀▀░░▀░▀░▀▀▀
#
#  ────────────────────────────────────────────────────────────────────────────
#  🎯 ASIGNATURA : Lenguajes de Interfaz en TECNM Campus ITT
#  ✍️ AUTOR      : [HERRERA MIRANDA MARVIN JAVIER]               🗓  FECHA : 2025/09/25
#  🔧 PROGRAMA   : Suma básica de dos números
#
#  📄 DESCRIPCIÓN:
#    - Programa sencillo que suma dos números enteros: 3 + 5.
#    - Ejemplo introductorio al manejo de operaciones aritméticas en Python.
#
#  🌐 SIMULACIÓN WOKWI:
#    https://wokwi.com/projects/EDIT-ME-Suma-Retro
#
#  ────────────────────────────────────────────────────────────────────────────
#  (◉_◉)  HACKER MODE — Consola verde, líneas de código y pura lógica binaria
#
#    [OPERACIÓN]
#       3 + 5  =  8
#
#  ░ No es magia. Es matemática con estilo. — Módulo: RetroMath Hackers
# =============================================================================

# Programa en ARM64 Assembly: Suma de dos números (3 + 5)

```asm
// ======================================================
// Programa: suma.s
// Autor: [herrera miranda marvin javier]
// Descripción: Suma de dos números (3 + 5) en ARM64
// Plataforma: Ubuntu ARM64 (AWS Academy) o Raspberry Pi OS (AArch64)
// ======================================================
//
// Solución en C#:
//
// using System;
// class Program {
//     static void Main() {
//         int a = 3, b = 5;
//         int c = a + b;
//         Console.WriteLine("Resultado = " + c);
//     }
// }
//
// ======================================================

    .global _start
    .text

_start:
    // -------------------------------
    // 1) Inicializamos los valores
    // -------------------------------
    mov     x3, #3       // guardamos 3 en x3
    mov     x4, #5       // guardamos 5 en x4

    // -------------------------------
    // 2) Realizamos la suma
    // -------------------------------
    add     x5, x3, x4   // x5 = x3 + x4  -> 8

    // -------------------------------
    // 3) Llamamos a exit()
    //    Convención Linux AArch64:
    //    x0 = código de salida
    //    x8 = número de syscall (93 = exit)
    //    svc #0 = invocar syscall
    // -------------------------------
    mov     x0, x5       // código de salida = 8
    mov     x8, #93      // syscall exit
    svc     #0
```
https://asciinema.org/a/RbtDrdaLKudnwXNW31g5Pckcr
