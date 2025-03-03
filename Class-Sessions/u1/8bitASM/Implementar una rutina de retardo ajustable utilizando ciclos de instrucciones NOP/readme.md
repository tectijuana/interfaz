# Código fuente documentado.

	;*******************************************************
	; Nombre del Proyecto: [Implementar una rutina de retardo ajustable utilizando ciclos de instrucciones NOP]
	; Autor: [Vargas Perez Leonardo Gael - 22211669]
	; Fecha: [27/02/2025]
	;*******************************************************
	mov Rd, 10  ; Inicializa Rd con 10

	.delay_loop:
    nop         ; Retardo de 1 ciclo
    nop         ; Retardo de 1 ciclo
    nop         ; Retardo de 1 ciclo
    dec Rd        ; Decrementa Rd
    jmp 5     ; Salta al Nop para seguir Decrementando Rd
    
# Breve informe explicando la lógica y el funcionamiento.

Explicación del código
Inicialización:  mov Rd, 10: Inicializa el registro Rd con el valor 10. Este valor se mostrará en el display conectado a Rd.

Bucle de retardo:  .delay_loop: Etiqueta que marca el inicio del bucle.

nop:  Instrucción de No Operación. No hace nada, pero consume un ciclo de reloj. Se usa para crear un pequeño retardo.

### Se repite nop tres veces para crear un retardo más largo.

Decremento:  dec Rd: Decrementa el valor en Rd en 1. Por ejemplo, si Rd era 10, ahora será 9.

Salto condicional:  jmp 5: Esta instrucción es un salto incondicional. Sin embargo, el valor 5 no es una dirección válida en este contexto. lo use para experimentar.

### Demostración en la computadora de 8 bits o en el emulador.

Emulador
![image](https://github.com/user-attachments/assets/ebded896-07d1-479e-bfb0-64de155aa35a)


Computadora 8 bits
![image](https://github.com/user-attachments/assets/b03ffb83-b26a-4357-89c4-098c64cb43e4)
