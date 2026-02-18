# ARM64 ABI y registros: diseño para alto desempeño
*Por: Camacho Otañez Juan Pablo*

Mientras otras empresas como Qualcomm e Intel apostaban a computadoras conectadas a la corriente, procesadores grandes, potentes y complejos, **ARM** se enfocaba en la elegancia.

 ARM no buscaba complejidad, buscaba **rapidez y eficiencia energética**, no quería que sus chips hicieran muchas cosas, quería que las que hiciera las hiciera extremadamente eficientes y rápidas, gracias a esto se posicionó como el estándar en los teléfonos de 32 bits, sin embargo, debido al límite inherente de direccionamiento de 32 bits (≈4 GB de RAM) su uso era limitado. No fue hasta que en 2011 se presenta la arquitectura **ARMv8-A** (modo de 64 bits) esto eliminó el techo que lo había limitado por varios años, más que una mejora, fue un rediseño total. Este rediseño también redefinió el modelo de registros y el ABI, sentando las bases del alto desempeño de ARM64.

Dos años después en 2013 Apple lanza el iPhone 5S con un chip que lo cambiaría todo, el A7 basado en **ARM64**, esto obligó a todo el ecosistema Android a pasar a 64 bits aceleradamente, puesto que este mostraba un rendimiento excepcional en comparación con otros chips de la época. Esto demostró que **ARM64 no solamente era viable, sino altamente competitivo.**

Posteriormente comenzó a adoptarse por grandes compañías como AWS en sus chips para sus servicios, esto hizo que el mundo volteara a ver a ARM más allá de solo uso celular pero no fue hasta 2020 que Apple presento el chip M1 (basado en ARM64) para sus MacBooks, el cual rompió con la idea de que solo era para celulares, sino que además rompió el mito de que para tener potencia se necesitaban ventiladores y calor.

Pero a todo esto, **¿Qué es ARM y que lo hace tan especial?**

## ¿Qué es ARM?
Antes de explicar ARM, primero debemos tener una idea de que es **RISC** ya que ARM se basa en este.
### RISC 
 Un **Ordenador de Conjunto Reducido de Instrucciones** (Reduced Instruction Set Computer, **RISC**) es un tipo de arquitectura de microprocesador que utiliza un conjunto pequeño y altamente optimizado de instrucciones, en lugar del conjunto altamente especializado que normalmente se encuentra en otras arquitecturas. RISC es una alternativa a la arquitectura de Computación por Conjuntos de Instrucciones Complejas (CISC) y a menudo se considera la tecnología de arquitectura de CPU más eficiente disponible hoy en día.
<img width="1024" height="1024" alt="Gemini_Generated_Image_k9ky26k9ky26k9ky" src="https://github.com/user-attachments/assets/583b338d-1ecd-4f8f-b89f-094a65ffff4e" />


Con RISC, una unidad central de procesamiento (CPU) implementa el principio de diseño del procesador de instrucciones simplificadas que pueden hacer menos pero ejecutarse más rápidamente. El resultado es una mejora en el rendimiento. Una característica clave de RISC es que permite a los desarrolladores aumentar el conjunto de registros y el paralelismo interno incrementando el número de hilos paralelos ejecutados por la CPU y aumentando la velocidad de las instrucciones de ejecución de la CPU.



### ARM

La arquitectura de ARM es un conjunto de **ISAs** basadas en una arquitectura de computación con conjunto reducido de instrucciones (**RISC**) que define cómo los procesadores Arm ejecutan instrucciones e interactúan con el software. 
-   La arquitectura de la CPU (ISA) define el conjunto básico de instrucciones, así como los modelos de excepción y memoria en los que se basa el sistema operativo y el hipervisor.
-   La microarquitectura de la CPU determina cómo una implementación cumple con el contrato arquitectónico definiendo el diseño del procesador y cubriendo aspectos como: potencia, rendimiento, área, longitud de la tubería y niveles de caché.

Dentro de ARM hay distintas versiones pero en la que nos enfocaremos es en ARM64 la cual es el ISA de 64 bits **AArch64**

#### ARM64 (AArch64)
AArch64 es el conjunto de ISAs para 64 bits de ARM el cual establece cómo el software se ejecuta sobre procesadores ARM modernos. Una de las decisiones de diseño más relevantes de ARM64 fue la ampliación y homogeneización de su banco de registros pasando de 16 a 32 (en realidad 31 solo son utilizables).
Para darnos una idea comparándolo con otros tipos de arquitectura.

| Arquitectura | Registros generales |
| ------------ | ------------------- |
| x86-32       | 8                   |
| x86-64       | 16                  |
| ARM32        | 16                  |
| **ARM64**    | **31**              |
>Un registro es una porción de memoria temporal rápida de un ordenador utilizada para almacenar y transferir datos e instrucciones empleadas por la CPU, este puede contener una dirección de almacenamiento, una instrucción o datos. 

Pero la magia de ARM64 no está en su cantidad de registros si no en su pulido **ABI**, 
el cual fue diseñado para explotar eficazmente un banco amplio de registros dentro de un ISA limpio.

