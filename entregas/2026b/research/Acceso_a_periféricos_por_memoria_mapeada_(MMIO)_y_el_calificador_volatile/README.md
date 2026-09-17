# Acceso a periféricos por memoria mapeada (MMIO) y el calificador `volatile`.

## INTRODUCCION
Cuando hablamos de entrada y salida mapeada en memoria o por sus siglas "MMIO", entendemos que es una técnica que utilizamos para permitir 
la comunicación entre el procesador y los dispositivos de hardware, esto mediante direcciones de memoria específicos los cuales se verán
mas adelante en esta investigación. En este método en cuestión ciertos rangos del espacio de direcciones físicas se reservan para los para
los dispositivos, a su vez esto permite que el CPU interactúe con ellos utilizando operaciones normales de lectura y escritura.

Dentro de este contexto, el lenguaje C proporciona herramientas importantes para trabajar directamente con hardware, entre ellas el
calificador `volatile`. Este calificador le indica al compilador que valor de una variable puede cambiar de manera inesperada, por ejemplo,
debido a la acción de un dispositivo externo. `volatile` es especialmente relevante al trabajar con registros de hardware mediante MMIO, ya que
ayuda a garantizar que cada acceso realizado por el programa se efectué realmente sobre el dispositivo y no sea eliminado u optimizado
incorrectamente por el compilador

## DESARROLLO
## 1. Comunicación entre el procesador y los periféricos
### 1.1 Regiones de MMIO y mapas de memoria
Las regiones MMIO (Memory-Mapped I/O) ocupan rangos de direcciones físicas fijas establecidas por el diseño del SoC (System on a Chip).
Durante el proceso de arranque, el kernel de Linux descubre la ubicación y el tamaño de estas regiones consultando el Árbol de Dispositivos (Device Tree, o DT).
Una vez identificadas, Linux reserva estas áreas y crea mapeos de memoria virtual, habitualmente utilizando la función ioremap(). Es crucial
que estas asignaciones se configuren con atributos de memoria de "tipo de dispositivo", esto asegura que se desactive la memoria caché
se evite la reordenación de instrucciones. De esta manera, se garantiza que el procesador lea y escriba los datos interactuando directamente con los registros del periférico 
físico en tiempo real.

### 1.2 Traducción de direcciones virtuales a físicas
La CPU siempre emite direcciones virtuales (VA). Antes de que las transacciones lleguen a la interconexión, la unidad de gestión de Memoria (MMU) traduce las VA
a direcciones físicas (PA). La MMU utiliza un búfer de traducción anticipada (TLB) para las traducciones almacenadas en caché y realiza un recorrido de la tabla de 
páginas en caso de fallos en el TLB

