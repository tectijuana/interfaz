Alumno: Javier Fernandez Cortez - 22211558
tema: Uso de plataformIO como entrno para proyectos embebidos

<img width="220" height="220" alt="image" src="https://github.com/user-attachments/assets/5d8295b1-daaa-47ad-913b-da1bc1e8da05" />

# introduccion 
en este investigacion les proporcionare informacion de como es que se ve y para que sirve plataformIO, una plataforma que es de desarrollo de codigo abierto, para artefactos y dispositivos
es facil de usar ya que proporciona un entorno amigable con el usuario y altamente configurable

# ¿Qué es PlatformIO?

es un ecosistema de desarrollo especialmente útil para sistemas embebidos que te ofrece un entorno de trabajo unificado independiente del hardware y software que utilices. Se encarga de manejar la descarga de bibliotecas, la instalación de los toolchains adecuados, la compilación y linkeo del código fuente, la detección automática de puertos, la descarga del código a la placa y muchas otras acciones.

Es una herramienta multiplataforma que se puede instalar de manera independiente mediante una interfaz de comandos (CLI) o bien se puede integrar en varios editores de texto como Visual Studio Code, Atom, Eclipse, y otros.  Entre sus principales características se encuentran las siguientes:

La configuración general del proyecto está plasmada en un único archivo llamado platformio.ini, donde se describe la plataforma de hardware, el framework de desarrollo, y muchas otras configuraciones.
En el archivo platoformio.ini pueden existir diferentes configuraciones para diferentes entornos compartiendo el mismo código fuente.
El código fuente es independiente de la plataforma de desarrollo utilizada.
Basándose en el archivo de configuración del proyecto, el sistema se encarga de descargar e instalar todas los requerimientos necesarios.
Maneja de manera muy sencilla la descarga y utilización de bibliotecas externas que posibilitan el desarrollo de proyectos complejos.
El usuario utiliza una única herramienta para realizar todas las tareas de desarrollo necesarias para crear, compilar y descargar el código al hardware.

<img width="940" height="602" alt="image" src="https://github.com/user-attachments/assets/6dcb7dcc-8684-46a0-bb6b-ea31302b61f5" />

## Ventajas principales de usar PlatformIO

Compatibilidad multiplataforma

Soporta más de 900 placas de desarrollo y múltiples frameworks (Arduino, Zephyr, ESP-IDF, mbedOS, etc.).

Un solo entorno para programar distintos micros.

Gestión de dependencias y librerías

Tiene un gestor de librerías que descarga automáticamente lo que necesites, sin andar copiando carpetas como en Arduino IDE.

Configuración por proyecto

Cada proyecto tiene un archivo platformio.ini donde defines la placa, el framework y las librerías.
Ejemplo:

```text
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
lib_deps = 
    adafruit/Adafruit GFX Library
    adafruit/Adafruit SSD1306
```


Soporte para pruebas y depuración

Permite debugging con hardware (si tu microcontrolador lo soporta).

Integración con simulaciones y pruebas unitarias.

Integración con control de versiones (Git)

Facilita trabajar en equipo y mantener proyectos organizados.

Automatización

Puedes compilar, subir el firmware y hasta ejecutar pruebas desde la terminal o con scripts.

## Flujo típico de trabajo en PlatformIO

1 Instalar VS Code + PlatformIO IDE (extensión).

2 Crear un nuevo proyecto → eliges la placa y el framework.

3 Escribir tu código en la carpeta src/.

```text
#include <Arduino.h>

void setup() {
  Serial.begin(115200);
  Serial.println("Hola desde PlatformIO!");
}

void loop() {
  Serial.println("Loop corriendo...");
  delay(1000);
}
```

4 Configurar librerías y opciones en platformio.ini.

5 Compilar y subir el programa al microcontrolador.

6 (Opcional) Usar monitor serial integrado en PlatformIO.

## Diferencias 
<img width="1022" height="353" alt="image" src="https://github.com/user-attachments/assets/ba98ed92-1639-4d82-b150-0ad5505f952a" />


Ejemplo práctico

```text
[env:esp32dev]
platform = espressif32
board = esp32dev
framework = arduino
lib_deps = bblanchon/ArduinoJson
```

Y ya puedes usar ArduinoJson directamente en tu código sin configuraciones extra.

## Referencias
* Asistencia de GPT-5 para las diferencias de plataformio con arduino IDE del dia 17 de septiembre del 2025
* GoTo IoT | Uso de PlatformIO. (s. f.). https://www.gotoiot.com/pages/articles/platformio_vscode_usage/index.html
* What is PlatformIO? — PlatformIO latest documentation. (s. f.). https://docs-platformio-org.translate.goog/en/latest/what-is-platformio.html?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc
