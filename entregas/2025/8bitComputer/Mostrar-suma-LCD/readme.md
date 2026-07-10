## Alumno
**Nolasco Vázquez José Antonio**  
*Matrícula: 22210326*

## Docente
**René Solís Reyes**

## Materia
**Lenguajes de interfaz**

## Codigo

; FIBONACCI SEQUENCE
;
; If you want to halt instead of repeat, look
; at the jc .begin line. You might want to create
; Another label with another action to end ;)

; Mostrar el número 9 en el display

; Mostrar la suma 2 + 3 en el LCD

; Mostrar "2+3=5" en el LCD

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

start:
    clra
    lcc #LCD_INITIALIZE    ; Inicializar LCD
    lcc #DISPLAY_MODE      ; Encender display
    lcc #LCD_CMD_CLEAR     ; Limpiar pantalla

    ; Mostrar "2"
    data Ra, 50            ; ASCII '2'
    lcd Ra

    ; Mostrar "+"
    data Ra, 43            ; ASCII '+'
    lcd Ra

    ; Mostrar "3"
    data Ra, 51            ; ASCII '3'
    lcd Ra

    ; Mostrar "="
    data Ra, 61            ; ASCII '='
    lcd Ra

    ; Calcular 2 + 3
    data Ra, 2
    data Rb, 3
    add Ra                 ; Ra = 5

    ; Convertir a ASCII y mostrar
    data Rb, 48            ; '0'
    add Ra                 ; 5 + 48 = 53 ('5')
    lcd Ra

    hlt                    ; Fin
