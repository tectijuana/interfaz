### CAPÍTULO 10: **Interrupciones y Control de Procesos en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a las interrupciones en ARM64](#introducción-a-las-interrupciones-en-arm64)
2. [Tipos de interrupciones](#tipos-de-interrupciones)
3. [Manejo de interrupciones en ARM64](#manejo-de-interrupciones-en-arm64)
4. [Control de procesos y contexto](#control-de-procesos-y-contexto)
5. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a las interrupciones en ARM64

Las **interrupciones** son eventos que interrumpen el flujo normal de ejecución de un programa para que el procesador pueda atender una tarea urgente o importante. Estos eventos pueden ser causados por hardware (como un teclado, un temporizador o una red) o por software (como excepciones o llamadas al sistema).

En ARM64, las interrupciones son fundamentales para la programación de sistemas embebidos y el control de hardware en tiempo real, como en el **Raspberry Pi 5**. Las interrupciones permiten que el sistema responda rápidamente a eventos externos sin la necesidad de que el programa principal supervise constantemente el estado del hardware.

---

## Tipos de interrupciones

En ARM64, las interrupciones se pueden clasificar en diferentes categorías según su fuente y naturaleza:

### 1. **Interrupciones de hardware (IRQ - Interrupt Request)**
   - Generadas por dispositivos de hardware como temporizadores, teclados o dispositivos de red.
   - Se gestionan a través del **Controlador de Interrupciones**.

### 2. **Interrupciones de software (SWI - Software Interrupt)**
   - Generadas por el propio software mediante la instrucción `svc`.
   - Se utilizan para realizar llamadas al sistema y generar excepciones intencionales.

### 3. **Interrupciones síncronas (Excepciones)**
   - Ocurren cuando el procesador encuentra una condición irregular durante la ejecución del programa, como una división por cero o un acceso a memoria no válida.

### 4. **Interrupciones asíncronas (FIQ - Fast Interrupt Request)**
   - Son interrupciones rápidas que tienen una mayor prioridad que las interrupciones IRQ normales. Se utilizan para eventos críticos que requieren atención inmediata.

---

## Manejo de interrupciones en ARM64

El manejo de interrupciones implica la detección del evento, la suspensión temporal del programa principal y la ejecución de un **manejador de interrupciones** que realiza las acciones necesarias. Después de que la interrupción ha sido atendida, el procesador puede regresar al programa principal.

### Pasos para manejar una interrupción:

1. **Guardar el contexto**:
   - Antes de atender la interrupción, se debe almacenar el estado actual del procesador (registros, contador de programa, etc.) para restaurarlo más tarde.

2. **Ejecutar el manejador de interrupciones**:
   - Se ejecuta un código específico para gestionar la interrupción. Esto puede implicar la lectura de un dispositivo, el procesamiento de datos, o la reprogramación de un temporizador.

3. **Restaurar el contexto**:
   - Después de que se haya manejado la interrupción, el procesador restaura el estado anterior y continúa ejecutando el programa principal desde el punto en que fue interrumpido.

### Ejemplo de código para manejar una interrupción:

```assembly
.section .text
.global _start

_start:
    // Configurar el procesador para aceptar interrupciones
    mov x0, #0x1      // Habilitar interrupciones
    msr DAIFClr, x0   // Limpia las banderas de interrupciones

    // Bucle principal
1:
    wfi               // Espera la llegada de una interrupción
    b 1b              // Volver al bucle infinito

.manejador_irq:
    // Manejador de interrupción de hardware
    // Aquí se manejaría la interrupción
    eret              // Regresar de la interrupción
```

En este ejemplo, el procesador está en un bucle infinito que espera una interrupción usando la instrucción `wfi` (Wait for Interrupt). Cuando llega una interrupción, se llama al **manejador de interrupciones**.

---

## Control de procesos y contexto

El **control de procesos** es una parte crucial de la programación de sistemas operativos y de tiempo real. En ARM64, un proceso es una instancia en ejecución de un programa, y cada proceso tiene su propio contexto, que incluye sus registros, contador de programa y espacio de direcciones.

Cuando ocurre una **interrupción** o se cambia de proceso, es necesario **guardar el contexto** actual del proceso (para que pueda reanudarse más tarde) y cargar el contexto del nuevo proceso o manejador de interrupciones.

### El contexto de un proceso incluye:

1. **Registros del procesador**:
   - Registros de propósito general (x0-x30).
   - El contador de programa (PC).
   - El registro de estado del programa (PSTATE).

2. **Memoria de proceso**:
   - Cada proceso tiene su propio espacio de direcciones virtuales.
   - Esto incluye su pila, datos y código.

3. **Contexto de interrupciones**:
   - Cuando ocurre una interrupción, se almacena el contexto del proceso actual para que pueda reanudarse correctamente después de atender la interrupción.

### Cambiar entre procesos:

El cambio de procesos se conoce como **conmutación de contexto**. En este proceso, el sistema operativo guarda el contexto del proceso actual y carga el contexto del siguiente proceso a ejecutar.

```assembly
.manejador_irq:
    // Guardar el contexto del proceso actual
    stp x0, x1, [sp, #-16]!     // Guardar registros x0 y x1 en la pila
    stp x2, x3, [sp, #-16]!     // Guardar registros x2 y x3 en la pila
    // Resto de registros...

    // Cargar el contexto del siguiente proceso
    ldp x0, x1, [sp], #16       // Restaurar registros x0 y x1
    ldp x2, x3, [sp], #16       // Restaurar registros x2 y x3
    // Resto de registros...

    eret                        // Regresar del manejador de interrupciones
```

---

## Ejercicios prácticos

### Ejercicio 1: Manejador de interrupción de temporizador

Escribe un programa que configure un temporizador para generar una interrupción cada segundo. El manejador de interrupciones debe incrementar un contador en memoria cada vez que ocurre la interrupción.

#### Solución en ensamblador:

```assembly
.section .data
    contador: .word 0        // Contador para las interrupciones

.section .text
.global _start

_start:
    // Configurar temporizador (hipotético) para generar una interrupción
    mov x0, #0x1000          // Cargar valor de cuenta del temporizador
    str x0, [timer_base]     // Escribir en el registro del temporizador

    // Habilitar interrupciones
    msr DAIFClr, #0x2        // Habilitar interrupciones IRQ

    // Bucle principal
1:
    wfi                      // Esperar una interrupción
    b 1b

.manejador_irq:
    // Incrementar el contador en memoria
    ldr x1, =contador        // Cargar la dirección del contador
    ldr x2, [x1]             // Leer el valor del contador
    add x2, x2, #1           // Incrementar el contador
    str x2, [x1]             // Almacenar el valor actualizado

    eret                     // Regresar del manejador de interrupciones
```

### Ejercicio 2: Cambio de contexto entre dos procesos

Escribe un programa que simule el cambio de contexto entre dos procesos en ARM64. Cada proceso debe tener su propio contador, y el sistema debe alternar entre ellos usando interrupciones.

#### Solución en ensamblador:

```assembly
.section .data
    proceso1: .word 0        // Contador para el proceso 1
    proceso2: .word 0        // Contador para el proceso 2

.section .text
.global _start

_start:
    // Configurar temporizador para generar una interrupción periódica
    mov x0, #0x1000          // Cargar valor de cuenta del temporizador
    str x0, [timer_base]     // Escribir en el registro del temporizador

    // Habilitar interrupciones
    msr DAIFClr, #0x2        // Habilitar interrupciones IRQ

    // Bucle principal
1:
    wfi                      // Esperar una interrupción
    b 1b

.manejador_irq:
    // Guardar contexto del proceso actual (por simplicidad solo un contador)
    ldr x0, =proceso1
    ldr x1, [x0]
    add x1, x1, #1
    str x1, [x0]

    // Alternar al otro proceso
    ldr x0, =proceso2
    ldr x1, [x0]
    add x1, x1, #1
    str x1, [x0]

    eret                     // Regresar del manejador de interrupciones
```

---

## Conclusión

En este capítulo, exploramos el concepto

 de **interrupciones** y cómo manejar eventos de hardware y software de manera eficiente en ARM64. También profundizamos en el **control de procesos** y el **cambio de contexto**, que son esenciales para sistemas multitarea y de tiempo real, como el **Raspberry Pi 5**.

---

