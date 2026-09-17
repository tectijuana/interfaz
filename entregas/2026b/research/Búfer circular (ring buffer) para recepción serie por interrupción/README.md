# Introducción

En los sistemas embebidos es común recibir información mediante
comunicación serie. Sin embargo, los datos pueden llegar en cualquier
momento mientras el microcontrolador está realizando otras tareas. Para
evitar perder información, se pueden utilizar interrupciones junto con
una estructura llamada búfer circular o ring buffer. El búfer circular
permite almacenar temporalmente los datos recibidos para que
posteriormente el programa principal pueda procesarlos. De esta manera,
la interrupción se encarga únicamente de recibir y almacenar rápidamente
los datos, mientras que el resto del programa continúa realizando sus
tareas

# ¿Qué es un búfer circular?

Un búfer circular, también conocido como ring buffer o cola circular, 
es una estructura de datos de tamaño fijo que funciona normalmente 
siguiendo el principio FIFO (First In, First Out), es decir, el primer 
dato que entra es el primero que sale. Se denomina circular porque 
cuando un índice llega a la última posición del arreglo, vuelve nuevamente
a la primera posición, permitiendo reutilizar continuamente el espacio disponible.
Es especialmente utilizado en sistemas embebidos porque permite almacenar 
información sin tener que desplazar constantemente los elementos dentro de la memoria.

# Estructura del búfer circular

Generalmente se utiliza un arreglo de tamaño fijo junto con dos índices principales:
1. Índice de escritura (head): indica la posición donde se almacenará el siguiente dato.
2. Índice de lectura (tail): indica la posición del siguiente dato que deberá ser leído.
Cuando cualquiera de los índices llega al final del arreglo, vuelve al comienzo. 
Por ejemplo, en un búfer de 8 posiciones:
0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 0 → 1...
Esto permite reutilizar las posiciones que ya fueron liberadas.

# ¿Cómo funciona? 

Un búfer circular trabaja básicamente con dos índices para acceder a los elementos del 
búfer, que aquí llamaremos Inpointer y Outpointer. Ambos índices tienen avance incremental 
y cíclico, es decir, se incrementan de uno en uno y luego de apuntar al último elemento 
del búfer vuelven a apuntar al primero.
Al inicio los dos índices apuntan al primer elemento del búfer. Veamos cómo y cuándo se incrementan:
1. Cada nuevo dato que se guarda en el búfer se deposita en la posición actualmente indicada 
por head. A continuación, head se incrementa en uno.
2. Por otro lado, cada dato que se extrae del búfer corresponde a la posición actualmente indicada 
por tail. A continuación, tail se incrementa en uno.
Estos búferes tienen un comportamiento FIFO ("First In - First Out", "Primero en entrar - primero en salir").
Cuando el búfer está lleno y se intenta almacenar un nuevo dato, el comportamiento dependerá de la 
implementación: se puede sobrescribir el dato más antiguo, descartar el nuevo dato o indicar una 
condición de desbordamiento. 
Para saber si en el búfer hay espacio para meter más datos o si hay al menos un dato para sacar,
se debe usar la diferencia entre las posiciones de los punteros. Otra posible 
opción es utilizar una variable adicional que se incremente con cada dato ingresado 
y se decrementa con cada dato extraído.

Un búfer circular comienza vacío y con un tamaño predefinido. Por ejemplo, este es un búfer de 7 elementos
`[ ][ ][ ][ ][ ][ ][ ]`

Asuma que un 1 es escrito en el medio del búfer (la locación exacta no importa en un búfer circular):
`[ ][ ][1][ ][ ][ ][ ]`

Luego, asuma que dos elementos más son añadidos — 2 y 3 — los cuales quedan añadidos después del 1:

`[ ][ ][1][2][3][ ][ ]`

Si dos elementos son eliminados del búfer, los valores más viejos dentro del búfer son borrados.
Los dos elementos borrados, en este caso, son 1 y 2; quedando el búfer con solamente un 3:

`[ ][ ][ ][ ][3][ ][ ]`

Si el búfer tiene 7 elementos se encuentra lleno:

`[3][4][5][6][7][8][9]`

Una consecuencia de los búfer circulares es que cuando se encuentra lleno y se realiza una
nueva escritura, se comienza a sobrescribir los datos antiguos. En este caso, se agregan dos
elementos más — A y B — y sobrescriben el 3 y 4:

`[A][B][5][6][7][8][9]`

Como una alternativa, se puede hacer que las rutinas que administran el búfer no permitan 
que los datos se sobrescriban y retornen un error o una excepción.
Finalmente, si dos elementos son borrados ahora, se va a retornar 5 y 6 y no 3 y 4, 
dado que A y B sobrescribieron el 3 y 4:

`[A][B][ ][ ][7][8][9]`

# Estados del búfer

El búfer circular puede encontrarse principalmente en tres estados:
1. Vacío: no existen datos pendientes por leer.
2. Parcialmente lleno: existen datos almacenados y todavía 
quedan posiciones disponibles.
3. Lleno: todas las posiciones disponibles están ocupadas.
Uno de los problemas de esta estructura es distinguir correctamente entre vacío y lleno,
ya que dependiendo de la implementación los índices de lectura y escritura pueden 
coincidir en ambos casos. Para distinguir entre estos estados pueden utilizarse diferentes
métodos, como dejar una posición libre entre los índices de lectura y escritura o utilizar
un contador que indique la cantidad de datos almacenados.

# Desbordamiento (overflow)

