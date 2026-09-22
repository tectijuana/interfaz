# GPIO bare-metal en RP2350: registros SIO, PADS e IO_BANK0

**Autora:** Rosales Mailen Gisell  
**Tema:** 30 — Semestre 2026 B


## Introducción

Los pines de entrada y salida de propósito general, llamados GPIO, permiten conectar un microcontrolador con elementos externos, como botones y LED. Comprender su configuración ayuda a relacionar las instrucciones ejecutadas por el procesador con señales eléctricas observables. En este trabajo se estudia el RP2350, utilizado en la familia Raspberry Pi Pico 2 [1]. El enfoque bare-metal consiste en trabajar sin un sistema operativo; puede utilizar código de arranque y definiciones del SDK sin dejar de ser bare-metal. Aquí interesa especialmente comprender el acceso directo a registros.


## Desarrollo técnico

### 1. Microcontrolador, placa y registros

Es necesario distinguir el microcontrolador de la placa que lo incorpora. El RP2350A dispone de 30 GPIO de usuario y el RP2350B de 48; una placa puede exponer solo una parte de ellos en sus conectores [1], [2]. Por ello, el número de un GPIO no debe confundirse con la posición física de un terminal. Antes de conectar un componente se consulta el diagrama de pines de la placa concreta.

<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/8712b87d-78d8-4e4d-8e97-3e78fce3d73b" />

Los registros son posiciones mediante las cuales el programa consulta o modifica el hardware. Una escritura puede seleccionar una función, habilitar una salida o cambiar su estado. Este acceso exige conocer los campos de bits: modificar indiscriminadamente un registro puede afectar características que el programa pretendía conservar. En C se emplean definiciones de registros con acceso volatile para que las operaciones correspondan a accesos al periférico. Esto no sustituye la coordinación entre interrupciones o núcleos.

<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/b8ee2b7e-3648-48b7-937c-e8ff3e2a80e1" />

### 2. IO_BANK0: seleccionar quién controla el pin

Un mismo pin puede servir para distintas funciones. IO_BANK0 contiene la configuración que selecciona qué periférico se conecta al GPIO y permite modificar aspectos de las señales mediante controles de override. Para manejar el pin mediante SIO, el campo FUNCSEL debe seleccionar esa función; en el RP2350, GPIO_FUNC_SIO corresponde al valor 5 [2].

Esta selección explica por qué escribir un dato de salida no siempre produce un cambio externo. Si el pin está asignado a otra función, la ruta de control no corresponde a SIO. Al diagnosticar un LED que no enciende, conviene comprobar primero la función seleccionada y no asumir inmediatamente que la instrucción de escritura falló.


### 3. PADS_BANK0: comportamiento eléctrico

PADS_BANK0 configura características del contacto físico. Sus campos incluyen IE, que habilita la entrada; OD, que deshabilita la salida; PUE y PDE, que controlan las resistencias internas de pull-up y pull-down; y DRIVE, que selecciona la capacidad de excitación. También aparecen SCHMITT y SLEWFAST, relacionados con el acondicionamiento de entrada y la rapidez de las transiciones [3].

En el RP2350 es particularmente importante ISO, el control de aislamiento del pad. Una configuración que omita retirar este aislamiento puede impedir el funcionamiento esperado. La implementación oficial de gpio_set_function configura la entrada, elimina la deshabilitación de salida, selecciona la función y finalmente retira el aislamiento [4]. La secuencia muestra que configurar un pin comprende tanto su conexión lógica como sus propiedades eléctricas.

### 4. SIO: leer y escribir estados digitales

SIO significa Single-cycle I/O. Entre sus registros están GPIO_IN, para consultar entradas; GPIO_OUT, para definir niveles de salida; y GPIO_OE, para habilitar salidas. Los GPIO superiores a 31 utilizan registros adicionales, por lo que un ejemplo con un pin bajo no debe extenderse automáticamente a todos los pines [5].

Los registros GPIO_OUT_SET, GPIO_OUT_CLR y GPIO_OUT_XOR permiten establecer, borrar o alternar bits seleccionados. Para GPIO15, la máscara es 1u << 15, equivalente a 0x00008000. Escribir esa máscara en SET establece el bit; hacerlo en CLR lo borra. Los demás bits no se modifican por esa escritura. Estas operaciones evitan una secuencia de lectura, modificación y escritura sobre todo GPIO_OUT, aunque no resuelven conflictos entre dos tareas que intenten controlar el mismo pin [5].

