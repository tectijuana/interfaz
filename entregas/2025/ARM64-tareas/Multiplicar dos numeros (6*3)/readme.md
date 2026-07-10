# ✨🌸 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 🌸✨
# (｡♥‿♥｡)  ANIME KAWAII HEADER  (｡♥‿♥｡)
# ✨🌸 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 🌸✨
#
# 📚 Asignatura: Lenguajes de Interfaz en TECNM Campus ITT
# 👩‍💻 Autor/a: [Jimenez Guerrero Victor Gael] 
# 📅 Fecha: 2025/09/24
#
# 🌟 Descripción:
# Este programa controla un LED con ayuda de un botón usando la Raspberry Pi Pico W.
# ¡Un toque kawaii a la electrónica básica! 💖
#
# 🔗 Simulación en Wokwi: https://wokwi.com/projects/led-boton-kawaii
#
# 🌈🍓 Tema: Anime Kawaii con mucha ternura y lucecitas brillantes ✨
#
# 💕 Frase motivadora:
# "Cuando presiones el botón, deja que tu luz interior también brille." 🌸✨
#
# 🌟 Serie: ✧･ﾟ: *✧･ﾟ:* PICO MAGIC ACADEMY *:･ﾟ✧*:･ﾟ✧
# ✨🌸 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 🌸✨

/* =========================================================================
   FILENAME:    mul.s
   PROJECT:     Curso ARM64 en Raspberry Pi OS
   AUTHOR:      Juan Pérez <juan.perez@ejemplo.com>
   DATE:        2025-09-24
   VERSION:     v0.1
   LICENSE:     MIT

   PURPOSE:
     Este programa en ARM64 assembly multiplica dos enteros (6 * 3) y 
     muestra el resultado en la terminal de Raspberry Pi OS (aarch64).

   PLATFORM:
     Raspberry Pi OS de 64 bits (aarch64)
     ABI: AAPCS64 (argumentos en x0..x7, retorno en x0)

   BUILD:
     as -o mul.o mul.s       # ensamblar
     ld -o mul mul.o         # enlazar
     ./mul                   # ejecutar

   EXPORTS / SYMBOLS:
     _start   -- punto de entrada del programa

   OUTPUT:
     Imprime "18" en la consola (stdout)

   NOTES:
     Ejemplo didáctico. Valores fijos: 6 y 3.
   ========================================================================= */

/* ---------------- SOLUCIÓN EN C# (COMENTADA) -----------------
using System;
class Program {
  static void Main() {
    int a = 6, b = 3;
    int c = a * b;
    Console.WriteLine(c);
  }
}
---------------------------------------------------------------*/

/* ---------------- SOLUCIÓN EN C (COMENTADA) -----------------
#include <stdio.h>
int main() {
  int a = 6, b = 3;
  printf("%d\n", a*b);
  return 0;
}
---------------------------------------------------------------*/

    .text
    .global _start

_start:
    // Cargar operandos
    mov     x0, #6          // Guardamos 6 en el registro x0
    mov     x1, #3          // Guardamos 3 en el registro x1

    // Multiplicar
    mul     x2, x0, x1      // x2 = x0 * x1 = 18

    // ---- Preparar la cadena "18\n" para imprimir ----
    adrp    x3, result      // Dirección base de la etiqueta result
    add     x3, x3, :lo12:result // Dirección exacta de result

    // ---- Llamar a syscall write(fd=1, buf, len) ----
    mov     x0, #1          // fd = 1 (stdout)
    mov     x1, x3          // puntero al buffer "18\n"
    mov     x2, #3          // longitud del buffer
    mov     x8, #64         // número de syscall write en ARM64
    svc     #0              // llamada al sistema

    // ---- Terminar programa con syscall exit(0) ----
    mov     x0, #0          // código de salida = 0
    mov     x8, #93         // número de syscall exit en ARM64
    svc     #0              // llamada al sistema

    .data
result:
    .ascii  "18\n"          // Cadena a imprimir

    # Demo en Asciinema
[![asciicast](https://asciinema.org/a/iEXfVSXO1WdaTccIS4U3HSgEi.svg)](https://asciinema.org/a/iEXfVSXO1WdaTccIS4U3HSgEi)
