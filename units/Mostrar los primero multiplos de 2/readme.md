# ✨🌸━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🌸✨
#             ｡ﾟ･ Anime Code Header ･ﾟ｡  
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ 📚 Asignatura: Lenguajes de Interfaz (TECNM Campus ITT)
# ┃ 👤 Autor(a): Garrido Salas Andre Luiz
# ┃ 📅 Fecha: 2025/09/24
# ┃ 📝 Programa: Muestra en el LCD los primeros 3 múltiplos de 2.  
# ┃ 🌐 Simulación: https://wokwi.com/projects/123456-animeLCD
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
#
# 🌸 Tema: ANIME ✨  
# 💡 Inspirado en el estilo kawaii de los personajes que 
# siempre logran transformar las matemáticas en magia.
#
# 🏮「El código también puede ser un anime donde tú eres el héroe」🏮
# ✨ Saga: *Códigos que brillan más que mil estrellas* ✨
# 🌸━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🌸
;-------------------------------------------------------
; Mostrar los primeros 3 múltiplos de 2 en el LCD
;-------------------------------------------------------

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
SPACE = 32

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

start:
    clra
    lcc #LCD_CMD_CLEAR

    ; Mostrar '2'
    data Rc, 50
    lcd Rc
    ; Espacio
    data Rc, SPACE
    lcd Rc

    ; Mostrar '4'
    data Rc, 52
    lcd Rc
    ; Espacio
    data Rc, SPACE
    lcd Rc

    ; Mostrar '6'
    data Rc, 54
    lcd Rc

    hlt
<img width="923" height="460" alt="image" src="https://github.com/user-attachments/assets/45f4e5df-a3fb-4965-a12f-efb9bb8ceca7" />
