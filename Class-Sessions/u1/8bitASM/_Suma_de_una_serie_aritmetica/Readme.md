# Programa: Suma de una serie aritmética almacenada en memoria y mostrar el resultado.
## Código de ensamblador.

    ;***************************************************************
    ; Nombre del archivo: Suma_de_una_serie_aritmetica 
    ; Autor: Espino Hernández Jaime Paul  
    ; Fecha de creación: 02-03-2025  
    ; Descripción:  
    ;   Este programa tiene la funcionalidad de realizar una suma aritmética que se 
    ;   encuentra almacenada en memoria y mostrar el resultado. 
    ;   
    ; Arquitectura: Troy Breadboard Computer
    ;   
    ; Derechos de autor y licencia:  
    ;   Código abierto 
    ;**************************************************************

    #addr 0xA0  ; Definir la dirección base de memoria

    begin:
    ; Almacenar una secuencia de números pares en memoria comenzando en la dirección 0x80
    mva #0x80  ; Cargar en Ra la dirección base 0x80
    
    mvb #2     ; Cargar el valor 2 en Rb
    sto Ra, Rb ; Almacenar 2 en la dirección apuntada por Ra (0x80)
    inc Ra     ; Incrementar Ra a la siguiente dirección
    
    mvb #4     ; Cargar el valor 4 en Rb
    sto Ra, Rb ; Almacenar 4 en la nueva dirección
    inc Ra     ; Incrementar Ra
    
    mvb #6     ; Cargar el valor 6 en Rb
    sto Ra, Rb ; Almacenar 6 en la nueva dirección
    inc Ra     ; Incrementar Ra
    
    mvb #8     ; Cargar el valor 8 en Rb
    sto Ra, Rb ; Almacenar 8 en la nueva dirección
    inc Ra     ; Incrementar Ra
    
    mvb #10    ; Cargar el valor 10 en Rb
    sto Ra, Rb ; Almacenar 10 en la nueva dirección

    ; Inicializar Rc en 0 para la sumatoria
    clr Rc     ; Rc = 0

    ; Realizar la suma directamente en Rc
    mvb #2     ; Cargar el valor 2 en Rb
    add Rc     ; Rc = 2
    
    mvb #4     ; Cargar el valor 4 en Rb
    add Rc     ; Rc = 2 + 4
    
    mvb #6     ; Cargar el valor 6 en Rb
    add Rc     ; Rc = 2 + 4 + 6
    
    mvb #8     ; Cargar el valor 8 en Rb
    add Rc     ; Rc = 2 + 4 + 6 + 8
    
    mvb #10    ; Cargar el valor 10 en Rb
    add Rc     ; Rc = 2 + 4 + 6 + 8 + 10

    ; Mostrar el resultado en Rd
    mvd Rc     ; Transferir el valor de Rc a Rd

    ; Detener el programa
    hlt        ; Fin de la ejecución

## Resultados del código.
![Captura de pantalla 2025-03-02 230226](https://github.com/user-attachments/assets/31c7baca-1032-4c36-84c5-fd211010d99a)
