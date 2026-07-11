# ███████╗██╗███╗   ██╗     ██████╗██╗ ██████╗██╗      ██████╗  ██████╗ 
# ██╔════╝██║████╗  ██║    ██╔════╝██║██╔════╝██║     ██╔═══██╗██╔════╝ 
# █████╗  ██║██╔██╗ ██║    ██║     ██║██║     ██║     ██║   ██║██║  ███╗
# ██╔══╝  ██║██║╚██╗██║    ██║     ██║██║     ██║     ██║   ██║██║   ██║
# ██║     ██║██║ ╚████║    ╚██████╗██║╚██████╗███████╗╚██████╔╝╚██████╔╝
# ╚═╝     ╚═╝╚═╝  ╚═══╝     ╚═════╝╚═╝ ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ 
#                      🎬 UNA PRODUCCIÓN ORIGINAL DE TECNM                      
#                            ⏳ FIN DE CICLO: TEMPORADA ARM64                          
#===============================================================================
# 📚 Asignatura: Lenguajes de Interfaz en TECNM Campus ITT
# 👨‍💻 Autor: Serna Sauceda Jose Enrique
# 📅 Fecha: 2025/09/24
# 🧾 Descripción: Muestra 'FIN' al completar un ciclo for en ensamblador.
# 🕹️ Plataforma: ARM64 - Ubuntu 24.04 / Raspbian OS
# 🔗 Simulación en Wokwi: https://wokwi.com/projects/fin-de-ciclo-arm64
#===============================================================================
# 🎯 Episodio final: “El bucle se cierra, pero la historia continúa...”
#===============================================================================

## CÓDIGO  
  ```asm
  //====================================================
// Archivo: fin_ciclo.s
// Descripción: Muestra 'FIN' al terminar un ciclo
// Plataforma: ARM64 - Ubuntu 24.04 / Raspbian OS
// Autor: Serna Sauceda Jose Enrique
// Fecha: 24/09/2025
//====================================================

.section .data
msg:    .asciz "FIN\n"      // Mensaje a imprimir

.section .text
.global main
.extern printf              // Función externa de libc

main:
    // --- Inicializar contador i = 1 ---
    mov x19, #1             // x19 será nuestra variable i

loop_start:
    // --- Comparar i <= 5 ---
    cmp x19, #5
    bgt loop_end            // Si i > 5, termina el ciclo

    // Aquí podrías imprimir i o hacer otra acción...

    // --- Incrementar i ---
    add x19, x19, #1
    b loop_start            // Volver al inicio del ciclo

loop_end:
    // --- Mostrar "FIN" ---
    ldr x0, =msg            // x0: dirección del string "FIN"
    bl printf               // printf("FIN\n");

    // --- Salir del programa con syscall exit(0) ---
    mov x8, #93             // syscall número para exit
    mov x0, #0              // código de salida 0
    svc #0
  ```
## GRABACIÓN EN ASCIINEMA
  https://asciinema.org/a/QCfnUycQBTVxoXOlapciDmTh3


  
