# Rutinas de servicio de interrupción en Cortex-M y la tabla NVIC

**Alumno:** Duran Ponce Luis Adao Leonel.

**Matricula:** 23211951.

**Carrera:** Ingeniería en Sistemas Computacionales.

**Docente:** Rene Solis Reyes.

## Introducción: ¿A qué nos referimos con interrupciones y el NVIC?

### Interrupciones y rutinas de servicio (ISR)

En los sistemas integrados y microcontroladores, el procesador debe reaccionar inmediatamente a eventos del mundo real, como presionar un botón, recibir datos por el puerto serie o cuando se cumple el tiempo de un temporizador.

Para evitar que la CPU pierda tiempo preguntando constantemente a cada componente si cambió su estado, se utilizan las interrupciones. Una interrupción es una señal enviada al procesador que pausa temporalmente el programa principal para ejecutar una función especial 
llamada ISR, Rutina de Servicio de Interrupción. Una vez que la ISR termina, el procesador regresa a la tarea que estaba haciendo como si nada hubiera pasado.


### El controlador NVIC

En la arquitectura ARM Cortex-M, el encargado de administrar todas estas señales es el NVIC. El NVIC está integrado directamente dentro del núcleo de la CPU, lo que permite una respuesta casi instantánea a 
los eventos externos e internos.

![Diagrama de bloques de un microcontrolador](https://www.motioncontroltips.com/wp-content/uploads/2019/03/Microcontroller-Diagram.jpg)
Sus características principales son:

* **Manejo de prioridades:** Cada interrupción tiene asignado un número de prioridad. Entre más bajo sea el número, mayor es su importancia.
* **Anidamiento, o Nesting:** Si el microcontrolador está ejecutando una ISR y llega otra interrupción con un nivel de prioridad más alto, el NVIC suspende la ISR actual para atender
* inmediatamente la más urgente.

---

## Desarrollo: ¿Cómo funciona la Tabla de Vectores y el NVIC?

### La Tabla de Vectores de Interrupción

La **Tabla de Vectores** es una sección reservada en la memoria que contiene las direcciones, o punteros, a las funciones que deben ejecutarse según la interrupción generada. Por defecto, se ubica justo al inicio de la 
memoria Flash, en la dirección 0x0000_0000.

![Tabla de vectores de interrupción](https://tareasuniversitarias.com/wp-content/uploads/2013/02/Tabla-de-vectores.jpg)

Su estructura mantiene un orden fijo:

1. **Puntero de Pila Inicial, MSP:** La primera posición guarda la dirección inicial de la pila.
2. **Vector de Reset:** La dirección donde el procesador inicia la ejecución al encender o reiniciar el chip.
3. **Excepciones del Sistema:** Direcciones para errores o eventos del núcleo, como HardFault, SysTick y SVC.
4. **Interrupciones de Periféricos, IRQs:** Las direcciones para los componentes del chip, como Timers, UART, GPIO y SPI.

En modelos como los procesadores Cortex-M3 o M4, se incluye el registro VTOR, Vector Table Offset Register, el cual permite mover la tabla de vectores a la memoria RAM. 
Esto es sumamente útil cuando se desarrollan bootloaders o aplicaciones que necesitan cambiar las rutinas de interrupción en tiempo de ejecución.

### Mecanismo de Auto-stacking en las ISR

A diferencia de otras arquitecturas donde se requiere escribir código en ensamblador para guardar el estado del procesador antes de una interrupción, en ARM Cortex-M el propio hardware se encarga de este proceso mediante el Auto-stacking:

1. **Entrada a la ISR:** Al saltar la interrupción, el hardware guarda automáticamente en la memoria pila los registros esenciales: R0-R3, R12, LR, PC y xPSR.
2. **Ejecución:** La ISR se ejecuta como una función normal en C.
3. **Salida de la ISR:** Al terminar la función, el hardware restaura automáticamente los registros guardados en la pila y reanuda el programa principal.

Gracias a este diseño por hardware, el proceso de entrada y salida de una rutina de interrupción toma típicamente entre 12 y 15 ciclos de reloj.

### Optimizaciones por hardware en el NVIC

* **Tail-Chaining:** Si finaliza una ISR y ya hay otra interrupción pendiente con prioridad igual o menor, el procesador salta directamente a la siguiente rutina sin gastar tiempo en restaurar y volver a guardar registros en la pila.
* **Late Arrival:** Si se dispara una interrupción de mayor prioridad mientras el chip apenas estaba guardando los registros para una menos importante, el procesador conmuta para atender primero la de mayor importancia.

---

## Conclusiones personales

Estudiar cómo funciona el NVIC y la tabla de vectores me ayudó a comprender la arquitectura interna de los procesadores ARM Cortex-M cuando trabajan en tiempo real. Me pareció muy interesante la forma en que el hardware gestiona el 
auto-stacking, ya que facilita escribir rutinas de interrupción directamente en C sin perder rendimiento ni preocuparse por guardar manualmente los registros de la CPU.

### Referencias
- **ARM Software. (s. f.)**. *CMSIS-Core (Cortex-M): Interrupts and Exceptions (NVIC)*. ARM CMSIS Documentation. https://arm-software.github.io/CMSIS_5/Core/html/group__NVIC__gr.html
- **EmbeddedSoft. (2021)**. *ARM Cortex-M NVIC Interrupt Latency Optimization*. https://www.embeddedsoft.net/arm-cortex-m-nvic-interrupt-latency-optimization/
- **Interrupt by Memfault. (2020)**. *A Practical guide to ARM Cortex-M Exception Handling*. Memfault. https://interrupt.memfault.com/blog/arm-cortexm-exceptions-and-interrupts
