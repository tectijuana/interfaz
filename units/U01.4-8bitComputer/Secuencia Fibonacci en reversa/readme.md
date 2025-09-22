Alumno: Angel Gabriel Angulo Marentes 
No.Control: 222115522
Practica: Emulador 8 bit assembler Secuencia Fibonacci en Reversa

```text
; SECUENCIA FIBONACCI EN REVERSA
; Muestra valores en el display decimal (registro Rd)
; y escribe un mensaje en el LCD al iniciar

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

start:
    ; --- Inicializar LCD ---
    clra
    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

    ; --- Escribir mensaje ---
    data Ra, mensaje
    call printStr

.begin:
    data Rb, 144    ; F(12)
    data Rd, 233    ; F(13)

.loop:	
    mov Rc, Rd      ; copiar F(n) en Rc
    sub Rc, Rb      ; Rc = F(n) - F(n-1)
    mov Rd, Rb      ; mostrar F(n-1) en el display decimal
    mov Rb, Rc      ; actualizar F(n-1)
    jnz .loop       ; repetir mientras no sea 0

    jmp .begin      ; reiniciar la secuencia


; ---------------------------
; Rutina para imprimir cadenas
; ---------------------------
printStr:
    mov Rc, Ra
.nextChar:
    lod Ra, Rc
    tst Ra
    jz .done
    lcd Ra
    inc Rc
    jmp .nextChar
.done:
    ret

; ---------------------------
; Texto en el LCD
; ---------------------------
mensaje:
#d "Fibonacci reversa\0"
```

<img width="1129" height="812" alt="image" src="https://github.com/user-attachments/assets/a46381f0-e31d-4f90-abb9-c76122c0879e" />
