# Anexo — Asistencia de Inteligencia Artificial

### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "En base al tema de Acceso a periféricos por memoria mapeada (MMIO) y el calificador `volatile`, dame los puntos claves para investigar, para una investigación universitaria de la materia Lenguajes de Interfaz."
  
  - "De la información presentada, organiza las ideas principales y dale un formato de Markdown."
  
  - "Para la sección de espacios de memoria y mapa de direcciones dame un ejemplo de un mapa de direcciones."
  
  - "Explica qué son los registros de los periféricos y cómo funcionan las operaciones de lectura y escritura mediante MMIO. Incluye un ejemplo sencillo que muestre cómo la CPU puede leer el estado de un periférico o escribir en uno de sus registros, y relaciónalo con el uso de `volatile`."
  
  - "A partir de la información presentada sobre el acceso a registros mapeados en memoria desde C, sintetiza y organiza los conceptos más importantes para la sección 'Acceso a MMIO desde C' de una investigación universitaria. Explica cómo se representan los registros MMIO mediante punteros, el uso de direcciones base y offsets, la desreferenciación para realizar lecturas y escrituras, y la función de los calificadores `volatile` y `const`. Conserva un ejemplo sencillo basado en la Raspberry Pi Pico y presenta el resultado en formato Markdown."
  
  - "Genera un ejemplo sencillo en C para explicar el funcionamiento del calificador `volatile`. Compara el comportamiento de una variable o registro sin `volatile` y con `volatile`, mostrando por qué el compilador no debe asumir que su valor permanece sin cambios. Relaciona el ejemplo con un registro de estado de hardware y preséntalo de forma adecuada para una investigación universitaria en Markdown."

- **Herramientas utilizadas**:
  - ChatGPT (OpenAI)

- **Cambios y validación**:
  - Utilicé la IA principalmente para organizar y dar formato Markdown a la información recopilada durante la investigación.
  - Revisé los ejemplos proporcionados sobre MMIO, registros de periféricos y el uso de punteros en C antes de incorporarlos al documento.
  - Comparé las explicaciones generadas sobre `volatile` con las fuentes consultadas para evitar asumir que este calificador elimina todas las optimizaciones realizadas por el compilador.
  - Los mapas de direcciones y registros utilizados como ejemplos se trataron como representaciones simplificadas y no como mapas correspondientes a un dispositivo específico.
  - La información utilizada para elaborar el documento fue contrastada con las referencias incluidas en la bibliografía.

- **Reflexión personal**:
A lo largo de la investigación me apoye mayormente en la IA para la organización y de la misma, en gran parte se uso para entender como funcionaba markdown (esto ya que es la primera vez que lo manejo)
tambien bajo mi poca experiencia con ciertas partes que se trataron en esta investigacion, me apoye para la elavoracion de ejemplos y centrar cierta informacion que encontre en los diferentes enlaces y/o paginas
de las cuales se obtuvo la información, en gran medida fue un buen apoyo, ya que facilito la comprencion del tema y del uso de marckdown para futuros trabajos.

- **Fecha**: 2026-09-16
- **Plataforma utilizada**: GitHub
