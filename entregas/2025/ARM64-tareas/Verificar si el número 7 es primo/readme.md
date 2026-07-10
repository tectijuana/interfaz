/* ============================================================
   prime_check_arm64.s
   GitHub · ARM64 · Linux

   📚 Asignatura : Lenguajes de Interfaz en TECNM Campus ITT
   👤 Autor      : [Osuna Jose Manuel]
   📅 Fecha      : 2025/09/25
   📝 Descripción: Ensamblador AArch64 (Linux) que verifica
                 si el número 7 es primo e imprime el resultado
                 usando syscall write/exit.
   🔗 Simulación : https://asciinema.org/a/743549 ;

   Instrucciones de compilación (en máquina ARM64 o con toolchain aarch64-linux-gnu):
     as --64 -o prime_check_arm64.o prime_check_arm64.s
     ld -o prime_check_arm64 prime_check_arm64.o
   O con gcc:
     aarch64-linux-gnu-gcc -nostdlib -static -o prime_check_arm64 prime_check_arm64.s

   Prueba en QEMU (si no tienes hardware ARM64):
     qemu-aarch64 ./prime_check_arm64

   Lema: "Compila, inspecciona, conquista: Crónicas ARM64"
   ============================================================
*/

    .section .data
msg_primo:      .asciz "7 es primo\n"
msg_noprimo:    .asciz "7 NO es primo\n"

    .section .text
    .global _start
    .align 2

_start:
    // n = 7
    mov     x0, #7          // número a verificar (n)
    mov     x1, #1          // esPrimo = true (no usado como bandera luego)

    // si n <= 1 -> no primo
    cmp     x0, #1
    ble     not_prime

    // i = 2
    mov     x2, #2

loop:
    // if i*i > n -> done_check
    mul     x3, x2, x2      // x3 = i * i
    cmp     x3, x0
    bgt     done_check

    // if n % i == 0 -> not_prime
    udiv    x4, x0, x2      // x4 = n / i
    msub    x5, x4, x2, x0  // x5 = n - (x4 * i)  == n % i
    cbz     x5, not_prime

    // i++
    add     x2, x2, #1
    b       loop

done_check:
    // write(1, msg_primo, len)
    mov     x0, #1                  // fd = 1 (stdout)
    adrp    x1, msg_primo
    add     x1, x1, :lo12:msg_primo
    mov     x2, #11                 // len("7 es primo\n") == 11
    mov     x8, #64                 // syscall: write (AArch64 Linux)
    svc     #0
    b       exit

not_prime:
    mov     x0, #1                  // fd = 1 (stdout)
    adrp    x1, msg_noprimo
    add     x1, x1, :lo12:msg_noprimo
    mov     x2, #15                 // len("7 NO es primo\n") == 15
    mov     x8, #64                 // syscall: write
    svc     #0

exit:
    mov     x8, #93                 // syscall: exit (AArch64 Linux)
    mov     x0, #0
    svc     #0
