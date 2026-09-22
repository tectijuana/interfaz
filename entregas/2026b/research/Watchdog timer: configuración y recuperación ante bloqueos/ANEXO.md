# Anexo — Bitácora de uso de LLM

## 1. Introducción

Durante la realización de la investigación sobre **"Temporización, relojes y energía: Watchdog Timer - configuración y recuperación ante bloqueos"** se utilizó un modelo de lenguaje (LLM) como herramienta de apoyo para comprender conceptos técnicos relacionados con microcontroladores, sistemas embebidos y Watchdog Timer.

La inteligencia artificial no se utilizó como sustituto de la investigación ni para copiar directamente el contenido generado. Se utilizó principalmente para obtener explicaciones, resolver dudas técnicas, identificar conceptos que necesitaba investigar y recibir orientación sobre posibles fuentes y aspectos que debía considerar.

A continuación se presentan algunos de los prompts utilizados durante el desarrollo del trabajo y una reflexión sobre los resultados obtenidos.

---

## 2. Prompt 1 — Creación de un mentor para la investigación

### Prompt utilizado

> Dame un prompt para IA que pueda convertir la conversación en una plática con un experto en el área de investigación formato IEEE en microcontroladores y lenguajes de bajo nivel-medio nivel que me ayude a guiarme para entender mí tema de investigación sin hacerlo por mí. Necesito alguien que me ayude a entender la parte técnica.
>
> Este es mi tema:
>
> Temporización, relojes y energía
>
> Watchdog timer: configuración y recuperación ante bloqueos
>
> Y este la rúbrica a tener en cuenta:
>
> [Rúbrica proporcionada al modelo sobre rigor técnico, estructura, originalidad, repositorio, bitácora de IA y bibliografía IEEE.]

### Resultado obtenido

El modelo propuso utilizar un prompt que estableciera el papel de un investigador y profesor especializado en arquitectura de microcontroladores, sistemas embebidos y lenguajes de bajo y medio nivel.

También recomendó que la IA funcionara principalmente como un **mentor técnico**, en lugar de generar directamente el trabajo. Entre las funciones propuestas estuvieron explicar conceptos como prescalers, osciladores, registros de control del Watchdog Timer y modos de bajo consumo.

Otro aspecto importante fue la recomendación de utilizar preguntas para comprobar la comprensión del tema, por ejemplo, preguntando qué ocurriría ante determinados cambios en la configuración del temporizador.

### ¿Cómo me ayudó?

Este prompt me ayudó a definir una forma de utilizar la IA que no consistiera solamente en pedirle que escribiera la investigación. Me permitió plantear la conversación como una herramienta para aprender el funcionamiento técnico del Watchdog Timer.

También me ayudó a identificar que para comprender correctamente el tema no era suficiente con conocer una definición del WDT, sino que debía investigar elementos como los relojes, prescalers, registros, temporización, reinicio del microcontrolador y recuperación después de un bloqueo.

### Reflexión crítica

Considero que este prompt fue útil porque estableció desde el principio que la IA debía funcionar como apoyo y no como autora del trabajo. Sin embargo, la respuesta podía presentar explicaciones demasiado generales si no se especificaba un microcontrolador concreto.

También observé que una explicación proporcionada por una IA no debe considerarse automáticamente correcta. En temas de microcontroladores existen diferencias importantes entre fabricantes y familias de dispositivos. Por ejemplo, la configuración del Watchdog Timer y sus registros puede cambiar entre un AVR, un PIC, un STM32 o un Raspberry Pi Pico.

Por esta razón, la información técnica obtenida mediante la IA debía compararse posteriormente con documentación oficial, principalmente datasheets y manuales de referencia. El prompt sirvió como guía para saber qué investigar, pero no como fuente final de información.

---

## 3. Prompt 2 — Mentor técnico especializado

### Prompt utilizado

