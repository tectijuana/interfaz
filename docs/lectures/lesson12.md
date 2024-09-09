### CAPÍTULO 11: **Interfaces de Entrada/Salida y Control de Dispositivos en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a las interfaces de E/S en ARM64](#introducción-a-las-interfaces-de-es-en-arm64)
2. [Controladores de dispositivos en ARM64](#controladores-de-dispositivos-en-arm64)
3. [Interacción con periféricos a través de UART](#interacción-con-periféricos-a-través-de-uart)
4. [Comunicación I2C en ARM64](#comunicación-i2c-en-arm64)
5. [Protocolo SPI para dispositivos de alta velocidad](#protocolo-spi-para-dispositivos-de-alta-velocidad)
6. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a las interfaces de E/S en ARM64

En sistemas embebidos como el **Raspberry Pi 5**, las **interfaces de entrada/salida (E/S)** permiten la comunicación entre el procesador y los dispositivos externos, como sensores, motores, pantallas o teclados. ARM64, al igual que otras arquitecturas, utiliza varios protocolos y buses para conectar y controlar estos dispositivos, entre los que destacan **UART**, **I2C** y **SPI**.

### Principales interfaces de E/S:

1. **UART (Universal Asynchronous Receiver-Transmitter)**: Se utiliza para la comunicación serie, comúnmente para depuración y conexión con dispositivos externos.
2. **I2C (Inter-Integrated Circuit)**: Un protocolo de comunicación en serie para la conexión de dispositivos de bajo ancho de banda, como sensores.
3. **SPI (Serial Peripheral Interface)**: Un protocolo de comunicación en serie más rápido que I2C, utilizado en dispositivos como memorias flash, pantallas y sensores de alta velocidad.

---

## Controladores de dispositivos en ARM64

El **controlador de dispositivos** es el software responsable de gestionar las comunicaciones entre el procesador y el hardware específico. En ARM64, los controladores de dispositivos suelen interactuar directamente con los registros de los periféricos mapeados en memoria, realizando operaciones de lectura y escritura para controlar el hardware.

### Mapeo de dispositivos en memoria

Los periféricos en ARM64, como los puertos UART, GPIO, I2C o SPI, están asignados a direcciones específicas en el espacio de memoria. Al escribir o leer desde estas direcciones, podemos interactuar directamente con los dispositivos conectados.

Por ejemplo, el **UART** del Raspberry Pi 5 tiene su controlador mapeado en la dirección **0xFE201000**. Al escribir en los registros de este controlador, podemos enviar y recibir datos en serie.

### Pasos básicos para controlar un dispositivo:

1. **Configurar los registros de control**: Seleccionar la velocidad de comunicación y otros parámetros.
2. **Escribir o leer datos**: Enviar o recibir datos mediante la escritura o lectura de registros.
3. **Monitorear los estados**: Comprobar si hay datos disponibles para leer o si la transmisión ha finalizado.

---

## Interacción con periféricos a través de UART

El **UART** es una interfaz de comunicación serie muy común. En el **Raspberry Pi 5**, podemos usar el UART para enviar y recibir datos con dispositivos externos o para depuración.

### Registros importantes de UART:

- **DR (Data Register)**: Utilizado para leer o escribir datos en el puerto UART.
- **FR (Flag Register)**: Contiene información sobre el estado del UART, como si el buffer de transmisión está lleno o vacío.

### Ejemplo: Configuración básica del UART

```assembly
.section .data
    UART_BASE:  .word 0xFE201000    // Dirección base del UART

.section .text
.global _start

_start:
    // Configurar UART para enviar datos
    ldr x0, =UART_BASE        // Cargar la dirección base del UART
    ldr x1, =0x61             // Cargar el carácter 'a' (0x61)
    str x1, [x0]              // Escribir el carácter en el registro DR del UART

    // Bucle para detener el programa
1:
    b 1b
```

Este programa envía un solo carácter 'a' a través del UART del Raspberry Pi.

---

## Comunicación I2C en ARM64

El protocolo **I2C** permite la comunicación entre un procesador y varios dispositivos conectados al mismo bus, utilizando solo dos líneas: **SDA** (datos) y **SCL** (reloj). En ARM64, el controlador I2C se encarga de gestionar las transmisiones de datos, generando las señales de reloj y enviando o recibiendo datos en serie.

### Operaciones básicas con I2C:

1. **Inicio de comunicación**: El maestro inicia la comunicación generando una señal de start.
2. **Envío de datos**: El maestro envía una dirección de dispositivo seguida de datos.
3. **Recepción de datos**: El maestro o esclavo recibe los datos.
4. **Detención de la comunicación**: El maestro finaliza la comunicación enviando una señal de stop.

### Ejemplo: Comunicación I2C para leer un sensor

```assembly
.section .data
    I2C_BASE:   .word 0xFE804000   // Dirección base del controlador I2C
    SENSOR_ADDR: .word 0x68        // Dirección del sensor I2C

.section .text
.global _start

_start:
    // Configurar el I2C para leer del sensor
    ldr x0, =I2C_BASE       // Cargar la dirección base del I2C
    ldr x1, =SENSOR_ADDR    // Cargar la dirección del sensor
    str x1, [x0]            // Escribir la dirección en el controlador I2C

    // Leer datos del sensor
    ldr x2, [x0]            // Leer los datos desde el registro de datos del sensor

    // Bucle para detener el programa
1:
    b 1b
```

Este programa inicializa el bus I2C y lee un valor desde un sensor conectado.

---

## Protocolo SPI para dispositivos de alta velocidad

El protocolo **SPI** es una interfaz de comunicación en serie síncrona, utilizada para comunicar el procesador con dispositivos que requieren alta velocidad, como pantallas LCD o memorias flash. A diferencia de I2C, SPI utiliza cuatro líneas: **MISO** (datos del esclavo al maestro), **MOSI** (datos del maestro al esclavo), **SCLK** (reloj) y **SS** (selección del esclavo).

### Operaciones básicas con SPI:

1. **Selección del dispositivo**: El maestro activa la línea **SS** para seleccionar el esclavo con el que desea comunicarse.
2. **Envío de datos**: El maestro envía datos en la línea MOSI mientras el esclavo envía datos en la línea MISO, ambos sincronizados con la señal de reloj **SCLK**.
3. **Recepción de datos**: El maestro y el esclavo intercambian datos simultáneamente.
4. **Finalización de la transmisión**: El maestro desactiva la línea **SS** para finalizar la comunicación.

### Ejemplo: Comunicación con un dispositivo SPI

```assembly
.section .data
    SPI_BASE:   .word 0xFE204000   // Dirección base del controlador SPI
    DATA_OUT:   .word 0x5A         // Dato a enviar

.section .text
.global _start

_start:
    // Configurar el SPI para enviar datos
    ldr x0, =SPI_BASE       // Cargar la dirección base del SPI
    ldr x1, =DATA_OUT       // Cargar el dato a enviar
    str x1, [x0]            // Escribir el dato en el registro de transmisión del SPI

    // Leer la respuesta del dispositivo SPI
    ldr x2, [x0]            // Leer los datos recibidos

    // Bucle para detener el programa
1:
    b 1b
```

Este programa envía un dato a un dispositivo conectado mediante SPI y lee la respuesta.

---

## Ejercicios prácticos

### Ejercicio 1: Comunicación UART básica

Escribe un programa que envíe la cadena "Hola ARM64" a través del puerto UART del Raspberry Pi 5.

#### Solución en ensamblador:

```assembly
.section .data
    UART_BASE:   .word 0xFE201000    // Dirección base del UART
    mensaje:     .ascii "Hola ARM64\n"

.section .text
.global _start

_start:
    ldr x0, =UART_BASE        // Cargar la dirección base del UART
    ldr x1, =mensaje          // Cargar la dirección del mensaje
1:
    ldrb w2, [x1], #1         // Cargar un byte del mensaje
    cbz w2, fin               // Si es el final del mensaje, salir
    str w2, [x0]              // Enviar el byte al UART
    b 1b                      // Repetir para el siguiente byte

fin:
    // Bucle para detener el programa
    b fin
```

### Ejercicio 2: Leer un sensor con I2C

Escribe un programa que lea un valor de un sensor conectado al bus I2C en el Raspberry Pi 5.

#### Solución en ensamblador:

```assembly
.section .data
    I2

C_BASE:   .word 0xFE804000   // Dirección base del controlador I2C
    SENSOR_ADDR: .word 0x68        // Dirección del sensor I2C

.section .text
.global _start

_start:
    // Configurar el I2C para leer del sensor
    ldr x0, =I2C_BASE       // Cargar la dirección base del I2C
    ldr x1, =SENSOR_ADDR    // Cargar la dirección del sensor
    str x1, [x0]            // Escribir la dirección en el controlador I2C

    // Leer datos del sensor
    ldr x2, [x0]            // Leer los datos desde el registro de datos del sensor

    // Bucle para detener el programa
1:
    b 1b
```

---

## Resumen

En este capítulo, exploramos cómo interactuar con **dispositivos de entrada/salida** mediante los protocolos **UART**, **I2C** y **SPI** en ARM64. Estos protocolos son fundamentales para la comunicación con periféricos en sistemas embebidos como el **Raspberry Pi 5** y permiten conectar una amplia gama de dispositivos externos.

