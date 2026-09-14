# Linker Scripts para Microcontroladores: ARM Mapa de Memoria

- **Número de Control:** 23211980
- **Apellido:** Guzmán Ochoa

### Introducción

Cuando se programa en un lenguaje de programación como C, al compilar el código se convierte a instrucciones en código máquina que contienen direcciones de memoria relativas, las cuales no son un problema en un sistema operativo común, ya que el kernel y la MMU (Memory Management Unit) del sistema operativo se encargan de utilizar esas direcciones de memoria relativas dentro de un espacio virtual de memoria que se le asigna a la ejecución del programa. Sin embargo, cuando se usa un microcontrolador que no cuenta con estos sistemas para resolver direcciones relativas de memoria, el programa será imposible de ejecutarse, ya que las instrucciones en código máquina harán referencia a direcciones de memoria que pueda que no existan.
Para resolver esto se creó el sistema linker que, con el uso de un linker script, se encarga de traducir estas direcciones de memoria lógicas a direcciones de memoria físicas.
El propósito de esta investigación es mostrar el funcionamiento y creación de estos linker scripts que permiten el funcionamiento de código máquina con direcciones de memoria relativas en un sistema que únicamente opera con direcciones de memoria físicas.

### Desarrollo

#### Arquitectura de Memoria del ARM Cortex-M

A diferencia de las arquitecturas de computadoras tradicionales, la familia ARM Cortex-M está compuesta por procesadores diseñados principalmente para microcontroladores, y estos implementan una arquitectura Harvard modificada, en la que el bus de datos se maneja de forma distinta, esto significa que tiene buses separados para la lectura de instrucciones y el acceso a datos, estos respectivos buses son llamados bus I-Code y los buses D-Code y System.

Estos buses se usan para acceder a un espacio de direccionamiento de 32 Bits (4 GB totales), lo cual no significa que ese sea el tamano de la RAM sino que sera el tamano de puede representar direcciones dentro de un espacio de 4 GB, es decir, el tamano de sus direcciones son de 32 Bits, algo asi: ```0x00000000```, este es un mapa de memoria fijo, lo que significa que puede representar hasta 4 GB de memoria, personalmente me sirve recordar que a pesar de que esos 4 GB de direcciones de memoria existen, no significa necesariamente que son memoria fisica, por lo que en cada seccion de memoria puede ser que solo cierto rango sea utilizado por la memoria fisica, ya que se mencionaron las secciones, ese espacio de memoria fue dividido de forma estandarizada por ARM en tres distintas secciones:

- Code (0x00000000 – 0x1FFFFFFF):
  - Región destinada al código y normalmente utilizada para memoria no volátil, como Flash. La ubicación física de la Flash depende del fabricante; por ejemplo, muchos microcontroladores la ubican en 0x08000000 y pueden proporcionar un alias/remapeo en 0x00000000.
- SRAM (0x20000000 – 0x3FFFFFFF):
  - Región destinada a memoria RAM volátil de lectura/escritura, utilizada para variables (.data, .bss), la pila (stack) y, cuando se utiliza, el montón (heap).
- Peripherals (0x40000000 – 0x5FFFFFFF):
  - Región destinada a periféricos mapeados en memoria, donde las direcciones corresponden a registros de hardware para controlar dispositivos como GPIO, timers, UART, SPI, etc.

| Región de Memoria     | Dirección de Inicio     | Tipo de Memoria     | Uso Principal                                                          |
|-----------------------|-------------------------|---------------------|------------------------------------------------------------------------|
| **Code / Flash**      | 0x00000000              | No volatil (Flash)  | Codigo ejecutable (.text) y constantes (.rodata)                       |
| **SRAM**              | 0x20000000              | Volátil (RAM)       | Variables inicializadas (.data), variables a cero (.bss), Stack y Heap |
| **Peripherals**       | 0x40000000              | E/S mapeada         | Control de perifericos de hardware                                     |

#### 2.2. Anatomía del Enlazado y Archivos ELF

Ahora que se ha entendido como funcionan las secciones del mapa de memoria y los buses de datos de la arquitectura ARM Cortex-M, se puede pasar al siguiente concepto que es el enlazamiento y como se relaciona con los archivos ELF.

