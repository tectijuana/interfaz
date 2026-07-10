# ┌───────────────────────────────────────────────────────────────────────────┐
# │ ███╗   ███╗ █████╗ ██████╗  ██████╗ ███████╗██████╗  ██████╗ ███████╗     │
# │ ████╗ ████║██╔══██╗██╔══██╗██╔═══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝     │
# │ ██╔████╔██║███████║██████╔╝██║   ██║█████╗  ██████╔╝██║   ██║█████╗       │
# │ ██║╚██╔╝██║██╔══██║██╔══██╗██║   ██║██╔══╝  ██╔══██╗██║   ██║██╔══╝       │
# │ ██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╔╝███████╗██║  ██║╚██████╔╝███████╗     │
# │ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     │
# └───────────────────────────────────────────────────────────────────────────┘
#  ╔══════════════════════════════════════════════════════════════════════╗
#  ║  Asignatura : Lenguajes de Interfaz - TECNM Campus ITT                 ║
#  ║  Autor      : GUALBERTO CASTRO                                         ║
#  ║  Fecha      : 2025/09/24                                               ║
#  ║  Descripción: Mostrar en consola "hola"                                ║
#  ║                                                                        ║
#  ╚══════════════════════════════════════════════════════════════════════╝
#
#
#  Tema       : Ejercicio basico en ARM64 Assembly
#  ASCIINEMA :https://asciinema.org/a/dhwfZiAa8gFn3OgH0WJOInL4I
#
#
#    nano hola.s 
#   //**************************************************************
#   // Autor:Gualberto Castro 
#   // Fecha: 2025-09-24
#   // Programa: hola.s
#   // Descripción: Muestra "Hola" en la consola de Ubuntu
#   //**************************************************************
#
#                .section .data
#     mensaje: 
#                .ascii "Hola\n"        // Cadena a imprimir
#                len = . - mensaje          // Calcula longitud de la cadena
#
#                   .section .text
#                   .global _start
# 
#                    _start:
#                             // write(int fd, const void *buf, size_t count)
#                                mov x8, 64              // syscall number 64 = write
#                                mov x0, 1               // fd = 1 (stdout)
#                                ldr x1, =mensaje        // dirección del buffer
#                                mov x2, len             // longitud
#                                svc 0                   // llamada al sistema
#
#                               // exit(int status)
#                                  mov x8, 93              // syscall number 93 = exit
#                                  mov x0, 0               // status = 0
#                                  svc 0
#
#     as -o hola.o hola.s
#     ld -o hola hola.o 
#     ./hola
#  
#
#  Propósito breve:
#  Le terminal debe mostrar "hola"  
#
# 
#  
#
# ────────────────────────────────────────────────────────────────────────────
