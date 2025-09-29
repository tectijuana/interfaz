║ 📘 ASIGNATURA: Lenguajes de Interfaz en TECNM Campus ITT           ║
# ║ 👨‍💻 AUTOR: Oscar Francisco Alonso Sanchez                         ║
# ║ 🆔 NÚM. CONTROL: 23210539                                          ║
# ║ 📅 FECHA: 2025/09/24                                               ║
# ║ 🧮 DESCRIPCIÓN: Programa sencillo que suma dos números (3 + 5).    ║
# ║ 🔗 SIMULACIÓN: https://asciinema.org/a/GafznRw9gzfDVEtfc6d2tUKzw  ║
# ╚════════════════════════════════════════════════════════════════════╝
#          🧠 "Codifica como si el futuro dependiera de ti" 🧠         

```asm
  .section .data
msg:    .ascii  "La suma de 5 + 3 = 8\n"
len = . - msg

    .section .text
    .global _start
_start:
    // sys_write(int fd, const void *buf, size_t count)
    mov     x0, #1            // fd = 1 (stdout)
    ldr     x1, =msg           // buf = dirección de msg
    mov     x2, #len           // count = longitud del mensaje
    mov     w8, #64            // número de syscall: write = 64 en ARM64 :contentReference[oaicite:0]{index=0}
    svc     #0                 // invoca al kernel

    // sys_exit(int status)
    mov     x0, #0              // código de salida = 0
    mov     w8, #93             // número de syscall: exit = 93 :contentReference[oaicite:1]{index=1}
    svc     #0