Durante la etapa de compilacion de tu codigo existe el problema que en tu codigo fuente hay referencias a funciones definidas en otros archivos diferentes a main.c, para esto el compilador primmero convierte tus archivos fuente (.c) a archivos de objeto individual (.o) el cual ya tiene codigo maquina pero no es ejecutable aun ya que tiene dependencias sin resolver ya que hay llamadas a funciones que pueden ser definidas en otros archivos de objeto.

Ahora bien, importante entender como estan estructurados los archivos objeto, cada archivo objeto esta dividido en secciones que entran en una de estas cuatro categorias:

| Sección | Significado             | ¿Qué contiene?                                                           |
|---------|-------------------------|--------------------------------------------------------------------------|
| .text   | Codigo                  | Instrucciones ejecutables de las funciones                               |
| .rodata | Read-Only Data          | Datos constantes que no deben modificarse, como const y cadenas de texto |
| .data   | Initialized Data        | Variables globales o estaticas que tienen un valor inicial               |
| .bss    | Block Started by Symbol | Variables globales o estaticas sin valor inicial explicito               |

Ahora que se entiende que secciones tienen los archivos objeto, ese codigo objeto tiene que pasar por un proceso de enlazado que es realizado por el linker, el cual se encarga de tomar tus archivos de objeto y resolver las referencias cruzadas, es decir, esas llamadas a funciones que se encuentran en archivos distintos, despues de haber hecho este proceso se encarga de empaquetar todo el codigo maquina en un binario ejectuable final.

Durante este proceso de enlazamiento el linker tiene que resolver otros problemas, en la arquitectura ARM Cortex-M hay distintas secciones de memoria para distintos propositos, no se colocan en la misma seccion el codigo ejecutable que las variables, ademas tiene que tomar en cuenta cuanto espacio hay en cada seccion, y que direcciones son utilizables para cada seccion, para esto para poder obtener ese binario ejecutable final se usa ```linker script``` (.ld), el cual es un archivo que le dice al linker cómo organizar el programa final dentro de la memoria.

El archivo ```linker script``` se encarga de indicar donde se encuentran las funciones referenciadas y en que direccion de memoria colocarlas, para esto, utiliza dos comandos:

1. MEMORY: Define las regiones fisicas de memoria disponibles en el chip, especificando su direccion base, tamaño y permisos.
2. SECTIONS: Le indica al linker en que región de memoria fisica debe colocar cada seccion logica de los archivos objeto.

```ld
MEMORY
{
    // FLASH => nombre de la seccion
    // rx => tiene permisos de lectura (read) y ejecucion (x)
    // origin = 0x08000000 => desde que direccion de memoria comienza esta seccion
    // LENGTH = 512K => el tamaño de la seccion
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 512K

    // Con las anotaciones anteriores esta instruccion diria: La seccion RAM tiene permisos de lectura, estricutra, y ejecucion, comienza en la direccion 0x20000000 y tiene un tamaño de 128 kilobytes
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
    // .text => nombre de la seccion de salida
    // *(.text) => se toman las secciones .text de los archivos objeto
    // *(.rodata) => se toman las secciones .rodata de los archivos objeto
    // > FLASH => la region de memoria donde se deben colocar
    .text :
    {
        *(.text)
        *(.rodata)
    } > FLASH

    // Con las anotaciones anteriores esta instruccion diria: Crea un seccion .data y toma todas las instrucciones de la seccion .data del archivo objeto y colocalas dentro de la region RAM de la memoria
    .data :
    {
        *(.data)
    } > RAM

    .bss :
    {
        *(.bss)
    } > RAM
}
```
## 2.3. Direcciones de Memoria: VMA vs. LMA

Uno de los conceptos mas importantes para entender como funciona el enlazamiento en sistemas embebidos es la separacion de las direcciones de memoria en dos categorias, estas son LMA y VMA, estas dos direcciones son importantes principalmente cuando una seccion necesita estar almacenada en una region de memoria pero durante la ejecucion necesita encontrarse en otra region diferente.

