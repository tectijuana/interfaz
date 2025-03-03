# Temporizador simulado con ciclos de retardo usando instrucciones NOP

**📌 Autor:** Jennifer Nicole Macedo Cruz  
**📅 Fecha:** 03/03/2025  
**📝 Descripción:** Implementa un temporizador regresivo que cuenta desde 10 hasta 0 y luego se reinicia.  

## Descripción  

Este proyecto implementa un **temporizador en ensamblador** que inicia desde **10** y cuenta hacia atrás hasta **0**, utilizando instrucciones `NOP` para generar retardos simulados. Cuando llega a **0**, el contador se reinicia después de una breve pausa.

```assembly
; FIBONACCI SEQUENCE
;
; ---------------------------------------------------
; INSTITUTO TECNOLÓGICO DE TIJUANA
; Programa: Temporizador simulado con ciclos de retardo usando instrucciones NOP
; Autor: Jennifer Nicole Macedo Cruz
; No. Control: 22211599
; Fecha: 03/03/2025
; Descripción: Implementa un temporizador regresivo que 
; cuenta desde 10 hasta 0 y luego se reinicia.
; ---------------------------------------------------
; If you want to halt instead of repeat, look
; at the jc .begin line. You might want to create
; Another label with another action to end ;)
; Definir el valor inicial del temporizador

.begin:
    mov Ra, 10       ; Inicializa el temporizador en 10

.countdown:
    mov Rd, Ra       ; Mostrar el tiempo restante en el display

    ; Retardo con más NOPs
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  

    dec Ra           ; Decrementar el temporizador

    ; Alternativa a cmp: verificamos si Ra ya es 0
    jz .pause        ; Si Ra ya es 0, saltar a pausa
    jmp .countdown   ; Si no, continuar

.pause:
    mov Rd, 0        ; Asegurar que el display muestre 000

    ; Pequeño retardo antes de reiniciar
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  
    nop  

    jmp .begin       ; Reiniciar el conteo desde 10
```
## Capturas
![image](https://github.com/user-attachments/assets/f707cc3f-0dc9-4997-85ba-d179082b4520)


