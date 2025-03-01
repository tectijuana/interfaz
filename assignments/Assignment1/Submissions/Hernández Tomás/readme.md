#addr 0x80  ; Definimos la dirección de la subrutina de suma
.add_subroutine:
  add Ra    ; Suma Rb a Ra (Ra = Ra + Rb)
  ret       ; Retorna al punto de llamada

#addr 0x90  ; Definimos la dirección de la subrutina de resta
.sub_subroutine:
  sub Ra    ; Resta Rb de Ra (Ra = Ra - Rb)
  ret       ; Retorna al punto de llamada

  ; Cargar valores en los registros
  mov Ra, 10  ; Cargar 10 en Ra
  mov Rb, 5  ; Cargar 5 en Rb

  ; Llamar a la subrutina de suma
  call 0x80    ; Llama a la subrutina de suma en 0x80
  mov Rd, Ra   ; Mueve el resultado de Ra a Rd (para mostrarlo en el display)

  ; Llamar a la subrutina de resta
  call 0x90    ; Llama a la subrutina de resta en 0x90
  mov Rd, Ra   ; Mueve el resultado de Ra a Rd (para mostrarlo en el display)

  ; Fin del programa
  hlt          ; Detiene la ejecución


###Explicación del Código:
#
#---Subrutina de Suma (add_subroutine):
#
#Utiliza la instrucción add Ra para sumar Rb a Ra.
#
#Retorna con ret al punto de llamada.
#
#---Subrutina de Resta (sub_subroutine):
#
#Utiliza la instrucción sub Ra para restar Rb de Ra.
#
#Retorna con ret al punto de llamada.
#
#---Programa Principal:
#
#Carga valores en Ra y Rb.
#
#Llama a las subrutinas usando call.
#
#Mueve el resultado a Rd para mostrarlo en el display.
#
#Finaliza con hlt.
