// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : main.s (P03 — Captura básica de cadenas)      ║
// ║  Autor    : <Nombre Apellido> <No. de control>             ║
// ║  Curso    : Lenguajes de Interfaz SCC-1014                 ║
// ║  Fecha    : <AAAA-MM-DD>                                   ║
// ║  Descripción: Lee el nombre del usuario desde stdin con    ║
// ║  la syscall read y lo saluda. Subtemas 2.3 y 2.8.          ║
// ╚══════════════════════════════════════════════════════════╝

        .section .data
prompt: .asciz  "Como te llamas? "
plen    =       . - prompt - 1
saludo: .asciz  "Hola, "
slen    =       . - saludo - 1

        .section .bss
buf:    .skip   64                   // buffer para la cadena capturada

        .section .text
        .global _start

_start:
        // write(1, prompt, plen) — pregunta sin salto de línea
        mov     x8, #64
        mov     x0, #1
        ldr     x1, =prompt
        mov     x2, #plen
        svc     #0

        // read(0, buf, 64) — captura desde stdin
        // Regresa en x0 el número de bytes leídos (incluye el '\n' final)
        mov     x8, #63              // syscall read
        mov     x0, #0               // fd = 0 (stdin)
        ldr     x1, =buf
        mov     x2, #64              // capacidad máxima del buffer
        svc     #0
        mov     x19, x0              // guardar longitud capturada

        // write(1, saludo, slen)
        mov     x8, #64
        mov     x0, #1
        ldr     x1, =saludo
        mov     x2, #slen
        svc     #0

        // write(1, buf, x19) — eco de la cadena capturada
        // (la longitud REAL viene de read; no se asume tamaño fijo)
        mov     x8, #64
        mov     x0, #1
        ldr     x1, =buf
        mov     x2, x19
        svc     #0

        // exit(0)
        mov     x8, #93
        mov     x0, #0
        svc     #0

// Conclusiones/Observaciones:
// - <por qué la longitud del write final debe venir de x19 y no ser constante>
// - <qué pasa si el usuario escribe más de 64 caracteres>
