# Linker Scripts para Microcontroladores: ARM Mapa de Memoria

- **Número de Control:** 23211980
- **Apellido:** Guzmán Ochoa

### Introducción

Cuando se programa en un lenguaje de programación como C, al compilar el código se convierte a instrucciones en código máquina que contienen direcciones de memoria relativas, las cuales no son un problema en un sistema operativo común, ya que el kernel y la MMU (Memory Management Unit) del sistema operativo se encargan de utilizar esas direcciones de memoria relativas dentro de un espacio virtual de memoria que se le asigna a la ejecución del programa. Sin embargo, cuando se usa un microcontrolador que no cuenta con estos sistemas para resolver direcciones relativas de memoria, el programa será imposible de ejecutarse, ya que las instrucciones en código máquina harán referencia a direcciones de memoria que pueda que no existan.
Para resolver esto se creó el sistema linker que, con el uso de un linker script, se encarga de traducir estas direcciones de memoria lógicas a direcciones de memoria físicas.
El propósito de esta investigación es mostrar el funcionamiento y creación de estos linker scripts que permiten el funcionamiento de código máquina con direcciones de memoria relativas en un sistema que únicamente opera con direcciones de memoria físicas.

### Desarrollo

#### 2.3 Arquitectura de Memoria del ARM Cortex-M

A diferencia de las arquitecturas de computadoras tradicionales, la familia ARM Cortex-M está compuesta por procesadores diseñados principalmente para microcontroladores. Estos implementan una arquitectura Harvard modificada en la que el bus de datos se maneja de forma distinta; esto significa que tiene buses separados para la lectura de instrucciones y el acceso a datos. Estos respectivos buses son llamados bus I-Code y los buses D-Code y System.

Estos buses se usan para acceder a un espacio de direccionamiento de 32 bits (4 GB totales), lo cual no significa que ese sea el tamaño de la RAM, sino que será el tamaño que puede representar direcciones dentro de un espacio de 4 GB; es decir, el tamaño de sus direcciones es de 32 bits, algo así: `0x00000000`. Este es un mapa de memoria fijo, lo que significa que puede representar hasta 4 GB de memoria. Personalmente me sirve recordar que, a pesar de que esos 4 GB de direcciones de memoria existen, no significa necesariamente que sean memoria física, por lo que en cada sección de memoria puede ser que solo cierto rango sea utilizado por la memoria física. Ya que se mencionaron las secciones, ese espacio de memoria fue dividido de forma estandarizada por ARM en tres distintas secciones:

* Code (0x00000000 – 0x1FFFFFFF):
  * Región destinada al código y normalmente utilizada para memoria no volátil, como Flash. La ubicación física de la Flash depende del fabricante; por ejemplo, muchos microcontroladores la ubican en 0x08000000 y pueden proporcionar un alias/remapeo en 0x00000000.

* SRAM (0x20000000 – 0x3FFFFFFF):
  * Región destinada a memoria RAM volátil de lectura/escritura, utilizada para variables (.data, .bss), la pila (stack) y, cuando se utiliza, el montón (heap).

* Peripherals (0x40000000 – 0x5FFFFFFF):
  * Región destinada a periféricos mapeados en memoria, donde las direcciones corresponden a registros de hardware para controlar dispositivos como GPIO, timers, UART, SPI, etc.

| Región de Memoria | Dirección de Inicio | Tipo de Memoria    | Uso Principal                                                          |
| ----------------- | ------------------- | ------------------ | ---------------------------------------------------------------------- |
| **Code / Flash**  | 0x00000000          | No volátil (Flash) | Código ejecutable (.text) y constantes (.rodata)                       |
| **SRAM**          | 0x20000000          | Volátil (RAM)      | Variables inicializadas (.data), variables a cero (.bss), Stack y Heap |
| **Peripherals**   | 0x40000000          | E/S mapeada        | Control de periféricos de hardware                                     |

------

#### 2.2. Anatomía del Enlazado y Archivos ELF

