# Código de arranque (startup) y vector de reset en Cortex-M

**Alumno:** Jesus Cruz Tafoya

**No. de control:** 25210860

**Horario:** 3 pm-4 pm

**Materia:** Lenguajes de Interfaz (SCC-1014)

**Institución:** TecNM Campus Tijuana, Ingeniería en Sistemas Computacionales

**Tema:** Código de arranque (startup) y vector de reset en Cortex-M

**Fecha de entrega:** 20 de septiembre

---

## 1. Introducción

Cuando trabajamos con un microcontrolador ARM Cortex‑M, solemos pensar que todo empieza en la función main().
En realidad, antes de llegar ahí ocurre un proceso clave: el startup code.
Este código prepara la memoria y el entorno para que el programa en C funcione correctamente.
En sistemas con sistema operativo, esa tarea la hace el cargador y las librerías, pero en un microcontrolador sin sistema operativo (bare‑metal),
nosotros debemos encargarnos de escribirlo o usar el que viene en las plantillas de CMSIS

## 2. Qué pasa cuando el procesador sale de reset

Al encender o reiniciar, el Cortex‑M no salta directamente a código, sino que lee datos de la dirección 0x00000000
o la que indique el registro VTOR:

1. **Palabra 0:** La primera palabra es el valor inicial del Main Stack Pointer (MSP)
2. **Palabra 1:** La segunda palabra es la dirección del Reset_Handler, con el bit menos significativo en 1 

Con esos dos valores, el procesador ya sabe dónde está la pila y a qué función debe entrar. 
A partir de ahí empieza a ejecutar el Reset_Handler. 
En ese momento la RAM está sin inicializar y los periféricos aún no están configurados

## 3. La tabla de vectores

Las primeras 16 entradas son comunes a todos los Cortex-M3/M4.
a partir de la 16 vienen las interrupciones externas, que dependen del fabricante.
En otras palabras, La tabla de vectores es una lista de direcciones que indican qué función manejará cada excepción o interrupción. 
Las primeras entradas son estándar Reset, NMI, HardFault, etc.
y ya después vienen las interrupciones específicas del fabricante

EJemplo simplificado:
| Offset | Entrada | Descripción |
|--------|---------|-------------|
| 0x00 | Initial SP | Valor inicial de MSP (normalmente el final de la RAM) |
| 0x04 | Reset | Reset Handler |
| 0x08 | NMI | Interrupción no enmascarable |
| 0x0C | HardFault | Falla general |
| 0x10 | MemManage | Falla de la MPU |
| 0x14 | BusFault | Error de bus |
| 0x18 | UsageFault | Instrucción inválida, división entre cero, etc. |
| 0x1C–0x28 | Reservado | — |
| 0x2C | SVCall | Llamada al supervisor (`svc`) |
| 0x30 | DebugMon | Monitor de depuración |
| 0x34 | Reservado | — |
| 0x38 | PendSV | Base para cambio de contexto de un RTOS |
| 0x3C | SysTick | Temporizador del sistema |
| 0x40… | IRQ0, IRQ1… | Interrupciones del fabricante |

El Cortex-M0 tiene una diferencia importante, no tiene el registro VTOR, así que la tabla no se puede reubicar por hardware.
en el M0+ es opcional. Esto importa si un bootloader quiere saltar a una aplicación que tiene su propia tabla, en M3/M4 basta con escribir VTOR,
en M0 hay que copiar la tabla a RAM y remapear.
en muchos microcontroladores la dirección 0x00000000 no es realmente la Flash, sino un alias que el fabricante remapea según los pines BOOT.


## 4. El Reset Handler

