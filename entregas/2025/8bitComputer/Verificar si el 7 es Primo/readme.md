# Verificar si el número 7 es primo

**Nombre:** Rodriguez Ramirez Jose Uriel  
**No. Control:** 22211645  

---

## 📜 Código utilizado

```asm
; PROGRAMA PARA VERIFICAR SI 7 ES PRIMO
;
; Si es primo, mostrará 1 en el display (Rd)
; Si no es primo, mostrará su mayor factor
;

NUMBER = 7   ; <-- Aquí pones el número que quieras verificar

start:
	data Rd, NUMBER    ; Cargar el número en Rd (display)

    mov Rb, Rd         ; Guardamos copia en Rb
	data Ra, 7         ; Usado para rotación (no lo cambiamos)

rightShift:	; Ajuste de bits
	call leftRotate
	dec Ra
	jnz rightShift
	data Ra, 0x7f
	and Ra
	mov Rb, Ra
	
	data Ra, 0x01

; Verificar si Rc es divisible por Rb
checkNext:
	cmp Rb, Ra ; si Rb llegó a 1
	jz .noresult
	
	mov Rc, Rd
	.doSubtract:
		sub Rc
		jz .result
		jc .doSubtract
		dec Rb
		jmp checkNext

	.result:
		mov Rd, Rb   ; Resultado: mayor factor
		hlt

	.noresult:
		mov Rd, 1    ; Resultado: es primo
		hlt
	
; Función auxiliar para rotación
leftRotate:
	lsr
	jnc .ret
	.lsaddone:
		inc Rb
	.ret:
		ret