- **LMA (Load Memory Address):** Es la direccion donde se encuentra almacenada una seccion cuando el programa es cargado en el dispositivo, en un microcontrolador normalmente esta direccion se encuentra en una memoria no volatil como Flash, esto es importante porque el contenido de la Flash permanece almacenado aunque el dispositivo se apague.
- **VMA (Virtual Memory Address):** Es la direccion donde debe encontrarse una seccion durante la ejecucion del programa, en sistemas embebidos tambien se puede entender como la direccion donde la CPU espera encontrar esa seccion para poder utilizarla, aunque el termino "Virtual" viene de la definicion utilizada por el linker y no significa necesariamente que exista memoria virtual como en una computadora tradicional.

Para secciones como `.text` que contienen el codigo ejecutable, normalmente la LMA y la VMA son iguales, ya que el codigo puede almacenarse en Flash y ejecutarse directamente desde ella, esto es conocido como *Execute-In-Place* o XIP.

Sin embargo, esto cambia para secciones que necesitan ser modificadas durante la ejecucion, como `.data`, ya que las variables modificables necesitan estar en RAM, pero sus valores iniciales necesitan estar almacenados en una memoria no volatil para que no se pierdan cuando el dispositivo se apaga, por lo que en este caso la LMA y la VMA son diferentes.

| Seccion   | LMA                                          | VMA   | Motivo                                                                            |
| --------- | -------------------------------------------- | ----- | --------------------------------------------------------------------------------- |
| `.text`   | FLASH                                        | FLASH | El codigo puede ejecutarse directamente desde Flash                               |
| `.rodata` | FLASH                                        | FLASH | Los datos de solo lectura no necesitan modificarse                                |
| `.data`   | FLASH                                        | RAM   | Los valores iniciales se almacenan en Flash pero las variables se utilizan en RAM |
| `.bss`    | No ocupa espacio de datos iniciales en Flash | RAM   | Solo necesita reservar espacio en RAM e inicializarse en cero                     |

En el caso de `.data`, el linker script puede indicar esta diferencia utilizando `AT > FLASH`, por ejemplo:

```ld
.data :
{
    *(.data)
} > RAM AT > FLASH
```

Con esta instruccion se esta indicando que la seccion `.data` tendra su direccion de ejecucion en RAM, pero su contenido inicial se almacenara en Flash, posteriormente el codigo de arranque sera el encargado de copiar esos datos desde la Flash hacia la RAM antes de ejecutar la funcion `main()`.

## 2.4. La Tabla de Vectores y el Inicio del Hardware

Cuando un microcontrolador ARM Cortex-M recibe energia o se reinicia, la CPU necesita saber desde que direccion debe comenzar a ejecutar el programa y donde debe comenzar la pila, para esto existe una estructura llamada **Vector Table**, esta contiene direcciones que utiliza el procesador para conocer las funciones que debe ejecutar durante el arranque y cuando ocurre una interrupcion.

En un Cortex-M, los primeros valores de esta tabla tienen un significado especial:

1. La direccion `0x00000000` contiene el valor inicial del puntero de pila, conocido como *Main Stack Pointer* o MSP.
2. La direccion `0x00000004` contiene la direccion del *Reset Handler*, que es la primera funcion que se ejecuta despues del reset.

La direccion `0x00000000` pertenece al inicio de la region de codigo del mapa de memoria del Cortex-M, y dependiendo del microcontrolador esta region puede estar remapeada o hacer alias con la Flash fisica del dispositivo, por lo que no significa que todos los Cortex-M tengan fisicamente su Flash comenzando en `0x00000000`.

El ```linker script``` se encarga de colocar la Tabla de Vectores en una seccion especifica, normalmente llamada `.isr_vector`, y posteriormente colocar esta seccion al inicio de la region de memoria correspondiente, por ejemplo:

```ld
SECTIONS
{
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH
}
```

En este ejemplo `.isr_vector` es la seccion de salida que contiene la Tabla de Vectores, `*(.isr_vector)` toma las secciones `.isr_vector` de los archivos objeto, `KEEP()` le indica al linker que debe conservar esta seccion incluso si el linker esta configurado para eliminar secciones que aparentemente no son utilizadas, y `> FLASH` indica que debe colocarse dentro de la region de memoria Flash.

La instruccion `ALIGN(4)` se utiliza para asegurar que la seccion quede alineada en una direccion multiplo de 4, lo cual es importante porque la Tabla de Vectores esta formada por valores de 32 Bits.

## 2.5. Sinergia entre el Linker Script y el C-Startup

