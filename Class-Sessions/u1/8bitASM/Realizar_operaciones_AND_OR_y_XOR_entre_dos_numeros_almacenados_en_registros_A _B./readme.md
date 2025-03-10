22211575-Cesar Gonzalez Salazar-ITT

# 🔢 Operaciones AND, OR y XOR en Ensamblador  

Este código en ensamblador realiza operaciones **AND**, **OR** y **XOR** entre dos registros (`Ra` y `Rb`).  
Cada operación se ejecuta en un bucle infinito, limpiando el acumulador (`A`) después de cada cálculo.  

## 📌 Código en Ensamblador  

```assembly
; ************************************************************************************************
; * Programa: Realizar_operaciones_AND_OR_y_XOR_entre_dos_numeros_almacenados_en_registros_A _B. *                            *
; * Descripción: Este programa ejecuta operaciones lógicas AND, OR y XOR                         *
; *              entre dos registros (Ra y Rb), mostrando el resultado en                        *
; *              el acumulador.                                                                  *
; * Autor: Cesar Gonzalez Salazar - 22211575                                                     *
; ************************************************************************************************

.begin:
    clra            ; Limpia el acumulador A
    data Ra , 1     ; Asigna el valor 1 al registro Ra
    data Rb , 1     ; Asigna el valor 1 al registro Rb

.loop:
    and Ra , Rb     ; Operación lógica AND entre Ra y Rb
    clra            ; Limpia el acumulador

    data Ra , 1     ; Reinicia Ra con 1
    data Rb , 0     ; Establece Rb en 0
    or Ra , Rb      ; Operación lógica OR entre Ra y Rb
    clra            ; Limpia el acumulador

    data Ra , 1     ; Reinicia Ra con 1
    data Rb , 1     ; Establece Rb en 1
    xor Ra , Rb     ; Operación lógica XOR entre Ra y Rb
    clra            ; Limpia el acumulador

    jmp .loop       ; Repite el ciclo indefinidamente



```
