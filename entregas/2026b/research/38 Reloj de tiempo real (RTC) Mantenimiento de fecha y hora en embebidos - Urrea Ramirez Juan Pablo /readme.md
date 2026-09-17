# 38 Reloj de Tiempo Real (RTC): Mantenimiento de fecha y hora en embebidos
**Por: Urrea Ramirez Juan Pablo**

## Definición precisa y arquitectura básica

El **Reloj de Tiempo Real** (RTC, o *Real-Time Clock*) es un circuito electrónico especializado que se utiliza para mantener la hora real exacta, independientemente del estado de funcionamiento del sistema digital principal. 

El RTC está diseñado para mantener la hora de forma continua (tanto los segundos, minutos, horas, días y, a menudo, meses y años) incluso en situaciones en las que el microprocesador principal está apagado. Esta función es posible gracias al uso de una **fuente de alimentación independiente**, normalmente en forma de pilas o condensadores. 

El RTC se utiliza en una amplia gama de dispositivos electrónicos, desde ordenadores personales, sistemas embebidos, registradores de datos y equipos médicos, hasta automatismos industriales y sistemas de medición inteligentes. En los ordenadores personales, el RTC se encarga de mantener el tiempo del sistema entre ciclos de alimentación, y también puede interactuar con la BIOS o el sistema operativo. En los sistemas de ahorro de energía, el RTC permite sacar el dispositivo del modo de reposo o programar eventos a lo largo del tiempo.

## Componentes clave

Los circuitos RTC suelen integrar un generador de reloj basado en un **resonador de cuarzo de 32,768 kHz**, que proporciona una gran estabilidad y precisión de temporización. Además, contienen registros que almacenan datos de temporización y, a menudo, un calendario con corrección del año bisiesto, así como alarmas de temporización y funciones de interrupción.

## Interfaces de comunicación

La comunicación con el microcontrolador o el procesador se realiza a través de interfaces serie estándar como **I²C**, **SPI** o, en ocasiones, buses paralelos.

### El módulo PCF8563 frente a otras alternativas

Existe una amplia variedad de módulos de Reloj de Tiempo Real (RTC) disponibles en el mercado, tales como los modelos **DS1307** y **DS3231**. No obstante, en términos de eficiencia energética, el consumo de potencia de estos dispositivos es relativamente elevado, lo cual puede agotar de manera prematura la fuente de alimentación en aquellas aplicaciones de hardware basadas en baterías. 

Por consiguiente, una alternativa idónea que presenta un consumo energético significativamente reducido es el módulo **PCF8563**, el cual también opera mediante el protocolo de comunicación **I²C**.

El **PCF8563** es un Reloj de Tiempo Real y calendario basado en tecnología **CMOS**, diseñado y optimizado de manera específica para aplicaciones de bajo consumo de energía. Adicionalmente, este circuito integrado proporciona una salida de reloj programable, una salida de interrupción y un detector de caída de voltaje (*voltage-low detector*). La totalidad de las direcciones y los datos se transfieren de forma serial a través de un bus I²C bidireccional de dos líneas, soportando una velocidad máxima de transmisión de **400 kbit/s**.

A partir de estos antecedentes técnicos, este ejemplo detalla el diseño de la interfaz de comunicación entre el módulo RTC PCF8563 y la plataforma de desarrollo Arduino UNO, así como la implementación de la visualización de los parámetros de fecha y hora mediante una pantalla LCD de 16×2.

| No. | Nombre del Componente | Cantidad |
| :--- | :--- | :--- |
| 1 | Placa Arduino UNO | 1 |
| 2 | Pantalla LCD 16x2 | 1 |
| 3 | Módulo RTC PCF8563 | 1 |
| 4 | Potenciómetro de 10K | 1 |
| 5 | Cables de conexión | 10 |
| 6 | Protoboard | 1 |

El módulo de reloj en tiempo real está basado en el **NXP PCF8563T**, un chipset de reloj en tiempo real de alta precisión, programable y con comunicación I2C de hasta 400 KHz / 400 Kb/s.

<img width="220" height="150" alt="image" src="https://github.com/user-attachments/assets/66acf2f5-eade-4726-8744-ad8211de2e82" />

