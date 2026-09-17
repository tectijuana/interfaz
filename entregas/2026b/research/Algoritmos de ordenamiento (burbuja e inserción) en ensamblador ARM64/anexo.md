### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "Realiza una investigacion del siguiente tema: Algoritmos de ordenamiento (burbuja e inserción) en ensamblador ARM64"
  - "hazlo todo en formato md"
  - "mejora el formato porfavor"

- **Herramientas utilizadas**:
  - Gemini (Google AI)

- **Cambios y validación**:
  - Se corrigió el problema de saltos de línea y formateo colapsado que generaba el editor web de GitHub al pegar texto con sintaxis Markdown y bloques de código ensamblador.
  - Se verificó que las instrucciones de carga y almacenamiento escalado (`ldr`/`str` con `lsl #2`) correspondieran con el direccionamiento de enteros de 32 bits (`int32_t`) en registros `W` sobre direcciones base de 64 bits (`X0`).
  - Se validó la lógica de las rutinas hoja (*leaf functions*) conforme a AAPCS64 para asegurar que no fuera necesario reservar espacio de pila para el *Frame Pointer* (`x29`) ni para el *Link Register* (`x30`) al no existir subllamadas.

- **Reflexión personal**:
  La IA proporcionó una base estructurada para las rutinas de Bubble Sort e Insertion Sort en AArch64, facilitando la comparativa a nivel de accesos a memoria y saltos condicionales. Sin embargo, fue necesario ajustar manualmente la estructura del documento y revisar los bloques de código para asegurar su correcta compilación con GCC/Clang y su visualización adecuada en el repositorio.

- **Fecha**: 2026-09-15
- **Plataforma utilizada**: GitHub Web Editor / Entorno de desarrollo local ARM64 (Linux / QEMU)
