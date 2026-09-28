### Asistencia de Inteligencia Artificial

- **Nivel de participación de IA**: 3

- **Prompts utilizados**:
  - "Soy un estudiante de Ingeniería en Sistemas Computacionales; en mi materia de Lenguajes de Interfaz se me encargó la investigación del tema de operaciones de campos de bits con bfi, ubfx y sbfx en ARM 64. Dame una introducción y apúntame a fuentes donde pueda estudiar el tema, libros, artículos, blogs, etc.
    La introducción trata de que venga desde abajo hasta arriba con los conceptos necesarios para entenderlo y sus explicaciones."
  - "Explicámelo en un lenguaje de más alto nivel para consolidar mi entendimiento sobre este tema que es nuevo para mi"
  - "¿Dame más ejemplos de la utilidad de esto, en alguna aplicación real, entiendo el concepto de que es por eficiencia del procesador, pero para qué moverías estos datos a otras secciones para qué los brincarías o querrías limpiar o mantener el signo o precisamente colocarlo enmedio?"
  - "Ok con este contexto vuelve al bajo nivel volviendo a explicar los conceptos para mi investigación"
  - "Usando esta misma estructura de temas, la sección de conocimientos previos que resuelve y como lo resuelve, agregando ejemplos cortos de aplicaciones"

- **Herramientas utilizadas**:
  - Gemini

- **Cambios y validación**:
  - Verifique la información en las fuentes señaladas.
  - Realice investigación basada en la información presentada para confirmar la veracidad de los conceptos explicados.
  - Al comprender el tema, corroboré que los ejemplos fueran aplicaciones reales en la práctica.

- **Reflexión personal**:
  La IA me ayudó a comprender procesos complejos de hardware y sus limitaciones.
  Me ayudó a entender de dónde salió la necesidad de crear estas soluciones.
  Me explicó cómo funcionan estas soluciones y qué aplicaciones se les da en dispositivos reales.
  Me ayudó a pasar de un lenguaje de más alto nivel hasta aterrizar de regreso en los conceptos clave del tema de una manera más entendible.

- **Explicación propia de una decisión técnica central** *(obligatorio solo si el nivel declarado es 3 o 4)*:
  Previamente, en los procesadores podíamos encontrar lo que son los registros; en ellos se almacena para su procesamiento información.
  La estancia de la información aquí es muy corta, pero en el periodo que se encuentran aquí y se quieren trabajar, el procesador requiere acceder a ciertas secciones específicas del campo de bits, donde está la pieza de información requerida.
  Para ahorrar recursos al transportar la información, esta se empaqueta en estas secciones de 32 o 64 bits; para dar un ejemplo, podrían empaquetarse códigos de distintos colores en la misma seccion.
  El problema se presentaba al querer acceder a la información que estaba en medio del campo de bits; tradicionalmente, se tenía que mover la información y utilizar una operación para borrar los bits basura y así llegar a la información a donde se puede trabajar sobreescribiendo elementos no deseados.
  Con los nuevos métodos se permite obtener estos datos directamente y, pasando por un circuito especializado, ser transportados a un registro de destino limpio donde se puede trabajar esta información en un área nueva en un solo ciclo del procesador.
  También uno de los métodos nos permite tener cuidado para mantener el signo del valor con el que queremos trabajar.
  Y tenemos también el caso contrario, el caso en el que queremos insertar información en el centro del campo de bits de manera precisa.
  Estos métodos los encontramos justamente en procesadores como el ARM y son métodos muy valiosos que vuelven mucho más eficiente el procesamiento de la información.

- **Fecha**: 2026-09-21
- **Plataforma utilizada**: Git Hub
