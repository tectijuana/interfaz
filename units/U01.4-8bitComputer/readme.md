


Bot 8 bit Proboard computer assembler


https://chatgpt.com/g/g-67e07c810214819189bad584c77bbf93-8-bit-troy-breadboard-assistant

---

Emulador:

https://cpu.visualrealmsoftware.com/?utm_source=chatgpt.com

---

`
; Mostrar "2+7=9" en pantalla LCD

ZERO = 48                ; ASCII de '0'
NUM1 = 2
NUM2 = 7
RESULT = NUM1 + NUM2     ; Resultado (9)

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

    ; Inicializa el LCD
    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

start:
    clra

    ; Mostrar '2'
    data Rd, NUM1
    data Rb, ZERO
    add Rd
    lcd Rd

    ; Mostrar '+'
    data Rd, 43
    lcd Rd

    ; Mostrar '7'
    data Rd, NUM2
    data Rb, ZERO
    add Rd
    lcd Rd

    ; Mostrar '='
    data Rd, 61
    lcd Rd

    ; Mostrar '9'
    data Rd, RESULT
    data Rb, ZERO
    add Rd
    lcd Rd

    hlt

```