Ahora que se ha entendido cómo funcionan las secciones del mapa de memoria y los buses de datos de la arquitectura ARM Cortex-M, se puede pasar al siguiente concepto, que es el enlazamiento y cómo se relaciona con los archivos ELF.

Durante la etapa de compilación de tu código existe el problema de que en tu código fuente hay referencias a funciones definidas en otros archivos diferentes a `main.c`. Para esto, el compilador primero convierte tus archivos fuente (`.c`) a archivos de objeto individual (`.o`), los cuales ya tienen código máquina, pero no son ejecutables aún, ya que tienen dependencias sin resolver porque hay llamadas a funciones que pueden estar definidas en otros archivos de objeto.

Ahora bien, es importante entender cómo están estructurados los archivos objeto. Cada archivo objeto está dividido en secciones que entran en una de estas cuatro categorías:

| Sección | Significado             | ¿Qué contiene?                                                             |
| ------- | ----------------------- | -------------------------------------------------------------------------- |
| .text   | Código                  | Instrucciones ejecutables de las funciones                                 |
| .rodata | Read-Only Data          | Datos constantes que no deben modificarse, como `const` y cadenas de texto |
| .data   | Initialized Data        | Variables globales o estáticas que tienen un valor inicial                 |
| .bss    | Block Started by Symbol | Variables globales o estáticas sin valor inicial explícito                 |

Ahora que se entiende qué secciones tienen los archivos objeto, ese código objeto tiene que pasar por un proceso de enlazado que es realizado por el *linker*, el cual se encarga de tomar tus archivos de objeto y resolver las referencias cruzadas; es decir, esas llamadas a funciones que se encuentran en archivos distintos. Después de haber hecho este proceso, se encarga de empaquetar todo el código máquina en un binario ejecutable final.

Durante este proceso de enlazamiento el *linker* tiene que resolver otros problemas: en la arquitectura ARM Cortex-M hay distintas secciones de memoria para distintos propósitos (no se colocan en la misma sección el código ejecutable que las variables); además, tiene que tomar en cuenta cuánto espacio hay en cada sección y qué direcciones son utilizables para cada sección. Para esto, para poder obtener ese binario ejecutable final, se usa un `linker script` (`.ld`), el cual es un archivo que le dice al *linker* cómo organizar el programa final dentro de la memoria.

El archivo `linker script` se encarga de indicar dónde se encuentran las funciones referenciadas y en qué dirección de memoria colocarlas. Para esto, utiliza dos comandos:

1. MEMORY: Define las regiones físicas de memoria disponibles en el chip, especificando su dirección base, tamaño y permisos.
2. SECTIONS: Le indica al *linker* en qué región de memoria física debe colocar cada sección lógica de los archivos objeto.

