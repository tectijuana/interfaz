# Revisión de sistemas de depuración JTAG y SWD

---

**Nolasco Vazquez Jose Antonio - 22210326**  
**Docente:** Rene Solis Reyes  
**Materia:** Lenguajes de interfaz  

---

## Introducción al tema

En el desarrollo y mantenimiento de sistemas embebidos, la depuración eficiente del hardware y software es fundamental para garantizar la funcionalidad y calidad del producto final. Los sistemas de depuración JTAG (Joint Test Action Group) y SWD (Serial Wire Debug) son dos protocolos ampliamente utilizados para interactuar con microcontroladores y otros dispositivos integrados. Estos protocolos permiten realizar tareas de programación, verificación, pruebas y diagnóstico de fallas en tiempo real. En esta revisión se analizarán las características técnicas, ventajas, aplicaciones y diferencias entre ambos sistemas de depuración.

## Desarrollo técnico

### JTAG (Joint Test Action Group)

El protocolo JTAG fue desarrollado inicialmente para la prueba de placas de circuitos impresos (PCB) y está estandarizado bajo la norma IEEE 1149.1. Se basa en una interfaz serial de cuatro o cinco señales principales: TCK (clock), TMS (modo), TDI (entrada de datos) y TDO (salida de datos), y en algunos casos una señal adicional de reset o power.

JTAG permite acceder internamente a los registros y la memoria del dispositivo, así como a sus cadenas de prueba (scan chains), facilitando el diagnóstico de fallos de hardware, la programación del dispositivo y la depuración de software embebido. La cadena JTAG puede conectar varios dispositivos en una misma línea, permitiendo la prueba en cadena (boundary scan), lo que resulta útil en sistemas con múltiples componentes.

Entre las principales ventajas del JTAG está su estandarización y amplia adopción en la industria, lo que garantiza compatibilidad con muchos dispositivos y herramientas. Sin embargo, debido a la cantidad de pines que requiere y la complejidad de la implementación, puede ser poco práctico en aplicaciones donde el espacio o la cantidad de pines disponibles es limitada.

### SWD (Serial Wire Debug)

El protocolo SWD es un protocolo de depuración desarrollado por ARM como una alternativa a JTAG para microcontroladores Cortex-M. SWD utiliza una interfaz serial de dos hilos: SWDIO (datos bidireccionales) y SWCLK (clock). Esta reducción en la cantidad de pines facilita su integración en dispositivos con limitaciones físicas o en diseños compactos.

A nivel funcional, SWD ofrece características similares a JTAG, como la programación y depuración en tiempo real, acceso a registros internos y memoria. Sin embargo, su implementación más sencilla y eficiente lo ha hecho popular especialmente en dispositivos embebidos modernos.

SWD soporta una mayor velocidad de transferencia de datos debido a su protocolo optimizado y permite una depuración más rápida y con menos interferencia en el funcionamiento del dispositivo. Además, la mayoría de los microcontroladores ARM Cortex-M modernos ofrecen soporte nativo para SWD, consolidando su posición en el mercado.

### Comparación y aplicaciones

Mientras JTAG es un estándar más general y extendido para una amplia gama de dispositivos y aplicaciones, SWD está más enfocado en microcontroladores de bajo consumo y sistemas embebidos donde la minimización de pines y espacio es crítica.

En sistemas complejos con múltiples dispositivos, JTAG permite encadenar y depurar varios componentes simultáneamente. En contraste, SWD es más adecuado para aplicaciones donde solo se requiere la depuración de un único microcontrolador o componente.

Ambos protocolos son soportados por herramientas de desarrollo comunes, como depuradores físicos y entornos de programación, pero la elección entre uno u otro dependerá del dispositivo y los requisitos del proyecto.

## Conclusiones

Los sistemas de depuración JTAG y SWD son herramientas esenciales en el desarrollo de sistemas embebidos, cada uno con sus ventajas y limitaciones. JTAG ofrece una solución robusta, estándar y flexible, ideal para sistemas con múltiples componentes y pruebas de hardware complejas. Por otro lado, SWD presenta una alternativa más eficiente y compacta para la depuración de microcontroladores modernos, especialmente en aplicaciones con restricciones físicas.

La elección entre JTAG y SWD debe basarse en las necesidades específicas del proyecto, la compatibilidad con los dispositivos y el entorno de desarrollo. En la actualidad, SWD está ganando terreno debido a la proliferación de microcontroladores ARM Cortex-M, pero JTAG sigue siendo fundamental en muchos sectores industriales y electrónicos.

## Bibliografía

1. IEEE Standard for Test Access Port and Boundary-Scan Architecture, IEEE Std 1149.1-2013, 2013.

2. ARM Limited, *ARM Debug Interface v5 Architecture Specification*, 2014. [Online]. Available: https://developer.arm.com/documentation/ddi0314/latest

3. P. A. Lewis and D. J. Austin, "An introduction to the ARM Serial Wire Debug Interface," *Embedded Systems Conference*, 2016.

4. M. Keil, *Embedded Systems: Introduction to Arm® Cortex™-M Microcontrollers*, 3rd ed., Wiley, 2020.
