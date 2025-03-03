**TECNOLÓGICO NACIONAL DE MÉXICO**  
**INSTITUTO TECNOLÓGICO DE TIJUANA**

**SUBDIRECCIÓN ACADÉMICA**  
**DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN**

**SEMESTRE:**  
Enero - Junio 2025

**CARRERA:**  
Ingeniería en Sistemas Computacionales

**MATERIA:**  
Lenguajes de interfaz

**TÍTULO ACTIVIDAD:**  
Mostrar Numero e Invertir Numeros

**NOMBRE Y NÚMERO DE CONTROL:**  
Soberanes Oregel Cristopher Daniel - C20211465  

**NOMBRE DEL MAESTRO (A):**  
René Solis Reyes

##### Código fuente documentado

```assembly
 ; Nombre: Soberanes Oregel  Cristopher Daniel
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON | LCD_CMD_DISPLAY_CURSOR | LCD_CMD_DISPLAY_CURSOR_BLINK

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

.start:
  clra
  lcc #LCD_CMD_CLEAR  ; Limpiar pantalla antes de comenzar

  data Ra, .numbers   ; Cargar dirección de "42"
  call .printStr      ; Imprimir "42"

  lcc #LCD_CMD_CLEAR  ; Limpiar pantalla después de imprimir "24"

  data Ra, .numbers1  ; Cargar dirección de "24"
  call .printStr      ; Imprimir "24"

  jmz

.printStr:       ;Me base en el ejericio de hola mundo
  mov Rc, Ra
  .nextChar:
    lod Ra, Rc
    tst Ra
    jz .done
    lcd Ra
    inc Rc
    jmp .nextChar
  .done:    ;Pasa al siguiente bloque de codigo
    ret     ;Repute el Ciclo del programa

.numbers:    
#d "42\0"     ;cuando es llamada .numbers; invoca lo que esta aqui

.numbers1:
#d "24\0"     ;cuando es llamada .numbers; invoca lo que esta aqui
