# Reloj de tiempo real (RTC): mantenimiento de fecha y hora en sistemas embebidos

**Autor:**
Vazquez Sanchez Cesar Ricardo

**Curso:**
Lenguajes de Interfaz

**Tema #38**

---

## Introducción

Al momento de diseñar un sistema embebido, no siempre es suficiente con saber qué valor está midiendo un sensor, también se necesita saber exactamente cuándo es que sucedió esa medición. Un microcontrolador puede llevar una cuenta del tiempo por medio de sus propios temporizadores, pero mantener una fecha y hora de manera continua ocupa otra solución, y es aquí donde aparece el RTC (Real-Time Clock), el cual es un circuito especializado en mantener la referencia temporal de un sistema.

Este documento explica qué es un RTC y para qué sirve, cómo puede mantener la hora, las diferencias de usar un RTC interno o uno externo, factores que afectan su precisión y finalmente algunas aplicaciones.

---

## Desarrollo técnico

### 1. ¿Qué es un RTC y para qué sirve?

Un RTC (Real-Time Clock) es un circuito o periférico encargado de mantener una referencia de tiempo dentro de un sistema electrónico. Su función es llevar el conteo de segundos, minutos, horas y, dependiendo del dispositivo, también de la fecha, incluyendo día, mes, año y día de la semana. A diferencia de un temporizador utilizado únicamente para medir intervalos, un RTC está orientado a conservar una referencia temporal que pueda relacionarse con una fecha y una hora determinadas [1][2].

El uso de un RTC es importante en sistemas embebidos donde no es suficiente con solo saber que pasó un evento, sino que también es necesario saber cuándo ocurrió.

Por ejemplo, un sistema puede registrar una medición de temperatura, un acceso, una alarma o una transacción y asociarla con la hora y fecha correspondientes. De esta forma, el tiempo se convierte en parte de la información que maneja el sistema.

---

### 2. ¿Cómo mantiene la hora?

Para mantener el tiempo, un RTC necesita una fuente de referencia periódica y estable. Una de las referencias más utilizadas es un cristal de cuarzo de **32.768 kHz**. El PCF8563 de NXP, por ejemplo, utiliza un cristal de esta frecuencia como referencia para mantener los valores de año, mes, día, día de la semana, horas, minutos y segundos [2].

La frecuencia de **32.768 kHz** resulta especialmente conveniente porque puede dividirse sucesivamente entre dos hasta obtener una frecuencia de **1 Hz**:

```text
32,768 Hz
    ↓
16,384
    ↓
8,192
    ↓
4,096
    ↓
2,048
    ↓
1,024
    ↓
512
    ↓
256
    ↓
128
    ↓
64
    ↓
32
    ↓
16
    ↓
8
    ↓
4
    ↓
2
    ↓
1 Hz
```

Una frecuencia de 1 Hz representa un pulso por segundo. A partir de este conteo, el RTC puede incrementar los segundos y producir los cambios correspondientes en minutos, horas y fechas. El proceso puede continuar mediante registros internos que almacenan los diferentes componentes de la fecha y la hora.

Los dispositivos no solamente cuentan segundos de forma independiente. También deben manejar los cambios entre unidades de tiempo. Por ejemplo, al llegar a **23:59:59**, el siguiente cambio debe producir **00:00:00** y aumentar el día.

De forma parecida, cuando termina un mes, el RTC debe pasar al siguiente mes y después incrementar el año. El RTC documentado por Microchip realiza estos cambios mediante registros para segundos, minutos, horas, día, mes y año, además de contemplar la corrección de años bisiestos [5].

---

### 3. RTC interno y RTC externo

Un RTC puede encontrarse integrado dentro del propio microcontrolador o implementarse mediante un circuito externo conectado al sistema.

En un **RTC interno**, el periférico forma parte del microcontrolador. Microchip documenta, por ejemplo, módulos RTC en microcontroladores tinyAVR y megaAVR que cuentan con un contador de tiempo real y un temporizador de interrupciones periódicas. Estos recursos pueden utilizarse para generar interrupciones y también para despertar al microcontrolador desde determinados modos de suspensión [3].

Una de las ventajas de este enfoque es que no se necesita a fuerzas un circuito integrado RTC independiente. El microcontrolador puede configurar directamente su periférico y utilizar sus registros e interrupciones para mantener la base de tiempo.

El documento AVR134 de Microchip muestra una implementación de RTC utilizando un temporizador funcionando de manera asíncrona y una referencia externa de 32.768 kHz [4].

En cambio, un **RTC externo** es un circuito integrado dedicado conectado al microcontrolador. El **DS3231** y el **PCF8563** son ejemplos de este tipo. El microcontrolador se comunica con ellos mediante **I²C** para configurar o leer la información de tiempo [1][2].

Esta diferencia es importante al diseñar un sistema embebido porque la elección depende mucho de las características del microcontrolador y de los requisitos de precisión y complejidad del proyecto.

---

### 4. Precisión y alimentación de respaldo

La precisión de un RTC depende de la referencia utilizada para generar la base de tiempo y de las condiciones en las que funciona. Un cristal de cuarzo no produce una frecuencia absolutamente perfecta, por lo que pequeñas variaciones pueden acumularse con el paso del tiempo.