Este dispositivo proporciona múltiples funciones, tales como una salida de reloj externa programable, alarma, temporizador y un sistema óptimo de batería de respaldo. Además, presenta una **mayor estabilidad y precisión** en comparación con los modelos DS1302 o DS1307. El módulo RTC PCF8563 suministra la función de reloj y calendario de tiempo real, la cual es alimentada por una batería integrada, lo que le permite operar de forma autónoma incluso cuando el microcontrolador principal se encuentra desenergizado. En conclusión, se trata de un módulo de reloj de tiempo real (RTC) con interfaz I²C, caracterizado por su bajo costo y su precisión sumamente alta.

## Interfaz del módulo de reloj en tiempo real PCF8563 con Arduino

Este circuito corresponde a la interconexión del módulo de reloj en tiempo real PCF8563 con un Arduino UNO en una protoboard (placa de pruebas).

<img width="300" height="160" alt="image" src="https://github.com/user-attachments/assets/605ce4e5-61f4-4187-9b4f-fe9ec137dd68" />

### Conexiones de Hardware

*   **Módulo RTC:** Conecta los pines **SDA** y **SCL** del PCF8563 a los pines **A4** y **A5** del Arduino. Conecta su pin **VCC** a **5V** o **3.3V**, y **GND** a **GND**. 
*   **Pantalla LCD:** Conecta los pines **1, 5 y 16** de la LCD a **GND**, y los pines **2 y 15** a **VCC**. Conecta un potenciómetro de **10K** en el pin **3** de la LCD para ajustar el contraste. Los pines **4, 6, 11, 12, 13 y 14** de la LCD deben conectarse a los pines digitales **12, 11, 5, 4, 3 y 2** del Arduino.

### Código Fuente
El código fuente para interconectar el módulo de reloj en tiempo real PCF8563 con Arduino y obtener la hora y la fecha. Pero antes de eso se necesita instalar una librería para poder utilizarlo. 
Librería RTC PCF8563

Ahora se copia el código de la parte inferior y se sube a la placa Arduino.

```cpp
#include <Wire.h>
#include <Rtc_Pcf8563.h>
#include <LiquidCrystal.h>

// Inicializar el reloj de tiempo real
Rtc_Pcf8563 rtc;

// Inicializar pines de la pantalla LCD
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

void setup() {
  // Configurar el número de filas y columnas de la LCD:  
  lcd.begin(16, 2);
  lcd.setCursor(4, 0);
  lcd.print("PCF8563");
  lcd.setCursor(0, 1);
  lcd.print("Real Time Clock");
  
  delay(4000);
  lcd.clear();
  
  // Limpiar todos los registros
  rtc.initClock();
  
  // Establecer una fecha inicial
  // día, día de la semana, mes, siglo, año
  rtc.setDate(20, 3, 1, 20, 20);
  
  // Establecer una hora inicial
  // hr, min, sec
  rtc.setTime(16, 38, 48);
}

void loop() {
  lcd.setCursor(0, 0);
  lcd.print("Time:");
  lcd.setCursor(6, 0);
  // lcd.print(rtc.formatTime(RTCC_TIME_HM));
  lcd.print(rtc.formatTime());
  
  lcd.setCursor(0, 1);
  lcd.print("Date:");
  lcd.setCursor(6, 1);
  // lcd.print(rtc.formatDate(RTCC_DATE_ASIA));
  lcd.print(rtc.formatDate());
}
```

### Resultados

<img width="500" height="360" alt="image" src="https://github.com/user-attachments/assets/0febed6c-ef42-44d9-9211-f74f15c3fa11" />



### Referencias

[1] (N.d.). Industrialmonitordirect.com. Retrieved September 17, 2026, from https://industrialmonitordirect.com/es/blogs/knowledgebase/plc-real-time-clock-programming-registers-tags-and-time-sync?srsltid=AU7gw4WL6vHzt23EDVHTH9pOMdyakYfqjdia5vV8Ev879OZlxEJi3W58#section-0

[2] (N.d.-b). How2electronics.com. Retrieved September 17, 2026, from https://how2electronics.com/interfacing-pcf8563-real-time-clock-module-arduino/

[3] (N.d.-c). Tme.Eu. Retrieved September 17, 2026, from https://www.tme.eu/es/news/library-articles/glossary/page/69568/reloj-en-tiempo-real-rtc-definicion/

[4] Real-time clocks. (n.d.). Microchip.com. Retrieved September 17, 2026, from https://www.microchip.com/en-us/products/clock-and-timing/components/real-time-clocks