> **Actúa como un Investigador Senior y Catedrático experto en Arquitectura de Microcontroladores, Sistemas Embebidos, lenguajes de bajo/medio nivel (C, C++, Ensamblador) y redacción académica bajo el formato IEEE.**
>
> **Tu objetivo:** Ser mi mentor técnico y guía de investigación. Necesito entender a profundidad mi tema de investigación para poder escribir yo mismo un artículo/README de alta calidad.
>
> **Mi tema de investigación es:** "Temporización, relojes y energía: Watchdog timer - configuración y recuperación ante bloqueos."
>
> **REGLA DE ORO (ESTRICTA):** NO escribas el documento por mí. NO me des párrafos listos para copiar y pegar en mi README.md. Si detectas que estoy intentando que hagas el trabajo, detente y hazme preguntas para que yo mismo llegue a la conclusión. Tu trabajo es darme claridad técnica, sugerir enfoques, explicar cómo funciona el hardware y el código a nivel de registros, y evaluar mis ideas.
>
> **Debes guiarme asegurando que mi trabajo final cumpla con la siguiente rúbrica:**
>
> 1. **Rigor técnico (30 pts):** Ayúdame a entender los conceptos con exactitud (ej. prescalers, osciladores, registros de control del WDT, modos de bajo consumo). Sugiéreme datos, comparativas de hojas de datos (datasheets) o ejemplos verificables para que mi desarrollo supere las 500 palabras.
> 2. **Estructura (20 pts):** Recuérdame cómo organizar lógicamente mi Markdown (Introducción, Desarrollo técnico, Conclusiones) y ayúdame a revisar mi redacción profesional.
> 3. **Originalidad (20 pts):** Hazme preguntas socráticas ("¿Por qué crees que...?", "¿Qué pasaría si...?") para forzarme a analizar, comparar y generar una postura argumentada propia.
> 4. **Git Flow (15 pts):** Si tengo dudas técnicas sobre cómo hacer mi Fork, el Pull Request, los commits o dónde ubicar mi carpeta, explícame los comandos paso a paso.
> 5. **Bitácora IEEE e IA (15 pts):** Ayúdame a estructurar mi `anexo.md` con los prompts que usemos y ayúdame a formatear mis fuentes de información (datasheets, papers) en formato IEEE correcto.
>
> **Dinámica de trabajo:**
>
> Para empezar, hazme un diagnóstico rápido. Pregúntame qué sé actualmente sobre el "Watchdog Timer" y qué nivel de experiencia tengo leyendo datasheets de microcontroladores. A partir de mis respuestas, proponme un índice de temas que debería investigar y explicarme el primer concepto técnico.

### Resultado obtenido

La IA comenzó planteando un enfoque de diagnóstico para conocer el nivel de conocimiento previo sobre el Watchdog Timer y la lectura de datasheets.

A partir de este enfoque se estableció una ruta de aprendizaje relacionada con el funcionamiento del WDT, los relojes del microcontrolador, la configuración mediante registros, los tiempos de espera, los prescalers, los reinicios y la recuperación ante bloqueos.

También se planteó estudiar la relación entre el Watchdog Timer y el consumo energético, especialmente en sistemas embebidos donde existen diferentes modos de operación y bajo consumo.

### ¿Cómo me ayudó?

Este prompt fue más útil para la parte técnica porque permitió hacer preguntas sobre conceptos específicos en lugar de limitarse a buscar una definición del Watchdog Timer.

La interacción también permitió entender que el WDT no debe verse únicamente como un temporizador que "reinicia el microcontrolador", sino como un mecanismo de supervisión que permite detectar que el programa dejó de ejecutarse de la manera esperada.

Además, la conversación ayudó a identificar conceptos que posteriormente podían comprobarse directamente en la documentación del microcontrolador utilizado.

### Reflexión crítica

El principal beneficio fue poder preguntar cosas que inicialmente no entendía y recibir explicaciones con diferentes niveles de dificultad. Esto fue especialmente útil para relacionar conceptos como reloj, frecuencia, periodo, prescaler y tiempo de espera del Watchdog.

Sin embargo, también encontré una limitación importante: algunas explicaciones pueden ser correctas de manera general, pero no necesariamente aplican exactamente al microcontrolador que se esté estudiando. Un WDT no funciona de manera idéntica en todos los dispositivos.

Por eso, las respuestas de la IA se utilizaron como una guía para comprender el tema y saber qué buscar, mientras que los datos específicos de registros, frecuencias, tiempos y configuraciones debían verificarse en documentación oficial.

---

## 4. Evaluación general del uso de IA

El uso del LLM fue principalmente educativo. La herramienta permitió aclarar conceptos técnicos, generar preguntas para profundizar en el tema y organizar las áreas que debían investigarse.

Uno de los principales riesgos identificados fue aceptar una explicación de la IA sin comprobarla. En una investigación relacionada con microcontroladores esto puede generar errores, debido a que diferentes fabricantes utilizan arquitecturas, registros y configuraciones diferentes.

También se identificó que la IA puede presentar información demasiado general cuando no se proporciona un modelo específico de microcontrolador. Por este motivo, para los datos técnicos concretos se consideró necesario recurrir a fuentes primarias como datasheets, manuales de referencia y documentación oficial del fabricante.

La IA facilitó el proceso de aprendizaje, pero la interpretación de la información y la redacción final del trabajo corresponden al estudiante. El contenido generado por el modelo se utilizó como apoyo para comprender y orientar la investigación, no como sustituto de las fuentes técnicas.

---

## 5. Conclusión de la bitácora

El uso del LLM fue útil principalmente como herramienta de consulta y aprendizaje. Permitió identificar conceptos que necesitaba estudiar y formular preguntas técnicas que ayudaron a comprender mejor el funcionamiento del Watchdog Timer.

Al mismo tiempo, la experiencia mostró que la información proporcionada por una IA debe ser revisada y comparada con fuentes confiables. En especial, los datos relacionados con registros, tiempos, frecuencias y configuración del hardware no deben tomarse como universales.

Por lo tanto, considero que la IA fue una herramienta complementaria durante la investigación. Me ayudó a comprender el tema y a organizar mi proceso de aprendizaje, pero la información técnica utilizada en el trabajo final debe estar respaldada por documentación especializada y fuentes verificables.
