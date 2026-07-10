// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : main.s                                         ║
// ║  Autor    : <Nombre Apellido> <No. de control>             ║
// ║  Curso    : Lenguajes de Interfaz SCC-1014                 ║
// ║  Fecha    : <AAAA-MM-DD>                                   ║
// ║  Descripción: <qué hace el programa>                       ║
// ╚══════════════════════════════════════════════════════════╝

        .section .data
msg:    .asciz  "Hola Mundo en ARM64\n"
len     =       . - msg - 1          // longitud sin el NUL

        .section .text
        .global _start

_start:
        // write(fd=1, buf=msg, count=len)
        mov     x8, #64              // syscall write (AArch64)
        mov     x0, #1               // stdout
        ldr     x1, =msg
        mov     x2, #len
        svc     #0

        // exit(0)
        mov     x8, #93              // syscall exit
        mov     x0, #0
        svc     #0

// Conclusiones/Observaciones:
// - <qué aprendiste, qué ajustaste, cómo validaste>
