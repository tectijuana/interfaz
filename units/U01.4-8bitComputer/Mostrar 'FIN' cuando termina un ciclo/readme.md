
**Nombre:** Alberto Ruvalcaba  
**Número de control:** 22211653  

---

## 🎯 Objetivo
El propósito de este programa es **ejecutar un ciclo (bucle) controlado por un contador** y, cuando finalice, mostrar en el **LCD** del Troy Breadboard Computer el mensaje **"FIN"**.

---

## 🧩 Conceptos previos
Antes de ver el código, repasemos algunos puntos importantes:

1. **Inicialización del LCD**  
   - Es necesario configurar el modo de la pantalla antes de mostrar texto.  
   - Se usa `lcc #LCD_INITIALIZE`, `lcc #DISPLAY_MODE` y `lcc #LCD_CMD_CLEAR`.

2. **Uso de registros principales**  
   - `Ra`: se usa para cargar direcciones y caracteres.  
   - `Rb`: lo usaremos como **contador del ciclo**.  
   - `Rc`: se usará como puntero en la rutina que imprime la cadena.  
   - `Rd`: está conectado al display decimal, pero en este programa no lo utilizaremos.

3. **Subrutina para imprimir cadenas (`.printStr`)**  
   - Recorre una cadena de caracteres terminada en `\0`.  
   - Cada carácter se envía al LCD con la instrucción `lcd Ra`.

---

## 📜 Código completo

```asm
; -----------------------------
; Ejemplo: mostrar "FIN" al terminar un ciclo
; Troy's Breadboard Computer
; -----------------------------

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

; Inicializar el LCD
    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

; -----------------------------
; Programa principal
; -----------------------------
.start:
    clra                ; limpiar registros
    data Rb, 5          ; contador = 5 (ejemplo)

.loop:
    dec Rb              ; restar 1
    jnz .loop           ; repetir mientras no sea cero

; -----------------------------
; Al terminar el ciclo → mostrar "FIN"
; -----------------------------
.showFin:
    lcc #LCD_CMD_CLEAR  ; limpiar pantalla
    data Ra, .finMsg    ; cargar dirección de la cadena "FIN"
    call .printStr
    hlt                 ; detener ejecución

; -----------------------------
; Subrutina para imprimir cadena terminada en 0
; -----------------------------
.printStr:
    mov Rc, Ra
.nextChar:
    lod Ra, Rc          ; cargar carácter
    tst Ra              ; ¿es 0 (fin de cadena)?
    jz .done
    lcd Ra              ; mostrar carácter
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
=======

; -----------------------------
; Datos
; -----------------------------
.finMsg:
#d "FIN\0"
