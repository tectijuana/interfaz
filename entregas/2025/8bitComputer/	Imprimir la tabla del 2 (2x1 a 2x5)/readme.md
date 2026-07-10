# 	Imprimir la tabla del 2 (2x1 a 2x5)
**Avilez Jr Rogelio** 
**No. Control 22210284**

## Codigo
```asm

; TABLA DEL 2 (2x1 a 2x5)
; Cada resultado se muestra en el display decimal (Rd)

.begin:
    clra              ; limpiar registros
    data Ra, 1        ; Ra = 1 (contador, empieza en 1)

.loop:
    mov Rb, Ra        ; Rb = copia de Ra
    add Ra            ; Ra = Ra + Rb  (ahora contiene 2*Ra original)
    mov Rd, Ra        ; mostrar resultado en display

    ; restaurar contador (Ra se destruyó con la suma)
    mov Ra, Rb        ; Ra = valor original del contador

    ; incrementar el contador
    inc Ra
    data Rb, 6        ; Rb = 6 (valor límite)
    cmp Ra            ; compara Ra con Rb
    jnz .loop         ; si aún no llegamos a 6, repetir

.end:
    hlt               ; fin del programa
 ```
 ## Captura
<img width="1041" height="801" alt="image" src="https://github.com/user-attachments/assets/bf8f7ab1-245d-4e6b-ad17-3ec1025f6389" />
