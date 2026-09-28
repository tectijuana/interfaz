### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "Explica qué es el ensamblador en línea de GCC y cuál es la estructura de `asm` extendido."
  - "¿Qué significan las restricciones `r`, `m`, `i`, `g`, `+` y `=` en el ensamblador en línea de GCC?"
  - "Explica qué son los clobbers en GCC y para qué sirven `cc` y `memory`."
  - "¿Cuál es la diferencia entre `asm` y `asm volatile` en GCC?"
  - "Dame buenas prácticas y errores frecuentes al utilizar ensamblador en línea de GCC."

- **Herramientas utilizadas**:
  - ChatGPT
  - Documentación oficial de GCC
  - Compilador GCC para realizar pruebas de los ejemplos

- **Cambios y validación**:
  - Revisé y adapté los ejemplos de ensamblador para que utilizaran correctamente las restricciones de entrada y salida.
  - Verifiqué el uso de restricciones como `r`, `m`, `i`, `=r` y `+r`.
  - Revisé que los clobbers, especialmente `cc` y `memory`, fueran utilizados de acuerdo con los efectos reales de las instrucciones.
  - Comprobé que los ejemplos fueran coherentes con la sintaxis de ensamblador extendido de GCC.
  - Contrasté la información proporcionada por la IA con la documentación oficial de GCC antes de incorporarla al trabajo.

- **Reflexión personal**:
  La inteligencia artificial me ayudó a comprender conceptos que pueden resultar difíciles al principio, especialmente la relación entre las restricciones, los operandos y los clobbers. También me permitió obtener ejemplos sencillos para observar cómo GCC comunica al compilador qué valores entran, cuáles salen y qué recursos pueden modificarse. Sin embargo, comprendí que las respuestas generadas por IA deben ser verificadas, ya que un ejemplo aparentemente correcto puede contener errores de sintaxis o explicar de forma incorrecta el comportamiento del compilador. Por esta razón, considero importante complementar la información de la IA con la documentación oficial de GCC y realizar pruebas de compilación.

- **Fecha**: 2026-09-12
- **Plataforma utilizada**: PC local con GCC para compilar y verificar los ejemplos
