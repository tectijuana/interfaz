# Medición y optimización de latencia en interfaces de tiempo real

## Introducción

En los sistemas de tiempo real es importante que el procesador pueda responder rápidamente cuando ocurre un evento. Por ejemplo, un sensor puede generar una interrupción y el sistema debe atenderla en un tiempo determinado.

El tiempo que transcurre desde que ocurre el evento hasta que el procesador comienza a atenderlo se conoce como **latencia**.

En la materia de **Lenguajes de Interfaz**, este tema se puede relacionar con el funcionamiento interno del procesador, el lenguaje ensamblador, las interrupciones, los registros, los ciclos de reloj y el acceso a memoria.

El objetivo de esta investigación es explicar cómo se puede medir la latencia y qué técnicas pueden utilizarse para reducirla en interfaces y sistemas de tiempo real.

---

## 1. ¿Qué es la latencia?

La latencia es el tiempo que transcurre entre que ocurre un evento y el momento en que el sistema comienza a responder a dicho evento.

En un sistema de tiempo real, una latencia alta puede provocar que la respuesta llegue demasiado tarde.

Un ejemplo sencillo es el siguiente:

**Evento → Interrupción → Atención del procesador → Ejecución de instrucciones → Respuesta**

La latencia puede medirse utilizando unidades de tiempo, como nanosegundos o microsegundos, pero también puede medirse mediante la cantidad de **ciclos de reloj** que utiliza el procesador.

---

## 2. Factores que afectan la latencia

La latencia de un sistema puede depender de diferentes factores, entre ellos:

* Tiempo necesario para detectar una interrupción.
* Prioridad asignada a la interrupción.
* Instrucción que se está ejecutando cuando ocurre el evento.
* Tiempo utilizado para guardar y restaurar registros.
* Accesos a memoria.
* Cantidad de instrucciones que contiene una rutina de atención de interrupción.
* Esperas relacionadas con periféricos.
* Organización de la memoria y caché.
* Frecuencia del procesador.

Por esta razón, para reducir la latencia es necesario identificar qué parte del proceso está consumiendo más tiempo.

---

## 3. Medición mediante ciclos de reloj

Una forma de medir la latencia es utilizar los ciclos de reloj del procesador.

En arquitecturas ARM64 existen mecanismos de monitoreo de rendimiento que permiten obtener información relacionada con los ciclos ejecutados. Uno de ellos es el contador **PMCCNTR**.

El acceso a este contador depende del procesador, del nivel de privilegio y de la configuración del sistema operativo, por lo que no siempre puede utilizarse directamente desde una aplicación común.

La fórmula básica para obtener los ciclos utilizados es:

**Latencia = ciclos finales − ciclos iniciales**

Por ejemplo, si se registran 500 ciclos entre el inicio y el final de una operación, se puede utilizar esa cantidad para analizar el tiempo empleado.

Si el procesador trabaja a una frecuencia de 1 GHz, de manera aproximada un ciclo corresponde a 1 nanosegundo. Por lo tanto:

**500 ciclos ≈ 500 ns**

Esta relación es aproximada y depende de la frecuencia real del procesador.

---

## 4. Ejemplo de medición de una interrupción

Para medir la latencia de una interrupción se puede seguir un proceso como el siguiente:

1. Registrar el contador de ciclos antes del evento.
2. Generar o esperar el evento.
3. Detectar la interrupción.
4. Ejecutar la rutina de atención de la interrupción.
5. Registrar nuevamente el contador de ciclos.
6. Restar el valor inicial al valor final.
7. Repetir la prueba varias veces.
8. Comparar los resultados obtenidos.

Un ejemplo de mediciones podría ser:

| Prueba | Ciclos medidos | Latencia aproximada |
| ------ | -------------: | ------------------: |
| 1      |            820 |              820 ns |
| 2      |            845 |              845 ns |
| 3      |            810 |              810 ns |
| 4      |            830 |              830 ns |
| 5      |            825 |              825 ns |

Las pequeñas diferencias entre las pruebas pueden deberse a otros procesos que se estén ejecutando en el sistema o a las condiciones del procesador.

---

## 5. Relación con lenguaje ensamblador

La latencia también está relacionada con las instrucciones que ejecuta el procesador.

En lenguaje ensamblador se pueden realizar operaciones como:

* Cargar datos desde memoria.
* Guardar datos en memoria.
* Realizar operaciones aritméticas.
* Comparar valores.
* Realizar saltos.
* Manipular registros.

La cantidad y el tipo de instrucciones utilizadas pueden influir en el tiempo de ejecución de una operación.

Por ejemplo, una rutina que contiene muchas instrucciones y accesos innecesarios a memoria puede tardar más tiempo que una rutina más sencilla.

Por esta razón, el análisis de instrucciones en ensamblador puede ayudar a identificar partes del código que pueden ser optimizadas.

---

## 6. Interrupciones y latencia

Una interrupción permite que un dispositivo o evento solicite la atención del procesador.

Un flujo simplificado puede representarse de la siguiente manera:

**Evento → Señal de interrupción → Procesador → Rutina de atención (ISR) → Procesamiento → Retorno**

La rutina que atiende la interrupción se conoce como **ISR (Interrupt Service Routine)**.

Una recomendación importante es mantener la ISR lo más corta posible. Si una ISR realiza demasiadas operaciones, puede aumentar el tiempo durante el cual el procesador permanece atendiendo esa interrupción.

---

## 7. Prioridades de interrupción

Cuando existen varias interrupciones, el sistema puede utilizar diferentes niveles de prioridad.

Una interrupción de mayor prioridad puede ser atendida antes que otra de menor prioridad.

