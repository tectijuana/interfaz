# 🧠 Troy's Breadboard Computer - Mostrar Logo tipo Commodore

Autor: **Vázquez González Blessing Osciel**  
Unidad: `U01.4 - 8-bit Computer`  
Problema: Mostrar un logo estilo **Commodore** en pantalla LCD usando caracteres personalizados.

---

## 🎯 Objetivo

Mostrar en la pantalla LCD del emulador el **logo de Commodore** utilizando caracteres definidos en la CGRAM, con scroll automático y acompañado del nombre del autor en la segunda línea.

---

## 🧩 Código Ensamblador

```asm
; Mostrar logo tipo Commodore
; Autor: Vazquez Gonzalez Blessing Osciel

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
NEXTLINE = LCD_CMD_SET_DRAM_ADDR | 40

initializeDisplay:
	clra
	lcc #LCD_INITIALIZE
	lcc #DISPLAY_MODE
	lcc #LCD_CMD_CLEAR

outputCharacters:
	lcd #0
	lcd #1
	lcd #2
	lcd #3
	data Ra, strCommodore
	call printStr
	lcc #NEXTLINE
	lcd #12
	lcd #13
	lcd #14
	lcd #15
	data Ra, strName
	call printStr

buildCustomCharacters:	
	lcc #LCD_CMD_SET_CGRAM_ADDR

	data Rb, (charDataEnd - charDataStart)
	data Rc, charDataStart
	.addLine:
		lod Ra, Rc
		lcd Ra
		inc Rc
		dec Rb
		jnz .addLine

SCROLL_RIGHT = LCD_CMD_SHIFT | LCD_CMD_SHIFT_DISPLAY | LCD_CMD_SHIFT_RIGHT

scrollDisplay:
	lcc #SCROLL_RIGHT
	jmp scrollDisplay

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

strCommodore: #d " Commodore\0"
strName:      #d "By: Blessing Osciel\0"
