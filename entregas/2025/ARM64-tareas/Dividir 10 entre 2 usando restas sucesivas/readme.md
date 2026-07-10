# ☠️⚓━━━━━━━[ PIRATE CODE ]━━━━━━━⚓☠️
### 📚 Asignatura : Lenguajes de Interfaz - TECNM Campus ITT
#### ✍️ Autor      : Lavenant Baldenebro Gilbeto
### 📅 Fecha      : 2025/09/23
###
### 🏴 Propósito : Un tesoro de lógica y código oculto en los mares digitales del aprendizaje.
###
###
### ❝ El que no programa, no encuentra el tesoro ❞
## ☠️⚓━━━━━━━[ Fin del Módulo: Seven Seas of Code ]━━━━━━━⚓☠️



```text
    .section .data
fmt:
    .asciz "10 / 2 = %d rem %d\n"    // formato para printf (cociente, resto)

    .section .text
    .global main
    .type main, @function

main:
    // Prologue (ninguna reserva de pila especial es necesaria aquí)
    // Inicializar valores:
    mov     w19, #10        // w19 = dividendo (10)
    mov     w20, #2         // w20 = divisor (2)
    mov     w21, #0         // w21 = cociente (0)

loop:
    // comparar si dividendo >= divisor
    cmp     w19, w20
    blt     done            // si dividendo < divisor saltar a done

    // dividendo = dividendo - divisor
    sub     w19, w19, w20

    // cociente = cociente + 1
    add     w21, w21, #1

    // repetir
    b       loop

done:
    // Preparar llamada a printf:
    // printf("10 / 2 = %d rem %d\n", cociente, resto)
    // formato -> x0, argumentos -> x1, x2 (en ARM64 el primer arg en x0, luego x1, x2, x3, ...)
    adrp    x0, fmt
    add     x0, x0, :lo12:fmt
    // mover valores enteros a registros de 32 bits para printf %d
    mov     w1, w21        // primer %d = cociente
    mov     w2, w19        // segundo %d = resto

    // llamar a printf (vinculado con libc al compilar con gcc)
    bl      printf

    // devolver 0
    mov     w0, #0
    ret

```
# <img width="619" height="534" alt="image" src="https://github.com/user-attachments/assets/dfeae1f8-d47a-4783-9804-059a4d9c38a7" />
# <img width="200" height="178" alt="image" src="https://github.com/user-attachments/assets/d3e19652-768a-47f0-b947-6e4ac050ee24" />
