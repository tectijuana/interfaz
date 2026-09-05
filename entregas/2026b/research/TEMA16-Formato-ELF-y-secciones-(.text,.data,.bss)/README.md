# Análisis Estructural del Formato ELF y Disposición de Secciones (.text, .data, .bss) en Arquitecturas ARM

---

## Introducción

El formato **ELF** (*Executable and Linkable Format*) constituye el estándar para la representación de archivos ejecutables, código objeto relocalizable, bibliotecas compartidas y volcados de memoria (*core dumps*) en la mayoría de los sistemas operativos tipo Unix, incluidos Linux y variados entornos empotrados (*embedded systems*). En arquitecturas de procesadores **ARM** (como ARMv7-A/R/M y ARMv8-A AArch32/AArch64), la comprensión de la estructura ELF es esencial para optimizar la gestión de memoria, analizar la seguridad de binarios y programar firmware en entornos bare-metal o bajo kernel Linux.

El objetivo de este documento es proporcionar un análisis exhaustivo del formato ELF con especial foco en la microarquitectura ARM. Se abordan sus encabezados fundamentales, las tablas de control, el comportamiento detallado de las secciones principales (`.text`, `.data`, `.bss`), y los mecanismos de mapeo en memoria virtual y física.

---

## Desarrollo Técnico

---

### 1. Visión General del Formato ELF

El estándar ELF organiza la información binaria de manera flexible y extensible. Para lograr esto, el formato adopta una **doble vista** (*Dual View*) en función de la etapa del ciclo de vida del software:

| Etapa | Componente de Control | Unidad de Trabajo |
| :--- | :--- | :--- |
| **Enlazado** (*Linking View*) | Tabla de Cabeceras de Sección (*Section Header Table*) | Secciones (*Sections*) |
| **Ejecución** (*Execution View*) | Tabla de Cabeceras de Programa (*Program Header Table*) | Segmentos (*Segments*) |


```text
VISTA DE ENLAZADO (Linking View)        VISTA DE EJECUCIÓN (Execution View)
================================        =================================

+---------------------------+           +---------------------------+
|        ELF Header         |           |        ELF Header         |
+---------------------------+           +---------------------------+
| Program Header Table      |           | Program Header Table      |
|        (Opcional)         |           |                           |
+---------------------------+           +---------------------------+
|          .text            | --------> | Segmento de Codigo        |
|     Codigo ejecutable     |           |       (Read / Execute)    |
+---------------------------+           +---------------------------+
|         .rodata           | --------> | Datos de solo lectura     |
|    Datos de solo lectura  |           |                           |
+---------------------------+           +---------------------------+
|          .data            | --------> | Segmento de Datos         |
|   Datos inicializados     |           |      (Read / Write)       |
+---------------------------+           +---------------------------+
|           .bss            | --------> |                           |
| Datos no inicializados    |           |                           |
+---------------------------+           +---------------------------+
| Section Header Table      |           |                           |
| Tabla de Cabeceras        |           |                           |
|       de Seccion          |           |                           |
+---------------------------+           +---------------------------+
```

#### A. Encabezado Principal (ELF Header)
Contiene la "firma" (*magic bytes*: `0x7F 'E' 'L' 'F'`) y la metainformación global del archivo. Define si el binario es de 32 bits (`ELFCLASS32`) o 64 bits (`ELFCLASS64`), el endianness (Little Endian en la mayoría de configuraciones ARM), el punto de entrada (*Entry Point*) y el tipo de arquitectura objetivo (`EM_ARM` / `0x28` para ARM 32-bit o `EM_AARCH64` / `0xB7` para 64-bit).

#### B. Tabla de Cabeceras de Programa (Program Header Table)
Es vital para el cargador del sistema operativo (*loader*). Describe los **Segmentos** (como `PT_LOAD`) que deben cargarse en memoria virtual. Mapea regiones continuas del archivo binario a direcciones de memoria con permisos estrictos de acceso (lectura `R`, escritura `W`, ejecución `X`).

#### C. Tabla de Cabeceras de Sección (Section Header Table)
Proporciona la lista completa de **Secciones**, sus nombres, tipos (`SHT_PROGBITS`, `SHT_NOBITS`), alineación y atributos (*flags* como `SHF_ALLOC`, `SHF_EXECINSTR`, `SHF_WRITE`).

---

### 3. Las Secciones Fundamentales en ARM


        Direcciones Altas de Memoria
        +---------------------------+
        |        Stack (Pila)       |  v Crece hacia abajo
        +---------------------------+
        |                           |
        |        Heap (Montículo)   |  ^ Crece hacia arriba
        +---------------------------+
        | .bss (Var. No Inic. = 0)  |  (Solo ocupa espacio en RAM)
        +---------------------------+
        | .data (Var. Inicializadas)|  (Ocupa Flash/Disco y RAM)
        +---------------------------+
        | .text (Código Ejecutable) |  (Solo Lectura / Ejecución)
        +---------------------------+
        Direcciones Bajas de Memoria


---

