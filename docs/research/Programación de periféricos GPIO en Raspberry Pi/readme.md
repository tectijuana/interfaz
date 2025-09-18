# Programación de periféricos GPIO en Raspberry Pi

**Cesar Gregorio Angel Montoya**  
**No. Control: 22210281**

---

Los pines GPIO (General Purpose Input Output) se pueden usar como entrada o salida y permiten que Raspberry Pi se conecte con dispositivos de E / S de propósito general.

## ¿Qué son los pines GPIO?

GPIO significa Entrada/Salida de Propósito General.
Son los 40 pines que puedes ver en el Raspberry Pi, cerca del borde de la placa

• Raspberry pi puede controlar muchos dispositivos de E / S externos utilizando estos GPIO.
• Estos pines son una interfaz física entre el Pi y el mundo exterior.
• Podemos programar estos pines según nuestras necesidades para interactuar con dispositivos externos. Por ejemplo, si queremos leer el estado de un switch físico, podemos configurar cualquiera de los pines GPIO disponibles como entrada y leer el estado del switch para tomar decisiones. También podemos configurar cualquier pin GPIO como salida para controlar el LED ON/OFF.
• Raspberry Pi puede conectarse a Internet mediante Wi-Fi integrado o un adaptador USB Wi-Fi. Una vez que la Raspberry Pi está conectada a Internet, podemos controlar los dispositivos que están conectados a la Raspberry Pi de forma remota.

Algunos de los pines GPIO están multiplexados con funciones alternativas como I2C, SPI, UART, etc.
Podemos usar cualquiera de los pines GPIO para nuestra aplicación.
Debemos definir el pin GPIO que queremos usar como salida o entrada. Pero Raspberry Pi tiene dos formas de definir el número de pin que son las siguientes:
• Numeración GPIO
• Numeración física

En la numeración GPIO, el número de pin se refiere al número en Broadcom SoC (System on Chip). Por lo tanto, siempre debemos considerar la asignación de pines para usar el pin GPIO.
Mientras que en la numeración física, el número de pin se refiere al pin del encabezado P1 de 40 pines en la placa Raspberry Pi. La numeración física anterior es simple, ya que podemos contar el número de pin en el encabezado P1 y asignarlo como GPIO.
Pero, aún así, debemos considerar el diagrama de configuración de pines que se muestra arriba para saber cuáles son pines GPIO y cuáles son VCC y GND.

## Numeración GPIO de Raspberry Pi

Hay dos formas diferentes de referirse a un pin GPIO: su nombre (que se conoce como numeración GPIO o numeración Broadcom) o su número físico de pin correspondiente (que corresponde a la ubicación física del pin en el encabezado).

**Ejemplo:**
Conecte un botón y un LED a los GPIO de Raspberry Pi. Conectaremos un LED a GPIO 14 (pin 8) y el pulsador para GPIO 4 (pin 7). Puede usar cualquier otro pin, excepto GPIO 0 y GPIO 1.

a una colección de interfaces para componentes cotidianos como LED, botones, potenciómetros, sensores y mucho más.

Para leer entradas digitales, la biblioteca gpiozero proporciona el Botón , diseñada especialmente para pulsadores, y el Dispositivo de entrada digital para entradas digitales genéricas. Ambas interfaces funcionan de manera similar, pero usan funciones con nombres diferentes.

El gpiozero ya debería estar instalada si está ejecutando el sistema operativo Raspberry Pi, si no, puede ejecutar:

```
python3 -m pip gpiozero
```

## Control de un LED con un pulsador

Para mostrarle cómo leer el estado de un pulsador y cómo activar diferentes eventos según el estado del pulsador, crearemos un script de Python para controlar un LED.

Cree un nuevo archivo de Python en su Raspberry Pi llamado pushbutton_led.py y copie el siguiente código.

```python


from gpiozero import Button, LED
from signal import pause

led = LED(14)
button = Button(4)

button.when_pressed = led.on
button.when_released = led.off

pause()
```

## Cómo funciona el código

Continúe leyendo para saber cómo funciona el código.

### Importación de bibliotecas

Primero, importa el archivo LED componente del componente gpiozero para controlar el GPIO al que está conectado el LED y el Botón para interactuar con el pulsador. Luego, también debe importar el pausa() de la función señal para mantener su programa en ejecución para que pueda detectar eventos.

```python
from gpiozero import Button, LED
from signal import pause
```

### Declaración del LED

A continuación, crea un LED objeto llamado led que se refiere a GPIO 14, que es el GPIO al que está conectado el LED. Cambia el número si estás usando otro GPIO.

```python
led = LED(14)
```

