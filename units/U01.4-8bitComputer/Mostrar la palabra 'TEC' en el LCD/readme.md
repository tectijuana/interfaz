# Mostrar la palabra 'TEC' en el LCD
**Nombre:** Rico Sánchez Sebastián Emiliano

**No. Control:** 22211641

**Práctica:** Mostrar la palabra 'TEC' en el LCD

## Código
```
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE
lcc #LCD_CMD_CLEAR
.start:
  data Ra, .msgTEC
  call .printStr
  hlt           
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
.msgTEC:
#d "TEC\0"
```

## Ejecución
Pantalla muestra **'T'**
<img width="812" height="617" alt="imagen" src="https://github.com/user-attachments/assets/3a472642-c41b-475b-895f-e6a98b2f2b36" />

Pantalla muestra **'TE'**
<img width="812" height="617" alt="imagen" src="https://github.com/user-attachments/assets/6cfb2edd-7130-4fe8-9c96-4acf344fc85c" />

Pantalla final, muestra **'TEC'**:
<img width="823" height="633" alt="imagen" src="https://github.com/user-attachments/assets/ade5d361-f2af-42fe-a631-746cac3f5673" />