El **DS3231** utiliza un oscilador de cristal compensado en temperatura (TCXO) y especifica una precisión de **±2 ppm entre 0 °C y 40 °C** y de **±3.5 ppm entre -40 °C y +85 °C** [1]. Esto muestra que la temperatura es un factor que debe tenerse en cuenta cuando se requiere un mantenimiento de tiempo más preciso.

Microchip también documenta mecanismos de calibración para sus módulos RTCC. El Technical Brief TB3124 describe la posibilidad de realizar calibración mediante ajustes periódicos y señala que el módulo puede compensar errores del cristal, permitiendo mejorar la exactitud del mantenimiento del tiempo [5].

Otro elemento fundamental es la **alimentación de respaldo**. Un RTC externo puede utilizar una fuente secundaria para continuar funcionando cuando la alimentación principal del sistema se interrumpe.

El DS3231 cuenta con una entrada específica para alimentación de respaldo y puede mantener el conteo del tiempo cuando la alimentación principal deja de estar disponible [1].

---

### 5. Aplicaciones en sistemas embebidos

Los RTC son útiles en sistemas donde los hechos deben unirse con un momento específico. El uso de fecha y hora ayuda a convertir una medición en un registro temporal que posteriormente puede analizarse.

Una aplicación sencilla sería un sistema de monitoreo. Un microcontrolador puede obtener una medición de un sensor y consultar al RTC para conocer el momento en que se realizó:

```text
Sensor → obtiene medición
              ↓
       Microcontrolador
              ↓
         consulta al RTC
              ↓
     Fecha + hora + medición
```

Por ejemplo:

```text
20/09/2026  08:00:00 → 21 °C

20/09/2026  08:10:00 → 21.5 °C

20/09/2026  08:20:00 → 22 °C
```

El RTC no realiza la medición de temperatura; su función es proporcionar la referencia temporal que permite identificar cuándo ocurrió cada medición.

Otra aplicación es la generación de alarmas. Tanto el DS3231 como los módulos RTCC de Microchip cuentan con funciones relacionadas con alarmas [1][5]. Esto permite que un sistema pueda ejecutar una acción cuando se alcanza determinada condición temporal.

---

### 6. Comparación y análisis

Al comparar las diferentes implementaciones revisadas, se puede observar que un RTC no es simplemente un contador de segundos. Para mantener una fecha y hora útil para un sistema embebido debe existir una referencia temporal estable, una lógica encargada de realizar el conteo y una forma de proporcionar esos datos al resto del sistema.

Los RTC externos como el **DS3231** y el **PCF8563** ofrecen un circuito dedicado al mantenimiento del tiempo. El DS3231 destaca por integrar un oscilador compensado en temperatura y una alimentación de respaldo, mientras que el PCF8563 está orientado a un funcionamiento de bajo consumo y utiliza una interfaz I²C [1][2].

Por otro lado, los RTC internos permiten aprovechar recursos que ya forman parte del microcontrolador. Los documentos de Microchip muestran que estos periféricos pueden generar interrupciones, funcionar con fuentes de reloj independientes y continuar trabajando mientras el CPU se encuentra en determinados estados de bajo consumo [3][4].

---

## Conclusión

Después de revisar el funcionamiento de los RTC, se entiende que su función dentro de un sistema embebido va más allá de solamente contar segundos, su principal utilidad es dar una referencia temporal que ayude a relacionar los eventos del sistema con una fecha y hora concreta.

Esto es realmente importante cuando los datos obtenidos por sensores o registros ocupan conservar información sobre el momento exacto en que pasaron.

También se pudo ver que existen diferentes formas de aplicar esta función, ya que un RTC interno ayuda a aprovechar los recursos que ya están integrados en el microcontrolador, mientras que un RTC externo nos da un circuito dedicado para mantener la información temporal, y que la elección entre ambos depende de las necesidades del sistema.

Por todo esto, el RTC representa un componente muy útil para sistemas embebidos que ocupan no solo realizar una acción, sino también saber exactamente cuándo ocurrió.

---

## Bibliografía

**Formato IEEE**

**[1]** Analog Devices, “DS3231: Extremely Accurate I²C-Integrated RTC/TCXO/Crystal,” *DS3231 Datasheet and Product Information*, disponible en: https://www.analog.com/en/products/ds3231.html. [Accedido: 19-sep-2026].

**[2]** NXP Semiconductors, “PCF8563 Real-time clock/calendar,” *Product Data Sheet*, disponible en: https://www.nxp.com/docs/en/data-sheet/PCF8563.pdf. [Accedido: 19-sep-2026].

**[3]** Microchip Technology Inc., V. Berzan, “Getting Started with RTC,” *Technical Brief TB3213*, disponible en: https://www.microchip.com/en-us/application-notes/tb3213. [Accedido: 19-sep-2026].

**[4]** Microchip Technology Inc., “AVR134: Real Time Clock (RTC) Using the Asynchronous Timer,” *Application Note AN1259-1*, disponible en: https://www.microchip.com/en-us/application-notes/an1259-1. [Accedido: 19-sep-2026].

**[5]** Microchip Technology Inc., M. T. Tan, “Real-Time Clock and Calendar Technical Brief,” *Technical Brief TB3124*, disponible en: https://www.microchip.com/en-us/application-notes/tb3124. [Accedido: 19-sep-2026].
