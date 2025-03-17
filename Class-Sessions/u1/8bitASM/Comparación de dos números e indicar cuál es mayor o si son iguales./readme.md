# 🔢 **Comparación de dos números: ¿Cuál es mayor? ¿Son iguales?** 🔍  

<p align="center">
  <img src="https://github.com/Maya-Bytes/Maya-Bytes/blob/main/Images/4.jpg" alt="Imagen centrada" />
</p>


👨‍💻 **Hecho por:** Maya Pino Juan Carlos

📅 **Fecha:** 04/03/2025 

🛠️ **Tecnologías usadas:** Assembly, Markdown 

🎯 **Objetivo:** Facilitar la comparación de números de manera rápida y precisa. 

---

## 📌Código Fuente Documentado

```asm
;Maya Pino Juan Carlos

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON | LCD_CMD_DISPLAY_CURSOR | LCD_CMD_DISPLAY_CURSOR_BLINK

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

.start:
  clra
  lcc #LCD_CMD_CLEAR

  ; Definir los números a comparar
  data Ra, 10  ; Primer número
  data Rb, 10  ; Segundo número (puedes cambiar este valor para probar)

  ; Comparar si el primer número es mayor
  cmp Rb, Ra      ; Compara Ra con Rb
  jz .iguales  ; Si Ra == Rb, salta a .iguales
  ; Si no hay acarreo, entonces Ra < Rb
  jnc .primero  ; Si no hay acarreo, Ra >= Rb (Ra es mayor)

  ; Si Ra < Rb
  mov Ra, .msg2 ; Ra < Rb → "El 2do es mayor"
  jmp .mostrar

.primero:
  ; Si Ra > Rb
  mov Ra, .msg1 ; Ra > Rb → "El 1ro es mayor"
  jmp .mostrar

.iguales:
  ; Si Ra == Rb
  mov Ra, .msg3 ; Ra == Rb → "Son iguales"

.mostrar:
  call .printStr
  jmz

; Función para imprimir una cadena en la LCD
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
  #d "El 1ro es mayor\0"

.msg2:
  #d "El 2do es mayor\0"

.msg3:
  #d "Son iguales\0"
  ```
---

## 📝 **Descripción**  

Este programa en Assembly compara dos números en un emulador de una computadora de 8 bits y muestra en una pantalla LCD cuál es mayor o si son iguales.  

🔹 **Funcionamiento:**  
1. Se definen dos números en los registros `Ra` y `Rb`.  
2. Se realiza la comparación entre ambos:  
   - Si `Ra > Rb`, se muestra el mensaje **El 1ro es mayor**.  
   - Si `Ra < Rb`, se muestra el mensaje **El 2do es mayor**.  
   - Si son iguales, se muestra **Son iguales**.  
3. La impresión del mensaje se hace en una pantalla LCD a través de una rutina que recorre la cadena y la envía a la pantalla.  

🔹 **Detalles técnicos:**  
✔️ Usa instrucciones básicas de comparación (`cmp`), salto condicional (`jz`, `jnc`), y manipulación de registros.  
✔️ Incluye una función (`.printStr`) para mostrar texto en la pantalla LCD.  
✔️ Utiliza la memoria de datos (`data`) para almacenar los números a comparar.  

Este código es ideal para aprender sobre el manejo de registros, comparación de datos y salida en una computadora de 8 bits.🚀  

---

## 📑 **Demostración en el emulador** 

A continuación se muestra el resultado de la comparación de los números: 

###  **Resultado cuando los números son iguales** ⇄

![Números iguales](https://github.com/Maya-Bytes/Maya-Bytes/blob/main/Images/1.png?raw=true)

---

### **Resultado cuando el primer número es mayor:** ⇅

![Primer Número mayor](https://github.com/Maya-Bytes/Maya-Bytes/blob/main/Images/3.png?raw=true)

---

### **Resultado cuando el segundo número es mayor:** ⇵

---

![Segudo Número mayor](https://github.com/Maya-Bytes/Maya-Bytes/blob/main/Images/2.png?raw=true)

