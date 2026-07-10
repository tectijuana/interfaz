#### ROGRAMA: Mostrar datos personales y la fecha en el LCD
#### Autor: Gilberto Lavenant Baldenebro
#### Matrícula: 22211590
#### Objetivo: Mostrar la fecha 16-09 en el LCD


```text 

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
NEXTLINE = LCD_CMD_SET_DRAM_ADDR | 40   ; dirección base para segunda línea del LCD
THIRDLINE = LCD_CMD_SET_DRAM_ADDR | 80  ; dirección base para tercera línea

; --- Inicialización del LCD ---
    lcc #LCD_INITIALIZE   ; Inicializa el LCD
    lcc #DISPLAY_MODE     ; Activa display (cursor apagado por simplicidad)
    lcc #LCD_CMD_CLEAR    ; Limpia el LCD

; --- Línea 1: Nombre ---
.start:
    clra
    data Ra, .nombre      ; cargar dirección de la cadena "Gilberto..."
    call .printStr        ; imprimir en la primera línea

; --- Línea 2: Matrícula ---
    lcc #NEXTLINE         ; mover cursor a la segunda línea
    data Ra, .matricula   ; cargar dirección de "22211590"
    call .printStr        ; imprimir en la segunda línea

; --- Línea 3: Mensaje con fecha ---
    lcc #THIRDLINE        ; mover cursor a la tercera línea
    data Ra, .mensaje     ; cargar dirección de "Mostrar la fecha 16-09 en el LCD"
    call .printStr        ; imprimir en la tercera línea

    hlt                   ; detener el programa

; --- Rutina para imprimir cadenas en el LCD ---
.printStr:
    mov Rc, Ra            ; Rc = dirección de la cadena
.nextChar:
    lod Ra, Rc            ; cargar un carácter desde memoria
    tst Ra                ; ¿es cero (fin de cadena)?
    jz .done              ; si sí, terminamos
    lcd Ra                ; mostrar carácter en el LCD
    inc Rc                ; siguiente carácter
    jmp .nextChar
.done:
    ret

; --- Datos (cadenas terminadas en \0) ---
.nombre:
#d "Gilberto Lavenant Baldenebro\0"

.matricula:
#d "22211590\0"

.mensaje:
#d "Mostrar la fecha 16-09 en el LCD\0"
```
<img width="1092" height="783" alt="image" src="https://github.com/user-attachments/assets/543ba4c0-1ca2-4959-b99f-26c796931eeb" />
