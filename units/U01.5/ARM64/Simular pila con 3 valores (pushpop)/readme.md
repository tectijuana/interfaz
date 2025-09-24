ALUMNO: Javier fernandez Cortez
No. de control: 22211558
actividad: Simular pila con 3 valores
<img width="706" height="258" alt="image" src="https://github.com/user-attachments/assets/55146850-9143-4cc8-9332-c9dfa0b3d184" />


<img width="710" height="573" alt="image" src="https://github.com/user-attachments/assets/6fb5880a-e486-494f-97df-55031b55533e" />

```text
//=========================================================
// Simulación de una pila en ARM64 Assembly (AArch64)
// PUSH de 3 valores (10, 20, 30) y POP en orden inverso
// con impresión en consola usando syscall write
//=========================================================

.global _start

.section .data
msg1: .asciz "POP 1: "
msg2: .asciz "POP 2: "
msg3: .asciz "POP 3: "
nl:   .asciz "\n"

.section .bss
numbuf: .skip 20    // buffer para número convertido a texto

.section .text
_start:

    // --- PUSH valores ---
    MOV     X0, #10
    STR     X0, [SP, #-16]!   // PUSH 10

    MOV     X0, #20
    STR     X0, [SP, #-16]!   // PUSH 20

    MOV     X0, #30
    STR     X0, [SP, #-16]!   // PUSH 30

    // --- POP valores ---
    LDR     X1, [SP], #16    // POP -> X1 = 30
    LDR     X2, [SP], #16    // POP -> X2 = 20
    LDR     X3, [SP], #16    // POP -> X3 = 10

    // Imprimir POP 1 (X1)
    ADR     X0, msg1
    BL      print_str
    MOV     X0, X1
    BL      print_int
    ADR     X0, nl
    BL      print_str

    // Imprimir POP 2 (X2)
    ADR     X0, msg2
    BL      print_str
    MOV     X0, X2
    BL      print_int
    ADR     X0, nl
    BL      print_str

    // Imprimir POP 3 (X3)
    ADR     X0, msg3
    BL      print_str
    MOV     X0, X3
    BL      print_int
    ADR     X0, nl
    BL      print_str

    // salir
    MOV     X8, #93       // syscall: exit
    MOV     X0, #0
    SVC     #0

//---------------------------------------------------------
// Subrutina: print_str (X0 = puntero a string 0-terminado)
print_str:
    // calcular longitud de string
    MOV     X1, X0          // dirección del string
    MOV     X2, #0
len_loop:
    LDRB    W3, [X1, X2]
    CBZ     W3, do_write
    ADD     X2, X2, #1
    B       len_loop

do_write:
    MOV     X1, X0          // buffer
    MOV     X0, #1          // fd = stdout
    MOV     X8, #64         // syscall: write
    SVC     #0
    RET

//---------------------------------------------------------
// Subrutina: print_int (X0 = número a imprimir)
print_int:
    MOV     X1, X0          // número a convertir
    ADR     X2, numbuf
    ADD     X2, X2, #19     // apuntar al final del buffer
    MOV     X6, #10         // divisor = 10

1:  UDIV    X4, X1, X6      // X4 = X1 / 10
    MUL     X5, X4, X6      // X5 = X4 * 10
    SUB     X5, X1, X5      // X5 = residuo
    ADD     X5, X5, #'0'    // convertir a ASCII
    STRB    W5, [X2], #-1   // guardar en buffer
    MOV     X1, X4
    CBNZ    X1, 1b

    ADD     X2, X2, #1      // X2 apunta al primer dígito

    // calcular longitud: (numbuf+20) - X2
    ADR     X7, numbuf
    ADD     X7, X7, #20
    SUB     X7, X7, X2

    // write(fd=1, buf=X2, len=X7)
    MOV     X0, #1          // fd=stdout
    MOV     X1, X2          // buf
    MOV     X2, X7          // len
    MOV     X8, #64         // syscall: write
    SVC     #0
    RET
```



