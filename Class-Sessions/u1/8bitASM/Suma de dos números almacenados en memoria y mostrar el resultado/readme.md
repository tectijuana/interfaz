# Suma de dos números almacenados en memoria y mostrar el resultado.

## Este programa en lenguaje ensamblador suma dos números almacenados en memoria y muestra el resultado en el display.

## Código en Ensamblador 

```assembly
; ======================================================================================
;
; Programa asignado:  Suma de dos números almacenados en memoria y mostrar el resultado.
; Autor:     Jocelyn Alvarez Paniagua
; Matrícula: C20210713
; Instituto: Instituto Tecnológico de Tijuana
; Carrera: INGENIERIA EN SISTEMAS COMPUTACIONALES
; Asignatura: LENGUAJES DE INTERFAZ
; Fecha: 05 de marzo del 2025
; Ensamblador: Troy's Breadboard Computer
;
; ======================================================================================
;
; Definición de las variables en memoria
VALOR1 = 0x60
VALOR2 = 0x61
SUMA = 0x62
; Se inicia el programa en la dirección 0x00
#addr 0x00
    mva #30           ; Asignar 30 a Ra
    sto Ra, VALOR1    ; Almacenar Ra en la dirección VALOR1
    mvb #15           ; Asignar 15 a Rb
    sto Rb, VALOR2    ; Almacenar Rb en la dirección VALOR2

    lod Ra, VALOR1    ; Cargar el valor de VALOR1 en Ra
    lod Rb, VALOR2    ; Cargar el valor de VALOR2 en Rb

    add Ra            ; Sumar Rb a Ra (Ra = Ra + Rb)

.guardar_resultado:
    sto Ra, SUMA      ; Almacenar el resultado en la memoria

    mov Rd, Ra        ; Mostrar el resultado en la pantalla decimal

    nop               ; Instrucción sin operación
.fin:
    jmp .fin          ; Bucle infinito para detener el programa

```
