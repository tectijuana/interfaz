
Nombre: Axel Alvarez Estrada


Matricula: 23210542

# Practica: Mostrar Hello World! en el LCD del emulador 

Codigo del programa

; Hola Mundo para Troy's Breadboard Computer
; Muestra "Hola, Mundo!" en la pantalla LCD
; Adaptado del ejemplo hello.asm

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON | LCD_CMD_DISPLAY_CURSOR | LCD_CMD_DISPLAY_CURSOR_BLINK

; Inicializa la LCD (valores de constantes vienen del entorno/assembler de Troy)
lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

.start:
  clra                 ; limpia registros (opcional)
  lcc #LCD_CMD_CLEAR    ; limpia la pantalla
  data Ra, .hello       ; Ra apunta a la cadena a imprimir
  call .printStr        ; llama a la rutina de impresión
  jmz                   ; salta a 0x00 (detiene o vuelve a inicio según plataforma)

; Rutina que imprime una cadena terminada en 0 (NULL)
.printStr:
  mov Rc, Ra            ; Rc = puntero actual en memoria
  .nextChar:
    lod Ra, Rc          ; Ra = [Rc]  (carga carácter)
    tst Ra              ; prueba si Ra == 0 (terminador)
    jz .done            ; si es 0, fin
    lcd Ra              ; envia byte Ra al LCD (muestra carácter)
    inc Rc              ; siguiente carácter
    jmp .nextChar
  .done:
    ret

; Cadena terminada en 0
.hello:
#d "Hola, Mundo!\0"




