# Linker Scripts para Microcontroladores: ARM Mapa de Memoria

- **Número de Control:** 23211980
- **Apellido:** Guzmán Ochoa

### Introducción

Cuando se programa en un lenguaje de programación cómo C al compilar el código se convierte a instrucciones en código máquina que contiene direcciones de memoria relativas, las cuales no son un problema en un sistema operativo común ya que el kernel y MMU (Memory Management Unit) del sistema operativo se encargan de utilizar esas direcciones de memoria relativas dentro de un espacio virtual de memoria que se le asigna a la ejecución del programa, sin embargo, cuando se usa un microcontrolador que no cuenta con estos sistemas para resolver direcciones relativas de memoria el programa sera imposible de ejecutarse ya que las instrucciones en código maquina harán referencia a direcciones de memoria que pueda que no existan.
Para resolver esto se creo el sistema linker que con el uso de un linker script se encarga de traducir estas direcciones de memoria lógicas a direcciones de memoria físicas.
El propósito de esta investigación es mostrar el funcionamiento y creación de estos linker scripts que permiten el funcionamiento de código máquina con direcciones de memoria relativas en un sistema que únicamente opera con direcciones de memoria físicas.

### Desarrollo

### Conclusiones

### Bibliografía
