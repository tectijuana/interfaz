📌 Integración de Sensores con Microcontroladores usando I2C

🔹 Definición


El bus I2C (Inter-Integrated Circuit) es un protocolo de comunicación serial síncrona desarrollado por Philips. Permite que múltiples dispositivos (sensores, memorias, pantallas, etc.) se conecten a un microcontrolador utilizando solo dos líneas:

SDA (Serial Data Line): línea de datos.

SCL (Serial Clock Line): línea de reloj.

El microcontrolador actúa como maestro y los sensores como esclavos, identificados por una dirección única en el bus.

<img width="277" height="182" alt="image" src="https://github.com/user-attachments/assets/37d070a8-38bd-4002-a3c8-555a2a9769fe" />


🔹 Características

Bidireccional y síncrono: los datos se sincronizan con una señal de reloj.

Solo dos cables: independientemente del número de dispositivos conectados.

Direcciones de 7 u 10 bits para identificar dispositivos.

Velocidades típicas:

Estándar: 100 kbps

Rápido: 400 kbps

High-Speed: hasta 3.4 Mbps

Soporta múltiples dispositivos: maestro único o múltiples maestros.

Uso de resistencias pull-up en SDA y SCL para mantener la señal estable.

🔹 Ejemplos de Sensores que usan I2C

MPU6050: acelerómetro y giroscopio.

BMP280 / BME280: sensor de presión, temperatura y humedad.

ADS1115: convertidor ADC de 16 bits.

DS3231: reloj en tiempo real (RTC).

OLED SSD1306: pantallas gráficas pequeñas.


## 🔹 Ejemplo en Arduino (lectura de sensor I2C)

```cpp
#include <Wire.h>
#include <Adafruit_BMP280.h>

Adafruit_BMP280 bmp; 

void setup() {
  Serial.begin(9600);
  if (!bmp.begin(0x76)) {  // Dirección I2C típica del BMP280
    Serial.println("No se detecta el sensor!");
    while (1);
  }
}

void loop() {
  Serial.print("Temperatura = ");
  Serial.print(bmp.readTemperature());
  Serial.println(" °C");

  Serial.print("Presion = ");
  Serial.print(bmp.readPressure()/100.0);
  Serial.println(" hPa");

  delay(1000);
}

``` 

🔹 Ventajas de usar I2C

✅ Fácil conexión (solo dos pines).

✅ Permite conectar muchos sensores en paralelo.

✅ Muy usado en sistemas embebidos e IoT.


🔹 Limitaciones

⚠️ Distancia máxima limitada (aprox. < 1 metro sin repetidores).

⚠️ Velocidad menor comparada con SPI.

⚠️ Posibles conflictos si dos dispositivos tienen la misma dirección (se soluciona con multiplexores I2C).


🔹 Aplicaciones Relevantes

IoT y domótica: monitoreo ambiental con BME280.

Wearables: detección de movimiento con MPU6050.

Automotriz: medición de presión y temperatura.

Prototipos con microcontroladores (Arduino, ESP32, STM32, Raspberry Pi Pico, etc.).
