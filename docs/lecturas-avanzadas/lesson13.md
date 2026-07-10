### CAPÍTULO 12: **Seguridad y Manejo de Excepciones Avanzadas en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a la seguridad en ARM64](#introducción-a-la-seguridad-en-arm64)
2. [Modos de ejecución y niveles de privilegio](#modos-de-ejecución-y-niveles-de-privilegio)
3. [Manejo de excepciones avanzadas](#manejo-de-excepciones-avanzadas)
4. [Protección de memoria y uso de la MMU](#protección-de-memoria-y-uso-de-la-mmu)
5. [Mitigación de vulnerabilidades de hardware](#mitigación-de-vulnerabilidades-de-hardware)
6. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a la seguridad en ARM64

En la arquitectura **ARM64**, la seguridad juega un papel crucial para garantizar la integridad del sistema y la protección de los datos frente a ataques. En entornos embebidos como el **Raspberry Pi 5**, donde los dispositivos pueden estar expuestos a redes y otros actores externos, implementar medidas de seguridad a nivel de hardware y software es esencial.

ARM64 incluye varias características de seguridad integradas que permiten proteger el acceso a recursos críticos como la memoria, los registros y los periféricos. Estas incluyen los niveles de privilegio, el uso de la **Unidad de Administración de Memoria (MMU)**, y el manejo de excepciones para responder adecuadamente a eventos no deseados.

---

## Modos de ejecución y niveles de privilegio

En ARM64, el procesador puede ejecutar en diferentes **niveles de privilegio**, que determinan qué recursos y áreas del sistema puede acceder el código en ejecución. Estos niveles de ejecución permiten aislar procesos críticos y proteger el sistema operativo del código de usuario.

### Principales niveles de ejecución:

1. **EL0 (User mode)**:
   - Nivel de menor privilegio, utilizado por aplicaciones de usuario. No tiene acceso directo al hardware ni a funciones críticas del sistema.

2. **EL1 (Kernel mode)**:
   - Nivel de mayor privilegio, donde se ejecuta el sistema operativo y puede acceder al hardware directamente. EL1 puede controlar la MMU y manejar excepciones.

3. **EL2 (Hypervisor mode)**:
   - Nivel de privilegio para **virtualización**. Permite que un hipervisor controle múltiples sistemas operativos virtualizados.

4. **EL3 (Secure monitor mode)**:
   - Nivel de mayor privilegio utilizado para gestionar funciones de seguridad y transiciones entre los mundos seguro y no seguro en sistemas con **TrustZone**.

### Cambios entre niveles de ejecución

El procesador puede cambiar entre niveles de ejecución según el tipo de tarea que esté realizando. Por ejemplo, una aplicación de usuario en EL0 puede hacer una **llamada al sistema (syscall)**, lo que eleva temporalmente el nivel de privilegio a EL1 para ejecutar código del kernel.

---

## Manejo de excepciones avanzadas

Las **excepciones** en ARM64 son eventos que interrumpen la ejecución normal del código y requieren atención inmediata, como errores de hardware, intentos de acceso no autorizado, o errores del sistema. La arquitectura ARM64 proporciona mecanismos avanzados para manejar estas excepciones de manera eficiente.

### Tipos comunes de excepciones:

1. **Excepciones síncronas**:
   - Son generadas por eventos predecibles, como una división por cero o acceso a memoria no válida.
   
2. **Interrupciones de hardware (IRQ)**:
   - Ocurren cuando un dispositivo de hardware solicita atención, como un temporizador o un controlador de red.

3. **Abortos**:
   - Son errores graves, como un fallo de acceso a memoria o intentos de ejecución de código en áreas restringidas.

4. **Excepciones de sistema**:
   - Incluyen llamadas al sistema o errores de alineación de memoria.

### Control de excepciones:

El sistema operativo, que opera en EL1, se encarga de manejar estas excepciones. El manejo adecuado implica:
- **Guardar el contexto** de la tarea actual.
- **Ejecutar el manejador de excepciones**.
- **Restaurar el contexto** para que el programa pueda continuar.

```assembly
// Ejemplo de un manejador de excepción simple
.manejador_excepcion:
    // Guardar el contexto
    stp x0, x1, [sp, #-16]!
    // Procesar la excepción
    // ...
    // Restaurar el contexto
    ldp x0, x1, [sp], #16
    eret                       // Regresar al flujo de ejecución normal
```

---

## Protección de memoria y uso de la MMU

La **Unidad de Administración de Memoria (MMU)** en ARM64 es responsable de traducir direcciones virtuales a direcciones físicas y aplicar restricciones de acceso. Esto permite implementar **protección de memoria**, asegurando que un proceso no acceda a memoria que no le pertenece y evitando así que errores o ataques comprometan la seguridad del sistema.

### Características clave de la MMU:

1. **Traducción de direcciones**: La MMU traduce las direcciones virtuales de los procesos en direcciones físicas reales, asegurando que cada proceso tenga su propio espacio de direcciones aislado.
   
2. **Protección de memoria**: La MMU puede restringir el acceso a regiones de memoria específicas según el nivel de ejecución, asegurando que solo el kernel o ciertos procesos puedan acceder a áreas críticas.

3. **Memoria caché y coherencia**: La MMU también juega un papel en la administración de caché, garantizando que las operaciones de memoria sean coherentes en todos los niveles del sistema.

### Ejemplo de configuración de la MMU:

```assembly
// Configurar una tabla de páginas simple
.section .data
    pagetable: .word 0x00000003    // Configuración de acceso y traducción

.section .text
.global _start

_start:
    ldr x0, =pagetable          // Cargar la dirección de la tabla de páginas
    msr TTBR0_EL1, x0           // Cargar la tabla de páginas en el registro de la MMU
    isb                         // Sincronizar la instrucción
    msr SCTLR_EL1, #0x1         // Activar la MMU
```

---

## Mitigación de vulnerabilidades de hardware

En los últimos años, se han descubierto varias vulnerabilidades de hardware que afectan a procesadores modernos, como **Spectre** y **Meltdown**, que aprovechan la ejecución especulativa para acceder a información sensible. ARM64 incluye técnicas para mitigar estos ataques y proteger los sistemas contra posibles exploits.

### Técnicas de mitigación:

1. **Desactivación de ejecución especulativa**: Aunque la ejecución especulativa mejora el rendimiento, en algunos casos puede desactivarse o limitarse para evitar que datos sensibles se filtren.

2. **Uso de barreras de memoria**: Las barreras de memoria aseguran que las operaciones de lectura/escritura en la memoria ocurran en el orden correcto, evitando problemas de sincronización y acceso inseguro a datos.

3. **Actualizaciones de firmware**: Los fabricantes de hardware, incluido ARM, han lanzado actualizaciones de firmware que mitigan estas vulnerabilidades en los procesadores ARM64.

```assembly
// Usar una barrera de memoria para evitar acceso especulativo
dsb sy           // Barrera de sincronización completa
isb              // Barrera de sincronización de instrucciones
```

---

## Ejercicios prácticos

### Ejercicio 1: Manejo de excepciones de memoria

Escribe un programa que intente acceder a una dirección de memoria no válida, provocando una excepción. El manejador de excepciones debe capturar el error y realizar una syscall para salir del programa.

#### Solución en ensamblador:

```assembly
.section .text
.global _start

_start:
    ldr x0, =0xDEADBEEF    // Intentar acceder a una dirección no válida
    ldr x1, [x0]           // Provocar una excepción
    b fin

.manejador_excepcion:
    mov x0, #1             // Código de error
    mov x8, #93            // Syscall para salir
    svc #0                 // Ejecutar la syscall

fin:
    b fin
```

### Ejercicio 2: Configuración básica de la MMU

Escribe un programa que configure la MMU con una tabla de páginas simple y active la protección de memoria.

#### Solución en ensamblador:

```assembly
.section .data
    pagetable: .word 0x00000003    // Tabla de páginas con permisos básicos

.section .text
.global _start

_start:
    ldr x0, =pagetable             // Cargar la tabla de páginas
    msr TTBR0_EL1, x0              // Configurar la MMU
    isb                            // Sincronizar
    msr SCTLR_EL1, #0x1            // Activar la MMU

    // Intentar acceder a una dirección protegida
    ldr x1, [x0]                   // Este acceso debería ser válido
    b fin

fin:
    b fin
```

---

## Resumen

En este capítulo, exploramos las características avanzadas de **seguridad** y **manejo de excepciones** en ARM64. Estas técnicas son esenciales para proteger el sistema contra vulnerabilidades y errores, garantizando un entorno de ejecución seguro y estable, especialmente en sistemas embebidos como el
