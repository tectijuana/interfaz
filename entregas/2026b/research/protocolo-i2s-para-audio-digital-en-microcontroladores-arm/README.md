# Protocolo I2S para audio digital en microcontroladores ARM

## Introducción
Era un paso natural que el audio digital se estableciera como un estándar en la industria. Con la creciente demanda por la digitalización, surgió la necesidad de adaptarlo y procesarlo en todo tipo de hardware, incluyendo los sistemas como los microcontroladores. En un inicio, no existía un método estándar para que los circuitos integrados comunicaran flujos de audio de forma sencilla, recurriendo a protocolos genéricos y más complejos como TDM (Time Division Multiplexing). Para solucionar esto, Philips Semiconductors introdujo en 1986 el protocolo I²S (Inter-IC Sound), el cual llegó para simplificar la interconexión y convertirse en el estándar de facto para la transmisión de audio digital entre procesadores, microcontroladores y convertidores (DAC/ADC)[1], [4].

## Arquitectura del Protocolo I²S
I²S es un protocolo de comunicación serie síncrono diseñado exclusivamente para la transmisión de datos de audio digital. A diferencia de buses como I²C o SPI, I²S separa las señales de reloj y sincronización de la línea de datos, lo que permite una sincronización determinista entre el transmisor y el receptor[1], [4].

Físicamente, utiliza una arquitectura de Controlador/Periférico (Master/Slave) y requiere tres líneas de conexión principales[1], [5]:
1. **SCK (Serial Clock) o BCLK (Bit Clock):** La señal de reloj que sincroniza la transmisión bit a bit.
2. **WS (Word Select) o LRCLK (Left/Right Clock):** Una línea que indica qué canal de audio se está transmitiendo. Típicamente, un nivel bajo (0) indica el canal izquierdo y un nivel alto (1) indica el canal derecho. Frecuentemente, esta señal opera a la misma velocidad que la frecuencia de muestreo del audio (por ejemplo, 44.1 kHz).
3. **SD (Serial Data):** La línea de datos por donde viaja la información de audio en formato de complemento a dos. En implementaciones full-duplex de microcontroladores ARM, pueden existir líneas separadas para transmisión (SD_OUT) y recepción (SD_IN)[2].

Adicionalmente, algunos DAC, ADC o códecs requieren una señal de reloj maestro (MCLK o System Clock) independiente de las tres líneas básicas de I²S. Su frecuencia suele ser un múltiplo de la frecuencia de muestreo; entre los valores utilizados se encuentran 128, 256, 384 y 512 veces Fs, dependiendo del dispositivo[5].

## Diagrama de Tiempos y Transmisión de Datos
La transmisión en I²S es estructurada y continua. Los datos se transmiten con el bit más significativo (MSB) primero. La transmisión MSB-first permite trabajar con diferentes longitudes de palabra entre transmisor y receptor; sin embargo, si el receptor admite menos bits que el transmisor, se pierde la resolución correspondiente a los bits menos significativos que no puede procesar[1], [5].

La característica técnica más distintiva del estándar I²S es el **retraso de un ciclo de reloj**. La línea WS cambia de estado un ciclo de reloj antes de que esté disponible el MSB de la nueva palabra[1], [2]. Los bits se colocan en la línea de datos en el flanco descendente del reloj y el receptor los captura en el flanco ascendente, asegurando estabilidad en la lectura[1].

## Implementación en Microcontroladores ARM
En microcontroladores basados en ARM, la implementación de I²S depende del fabricante y de la familia del dispositivo. Por ejemplo, en varios microcontroladores STM32, la interfaz I²S está integrada en el periférico SPI y comparte parte de su hardware[2]. 

Para que un procesador ARM pueda transmitir audio estéreo de alta calidad a 44.1 kHz o 48 kHz (lo que requiere mover millones de bits por segundo) sin bloquear la ejecución del programa principal, se hace uso crítico del **DMA (Direct Memory Access)**[2]. 

El flujo de trabajo estándar en ARM involucra:
1. Configurar la fuente y los divisores de reloj del periférico I²S para obtener las frecuencias requeridas de SCK y WS.
2. Reservar dos búferes de memoria en la RAM (estrategia de *Ping-Pong Buffer* o Búfer Circular).
3. Configurar el controlador DMA para que mueva automáticamente las muestras de audio desde la memoria RAM hacia el registro de transmisión de datos (DR) del periférico I²S[2].

Mientras el DMA transmite el "Búfer A" por I²S interactuando directamente con el hardware, el núcleo ARM está libre para procesar, decodificar (por ejemplo, un archivo MP3) o calcular las siguientes muestras de audio para llenar el "Búfer B". El DMA puede configurarse para utilizar un búfer circular o una estrategia de doble búfer. Cuando se alcanza la mitad o el final de una transferencia, puede generarse una interrupción para que la CPU procese o rellene la región correspondiente[2].

## Conclusión
La evolución de I²S como el estándar está en su naturaleza simple, directa y eficaz: resuelve el problema de la transmisión síncrona de audio separando las señales de reloj, selección de palabra y datos, facilitando una transmisión síncrona y determinista del audio[1]. Para el desarrollo de sistemas embebidos modernos, el soporte de I²S y DMA proporcionado por determinados microcontroladores basados en ARM permite construir aplicaciones complejas como reproductores de audio, pedales de efectos digitales o sistemas de reconocimiento de voz sin saturar los recursos computacionales de la CPU y permitiendo aún más la expansión de la era digital con la facilitación e innovación de nuevos sistemas de procesamiento de audio digital según la necesidad y solución requerida[2], [3].

## Bibliografía
* [1] Philips Semiconductors, "I2S bus specification", 1986. [Online]. Disponible: https://www.sparkfun.com/datasheets/BreakoutBoards/I2SBUS.pdf
* [2] STMicroelectronics, "RM0090 Reference manual: STM32F405/415, STM32F407/417, STM32F427/437 and STM32F429/439 advanced ARM-based 32-bit MCUs", Sección 28: Inter-IC sound (I2S) interface. 
* [3] Joseph Yiu, *The Definitive Guide to ARM Cortex-M3 and Cortex-M4 Processors*, 3ra ed. Newnes, 2013.
* [4] Keysight Technologies, "The I2S Protocol and Why Digital Audio is Everywhere", mayo 2022. [Online]. Disponible: https://www.keysight.com/blogs/en/tech/digital-test-instruments/2022/05/23/the-i2s-protocol-and-why-digital-audio-is-everywhere
* [5] DigiKey, "What is the I2S Communication Protocol", DigiKey Maker Tutorials, 2023. [Online]. Disponible: https://www.digikey.com/en/maker/tutorials/2023/what-is-the-i2s-communication-protocol
