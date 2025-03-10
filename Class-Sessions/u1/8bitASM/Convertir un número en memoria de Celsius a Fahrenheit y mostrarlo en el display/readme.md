# Convertir un número en memoria de Celsius a Fahrenheit y mostrarlo en el display


```sql
; *************************************************************************
;                         Conversión de Celsius a Fahrenheit
;                        y despliegue del resultado en LCD
; *************************************************************************
;
; Autor: Brian Guadalupe Tellez Escobar
; Descripción: Este programa convierte una temperatura en grados Celsius a
;              Fahrenheit y muestra el resultado en una pantalla LCD. Además,
;              incluye funciones para multiplicación y división de enteros de
;              8 bits.
;
; Fecha de creación: [03/03/2025]
; *************************************************************************

; Definición de constantes
Celsius = 25  ; Valor de ejemplo en grados Celsius (puede cambiarse según sea necesario)
ADDR    = 0   ; Dirección de inicio para mostrar el resultado
ZERO    = 48  ; Valor ASCII del caracter '0'

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON  ; Configuración del modo de pantalla LCD

; Inicialización de la pantalla LCD
lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE
lcc #LCD_CMD_CLEAR

main:
    data SP, 255       ; Inicializa el puntero de la pila
    data Rd, Celsius   ; Carga el valor de Celsius en el registro Rd
    data Ra, ADDR      ; Dirección de memoria para almacenar el resultado
    mov Rb, Rd         ; Mueve el valor de Celsius a Rb para uso posterior

    call toFahrenheit  ; Llama a la función de conversión a Fahrenheit
    
    .output:
        call printResult  ; Llama a la función para imprimir el resultado
        jmp .output       ; Repite el ciclo para mantener la salida en pantalla
; Autor: Brian Guadalupe Tellez Escobar
printResult:
    lcc #LCD_CMD_CLEAR      ; Limpia la pantalla LCD
    data Ra, ADDR           ; Dirección de inicio para el resultado
    data Rb, 0xFF           ; Terminador para la salida

    ; Buscar el final de la cadena en memoria e imprimir
.findEnd:
    lod Rc, Ra              ; Carga el valor de memoria en Rc
    cmp Rb, Rc              ; Compara con el terminador
    jz .startPrint          ; Si es igual, comienza la impresión
    inc Ra                  ; Incrementa la dirección de memoria
    jmp .findEnd            ; Repite la búsqueda

.startPrint:
    data Rc, ADDR           ; Carga el valor de la cadena para imprimir

.nextDigit:
    dec Ra                  ; Decrementa la dirección de memoria
    lod Rd, Ra              ; Carga el valor en Rd
    mov Rb, Rd              ; Mueve el valor a Rb para convertirlo a ASCII
    data Rb, ZERO           ; Convierte a ASCII sumando el valor de '0'
    add Rd                  ; Realiza la conversión
    lcd Rd                  ; Muestra el dígito en el LCD
    mov Rb, Ra              ; Mueve la dirección de memoria a Rb
    cmp Rb, Rc              ; Compara con el final de la cadena
    jz .return              ; Si ya se imprimió todo, retorna
    jmp .nextDigit          ; Repite el ciclo para el siguiente dígito

.return:
    ret

; Función div10 - División por 10 utilizando resta repetitiva
;  Rb: valor del cociente (inicializado a 0)
div10:
    data Rc, 0x00      ; Inicializar el cociente
    data Rb, 10        ; Cargar el valor 10 en el registro Rb

.step:
    cmp Rd, Rb         ; Compara Rd con Rb (10)
    jc .return         ; Si Rd < 10, salir (no puede dividir más)

    sub Rd, Rb         ; Restar 10 de Rd
    inc Rc             ; Incrementar el cociente
    jmp .step          ; Repetir el ciclo

.return:
    ret

; Autor: Brian Guadalupe Tellez Escobar

; Función toFahrenheit - Convierte de Celsius a Fahrenheit
;  Rb: valor en grados Celsius
;  Ra: dirección de memoria donde se almacenará el resultado
toFahrenheit:
    push Ra             ; Empuja la dirección de memoria al stack
    push Rb             ; Empuja el valor de Celsius al stack

    ; Multiplicar Celsius por 9 (Ra = Celsius * 9)
    data Rc, 9
    call mul8           ; Llama a la función de multiplicación

    ; Dividir entre 5 (Ra = (Celsius * 9) / 5)
    data Rc, 5
    call div8           ; Llama a la función de división

    ; Sumar 32 (Ra = ((Celsius * 9) / 5) + 32)
    data Rc, 32
    add Ra              ; Realiza la suma

    ; Almacenar el resultado en memoria
    pop Rb
    sto Rb, Ra          ; Almacena el resultado en la memoria

    ; Empuja la siguiente dirección de memoria para su visualización
    inc Rb
    push Rb

    pop Rb
    ret


; Función mul8 - Multiplica dos enteros de 8 bits
;  Ra: primer operando
;  Rb: segundo operando
; Devuelve:
;  Rc: resultado de la multiplicación
mul8:
    data Rc, 0x00   ; Inicializar el resultado en 0
    
    .step:
        tst Rb            ; Verifica si Rb es cero
        jz .return        ; Si es cero, regresa
        
        add Rc            ; Sumar Ra a Rc
        dec Rb            ; Decrementar Rb
        jmp .step         ; Repetir hasta que Rb sea cero
    
    .return:
        ret


; Función div8 - Divide dos enteros de 8 bits
;  Ra: dividendo
;  Rb: divisor
; Devuelve:
;  Rc: cociente
;  Ra: residuo
div8:
    data Rc, 0x00   ; Inicializar el cociente
    
    .step:
        cmp Ra, Rb      ; Compara el dividendo con el divisor
        jc .return      ; Si Ra < Rb, regresa (no puede dividirse más)
        
        sub Ra          ; Restar Rb de Ra
        inc Rc          ; Incrementar el cociente
        jmp .step       ; Repetir el ciclo
    
    .return:
        ret
