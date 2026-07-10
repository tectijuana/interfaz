; FACTORIALS
;
; Cycles through factorial numbers (0! -> 5!)


.begin:
	data Rd, 1
	data Ra, 0
	push Ra
	inc Ra


.next:
	pop Rc
	inc Rc
	push Rc
	mov Rd, Ra
	mov Rb, Ra


.mul:
	add Ra
	jc .end
	dec Rc
	jz .next
	jmp .mul


.end:
	pop Rc
	jmp .begin


# 🧠 Resumen del funcionamiento


- Inicializa en **0! = 1**. 
- Usa la **pila** para llevar la cuenta del número que toca. 
- Cada factorial se calcula con **sumas repetidas (`add`)**. 
- El resultado se almacena en **`Rd`**. 
- Si el resultado excede **255**, se reinicia desde el principio. 


## 📌 Nota
El límite práctico es **5! = 120**, porque **6! = 720 → se desborda en 8 bits**. 

