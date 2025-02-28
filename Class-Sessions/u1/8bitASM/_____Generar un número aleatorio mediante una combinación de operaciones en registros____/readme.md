; FIBONACCI SEQUENCE; Programa para comparar valores y mover el menor a un registro y el mayor a otro

#addr 0x00      ; Establecer la dirección de inicio en 0x00
start:
  mva #10       ; Inicia el registro Ra con el valor 10
  mvb #20       ; Inicia el registro Rb con el valor 20
  mvc #0        ; Inicia el registro Rc con el valor 0 (para el menor valor)
  mvd #0        ; Inicia el registro Rd con el valor 0 (para el mayor valor)

.compare:
  cmp Ra        ; Compara Ra con Rb
  jc .swap      ; Si Ra es menor, salta a .swap
  mov Rc, Rb    ; Si Ra es mayor o igual, mueve Rb a Rc (menor valor)
  mov Rd, Ra    ; Mueve Ra a Rd (mayor valor)
  jmp .loop     ; Salta a .loop

.swap:
  mov Rc, Ra    ; Si Ra es menor, mueve Ra a Rc (menor valor)
  mov Rd, Rb    ; Mueve Rb a Rd (mayor valor)

.loop:
  ; Incrementa y decrementa los valores de forma no secuencial
  inc Ra        ; Incrementa el valor en el registro Ra
  inc Ra
  dec Rb        ; Decrementa el valor en el registro Rb
  dec Rb
  dec Rb
  
  ; Intercambia los valores entre los registros de forma no secuencial
  mov Rc, Ra    ; Mueve el valor de Ra a Rc (menor valor)
  mov Rd, Rb    ; Mueve el valor de Rb a Rd (mayor valor)

  jmp .compare  ; Salta a la etiqueta .compare para continuar comparando

; Fin del programa
