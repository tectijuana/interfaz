# Bitácora de IA - Responsabilidad Académica

## 1. Documentación del proceso

* **Prompts utilizados:**
  * **Asistente de IA (Gemini):** Para la síntesis de documentación técnica, generación de ejemplos de código ensamblador y corrección de formato Markdown.
  * *"Explica los modos de direccionamiento pre-indexado y post-indexado en la arquitectura ARMv8-A. Proporciona ejemplos claros y explica cómo se utilizan de forma eficiente en programación."*
  * *"Reestructura la investigación utilizando formato Markdown, mejora la profundidad técnica a nivel de hardware y agrega referencias bibliográficas."*
* **Cambios o mejoras realizadas tras usar pensamiento crítico:**
  * Se modificó el formato del texto plano generado originalmente para incluir la jerarquía correcta de Markdown (títulos, negritas, bloques de código). 
  * Se verificó que los registros mencionados en los ejemplos (`Xn` para 64 bits, `Wn` para 32 bits) correspondieran estrictamente al estado de ejecución AArch64, eliminando sintaxis heredada de ARMv7.
  * Se amplió la explicación del *writeback* para separar conceptualmente el cálculo aritmético (AGU) del acceso a memoria.
* **Referencias oficiales o pruebas adicionales consultadas:**
  * ARM Limited, *ARM Architecture Reference Manual ARMv8, for ARMv8-A architecture profile*.
  * Pyeatt, L. D., & Ughetta, W., *ARM 64-Bit Assembly Language*.

## 2. Reflexión

* **¿Qué sesgos, errores o vacíos encontré en la respuesta de la IA?**
  * La arquitectura "ARM", mezclando conceptos de 32 bits y 64 bits si no se le restringe estrictamente. Por ejemplo, en iteraciones iniciales, no dejaba explícito que en ARMv8-A las instrucciones tradicionales `PUSH` y `POP` fueron reemplazadas por rutinas que utilizan `STP` y `LDP` combinadas con pre y post-indexación. Fue necesario pedir contexto específico de AArch64 para llenar ese vacío técnico.
* **¿En qué me ayudó la IA y la automatización de tareas?**
  * La IA funcionó como un facilitador para sintetizar documentación técnica compleja. La automatización de tareas repetitivas (como estructurar el formato Markdown, generar los bloques de código resaltados y guiarme paso a paso para resolver el flujo de trabajo en GitHub). Esto me permitió enfocar mi esfuerzo mental en la comprensión real de la teoría de ensamblador.
* **¿Qué aprendí del proceso de revisión?**
  * **Sobre la arquitectura:** Aprendí que el direccionamiento pre-indexado y post-indexado no son simples "atajos" de escritura, sino mecanismos implementados a nivel de hardware que ejecutan una operación aritmética y un acceso a memoria simultáneamente, reduciendo el tamaño del código.
  * **Sobre el flujo de trabajo (Git/GitHub):** Enfrenté dificultades técnicas para estructurar correctamente la entrega, renombrar carpetas y gestionar archivos de un tema anterior. Aprendí a utilizar la interfaz web de GitHub para modificar rutas y realizar commits correctamente, logrando que el *Pull Request* se actualizara cumpliendo con la rúbrica.
