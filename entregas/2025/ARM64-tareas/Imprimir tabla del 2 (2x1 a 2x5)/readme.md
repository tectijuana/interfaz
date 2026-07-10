## ╭─────────────────────────────────────────────╮
## 🍬🍭🍫   IMPRIMIR TABLA DEL 2 (2X1 A 2X5)   🍫🍭🍬
## ╰─────────────────────────────────────────────╯

---

#### 🌸 Asignatura: Lenguajes de Interfaz - TECNM ITT  
#### 🍓 Alumna: Estephania Esqueda Cardenas  
#### 📅 Fecha: 2025/09/23  
#### 🍧 Grabación: [Ver en Asciinema](https://asciinema.org/a/XdnndemxlljpCTWu2Rrd5Ne9t)  

##### (｡♥‿♥｡) 🍡 (✿◕‿◕✿) 🍨 (´｡• ᵕ •｡`) 🍬 (>‿◠)✌  

---

## 📜 Código en ARM64 Assembly

```asm
    .section .data
msg:    .asciz "2 x %d = %d\n"

    .section .text
    .global main
    .extern printf

main:
    // Prologo
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x19, 1          // i = 1 en x19

loop:
    mov x20, 2          // constante 2
    mul x21, x19, x20   // x21 = 2 * i

    // printf("2 x %d = %d\n", i, 2*i);
    ldr x0, =msg        // primer argumento = dirección del string
    mov x1, x19         // primer %d = i
    mov x2, x21         // segundo %d = 2*i
    bl printf

    add x19, x19, 1     // i++
    cmp x19, 6
    blt loop

    // Epilogo
    ldp x29, x30, [sp], 16
    mov w0, 0
    ret

```
### Programa: Tabla del 2 (2x1 a 2x5)
#### Autor: Estephania Esqueda Cardenas
#### Descripción: Imprime la tabla del 2 usando un ciclo for
```asm
for i in range(1, 6):          # i toma valores del 1 al 5
    resultado = 2 * i           # multiplicación: 2 por i
    print(f"2 x {i} = {resultado}")  # imprime en formato

