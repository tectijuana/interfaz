#-------------------------------------

Alumno: Jose Angel Mojica Fajardo

Numero de control: 22210322

Profesor: RENE SOLIS REYES

Materia: Lenguajes de interfaz

#-------------------------------------

; Tabla del 2: muestra 2x1 .. 2x5 en el LCD (una línea a la vez)
; Asume la interfaz LCD del emulador Troy

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

    ; inicializa LCD
    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

    data Rc, 1      ; contador = 1

.loop:
    ; limpia pantalla y escribe "2xN="
    lcc #LCD_CMD_CLEAR
    lcd #0x32       ; '2'
    lcd #0x78       ; 'x'  (0x78 = 'x')

    ; imprimir multiplicador (Rc) -> convertir a ASCII y mostrar
    mov Ra, Rc
    data Rb, 48     ; ASCII '0'
    add Ra          ; Ra = Rc + '0'
    lcd Ra

    lcd #0x3D       ; '=' (0x3D = '=')

    ; calcular producto: Ra = 2 * Rc
    mov Ra, Rc
    mov Rb, Rc
    add Ra          ; Ra = Rc + Rc = 2*Rc

    ; si Ra == 10 -> imprimir "10", si no -> imprimir dígito único
    data Rb, 10
    cmp Ra
    jz .print10

    ; un solo dígito (1..9)
    data Rb, 48
    add Ra          ; convertir a ASCII
    lcd Ra
    jmp .afterPrint

.print10:
    lcd #0x31       ; '1'
    lcd #0x30       ; '0'

.afterPrint:
    ; pequeño retardo (simple loop de NOPs) para que se lea la línea
    data Rb, 80
.delay:
    dec Rb
    jnz .delay

    ; siguiente multiplicador
    inc Rc
    data Rb, 6
    cmp Rc
    jz .end         ; cuando Rc == 6 (hemos hecho 1..5) termina
    jmp .loop

.end:
    hlt

<img width="1482" height="651" alt="image" src="https://github.com/user-attachments/assets/97796afd-1475-4531-b18a-3924cc9b373b" />