Existe un error comun al entender el funcionamiento del `linker script`, pensar que el linker script por si mismo copia las variables de la Flash hacia la RAM, sin embargo, esto no sucede, el linker no genera por si mismo las instrucciones que realizan esta copia, sino que calcula las direcciones que tendran las diferentes secciones y puede crear simbolos que posteriormente seran utilizados por el codigo de arranque.

El `linker script` puede definir variables especiales que funcionan como simbolos para marcar las fronteras de las diferentes secciones, por ejemplo:

- `_sdata` y `_edata`: Representan el inicio y el final de la seccion `.data` en RAM, es decir, su VMA.
- `_sidata`: Representa la direccion donde se encuentran almacenados los valores iniciales de `.data` en Flash, es decir, su LMA.
- `_sbss` y `_ebss`: Representan el inicio y el final de la seccion `.bss` en RAM.

Por ejemplo:

```ld
.data : 
{
    _sdata = .;
    *(.data*)
    _edata = .;
} > RAM AT > FLASH

_sidata = LOADADDR(.data);
```

Con las anotaciones anteriores esta instruccion diria: crea una seccion `.data`, coloca sus datos en RAM para la ejecucion, pero mantiene una copia de sus valores iniciales en Flash, `_sdata` marca el inicio de `.data` en RAM, `_edata` marca el final de `.data` en RAM y `_sidata` obtiene la direccion donde se encuentran los datos iniciales de `.data` en Flash.

El simbolo `.` dentro del `linker script` representa la posicion actual que esta calculando el linker, por lo que cuando se escribe:

```ld
_sdata = .;
```

se esta guardando en `_sdata` la direccion actual de memoria.

Posteriormente, el codigo de arranque (*Startup Code*), que puede estar escrito en Ensamblador o C dependiendo del proyecto, utiliza estos simbolos como direcciones para realizar las operaciones necesarias antes de transferir el control a la funcion `main()`.

Un ejemplo simplificado de este proceso seria:

```c
extern uint32_t _sdata, _edata, _sidata, _sbss, _ebss;

void Reset_Handler(void) {

    // 1. Copiar la seccion .data de FLASH (LMA) a RAM (VMA)
    uint32_t *src = &_sidata;
    uint32_t *dst = &_sdata;

    while (dst < &_edata) {
        *dst++ = *src++;
    }

    // 2. Limpiar la seccion .bss a cero en RAM
    dst = &_sbss;

    while (dst < &_ebss) {
        *dst++ = 0;
    }

    // 3. Llamar a la funcion principal
    main();
}
```

En este ejemplo primero se obtiene la direccion de los datos iniciales de `.data` en Flash mediante `_sidata`, despues se obtiene la direccion donde debe comenzar `.data` en RAM mediante `_sdata`, y mediante un ciclo se copian los datos desde la LMA hacia la VMA.

Despues se obtiene el inicio y final de `.bss` mediante `_sbss` y `_ebss`, y se escribe `0` en todo ese rango de RAM, de esta forma las variables que pertenecen a `.bss` comienzan con el valor esperado antes de ejecutar `main()`.

Finalmente, cuando `.data` ya fue copiada a RAM y `.bss` ya fue inicializada en cero, el codigo de arranque puede llamar a `main()` y comenzar con la ejecucion normal del programa.

### Conclusiones

Finalmente, como conclusion, creo que una gran forma de resumir todo este proceso es viendo como todo comienza desde que el compilador convierte el codigo fuente en archivos objeto y los organiza en secciones, el linker combina esos archivos y resuelve sus referencias, y el linker script le indica al linker como organizar esas secciones dentro de la memoria del microcontrolador, posteriormente, cuando el microcontrolador recibe energia o ocurre un reset, la Tabla de Vectores proporciona el MSP y la direccion del Reset Handler, el Startup Code prepara la memoria y el entorno de ejecucion, y finalmente se ejecuta `main()`.

Esto te permite ver como existe un gran proceso que se ejecuta de manera practicamente instantanea e invisible detras de cada compilacion y ejecucion de un proyecto para microcontroladores, poder entender esto ha sido una forma de tomar en cuenta todos los detalles que se tienen que manejar cuando se trabaja con estos pequeños controladores y te permite darte una perspectiva de lo automatico que es todo este proceso que normalmente es hecho por ti por las herramientas de compilacion y enlazamiento.

### Bibliografía