El Reset Handler tiene que dejar al sistema en las condiciones que el lenguaje C asume. 
Lo mínimo es:
1. **Copiar `.data` de Flash a RAM.** Las variables globales con valor inicial (int contador = 5;) viven en RAM,
2. pero su valor inicial tiene que guardarse en Flash porque la RAM se pierde al apagar.
3. El startup copia eso a la RAM.
4. **Poner en cero `.bss`.** C garantiza que las globales sin inicializar valen 0, la RAM real arranca con basura.
5. **(Opcional) Configurar reloj u otros recursos** con una función tipo SystemInit(), como hace CMSIS.
6. **(Opcional) Inicializar la biblioteca estándar** (__libc_init_array`, constructores de C++).
7. **Llamar a `main()`.**
8. **Un bucle infinito** por si main retorna, porque no hay a dónde regresar.

Para que el código de arranque sepa dónde empiezan y terminan esas secciones, el *linker script* exporta símbolos _sidata, _sdata, _edata, _sbss, _ebss, _estack.
Esos símbolos no son variables, son direcciones que calcula el enlazador, por eso en C se declaran como extern uint32_t _sdata,
y se usa &_sdata para obtener el valor.
La diferencia clave es entre la dirección de carga LMA, donde queda guardada la imagen en Flash y la dirección de ejecución VMA, donde vive en RAM.
En el linker script se expresa con > RAM AT > FLASH.

## 5. Ejemplo completo

Con arm-none-eabi-gcc y QEMU (placa lm3s6965evb) se puede probar un startup mínimo

### 5.1 `startup.c`

```c
#include <stdint.h>

/* Símbolos definidos por el linker script */
extern uint32_t _estack;
extern uint32_t _sidata, _sdata, _edata;
extern uint32_t _sbss, _ebss;

extern int main(void);

void Reset_Handler(void);
void Default_Handler(void);

/* Handlers débiles: si el usuario define uno con el mismo nombre, lo reemplaza */
void NMI_Handler(void)        __attribute__((weak, alias("Default_Handler")));
void HardFault_Handler(void)  __attribute__((weak, alias("Default_Handler")));
void MemManage_Handler(void)  __attribute__((weak, alias("Default_Handler")));
void BusFault_Handler(void)   __attribute__((weak, alias("Default_Handler")));
void UsageFault_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SVC_Handler(void)        __attribute__((weak, alias("Default_Handler")));
void DebugMon_Handler(void)   __attribute__((weak, alias("Default_Handler")));
void PendSV_Handler(void)     __attribute__((weak, alias("Default_Handler")));
void SysTick_Handler(void)    __attribute__((weak, alias("Default_Handler")));

typedef void (*isr_t)(void);

/* Tabla de vectores: va en su propia sección para que el linker la ponga en 0x0 */
__attribute__((section(".isr_vector"), used))
const isr_t vector_table[] = {
    (isr_t)&_estack,     /* 0x00: valor inicial de SP */
    Reset_Handler,       /* 0x04 */
    NMI_Handler,         /* 0x08 */
    HardFault_Handler,   /* 0x0C */
    MemManage_Handler,   /* 0x10 */
    BusFault_Handler,    /* 0x14 */
    UsageFault_Handler,  /* 0x18 */
    0, 0, 0, 0,          /* 0x1C - 0x28 reservados */
    SVC_Handler,         /* 0x2C */
    DebugMon_Handler,    /* 0x30 */
    0,                   /* 0x34 reservado */
    PendSV_Handler,      /* 0x38 */
    SysTick_Handler      /* 0x3C */
};

void Reset_Handler(void)
{
    uint32_t *src = &_sidata;
    uint32_t *dst = &_sdata;

    /* 1. Copiar .data de Flash a RAM */
    while (dst < &_edata) {
        *dst++ = *src++;
    }

    /* 2. Poner .bss en cero */
    for (dst = &_sbss; dst < &_ebss; dst++) {
        *dst = 0;
    }

    /* 3. Llamar a main */
    main();

    /* 4. Si main regresa, quedarse aquí */
    while (1) { }
}

void Default_Handler(void)
{
    while (1) { }
}
```

### 5.2 `linker.ld`

```ld
ENTRY(Reset_Handler)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 256K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);   /* la pila crece hacia abajo */

