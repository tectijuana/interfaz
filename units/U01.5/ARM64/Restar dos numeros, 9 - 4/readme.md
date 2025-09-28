
# ╔══════════════════════════════════════════════════════════════════════════╗
# ║   ██████╗ ██╗   ██╗██████╗ ██████╗ ██╗   ██╗██████╗ ██╗   ██╗███╗   ██╗   ║
# ║  ██╔═══██╗██║   ██║██╔══██╗██╔══██╗██║   ██║██╔══██╗██║   ██║████╗  ██║   ║
# ║  ██║   ██║██║   ██║██████╔╝██║  ██║██║   ██║██████╔╝██║   ██║██╔██╗ ██║   ║
# ║  ██║▄▄ ██║██║   ██║██╔═══╝ ██║  ██║██║   ██║██╔═══╝ ██║   ██║██║╚██╗██║   ║
# ║  ╚██████╔╝╚██████╔╝██║     ██████╔╝╚██████╔╝██║     ╚██████╔╝██║ ╚████║   ║
# ║   ╚══▀▀═╝  ╚═════╝ ╚═╝     ╚═════╝  ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═══╝   ║
# ║                  ✦ CYBERPUNK NUMERIC OPS ✦                               ║
# ╚══════════════════════════════════════════════════════════════════════════╝
# Asignatura : Lenguajes de Interfaz - TECNM Campus ITT
### Autor      : Axel Alvarez Estrada
### Matricula  : 23210542
### Fecha      : 2025/09/28
# Descripción:
##   Código que realiza la resta de dos números enteros
# Video Asciinema
# https://asciinema.org/a/744742   
# Codigo en ARM 64
```

    .global _start            // Punto de entrada del programa

    .data
msg:    .asciz "Resultado: %d\n"   // Formato de impresión para printf

    .text
_start:
    // Cargar valores en registros
    mov x0, 9            // x0 = 9
    mov x1, 4            // x1 = 4

    // Realizar la resta
    sub x2, x0, x1       // x2 = x0 - x1 = 9 - 4 = 5

    // Llamar a printf("Resultado: %d\n", x2)
    ldr x0, =msg         // Dirección del string
    mov x1, x2           // Argumento (resultado)
    bl printf            // Llamar a la libc

    // Salir del programa
    mov x8, 93           // syscall exit
    mov x0, 0            // código de retorno = 0
    svc 0

#   INPUT:  num1, num2
#   OUTPUT: resultado = num1 - num2
#   Efectos visuales: ≡≡≡ SIGNAL ∴ NEON ∴ CIRCUITS ≡≡≡
```
# Codigo en C
```
// Autor: [Tu Nombre]
// Fecha: 28/09/2025
// Objetivo: Programa en C# que resta 9 - 4 e imprime el resultado

using System;

class Program
{
    static void Main()
    {
        int a = 9;
        int b = 4;
        int c = a - b;

        Console.WriteLine("Resultado: " + c);
    }
}
```          


