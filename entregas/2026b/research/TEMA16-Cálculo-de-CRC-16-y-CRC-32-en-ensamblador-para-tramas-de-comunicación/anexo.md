# Bitácora de Uso de Modelos de Lenguaje (LLM)

## Prompts Reales y Resultados Obtenidos

### Prompt 1: Generación del esquema matemático y código assembly
* **Prompt planteado:** *"Escribe un fragmento de código optimizado en ensamblador x86-64 (sintaxis NASM) para calcular el CRC-32 de un búfer de datos utilizando una tabla de búsqueda (LUT). Incluye comentarios explicativos en cada instrucción y usa la convención de llamada de System V."*
* **Resultado obtenido:** La IA proporcionó una rutina completa con la sintaxis correcta de NASM, haciendo un uso adecuado de la instrucción `movzx` para el índice y la escala `[rdx + r8*4]`. El valor inicial e inversión final del CRC mediante `not eax` se implementaron correctamente conforme al estándar IEEE 802.3.

### Prompt 2: Optimización de registros y eliminación de cuellos de botella
* **Prompt planteado:** *"En el código ensamblador de CRC-16 bit a bit generado previamente, ¿cómo puedo eliminar las instrucciones de salto dentro del bucle de 8 bits para evitar fallos en el predictor de saltos (branch misprediction)?"*
* **Resultado obtenido:** El LLM sugirió el uso de instrucciones de movimiento condicional (`cmovnz`) o el cálculo directo mediante máscaras aritmético-lógicas (`sar` / `and`). Se optó por la solución basada en máscaras lógicas para mantener la compatibilidad con microcontroladores simples que no soportan condicionales complejas.

## Reflexión Crítica

### ¿Ayudó la herramienta?
El uso de la herramienta aceleró significativamente el desarrollo de las plantillas en lenguaje ensamblador y la verificación de las constantes polinómicas. Además, simplificó la redacción matemática en formato LaTeX y la estructuración del documento técnico conforme a los estándares académicos.

### ¿Hubo sesgos o errores?
* **Confusión de endianeidad (*Endianness*) y reflejo:** En una versión preliminar, la IA mezcló el polinomio de CRC-32 normal (`0x04C11DB7`) con una rutina de desplazamiento hacia la derecha (*LSB first*), lo cual produce resultados incorrectos. Fue necesario corregir el prompt especificando explícitamente el uso de polinomios reflejados (`0xEDB88320`).
* **Sintaxis de ensamblador:** El modelo intercaló ocasionalmente sintaxis AT&T con sintaxis Intel/NASM (por ejemplo, omitiendo corchetes `[]` en los desreferenciamientos de memoria). Se requirió revisión humana directa para unificar el código en sintaxis NASM pura.