Cuando crea y usa este LED , su programa sabe que GPIO 14 es una salida que se puede establecer en HIGH o LOW. Después de esta declaración, puede usar led para consultar su GPIO 14. Puedes usar esto LED para controlar otros componentes que no sean LED, siempre que puedan controlarse con señales ALTAS y BAJAS.

### Declaración del pulsador

Declarar el pulsador también es sencillo. Solo necesita crear una instancia de la clase Botón clase. Pasar como argumento el GPIO al que está conectado el pulsador, en nuestro caso, es GPIO 4.

```python
button = Button(4)
```

Puede pasar otros argumentos útiles a la clase Button:

```python
Button(pin, *, pull_up=True, active_state=None, bounce_time=None, hold_time=1, hold_repeat=False, pin_factory=None)
```

Esto es lo que significan estos parámetros:
• anclar: el GPIO al que está conectado el botón.
• pull_up: el valor predeterminado es Verdadero > el GPIO se elevará de forma predeterminada, debe conectar el otro pin del pulsador a GND como lo hicimos en el circuito. Si desea que el botón funcione al revés, establezca esta marca en Falso y conecte el otro lado del pulsador a 3.3V.
• active_state: el valor predeterminado es Ninguno (se establece automáticamente en el valor correcto de acuerdo con el valor de pull_up). Si se establece en Falso, la polaridad de entrada se invierte: el pulsador envía una señal HIGH, pero el software envía una LOW a su programa.
• bounce_time: por defecto, no hay ninguna definida bounce_time. El bounce_time es útil si recibe pulsaciones falsas de botones. El bounce_time es el período de tiempo, en este caso en segundos, que el GPIO ignorará los cambios de estado para evitar falsos positivos. Si después de la prueba, siente que el programa detecta falsos positivos, establezca un valor para el bounce_time.
• hold_time: el tiempo en segundos que debemos esperar después de que se haya presionado el botón para considerar que el botón se mantuvo presionado (when_held controlador)
• hold_repeat: si se establece en Verdaderoel when_held handler se ejecutará repetidamente hasta que el pulsador deje de mantenerse. Si se establece en Falso, solo se ejecutará una vez.
• pin_factory: esta es una función avanzada que probablemente no necesitará usar ni preocuparse.

## Button Events

Puede usar el comando when_pressed y when_released controladores para detectar cuándo se presionó o soltó el botón y asociar una función para que se ejecute cuando se detecte cada evento.

### when_pressed

En la siguiente línea, cuando se presiona el botón(when_pressed), el LED se enciende.

```python
button.when_pressed = led.on
```

### when_released

Cuando el when_released , el LED se apaga.

```python
button.when_released = led.off
```

En lugar de encender y apagar un LED, puede asociar cualquier otra función que necesite ejecutar cuando se detecten esos eventos de botones.

### Mantenga el programa en ejecución

Al final, llamamos a la pausa() función. Mantiene el programa en ejecución incluso después de que todo el código se haya ejecutado para detectar eventos, en este caso, está comprobando continuamente el estado del botón pulsador.

```python
pause()
```

## Alternar el LED

En lugar del ejemplo anterior, es posible que desee alternar el estado del LED con cada pulsación de botón. Si ese es el caso, puede usar el siguiente ejemplo.

```python


from gpiozero import Button, LED
from signal import pause

led = LED(14)
button = Button (4)

button.when_pressed = led.toggle

pause()
```

## En resumen...

1) Para leer el estado de un pulsador, puede utilizar el botón Botón interfaz de la interfaz gpiozero biblioteca. Primero debe importarlo así:

```python
from gpiozero import Button
```

2) Defina el GPIO al que está conectado el botón:

```python
button = Button(GPIO_NUMBER_OF_YOUR_CHOICE)
```

3) Luego, use el comando when_pressed y when_released eventos para hacer que algo suceda cuando se presiona o suelta el botón.

```python
button.when_pressed = your_function
button.when_released = your_function
```

## Demostración

Guarde su archivo de python. Luego ejecútelo en su Raspberry Pi. Ejecute el siguiente comando en el directorio del archivo del proyecto (use el nombre del archivo):

```
python pushbutton_led.py
```

---

## Referencias

[1] Raspberry Tips. "Guía pines GPIO Raspberry Pi." Disponible en: https://raspberrytips.es/guia-pines-gpio-raspberry-pi/

[2] Electronic Wings. "Raspberry Pi GPIO Access." Disponible en: https://www.electronicwings.com/raspberry-pi/raspberry-pi-gpio-access

[3] Random Nerd Tutorials. "Raspberry Pi Digital Inputs Python." Disponible en: https://randomnerdtutorials.com/raspberry-pi-digital-inputs-python/
