![Página 102 – Tecnológico Nacional de México – Tijuana](https://www.tijuana.tecnm.mx/wp-content/uploads/2022/03/TecNM-ITT-sgc-2018-color-scaled-e1646127126124-1568x479.jpg)
**TECNOLÓGICO NACIONAL DE MÉXICO**  
**INSTITUTO TECNOLÓGICO DE TIJUANA**  

**SUBDIRECCIÓN ACADÉMICA**  
**DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN**  

**SEMESTRE:**  
Enero - Junio 2025  

**CARRERA:**  
Ingeniería en Sistemas Computacionales  

**MATERIA:**  
Lenguajes de interfaz

**TÍTULO ACTIVIDAD:**  
Ensamblador 8 bits

**PARCIAL A EVALUAR:**  
1  

**NOMBRES Y NÚMEROS DE CONTROL:**  
López Méndez Juan David - 22211598

**NOMBRE DEL MAESTRO (A):**  
René Solis Reyes

# Código

.mover:		; El desplazo a la izquieda de los bits en el Registro A  
	clra  	; Limpia todos los registros  
	mva #6  ; Asigna el valor de 6 al registro A 00000110  
	mvc ra  ; Mueve el valor del Registro A al Registro C para luego  
	mvb ra  ; Mueve el valor del Registro A al Registro B, porque  
			; lsr solo funciona en el Registro B  
	lsr		; Desplaza los bits del Registro B a la izquierda  
			; es decir, 00001100, oséase 12  
	mvd rb	; Mueve el valor del Registro B al Registro D  
			; para verlo en el LED del emulador  
    
.deplazarDerecha: ; El desplazo a la derecha de los bits en el Registro A  
	mvc ra	; Asigna el valor del Registro A, 6, al Registro C  
	mvb ra	; Asigna el valor del Registro A, 6, al Registro B  
.loopDivision: ; Divide en 2 el valor de B, es decir a 3, ya que esto   
			   ; funciona como un desplazmiento de un bit a la derecha  
	dec rb	; Decrementa el valor de B  
	dec rc	; Decrementa el valor de C  
	dec rc	; Decrementa el valor de C  
	jnz .loopDivision ; Regresa al ciclo de división hasta que se haya  
					  ; dividido en 2 el número original  
	mvd rb	; Mueve el valor del Registro B al Registro D  
			; para verlo en el LED del emulador  
	nop		; para gastar tiempo para poder ver el resultado  
	nop  
	nop  
	nop  
	nop  
  	jmp .mover	; regresa al inicio  

# Logica
El desplazamiento de bits es basicamente desplazar los 1 en el número binario, ya sea a la izquierda o a la derecha.  
Si es a la izquierda, esto significa que se está multiplicando por 2. Dependiendo el número de espacios que se desee  
multiplicar, será el número de veces que se multiplique por 2, osea, 2 a la potencia del número de espacios que se desea desplazar.
Para la derecha, vendría siendo lo contrario, dividir el número entre 2, a la potencia del número de espacios que se desea desplazar.

Dado que el ensamblador utilizado solo posee la instruccion LSR, la cual equivocadamente desplaza los 1 solamente un espacio
a la izquierda, cuando debería ser a la derecha, debí usar mi ingenio para replicar el desplazo a la derecha.

Para el desplazo a la izquierda pues, use la instrucción LSR, y para la derecha un método inventado para dividir entre 2, ya que tampooco cuenta el lenguaje con la función de DIV, y desplazar así los bits a la derecha. Hacer esto en número impares hace que se pierda ese ultimo 1. 

El número utilizado fue el 6, el cual en binario es 00000110.  
Al ser desplazado a la izq. se convirtió en 00001100, el cual da 12.
Al ser desplazado a la der. ser convirtió en 00000011, el cual es 3 en decimal.

![despdderecha](https://github.com/Cheshire03/interfaz/blob/main/Class-Sessions/u1/8bitASM/Desplazamientos%20de%20bits%20a%20la%20izquierda%20y%20derecha/desplazamiento.png)
![despdizquierda](https://github.com/Cheshire03/interfaz/blob/main/Class-Sessions/u1/8bitASM/Desplazamientos%20de%20bits%20a%20la%20izquierda%20y%20derecha/desplazamiento1.png)
