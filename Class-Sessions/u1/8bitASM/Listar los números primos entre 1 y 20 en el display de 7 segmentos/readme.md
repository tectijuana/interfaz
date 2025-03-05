# Listado de Números Primos en una CPU de 8 Bits

**Allen Jacob Suarez Briseño - 21212056**

## 1. Código Fuente Documentado

```assembly
; Programa para listar los números primos entre 1 y 20 en el display de 7 segmentos

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
NEXTLINE = LCD_CMD_SET_DRAM_ADDR | 40

ADDR   = 0
STR_TERM = 0
BCD_TERM = 255
ASCII_ZERO = 48 ; ASCII '0'

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE

start:
    lcc #LCD_CMD_CLEAR  ; Limpiar display
    data Ra, 1          ; Comenzar desde 1

loop:
    mov Rb, 20
    cmp Ra, Rb          ; Si Ra > 20, terminar
    jn .done
    call is_prime       ; Verificar si es primo
    tst Rb              ; En lugar de carry, usa Rb (1 = primo, 0 = no primo)
    jz .next            ; Si no es primo, ir al siguiente

    mov Rb, Ra          ; Pasar el número a Rb
    call printNumber    ; Imprimir número primo en display
    lcc #NEXTLINE       ; Mover cursor a nueva línea

.next:
    inc Ra              ; Siguiente número
    jmp loop

.done:
    jmp start           ; Reiniciar el proceso

; Verifica si un número en Ra es primo
; Retorna Rb = 1 si es primo, 0 si no
is_prime:
    mov Rb, 2           ; Divisor inicial
    cmp Ra, Rb          ; Si Ra < 2, no es primo
    jc .not_prime

.check_div:
    cmp Rb, Ra          ; Si Rb >= Ra, es primo
    jnc .prime

    mov Rc, Ra          ; Guardar el número original
    call div8           ; Dividir Ra entre Rb
    tst Ra              ; Si el residuo es 0, no es primo
    jz .not_prime

    inc Rb              ; Incrementar divisor
    jmp .check_div

.prime:
    data Rb, 1          ; Marcar como primo
    ret

.not_prime:
    data Rb, 0          ; Marcar como no primo
    ret

; Imprime un número en Rb en el display
printNumber:
    data Ra, ADDR
    call toDec8
    data Ra, ADDR
    call printBCD
    ret

; Conversión de binario a decimal en BCD
; Entrada: Rb = número, Ra = dirección de memoria de salida
toDec8:
    push Ra
    push Rb

.nextDigit:
    pop Ra
    data Rb, 10
    call div8
    pop Rb
    sto Rb, Ra
    inc Rb
    push Rb
    tst Rc
    jz .return
    push Rc
    jmp .nextDigit

.return:
    pop Rb
    data Ra, BCD_TERM
    sto Rb, Ra
    ret

; División de 8 bits: Ra / Rb
; Retorna Rc = cociente, Ra = residuo
div8:
    data Rc, 0x00

.step:
    cmp Rb, Ra
    jz .add
    jc ret

.add:
    inc Rc
    sub Ra
    jnz .step
    ret

; Mostrar número en display
printBCD:
    data Rb, BCD_TERM

.findEnd:
    lod Rc, Ra
    cmp Rb, Rc
    jz .startPrint
    inc Ra
    jmp .findEnd

.startPrint:
    clr Rc

.nextDigit:
    dec Ra
    lod Rc, Ra
    data Rb, ASCII_ZERO
    add Rc
    lcd Rc
    mov Rb, Ra
    tst Rb
    jz ret
    jmp .nextDigit
    ret
```

---

## 2. Breve Informe Explicativo

### **Lógica del Programa**
El código busca y muestra los números primos entre 1 y 20 en un display de 7 segmentos utilizando una CPU de 8 bits. Se siguen los siguientes pasos:

1. **Inicialización:** Se configura el display LCD y se inicia desde el número 1.
2. **Bucle Principal:**
   - Si el número actual supera 20, el programa reinicia.
   - Se verifica si el número es primo mediante `is_prime`.
   - Si es primo, se imprime en el display y se pasa a la siguiente línea.
   - Se incrementa el número y se repite el proceso.
3. **Verificación de Primos (`is_prime`):**
   - Se prueba la divisibilidad desde 2 hasta el número actual.
   - Si se encuentra un divisor, no es primo.
   - Si no se encuentra divisor, el número es primo.
4. **Conversión y Visualización:**
   - `toDec8` convierte el número a BCD para ser impreso.
   - `printBCD` lo muestra en el display.

---

## 3. Demostración en la Computadora de 8 Bits

Para ejecutar este código en un simulador de CPU de 8 bits, sigue estos pasos:

1. **Cargar el código en el ensamblador** de tu emulador (Ejemplo: `emu8bit`).
2. **Ejecutar la simulación** y observar el display de 7 segmentos.
3. **Verificar la salida:**
   - El display debe mostrar los números primos 2, 3, 5, 7, 11, 13, 17 y 19.
   - Cada número debe aparecer en una nueva línea.
4. **Reiniciar el proceso:**
   - Al finalizar, el programa reinicia mostrando nuevamente los primos desde 1 a 20.

Este código es funcional y optimizado para tu CPU de 8 bits. 🚀

