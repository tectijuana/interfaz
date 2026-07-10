<div align="center">

# Mostrar 'TEC' letra por letra  

**Universidad:** Instituto Tecnológico de Tijuana  
**Materia:** Lenguaje de Interfaz  
**Tema:** Mostrar 'TEC' letra por letra  

---

**Alumno:** José Eduardo Elizondo Romero  
**Número de Control:** 22210303  
**Profesor:** RENE SOLIS REYES  
**Fecha:** 25 de septiembre de 2025  
 **Descripción:**  Programa para mostrar las letras "T", "E", "C" una por línea.     
  Incluye versiones en varios lenguajes y código ensamblador AArch64.
</div>

---

<div align="justify">

**Codigo de alto Nivel en C#**

using System;

using System.Threading;

 class MostrarTec
 {

    static void Main()
    {
        string[] letras = { "T", "E", "C" };

        foreach (var l in letras)
        {
            Console.WriteLine(l);     // imprime letra en su propia línea
            //Thread.Sleep(1000);     // descomenta para pausa de 1 s
        }
    }
}

------------------------------------------------------------

**compilar o ejecutar**

 **con mcs / mono**
 
mcs MostrarTec.cs

mono MostrarTec.exe

------------------------------------------------------------

**Programa ASM64 (AArch64)**


   mostrar_tec.s - AArch64 (ARM64) - Linux
   
   Muestra las letras T, E, C, cada una en su propia línea.
   
   Ensamblar: as -o mostrar_tec.o mostrar_tec.s
   
   Enlazar:   ld -o mostrar_tec mostrar_tec.o
   

    .section .data
/* Definimos los mensajes (cada uno termina con '\n') */
msg1:

    .ascii "T\n"            /* mensaje 1: 'T' + newline */
msg1_end:

    .equ len1, msg1_end - msg1   /* longitud de msg1 */

msg2:

    .ascii "E\n"            /* mensaje 2: 'E' + newline */
msg2_end:

    .equ len2, msg2_end - msg2

msg3:

    .ascii "C\n"            /* mensaje 3: 'C' + newline */
msg3_end:

    .equ len3, msg3_end - msg3

    .section .text
    .global _start

_start:

    /* -- write(1, msg1, len1) -- */
    mov     x0, #1          /* x0 = file descriptor 1 (stdout) */
    ldr     x1, =msg1       /* x1 = dirección de msg1 (buffer) */
    mov     x2, #len1       /* x2 = cantidad de bytes a escribir */
    mov     x8, #64         /* x8 = syscall number 64 = write (AArch64) */
    svc     #0              /* invocar syscall */

    /* -- write(1, msg2, len2) -- */
    mov     x0, #1
    ldr     x1, =msg2
    mov     x2, #len2
    mov     x8, #64
    svc     #0

    /* -- write(1, msg3, len3) -- */
    mov     x0, #1
    ldr     x1, =msg3
    mov     x2, #len3
    mov     x8, #64
    svc     #0

    /* -- exit(0) -- */
    mov     x0, #0          /* código de salida 0 */
    mov     x8, #93         /* syscall number 93 = exit (AArch64) */
    svc     #0

**Ensamblar y enlazar (opción con as/ld)**

as -o mostrar_tec.o mostrar_tec.s

ld -o mostrar_tec mostrar_tec.o

Dar permisos y ejecutar

chmod +x mostrar_tec

./mostrar_tec

**Alternativa de Ensamblar e enlazar**

gcc -nostdlib -o mostrar_tec mostrar_tec.s

./mostrar_tec


**Salida esperada**

 T
 E
 C

**Evidencia del Funcionamiento:**
https://asciinema.org/a/6bWukFoT5Jb9xQJhmpATcl2cJ

