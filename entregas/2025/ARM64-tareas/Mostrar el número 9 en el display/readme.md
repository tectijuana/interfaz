#══════════════════════════════════════════════════════════════════════════╗
# ⚔️🏰  R O L E - P L A Y I N G   F A N T A S Y   C O D E 🧙✨               ║
#══════════════════════════════════════════════════════════════════════════╝
# 📚 Asignatura : Lenguajes de Interfaz en TECNM Campus ITT
# ✍️ Autor(a)   : Mario Leon Gasca
# 📅 Fecha      : 2025/09/24
# 🧾 Descripción: Mostrar el número 9 en el display
# 🔗 video : [Ejercicio básico en ARM64 Assembly](https://asciinema.org/a/EJX1J0WZdZJSGyBp0qDDARwDh)
#───────────────────────────────────────────────────────────────────────────
#        .-.
#       {{@}}  ──► El guardián vigila los pasillos del reino
#       8@8    ──► Si un enemigo se acerca… ¡la runa roja brillará!
#       888
#        ´"
#───────────────────────────────────────────────────────────────────────────
# 🌟 "Que tu código sea la espada, y la lógica tu escudo en la aventura." 🌟
#═══════════════════════════════════════════════════════════════════════════
# 🏹 Módulo:  **Guardianes del Código - La Alarma de la Fortaleza**
#═══════════════════════════════════════════════════════════════════════════

# Codigo en ensamblador:
```assembly
    .data
msg:    .asciz "Número 9 → patrón: 0x7B (gfedcba = 1111011)\n"
len = . - msg

    .text
    .global _start

_start:
    // write(int fd, const void *buf, size_t count)
    mov x8, #64         // syscall number write
    mov x0, #1          // fd = 1 (stdout)
    ldr x1, =msg        // dirección del mensaje
    mov x2, len         // longitud del mensaje
    svc #0              // syscall

    // exit(int status)
    mov x8, #93         // syscall number exit
    mov x0, #0
    svc #0
```
# Codigo en C#:

```csharp
using System;

class Program
{
    static void Main()
    {
        // Segmentos: a, b, c, d, e, f, g
        // Patrón para el número 9 = segmentos a, b, c, f, g encendidos
        // En formato gfedcba: 1111011 (binario) = 0x7B (hex)
        byte pattern = 0x7B;  

        Console.WriteLine("Número 9 → patrón de display:");
        Console.WriteLine($"Hex : 0x{pattern:X2}");
        Console.WriteLine($"Bin : {Convert.ToString(pattern, 2).PadLeft(7, '0')} (gfedcba)");
    }
}
```
