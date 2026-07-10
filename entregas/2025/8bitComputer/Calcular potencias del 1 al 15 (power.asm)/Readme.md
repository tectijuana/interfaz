# Calcular potencias del 1 al 15 (power.asm)
**Cesar Gregorio Angel Montoya**  
**No. Control: 22210281**

## Codigo
```asm
; POTENCIAS DEL 1 AL 15 Cesar Gregorio Angel Montoya #22210281

ADDR_BASE  = 0x00   ; memoria temporal para guardar la base actual

.begin:
	clra                 ; limpia registros
	data SP, 0xff        ; inicializa la pila
	inc Ra               ; Ra = 1
	sto Ra, ADDR_BASE    ; primera base = 1
	
.loop:
	lod Ra, ADDR_BASE    ; carga base actual
	inc Ra               ; Ra = siguiente base
	data Rb, 0x0f        ; límite superior (15)
	and Ra               ; Ra & 15 → mantiene rango 1..15
	jz .begin            ; si excede 15 → reinicia
	sto Ra, ADDR_BASE    ; guarda base en memoria
	mov Rd, Ra           ; muestra la base en display
	mov Rb, Ra           ; Rb = base
	call .nextPower      ; calcula sus potencias
	jmp .loop            ; sigue con la siguiente base
	
.nextPower:
	data Rc, 0x00        ; acumulador del resultado = 0
	
.powerAdder:
	dec Ra               ; contador de multiplicaciones
	jnn .doAdd           ; si no hemos terminado → saltar a suma
	mov Rd, Rc           ; muestra potencia calculada
	mov Rb, Rc           ; prepara para siguiente potencia
	lod Ra, ADDR_BASE    ; reinicia contador = base
	jmp .nextPower
	
.doAdd:
	add Rc, Rb           ; Rc = Rc + base (multiplicación repetida)
	jnc .powerAdder      ; repetir mientras no haya overflow (<= 255)
	ret                  ; fin de potencias para esta base
```
## Captura
<img width="1066" height="846" alt="image" src="https://github.com/user-attachments/assets/37f7fcb5-e2ad-4807-a122-0cdbe3164ce0" />