El overflow ocurre cuando llegan nuevos datos mientras el búfer ya está lleno.
No existe una única forma obligatoria de manejar esta situación. Dependiendo del
diseño del sistema se puede:
1. Descartar el nuevo dato recibido.
2. Sobrescribir el dato más antiguo.
3. Generar una bandera o indicador de error para informar que hubo pérdida de información.
Para recepción serie, normalmente es importante detectar esta situación porque la pérdida 
de un byte podría afectar el mensaje que se está recibiendo.

# Recepción serie por interrupción

En un sistema embebido, un periférico de comunicación serie, como una UART, puede recibir 
datos provenientes de otro dispositivo.
En lugar de hacer que el programa principal revise constantemente si llegó información, 
puede utilizarse una interrupción de recepción.
Cuando llega un nuevo byte, el periférico genera una interrupción y el microcontrolador 
suspende momentáneamente la tarea que estaba realizando para ejecutar una rutina de 
servicio de interrupción (ISR).
La ISR debe realizar pocas operaciones para terminar rápidamente. Una estrategia común 
consiste en tomar el byte recibido y almacenarlo inmediatamente dentro del búfer circular.

# Integración del búfer circular con la interrupción

El proceso completo puede entenderse de esta manera:
Dispositivo externo → Comunicación serie → Llega un byte → Se genera una interrupción 
→ Se ejecuta la ISR → El byte se guarda en el ring buffer → El programa principal lo 
lee posteriormente
Por ejemplo, si llegan consecutivamente:
H → O → L → A
cada byte genera una recepción. La ISR va almacenando los caracteres en el búfer:
[H][O][L][A][ ][ ][ ][ ]
Posteriormente, el programa principal puede leerlos siguiendo el orden FIFO:
H → O → L → A
La gran ventaja es que el programa principal no necesita procesar inmediatamente 
cada byte que llega. Una de las principales ventajas de este funcionamiento es la
operación asíncrona: la ISR puede almacenar rápidamente los datos recibidos mientras 
que el programa principal los procesa posteriormente a su propio ritmo. 

# Relación entre productor y consumidor

Otra forma sencilla de comprenderlo es mediante el modelo productor-consumidor.
En este caso:
1. Productor: la interrupción de recepción, porque introduce los bytes recibidos en el búfer.
2. Consumidor: el programa principal, porque obtiene los bytes almacenados y los procesa.
El búfer circular funciona como una zona intermedia entre ambos.
Si los datos llegan temporalmente más rápido de lo que el programa puede procesarlos,
pueden permanecer almacenados hasta que el programa principal tenga tiempo para atenderlos.

# Ventajas

1. Permite una recepción asíncrona de datos.
2. Las operaciones de lectura y escritura son rápidas.
3. No es necesario desplazar elementos dentro de la memoria.
4. Puede utilizar memoria de tamaño fijo.
5. Reduce el tiempo que debe permanecer ejecutándose la ISR.
6. Permite que el programa principal continúe realizando otras tareas.
7. Separa la recepción de los datos de su procesamiento.

# Desventajas

1. Existe riesgo de overflow si llegan datos más rápido de lo que son procesados.
2. Tiene una capacidad limitada por su tamaño.
3. Requiere controlar correctamente los índices de lectura y escritura.
4. Al ser compartido entre la interrupción y el programa principal, debe cuidarse
el acceso concurrente a sus variables.
5. Los mensajes que quedan divididos entre el final y el principio físico del arreglo 
pueden requerir lógica adicional para  procesarse.

# Aplicaciones

Los búferes circulares para recepción por interrupción pueden utilizarse en:
1. Comunicación entre microcontroladores.
2. Recepción de comandos desde una computadora.
3. Sistemas de sensores.
4. Dispositivos IoT.
5. Sistemas de adquisición de datos.
6. Terminales serie.
7. Sistemas embebidos que reciben continuamente información de otros dispositivos.

# Conclusión

El búfer circular es una estructura muy útil para la recepción serie por interrupción 
en sistemas embebidos, ya que permite almacenar temporalmente los datos recibidos mientras 
el programa principal realiza otras tareas. Su funcionamiento mediante índices de lectura y 
escritura permite reutilizar continuamente un espacio fijo de memoria.
Al combinarlo con una interrupción de recepción, la ISR puede almacenar rápidamente cada byte 
recibido para que posteriormente sea procesado por el programa principal. De esta manera, se 
logra una recepción de datos más eficiente y organizada.

## Referencias

[1] Colaboradores de Wikipedia, “Buffer circular,” *Wikipedia, la enciclopedia libre*, ene. 8, 2026. [En línea]. Disponible: https://es.wikipedia.org/wiki/Buffer_circular. [Accedido: sep. 14, 2026].

[2] K. Wada, “Ring buffer basics,” *Embedded*, 2004. [En línea]. Disponible: https://www.embedded.com/ring-buffer-basics/. [Accedido: sep. 14, 2026].

[3] P. Johnston, “Creating a circular buffer in C and C++,” *Embedded Artistry*, dic. 22, 2022. [En línea]. Disponible: https://embeddedartistry.com/blog/2017/05/17/creating-a-circular-buffer-in-c-and-c/. [Accedido: sep. 14, 2026].

[4] L. Llamas, “Buffer circular o ring buffer: qué es y usos,” *Luis Llamas*, ene. 30, 2026. [En línea]. Disponible: https://www.luisllamas.es/que-es-buffer-circular-ring-buffer/#cache-friendly. [Accedido: sep. 14, 2026].
