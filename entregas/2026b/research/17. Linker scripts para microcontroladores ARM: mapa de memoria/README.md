# Linker Scripts para Microcontroladores ARM: Mapa de Memoria

## Introducción

Cuando se desarrolla software para un microcontrolador ARM, el programa no solamente necesita ser compilado, sino que también debe organizarse correctamente dentro de la memoria disponible del dispositivo. A diferencia de una computadora convencional, un microcontrolador cuenta con cantidades limitadas de memoria y diferentes regiones destinadas a funciones específicas. Por esta razón, es necesario indicar dónde debe colocarse cada parte del programa.

En este proceso participa el **linker**, una herramienta que combina los diferentes archivos objeto generados durante la compilación para crear el programa final. Para indicarle al linker cómo debe organizar la memoria se utiliza un **linker script**.

Un linker script puede entenderse como un plano que describe cómo se distribuirá el programa dentro de la memoria del microcontrolador. En él se pueden definir regiones como FLASH y RAM, indicando su dirección inicial y el tamaño disponible. También se puede especificar dónde deben colocarse secciones del programa como `.text`, `.rodata`, `.data` y `.bss`.

El concepto de **mapa de memoria** está directamente relacionado con este proceso, ya que representa la organización de las diferentes regiones de memoria y sus direcciones. Comprender esta relación permite saber dónde se encuentra el código, dónde se almacenan las variables y cuánto espacio tiene disponible el programa.

En este trabajo se explica el funcionamiento de los linker scripts en microcontroladores ARM, la relación que tienen con el mapa de memoria y la función de las principales secciones utilizadas durante la organización del programa.

# Desarrollo técnico

## ¿Qué es un linker?

El linker, también conocido como enlazador, es una herramienta que participa después de la compilación. Cuando un programa escrito en C se compila, el código fuente puede convertirse en uno o varios archivos objeto. Estos archivos contienen diferentes partes del programa que todavía necesitan ser combinadas para formar el programa final.

El proceso puede representarse de la siguiente manera:

```text
Código fuente
     ↓
Compilador
     ↓
Archivos objeto (.o)
     ↓
Linker
     ↓
Programa final (.elf)
     ↓
Microcontrolador
```

El linker se encarga de combinar las diferentes partes del programa y resolver referencias entre ellas. Sin embargo, en un microcontrolador también necesita conocer cómo está organizada la memoria del dispositivo.
Por ejemplo, si un microcontrolador tiene una región FLASH y otra región RAM, el linker necesita saber cuáles son sus direcciones y cuánto espacio existe en cada una.

---

## ¿Qué es un linker script?

Un **linker script** es un archivo que contiene instrucciones para indicarle al linker cómo debe organizar el programa final.

GNU `ld`, uno de los linkers utilizados en sistemas basados en GNU, permite definir regiones de memoria mediante el comando `MEMORY` y organizar las secciones del programa mediante `SECTIONS`.

Un ejemplo sencillo de definición de memoria es:

```ld
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 256K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}
```

En este ejemplo se están definiendo dos regiones:

```text
FLASH
Inicio: 0x08000000
Tamaño: 256 KB

RAM
Inicio: 0x20000000
Tamaño: 64 KB
```

`ORIGIN` indica la dirección donde comienza la región de memoria, mientras que `LENGTH` indica cuánto espacio está disponible.

Es importante aclarar que estas direcciones son solamente un ejemplo. El mapa de memoria real depende del microcontrolador ARM utilizado.

---

## Mapa de memoria

El mapa de memoria describe cómo están distribuidas las diferentes regiones de memoria de un microcontrolador y qué direcciones ocupan.

Un ejemplo simplificado puede representarse de esta manera:

```text
┌─────────────────────────────┐
│           FLASH             │
│                             │
│  Código del programa        │
│  .text                      │
│  .rodata                    │
│  Datos iniciales            │
│                             │
└─────────────────────────────┘

┌─────────────────────────────┐
│            RAM              │
│                             │
│  .data                      │
│  .bss                       │
│  Heap                       │
│  Stack                      │
│                             │
└─────────────────────────────┘
```

La organización exacta depende del microcontrolador. Sin embargo, esta representación permite comprender la idea general: diferentes partes del programa utilizan diferentes regiones de memoria.

---

## FLASH y RAM

Dos regiones importantes en muchos microcontroladores ARM son la **FLASH** y la **RAM**.

La FLASH es una memoria no volátil. Esto significa que conserva su contenido aunque el microcontrolador sea apagado. Por esta razón, normalmente se utiliza para almacenar el código del programa y otros datos que deben conservarse.