SECTIONS
{
    .isr_vector : {
        KEEP(*(.isr_vector))
    } > FLASH

    .text : {
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    _sidata = LOADADDR(.data);          /* dónde quedó guardada la imagen en Flash */

    .data : {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT > FLASH

    .bss : {
        . = ALIGN(4);
        _sbss = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM
}
```

### 5.3 `main.c`

```c
#include <stdint.h>

volatile uint32_t contador = 5;     /* va a .data: debe valer 5 al llegar a main */
volatile uint32_t acumulado;        /* va a .bss: debe valer 0 al llegar a main */

int main(void)
{
    while (1) {
        acumulado += contador;
        contador++;
    }
}
```

### 5.4 Compilar y depurar

```bash
arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -g -ffreestanding -nostartfiles \
    -T linker.ld startup.c main.c -o prog.elf

arm-none-eabi-objdump -h prog.elf        # revisar secciones y LMA/VMA
arm-none-eabi-nm prog.elf | grep -E "_sdata|_edata|_sbss|_ebss|_sidata"

# Terminal 1
qemu-system-arm -M lm3s6965evb -kernel prog.elf -nographic -S -gdb tcp::1234

# Terminal 2
arm-none-eabi-gdb prog.elf
(gdb) target remote :1234
(gdb) x/2wx 0x0            # SP inicial y dirección del Reset Handler
(gdb) break main
(gdb) continue
(gdb) print contador       # debe ser 5
(gdb) print acumulado      # debe ser 0
```

Uso `-ffreestanding` porque GCC a veces convierte los bucles de copia en llamadas a `memcpy`, y en este proyecto no hay biblioteca estándar enlazada. [COMPLETAR: tu resultado real. ¿Qué valores viste en `x/2wx 0x0`? ¿Qué pasó si quitaste la copia de .data?]

## 6. Errores comunes

- **Olvidar el bit Thumb** en la tabla escrita en ensamblador, el procesador cae en HardFault apenas arranca.
- **Poner la tabla en la sección equivocada:** si el linker no la coloca al inicio de la Flash, el procesador lee basura como SP y PC. Por eso el `KEEP` y el orden de las secciones.
- **No copiar `.data`:** el programa "funciona" hasta que depende de una global inicializada.
- **No usar `KEEP`** y que la optimización del enlazador --gc-sections elimine la tabla por no ser referenciada.
- **`_estack` mal calculado:** una pila mal ubicada corrompe datos sin avisar.

## 7. Análisis y opinión personal

Lo interesante de este tema es que el arranque de un Cortex‑M es muy corto y directo, pero cada detalle importa.
Me sorprendió que la primera palabra de la tabla no sea código sino el valor inicial de la pila.
También me costó entender cómo el linker genera los símbolos y cómo se usan en C.
Comparando con los startup que generan CMSIS o STM32CubeIDE, se nota que ellos agregan más inicialización reloj, FPU, librerías, pero la base es la misma

## 8. Conclusiones

El startup code y el vector de reset son la base de todo programa en Cortex‑M. Sin ellos, el microcontrolador no puede arrancar correctamente.
Entender cómo funcionan ayuda a depurar problemas de inicialización y a valorar el trabajo que hacen las librerías al generar código de arranque automático.

## 9. Bibliografia

[1] Arm Ltd., *ARM v7-M Architecture Reference Manual*, Doc. DDI 0403E. [En línea]. Disponible: https://developer.arm.com/documentation/ddi0403/

[2] Arm Ltd., *Cortex-M4 Devices Generic User Guide*, Doc. DUI 0553. [En línea]. Disponible: https://developer.arm.com/documentation/dui0553/

[3] Arm Ltd., *Procedure Call Standard for the Arm Architecture*, Doc. IHI 0042. [En línea]. Disponible: https://github.com/ARM-software/abi-aa

