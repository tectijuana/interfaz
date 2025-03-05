# <p align="center"> 22211600 - Machado Sanchez Javier </p> 
```asm
;
;       __            _                      
;      / /___ __   __(_)__  _____            
; __  / / __ `/ | / / / _ \/ ___/            
;/ /_/ / /_/ /| |/ / /  __/ /                
;\____/\__,_/ |___/_/\___/_/                 
;    __  ___           __              __    
;   /  |/  /___ ______/ /_  ____ _____/ /___ 
;  / /|_/ / __ `/ ___/ __ \/ __ `/ __  / __ \
; / /  / / /_/ / /__/ / / / /_/ / /_/ / /_/ /
;/_/  /_/\__,_/\___/_/ /_/\__,_/\__,_/\____/ 
;                                           
;###############################################################################                                                  
;#                        Machado Sanchez Javier                               #
;#                                22211600                                     #
;#                                                                             #
;# Comparar dos números de memoria y encender LEDs si son iguales o diferentes #
;#                                                                             #
;###############################################################################
; Programa: Comparar 5 y 7
; Muestra "false" si los números son diferentes
; o muestra "true" si son iguales
NUM1 = 5
NUM2 = 7

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
ADDR       = 0
BCD_TERM   = 255
ASCII_ZERO = 48

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

mva #NUM1    ; Ra <- 5
mvb #NUM2    ; Rb <- 7


cmp Ra       ; Compara 5 (Ra) con 7 (Rb)
jz .same     ; Si son iguales, salta a .same
jmp .error   ; Si son diferentes, salta a .error


.same:
  ; Se asume que la rutina printNumber imprime el contenido de Ra
  data Ra, strTrue
  call printStr
  jmp .fin


.error:
  data Ra, strFalse
  call printStr

.fin:
  hlt               ; Termina la ejecución


printStr:
  mov Rc, Ra
.nextChar:
  lod Ra, Rc
  tst Ra
  jz .endPrintStr   ; Salta a la etiqueta de fin de impresión
  lcd Ra
  inc Rc
  jmp .nextChar
.endPrintStr:
  ret

printNumber:
  ; Rutina simplificada para imprimir el contenido de Ra
  lcd Ra
  ret

strFalse: #d "false\0"
strTrue: #d "true\0"

```

    
![Gif](https://i1.wp.com/giffiles.alphacoders.com/215/215462.gif)