Por ejemplo:

```c
const int velocidad = 100;
```

Una constante como esta puede almacenarse en una región de memoria de solo lectura.

La RAM, por otro lado, es utilizada durante la ejecución del programa para almacenar información que puede cambiar.

Por ejemplo:

```c
int contador = 10;
```

El valor de `contador` puede cambiar mientras el programa está funcionando:

```c
contador++;
contador = 50;
```

Por esta razón necesita encontrarse en una región de memoria que permita escritura.

De forma simplificada:

```text
FLASH
→ Código
→ Constantes
→ Información persistente

RAM
→ Variables
→ Datos temporales
→ Stack
→ Heap
```

---

## Principales secciones del programa

El linker trabaja con diferentes **secciones**, que permiten organizar las partes del programa.

### `.text`

La sección `.text` contiene principalmente las instrucciones ejecutables del programa.

Por ejemplo, una función como:

```c
int suma(int a, int b)
{
    return a + b;
}
```

genera instrucciones que forman parte del código ejecutable.

En muchos sistemas ARM, esta sección se coloca en FLASH.

---

### `.rodata`

El nombre `.rodata` proviene de *read-only data*, que significa datos de solo lectura.

Aquí pueden encontrarse constantes y otros datos que el programa necesita consultar pero que no deben modificarse.

Por ejemplo:

```c
const char mensaje[] = "Hola";
```

Este tipo de información puede mantenerse en FLASH.

---

### `.data`

La sección `.data` contiene normalmente variables globales o estáticas que tienen un valor inicial.

Por ejemplo:

```c
int contador = 10;
```

Durante la ejecución, `contador` debe estar en RAM porque puede modificarse.

Sin embargo, el valor inicial `10` debe estar disponible cuando el microcontrolador comienza a ejecutarse. Por eso, en sistemas embebidos, los datos iniciales pueden almacenarse en FLASH y posteriormente copiarse a RAM durante el proceso de inicio.

La idea puede representarse así:

```text
FLASH
┌─────────────────┐
│ contador = 10   │
└────────┬────────┘
         │
         │ Inicio del sistema
         ↓
RAM
┌─────────────────┐
│ contador = 10   │
└─────────────────┘
```

---

### `.bss`

La sección `.bss` se utiliza normalmente para variables globales o estáticas que no tienen un valor inicial explícito o que deben comenzar en cero.

Por ejemplo:

```c
int contador;
```

Cuando comienza el programa, se espera que:

```text
contador = 0
```

No es necesario almacenar una gran cantidad de ceros en FLASH. Durante el proceso de inicio, esta región de RAM puede ser inicializada a cero.

De manera sencilla:

```text
.data
→ Tiene un valor inicial
→ Sus datos iniciales deben estar disponibles al arrancar

.bss
→ Comienza en cero
→ Se inicializa durante el arranque
```

---

## El comando `SECTIONS`

Además de definir las regiones de memoria mediante `MEMORY`, el linker script puede utilizar `SECTIONS` para indicar dónde deben colocarse las diferentes secciones del programa.

Por ejemplo:

```ld
SECTIONS
{
    .text :
    {
        *(.text*)
    } > FLASH

    .data :
    {
        *(.data*)
    } > RAM

    .bss :
    {
        *(.bss*)
    } > RAM
}
```

Este ejemplo indica:

```text
.text → FLASH

.data → RAM

.bss → RAM
```

De esta manera, el linker puede construir el programa final respetando la organización definida.

Con eso la relación puede entenderse así:

```text
             LINKER SCRIPT
                    │
          ┌─────────┴─────────┐
          ↓                   ↓
       MEMORY              SECTIONS
          │                   │
          ↓                   ↓
¿Qué memoria existe?    ¿Qué va dónde?
          │                   │
          └─────────┬─────────┘
                    ↓
             MAPA DE MEMORIA
                    ↓
             PROGRAMA FINAL
```

---

## Stack y Heap

Además de las secciones anteriores, la RAM también puede utilizarse para el **Stack** y el **Heap**.

El *Stack* se utiliza, entre otras cosas, durante las llamadas a funciones y para almacenar determinadas variables locales.

Por ejemplo:

```c
void funcion()
{
    int numero = 10;
}
```

La variable local puede utilizar espacio asociado al Stack.

En muchos sistemas basados en Cortex-M, el Stack se coloca hacia una zona alta de la RAM y puede crecer hacia direcciones menores.

El Heap se relaciona con la memoria utilizada para asignaciones dinámicas cuando el sistema las utiliza.

