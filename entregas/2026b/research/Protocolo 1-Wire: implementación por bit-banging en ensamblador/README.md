# Protocolo 1-Wire: Implementación por bit-banging en ensamblador
## Introducción
El protocolo 1-Wire, creado originalmente por Dallas Semiconductor y actualmente perteneciente a Maxim Integrated / Analog Devices, es un tipo de comunicación serie asíncrona que permite conectar dispositivos de baja velocidad utilizando solamente un cable de datos y una conexión a tierra. Una de sus principales características es que puede proporcionar alimentación a algunos dispositivos mediante la misma línea de datos, lo que resulta útil para sensores remotos y dispositivos de seguridad.

Como muchos microcontroladores actuales no cuentan con un controlador 1-Wire integrado, es necesario utilizar una técnica llamada bit-banging. Esta consiste en controlar el protocolo mediante software, cambiando manualmente el estado de un pin GPIO. Al realizar esta implementación en un nivel bajo, utilizando lenguaje ensamblador y arquitecturas como ARM, se puede tener un mayor control sobre los tiempos de ejecución. Esto es importante en 1-Wire, ya que el protocolo requiere respetar tiempos muy específicos que se encuentran en el rango de los microsegundos.

## Desarrollo Técnico
**Topología de Hardware y el Concepto Open-Drain**  
El bus 1-Wire opera bajo una topología de "colector abierto" (open-collector) o "drenador abierto" (open-drain). Esto significa que ningún dispositivo en el bus tiene la capacidad de forzar físicamente la línea a un nivel lógico alto (VCC). En su lugar, se conecta una resistencia de pull-up externa (generalmente de 4.7 kΩ) entre la línea de datos y VCC.


Para transmitir un estado lógico "0", el microcontrolador o el esclavo conecta el pin a tierra, superando la resistencia y tirando el voltaje a 0V. Para transmitir un estado lógico "1", el dispositivo "suelta" la línea (la configura en alta impedancia), permitiendo que la resistencia pull-up recargue la capacitancia del bus y eleve el voltaje. En lenguaje ensamblador, esto implica que nunca escribimos directamente un 1 o un 0 en el registro de salida de datos del GPIO. En su lugar, el registro de salida se mantiene siempre en 0, y lo que alternamos es el registro de dirección (Direction Register) del GPIO: para escribir "0" configuramos el pin como salida, y para escribir "1" o leer, lo configuramos como entrada.

**Mapeo de Memoria (MMIO) y Barreras en ARM**  
En procesadores ARM, los periféricos GPIO se controlan mediante operaciones de carga y almacenamiento (MMIO - Memory Mapped I/O). Para manipular el pin con la menor latencia posible, el código ensamblador debe cargar la dirección base del puerto en un registro y usar desplazamientos.

Por ejemplo, conceptualmente en un ARM Cortex-M, se requiere usar la instrucción LDR R0, =GPIO_PORTA_BASE para cargar la dirección base del puerto en el registro R0, seguido de LDR R1, =PIN_MASK para definir la máscara del pin 1-Wire específico que se va a manipular.

Un aspecto crítico en arquitecturas avanzadas es el uso de memorias caché, buffers de escritura y pipelines profundos. Una instrucción de almacenamiento (STR) que cambia la dirección del pin podría retrasarse en un buffer, arruinando la temporización del protocolo. Por ello, una implementación rigurosa requiere el uso de instrucciones de barrera de memoria como DSB (Data Synchronization Barrier) e ISB (Instruction Synchronization Barrier) inmediatamente después de alterar un registro del GPIO, garantizando que el cambio de estado del pin eléctrico ocurra antes de que la CPU comience a contar los retardos.

**Cálculo Matemático de Ciclos de Reloj y Retardos**  
Para lograr la precisión de microsegundos que exige 1-Wire, el código ensamblador debe calcular bucles de retardo basados en la frecuencia del procesador. Por ejemplo, si un microcontrolador Cortex-M opera a 16 MHz, cada ciclo de reloj dura 62.5 nanosegundos.

Si el protocolo requiere un retardo exacto de 2 microsegundos (2000 ns), se necesitan exactamente 32 ciclos de reloj (2000 / 62.5 = 32). En ensamblador ARM, un bucle de retardo típico utiliza una instrucción de resta (SUBS) y un salto condicional (BNE). Si este bucle consume 3 ciclos por iteración, el registro contador debe inicializarse con un valor cercano a 10 para agotar los 32 ciclos requeridos. Este cálculo determinista es la principal ventaja técnica de usar ensamblador sobre lenguajes de alto nivel como C, donde el compilador puede alterar los ciclos generados al aplicar niveles de optimización (como -O2 u -O3).

**Gestión de Interrupciones y Cambio de Contexto**  
El mayor enemigo del bit-banging es el jitter (fluctuación temporal) introducido por las interrupciones del sistema. Si la CPU está a la mitad de una ventana de lectura crítica y ocurre una interrupción (por ejemplo, el SysTick del sistema operativo), el procesador saltará al manejador de la interrupción. Al regresar, la estricta ventana de 15 microsegundos de 1-Wire habrá expirado, corrompiendo los datos.

Para evitar esto, el programador de ensamblador debe enmascarar las interrupciones antes de iniciar un slot de tiempo crítico. En ARM Cortex-M, esto se ejecuta mediante la instrucción CPSID i (Change Processor State, Disable Interrupts) para silenciar el procesador temporalmente, y se utiliza CPSIE i (Enable Interrupts) para restaurar el flujo normal inmediatamente después de capturar o enviar el bit.

