
![logos](https://github.com/user-attachments/assets/6990d41d-7bde-425c-91cc-73c9eb7c3c0d)
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
Sumar los dígitos de un número almacenado en memoria y mostrar el resultado

**NOMBRE Y NÚMERO DE CONTROL:**  
Suárez Sandoval Alejandro - 22211664  

**NOMBRE DEL MAESTRO (A):**  
René Solis Reyes

## **Código fuente documentado**
```
; Alejandro Suarez Sandoval
; Inicio del programa
.begin:
    NUMERO = 0x20    ; Declaración de variable(númuero guardado en memoria[35])
	                 ; También puede cambiarse por una constante
    ; Inicializamos registros
    data Rb, NUMERO   ; número
    clr Ra            ; suma
    clr Rc           ; dígito
    data Rd, 10       ; 10 para hacer restas sucesivas

; Bucle principal
.loop:
    ; Verificamos si el número es mayor que 0
    tst Rb
    jz .end           ; Si Rb == 0, terminamos

    ; Extraemos el último dígito
    clr Rc            ; Limpiamos Rc (iteraciones de resta)

	.while_Rb_mayor_q_10:
    	cmp Rb, Rd        ; Comparamos Rb con 10 (en Rd)
    	jn .while_reduccion ; Si Rb < 10, terminamos
		sub Rb, Rd       ; Si no, restamos 10 a Rb
		mov Rb, Rd       ; Resultado se guarda en Rd, se mueve a Rb
		data Rd, 10      ;Borramos el valor en Rd y le asignamos 10
    	inc Rc            ; Incrementamos Rc (iteracion)
    	jmp .while_Rb_mayor_q_10 ; Repetimos
		
		.while_reduccion:
    ; Ahora Rb tiene el último dígito
    		addc Ra        ; Sumamos el dígito a Ra (suma total)
			tst Rc         ; verificamos si Rc es cero (para salir del bucle)
			jz .end         ;salimos
    		mov Rb, Rc        ; Le quitamos el ultimo digito a Rb al reemplazar con Rc
    		jmp .loop         ; Repetimos el proceso

.end:
    ; Resultado en Rd
    mov Rd, Ra
    hlt               ; Detener ejecución

```
## **Breve informe explicando la lógica y el funcionamiento**
Este programa en ensamblador está diseñado para calcular la suma de los dígitos de un número almacenado en memoria. Utiliza restas sucesivas para extraer cada dígito y lo suma en un registro acumulador.
La lógica de este programa se basa en dos ciclos, los cuales toman un número y verifican si este es mayor a cero, en caso de serlo verifica que sea también mayor, pero a diez, si es el caso, entonces procede a restarle diez en cada iteración de manera que en un acumulador se sumarán cuántas veces fue necesario restarle diez para llegar a un número menor que este, así siendo el número restante un dígito de todo el número, este se guarda en Ra(la suma total), y ahora, el número total, sin el último digito, justamente será el número de iteraciones(Rc) que se pudieron realizar, que es lo mismo a dividir el número(Rb) entre diez. De esta forma sucesivamente se sumarán todos los dígitos hasta que se termine el último.
| Código |Explicación  |
|--|--|
| `sub Rb, Rd` | Se resta `10` a `Rb` |
|`mov Rb, Rd`|Se mueve el resultado de `Rd` a `Rb`|
|`data Rd, 10`|Se restablece `Rd` a `10`|
|`inc Rc`|Se incrementa `Rc` (se cuenta la iteración)|
|`jmp .while_Rb_mayor_q_10`|Se repite el proceso mientras `Rb >= 10`|
|`.while_reduccion:`|Se ejecuta cuando `Rb < 10`|
|`addc Ra`|Se suma el dígito extraído a `Ra`|
|`mov Rb, Rc`|Se reemplaza `Rb` con `Rc` (se quita el último dígito).|
## **Demostración en la computadora de 8 bits o en el emulador.**
![Emulación en Computadora](https://github.com/user-attachments/assets/2e9d0623-1cb8-461e-8f60-525a3e1d8347)
![Emulación en Editor de texto](https://github.com/user-attachments/assets/f5861ab0-7704-4844-bdb7-20f40cfefc34)