### 5. Ejemplo razonado: salida para un LED

Como ejemplo conceptual se propone un LED externo conectado a GPIO15 mediante una resistencia limitadora, con retorno a tierra. La elección de resistencia depende de la alimentación, la caída de tensión del LED y la corriente prevista. No se presupone que el LED integrado de cualquier placa esté conectado a ese GPIO.

La preparación requiere disponer de un entorno de arranque válido, periféricos fuera de reset y permisos de acceso adecuados. Después se mantiene deshabilitada la salida, se precarga el nivel bajo, se configura el pad y se selecciona SIO. Una vez retirada la condición de aislamiento, se habilita la salida. Esta organización busca evitar activar el LED con un valor previo inesperado. La inicialización oficial también separa la preparación del nivel y la selección de función [4].

El siguiente pseudocódigo ilustra las operaciones posteriores a esa configuración; no es un firmware completo ni se ha probado en una placa:

```text
mascara = 1 << 15
escribir mascara en GPIO_OUT_CLR   // Preparar nivel bajo
escribir mascara en GPIO_OE_SET    // Habilitar salida
escribir mascara en GPIO_OUT_SET   // Nivel alto: LED encendido
escribir mascara en GPIO_OUT_CLR   // Nivel bajo: LED apagado
```

<img width="400" height="200" alt="image" src="https://github.com/user-attachments/assets/bae6fd39-d0c9-4c40-bbe4-8754500d4ed6" />

### 6. Entrada para un botón y comparación de enfoques

Un botón requiere una configuración diferente: salida deshabilitada, entrada habilitada y un nivel de reposo definido. Si se conecta el botón a tierra y se emplea pull-up, el reposo se interpreta como uno y la pulsación como cero. El programa consulta el bit correspondiente de la entrada. Las funciones documentadas gpio_set_dir, gpio_pull_up y gpio_get sirven como referencia para comprender estas operaciones [2].

Comparar el acceso directo con el SDK permite evaluar dos prioridades. El acceso directo hace visibles las decisiones sobre registros y facilita estudiar errores de configuración. El SDK expresa la intención mediante funciones y reduce la cantidad de detalles que deben repetirse. Un programa con SDK también puede ejecutarse sin sistema operativo. Por ello, la comparación relevante es el grado de abstracción y la responsabilidad que asume quien programa, no una supuesta oposición entre SDK y bare-metal.

## Conclusiones

El control GPIO depende de tres responsabilidades complementarias: IO_BANK0 selecciona la función, PADS_BANK0 configura el comportamiento eléctrico y SIO permite leer o modificar estados. Conocer esta separación proporciona un método de diagnóstico: comprobar la ruta de la señal, las condiciones del pad y finalmente la operación de entrada o salida.

El análisis sugiere que el acceso directo es especialmente útil para aprender cómo funciona el hardware, mientras que las funciones del SDK facilitan el mantenimiento. La elección depende del objetivo del proyecto. Este trabajo presenta una explicación documental; una validación experimental posterior tendría que registrar la placa utilizada, las conexiones y los resultados observados.

## Bibliografía

[1] Raspberry Pi Ltd., “Microcontroller chips,” Raspberry Pi Documentation. [En línea]. Disponible: https://www.raspberrypi.com/documentation/microcontrollers/microcontroller-chips.html. [Consultado: 18-sep-2026].

[2] Raspberry Pi Ltd., “Hardware APIs: hardware_gpio,” Raspberry Pi Pico SDK Documentation. [En línea]. Disponible: https://www.raspberrypi.com/documentation/pico-sdk/hardware.html. [Consultado: 18-sep-2026].

[3] Raspberry Pi Ltd., “RP2350 hardware structures: pads_bank0.h,” pico-sdk. [Código fuente en línea]. Disponible: https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2350/hardware_structs/include/hardware/structs/pads_bank0.h. [Consultado: 18-sep-2026].

[4] Raspberry Pi Ltd., “GPIO implementation: gpio.c,” pico-sdk. [Código fuente en línea]. Disponible: https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2_common/hardware_gpio/gpio.c. [Consultado: 18-sep-2026].

[5] Raspberry Pi Ltd., “RP2350 hardware structures: sio.h,” pico-sdk. [Código fuente en línea]. Disponible: https://github.com/raspberrypi/pico-sdk/blob/master/src/rp2350/hardware_structs/include/hardware/structs/sio.h. [Consultado: 18-sep-2026].
