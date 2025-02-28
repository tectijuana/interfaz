## i. Código fuente documentado

---------
	;SUÁREZ CASTRO JAIR ALBERTO 22211663
	; PROGRAMA PARA COMPARAR DOS NÚMEROS Y ENCENDER LED SI SON IGUALES
	; Este programa guarda dos números en memoria, los compara
	; y enciende un LED (pone 1 en Rd) si son iguales

	.init:
	    ; Guardar los números en memoria
	    ; Primer número: 10
	    mva #10        ; Poner 10 en Ra (primer número a comparar)
	    mvb #0x20     ; Dirección donde guardaremos el primer número
	    sto Rb, Ra    ; Guardar Ra 10 en la dirección guardada en Rb (0x20)
	    
	   ; Segundo número : 10
	    mva #10       ; Poner 10 en Ra (segundo número a comparar)
	    mvb #0x21     ; Dirección donde guardaremos el segundo número
	    sto Rb, Ra    ; Guardar Ra 10 en la dirección guardada en Rb (0x21)

	.begin:
	    ; Cargar el primer número en Ra
	    mva #0x20     ; Poner la dirección en Ra
	    lod Ra, Ra    ; Cargar el valor de memoria en la dirección Ra a Ra
    
	   ; Guardar el primer número en Rc para conservarlo
	    mov Rc, Ra
	    
	   ; Cargar el segundo número en Rb
	    mvb #0x21     ; Poner la dirección en Rb
	    lod Rb, Rb    ; Cargar el valor de memoria en la dirección Rb a Rb
	    
	   ; Recuperar el primer número en Ra
	    mov Ra, Rc
	    
	   ; Comparar Ra con Rb
	    cmp Ra        ; Compara Ra con Rb, establece Z si son iguales
	    
	   ; Por defecto, LED apagado (no son iguales)
	    mvd #0        ; Poner 0 en Rd (LED apagado)
	    
	   ; Si los números no son iguales, saltar a .end
	    jnz .end      ; Si Z no está establecido (no son iguales), saltar a .end
	    
	   ; Si llegamos aquí, los números son iguales
	    mvd #1        ; Poner 1 en Rd (LED encendido)
	    
	.end:
	    hlt           ; Detener la ejecución

---------------------
## ii. Informe
Este programa realiza una comparación entre dos números. Si los dos números son iguales, entonces manda un mensaje de encendido en la led del marcador escribiendo un uno (Encendido) y si no son iguales escribe un 0 (Apagado).

En ".init" se declaran los dos números, tanto su valor como su dirección, en este caso los dos números son 10.
En ".begin" se cargan los números para conservarlos, se recupera el primero y se comparan con cmp, si no son iguales se le pone el cero(apagado) y se finaliza con ".end". Ahora, si son iguales, entonces se muestra un uno(Prendido).

---------------------
## iii. 1.  Demostración en la computadora de 8 bits o en el emulador.
Si los dos números se encuentran igual:
![image](https://github.com/user-attachments/assets/fda4326e-e98d-41ef-8117-5aaab92ed9ca)

Si los dos números no son iguales
![image](https://github.com/user-attachments/assets/199b3b72-ce26-4697-a986-c58ef73dbc58)