#### Sección A: La Sección `.text` (Código de Instrucciones)
* **Propósito:** Almacena el código de máquina traducido por el compilador para el procesador ARM, junto con las constantes de solo lectura (`.rodata`) o los *literal pools*.
* **Permisos:** Lectura y Ejecución (`R-X`). No posee permisos de escritura por motivos de seguridad (*W^X: Write XOR Execute*).
* **Particularidad en Arquitecturas ARM:**
  * En ARM de 32 bits (AArch32), la sección `.text` almacena instrucciones con alineación fija a 32 bits (4 bytes) o instrucciones comprimidas del conjunto **Thumb/Thumb-2** alineadas a 16 bits (2 bytes).
  * Contiene los llamados **Literal Pools** (pozas de literales): constantes o direcciones de 32/64 bits embebidas directamente dentro de la sección de código porque la arquitectura ARM no permite cargar literales de 32 bits mediante una sola instrucción de tipo *Immediate*.
  * En microcontroladores ARM Cortex-M, esta sección reside directamente en la memoria **Flash ROM**.

#### Sección B: La Sección `.data` (Datos Inicializados)
* **Propósito:** Contiene todas las variables globales y estáticas que han sido explícitamente inicializadas con un valor distinto de cero en el código fuente.
* **Permisos:** Lectura y Escritura (`RW-`).
* **Ubicación y Manejo de Memoria:**
  * En sistemas con S.O. (ej. Linux en ARM), el cargador mapea las copias iniciales desde el archivo ELF del almacenamiento a las páginas de RAM dedicadas al proceso.
  * En sistemas embebidos *bare-metal* (Cortex-M), los valores iniciales residen en la Flash (*LMA - Load Memory Address*) y el código de arranque (*startup script*) debe copiarlos a la memoria SRAM (*VMA - Virtual Memory Address*) antes de llamar a la función `main()`.

#### Sección C: La Sección `.bss` (Block Started by Symbol)
* **Propósito:** Guarda variables globales y estáticas no inicializadas o inicializadas explícitamente a cero.
* **Permisos:** Lectura y Escritura (`RW-`).
* **Optimización de Espacio:** 
  * A diferencia de `.data`, la sección `.bss` **no ocupa espacio físico en la imagen del ejecutable** en disco o Flash. En la cabecera de la sección se especifica su tipo como `SHT_NOBITS`.
  * La cabecera ELF solo declara la dirección inicial y el tamaño total requerido (`sh_size`).
  * Durante la carga del binario, el kernel o el *startup code* asigna el bloque de memoria RAM indicado y llena todos sus bytes con ceros (`0x00`). Esto reduce radicalmente el tamaño del archivo ejecutable.

---

### 4. Tabla Comparativa de Secciones

| Propiedad | Sección `.text` | Sección `.data` | Sección `.bss` |
| :--- | :--- | :--- | :--- |
| **Contenido** | Código de máquina ARM / Thumb / Literales | Variables globales/estáticas inicializadas | Variables globales/estáticas sin inicializar (o a cero) |
| **Tipo ELF** | `SHT_PROGBITS` | `SHT_PROGBITS` | `SHT_NOBITS` |
| **Ocupa espacio en archivo** | Sí | Sí | No |
| **Ocupa espacio en RAM** | Sí (o ejecutable desde Flash) | Sí | Sí |
| **Permisos típicos** | Read / Execute (`R-X`) | Read / Write (`RW-`) | Read / Write (`RW-`) |
| **Atributos (Flags)** | `SHF_ALLOC` + `SHF_EXECINSTR` | `SHF_ALLOC` + `SHF_WRITE` | `SHF_ALLOC` + `SHF_WRITE` |

---

### 5. Análisis Práctico con Herramientas GNU Toolchain para ARM

Para examinar la estructura ELF en binarios ARM de manera práctica, se utiliza la suite de herramientas **GNU Binary Utilities (`binutils`)**:

1. **Lectura de encabezados de programa y secciones:**
```bash
arm-none-eabi-readelf -a ejecutable.elf


Inspección detallada de las secciones de un archivo objeto:

arm-none-eabi-objdump -h ejecutable.elf
```


## Conclusiones

1. **Estructuración eficiente:** El formato ELF divide limpiamente las responsabilidades mediante la arquitectura de doble vista (*Linking View* vs *Execution View*), permitiendo que los compiladores y los cargadores del sistema operativo procesen el binario de forma independiente y óptima.

2. **Optimización de recursos en ARM:** La distinción estricta entre `.data` y `.bss` previene el desperdicio de almacenamiento no volátil (Flash o Disco), reservando almacenamiento físico en archivo solo para aquellos datos que requieren un valor inicial definido.

3. **Seguridad y ejecución:** La separación lógica de las secciones `.text` (ejecutable, no escribible) y `.data`/`.bss` (no ejecutable, escribible) permite aplicar mecanismos hardware de protección de memoria (como el bit *NX/XN - Never Execute*) en la Unidad de Manejo de Memoria (**MMU**) o de Protección de Memoria (**MPU**) de los procesadores ARM.

## Bibliografía

1. ARM Architecture Reference Manual ARMv8, *for ARMv8-A architecture profile*, ARM Ltd., Doc. ARM DDI 0487, 2021.

2. Tool Interface Standard (TIS), *Executable and Linking Format (ELF) Specification*, Version 1.2, *Relocatable Object Module Format*, 1995.

3. J. S. Joseph, *ARM Assembly Language: Fundamentals and Techniques*, 2nd ed. Boca Raton, FL, USA: CRC Press, 2015.

4. R. Linux Software Building, *System V Application Binary Interface: ELF (Executable and Linking Format)*, SCO OpenServer Architecture, 2010.

5. S. Furber, *ARM System-on-Chip Architecture*, 2nd ed. Boston, MA, USA: Addison-Wesley, 2000.


