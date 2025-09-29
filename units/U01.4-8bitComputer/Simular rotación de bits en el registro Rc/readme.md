# Programa para simular rotación de bits en el registro Rc

**Autor:** Oscar Francisco Alonso Sanchez  

```asm
; Rotación circular derecha en Rc

start:
    mva #129        ; Ra = 129 (ejemplo inicial: 1000 0001)
    mov Rc, Ra      ; Rc = valor inicial

.loop:
    mva #1          ; Ra = 1
    mov Rb, Ra      ; Rb = 1
    and Rc          ; Rc & 1 → si LSB=1 → Z=0
    jz .shift       ; si LSB=0, no reinsertar

    mva #128        ; Ra = 128
    mov Rd, Ra      ; usar Rd como flag = 128
    jmp .shift_do

.shift:
    mva #0
    mov Rd, Ra      ; Rd = 0

.shift_do:
    mov Rb, Rc
    lsr
    mov Rc, Rb

    tst Rd
    jz .show
    add Rc          ; Rc = Rc + Rb → reinserta MSB si era necesario

.show:
    mov Ra, Rc
    lcd Ra          ; mostrar valor en LCD
    jmp .loop       ; repetir


