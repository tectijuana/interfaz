### **Código Fuente del Programa**
Este código en ensamblador está diseñado para ejecutarse en la **Ben Eater 8-bit Computer** y determina si un número almacenado en memoria es **par o impar**, mostrando un mensaje en una pantalla LCD. A continuación, se explica cada sección:

```assembly
;---------------------------------------------------------------
; Programa: Verificación de Paridad en Troy's Breadboard Computer 8bit
; Descripción: Este programa verifica si un número almacenado en memoria
;             es par o impar y muestra el resultado en un LCD.
; Autor: Chavez Hernandez Emmanuel Isai No. Control: 23211005
;---------------------------------------------------------------
NUMBER = 8  ; Numero para almacenar en memoria
DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
NEXTLINE = LCD_CMD_SET_DRAM_ADDR | 40

lcc #LCD_INITIALIZE      ; Inicializa el LCD
lcc #DISPLAY_MODE        ; Configura el modo de visualización

ADDR   = 0              ; Dirección base
STR_TERM = 0            ; Terminador de cadena
BCD_TERM = 255          ; Terminador de número BCD
ASCII_ZERO = 48         ; Código ASCII de '0'
;---------------------------------------------------------------
; Inicialización del programa
;---------------------------------------------------------------
    clra                ; Limpia el acumulador (Ra)
    data SP, 255        ; Configura el puntero de pila en 255
    data Rd, NUMBER     ; Carga el número a evaluar en Rd
;---------------------------------------------------------------
; Verificación de Paridad
;---------------------------------------------------------------
    lcc #LCD_CMD_CLEAR  ; Borra la pantalla del LCD
    mov Ra, Rd          ; Copia el número a Ra
    data Rb, 0x01       ; Carga 1 en Rb (máscara para verificar bit menos significativo)
    and Ra              ; Realiza AND entre Ra y 1 (verifica si el bit menos significativo es 1)
    jz .even            ; Si es 0 (par), salta a la etiqueta .even

; Número impar
    data Ra, strOdd     ; Carga la dirección del mensaje "Impar" en Ra
    call printStr       ; Llama a la subrutina para imprimir la cadena
    jmp .end            ; Salta al final del programa

.even:
    data Ra, strEven    ; Carga la dirección del mensaje "Par" en Ra
    call printStr       ; Llama a la subrutina para imprimir la cadena

.end:
    hlt                ; Detiene la ejecución
;---------------------------------------------------------------
; Subrutina: printStr
; Descripción: Imprime una cadena almacenada en la dirección contenida en Ra
;---------------------------------------------------------------
printStr:
    mov Rc, Ra         ; Copia la dirección de la cadena en Rc
.nextChar:
    lod Ra, Rc         ; Carga el siguiente carácter en Ra
    tst Ra             ; Verifica si es el terminador de cadena (cero)
    jz ret             ; Si es cero, retorna
    lcd Ra             ; Envía el carácter al LCD
    inc Rc             ; Incrementa el puntero de la cadena
    jmp .nextChar      ; Repite hasta encontrar el terminador

ret:
    ret                ; Retorno de la subrutina

;---------------------------------------------------------------
; Mensajes de salida
;---------------------------------------------------------------
strEven:  #d "Par\0"     ; Mensaje para número par
strOdd:   #d "Impar\0"   ; Mensaje para número impar
```
---

### **1. Definiciones y Constantes**
```assembly
NUMBER = 8  ; Número a verificar (puedes cambiar este valor)

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
NEXTLINE = LCD_CMD_SET_DRAM_ADDR | 40

ADDR   = 0
STR_TERM = 0
BCD_TERM = 255
ASCII_ZERO = 48 ; Código ASCII de '0'
```
- Se define el número a verificar (`NUMBER` = 8 en este caso).
- Se establecen constantes relacionadas con la configuración de la pantalla LCD.
- `ASCII_ZERO` se usa para convertir valores numéricos en caracteres ASCII.

---

### **2. Inicialización**
```assembly
lcc #LCD_INITIALIZE    ; Inicializa la pantalla LCD
lcc #DISPLAY_MODE      ; Configura el modo de pantalla
```
- Se inicializa la pantalla LCD para mostrar texto.

