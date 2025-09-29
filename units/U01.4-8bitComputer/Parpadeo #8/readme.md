# Parpadeo del número 8 en display

Este programa en **ensamblador** muestra el número `8` en un display, alternando entre mostrar y no mostrar cada cierto tiempo.  
El retardo se logra mediante una rutina con **bucles anidados por software**.  

**#Nota:** para una mejor apreciacion, incrementar la velocidad de reloj al maximo.
## Código

```asm
; PARPADEO DEL NÚMERO 8 EN EL DISPLAY
; Usa un retardo por software con bucles anidados
; -------------------------------------
; Programa principal
; -------------------------------------
start:
    clra             ; limpiar registros
.loop:
    data Rd, 8       ; mostrar número 8
    call delay       ; esperar
    data Rd, 0       ; no mostrar
    call delay       ; esperar
    jmp .loop        ; repetir para siempre
; -------------------------------------
; Rutina de retardo
; Genera una pausa usando bucles anidados
; -------------------------------------
delay:
    data Ra, 0x20    ; bucle externo (32 repeticiones)
.outer:
    data Rc, 0xFF    ; bucle interno (255 repeticiones)
.inner:
    dec Rc
    jnz .inner       ; repetir hasta que Rc = 0
    dec Ra
    jnz .outer       ; repetir hasta que Ra = 0
    ret              ; regresar al programa principal
