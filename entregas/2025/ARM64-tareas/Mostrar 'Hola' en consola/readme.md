/*======================================================================*
 | 👾⚔️  R P G   -   C O D E   Q U E S T                               |
 |----------------------------------------------------------------------|
 | 📚 Asignatura : Lenguajes de Interfaz - TECNM Campus ITT            |
 | ✍️ Autor      : Jose Angel Mojica Fajardo                           |
 | 📅 Fecha      : 2025/09/23                                          |
 | 📝 Descripción: Programa en ARM64 Assembly que muestra "Hola" en     |
 |               consola, primer reto del héroe en el mundo del código.|
 | 🌐 Simulación : https://wokwi.com/projects/arm64-holamundo           |
 | 🎥 Video      : https://asciinema.org/a/742829                      |
 *======================================================================*
 | ⚡ "Tu espada es el ensamblador, tu misión: domar la máquina" ⚡      |
 *======================================================================*/

.global _start

.section .data
msg:    .ascii  "Hola\n"          // Cadena a imprimir
len = . - msg                     // Longitud de la cadena

.section .text
_start:
    // write(int fd, const void *buf, size_t count)
    mov     x8, 64        // syscall number (write en AArch64 Linux)
    mov     x0, 1         // file descriptor 1 = stdout
    ldr     x1, =msg      // dirección del mensaje
    mov     x2, len       // longitud del mensaje
    svc     0             // llamada al sistema

    // exit(0)
    mov     x8, 93        // syscall number (exit en AArch64 Linux)
    mov     x0, 0         // código de salida 0
    svc     0
