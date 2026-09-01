# Anexo — Bitácora de uso de LLM

## Uso de inteligencia artificial

Para la elaboración de esta investigación se utilizó un modelo de lenguaje (LLM) como herramienta de apoyo para comprender el tema de **Linker scripts para microcontroladores ARM: mapa de memoria**, organizar la información y desarrollar ejemplos que facilitaran la comprensión del contenido.

La inteligencia artificial se utilizó como apoyo para el aprendizaje y la redacción, pero la información fue revisada para evitar incorporar conceptos incorrectos o ejemplos que pudieran generar confusión.

---

## Prompt utilizado

### Prompt 1

> “Ayudame a entender y a organizar de manera precisa la informacion acerca del tema linker scripts y microcontroladores”

**Resultado obtenido:**

El LLM explicó de manera general qué es un linker, qué es un linker script y cómo se relaciona con el mapa de memoria de un microcontrolador ARM. También se introdujeron los conceptos de FLASH, RAM, `.text`, `.data`, `.bss`, `MEMORY` y `SECTIONS`.

---

### Prompt 2

> “En base a esa explicación destaca los puntos mas importantes que tengo que tomar en cuenta y ejemplos.”

**Resultado obtenido:**

Se desarrolló una explicación más detallada del tema, utilizando ejemplos sencillos para explicar la relación entre el código fuente, el compilador, el linker y el programa final. También se explicó cómo se distribuyen diferentes secciones del programa dentro de FLASH y RAM.

---

## Reflexión crítica

El uso del LLM fue útil para comprender un tema que inicialmente podía resultar complicado debido a que involucra conceptos de compilación, memoria y arquitectura de microcontroladores.

Una de las partes que ayudó más fue utilizar ejemplos visuales para representar el mapa de memoria. Esto permitió relacionar conceptos abstractos como FLASH, RAM y las diferentes secciones del programa con una representación más sencilla.

Sin embargo, también fue necesario tener cuidado con las respuestas generadas. Las direcciones de memoria utilizadas en los ejemplos no deben considerarse universales para todos los microcontroladores ARM, ya que cada dispositivo puede tener un mapa de memoria diferente.

Por esta razón, los ejemplos de direcciones utilizados en la investigación se presentan como ejemplos ilustrativos y no como una configuración válida para cualquier microcontrolador.

También se consideró necesario revisar la información relacionada con GNU `ld`, especialmente los comandos `MEMORY` y `SECTIONS`, debido a que son elementos técnicos importantes del tema.

En conclusión, el LLM ayudó principalmente como herramienta para organizar la investigación, explicar conceptos difíciles de una manera más sencilla y generar ejemplos. Sin embargo, la información generada tuvo que analizarse críticamente, especialmente en los puntos relacionados con las características específicas de cada arquitectura ARM.
---

## Errores, limitaciones y posibles sesgos

Durante la revisión se identificó que algunos ejemplos generados por el LLM podían interpretarse como si fueran aplicables a cualquier microcontrolador ARM.

Esto podía ser confuso, ya que diferentes microcontroladores pueden tener diferentes tamaños, direcciones y regiones de memoria.

Por esta razón, se aclaró dentro de la investigación que las direcciones utilizadas son ejemplos ilustrativos y que el mapa de memoria depende del dispositivo específico.

También se tuvo en cuenta que una explicación generada por un LLM puede simplificar conceptos técnicos para hacerlos más fáciles de comprender. Aunque esto resulta útil para aprender, puede dejar fuera detalles importantes de una arquitectura específica.

Por lo anterior, la información técnica relacionada con GNU ld y los linker scripts se contrastó con documentación de referencia.

---

## Validación de la información

La información relacionada con los comandos MEMORY y SECTIONS fue contrastada con la documentación de GNU ld.

También se revisó que los ejemplos utilizados fueran coherentes con la explicación proporcionada.

Se comprobó especialmente que:

-- MEMORY se utilizara para describir regiones de memoria.

-- SECTIONS se utilizara para organizar las secciones del programa.

-- .text se relacionara con el código ejecutable.

-- .rodata se relacionara con datos de solo lectura.

-- .data se relacionara con datos inicializados que pueden utilizar RAM durante la ejecución.

-- .bss se relacionara con datos que comienzan en cero.

-- Las direcciones de memoria se presentaran únicamente como ejemplos y no como valores universales.
