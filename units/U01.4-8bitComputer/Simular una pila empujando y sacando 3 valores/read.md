### HERRERA MIRANDA MARVIN JAVIER 23210602  

## PRACTICA 8BITS: SIMULACIÓN DE PILA EMPUJANDO Y SACANDO 3 VALORES  

```asm
; PRACTICA: Simulación de pila con 3 valores
;
; Empuja tres valores a la pila y luego los extrae
; Mostrando en el display cada valor en orden inverso

start:
    clra
    data SP, 0xFF      ; inicializamos el puntero de pila al final de memoria (255)

    ; --- Empujar valores ---
    data Ra, 10        ; primer valor
    push Ra

    data Ra, 20        ; segundo valor
    push Ra

    data Ra, 30        ; tercer valor
    push Ra

    ; --- Extraer valores (LIFO) ---
    pop Rd             ; debería mostrar 30
    pop Rd             ; debería mostrar 20
    pop Rd             ; debería mostrar 10

end:
    hlt                ; detener ejecución
```
<img width="1218" height="877" alt="image" src="https://github.com/user-attachments/assets/a8f2ac6c-4708-438f-8ffd-1096ecb100e0" />
<img width="1200" height="878" alt="image" src="https://github.com/user-attachments/assets/35e4a352-fe95-4123-9213-7cdd57e54977" />
<img width="1188" height="867" alt="image" src="https://github.com/user-attachments/assets/8338f494-f0d6-4ac7-8f96-972198e4c458" />


