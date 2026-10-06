## Bitácora de uso de LLM

Durante la elaboración de este trabajo se utilizó un modelo de lenguaje (LLM) como herramienta de apoyo para organizar, redactar y revisar información relacionada con la aritmética de punto fijo Q15 y Q31 en microcontroladores ARM.

### 1. Prompt utilizado: búsqueda y organización del tema

**Prompt:**

> Dame el texto para cada diapositiva de acuerdo a los temas de arquitectura y funcionamiento de los sistemas relacionados con procesamiento digital de señales.

**Resultado obtenido:**

El modelo proporcionó una estructura organizada por temas y subtemas, incluyendo conceptos, características, aplicaciones y explicaciones técnicas. Esto sirvió como referencia para organizar posteriormente la información del trabajo.

**Reflexión crítica:**

El resultado fue útil principalmente para organizar las ideas y establecer una estructura. Sin embargo, no se consideró que toda la información generada fuera automáticamente correcta, por lo que fue necesario revisar conceptos técnicos y fuentes relacionadas con ARM y CMSIS-DSP.

---

### 2. Prompt utilizado: explicación de Q15 y Q31

**Prompt:**

> Explica la aritmética de punto fijo Q15 y Q31 para DSP en microcontroladores ARM.

**Resultado obtenido:**

El modelo explicó el funcionamiento de las representaciones Q15 y Q31, las conversiones entre punto flotante y punto fijo, las operaciones de suma y multiplicación, además de conceptos como saturación, overflow y resolución.

**Reflexión crítica:**

La explicación ayudó a comprender la relación entre los valores enteros almacenados y los valores reales. Sin embargo, algunas explicaciones podían ser demasiado generales y fue necesario comprobar las operaciones matemáticas y las características específicas de CMSIS-DSP antes de incorporarlas al trabajo.

---

### 3. Prompt utilizado: revisión del contenido

**Prompt:**

> Revisa el siguiente contenido sobre aritmética de punto fijo Q15/Q31 y señala errores o aspectos que puedan mejorarse.

**Resultado obtenido:**

La revisión permitió detectar problemas de redacción, formato y algunos errores de escritura dentro del documento.

**Reflexión crítica:**

Esta revisión fue útil porque permitió encontrar errores que podían pasar desapercibidos. Por ejemplo, se identificaron expresiones incompletas o mal escritas como `x[nk]`, `yh[k]` y `q15_t y q31_t`, además de un error tipográfico en la palabra "hijo" dentro de una explicación sobre los límites de Q31.

También se observó que algunas expresiones matemáticas podían presentarse de una manera más clara mediante fórmulas separadas.

---

### 4. Prompt utilizado: mejora del formato en GitHub

**Prompt:**

> ¿Cómo mejoro el formato?

**Resultado obtenido:**

El modelo recomendó utilizar Markdown para organizar correctamente el documento en GitHub mediante títulos, subtítulos, listas, tablas, código y bloques de fórmulas.

**Reflexión crítica:**

La recomendación ayudó a mejorar la presentación del README. Se decidió utilizar encabezados `#`, `##` y `###`, tablas y bloques de código para facilitar la lectura.

---

### 5. Errores y sesgos identificados

El uso del LLM presentó algunas limitaciones. La principal fue que algunas respuestas podían parecer correctas aunque necesitaran verificación técnica.

Durante la revisión del documento se encontraron algunos errores de escritura y formato, por ejemplo:

- `Q15-Q30` cuando el trabajo corresponde a **Q15/Q31**.
- `q15_ty q31_t` en lugar de una separación correcta entre los tipos.
- `x[nk]`, que debe revisarse porque la notación esperada normalmente sería `x[n-k]`.
- `yh[k]`, donde faltaba separar correctamente los términos de la ecuación.
- La palabra `hijo` en una oración donde claramente se trataba de un error de escritura.
- Algunas fórmulas estaban escritas como texto plano y no con una notación matemática clara.

También se consideró que las referencias proporcionadas por un LLM no deben aceptarse sin comprobarlas, ya que un modelo puede generar referencias incompletas, incorrectas o desactualizadas.

### 6. Reflexión final

El uso del LLM **sí ayudó** durante el desarrollo del trabajo, principalmente para organizar información, aclarar conceptos y detectar errores de redacción y formato. Sin embargo, no se utilizó como única fuente de información.

La experiencia mostró que un LLM puede ahorrar tiempo y ayudar a comprender temas técnicos, pero sus respuestas deben ser revisadas críticamente. Es posible que presente errores, simplifique demasiado algunos conceptos o proporcione información que necesite ser comprobada en documentación oficial.

Por esta razón, la información técnica relacionada con Q15, Q31, ARM Cortex-M y CMSIS-DSP debe contrastarse con documentación oficial y otras fuentes confiables. El LLM se utilizó como **herramienta de apoyo**, mientras que la revisión y validación final de la información quedaron bajo responsabilidad del autor.
