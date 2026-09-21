# Anexo: Bitácora de uso de IA

**Autora:** Rosales Mailen Gisell  
**Tema:** 30 — GPIO bare-metal en RP2350: registros SIO, PADS e IO_BANK0

## Herramienta utilizada y alcance

Se utilizó el asistente de OpenAI en la aplicación Codex para interpretar la actividad, consultar fuentes oficiales y elaborar un borrador del README, incluyendo desarrollo, conclusiones y bibliografía. Posteriormente se realizaron las preguntas técnicas registradas a continuación para revisar las explicaciones y comprender el contenido. Estas preguntas corresponden a la etapa posterior al borrador, no a su generación inicial.

Esta bitácora presenta una selección de consultas técnicas reales; omite las consultas iniciales de navegación en GitHub y localización del tema. Los resultados son resúmenes de las respuestas del asistente. No se realizaron pruebas en hardware.

## Preguntas utilizadas y resultados obtenidos

### 1. GPIO y programación bare-metal

**Pregunta real:**
> que es un GPIO y qué significa programar bare-metal?

**Resultado obtenido:** El asistente explicó que un GPIO es un pin configurable como entrada o salida digital. Usó el botón como ejemplo de entrada y el LED como ejemplo de salida. Definió bare-metal como ejecución sin sistema operativo y aclaró que se pueden utilizar C y bibliotecas del fabricante.

### 2. Diferencia entre microcontrolador y placa

**Pregunta real:**
> que diferencia hay entre el RP2350 y la placa Raspberry Pi Pico 2?

**Resultado obtenido:** Se distinguió el RP2350, que es el chip, de la Pico 2, que es una placa que lo incorpora junto con alimentación, conexión USB y memoria flash. También se aclaró que GPIO15 no equivale al terminal físico número 15 de la placa.

### 3. Registros y responsabilidades de los bloques

**Pregunta real:**
> que son los registros y para qué sirven SIO, IO_BANK0 y PADS_BANK0?

**Resultado obtenido:** Se describieron los registros como ubicaciones de hardware que el programa lee o escribe para controlar funciones. IO_BANK0 selecciona la función del pin; PADS_BANK0 configura sus características eléctricas; y SIO permite leer entradas, establecer salidas y habilitarlas. Cada bloque agrupa varios registros.

### 4. Condiciones para encender un LED

**Pregunta real:**
> por qué no basta con escribir un uno para encender un LED?

**Resultado obtenido:** Se explicó que el valor escrito solo produce la señal esperada si el pin tiene seleccionada la función adecuada, la salida está habilitada y el pad no permanece aislado. Encender con nivel alto o bajo depende de cómo esté conectado el LED.

### 5. Máscara de bits

**Pregunta real:**
> qué significa `1 << 15` en el ejemplo?

**Resultado obtenido:** El asistente explicó el desplazamiento de bits y mostró que la expresión produce 32768, equivalente a 0x00008000. Esta máscara selecciona el bit 15. Escribirla en GPIO_OUT_SET establece ese bit sin cambiar los demás por esa escritura. Calcular la máscara por sí solo no modifica el pin.

### 6. Configuración de un LED y un botón

**Pregunta real:**
> qué diferencia hay entre configurar un LED y un botón?

**Resultado obtenido:** El LED se presentó como salida y el botón como entrada. Se explicó un botón conectado a tierra con pull-up: sin pulsación se lee uno y al pulsarlo se lee cero. Se distinguió la resistencia que limita la corriente del LED de la resistencia que define el nivel de reposo de una entrada.

### 7. Imágenes relacionadas con el tema

**Pregunta real:**
> que imagenes puedo poner y cómo se relacionan con mi investigación?

**Resultado obtenido:** Se propusieron un diagrama de bloques del RP2350, un diagrama de pines de la Pico 2 y un circuito de LED con resistencia. Se explicó qué parte del texto complementa cada imagen y se recomendó añadir descripciones y fuentes. El GPIO del circuito debe coincidir con el del ejemplo escrito.

### 8. Fuentes utilizadas

**Pregunta real:**
> dame fuentes verificadas para comprobar la informacion que me proporcionaste

**Resultado obtenido:** El asistente identificó las cinco fuentes oficiales utilizadas para preparar el borrador y explicó qué información obtuvo de cada una. Aclaró que las respuestas posteriores simplificaban ese material y que no realizó una búsqueda nueva para cada pregunta. También distinguió sus consultas de las verificaciones que la autora realice personalmente.

## Fuentes identificadas por el asistente

1. Raspberry Pi, [Microcontroller chips](https://www.raspberrypi.com/documentation/microcontrollers/microcontroller-chips.html): características del microcontrolador.
2. Raspberry Pi, [Hardware APIs — Pico SDK](https://www.raspberrypi.com/documentation/pico-sdk/hardware.html): funciones de configuración y uso de GPIO.
3. Raspberry Pi, [pads_bank0.h](https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2350/hardware_structs/include/hardware/structs/pads_bank0.h): campos de configuración eléctrica y aislamiento.
4. Raspberry Pi, [gpio.c](https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2_common/hardware_gpio/gpio.c): implementación de la selección de función y configuración del pad.
5. Raspberry Pi, [sio.h](https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2350/hardware_structs/include/hardware/structs/sio.h): registros de entrada, salida y operaciones sobre bits.

Las referencias en formato IEEE se encuentran en el README. Las imágenes requieren sus propias fuentes.

## Límites del apoyo de IA

Las respuestas ofrecieron explicaciones simplificadas y ejemplos, pero no constituyen evidencia experimental. El pseudocódigo del README no es un firmware completo y no se ejecutó en una placa. Además, un resultado de búsqueda de imágenes no garantiza que el circuito corresponda al RP2350 ni al GPIO del ejemplo: es necesario comprobar esas correspondencias.

## Reflexión personal  

1. ¿Cómo me ayudó la IA a entender el tema?
Al principio no tenía clara la diferencia entre el microcontrolador, la placa y los registros. Las explicaciones con ejemplos prácticos como el LED y el botón, junto con las tablas comparativas, me ayudaron a organizar los conceptos y a entender bien la función de SIO, IO_BANK0 y PADS_BANK0.

2. ¿Qué explicación comprobé o corregí y con qué fuente?
Pedí fuentes para verificar la información y la revisé directamente con la documentación oficial de Raspberry Pi y el código del Pico SDK.

3. ¿Qué limitación, error o sesgo identifiqué?
Una limitación es que las explicaciones y el ejemplo del LED no se probaron físicamente en una placa real. Además, entendí que no cualquier imagen de una Raspberry Pi sirve para este tema: debe corresponder exactamente al modelo específico y a las conexiones que estemos usando en la práctica.

4. ¿Qué partes reescribí con mis palabras?
Leí la mayor parte del texto y lo reexpliqué con mis propias palabras de forma clara, cuidando no desviarme del tema ni cambiar los conceptos. También agregué imágenes para que todo lo descrito se entienda mucho mejor.
