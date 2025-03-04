Ernesto Torres Pineda 22211665
# Codigo de la Practica
```Assembly
;=================================================================================================================
; INSTITUTO TECNOLOGICO DE TIJUANA
; File name	: Practica.asm
; Author	: [Ernesto Torres Pineda 22211665]
; Date		: [03/03/2025]
; Title		: [Determinar si un número es negativo, cero o positivo y encender un LED correspondiente.]
; Description	: [Este programa analiza un numero dado y determina si es negativo, positivo o cero y lo indica.]
; Assembler	: [Troy's Breadboard Copmuter]
; Architecture	: [Personalized CPU]
; ===============================================================================================================
    ; Define the number to check
    NUMBER = 0  ; Change this value to test other numbers

    DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON
    NEXTLINE = LCD_CMD_SET_DRAM_ADDR | 40

    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE

    ADDR   = 0
    STR_TERM = 0
    BCD_TERM = 255
    ASCII_ZERO = 48 ; ascii 0

	clra
	data SP, 255
	data Rd, NUMBER	

    ; Evaluate if Rd is negative, positive, or zero
    start:
	  lcc #LCD_CMD_CLEAR

	; Check if the number is zero
	mov Ra, Rd       ; Copy Rd to Ra
	tst Ra           ; Test the value in Ra
	jz .zero         ; If Ra is zero, jump to .zero

	; Check if the number is negative
	mov Ra, Rd       ; Copy Rd to Ra
	data Rb, 0x80    ; Load 0x80 (binary 10000000) into Rb
	and Ra, Rb       ; Mask all bits except the MSB
	jnz .negative    ; If the result is non-zero, the number is negative

	; If neither zero nor negative, the number is positive
	jmp .positive

    .negative:
	    data Ra, strNegative
	    call printStr
	    jmp .done

    .zero:
	    data Ra, strZero
	    call printStr
	    jmp .done

    .positive:
	    data Ra, strPositive
	    call printStr
	    jmp .done

    .done:
	    hlt

    ; Helper function to print a string
      printStr:
      mov Rc, Ra
      .nextChar:
        lod Ra, Rc
        tst Ra
      jz .printStrEnd  ; Jump to a valid label instead of "ret"
        lcd Ra
	    inc Rc
        jmp .nextChar
      .printStrEnd:
        ret              ; Explicit return

    ; Strings for display
    strNegative: #d "Is negative\0"
    strZero: #d "Is zero\0"
    strPositive: #d "Is positive\0"
```

# Explicacion
## Este código en ensamblador verifica si un número es negativo, cero o positivo y muestra el mensaje correspondiente en la pantalla LCD. Funciona en 4 etapas:

1) Inicialización:

  + El número a verificar se almacena en Rd.

  + La pantalla LCD se inicializa y se limpia.

2) Evaluación:

  + El programa verifica si el número es cero usando tst y jz.

  + Si no es cero, verifica si el número es negativo enmascarando el bit más significativo (MSB) con and Ra, 0x80 y jnz.

  + Si no es ninguno de los dos, el número es positivo.

3) Visualización:

   Dependiendo de la evaluación, el programa muestra:

  + "Es negativo"

  + "Es cero"

  + "Es positivo"

4) Función Auxiliar:

  + La función printStr imprime una cadena en la pantalla LCD.

# Capturas: 
![image](https://github.com/user-attachments/assets/d0b28e13-8399-4a02-9ced-b614deb78ac3)
![image](https://github.com/user-attachments/assets/0efe6c80-19ae-458f-b7f6-359063a55aa0)
![image](https://github.com/user-attachments/assets/1d773c87-9322-4475-a67e-b0f8cd2d4595)
