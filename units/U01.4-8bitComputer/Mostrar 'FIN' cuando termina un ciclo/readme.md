```asm
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE
lcc #LCD_CMD_CLEAR
.begin:
    data Rd, 1
    data Ra, 0
    push Ra
    inc Ra
.next:
    pop Rc
    inc Rc
    push Rc
    mov Rd, Ra
    mov Rb, Ra
.mul:
    add Ra
    jc .end
    dec Rc
    jz .next
    jmp .mul
.end:
    pop Rc
    ; === Aquí mostramos FIN ===
    lcc #LCD_CMD_CLEAR
    data Ra, .fin
    call .printStr
    hlt
; ----------------------------
; Rutina para imprimir cadenas
; ----------------------------
.printStr:
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
; ----------------------------
; Cadena "FIN"
; ----------------------------
.fin:
#d "FIN\0"
```
![Preview del programa](https://github.com/user-attachments/assets/052685da-9333-42db-a32e-11d4d9e0f984)
