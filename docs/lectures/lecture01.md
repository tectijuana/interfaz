# Introducción al Ensamblador con Raspberry Pi 5

## Contenidos
1. [Características generales de la arquitectura ARM](#características-generales-de-la-arquitectura-arm)
2. [El lenguaje ensamblador](#el-lenguaje-ensamblador)
3. [El entorno de desarrollo](#el-entorno-de-desarrollo)
4. [Configuración del entorno en casa](#configuración-del-entorno-en-casa)
5. [Aspecto de un programa en ensamblador](#aspecto-de-un-programa-en-ensamblador)
6. [Cómo ensamblar y enlazar un programa](#cómo-ensamblar-y-enlazar-un-programa)

---

## Características generales de la arquitectura ARM

La **Raspberry Pi 5** incorpora el procesador **ARM Cortex-A76**, que forma parte de la arquitectura **ARMv8-A**. Este procesador es de 64 bits, lo que ofrece una mejora significativa en rendimiento y eficiencia energética respecto a versiones anteriores como la Raspberry Pi 4 (basada en Cortex-A72). La Raspberry Pi 5 es capaz de manejar múltiples núcleos con alto rendimiento, lo que permite ejecutar aplicaciones más complejas.

- **Arquitectura ARMv8-A**: Mixta, compatible con instrucciones de 32 y 64 bits.
- **Procesador ARM Cortex-A76**: Mayor capacidad de procesamiento y eficiencia energética.
- **Soporte de periféricos avanzados**: Conexiones PCIe, USB 3.0, y soporte para más RAM que permite realizar tareas más complejas.

> **Nota**: ARM es una arquitectura RISC (Reduced Instruction Set Computer), optimizada para ejecutar instrucciones simples y rápidas, lo que la hace ideal para dispositivos móviles y embebidos como la Raspberry Pi.

---

## El lenguaje ensamblador

El ensamblador es un lenguaje de bajo nivel que permite un control directo del hardware. En este caso, se utilizará el conjunto de instrucciones **A64**, que es la versión de 64 bits del ARMv8-A.

### Ventajas del lenguaje ensamblador:
1. **Control total del hardware**: Permite acceso directo a los registros y la memoria.
2. **Optimización**: Es posible escribir código extremadamente eficiente.
3. **Flexibilidad**: Puedes escribir rutinas específicas que no se pueden implementar de manera eficiente en lenguajes de alto nivel.

### Desventajas:
1. **Complejidad**: Requiere muchas líneas de código para operaciones sencillas.
2. **Mantenimiento difícil**: El código es menos legible y más difícil de depurar.

---

## El entorno de desarrollo

Para escribir, ensamblar y ejecutar programas en ensamblador en la **Raspberry Pi 5**, utilizamos el siguiente flujo de trabajo:

1. **Escribir el código** en un editor de texto como `nano` o `vim`.
2. **Ensamblar el código** usando el comando `as` (GNU Assembler).
3. **Enlazar el archivo objeto** usando el comando `ld` (GNU Linker).
4. **Ejecutar el programa** directamente en la Raspberry Pi o mediante `qemu` (emulador si trabajas en otro sistema operativo).

### Herramientas principales:
- **GNU Assembler (as)**: Convierte el código ensamblador a código máquina.
- **GNU Linker (ld)**: Enlaza archivos objeto para crear ejecutables.
- **GNU Debugger (gdb)**: Depura programas en ensamblador.
- **Extensión para GNU Debugger (GEF)**: Depura de manera interactiva visualizando registros, pila, descompilacion y otros elementos via GEF 

---

## Configuración del entorno

### Instalación del sistema operativo (Raspberry Pi OS):
1. Descarga la última versión de **Raspberry Pi OS** desde [la página oficial](https://www.raspberrypi.org/software/operating-systems/).
2. Usa la herramienta **Raspberry Pi Imager** o **balenaEtcher** para grabar la imagen en una tarjeta SD.
3. Inserta la tarjeta SD en la Raspberry Pi 5 y arranca el sistema.
4. Darse de alta en RPI Connect via https://www.raspberrypi.com/software/connect/, aplicando las librerias de enlace remoto,

### Conexión remota:
- Usa **SSH** para acceder a tu Raspberry Pi 5 desde otro equipo. Si no tienes teclado o monitor, habilita `ssh` en la tarjeta SD añadiendo un archivo vacío llamado `ssh` en la partición de arranque.
- Conéctate con el comando:
  ```bash
  ssh pi@<raspberry_pi_ip> ```


NOTA: En visual Studio Code, es posible agregar la libreria de SSH para conectarse remotamente.
