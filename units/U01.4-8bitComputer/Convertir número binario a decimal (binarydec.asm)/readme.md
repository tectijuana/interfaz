Programa: Binary to Decimal (binarydec.asm)


Autor: Contreras Hernández Jonathan Ramiro

Matrícula: 22211539

<img width="223" height="226" alt="image" src="https://github.com/user-attachments/assets/97cc7e38-bf48-401c-b3e9-084d2b395611" />

Objetivo: Convertir un número binario a decimal y mostrarlo en un display (registro Rd) sin usar LCD ni ASCII.


 Programa: binarydec.asm

**** Convierte un número binario a decimal y lo muestra en el display decimal (registro Rd).****

**** Basado en binary.asm pero sin usar LCD ni ASCII.****



```asm
NUMBER = 0b10101001   ; Número binario a convertir (169 decimal)
ADDR   = 0
TERMINATOR = 255

.begin:
    data SP, 255        ; inicializar stack pointer
    data Ra, ADDR       ; dirección base para almacenar dígitos
    data Rb, NUMBER     ; cargar número binario

    call toDec8         ; convertir a decimal → guardar en memoria
    call printResult    ; mostrar en display decimal
    hlt                 ; detener programa


; -------------------------------
; Conversión binario → decimal
; Rb = número a convertir
; Ra = dirección de memoria inicial
; -------------------------------
toDec8:
    push Ra
    push Rb

.nextDigit:
    pop Ra              ; número actual
    data Rb, 10
    call div8           ; dividir número entre 10
    pop Rb              ; dirección
    sto Rb, Ra          ; guardar resto en memoria
    inc Rb
    push Rb             ; guardar dirección siguiente
    tst Rc
    jz .done
    push Rc             ; guardar cociente y repetir
    jmp .nextDigit

.done:
    pop Rb
    data Ra, TERMINATOR
    sto Rb, Ra          ; marcar fin de número
    ret


; -------------------------------
; Mostrar resultado en DISPLAY (Rd)
; -------------------------------
printResult:
    data Ra, ADDR
    data Rb, TERMINATOR

.findEnd:
    lod Rc, Ra
    cmp Rb, Rc
    jz .startPrint
    inc Ra
    jmp .findEnd

.startPrint:
    data Rc, ADDR

.nextDigit:
    dec Ra
    lod Rd, Ra          ; cargar dígito decimal en Rd (DISPLAY)
    mov Rb, Ra
    cmp Rb, Rc
    jz .return
    jmp .nextDigit

.return:
    ret


; -------------------------------
; División entera 8 bits
; Entrada: Ra = dividendo, Rb = divisor
; Salida:  Rc = cociente, Ra = resto
; -------------------------------
div8:
    data Rc, 0x00

.step:
    cmp Rb, Ra
    jz .add
    jc .return

.add:
    inc Rc
    sub Ra
    jnz .step

.return:
    ret
```

    Inicialización
Se define el número binario (NUMBER) que se convertirá, la dirección base (ADDR) y un terminador (255) para indicar el fin del número.

Conversión a decimal (toDec8)

Se divide el número entre 10 repetidamente usando div8.

El resto de cada división se almacena en memoria como dígito decimal.

El proceso termina cuando el cociente es 0.

Mostrar en display (printResult)

Se busca el terminador para identificar el final del número.

Se muestran los dígitos en orden inverso (de mayor a menor) en el registro Rd.

División entera 8 bits (div8)

Realiza la división repetitiva restando el divisor del dividendo.

Al finalizar, Rc contiene el cociente y Ra el resto.
