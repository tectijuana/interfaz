; Crisostomo Enciso Francisco Javier 22211546
; Programa: Generar tabla de multiplicar de un número guardado en memoria
; Tabla de multiplicar de un número almacenado en memoria
; Se asume que el número a multiplicar está guardado en la dirección NUM_ADDR

NUM_ADDR = 0x10

.begin:
    lod Rb, NUM_ADDR    ; Cargar el multiplicando desde memoria en Rb
    data Ra, 1           ; Inicializar el multiplicador en 1
    push Ra              ; Empujar el multiplicador para usarlo en el bucle

.loop:
    data Rd, 0           ; Inicializar el acumulador (producto) en 0
    pop Rc               ; Sacar el contador (valor del multiplicador) de la pila

.add_loop:
    tst Rc               ; Probar el contador; se activa Z si Rc es 0
    jnz .add_loop_body   ; Si Rc no es 0, continuar la suma
    jmp .display         ; Si Rc es 0, ya se completó la suma

.add_loop_body:
    add Rd             ; Sumar el multiplicando (contenido en Rb) al acumulador Rd
    dec Rc             ; Decrementar el contador
    jmp .add_loop      ; Repetir hasta que Rc llegue a 0

.display:
    nop                ; Resultado de la multiplicación se encuentra en Rd (se asume que Rd está conectado al display)
    
.next:
    inc Ra             ; Incrementar el multiplicador (Ra = Ra + 1)
    push Ra            ; Empujar el nuevo multiplicador para la siguiente iteración
    data Rc, 11        ; Cargar 11 en Rc (valor de terminación: 11 significa que ya se han hecho 10 productos)
    mov Rb, Ra         ; Copiar el multiplicador actual a Rb para la comparación
    cmp Rc             ; Comparar 11 con el multiplicador (Rb)
    jnz .loop          ; Si Ra (multiplicador) es distinto de 11, repetir el bucle

.end:
    hlt                ; Finalizar la ejecución
