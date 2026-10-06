# Registro de Asistencia de IA y Metodología de Trabajo

### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "Actúa como un experto en arquitectura de computadores y sistemas embebidos. Necesito que elabores una "Guía práctica para portar una rutina en ensamblador de ARM (AArch64 / ARMv8) a RISC-V (RV64I)". 

La guía debe estar enfocada en desarrolladores y cubrir los siguientes apartados estructurados:

1. Mapeo de Registros:
   - Tabla comparativa de los registros de propósito general entre ARM64 (X0-X30, SP, ZR) y RISC-V (x0-x31, nombres ABI como a0-a7, t0-t6, s0-s11, sp, ra).
   - Equivalencias en el uso para paso de argumentos, valores de retorno, registros guardados por el llamador (caller-saved) y por el llamado (callee-saved).

2. Mapeo de Instrucciones Comunes:
   - Tabla con instrucciones equivalentes para operaciones aritmético-lógicas, carga/almacenamiento de memoria, y saltos/control de flujo (ej. MOV, LDR/STR vs LW/SW, B/BL vs J/JAL/BRANCHES).
   - Explicación de cómo RISC-V maneja el registro cero (x0) frente al registro ZR de ARM.

3. Manejo de Memoria y Modos de Direccionamiento:
   - Diferencias principales entre los modos de direccionamiento de ARM (como pre/post-incremento) y el modelo simplificado de RISC-V (registro + offset).
   - Cómo traducir patrones de carga/almacenamiento complejos de ARM a secuencias equivalentes en RISC-V.

4. Convención de Llamadas (Calling Conventions) y Pila:
   - Diferencias en la alineación del Stack Pointer (SP).
   - Estructura del Prólogo y Epílogo de una función en ambas arquitecturas.

5. Ejemplo Práctico de Portabilidad (Paso a Paso):
   - Muestra una rutina corta y real en ARM64 (por ejemplo, una función para calcular la suma de un arreglo de enteros o encontrar el valor máximo).
   - Muestra la rutina equivalente traducida a RISC-V (RV64I).
   - Explica línea por línea las decisiones de traducción tomadas.

6. Trampas Comunes y Consideraciones de Optimización:
   - Lista de errores frecuentes al portar (como asumir incrementos automáticos en registros o banderas de condición como en ARM32/ARM64).
   - Consejos para optimizar la rutina resultante en RISC-V."
  - "Entrega toda la parte de ejemplo práctico de portabilidad formateada directamente como código Markdown listo para producción."
  - "lo mismo para todo lo que sea código."

- **Herramientas utilizadas**:
  -  Gemini
- **Cambios y validación**:
  Ajusté ligeramente la complejidad del ejemplo práctico para mantenerlo breve y claro.
  - Corregí algunas faltas de ortografía y detalles menores de formato en las tablas de Markdown.

- **Reflexión personal**:
  La herramienta de IA simplificó la organización de la información y aceleró la estructuración de la guía técnica, permitiéndome enfocarme en revisar la claridad del contenido.

- **Fecha**: 2026-09-19
