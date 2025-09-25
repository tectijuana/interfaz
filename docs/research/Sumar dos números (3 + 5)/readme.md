# ============================================================
#      ╔═╗┌┐┌┌─┐┌┬┐┬ ┬┌─┐┌─┐┬─┐      H A C K E R - R E T R O
#      ║ ╦││││ │ │ ├─┤├─┤│ │├┬┘      ARM64 Assembly Playground
#      ╚═╝┘└┘└─┘ ┴ ┴ ┴┴ ┴└─┘┴└─
#
# 📚 Asignatura: Lenguajes de Interfaz - TECNM Campus ITT
# ✍️ Autor: [HERRERA MIRANDA MARVIN JAVIER 23210602]
# 📅 Fecha: 2025/09/24
# 📝 Descripción: Programa en ensamblador ARM64 que suma
#    dos números (3 + 5) y devuelve el resultado al sistema.
# 🔗 Simulación Wokwi: https://wokwi.com/projects/arm64-suma
#
# ============================================================
# 🚀 "Cada instrucción cuenta... cada bit construye tu universo."
#              >> Saga: *Bits & Dragons - Nivel 1: Suma Épica*
# ============================================================

# Programa en ARM64 Assembly: Suma de dos números (3 + 5)

```asm
// ======================================================
// Programa: suma.s
// Autor: [Tu Nombre]
// Descripción: Programa en ensamblador ARM64 que suma
//              dos números (3 + 5) y devuelve el resultado
//              como código de salida del sistema operativo.
// Plataforma: AWS Academy (Ubuntu 24 ARM64) o Raspberry Pi OS 64 bits
// ======================================================
//
// Solución en C# (alto nivel):
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

    .global _start       // Definimos el punto de entrada del programa
    .text                // Sección de código ejecutable

_start:
    //---------------------------------------------------
    // 1) Inicializar operandos
    // En este caso los operandos son 3 y 5.
    // Los guardamos en registros temporales.
    //---------------------------------------------------
    mov     x3, #3       // Guardar el valor 3 en el registro x3
    mov     x4, #5       // Guardar el valor 5 en el registro x4

    //---------------------------------------------------
    // 2) Realizar la suma
    //---------------------------------------------------
    add     x5, x3, x4   // x5 = x3 + x4  -> 8

    //---------------------------------------------------
    // 3) Terminar el programa
    // Convención de Linux en AArch64:
    //   - El argumento de salida va en x0
    //   - El número de syscall va en x8
    //   - "svc #0" ejecuta la llamada al sistema
    //---------------------------------------------------
    mov     x0, x5       // Pasamos el resultado (8) al registro x0
    mov     x8, #93      // 93 = número de syscall para "exit"
    svc     #0           // Llamada al kernel -> terminar programa