![Traduccion de VA-PA](https://media2-dev-to.translate.goog/dynamic/image/width=800%2Cheight=%2Cfit=scale-down%2Cgravity=auto%2Cformat=auto/https%3A%2F%2Fdev-to-uploads.s3.amazonaws.com%2Fuploads%2Farticles%2Feutqp5b9kxb4epqw21cf.png?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc)
## 2. E/S mapeada en memoria (MMIO)
La E/S mapeada en memoria (Memory-Mapped I/O o MMIO) es un mecanismo que permite integrar los registros de los dispositivos de entrada y salida dentro del espacio de direcciones físicas del sistema. De esta manera, la CPU puede comunicarse con determinados periféricos mediante operaciones de lectura y escritura similares a las utilizadas para acceder a la memoria.

En MMIO, determinados rangos de direcciones físicas son asignados a dispositivos de hardware. Cuando el procesador realiza una operación sobre una de estas direcciones, el acceso no se dirige a la memoria RAM, sino al dispositivo asociado con ese rango.

Una de las principales características de MMIO es que permite utilizar instrucciones normales de acceso a memoria para comunicarse con los dispositivos. Esto simplifica la programación de bajo nivel, ya que no es necesario disponer de un conjunto separado de instrucciones de entrada y salida para cada acceso.

Este mecanismo es utilizado en diferentes componentes de un sistema, como dispositivos PCI, controladores de hardware y regiones de memoria asociadas con determinados dispositivos.

### 2.1 Espacio y mapa de direcciones
MMIO utiliza parte del espacio de direcciones físicas disponible para representar los registros de los periféricos. Esto significa que una dirección física puede corresponder a memoria RAM o a un registro de hardware, dependiendo de la configuración del sistema.
### Mapa de Direcciones Físicas (SoC Ejemplificar)

| Rango de Direcciones Físicas | Tamaño | Tipo | Descripción |
| :--- | :--- | :--- | :--- |
| `0x0000_0000` - `0x7FFF_FFFF` | 2 GB | RAM | Memoria DDR (Sistema Principal) |
| `0x8000_0000` - `0x8000_0FFF` | 4 KB | Periférico | UART 0 (Puerto Serie) |
| `0x8000_1000` - `0x8000_1FFF` | 4 KB | Periférico | I2C Controller |
| `0x8000_2000` - `0x8000_2FFF` | 4 KB | Periférico | SPI Controller |
| `0x8001_0000` - `0x8001_00FF` | 256 B | Periférico | GPIO Controller (Pines de E/S) |
| `0x8002_0000` - `0x8002_0FFF` | 4 KB | Periférico | Timer / Contador del sistema |
| `0x8003_0000` - `0x8003_FFFF` | 64 KB | Periférico | Controlador Ethernet (NIC) |
| `0x8004_0000` - `0x8FFF_FFFF` | ~255 MB | Reservado | Espacio reservado para periféricos futuros |
| `0x9000_0000` - `0xFFFF_FFFF` | ~1.75 GB | RAM | Extensión DDR (Si el sistema tiene 4 GB) |
### 2.2 Registros de los periféricos
Los periféricos cuentan con **registros de hardware internos** que permiten a la CPU configurarlos, controlarlos y consultar su estado. Estos registros no deben confundirse con los registros internos de la CPU, ya que pertenecen al dispositivo y cumplen funciones específicas relacionadas con su operación.

En un sistema que utiliza MMIO, estos registros se asocian con determinadas **direcciones dentro del espacio de direcciones físicas**. De esta manera, cuando la CPU accede a una de estas direcciones, la operación se dirige al registro correspondiente del periférico en lugar de a la memoria RAM.

Los registros de un periférico pueden cumplir diferentes funciones:

- **Registros de control:** permiten configurar o modificar el funcionamiento del dispositivo.
- **Registros de estado:** proporcionan información sobre el estado actual del periférico.
- **Registros de datos:** permiten enviar o recibir información entre la CPU y el dispositivo.

Por ejemplo, un controlador GPIO ficticio podría tener la siguiente distribución:

| Dirección | Registro | Función |
|---|---|---|
| `0x40000000` | `GPIO_MODE` | Configura los pines como entrada o salida |
| `0x40000004` | `GPIO_OUTPUT` | Controla el estado de los pines de salida |
| `0x40000008` | `GPIO_INPUT` | Permite consultar el estado de los pines de entrada |
| `0x4000000C` | `GPIO_STATUS` | Indica el estado del controlador |

### 2.3 Lecturas y escrituras MMIO
La comunicación con los registros de un periférico mediante MMIO se realiza a través de **operaciones de lectura y escritura**. Desde el punto de vista de la CPU, estas operaciones utilizan mecanismos similares a los empleados para acceder a memoria, pero la dirección utilizada determina que la transacción sea enviada hacia un dispositivo de hardware.

Una **escritura MMIO** permite enviar un valor a un registro del periférico. Dependiendo de la función del registro, esta escritura puede provocar una acción física o modificar la configuración del dispositivo.

Por ejemplo, suponiendo que `GPIO_OUTPUT` se encuentre asociado con la dirección `0x40000004`, escribir un valor en este registro podría modificar el estado de un pin:
```c
*GPIO_OUTPUT = 1;
```
Por otro lado, una **lectura MMIO** permite obtener información proveniente del periférico. Por ejemplo, la CPU podría consultar un registro para determinar si un dispositivo está listo, conocer el estado de un botón o recibir datos provenientes de un controlador.

```c
estado = *GPIO_INPUT;
```
## 4. Acceso a MMIO desde C
En C, los registros de los periféricos mapeados en memoria pueden representarse mediante **punteros que apuntan directamente a las direcciones asignadas al hardware**. Esto permite utilizar operaciones normales del lenguaje para leer o modificar los registros de un dispositivo.

Un ejemplo se encuentra en la Raspberry Pi Pico, donde diferentes periféricos poseen direcciones específicas dentro del mapa de memoria. Para acceder a los registros del bloque de reinicio se pueden definir punteros de la siguiente manera:
```c
const uint32_t resets_base = 0x4000C000;

volatile uint32_t * const resets_reset =
    (volatile uint32_t *)resets_base;

volatile uint32_t * const resets_reset_done =
    (volatile uint32_t *)(resets_base + 0x8);
```
En este código, `resets_base` contiene la dirección base del periférico. A partir de ella se obtienen las direcciones de los diferentes registros. El tipo `uint32_t` indica que los registros utilizados tienen un tamaño de **32 bits**.

La expresión:
```c
volatile uint32_t * const
```
contiene dos calificadores con funciones diferentes. `volatile` se aplica al dato apuntado e indica que el contenido del registro puede cambiar por causas externas al programa y que sus accesos son significativos. Por otro lado, `const` hace que el propio puntero mantenga siempre la misma dirección.

Una vez definido el puntero, el registro puede ser accedido mediante el operador de desreferencia `*`:
```c
*resets_reset |= 1 << 5;
```
Esta operación modifica el bit 5 del registro `RESET`. Posteriormente, el programa puede consultar otro registro hasta que el hardware indique que la operación ha finalizado:
```c
while ((*resets_reset_done & (1 << 5)) == 0)
    ;
```
En este caso, el programa realiza lecturas repetidas del registro `RESET_DONE` y comprueba su bit 5. El contenido de este registro puede ser modificado directamente por el hardware, sin que el programa realice una escritura sobre él.

### Registros organizados en bloques

Los periféricos suelen contener varios registros organizados a partir de una **dirección base**. En lugar de definir manualmente una dirección completamente independiente para cada registro, es posible calcularla utilizando un desplazamiento (*offset*).

Por ejemplo, en un bloque GPIO donde cada conjunto de registros ocupa 8 bytes, la dirección de un registro de control puede calcularse conceptualmente como:
```text
Dirección del registro = Dirección base + (n × 8) + desplazamiento
```
Esto permite acceder de manera organizada a múltiples registros similares utilizando su posición dentro del bloque del periférico.

De esta forma, C proporciona los elementos necesarios para establecer una interfaz directa con dispositivos mapeados en memoria mediante **direcciones, punteros, operaciones sobre bits y el calificador `volatile`**.
## 5. El calificador `volatile`

### 5.1 Funcionamiento de `volatile`

El calificador `volatile` se utiliza en C para indicar que el valor de un objeto puede cambiar de una forma que no es evidente únicamente al analizar el flujo normal del programa. Esto puede ocurrir, por ejemplo, cuando una posición de memoria representa un registro de hardware cuyo contenido puede ser modificado directamente por un periférico.

Al utilizar `volatile`, se indica al compilador que los accesos realizados sobre ese objeto son significativos y que no debe asumir que su valor permanece sin cambios simplemente porque el programa no lo haya modificado.

Esto es especialmente importante cuando se trabaja con MMIO, ya que los registros de los periféricos pueden cambiar independientemente de la ejecución normal del programa.

Por ejemplo, supongamos que existe un registro de estado que indica si un dispositivo se encuentra ocupado o listo:

```text
Registro STATUS

0x00000000  →  Dispositivo ocupado
      ↓
      ↓ El hardware termina su operación
      ↓
0x00000001  →  Dispositivo listo
```

El cambio entre ambos valores puede ser realizado directamente por el hardware, sin que el programa ejecute una instrucción de escritura sobre ese registro.

### 5.2 ¿Por qué es necesario `volatile` en MMIO?

Cuando los registros de hardware se encuentran mapeados en direcciones de memoria, el compilador de C o C++ no necesariamente conoce que detrás de esas direcciones existe un periférico, como un temporizador, un controlador GPIO o una tarjeta de red.

El compilador normalmente aplica optimizaciones suponiendo el comportamiento convencional de la memoria. Por ejemplo, si un valor es leído varias veces y el programa no realiza ninguna escritura sobre él, podría considerar innecesario repetir determinadas lecturas.

Esto representa un problema en MMIO, ya que el contenido de un registro puede ser modificado directamente por el hardware, independientemente de las instrucciones ejecutadas por el programa.

#### Problema sin `volatile`

Supongamos que un programa necesita esperar hasta que un registro de estado cambie su valor:

```c
uint32_t *status_reg = (uint32_t *)0x40001000;

while (*status_reg == 0) {
    // Esperar a que el hardware cambie el estado
}
```

En este ejemplo, el programa no modifica el contenido apuntado por `status_reg` dentro del ciclo. Al tratarse de un objeto no declarado como `volatile`, el compilador puede aplicar optimizaciones basándose únicamente en las modificaciones que observa dentro del programa.

Conceptualmente, una optimización podría producir un comportamiento equivalente al siguiente:

```c
uint32_t temp = *status_reg;

while (temp == 0) {
    // El registro de hardware ya no se vuelve a consultar
}
```

En este caso, el valor sería leído inicialmente y almacenado temporalmente. Si el valor obtenido fuera `0`, las siguientes iteraciones podrían continuar utilizando ese mismo valor y el programa no observaría posteriormente el cambio realizado por el hardware.

El problema puede representarse de la siguiente manera:

```text
Primera lectura

Registro STATUS
0x00000000
      │
      ▼
Registro de la CPU
0x00000000

      ↓ El hardware modifica STATUS

Registro STATUS
0x00000001

Pero el programa continúa utilizando:

Registro de la CPU
0x00000000
```

Por esta razón, el programa necesita indicar que el valor asociado con esa dirección puede cambiar independientemente de las modificaciones visibles en el código.

#### Solución mediante `volatile`

El registro puede declararse utilizando el calificador `volatile`:

```c
volatile uint32_t *status_reg =
    (volatile uint32_t *)0x40001000;

while (*status_reg == 0) {
    // Consultar nuevamente el registro
}
```

En este caso, los accesos se realizan sobre un objeto declarado como `volatile`. Esto indica al compilador que las lecturas del registro son observables y que no debe eliminar una lectura simplemente porque el programa no haya realizado una escritura sobre ese valor.

el funcionamiento esperado puede representarse de la siguiente manera:

```text
Lectura 1
STATUS → 0x00000000
           ↓
     Dispositivo ocupado

Lectura 2
STATUS → 0x00000000
           ↓
     Dispositivo ocupado

      ↓ El hardware cambia el registro

Lectura 3
STATUS → 0x00000001
           ↓
      Dispositivo listo
```

De esta manera, el programa puede detectar los cambios producidos directamente por el periférico.

### 5.3 ¿Qué garantiza `volatile`?

El calificador `volatile` indica al compilador que los accesos al objeto tienen importancia para el comportamiento del programa. Esto resulta especialmente útil en MMIO, donde una lectura o escritura puede representar una interacción con un dispositivo de hardware.

Entre sus principales efectos se encuentran:

- **Preservación de accesos:** las lecturas y escrituras `volatile` requeridas por el programa no pueden eliminarse simplemente por considerarse innecesarias.

- **Cambios externos:** el compilador no debe asumir que el valor permanece constante únicamente porque el programa no lo haya modificado.

- **Acceso a registros MMIO:** permite expresar en C que una dirección representa un objeto cuyo estado puede depender directamente del hardware.

Por ejemplo:

```c
volatile uint32_t *status =
    (volatile uint32_t *)0x40001000;

uint32_t estado = *status;
```

En este caso, el acceso a `*status` corresponde a una lectura de un objeto `volatile`, por lo que tiene significado observable para el programa.

Sin embargo, `volatile` tiene ciertas limitaciones. No debe considerarse por sí mismo un mecanismo de sincronización entre diferentes hilos o núcleos, ni garantiza atomicidad o todas las formas de ordenamiento de memoria que pueden requerirse en una arquitectura determinada. Estas características pueden necesitar mecanismos adicionales proporcionados por el lenguaje, la arquitectura o el sistema.

## Conclusiones
A lo largo de esta investigación se pudo comprender cómo la entrada y salida mapeada en memoria (MMIO) permite establecer una comunicación directa entre el procesador y los diferentes periféricos de un sistema. Mediante este mecanismo, los registros de hardware son asociados con direcciones dentro del espacio de memoria, permitiendo que la CPU pueda consultar el estado de un dispositivo, enviar información o modificar su funcionamiento utilizando operaciones de lectura y escritura.

También se observó cómo el lenguaje C permite trabajar con estos registros mediante punteros que hacen referencia a direcciones específicas de memoria. Esto demuestra la relación que existe entre el software y el hardware, ya que una operación realizada desde el código puede terminar provocando una acción directamente sobre un periférico. El uso de direcciones base, desplazamientos y operaciones sobre bits permite acceder y modificar registros específicos de un dispositivo. 

Por otra parte, se identificó la importancia del calificador `volatile` al trabajar con MMIO. Los registros de hardware pueden cambiar independientemente de las instrucciones ejecutadas por el programa, por lo que el compilador no debe tratarlos de la misma manera que una posición convencional de memoria. `volatile` permite indicar que estos accesos son significativos y evita que determinadas optimizaciones eliminen accesos que son necesarios para interactuar correctamente con el hardware.

Finalmente, MMIO y `volatile` muestran la importancia de comprender la interacción entre el lenguaje de programación, el compilador, el procesador y los dispositivos físicos. Aunque `volatile` es una herramienta importante para trabajar con registros MMIO, también se debe considerar que tiene limitaciones y que por sí mismo no proporciona mecanismos como atomicidad o sincronización. Comprender estos conceptos permite tener una visión más clara de cómo un programa escrito en un lenguaje como C puede utilizarse para controlar y comunicarse directamente con el hardware.

## Referencias

[1] L. Clipp, “GPU Virtualization Part 1: An Introduction to PCIe and MMIO,” *Top of Mind*, Feb. 15, 2026. [Online]. Available: https://topofmind-dev.translate.goog/blog/2026/02/15/gpu-virtualization-part-1-an-introduction-to-pcie-and-mmio/?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc

[2] Microsoft, “volatile (Referencia de C#),” *Microsoft Learn*, Jan. 26, 2026. [Online]. Available: https://learn.microsoft.com/es-es/dotnet/csharp/language-reference/keywords/volatile

[3] R. Deuri, “Memory Mapped IO (MMIO),” *DEV Community*, Nov. 20, 2025. [Online]. Available: https://dev-to.translate.goog/ripan030/memory-mapped-io-mmio-5bn8?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc

[4] L. Llamas, “Volatile en C++: variables que pueden cambiar fuera del código,” *Luis Llamas*. [Online]. Available: https://www.luisllamas.es/cpp-variables-volatile/
