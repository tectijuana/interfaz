# Miguel Angel Lopez Garibay  
**Número de control:** 21212576  

---

# Rotación de bits en el Troy Breadboard Computer

## Introducción  
El **Troy Breadboard Computer** es un simulador educativo de una computadora de 8 bits, que permite entender cómo funcionan instrucciones básicas a nivel de máquina en un procesador sencillo.  
Una de las operaciones importantes en sistemas digitales es la **rotación de bits**, la cual consiste en desplazar los bits de un registro y “reciclar” el bit que sale para colocarlo del otro lado.  

Este programa realiza una **rotación a la izquierda simulada** en el registro `Rc`, mostrando cómo se puede implementar esta operación usando las instrucciones disponibles en el simulador.

---
<img width="1559" height="650" alt="image" src="https://github.com/user-attachments/assets/6f247eaf-cc80-4b48-affd-997d53dca02f" />

## Funcionamiento del código  

1. **Inicialización del patrón**  
   - Se define un patrón inicial (`0b11001100`) que se carga en el registro `Rc`.  
   - Este valor será el que se rote continuamente.

2. **Copia y desplazamiento**  
   - El contenido de `Rc` se copia a `Rb`.  
   - Sobre `Rb` se ejecuta la instrucción `lsr` (logical shift right), la cual desplaza los bits hacia la derecha y envía el bit menos significativo al flag de **Carry**.  

3. **Uso del Carry como rotación**  
   - Si el flag **Carry** queda en 1, significa que el bit que “salió” debe regresar al inicio de la cadena de bits.  
   - Para simular eso, se incrementa `Rb` (`inc Rb`), lo que coloca un 1 en el bit más bajo.  

4. **Resultado en Rc y visualización**  
   - El valor procesado en `Rb` se copia de vuelta a `Rc`.  
   - Opcionalmente se pasa también a `Rd` para poder observar el resultado en el display decimal que ofrece el simulador.  
   - Se agregan algunas instrucciones `nop` (no operation) para dar un pequeño retardo visual y permitir ver los cambios paso a paso.  

5. **Bucle infinito**  
   - Se usa `jmp .loop` para que el proceso de rotación s

   <img width="869" height="686" alt="image" src="https://github.com/user-attachments/assets/58973810-0af5-4b78-97ae-60d092ae048d" />
 Verás que el número decimal que aparece en la pantalla cambia constantemente.

**Ejemplo:** 

-11001100 en binario = 204 en decimal

-10011001 = 153

-00110011 = 51

-01100110 = 102

-…y luego vuelve a 204.

-Esto confirma que los bits se están reacomodando.
## Cómo se visualiza en Troy Breadboard  

En el simulador se pueden ver los registros y su contenido en tiempo real:  

- **Rc** irá cambiando en cada iteración, mostrando cómo el patrón inicial se va rotando.  
- **Carry flag** refleja si el bit desplazado es 0 o 1.  
- **Rd** (si está conectado a la salida) permitirá ver el valor decimal correspondiente en el display, mostrando cómo cambian los bits a nivel numérico.  

De esta forma, el estudiante observa el efecto de la rotación directamente en los registros y en el display del simulador.  

---

## Conclusión sencilla  

Este ejercicio muestra cómo una operación compleja como la **rotación de bits** puede construirse paso a paso usando instrucciones básicas de un procesador.  
En el Troy Breadboard Computer se visualiza claramente el movimiento de los bits y el uso del **Carry flag**, lo cual ayuda a comprender mejor la lógica interna de las computadoras de 8 bits y el valor educativo de este simulador.  