```ld
MEMORY
{
    // FLASH => nombre de la seccion
    // rx => tiene permisos de lectura (read) y ejecucion (x)
    // origin = 0x08000000 => desde que direccion de memoria comienza esta seccion
    // LENGTH = 512K => el tamaño de la seccion
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 512K

    // Con las anotaciones anteriores esta instruccion diria: La seccion RAM tiene permisos de lectura, escritura, y ejecucion, comienza en la direccion 0x20000000 y tiene un tamaño de 128 kilobytes
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

    // Con las anotaciones anteriores esta instruccion diria: Crea una seccion .data y toma todas las instrucciones de la seccion .data del archivo objeto y colocalas dentro de la region RAM de la memoria
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

------

#### 2.3. Direcciones de Memoria: VMA vs. LMA

Uno de los conceptos más importantes para entender cómo funciona el enlazamiento en sistemas embebidos es la separación de las direcciones de memoria en dos categorías; estas son LMA y VMA. Estas dos direcciones son importantes principalmente cuando una sección necesita estar almacenada en una región de memoria, pero durante la ejecución necesita encontrarse en otra región diferente.

* **LMA (Load Memory Address):** Es la dirección donde se encuentra almacenada una sección cuando el programa es cargado en el dispositivo. En un microcontrolador, normalmente esta dirección se encuentra en una memoria no volátil como Flash; esto es importante porque el contenido de la Flash permanece almacenado aunque el dispositivo se apague.
* **VMA (Virtual Memory Address):** Es la dirección donde debe encontrarse una sección durante la ejecución del programa. En sistemas embebidos también se puede entender como la dirección donde la CPU espera encontrar esa sección para poder utilizarla, aunque el término "Virtual" viene de la definición utilizada por el *linker* y no significa necesariamente que exista memoria virtual como en una computadora tradicional.

Para secciones como `.text`, que contienen el código ejecutable, normalmente la LMA y la VMA son iguales, ya que el código puede almacenarse en Flash y ejecutarse directamente desde ella; esto es conocido como *Execute-In-Place* o XIP.

Sin embargo, esto cambia para secciones que necesitan ser modificadas durante la ejecución, como `.data`, ya que las variables modificables necesitan estar en RAM, pero sus valores iniciales necesitan estar almacenados en una memoria no volátil para que no se pierdan cuando el dispositivo se apaga, por lo que en este caso la LMA y la VMA son diferentes.

| Sección   | LMA      | VMA   | Motivo                                                                             |
| --------- | -------- | ----- | ---------------------------------------------------------------------------------- |
| `.text`   | FLASH    | FLASH | El código puede ejecutarse directamente desde Flash                                |
| `.rodata` | FLASH    | FLASH | Los datos de solo lectura no necesitan modificarse                                 |
| `.data`   | FLASH    | RAM   | Los valores iniciales se almacenan en Flash, pero las variables se utilizan en RAM |
| `.bss`    | No ocupa | RAM   | Solo necesita reservar espacio en RAM e inicializarse en cero                      |

En el caso de `.data`, el *linker script* puede indicar esta diferencia utilizando `AT > FLASH`, por ejemplo:

```ld
.data :
{
    *(.data)
} > RAM AT > FLASH

```

Con esta instrucción se está indicando que la sección `.data` tendrá su dirección de ejecución en RAM, pero su contenido inicial se almacenará en Flash; posteriormente, el código de arranque será el encargado de copiar esos datos desde la Flash hacia la RAM antes de ejecutar la función `main()`.

------

#### 2.4. La Tabla de Vectores y el Inicio del Hardware

Cuando un microcontrolador ARM Cortex-M recibe energía o se reinicia, la CPU necesita saber desde qué dirección debe comenzar a ejecutar el programa y dónde debe comenzar la pila. Para esto existe una estructura llamada **Vector Table**; esta contiene direcciones que utiliza el procesador para conocer las funciones que debe ejecutar durante el arranque y cuando ocurre una interrupción.

En un Cortex-M, los primeros valores de esta tabla tienen un significado especial:

1. La dirección `0x00000000` contiene el valor inicial del puntero de pila, conocido como *Main Stack Pointer* o MSP.
2. La dirección `0x00000004` contiene la dirección del *Reset Handler*, que es la primera función que se ejecuta después del *reset*.

La dirección `0x00000000` pertenece al inicio de la región de código del mapa de memoria del Cortex-M y, dependiendo del microcontrolador, esta región puede estar remapeada o hacer alias con la Flash física del dispositivo, por lo que no significa que todos los Cortex-M tengan físicamente su Flash comenzando en `0x00000000`.

El `linker script` se encarga de colocar la Tabla de Vectores en una sección específica, normalmente llamada `.isr_vector`, y posteriormente colocar esta sección al inicio de la región de memoria correspondiente, por ejemplo:

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

En este ejemplo, `.isr_vector` es la sección de salida que contiene la Tabla de Vectores, `*(.isr_vector)` toma las secciones `.isr_vector` de los archivos objeto, `KEEP()` le indica al *linker* que debe conservar esta sección incluso si el *linker* está configurado para eliminar secciones que aparentemente no son utilizadas, y `> FLASH` indica que debe colocarse dentro de la región de memoria Flash.

La instrucción `ALIGN(4)` se utiliza para asegurar que la sección quede alineada en una dirección múltiplo de 4, lo cual es importante porque la Tabla de Vectores está formada por valores de 32 bits.

------

#### 2.5. Sinergia entre el Linker Script y el C-Startup

Existe un error común al entender el funcionamiento del `linker script`: pensar que el *linker script* por sí mismo copia las variables de la Flash hacia la RAM. Sin embargo, esto no sucede; el *linker* no genera por sí mismo las instrucciones que realizan esta copia, sino que calcula las direcciones que tendrán las diferentes secciones y puede crear símbolos que posteriormente serán utilizados por el código de arranque.

El `linker script` puede definir variables especiales que funcionan como símbolos para marcar las fronteras de las diferentes secciones, por ejemplo:

* `_sdata` y `_edata`: Representan el inicio y el final de la sección `.data` en RAM; es decir, su VMA.
* `_sidata`: Representa la dirección donde se encuentran almacenados los valores iniciales de `.data` en Flash; es decir, su LMA.
* `_sbss` y `_ebss`: Representan el inicio y el final de la sección `.bss` en RAM.

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

Con las anotaciones anteriores esta instrucción diría: crea una sección `.data`, coloca sus datos en RAM para la ejecución, pero mantiene una copia de sus valores iniciales en Flash; `_sdata` marca el inicio de `.data` en RAM, `_edata` marca el final de `.data` en RAM y `_sidata` obtiene la dirección donde se encuentran los datos iniciales de `.data` en Flash.

El símbolo `.` dentro del `linker script` representa la posición actual que está calculando el *linker*, por lo que cuando se escribe:

```ld
_sdata = .;

