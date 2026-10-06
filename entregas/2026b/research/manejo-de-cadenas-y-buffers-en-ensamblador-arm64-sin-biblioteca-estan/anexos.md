### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "analiza lo que menciona mi tema, ocupo que desfragmentes el texto y me expliques a que se debe cada punto, por ejemplo Como que cadenas? como que buffers? como que ensamblador? ARM64 y por que sin biblioteca estandar"
  - "cuál es la sintaxis correcta en Markdown para insertar un bloque de código en lenguaje ensamblador ARM64 de manera que el editor aplique el resaltado de colores correspondiente?"
  - Proporciona un ejemplo de código en ensamblador ARM64 puro que demuestre cómo calcular la longitud de una cadena (equivalente a strlen). Muestra cómo recorrer el buffer byte por byte utilizando un bucle y las instrucciones nativas necesarias para detectar el terminador nulo, sin depender de ninguna biblioteca estándar
  - Ayúdame a dar formato a estas referencias en estilo IEEE. No investigues ni agregues información nueva; solo organiza y formatea los datos que te proporcione. Coloca las referencias con el formato IEEE correspondiente, conserva los enlaces que te proporciono.

- **Herramientas utilizadas**:
  - Gemini
  - ChatGPT

- **Cambios y validación**:
  - Tomé la explicación desglosada de los conceptos (cadenas, buffers, ARM64) para redactar el texto, asegurándome de descartar información sobre bibliotecas de alto nivel.
  - Verifiqué en la vista previa del archivo .md que la sintaxis armasm sí aplicara el resaltado de colores correcto al bloque de código.
  - Revisé el código generado para el bucle de la cadena y validé que las instrucciones ldrb y cbz correspondieran correctamente a la arquitectura ARM64.

- **Reflexión personal**:
  - La IA me ayudó a comprender rápidamente la diferencia entre el manejo de memoria en lenguajes de alto nivel y el bajo nivel. Aclarar a qué se refería la restricción de "sin biblioteca estándar" me ahorró tiempo y me permitió enfocar correctamente la investigación hacia la manipulación directa de registros en ARM64 en lugar de buscar funciones prehechas.

- **Fecha**: 2026-09-09
