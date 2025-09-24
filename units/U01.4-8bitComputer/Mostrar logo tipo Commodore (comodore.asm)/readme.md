Alumno: Casimiro Morales Alexandra Daniela 23210562

Mostrar logo tipo Commodore (comodore.asm)
----

Este código en **ensamblador** está diseñado para controlar un **LCD** y mostrar el logo y texto del **Commodore C64**. El programa inicializa la pantalla, define y carga caracteres personalizados, escribe texto y luego realiza un desplazamiento infinito de la pantalla.

-----

### Código

```assembly
; Configuración de display
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
NEXTLINE     = LCD_CMD_SET_DRAM_ADDR | 40
SCROLL_RIGHT = LCD_CMD_SHIFT | LCD_CMD_SHIFT_DISPLAY | LCD_CMD_SHIFT_RIGHT

; -----------------------------------------------
; Inicialización de LCD
; -----------------------------------------------
initializeDisplay:
    clra
    lcc #LCD_INITIALIZE    ; Configuración inicial
    lcc #DISPLAY_MODE      ; Encender display
    lcc #LCD_CMD_CLEAR     ; Limpiar pantalla

; -----------------------------------------------
; Mostrar caracteres del logo + texto
; -----------------------------------------------
outputCharacters:
    ; Usar caracteres personalizados (0-3)
    lcd #0
    lcd #1
    lcd #2
    lcd #3

    ; Escribir " Commodore"
    data Ra, strCommodore
    call printStr

    ; Pasar a la segunda línea
    lcc #NEXTLINE

    ; Más caracteres personalizados (12-15)
    lcd #12
    lcd #13
    lcd #14
    lcd #15

    ; Escribir "     C64"
    data Ra, strC64
    call printStr

; -----------------------------------------------
; Construir caracteres personalizados (CGRAM)
; -----------------------------------------------
buildCustomCharacters:
    lcc #LCD_CMD_SET_CGRAM_ADDR

    data Rb, (charDataEnd - charDataStart)  ; número de bytes
    data Rc, charDataStart                  ; dirección de datos
.addLine:
    lod Ra, Rc      ; cargar byte desde tabla
    lcd Ra          ; enviar al LCD (CGRAM)
    inc Rc
    dec Rb
    jnz .addLine

; -----------------------------------------------
; Scroll infinito hacia la derecha
; -----------------------------------------------
scrollDisplay:
    lcc #SCROLL_RIGHT
    jmp scrollDisplay

; -----------------------------------------------
; Subrutina: imprimir cadena
; -----------------------------------------------
printStr:
    mov Rc, Ra
.nextChar:
    lod Ra, Rc      ; cargar carácter
    tst Ra          ; ¿es cero?
    jz .done
    lcd Ra          ; imprimir en LCD
    inc Rc
    jmp .nextChar
.done:
    ret

; -----------------------------------------------
; Datos: caracteres personalizados
; -----------------------------------------------
charDataStart:
#d64 0x0003070f0f1f1e1e
#d64 0x0f1f1f1f10000000
#d64 0x1818181807070700
#d64 0x000000001e1c1800
#d64 0x1e1e1f0f0f070300
#d64 0x000000101f1f1f0f
#d64 0x0007070718181818
#d64 0x00181c1e00000000
charDataEnd:

; -----------------------------------------------
; Cadenas a mostrar
; -----------------------------------------------
strCommodore: #d " Commodore\0"
strC64:       #d " By: Daniela Casimiro\0"
```
<img width="998" height="786" alt="image" src="https://github.com/user-attachments/assets/bd2bd95f-d7b2-44f0-b2b7-f730599038ba" />
