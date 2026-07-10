// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : main.s (P04 — Operaciones básicas de archivo) ║
// ║  Autor    : <Nombre Apellido> <No. de control>             ║
// ║  Curso    : Lenguajes de Interfaz SCC-1014                 ║
// ║  Fecha    : <AAAA-MM-DD>                                   ║
// ║  Descripción: Crea datos.txt, escribe un mensaje, lo       ║
// ║  cierra, lo reabre, lo lee y lo imprime. Subtema 2.16.     ║
// ╚══════════════════════════════════════════════════════════╝
//
// Syscalls AArch64 usadas:
//   openat = 56   close = 57   read = 63   write = 64   exit = 93
// openat sustituye a open: el primer argumento AT_FDCWD (-100)
// significa "ruta relativa al directorio actual".

        .equ    AT_FDCWD, -100
        .equ    O_RDONLY, 0
        .equ    O_CREAT_WRONLY_TRUNC, 0x241   // O_WRONLY|O_CREAT|O_TRUNC

        .section .data
ruta:   .asciz  "datos.txt"
msg:    .asciz  "Registro guardado en disco desde ASM\n"
mlen    =       . - msg - 1
errtxt: .asciz  "Error de archivo\n"
elen    =       . - errtxt - 1

        .section .bss
buf:    .skip   64

        .section .text
        .global _start

_start:
        // ---- 1) Crear/abrir para escritura ----
        // openat(AT_FDCWD, ruta, O_WRONLY|O_CREAT|O_TRUNC, 0644)
        mov     x8, #56
        mov     x0, #AT_FDCWD
        ldr     x1, =ruta
        mov     x2, #O_CREAT_WRONLY_TRUNC
        mov     x3, #0644                     // permisos rw-r--r-- (octal)
        svc     #0
        tbnz    x0, #63, error                // fd negativo = error
        mov     x19, x0                       // conservar fd

        // ---- 2) Escribir el mensaje al archivo ----
        mov     x8, #64
        mov     x0, x19
        ldr     x1, =msg
        mov     x2, #mlen
        svc     #0

        // ---- 3) Cerrar ----
        mov     x8, #57
        mov     x0, x19
        svc     #0

        // ---- 4) Reabrir solo lectura ----
        mov     x8, #56
        mov     x0, #AT_FDCWD
        ldr     x1, =ruta
        mov     x2, #O_RDONLY
        mov     x3, #0
        svc     #0
        tbnz    x0, #63, error
        mov     x19, x0

        // ---- 5) Leer el contenido ----
        mov     x8, #63
        mov     x0, x19
        ldr     x1, =buf
        mov     x2, #64
        svc     #0
        mov     x20, x0                       // bytes leídos

        // ---- 6) Cerrar ----
        mov     x8, #57
        mov     x0, x19
        svc     #0

        // ---- 7) Mostrar en pantalla lo leído del disco ----
        mov     x8, #64
        mov     x0, #1
        ldr     x1, =buf
        mov     x2, x20
        svc     #0

        // exit(0)
        mov     x8, #93
        mov     x0, #0
        svc     #0

error:
        mov     x8, #64
        mov     x0, #1
        ldr     x1, =errtxt
        mov     x2, #elen
        svc     #0
        mov     x8, #93
        mov     x0, #1
        svc     #0

// Conclusiones/Observaciones:
// - <qué es un descriptor de archivo y por qué se guarda en x19>
// - <qué hace O_TRUNC; qué pasaría sin él en la segunda corrida>
