# ⚡ Mostrar una secuencia de 1 a 5 en el display decimal 🔧

---

## Autor

**Nombre:** Kain Alejandro Novelo Astorga  

**Matrícula:** 22211623  

---

## 🖥️ Código ensamblador

```asm
; Mostrar secuencia 1 a 5 en el display decimal
start:
    data Rd, 1   ; Mostrar el número 1 en el display
    data Rb, 6   ; Valor límite (una unidad más que 5)

.loop:
    call delay     ; Pequeño retardo
    inc Rd         ; Incrementar número en display
    cmp Rd, Rb     ; Comparar Rd con 6
    jz .end        ; Si Rd == 6, terminar
    jmp .loop      ; Si no, repetir

.end:
    hlt            ; Fin del programa

; Rutina de retardo
delay:
    data Rc, 0x10  ; Contador del retardo
.wait:
    dec Rc         ; Restar 1
    jnz .wait      ; Repetir mientras Rc ≠ 0
    ret
