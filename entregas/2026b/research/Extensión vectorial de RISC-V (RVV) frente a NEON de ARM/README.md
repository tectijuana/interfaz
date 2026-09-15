# Extensión vectorial de RISC-V (RVV) frente a NEON de ARM
## Introducción
Las arquitecturas que constituyen a los procesadores cumplen múltiples funciones que la mayoría de gente pasa por alto, es que son necesarias para formar las reglas y métodos que una computadora utilizará para almacenar información, mostrar imágenes en una pantalla e interactuar con el usuario; desde sus inicios más primitivos con tarjetas perforadas hasta la actualidad que han llegado a avances como la ejecución de LLMs, los procesadores han logrado esto gracias a sus complejas arquitecturas que les dan forma.
## Desarrollo Técnico
### RISC-V
RISC-V es una arquitectura de conjunto de instrucciones de código abierto que se utiliza para desarrollar procesadores personalizados para una variedad de aplicaciones, desde diseños integrados hasta supercomputadoras. Es una arquitectura de conjunto de instrucciones (ISA) de código abierto desarrollada originalmente en la Universidad de California, Berkeley, utilizada para el desarrollo de procesadores personalizados destinados a diversas aplicaciones.
La arquitectura RISC-V, cuenta con un pequeño conjunto básico de instrucciones sobre el que se ejecuta todo el software del diseño. Sus extensiones opcionales permiten a los diseñadores adaptar la arquitectura a diversos mercados. En esencia, la arquitectura RISC-V permite personalizar y construir el procesador según las aplicaciones objetivo, optimizando así el consumo de energía, el rendimiento y el área (PPA) . Además, la arquitectura RISC-V ofrece la flexibilidad de seleccionar las funciones disponibles, en lugar de tener que utilizar todas.
#### Sus ventajas son:
| Ventaja | Descripción |
|---------|-------------|
| Estándar abierto | Permite la colaboración y la innovación en toda la industria sin restricciones de licencia. |
| ISA común | Simplifica el desarrollo de software; la misma arquitectura de conjunto de instrucciones (ISA) base se puede utilizar en diferentes dispositivos (desde sistemas embebidos hasta computación de alto rendimiento). |
| Eficiencia energética | Los diseños modulares y de menor tamaño permiten implementaciones energéticamente eficientes. |
| Personalización | Los diseñadores pueden elegir extensiones opcionales y agregar instrucciones personalizadas. |
| Seguridad | El escrutinio del código abierto, los diseños de referencia disponibles y las extensiones de seguridad mejoran la confianza. |
#### ¿Sus aplicaciones?
* Dispositivos portátiles, aplicaciones industriales, IoT y electrodomésticos.  
* Smartphones. 
* Automoción.  
* Sector aeroespacial y gubernamental. 

### Arm NEON
Arm Neon es una extensión de arquitectura de tipo SIMD, osea una extensión avanzada de una sola instrucción y múltiples datos para las series Arm Cortex-A y Arm Cortex-R de procesadores con funciones especialmente pensadas para dispositivos móviles, tales como codificación y decodificación multimedia, interfaces de usuario, gráficos 2D/3D y gaming.
Neon también puede acelerar algoritmos de procesamiento de señales y funciones para acelerar aplicaciones como el procesamiento de audio y vídeo, reconocimiento facial y de voz, visión artificial y machine learning.
 
Las instrucciones en Neon permiten hasta:
* Operaciones de enteros 16x8-bit, 8x16-bit, 4x32-bit, 2x64-bit 
* Operaciones de flotantes 8x16-bit, 4x32-bit, 2x64-bit
#### Ventajas
| Ventaja | Descripción |
|---------|-------------|
| Soporte para múltiples tipos de datos | La tecnología Neon es una arquitectura empaquetada SIMD con soporte para múltiples tipos de datos. También soporta múltiples instrucciones en paralelo. |
| Flexible | Neon puede ser utilizado en múltiples formas, incluyendo librerías compatibles con Neon, auto-vectorización en el compilador, intrínsecos, y código de ensamblador. |
| Ecosistema establecido | Un amplio rango de codecs y módulos DSP están disponibles de parte de patrocinadores de Arm en el ecosistema Neon. |
| Disponible en librerías de código abierto | Una de las formas más fáciles de tomar ventaja de Neon es con una librería de código abierto que lo soporta. |

### ¿La diferencia?
ARM utiliza una arquitectura de conjunto de instrucciones (ISA) fija. Un procesador Arm viene con un extenso conjunto de instrucciones predefinidas. Incluso si el desarrollo de su BSP integrado solo requiere el 10 % de esos comandos, el 90 % restante sigue presente, ocupando espacio y aumentando la complejidad. No es posible añadir ni eliminar nada.
Mientras tanto RISC-V es modular. Comienza con una base mínima y obligatoria (solo unas 47 instrucciones). A partir de ahí, solo se añaden las extensiones necesarias, como funciones matemáticas, operaciones atómicas o instrucciones comprimidas. Esto permite que el chip sea compacto, eficiente en consumo de energía y con el tamaño perfecto para cada tarea específica.

## Conclusión
El tipo de extensión de video que se utilice entonces dependerá de cuál es el propósito al que se quiere llegar, aunque Arm por si mismo ya tiene un nombre de prestigio en la escena del gaming, Neon tiene un uso más amplio en el área móvil, por ejemplo con las series Arm Cortex-A, o en los sectores de salud con el Arm Cortex-R debido a su baja latencia para el equipo medico; además los productos Arm tienden a ser propietarios. Sin embargo RISC-V aunque puede ser un nombre no muy familiar, al ser una arquitectura de código abierto y además más flexible de implementar por ser un estándar open-source, esto lo ha puesto por encima de otras arquitecturas en el medio. Tiene un amplio uso con sistemas en el kernel Linux, casi de forma exclusiva.

## Bibliografía 
* Synopsys, «What is RISC-V?», Synopsys, 11 de septiembre de 2025. https://www.synopsys.com/glossary/what-is-risc-v.html
* Arm Ltd., «Arm Neon», Arm. https://www.arm.com/technologies/neon
* «RISC-V vs ARM: Which is Better for Embedded Application?», ByteLogic. https://www.ebytelogic.com/blogs/risc-v-vs-arm
