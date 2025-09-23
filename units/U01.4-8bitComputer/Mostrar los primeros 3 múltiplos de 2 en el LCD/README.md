; Mostrar los primeros 3 múltiplos de 2 en el LCD
; Resultado esperado en pantalla: 2 4 6

ZERO = 48 ; ASCII de '0'
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

; Inicialización del LCD
lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE
lcc #LCD_CMD_CLEAR

.start:
    ; --- Mostrar 2 ---
    data Rd, 2
    call .printNumber

    ; Espacio
    data Rd, 32
    lcd Rd

    ; --- Mostrar 4 ---
    data Rd, 4
    call .printNumber

    ; Espacio
    data Rd, 32
    lcd Rd

    ; --- Mostrar 6 ---
    data Rd, 6
    call .printNumber

    jmz    ; detener ejecución como en hello.asm

.printNumber:
    data Rb, ZERO
    add Rd      ; Convierte número a ASCII ('0' + número)
    lcd Rd      ; Envía carácter al LCD
    ret

![Captura de pantalla 2025-09-23 163923](https://github.com/user-attachments/assets/82f22aba-3baf-4cc7-add8-740e109d80e1)
