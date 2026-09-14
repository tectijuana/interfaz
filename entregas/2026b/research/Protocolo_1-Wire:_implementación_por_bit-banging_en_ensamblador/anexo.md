### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "Explícame de forma técnica cómo funciona 1-Wire, sus tiempos, el uso de GPIO y cómo se relaciona con ARM y ensamblador."
  - "¿Qué registros debe preservar una función en el ABI de AArch64 y por qué x19–x28 son callee-saved?"
  - "Explica la diferencia entre ldr x1, =msg y adr x1, msg en GNU as."
  - "Explica qué es el protocolo 1-Wire y cómo funciona mediante bit-banging."
  - "Explica la topología open-drain del protocolo 1-Wire y cómo se controla mediante un GPIO."
  - "Explica cómo se implementa 1-Wire en ensamblador ARM mediante registros GPIO, retardos y ciclos de reloj."
  - "Explica los tiempos de Reset, Presence Pulse, Write 0, Write 1 y Read Slot del protocolo 1-Wire."
  - "Explica cómo calcular los ciclos de reloj necesarios para generar retardos en un procesador Cortex-M de 16 MHz."
  - "Explica el uso de CPSID, CPSIE, DSB e ISB en una implementación de bit-banging."
  - "Explica cómo se utiliza el sensor DS18B20 mediante el protocolo 1-Wire y los comandos 0xCC y 0x44."
  - "Ayúdame a adaptar mi investigación al formato de un archivo Markdown para GitHub, organizando la información con títulos, subtítulos, tablas, listas, bloques de código y diagramas de texto cuando sean necesarios, sin agregar información que no esté en mi investigación."

- **Herramientas utilizadas**:
  - ChatGPT
  - Gemini

- **Cambios y validación**:
  - La información generada por la IA fue organizada y adaptada al formato Markdown utilizado para el documento.
  - Se revisaron los conceptos relacionados con la comunicación 1-Wire, la configuración open-drain, los registros GPIO, los retardos y las instrucciones de ensamblador ARM.
  - Los datos técnicos se contrastaron con el material bibliográfico utilizado en la investigación, principalmente las aplicaciones de Maxim Integrated y la documentación de ARM.
  - Se mantuvieron únicamente los conceptos y datos técnicos respaldados por el material recopilado.

- **Reflexión personal**:
La IA me ayudó a entender mejor y organizar la información de la investigación. También me ayudó a explicar temas como el funcionamiento del bus open-drain, los ciclos de reloj, los time slots y las instrucciones de ensamblador ARM. Aun así, fue necesario revisar la información en las fuentes bibliográficas para comprobar que los datos técnicos y los tiempos del protocolo fueran correctos.

- **Fecha**: 2026-09-13
- **Plataforma utilizada**: GitHub 