De manera simplificada, una RAM podría organizarse así:

```text
Direcciones altas
┌─────────────────────┐
│       Stack         │
│         ↓           │
├─────────────────────┤
│                     │
│    Espacio libre    │
│                     │
├─────────────────────┤
│         ↑           │
│        Heap         │
├─────────────────────┤
│      .bss           │
│      .data          │
└─────────────────────┘
Direcciones bajas
```

Esta organización puede variar dependiendo de la arquitectura y configuración utilizada.

---

## ¿Qué ocurre cuando no hay suficiente memoria?

Uno de los motivos por los que los linker scripts son importantes es que la memoria de un microcontrolador es limitada.

Supongamos que un dispositivo tiene:

```text
FLASH = 256 KB
RAM   = 64 KB
```

Si el programa utiliza:

```text
.text      180 KB
.rodata     40 KB
```

todavía queda espacio disponible en FLASH.

Pero si el programa crece demasiado:

```text
.text      220 KB
.rodata     50 KB
```

la suma supera esa capacidad disponible.

El linker puede detectar esta situación y generar un error indicando que una región de memoria no tiene el suficiente espacio.

Algo similar puede ocurrir con la RAM. Las secciones `.data`, `.bss`, Stack y Heap compiten por el espacio disponible.

Por esta razón, es muy importante conocer el mapa de memoria permite identificar cuánto espacio se está utilizando y detectar problemas antes de ejecutar el programa.

---

## Importancia de los linker scripts en microcontroladores ARM

En un programa de computadora tradicional, el programador normalmente no necesita especificar manualmente la dirección física donde debe colocarse cada sección del programa. En sistemas embebidos, esta información es mucho más importante porque el hardware tiene una organización de memoria específica y recursos limitados.

El linker script permite adaptar el programa a las características del microcontrolador utilizado.

Por ejemplo, si un dispositivo tiene diferentes regiones de memoria, el desarrollador puede establecer reglas para determinar qué información debe colocarse en cada una.

Esto también permite aprovechar regiones específicas de memoria cuando el hardware las proporciona.

Por lo tanto, el linker script funciona como una conexión entre el software compilado y la organización física de la memoria del microcontrolador.

---

# Conclusiones

Los linker scripts son una parte importante del desarrollo de software para microcontroladores ARM porque permiten establecer cómo se distribuirá el programa dentro de la memoria disponible.

El mapa de memoria permite conocer las diferentes regiones existentes, sus direcciones y sus tamaños. A partir de esta información, el linker script puede indicar qué partes del programa deben colocarse en cada región.

Durante el desarrollo del tema se observó que la FLASH y la RAM cumplen funciones diferentes. La FLASH puede utilizarse para almacenar el código y datos que deben conservarse, mientras que la RAM permite trabajar con información modificable durante la ejecución.

También se analizaron las secciones `.text`, `.rodata`, `.data` y `.bss`, las cuales permiten organizar diferentes tipos de información dentro del programa. Además, el Stack y el Heap utilizan parte de la RAM y deben considerarse cuando se analiza el consumo de memoria.

Una de las ideas principales es que el linker script puede verse como un plano de distribución del programa. El comando `MEMORY` permite describir las regiones disponibles, mientras que `SECTIONS` permite establecer cómo se distribuirán las diferentes partes del programa.

Finalmente, comprender los linker scripts y los mapas de memoria es importante en sistemas embebidos porque los recursos son limitados. Una mala distribución puede provocar que el programa no pueda ser enlazado o que durante su ejecución no exista suficiente memoria disponible.

---

# Bibliografía

[1] GNU Project, “LD: The GNU Linker,” *GNU Binutils Documentation*. [En línea]. Disponible en: https://sourceware.org/binutils/docs/ld/

[2] GNU Project, “MEMORY Command,” *GNU Linker Documentation*. [En línea]. Disponible en: https://sourceware.org/binutils/docs/ld/MEMORY.html

[3] GNU Project, “SECTIONS Command,” *GNU Linker Documentation*. [En línea]. Disponible en: https://sourceware.org/binutils/docs/ld/SECTIONS.html

[4] Arm Limited, “Cortex-M Processors,” *Arm Developer*. [En línea]. Disponible en: https://developer.arm.com/Processors/Cortex-M

[5] Zephyr Project, “Linker Scripts for ARM Cortex-M,” *Zephyr Project Documentation and Source Code*. [En línea]. Disponible en: https://github.com/zephyrproject-rtos/zephyr/tree/main/include/zephyr/arch/arm/cortex_m/scripts