```

se está guardando en `_sdata` la dirección actual de memoria.

Posteriormente, el código de arranque (*Startup Code*), que puede estar escrito en Ensamblador o C dependiendo del proyecto, utiliza estos símbolos como direcciones para realizar las operaciones necesarias antes de transferir el control a la función `main()`.

Un ejemplo simplificado de este proceso sería:

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

En este ejemplo, primero se obtiene la dirección de los datos iniciales de `.data` en Flash mediante `_sidata`, después se obtiene la dirección donde debe comenzar `.data` en RAM mediante `_sdata`, y mediante un ciclo se copian los datos desde la LMA hacia la VMA.

Después se obtiene el inicio y final de `.bss` mediante `_sbss` y `_ebss`, y se escribe `0` en todo ese rango de RAM; de esta forma, las variables que pertenecen a `.bss` comienzan con el valor esperado antes de ejecutar `main()`.

Finalmente, cuando `.data` ya fue copiada a RAM y `.bss` ya fue inicializada en cero, el código de arranque puede llamar a `main()` y comenzar con la ejecución normal del programa.

### Conclusiones

Finalmente, como conclusión, creo que una gran forma de resumir todo este proceso es viendo cómo todo comienza desde que el compilador convierte el código fuente en archivos objeto y los organiza en secciones, el *linker* combina esos archivos y resuelve sus referencias, y el *linker script* le indica al *linker* cómo organizar esas secciones dentro de la memoria del microcontrolador. Posteriormente, cuando el microcontrolador recibe energía u ocurre un *reset*, la Tabla de Vectores proporciona el MSP y la dirección del *Reset Handler*, el *Startup Code* prepara la memoria y el entorno de ejecución, y finalmente se ejecuta `main()`.

Esto te permite ver cómo existe un gran proceso que se ejecuta de manera prácticamente instantánea e invisible detrás de cada compilación y ejecución de un proyecto para microcontroladores. Poder entender esto ha sido una forma de tomar en cuenta todos los detalles que se tienen que manejar cuando se trabaja con estos pequeños controladores y te permite darte una perspectiva de lo automático que es todo este proceso, que normalmente es hecho por ti por las herramientas de compilación y enlazamiento.

### Bibliografía
