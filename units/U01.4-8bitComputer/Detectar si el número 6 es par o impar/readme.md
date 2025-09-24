```python
# =====================================================================
#  ██████╗ ███████╗████████╗██████╗  ██████╗ ████████╗██████╗  ██████╗ 
#  ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗╚══██╔══╝██╔══██╗██╔═══██╗
#  ██████╔╝█████╗     ██║   ██████╔╝██║   ██║   ██║   ██████╔╝██║   ██║
#  ██╔═══╝ ██╔══╝     ██║   ██╔═══╝ ██║   ██║   ██║   ██╔═══╝ ██║   ██║
#  ██║     ███████╗   ██║   ██║     ╚██████╔╝   ██║   ██║     ╚██████╔╝
#  ╚═╝     ╚══════╝   ╚═╝   ╚═╝      ╚═════╝    ╚═╝   ╚═╝      ╚═════╝ 
# =====================================================================
# 💻 Asignatura: Lenguajes de Interfaz en TECNM Campus ITT
# 🧑 Autor: Javier N Lopez
# 📅 Fecha: 2025/09/24
# 📝 Descripción: Programa retro para detectar si el número 6 es par. 
# 🌐 Simulación Wokwi: https://wokwi.com/projects/xxxxxx
# ---------------------------------------------------------------------
# ⚡ MOTTO: "El código es la llave, los números son la puerta."
# =====================================================================


```asm
; DETECTAR SI UN NÚMERO ES PAR O IMPAR Y MOSTRARLO EN LCD

NUMBER = 6
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

    ; Inicializar LCD
    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

start:
    data Ra, NUMBER   ; cargar número en Ra
    data Rb, 0x01     ; máscara (LSB)
    and Ra            ; Ra = Ra AND 1
    jz .esPar         ; si Ra = 0 -> par
    jmp .esImpar      ; si no -> impar

.esPar:
    data Ra, msgPar
    call printStr
    hlt

.esImpar:
    data Ra, msgImpar
    call printStr
    hlt


; ----------- RUTINA PARA IMPRIMIR CADENAS EN LCD -----------
printStr:
    mov Rc, Ra
.nextChar:
    lod Ra, Rc        ; cargar caracter
    tst Ra            ; ¿es cero (fin de cadena)?
    jz .done
    lcd Ra            ; imprimir en pantalla
    inc Rc
    jmp .nextChar
.done:
    ret


; ----------- CADENAS A MOSTRAR -----------
msgPar:   #d "El numero es par\0"
msgImpar: #d "El numero es impar\0"
