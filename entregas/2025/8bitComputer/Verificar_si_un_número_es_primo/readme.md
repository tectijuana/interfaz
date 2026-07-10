NUMBER = 4

start:
	data Rd, NUMBER

    mov Rb, Rd
	data Ra, 7

rightShift:	; right shift
	call leftRotate
	dec Ra
	jnz rightShift
	data Ra, 0x7f
	and Ra
	mov Rb, Ra
	
	data Ra, 0x01

; check id Rc is divisible by Rb
checkNext:
	cmp Rb, Ra ; if we're down to 1
	jz .noresult
	
	mov Rc, Rd
	.doSubtract:
		sub Rc
		jz .result
		jc .doSubtract
		dec Rb
		jmp checkNext

	.result:
		mov Rd, Rb
		hlt

	.noresult:
		mov Rd, 2
		hlt
	
leftRotate:
	lsr
	jnc .ret
	.lsaddone:
		inc Rb
	.ret:
		ret
