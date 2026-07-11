-------------------------------------------
Nombre de alumno: Oscar Francisco Alonso Sanchez
Numero de control: 23210539
Nombre de Profesor: Rene Solis Reyes
-------------------------------------------
Tema: Comparación de buses SPI e I2C en microcontroladores ARM
-------------------------------------------
#INTRODUCCION: 

El SPI o Serial Peripheral Interface y el I2C o Inter Integrated Circuit son dos de los protocolos de comunicación serial más utilizados en microcontroladores
incluyendo aquellos basados en la arquitectura ARM. Ambos permiten establecer la comunicación entre el microcontrolador y diferentes periféricos externos como 
sensores memorias pantallas y otros circuitos integrados. Aunque cumplen con el mismo propósito general que es facilitar el intercambio de datos entre 
dispositivos cada uno posee características propias en cuanto a velocidad número de líneas de conexión complejidad de implementación y eficiencia energética.
Por ello resulta fundamental comprender sus diferencias y similitudes para seleccionar el protocolo más adecuado según las necesidades de un
proyecto específico.

##DESARROLLO TECNICO:

*1. Arquitectura y Topologia*
   **SPI:** Utiliza una arquitectira maestro-esclavo, pero requiere al menos cuatro lineas: MOSI(Master Out Slave In), MISO (Master In Slave Out), SCK (Serial Clock)
   y SS (Slave Select) para cada esclavo. Esto significa que, a medida que se agregan más dispositivos esclavos, se necesitan más pines para las señales SS.

   **I2C:** También usa una arquitectura maestro-esclavo, pero solo necesita dos líneas: SDA (Serial Data) y SCL (Serial Clock). Todos los dispositivos se conectan
   en paralelo a estas dos líneas, y cada uno tiene una dirección única en el bus.
  
*2. Velocidad de transferencia*
   **SPI:** Ofrece mayores velocidades de transferencia que I2C, llegando fácilmente a decenas de Mbps, lo que lo hace ideal para aplicaciones que requieren alta
   velocidad de comunicación.
   
   **I2C:** Es más lento en comparación, con velocidades estándar de hasta 400 kbps (Fast-mode) y hasta 3.4 Mbps (High-speed mode), pero generalmente es más lento
   debido a la capacitancia del bus y el uso de resistencias pull-up.

*3. Direccionamiento y Expansión*
   **SPI:** No utiliza direccionamiento; la selección de esclavos se realiza mediante líneas SS dedicadas. Esto limita la cantidad de dispositivos que se pueden
   conectar fácilmente, ya que cada uno requiere un pin adicional en el maestro
   
   **I2C:** Utiliza direccionamiento, permitiendo conectar múltiples dispositivos (hasta 127) en el mismo bus usando solo dos líneas, lo que es ideal cuando los 
   pines del microcontrolador son limitados.

*4. Complejidad y Facilidad de Implementación*
   **SPI:** Es más simple en cuanto a protocolo, pero requiere más pines y cableado a medida que se agregan dispositivos.

   **I2C:** El protocolo es más complejo (manejo de direcciones, condiciones de inicio/parada, arbitraje), pero la conexión física es mucho más sencilla y
   escalable.

*5. Consumo de Pines*
  **SPI:** Mayor consumo de pines en el microcontrolador, especialmente con varios esclavos.

   **I2C:** Menor consumo de pines, ideal para aplicaciones con recursos limitados.

*6. Aplicaciones Típicas*
  **SPI:** Memorias Flash, pantallas TFT, sensores de alta velocidad.

  **I2C:** Sensores, EEPROMs, RTCs, y dispositivos donde la velocidad no es crítica pero sí la simplicidad y el bajo consumo de pines.


*Ejemplos prácticos de uso de SPI:*
En microcontroladores ARM como la familia STM32 de STMicroelectronics, el protocolo SPI se utiliza comúnmente para controlar pantallas TFT de alta resolución,
ya que requieren velocidades elevadas de transferencia de datos para mostrar gráficos fluidos. Otro ejemplo frecuente es la conexión con memorias Flash externas,
donde la rapidez en la lectura y escritura de información resulta esencial para sistemas embebidos que necesitan almacenar firmware, imágenes o registros de 
datos. También es habitual encontrar SPI en módulos de comunicación como transceptores de radiofrecuencia o en convertidores analógico-digitales (ADC) de alta
velocidad, donde el desempeño en tiempo real es prioritario.

*Ejemplos prácticos de uso de I2C:*
En cambio, en los mismos microcontroladores ARM, el bus I2C se emplea de forma intensiva para interconectar sensores ambientales como medidores de temperatura,
humedad o presión, ya que estos dispositivos suelen enviar pocos datos y no requieren altas velocidades de transmisión.También se utiliza con memorias EEPROM
para guardar configuraciones del sistema de manera sencilla, aprovechando el hecho de que con solo dos líneas se pueden conectar múltiples chips.
Otro uso típico es la conexión con relojes en tiempo real (RTC) que mantienen la hora y fecha, incluso cuando el sistema está apagado, o con expansores de
puertos GPIO, lo que permite aumentar el número de entradas y salidas digitales de un microcontrolador sin consumir demasiados pines físicos.


###CONCLUSION

Al comparar SPI e I2C en los microcontroladores ARM se puede ver que cada protocolo tiene ventajas y desventajas según lo que se busque en un proyecto.
SPI es rápido y directo de usar, lo que lo hace muy útil cuando se necesita mover muchos datos, por ejemplo en pantallas o memorias externas.
La parte negativa es que gasta más pines, sobre todo si se quieren conectar varios dispositivos.

Por otro lado, I2C es más lento y un poco más complicado de implementar, pero con solo dos líneas se pueden conectar muchos periféricos gracias a que cada
uno tiene su dirección en el bus. Esto lo vuelve muy práctico en sensores o memorias donde la velocidad no es tan importante.


###REFERENCIAS

[1] Admin, “Explicar UART, SPI E I2C en detalle,” Tecksay, https://www.tecksay.com/es/BluetoothModule&BluetoothBeacon/explicar-uart-spi-e-i2c-en-detalle (accessed Sep. 18, 2025). 
[2] I2C Frente a SPI:diferencias que debe conocer, https://es.mfgrobots.com/mfg/it/1003029791.html (accessed Sep. 18, 2025). 
[3] N. Valencia, “Diferentes protocolos para micros,” Drouiz, https://www.drouiz.com/blog/2018/06/25/uart-vs-spi-vs-i2c-diferencias-entre-protocolos (accessed Sep. 18, 2025). 
[4] “UART vs. SPI vs. I2C: Routing & Layout guidelines,” Altium, https://resources.altium.com/p/i2c-vs-spi-vs-uart-how-layout-these-common-buses (accessed Sep. 18, 2025). 
[5] “SPI vs. I2C: How to choose the best protocol for your memory chips,” Altium, https://resources.altium.com/p/spi-versus-i2c-how-choose-best-protocol-your-memory-chips (accessed Sep. 18, 2025). 
[6] Diferencias de los protocolos de Comunicación Uart vs I2C VS SPI, https://solectroshop.com/es/blog/diferencias-de-los-protocolos-de-comunicacion-uart-vs-i2c-vs-spi-n107 (accessed Sep. 18, 2025). 





   






   
   
   
