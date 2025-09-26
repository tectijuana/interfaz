Titulo: Verificar si el numero 7 es primo
Nombre: Angel Abraham Diaz Chavelas
No.Co: 22211553

# Verificar si el numero 7 es primo

```text
Codigo:
; Verifica si un número es primo
; Muestra 1 si lo es, o su mayor divisor si no lo es

NUM = 7              ; Cambia este valor por el número a verificar

start:
    data Rd, NUM      ; Guarda el número original en Rd (visible en display)
    mov Rb, Rd        ; Rb = número a dividir
    dec Rb            ; Comenzamos desde NUM - 1

.loop:
    data Ra, 1        ; Ra = 1
    cmp Rb            ; ¿Rb == 1?
    jz .isPrime       ; Si sí, es primo

    mov Rc, Rd        ; Rc = número original

.checkDivision:
    sub Rc, Rb        ; Rc -= Rb
    jz .notPrime      ; Si Rc == 0, encontró divisor → no primo
    jc .next          ; Si Rc < 0, no es divisor

    jmp .checkDivision

.next:
    dec Rb
    jmp .loop

.notPrime:
    mov Rd, Rb        ; Mostrar el divisor más grande
    hlt

.isPrime:
    mov Rd, 1         ; Mostrar 1 → es primo
    hlt
```

<img width="1664" height="1101" alt="image" src="https://github.com/user-attachments/assets/930d8312-da0f-4616-a249-29a93a6c7389" />
Conclucion: Al ser 7 un numero primo, en el display se muestra un 1 confirmandolo 