### ABI de ARM64
La interfaz binaria de aplicación (**ABI**) es una interfaz de software de bajo nivel que separa la capa del sistema operativo de las aplicaciones y bibliotecas, que son gestionadas por el sistema operativo. Especifica cómo interactúan los módulos de programa tras la compilación, definiendo detalles como tipos de datos de bajo nivel, alineación, convenciones de llamada y formatos ejecutables de programa. Y junto con el ISA trabajan en conjunto para conectar el hardware con el software de forma correcta, portable y eficiente.
En pocas palabras el ABI es un manual de cómo se debe de utilizar los registros y el formato de las comunicaciones con distintas partes del software.

 El ABI permite la portabilidad de aplicaciones y bibliotecas entre sistemas operativos que implementan la misma ABI, permitiendo la compatibilidad binaria sin necesidad de recompilar programas para diferentes sistemas.
 
El ABI define:

- La convención de llamadas.
- Uso de los registros.
- Organización de la pila.
- Representación de tipo de datos. 
- Formato de Binarios. 
- Interfaz con el sistema operativo.

*Ejemplo breve del **ABI** de **ARM64** enfocado en Windows*

- **Registro de enteros**

| Registro  | Volatilidad | Rol |
|----------|-------------|-----|
| x0–x8    | Volátil     | Registros de paso de parámetros y valores de retorno |
| x9–x15   | Volátil     | Registros temporales (caller-saved) |
| x16–x17  | Volátil     | Registros temporales usados en llamadas internas (intra-procedimiento) |
| x18      | N/D         | Registro reservado por la plataforma: en modo kernel apunta al KPCR del procesador actual; en modo usuario apunta al TEB |
| x19–x28  | No volátil  | Registros preservados (callee-saved) |
| x29 / fp | No volátil  | Puntero de marco (frame pointer) |
| x30 / lr | Ambos       | Registro de enlace (link register): la función callee debe preservar su propio valor de retorno, pero se sobrescribe el valor del llamador |



- **Registro de punto flotante/SIMD**

| Registro  | Volatilidad | Rol |
|----------|-------------|-----|
| v0–v7    | Volátil     | Registros de paso de parámetros y valores de retorno |
| v8–v15   | Ambos       | Los 64 bits bajos son no volátiles; los 64 bits altos son volátiles |
| v16–v31  | Volátil     | Registros temporales (caller-saved) |

- **Registros del sistema**

| Registro        | Rol |
|-----------------|-----|
| *TPIDR_EL0*       | Reservado |
| *TPIDRRO_EL0*     | Contiene el identificador (número) de CPU del procesador actual |
| *TPIDR_EL1*       | Apunta a la estructura KPCR del procesador actual |

- **Pila**
Siguiendo la ABI presentada por ARM, la pila debe permanecer siempre alineada a 16 bytes. AArch64 contiene una característica de hardware que genera errores de alineación de pila cuando el SP no tiene una alineación de 16 bytes y se realiza una carga o un almacén relativos a SP.
Las funciones que asignan un tamaño de 4k o más de la pila deben asegurarse de que cada página sea tocada en orden antes de llegar a la página final. Con esta acción se consigue que ningún código pueda “saltarse” las páginas de restricción que Windows usa para expandir la pila. Normalmente, el asistente de `__chkstk` realiza el toque, que tiene una convención de llamada personalizada que pasa la asignación de pila total dividida entre 16 en x15.

# Conclusión
ARM64 se ha convertido en el estándar de facto para el diseño de chips eficientes y escalables, desde dispositivos móviles hasta centros de datos, aunque x86 sigue dominando ciertos mercados tradicionales. 
Estas características mencionadas como lo son 31 registros, un ABI hecho desde cero y un ISA perfectamente pulido permiten que ARM64 alcance una mayor eficiencia tanto en la ejecución de código como en el consumo energético, en comparación con otras arquitecturas
A pesar de que X86 siga dominando ciertos mercados (especialmente el de PCs) la popularidad que ha ganado ARM64 nos hace creer que esta dominancia no durara mucho.  X86 se aferra puesto que fue el estándar por mucho tiempo por lo que migrar a ARM64 no es simplemente comenzar a utilizarla si no cambiar todo lo que estaba hecho para X86 y adecuarlo para que ARM64 pueda ejecutarlo.
En pocas palabras ARM64 no ha desplazado a x86 porque la ventaja técnica no supera aún el peso del legado, la compatibilidad binaria y la madurez del ecosistema x86

ARM64 es moderno y eficiente, pero X86 es estable y universal. ¿Pero esto se mantendrá así en el futuro?




---
---
## Referencias 

- [What is an ARM processor? – Assured Systems FAQ](https://www.assured-systems.com/es/faq/what-is-an-arm-processor/)
- [ARM architecture – ARM.com](https://www.arm.com/architecture/cpu)
- [RISC – ARM Glossary](https://www.arm.com/glossary/risc)
- [Application Binary Interface – ScienceDirect](https://www.sciencedirect.com/topics/computer-science/application-binary-interface)
- [Registers in Computer Architecture – CSTaleem](https://cstaleem.com/registers-in-computer-architecture)
- [ARM64 Windows ABI Conventions – Microsoft Learn](https://learn.microsoft.com/es-es/cpp/build/arm64-windows-abi-conventions?view=msvc-170)
- [ARM64 CPU Feature Registers – Kernel.org](https://www.kernel.org/doc/html/v5.8/arm64/cpu-feature-registers.html)
- [Old New Thing: Windows blog on ARM64 calling conventions – Microsoft DevBlogs](https://devblogs.microsoft.com/oldnewthing/20220726-00/?p=106898)

## Herramientas de IA utilizadas:
- NanoBanana Gemini Prompt "imagen de cics vs risc que simplemente represente la complejidad de uno y la simplicidad del otro"
- Chatgpt. Ordenar ideas y coherencia del texto.
