Alumno: Javier Fernandez Cortez
No. De control: 22211558
Practica: Mostrar la palabra "HOLA" en el LCD

```text
; Mostrar "HOLA" en el LCD
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

lcc #LCD_INITIALIZE      ; Inicializa el LCD
lcc #DISPLAY_MODE        ; Enciende el display
lcc #LCD_CMD_CLEAR       ; Limpia pantalla

.start:
  clra                   ; Limpia registros
  data Ra, .hola         ; Cargar dirección del string en Ra
  call .printStr         ; Llamar rutina para imprimir cadena
  hlt                    ; Fin del programa

; --- Rutina para imprimir cadena ---
.printStr:
  mov Rc, Ra             ; Guardar dirección inicial en Rc
.nextChar:
  lod Ra, Rc             ; Cargar caracter de memoria
  tst Ra                 ; Revisar si es nulo
  jz .done               ; Si es fin de cadena, salir
  lcd Ra                 ; Enviar caracter al LCD
  inc Rc                 ; Avanzar al siguiente caracter
  jmp .nextChar
.done:
  ret

; --- Cadena a mostrar ---
.hola:
#d "HOLA\0"
```

<img width="1099" height="835" alt="image" src="https://github.com/user-attachments/assets/9bd16b22-1e88-444a-b0e0-9d81d798dcbe" />

