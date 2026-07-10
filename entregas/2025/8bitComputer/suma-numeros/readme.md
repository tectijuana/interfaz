```asm
; ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣷⣶⣶⣦⣤⣀⠀⠀⢀⣠⣤⣶⣾⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠈⠉⠙⠛⠻⣿⣿⣿⣿⠟⠛⠋⠉⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀🌸 P R O G R A M A   D E   S U M A   K A W A I I 🌸⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠀⠀⠀⢿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀
; ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣷⣦⣤⣀⡀⠀⠀⢀⣀⣤⣴⣾⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
;
; 🏫 ASIGNATURA: Lenguajes de Interfaz en TECNM Campus ITT
; 🧑‍🎓 AUTOR: Javier Ulises Cortes Aguilar
; 📅 FECHA: 2025/09/24
; 🧮 DESCRIPCIÓN: ¡Este kodomo suma 2 + 3 y muestra el resultado "2+3=5" en una LCD mágica!
; 🔗 SIMULACIÓN WOKWI: https://wokwi.com/projects/sakura-sum-chip
;
; 💖 MODO OTAKU: ACTIVO
; 🏮 "Bitto no Tomodachi: El LCD que quería aprender a contar"
; 🌟 Ganbatte kudasai, senpai! ¡Tu código también puede brillar! 🌈

; Mostrar "2+3=5" en pantalla LCD

ZERO = 48                ; ASCII de '0'
NUM1 = 2
NUM2 = 3
RESULT = NUM1 + NUM2     ; Resultado (5)

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

    ; Mostrar '3'
    data Rd, NUM2
    data Rb, ZERO
    add Rd
    lcd Rd

    ; Mostrar '='
    data Rd, 61
    lcd Rd

    ; Mostrar '5'
    data Rd, RESULT
    data Rb, ZERO
    add Rd
    lcd Rd

    hlt
```
<img width="1486" height="898" alt="image" src="https://github.com/user-attachments/assets/3e6bbcfc-098b-471a-9616-d99c12a9523a" />
