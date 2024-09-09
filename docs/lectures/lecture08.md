### CAPÍTULO 7: **Programación de Dispositivos y Acceso a Hardware en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a la programación de dispositivos en ARM64](#introducción-a-la-programación-de-dispositivos-en-arm64)
2. [Mapeo de memoria de hardware](#mapeo-de-memoria-de-hardware)
3. [Controladores de entrada/salida](#controladores-de-entrada-salida)
4. [Acceso a puertos GPIO en Raspberry Pi](#acceso-a-puertos-gpio-en-raspberry-pi)
5. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a la programación de dispositivos en ARM64

En sistemas embebidos como el **Raspberry Pi 5**, el acceso y control de dispositivos de hardware es una parte esencial del desarrollo de software de bajo nivel. ARM64 permite a los programadores interactuar directamente con el hardware, lo que abre posibilidades para proyectos como la manipulación de **GPIO** (General Purpose Input/Output), el control de pantallas, sensores y otros periféricos conectados.

En ARM64, la comunicación con hardware suele hacerse mediante el acceso directo a registros de control, ubicados en direcciones de memoria específicas asignadas a los dispositivos. Estas áreas de memoria mapeada de hardware permiten el control y monitoreo de los dispositivos conectados.

---

## Mapeo de memoria de hardware

El **mapeo de memoria** es la técnica que se utiliza para acceder a los registros de control de hardware. En ARM64, los dispositivos de hardware tienen direcciones de memoria específicas asignadas, y al leer o escribir en estas direcciones, podemos controlar el comportamiento de estos dispositivos.

### Pasos para acceder a hardware mediante mapeo de memoria:

1. **Identificar la dirección base** del dispositivo: Cada dispositivo tiene una dirección base en la memoria.
2. **Acceder a los registros del dispositivo**: A partir de la dirección base, se pueden leer y escribir en registros específicos que controlan diversas funciones del dispositivo.
3. **Realizar las operaciones necesarias**: Esto podría ser encender/apagar un LED, leer el estado de un sensor, o enviar datos a un dispositivo.

### Ejemplo de mapeo de memoria:

Para el Raspberry Pi 5, la dirección base para los **registros GPIO** está en la dirección `0xFE200000`. Desde esta dirección, se pueden controlar los pines GPIO utilizando diferentes registros.

---

## Controladores de entrada/salida

Los **controladores de entrada/salida** (E/S) son fundamentales para interactuar con el hardware desde un programa. ARM64 ofrece varias opciones para controlar dispositivos mediante acceso directo a memoria y también mediante instrucciones específicas que interactúan con los periféricos.

### Instrucciones clave:

1. **LDR**: Para cargar datos desde una dirección de memoria.
   ```assembly
   ldr x0, [x1]    // Carga el valor almacenado en la dirección apuntada por x1 en x0
   ```

2. **STR**: Para almacenar datos en una dirección de memoria.
   ```assembly
   str x0, [x1]    // Almacena el valor de x0 en la dirección apuntada por x1
   ```

Estos comandos se usan para leer y escribir en los registros mapeados en memoria de dispositivos de hardware.

---

## Acceso a puertos GPIO en Raspberry Pi

Los pines **GPIO** del Raspberry Pi permiten controlar dispositivos como LEDs, botones, motores, sensores y más. Cada pin GPIO se puede configurar como entrada o salida y se puede controlar directamente desde ARM64 usando mapeo de memoria.

### Direcciones importantes para los GPIO en Raspberry Pi 5:

- **Dirección base de los GPIO**: `0xFE200000`
- **Registros de selección de funciones (FSEL)**: Permiten configurar los pines como entrada, salida, o funciones alternativas.
- **Registros de set y clear**: Permiten encender y apagar los pines.

### Ejemplo: Encender un LED conectado a un pin GPIO

Para encender un LED conectado al pin **GPIO 17**, primero debemos configurar el pin como salida y luego establecer su valor en alto (encender el LED).

#### Pasos:

1. Configurar el pin 17 como salida.
2. Establecer el pin 17 en alto para encender el LED.

```assembly
.section .data
    GPIO_BASE:   .word 0xFE200000    // Dirección base de los GPIO
    GPFSEL1:     .word 0xFE200004    // Dirección del registro de selección de funciones
    GPSET0:      .word 0xFE20001C    // Dirección del registro para establecer pines
    GPCLR0:      .word 0xFE200028    // Dirección del registro para limpiar pines

.section .text
.global _start

_start:
    ldr x0, =GPIO_BASE      // Cargar la dirección base de los GPIO
    ldr x1, =GPFSEL1        // Cargar la dirección del registro FSEL para GPIO 17
    ldr x2, [x1]            // Leer el valor actual del registro FSEL
    bic x2, x2, #0x7 << 21  // Limpiar los bits de configuración para GPIO 17
    orr x2, x2, #0x1 << 21  // Configurar GPIO 17 como salida (b000)
    str x2, [x1]            // Almacenar el valor en el registro FSEL

    // Encender el LED (establecer GPIO 17 en alto)
    ldr x1, =GPSET0         // Cargar la dirección del registro SET para GPIO 17
    mov x2, #1 << 17        // Colocar 1 en la posición correspondiente al pin 17
    str x2, [x1]            // Establecer el pin 17 en alto (encender LED)

    // Bucle infinito para mantener el LED encendido
1:
    b 1b
```

Este programa configura el **GPIO 17** como una salida y luego lo establece en alto para encender el LED. El programa entra en un bucle infinito para mantener el LED encendido.

---

## Ejercicios prácticos

### Ejercicio 1: Parpadear un LED usando GPIO
Escribe un programa en ensamblador que haga parpadear un LED conectado al pin **GPIO 17** del Raspberry Pi.

#### Pseudocódigo:
1. Configurar el GPIO 17 como salida.
2. Encender el LED.
3. Esperar un momento.
4. Apagar el LED.
5. Repetir el proceso.

#### Solución en ensamblador:
```assembly
.section .data
    GPIO_BASE:   .word 0xFE200000    // Dirección base de los GPIO
    GPFSEL1:     .word 0xFE200004    // Dirección del registro de selección de funciones
    GPSET0:      .word 0xFE20001C    // Dirección del registro para establecer pines
    GPCLR0:      .word 0xFE200028    // Dirección del registro para limpiar pines

.section .text
.global _start

_start:
    // Configurar GPIO 17 como salida
    ldr x0, =GPFSEL1
    ldr x1, [x0]
    bic x1, x1, #0x7 << 21
    orr x1, x1, #0x1 << 21
    str x1, [x0]

parpadear:
    // Encender el LED
    ldr x0, =GPSET0
    mov x1, #1 << 17
    str x1, [x0]

    // Esperar
    mov x2, #0x3FFFFF
1:  subs x2, x2, #1
    bne 1b

    // Apagar el LED
    ldr x0, =GPCLR0
    mov x1, #1 << 17
    str x1, [x0]

    // Esperar
    mov x2, #0x3FFFFF
2:  subs x2, x2, #1
    bne 2b

    // Repetir el ciclo
    b parpadear
```

### Ejercicio 2: Leer el estado de un botón
Escribe un programa que lea el estado de un botón conectado al **GPIO 18** y encienda un LED en **GPIO 17** si el botón está presionado.

#### Solución en ensamblador:
```assembly
.section .data
    GPIO_BASE:   .word 0xFE200000
    GPFSEL1:     .word 0xFE200004
    GPFSEL2:     .word 0xFE200008
    GPSET0:      .word 0xFE20001C
    GPCLR0:      .word 0xFE200028
    GPLEV0:      .word 0xFE200034

.section .text
.global _start

_start:
    // Configurar GPIO 17 como salida
    ldr x0, =GPFSEL1
    ldr x1, [x0]
    bic x1, x1, #0x7 << 21
    orr x1, x1, #0x1 << 21
    str x1, [x0

]

    // Configurar GPIO 18 como entrada
    ldr x0, =GPFSEL2
    ldr x1, [x0]
    bic x1, x1, #0x7
    str x1, [x0]

leer_boton:
    // Leer el estado del botón
    ldr x0, =GPLEV0
    ldr x1, [x0]
    and x1, x1, #1 << 18   // Comprobar si el botón está presionado

    cbz x1, apagar_led     // Si no está presionado, apagar LED
    // Encender el LED si el botón está presionado
    ldr x0, =GPSET0
    mov x1, #1 << 17
    str x1, [x0]
    b leer_boton

apagar_led:
    // Apagar el LED
    ldr x0, =GPCLR0
    mov x1, #1 << 17
    str x1, [x0]
    b leer_boton
```

---

## Resumen

En este capítulo, aprendimos a **programar dispositivos y acceder al hardware** en ARM64, incluyendo el uso de **GPIO** en el Raspberry Pi 5 para controlar dispositivos como LEDs y botones. Estos conceptos son fundamentales para el desarrollo de proyectos de electrónica y sistemas embebidos.
