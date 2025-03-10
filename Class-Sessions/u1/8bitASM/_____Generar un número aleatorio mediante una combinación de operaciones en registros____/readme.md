*TECNOLÓGICO NACIONAL DE MÉXICO*  
*INSTITUTO TECNOLÓGICO DE TIJUANA*

*SUBDIRECCIÓN ACADÉMICA*  
*DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN*

*SEMESTRE:*  
Enero - Junio 2025

*CARRERA:*  
Ingeniería en Sistemas Computacionales

*MATERIA:*  
Lenguajes de interfaz

*TÍTULO ACTIVIDAD:*  
Generar un número aleatorio mediante una combinación de operaciones en registros

*NOMBRE Y NÚMERO DE CONTROL:*  
Sandoval Marquez Oscar Sebastian - 22211660  

*NOMBRE DEL MAESTRO(A):*  
René Solis Reyes
```assembly
  ; Sandoval Marquez Oscar Sebastian
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