La asignación correcta de prioridades puede ayudar a que los eventos importantes sean atendidos rápidamente.

Sin embargo, una mala configuración de prioridades puede provocar que algunas interrupciones tengan que esperar demasiado tiempo.

Por eso, al diseñar un sistema de tiempo real es importante considerar cuáles eventos necesitan una respuesta más rápida.

---

## 8. Técnicas para reducir la latencia

Existen diferentes técnicas que pueden utilizarse para disminuir la latencia.

### 8.1 Reducir el código dentro de la ISR

La rutina de atención de interrupciones debe contener solamente las operaciones necesarias.

Las operaciones que no sean urgentes pueden realizarse posteriormente fuera de la ISR.

### 8.2 Optimizar el código crítico

Las partes del programa que necesitan responder rápidamente pueden optimizarse utilizando instrucciones adecuadas y evitando operaciones innecesarias.

En algunos casos, el análisis del código ensamblador permite identificar instrucciones que pueden reducirse o mejorarse.

### 8.3 Reducir accesos innecesarios a memoria

Los accesos a memoria pueden agregar tiempo a la ejecución.

Cuando sea posible, se pueden utilizar registros para almacenar temporalmente los datos que se necesitan con mayor frecuencia.

### 8.4 Utilizar prioridades adecuadas

Las interrupciones importantes deben contar con una prioridad adecuada para evitar esperas innecesarias.

### 8.5 Medir antes y después

Una optimización debe comprobarse mediante mediciones.

El proceso puede ser:

**Medir → Analizar → Optimizar → Medir nuevamente**

De esta manera se puede comprobar si realmente disminuyó la latencia.

---

## 9. Ejemplo de optimización

Supongamos que una rutina de atención de interrupción inicialmente utiliza 1200 ciclos.

Después de analizar el código y eliminar algunas operaciones innecesarias, la rutina utiliza 750 ciclos.

| Situación            | Ciclos |
| -------------------- | -----: |
| Antes de optimizar   |   1200 |
| Después de optimizar |    750 |

La reducción obtenida es:

**1200 − 750 = 450 ciclos**

Porcentaje aproximado de reducción:

**(450 / 1200) × 100 = 37.5 %**

Este ejemplo muestra cómo las mediciones pueden utilizarse para comprobar los resultados de una optimización.

---

## 10. ARM64 y RISC-V

La medición de ciclos también puede estudiarse en diferentes arquitecturas de procesadores.

En **ARM64**, existen mecanismos de monitoreo de rendimiento que pueden utilizarse para obtener información sobre la ejecución del procesador. Uno de los elementos relacionados con esta medición es el contador **PMCCNTR**.

En **RISC-V**, existe el contador **mcycle**, que permite contar ciclos de reloj del procesador. El acceso y las condiciones de uso dependen del nivel de privilegio y de la implementación utilizada.

Estas herramientas permiten analizar cuánto tiempo puede tardar una sección determinada del código y pueden ser útiles para estudiar la latencia en sistemas de tiempo real.

---

## 11. Importancia en interfaces de tiempo real

La latencia es especialmente importante en sistemas que necesitan responder rápidamente a eventos externos.

Algunos ejemplos son:

* Sistemas de control.
* Robots.
* Sensores.
* Sistemas industriales.
* Sistemas electrónicos.
* Sistemas de adquisición de datos.
* Aplicaciones controladas mediante interrupciones.

En estos sistemas, una respuesta demasiado lenta puede afectar el funcionamiento esperado.

Por eso, conocer el funcionamiento del procesador, las interrupciones, los registros y los ciclos de reloj ayuda a comprender mejor el comportamiento de una interfaz de tiempo real.

---

## 12. Conclusión

La medición y optimización de la latencia permite conocer cuánto tiempo necesita un sistema para responder ante un evento.

En el contexto de **Lenguajes de Interfaz**, este tema puede estudiarse desde un nivel más cercano al hardware mediante conceptos como ciclos de reloj, interrupciones, registros, ensamblador y acceso a memoria.

Una forma de mejorar el rendimiento consiste en medir primero la latencia, analizar las partes que consumen más tiempo, realizar una optimización y volver a medir.

El proceso puede resumirse como:

**Medir → Analizar → Optimizar → Volver a medir**

De esta manera se puede comprobar mediante datos si una modificación realmente ayuda a reducir la latencia.

---

## 13. Referencias

[1] Arm Limited, *Arm Architecture Reference Manual for A-profile architecture*, Arm Developer, 2024. [Online]. Available: https://developer.arm.com/documentation/ddi0487/latest/

[2] Arm Limited, *Learn the Architecture - AArch64 Instruction Set Architecture*, Arm Developer. [Online]. Available: https://developer.arm.com/documentation/102374/latest/

[3] Arm Limited, *Performance Monitors Extension*, Arm Developer. [Online]. Available: https://developer.arm.com/documentation/ddi0487/latest/

[4] RISC-V International, *The RISC-V Instruction Set Manual, Volume II: Privileged Architecture*, RISC-V International. [Online]. Available: https://docs.riscv.org/reference/isa/priv/machine.html

[5] RISC-V International, *RISC-V Instruction Set Manual*, RISC-V International. [Online]. Available: https://docs.riscv.org/

[6] A. Silberschatz, P. B. Galvin and G. Gagne, *Operating System Concepts*, 10th ed. Hoboken, NJ, USA: Wiley, 2018.

[7] J. L. Hennessy and D. A. Patterson, *Computer Architecture: A Quantitative Approach*, 6th ed. Cambridge, MA, USA: Morgan Kaufmann, 2019.
