# 🖥️ Inversión de Bits en un Computador de 8 Bits

## 📌 Descripción

Rivera Garcia Rodrigo - 22211642

Este proyecto implementa un programa en ensamblador para el **emulador de Troy’s Breadboard Computer**, que invierte los bits de un número almacenado en memoria y muestra el resultado en la salida (LCD, LEDs o display de 7 segmentos).  

---

## 🛠️ Requisitos

- **Emulador:** Troy’s Breadboard Computer  
- **Lenguaje:** Ensamblador del emulador  
- **Entrada:** Número almacenado en memoria  
- **Salida:** Número con los bits invertidos, mostrado en la pantalla o LEDs  

---

## 📜 Código Fuente

```assembly
; INVERSIÓN DE BITS DE UN NÚMERO EN MEMORIA
; ----------------------------------------
; Este programa toma un número almacenado en memoria,
; invierte todos sus bits y muestra el resultado en la salida.

NUM = 0b11010010  ; Número de prueba (puedes cambiarlo)

start:
    data Ra, NUM   ; Cargar el número original en Ra

    not Ra         ; Invertir los bits de Ra

    mov Rd, Ra     ; Mover el resultado a la salida (LCD, LEDs o display)

.loop:
    jmp .loop      ; Bucle infinito para mantener el resultado en pantalla
