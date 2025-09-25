# 
# 🖥️ RETRO-CÓDIGO: MULTIPLICACIÓN EN ARM64 & C# 🖥️
# 
#
# 📚 Asignatura: Lenguajes de Interfaz – TECNM Campus ITT
# 👤 Autor: Cesar Gregorio Angel Montoya
# 📅 Fecha: 2025/09/24
# 🎯 Descripción: Programa que multiplica 6 × 3 en ARM64 Assembly y en C#, mostrando cómo ambos llegan al mismo resultado.

*ASCIINEMA*

https://asciinema.org/a/Q8T4V09F1CJRNe1MQP5Gp4G6R

*Codigo ARM64*

```asm
    .section .text
    .global main
    .type main, %function

/* main: multiplica 6 * 3 y devuelve el resultado en w0 */
main:
    mov     w0, #6        /* w0 = 6 (primer factor) */
    mov     w1, #3        /* w1 = 3 (segundo factor) */

    /* Multiplicación: w0 = w0 * w1 */
    mul     w0, w0, w1    /* w0 = 6 * 3 -> w0 = 18 */

    /* Retornar a llamador (en programa C esto devuelve el valor en w0) */
    ret

    .size main, . - main
```

*Codigo en C#*

```C#
using System;

class Program
{
    static void Main(string[] args)
    {
        // Declaracion dos enteros con valores fijos
        int a = 6;   // primer número
        int b = 3;   // segundo número

        // Multiplicacion de los dos enteros
        int resultado = a * b;   // aquí resultado == 18

        //resultado en consola
        Console.WriteLine("El resultado de {0} * {1} es {2}", a, b, resultado);

        // Salida del programa con el valor del resultado
        Environment.Exit(resultado);  
    
    }
}
```
