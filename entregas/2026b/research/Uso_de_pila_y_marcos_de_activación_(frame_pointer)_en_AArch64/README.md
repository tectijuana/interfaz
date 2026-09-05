# Uso de pila y marcos de activación (frame pointer) en AArch64.

![](https://www.tijuana.tecnm.mx//wp-content/uploads/2022/03/TecNM-ITT-sgc-2018-color-scaled-e1646127126124-768x234.jpg)  

**Alumno**: Bojorquez Valdez Victor Manuel.   
**No.Control**: 23211926.  
**Carrera**: Ingeniería en Sistemas Computacionales.  
**Docente**: Rene Solis Reyes.  

### Introducción: ¿A qué nos referimos con pila y marcos de activación?  

#### Pilas:
La pila es una estructura de datos utilizada en informática. Es similar a una pila de platos, donde se puede añadir o quitar un plato de la parte superior, pero no de cualquier posición. A continuación, se muestra una representación visual de una pila que almacena datos (en este caso, números).  
![](https://timosoft.wordpress.com/wp-content/uploads/2023/02/pila-en-python.png)  
Como podemos apreciar en la imagen, el 30 es el elemento superior y es el único al que podemos darle salida. Cualquier operación que busquemos hacer solo se podrá realizar con el último elemento que haya entrado en la pila (LIFO o Last In First Out). Los nuevos datos solo se pueden añadir mediante la operación de inserción y siempre se añadirán a la parte superior de la pila. Se puede insertar cualquier número de elementos en la pila y todos se añadirán, uno a uno, a la parte superior.  

#### Marcos de activación (stack frame):
Imagina que acabas de ejecutar un programa en tu ordenador. El sistema operativo llama al planificador, que reserva memoria para tu programa y lo prepara para que la CPU procese sus instrucciones. En esta memoria reservada es donde tu programa asigna la memoria de la pila. En la mayoría de los sistemas, el tamaño máximo predeterminado de la pila por hilo es de 8 MB.  

La memoria de pila se utiliza para guardar los parámetros pasados ​​al programa, asignar memoria para variables locales y almacenar el contexto de ejecución. Una de las principales diferencias entre la memoria de pila y la memoria dinámica es que la pila es mucho más rápida. Dado que el sistema operativo reserva la memoria de la pila al inicio de la ejecución, no es necesario llamar al sistema operativo cada vez que se asigna memoria.  
![](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Call_stack_layout.svg/500px-Call_stack_layout.svg.png)  
En su lugar, el código simplemente actualiza la dirección de memoria a la que apunta la parte superior de la pila y continúa la ejecución. Esto hace que la pila sea ideal para datos pequeños y de corta duración, como las variables locales, mientras que los datos más grandes o de mayor duración se asignan en la memoria dinámica mediante llamadas al sistema operativo.  

Actualmente, las CPU son capaces de realizar billones de operaciones por segundo y, en la mayoría de los casos, el impacto de las llamadas a funciones en el rendimiento es mínimo. Sin embargo, en algunos campos, como los sistemas embebidos o las aplicaciones que requieren mucha capacidad de cálculo, estas optimizaciones pueden ser cruciales. Los procesadores embebidos, por ejemplo, suelen tener un rendimiento y una memoria limitados, lo que encarece la gestión de la pila. Del mismo modo, optimizar las llamadas a funciones puede reducir la latencia en sistemas en tiempo real o acelerar los cálculos matemáticos en simulaciones que consumen muchos recursos.  

### Desarrollo: ¿Como funciona esto en AArch64?
#### Apuntadores de pila en AArch64:
-**SP (Stack Pointer / Apuntador de Pila)**: Apunta al tope actual de la pila en memoria. En AArch64 debe mantenerse siempre alineado a 16 bytes.
-**x29 / FP (Frame Pointer / Apuntador de Marco)**: Almacena la dirección base del marco de pila actual. Permite acceder a las variables locales y a los argumentos pasados a la función mediante desplazamientos (offsets) fijos, independientemente de cómo cambie SP.
-**x30 / LR (Link Register / Registro de Enlace)**: Almacena la dirección de retorno a la que debe volver el programa cuando finalice la función actual.  

#### Marco de pila en AArch64:
Un marco de pila es la sección reservada en la pila para la ejecución de una función concreta. Al llamar a una función que a su vez llama a otra (o que modifica registros preservados), se deben guardar dos elementos fundamentales al inicio: el FP (x29) de la función anterior y el LR (x30).

##### **Creación del marco en AArch64:**
1. Se decrementa SP para reservar espacio suficiente (múltiplo de 16 bytes).
2. Se guardan en la pila el antiguo x29 y el x30.
3. Se actualiza x29 (FP) para que apunte a la posición actual de SP.
  
###### **Ejemplo de la creación de un marco:**
```
sub sp, sp, #32          // Reserva 32 bytes en la pila
stp x29, x30, [sp, #16]  // Guarda FP (x29) y LR (x30) en el marco
add x29, sp, #16         // Establece el nuevo Frame Pointer (FP)
```
##### **Destrucción del marco en AArch64:**
1. Se restauran los valores originales de x29 y x30 desde la pila.
2. Se incrementa SP para liberar el espacio del marco.
3. Se retorna a la función llamadora con la instrucción ret (que salta a la dirección guardada en x30).

###### **Ejemplo de la destrucción de un marco:** 
```
ldp x29, x30, [sp, #16]  // Restaura FP y LR originales
add sp, sp, #32          // Libera el espacio reservado
ret                      // Retorna a la dirección en LR (x30)
```
#### Preservación de registros en llamadas a función (AAPCS64)
- **Callee-saved (x19–x28)**: Si la función llamada necesita utilizar estos registros, debe guardarlos previamente en su marco de pila y restaurarlos antes de retornar.
- **Caller-saved (x0–x17)**: Si la función llamadora necesita conservar sus valores a través de una subrutina, debe guardarlos en la pila antes de realizar la llamada (bl).
  
### Conclusiones personales:
Aprender cómo funciona la pila en AArch64 me ayudó a entender lo que realmente sucede en memoria detrás de una llamada a función. Este tema me dejó ver la importancia del prólogo y el epílogo para no perder el rastro de las direcciones de retorno ni corruptos datos en memoria.
  
### Referencias  
- **The Stack - Introduction to ARM AArch64 Architecture and Low-level Programming. (s. f.)**. https://hrishim.github.io/llvl_prog1_book/stack.html
- **Diniz, A. (2025, 24 enero)**. Stack Frames and Function Calls: How They Create CPU Overhead. DEV Community. https://dev.to/ariasdiniz/stack-frames-and-function-calls-how-they-create-cpu-overhead-3ap8
- **Samaras, V. (2020, 24 de mayo)**. ARM 64 Assembly series: Basic definitions and registers. Medium. https://valsamaras.medium.com/arm-64-assembly-series-basic-definitions-and-registers-ec8cc1334e40
