```python

#  ███╗   ██╗ ███████╗ █████╗ ██████╗ ███████╗    ██╗  ██╗███████╗██████╗ 
#  ████╗  ██║ ██╔════╝██╔══██╗██╔══██╗██╔════╝    ██║  ██║██╔════╝██╔══██╗
#  ██╔██╗ ██║ █████╗  ███████║██████╔╝█████╗      ███████║█████╗  ██████╔╝
#  ██║╚██╗██║ ██╔══╝  ██╔══██║██╔══██╗██╔══╝      ██╔══██║██╔══╝  ██╔══██╗
#  ██║ ╚████║ ███████╗██║  ██║██║  ██║███████╗    ██║  ██║███████╗██║  ██║
#  ╚═╝  ╚═══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
#
#   ╔══════════════════════════════════════════════════════════════════╗
#   ║  ASIGNATURA: Lenguajes de Interfaz en TECNM Campus ITT           ║
#   ║  AUTOR(A):  Jonathan Bedoy ALvarez                                ║
#   ║  FECHA:     2025/09/25                                            ║
#   ║  PROPOSITO: Detectar si un número es par o impar (7)              ║
#   ║                                                                   ║
#   ╚══════════════════════════════════════════════════════════════════╝
#  
#   » Frase motivadora: "Hackea la noche: cada semáforo es un pulso
#     en la ciudad. Aprende a dominar el tiempo." ✦
```
video : [Ejercicio básico en ARM64 Assembly](https://asciinema.org/a/3FN1yuNWGGdLoift6h8zMysZW)
# Codigo de ensamblador:
```assembly
.data
num:        .word   7                // número a evaluar (ejemplo: 7)
msg_par:    .asciz  "PAR\n"
msg_impar:  .asciz  "IMPAR\n"

    .text
    .global _start

_start:
    // Cargar número en w0
    ldr     w0, num

    // Revisar el último bit
    and     w1, w0, #1        // w1 = num & 1
    cbz     w1, es_par        // si w1 == 0 → es PAR

es_impar:
    // Escribir "IMPAR\n"
    mov     x0, #1            // fd = 1 (stdout)
    ldr     x1, =msg_impar    // buffer
    mov     x2, #6            // longitud de "IMPAR\n"
    mov     x8, #64           // syscall: write (64 en AArch64)
    svc     #0
    b       salir

es_par:
    // Escribir "PAR\n"
    mov     x0, #1            // fd = 1
    ldr     x1, =msg_par
    mov     x2, #4            // longitud de "PAR\n"
    mov     x8, #64           // syscall: write
    svc     #0

salir:
    mov     x0, #0            // exit code = 0
    mov     x8, #93           // syscall: exit
    svc     #0
```
# Codigo de C#:
```C#
using System;
using System.Runtime.InteropServices;

class Program
{
    // Importamos la función desde libnative.so
    [DllImport("libnative.so", EntryPoint="is_even", CallingConvention = CallingConvention.Cdecl)]
    public static extern int IsEven(int number);

    static void Main()
    {
        int num = 7; // Número a probar
        int result = IsEven(num);

        if (result == 1)
            Console.WriteLine($"{num} es PAR");
        else
            Console.WriteLine($"{num} es IMPAR");
    }
}
```
