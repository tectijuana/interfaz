# Miguel Angel Lopez Garibay  
**Número de control:** 21212576  

---

# Rotación de bits en el Troy Breadboard Computer

## Introducción  
El **Troy Breadboard Computer** es un simulador educativo de una computadora de 8 bits, que permite entender cómo funcionan instrucciones básicas a nivel de máquina en un procesador sencillo.  
Una de las operaciones importantes en sistemas digitales es la **rotación de bits**, la cual consiste en desplazar los bits de un registro y “reciclar” el bit que sale para colocarlo del otro lado.  

Este programa realiza una **rotación a la izquierda simulada** en el registro `Rc`, mostrando cómo se puede implementar esta operación usando las instrucciones disponibles en el simulador.

---

## Código utilizado  

; ROTAR IZQUIERDA (simulada) EN Rc
; Copia Rc → Rb, lsr (actúa en Rb), si Carry=1 => inc Rb (coloca 1 en bit0), luego mov Rb → Rc

Pattern = 0b11001100   ; patrón inicial (puedes cambiarlo)

	clra
	data Rc, Pattern    ; cargar patrón en Rc

.loop:
	mov Rb, Rc          ; copiar Rc a Rb (lsr actúa sobre Rb)
	lsr                 ; desplaza Rb hacia la izquierda (bit7 -> Carry)
	jnc .no_carry       ; si Carry == 0 saltamos
	inc Rb              ; si Carry == 1, poner 1 en bit0 (rotate)
.no_carry:
	mov Rc, Rb          ; devolver resultado a Rc
	mov Rd, Rc          ; opcional: mostrar valor decimal en la salida (display)
	; pequeño retardo visual
	nop
	nop
	nop
	jmp .loop

<img width="1126" height="907" alt="{C60099C7-74A8-4928-889C-6FABB1D36505}" src="https://github.com/user-attachments/assets/dd432a06-764f-4d7c-8caf-d948eeb9edf0" />
<img width="1900" height="875" alt="{5C27267D-5614-492E-BB1D-5902247F608D}" src="https://github.com/user-attachments/assets/a93d2f3b-0a61-4980-9910-9439537ce7cf" />

