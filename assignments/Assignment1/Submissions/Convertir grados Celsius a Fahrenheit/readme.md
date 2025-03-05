; ******************************************************
; Instituto Tecnológico de Tijuana
; Materia: Lenguajes de Interfaz
; Nombre del Alumno: Solano Cortez Iván Israel
; Número de Control: 22210786
; Profesor: René Solís Reyes
; Lenguaje en que se Ensambla: Assembly (Lenguaje de Bajo Nivel)
;
; Descripción del Código:
; Este programa en lenguaje ensamblador realiza la conversión
; de temperatura de grados Celsius a Fahrenheit utilizando
; la fórmula matemática:
; 
; F = (C * 9 / 5) + 32
; 
; El código incluye operaciones matemáticas como multiplicación,
; división y suma implementadas mediante funciones personalizadas,
; trabajando con registros y operaciones en ensamblador para lograr
; la conversión. Además, el programa presenta el resultado al final,
; mostrando los valores calculados en formato legible.
; ******************************************************

; Formula: F = (C * 9 / 5) + 32
NUMBER = 25    ;celsius
ADDR   = 0
TERMINATOR = 255

main:
    data SP, 255
    data Rd, NUMBER
    data Ra, ADDR
    mov Rb, Rd
    ; F = (C * 9 / 5) + 32
    mov Ra, Rd  
    data Rc, 9    
    call mul8  
    mov Rd, Rc   
    data Rc, 5   
    call div8   
    mov Rd, Ra     
    data Rc, 32   
    call add8      
    mov Rb, Ra      
    
    .output:
        call printResult
        jmp .output

printResult:
    data Ra, ADDR
    data Rb, TERMINATOR
    data Rd, NUMBER

    .findEnd:
        lod Rc, Ra
        cmp Rb, Rc
        jz .startPrint
        inc Ra
        jmp .findEnd

    .startPrint:
        data Rc, ADDR
        mov Rb, Ra

    .nextDigit:
        dec Rb
        lod Rd, Rb
        cmp Rb, Rc
        jz .return
        jmp .nextDigit

    .return:
        ret

mul8:
    data Rc, 0x00

    .multiply:
        tst Rb
        jz .done
        call inc8 
        dec Rb
        jmp .multiply

    .done:
        ret

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
add8:

    tst Rc
    jz .doneAdd
    inc Ra
    dec Rc
    jmp add8

.doneAdd:
    ret

inc8:
    inc Ra
    dec Rc
    tst Rc
    jnz inc8
    ret
