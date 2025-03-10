```
ASM
Mendoza Panduro Jesus Enrique 21211995

; Algoritmo de burbuja para ordenar una lista en memoria (8 bits)

.start:
  clra
  inc Rb            ; Rb = 1 (bandera de intercambio)
  ldi Rc, 4         ; Rc = tamaño de la lista - 1

.outer_loop:
  clra
  mov Rb, Rc        ; Reiniciar contador interno
  ldi Ri, .list     ; Ri apunta al inicio de la lista

.inner_loop:
  lod Ra, Ri        ; Cargar el número actual en Ra
  lod Rd, Ri+1      ; Cargar el siguiente número en Rd
  cmp Ra, Rd        ; Comparar Ra y Rd
  jle .no_swap      ; Si Ra <= Rd, no intercambiar

  mov Rf, Ra        ; Intercambiar en registros
  mov Ra, Rd
  mov Rd, Rf
  sto Ra, Ri        ; Guardar de vuelta en memoria
  sto Rd, Ri+1
  inc Rb            ; Indicar que hubo intercambio

.no_swap:
  inc Ri            ; Mover al siguiente par
  dec Rb            ; Disminuir el contador interno
  jnz .inner_loop   ; Si no hemos terminado, repetir

  tst Rb            ; ¿Hubo intercambio?
  jz .done          ; Si no hubo, la lista está ordenada

  jmp .outer_loop   ; Repetir el proceso

.done:
  hlt               ; Terminar ejecución

.list:
#d 9, 5, 3, 7, 1    ; Lista desordenada

; ============================================
; Algoritmo de Burbuja - 8 bits
; Imagen: https://ibb.co/Fpc7T1y
; ============================================


```
