/***********************************************************************************************************************
 * Autor:         Ceballos Reséndiz Verónica Sarahi
 * Programa:      Contador binario en LEDs (0 - 255)
 * Descripción:   Este programa implementa un contador de 8 bits que incrementa desde 0 hasta 255, mostrando cada valor 
 *                en un conjunto de LEDs. Al alcanzar el valor máximo (255), el contador se reinicia automáticamente a 0.
 * Plataforma:    [Especifica el microcontrolador o arquitectura, por ejemplo: PIC16F877A, 8051, AVR, etc.]
 * Fecha:         27 de febrero de 2025
 * Versión:       1.0
 ***********************************************************************************************************************/
.start:
    clr Ra        ; Inicializa Ra en 0
    clr Rd        ; Inicializa Rd (display de LEDs) en 0

.loop:
    mov Rd, Ra    ; Mueve el valor de Ra al registro Rd para mostrarlo
    inc Ra        ; Incrementa Ra en 1
    cmp Ra        ; Compara Ra con 255
    jz .reset     ; Si Ra es 0 (después de 255), reinicia el contador

    jmp .loop     ; Continúa el bucle

.reset:
    clr Ra        ; Reinicia Ra a 0
    jmp .loop     ; Vuelve al bucle

