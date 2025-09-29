# 🖥️ Práctica: Secuencia Fibonacci en ARM64 (AWS Ubuntu)

## 👨‍💻 Datos del estudiante
- **Nombre:** Alberto Carlos Ruvalcaba Fernandez
- **Materia:** Programación en Ensamblador ARM64
- **Entorno:** AWS EC2 Ubuntu 24.04 LTS (ARM64 / AArch64)

---

## 📌 Objetivo
Implementar en **ensamblador ARM64** un programa que calcule e imprima los primeros **5 términos de la secuencia de Fibonacci** en una instancia virtual **Ubuntu ARM64**.

---

## 🔧 Herramientas utilizadas
- `gcc` → compilador para ensamblador ARM64.  
- `nano` → editor de texto en terminal.  
- `asciinema` → grabador de sesiones de terminal.  
- **Lenguaje**: Ensamblador ARM64 (AArch64).  

---

## 📄 Código fuente

Archivo: `fibonacci.s`

```asm
/**************************************************************
 * Programador: Alberto Carlos Ruvalcaba Fernandez
 * Fecha: 25/09/2025
 * Proyecto: Fibonacci - primeros 5 términos (ARM64 / AArch64)
 * Descripción:
 *   Calcula e imprime los primeros 5 números de la secuencia
 *   de Fibonacci (0,1,1,2,3) usando ensamblador para ARM64.
 **************************************************************/

/*  --- Versión en C (referencia) ---
#include <stdio.h>
int main() {
    long a = 0, b = 1, c;
    printf("%ld\n", a);
    printf("%ld\n", b);
    for (int i = 2; i < 5; ++i) {
        c = a + b;
        printf("%ld\n", c);
        a = b;
        b = c;
    }
    return 0;
}
*/

    .global main
    .extern printf

    .section .data
fmt:    .asciz "%ld\n"    // formato para imprimir long (64-bit)

    .section .text
main:
    mov     x19, #0       // a = 0
    mov     x20, #1       // b = 1
    mov     x21, #2       // i = 2

    // imprimir a
    ldr     x0, =fmt
    mov     x1, x19
    bl      printf

    // imprimir b
    ldr     x0, =fmt
    mov     x1, x20
    bl      printf

loop:
    cmp     x21, #5
    b.ge    end_loop

    // c = a + b
    add     x22, x19, x20

    // imprimir c
    ldr     x0, =fmt
    mov     x1, x22
    bl      printf

    // actualizar a = b ; b = c
    mov     x19, x20
    mov     x20, x22

    add     x21, x21, #1
    b       loop

end_loop:
    mov     x0, #0
    ret
