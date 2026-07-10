## Alumno
**Gayosso Perez Karla Yuray**  
*Matrícula: 22210764*

## Docente
**René Solís Reyes**

## Materia
**Lenguajes de interfaz**

## Practica

; Detectar Carry en 200 + 100 y mostrar resultado truncado (8 bits)
; Salida esperada en LCD: "Carry 44"

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
ZERO = 48     ; ASCII '0'

    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

start:
    ; 1) Operandos y suma
    data Ra, 200
    data Rb, 100
    add Ra           ; Ra = (200+100) mod 256
    mov Rd, Ra       ; <- guardar resultado en Rd (porque printStr usa Ra/Rc)

    ; 2) Detectar carry (acarreo unsigned)
    jc .hasCarry

.noCarry:
    data Ra, strNoC
    call printStr
    jmp .printResult

.hasCarry:
    data Ra, strCarry
    call printStr

.printResult:
    ; imprimir espacio
    lcd #32          ; espacio ASCII decimal

    ; preparar división para convertir a decimal: dividend en Ra, divisor 10 en Rb
    mov Ra, Rd       ; Ra = resultado guardado
    data Rb, 10
    call div8        ; al volver: Rc = cociente (tens), Ra = resto (units)

    tst Rc
    jz .oneDigit

    ; dos dígitos: imprimir tens (Rc) y units (Ra)
    data Rb, ZERO
    add Rc           ; Rc = tens + '0'
    lcd Rc
    data Rb, ZERO
    add Ra           ; Ra = units + '0'
    lcd Ra
    jmp .end

.oneDigit:
    data Rb, ZERO
    add Ra           ; Ra = digit + '0'
    lcd Ra

.end:
    hlt

; ------------------------
; printStr: imprime string cuyo puntero está en Ra
; (usa mov Rc, Ra / lod Ra, Rc / lcd Ra)
; ------------------------
printStr:
    mov Rc, Ra
.nextChar:
    lod Ra, Rc
    tst Ra
    jz .donePr
    lcd Ra
    inc Rc
    jmp .nextChar
.donePr:
    ret

; ------------------------
; div8: divide Ra / Rb (enter: Ra=dividendo, Rb=divisor)
; salida: Rc = cociente, Ra = resto
; Implementación basada en binarydec.asm
; ------------------------
div8:
    data Rc, 0x00
.divStep:
    cmp Rb, Ra
    jz .sub
    jc .return
.sub:
    inc Rc
    sub Ra
    jnz .divStep
.return:
    ret

; ------------------------
; cadenas
; ------------------------
strCarry: #d "Carry\0"
strNoC:   #d "NoCarry\0"