```assembly
clra                  ; Limpia el registro acumulador (Ra = 0)
data SP, 255          ; Inicializa el puntero de pila en 255
data Rd, NUMBER       ; Carga el número en el registro Rd
```
- Se limpia el registro **Ra** (Acumulador).
- Se establece el puntero de la pila (`SP`).
- Se carga el número que queremos verificar en **Rd**.

---

### **3. Verificación de Paridad**
```assembly
lcc #LCD_CMD_CLEAR    ; Limpia la pantalla LCD
mov Ra, Rd            ; Copia el número de Rd a Ra
data Rb, 0x01         ; Carga en Rb el valor 1 (máscara para AND)
and Ra                ; Realiza una operación AND entre Ra y 1
jz .even              ; Si el resultado es 0, el número es par (salta a .even)
```
- Se limpia la pantalla LCD.
- Se mueve el número de **Rd** a **Ra**.
- Se carga **Rb** con `0x01` (1 en binario).
- **AND lógico** (`and Ra`): Si el bit menos significativo de `Ra` es **0**, el número es **par**; si es **1**, es **impar**.
- Si el resultado es **cero** (`jz .even`), significa que el número es **par** y salta a `.even`.

---

### **4. Mostrar el Mensaje**
Si el número es impar:
```assembly
data Ra, strOdd   ; Carga la dirección de "Impar\0" en Ra
call printStr     ; Llama a la función para imprimir el mensaje
jmp .end          ; Salta al final
```
Si el número es par:
```assembly
.even:
data Ra, strEven  ; Carga la dirección de "Par\0" en Ra
call printStr     ; Llama a la función para imprimir el mensaje
```
- Dependiendo del resultado del chequeo, se carga la dirección de la cadena `"Impar\0"` o `"Par\0"` en **Ra** y se llama a `printStr` para imprimirla.

---

### **5. Finalización**
```assembly
.end:
    hlt  ; Detiene la ejecución del programa
```
- Detiene la ejecución.

---

### **6. Función `printStr` (Imprime una cadena en la LCD)**
```assembly
printStr:
    mov Rc, Ra        ; Guarda la dirección de la cadena en Rc
.nextChar:
    lod Ra, Rc        ; Carga en Ra el carácter apuntado por Rc
    tst Ra            ; Si Ra es 0 (fin de cadena), salir
    jz ret
    lcd Ra            ; Imprime el carácter en la pantalla LCD
    inc Rc            ; Mueve al siguiente carácter
    jmp .nextChar     ; Repite hasta encontrar '\0'

ret:
    ret               ; Retorna al programa principal
```
- Esta función imprime un **string** en la pantalla LCD.
- Se recorre la memoria con `Rc` hasta encontrar `\0`, enviando cada carácter a la LCD.

---

### **7. Definición de Cadenas**
```assembly
strEven:  #d "Par\0"
strOdd:   #d "Impar\0"
```
- Se definen las cadenas **"Par\0"** y **"Impar\0"** para indicar si el número es par o impar.

---

### **Ejemplo de Funcionamiento**
Si `NUMBER = 8`, la operación `8 AND 1` da **0**, lo que significa que es **Par** → Se muestra `"Par"` en la LCD.
![](https://raw.githubusercontent.com/EICH58/Imagenes-LI/refs/heads/main/Captura1.PNG)
![](https://raw.githubusercontent.com/EICH58/Imagenes-LI/refs/heads/main/Captura2.PNG)
Si `NUMBER = 7`, la operación `7 AND 1` da **1**, lo que significa que es **Impar** → Se muestra `"Impar"` en la LCD.
![](https://raw.githubusercontent.com/EICH58/Imagenes-LI/refs/heads/main/Captura3.PNG)
![](https://raw.githubusercontent.com/EICH58/Imagenes-LI/refs/heads/main/Captura4.PNG)
---

### **Resumen**
Este código:
1. **Carga un número en memoria** (`NUMBER`).
2. **Verifica si es par o impar** usando `AND` con `1`.
3. **Muestra en pantalla "Par" o "Impar"** dependiendo del resultado.
4. **Usa `printStr` para imprimir las cadenas** en la pantalla LCD.
