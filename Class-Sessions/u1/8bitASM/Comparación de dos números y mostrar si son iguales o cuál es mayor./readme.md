 # Comparación de dos números y mostrar si son iguales o cuál es mayor. #

Este código en ensamblador compara dos valores almacenados en registros y muestra el resultado en la pantalla LCD. 
Utiliza instrucciones de comparación y saltos condicionales para determinar si el primer número es mayor, menor o igual al segundo, imprimiendo el mensaje.

↓ Codigo ↓

;; Comparación de dos números y mostrar si son iguales o cuál es mayor

DISPLAY_MODE = LCD_CMD_DISPLAY |
LCD_CMD_DISPLAY_ON | 
LCD_CMD_DISPLAY_CURSOR | 
LCD_CMD_DISPLAY_CURSOR_BLINK

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

.start:
  clra
  lcc #LCD_CMD_CLEAR

  ; Definicion de variables 
  data Ra, 12  
  data Rb, 8  

  ; Comparar cual es la variable es mayor
  cmp Rb, Ra      
  
  ; Operacion para saber si no son iguales
  jz .iguales  
  
  ; Muestra si el primero es mayor
  jnc .primero  

  ; Muestra si el segundo es mayor
  mov Ra, .msg2 ; Ra < Rb → "El 2do es mayor"
  jmp .mostrar

.primero:
  mov Ra, .msg1 ; Ra > Rb 
  jmp .mostrar

.iguales:
  mov Ra, .msg3 ; Ra == Rb

.mostrar:
  call .printStr
  jmz

; Función que muestra el texto en la LCD
.printStr:
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

.msg1:
  #d "El n1 es mayor\0"

.msg2:
  #d "El n2 es mayor\0"

.msg3:
  #d "Los dos son iguales\0"