<img width="1600" height="900" alt="image" src="https://github.com/user-attachments/assets/476c2f1f-b47a-4a1a-811c-c14af34e9ac2" />

**Anatomía de los Tiempos (Time Slots) y Secuencias Lógicas**  
El protocolo define cuatro operaciones atómicas. Implementarlas en ensamblador requiere aplicar los retardos previamente calculados y la gestión de interrupciones en las siguientes fases:

* **Secuencia de Reset y Presence Pulse:**
Toda transacción inicia con un Reset. El maestro configura el pin como salida (tirando a 0V) durante al menos 480 microsegundos. Luego, cambia el pin a entrada y espera entre 15 y 60 microsegundos. Si un esclavo está conectado, responderá con un Presence Pulse, tirando la línea a 0V durante 60 a 240 microsegundos. El ensamblador debe muestrear el registro de entrada de datos en el momento exacto y verificar el bit correspondiente.

* **Escritura (Write 0 y Write 1):**
Para escribir un "1", el maestro tira la línea a bajo por un lapso muy breve (1 a 15 microsegundos) y la libera (cambia a entrada). El slot total debe durar al menos 60 microsegundos. Para escribir un "0", el maestro tira la línea a bajo y la mantiene así durante todo el slot de 60 a 120 microsegundos.

* **Lectura (Read Slot):**
Para leer un bit, el maestro inicia el slot tirando la línea a bajo durante un mínimo de 1 microsegundo y luego cambia a entrada. El estándar establece que el maestro debe muestrear el estado del pin exactamente dentro de una ventana de 15 microsegundos desde que la señal inicial cayó. Lógicamente, en ensamblador, la secuencia de lectura se estructura de la siguiente manera:

  * **Paso 1:** Se deshabilitan interrupciones (CPSID i) y se inicia el slot forzando el pin a salida con STR R1, [R0, #GPIO_DIR_OFFSET], seguido de un DSB para asegurar que el hardware registre el cambio.

  * **Paso 2:** Se introduce un retardo calibrado de aproximadamente 2 microsegundos (bucle de ciclos de reloj).

  * **Paso 3:** Se libera la línea cambiándola a entrada mediante STR R2, [R0, #GPIO_DIR_OFFSET] y otro DSB, permitiendo que la resistencia de pull-up o el esclavo dicten el estado del bus.

  * **Paso 4:** Se añade otro retardo preciso para alcanzar la ventana de los 12 a 15 microsegundos.

  * **Paso 5:** Se efectúa el muestreo leyendo el registro de entrada con LDR R3, [R0, #GPIO_IN_OFFSET]. Se utiliza la instrucción TST R3, R1 para aislar el bit objetivo, se restauran las interrupciones (CPSIE i) y mediante saltos condicionales (BNE o BEQ) se determina si el dispositivo leyó un "1" o un "0".

**Caso de Uso Práctico: Sensor de Temperatura DS18B20**  
El dispositivo 1-Wire más representativo en la industria es el sensor DS18B20. Para interactuar con él usando rutinas de bit-banging, el flujo en ensamblador implica ejecutar la rutina de Reset, leer el pulso de presencia y luego enviar una serie de bytes de comando formados por múltiples Write Slots. Por ejemplo, el controlador debe enviar 0xCC (Skip ROM, para omitir la lectura del número de serie si es el único componente en el bus) seguido de 0x44 (Convert T, para iniciar la lectura térmica). Posteriormente, el controlador utiliza múltiples Read Slots para extraer los 16 bits de resolución de la temperatura de la memoria scratchpad del sensor.

## Conclusión
La implementación del bus 1-Wire mediante bit-banging en lenguaje ensamblador permite comprender la relación que existe entre el procesador, la memoria y el funcionamiento eléctrico de un bus open-drain. Trabajar directamente con los ciclos de reloj permite cumplir con los tiempos establecidos por el protocolo de Maxim Integrated, pero también tiene algunas desventajas, como un mayor uso de la CPU y una mayor latencia en el sistema debido a la necesidad de desactivar las interrupciones durante ciertas operaciones. Aunque actualmente existen alternativas como el uso de hardware externo o periféricos UART para reducir la carga del procesador, realizar este tipo de controladores en ensamblador sigue siendo importante para comprender cómo se manejan los tiempos en sistemas embebidos.

## Bibliografía
[1] Maxim Integrated, “1-Wire Communication Through Software,” *Application Note 126*, 2002. https://d1.amobbs.com/bbs_upload782111/files_7/armok01153399.pdf

[2] Maxim Integrated, “Using a UART to Implement a 1-Wire Bus Master,” *Application Note 214*. https://www.analog.com/en/resources/app-notes/reading-and-writing-1wirereg-devices-through-serial-interfaces.html

[3] Arm Limited, *Armv8-M Architecture Reference Manual*, DDI0553B, 2021. https://community.arm.com/cfs-file/__key/communityserver-discussions-components-files/471/DDI0553B_y_armv8m_arm.pdf

[4] J. Yiu, *The Definitive Guide to ARM Cortex-M3 and Cortex-M4 Processors*, 3rd ed. Newnes, 2013. https://shop.elsevier.com/books/the-definitive-guide-to-arm-cortex-m3-and-cortex-m4-processors/yiu/978-0-12-408082-9

[5] C. Maxfield, *Bebop to the Boolean Boogie: An Unconventional Guide to Electronics*, 3rd ed. Newnes, 2008. https://shop.elsevier.com/books/bebop-to-the-boolean-boogie/maxfield/978-1-85617-507-4
