Prompts utilizados:
  - "Con los siguientes links dame los puntos que debo tener en una investigación del tema Conteo de ciclos con el contador de la PMU (PMCCNTR) en AArch64 [se incluyeron 5 enlaces web]."
  - "Dale una mejor estructura a la investigación."

- Herramientas utilizadas:
  - Gemini

- Cambios y validación**:
  - Ajusté el texto generado para asegurar que no solo fuera un resumen superficial, comprobando específicamente las restricciones de acceso en espacio de usuario contra la documentación oficial de ARM.
  - Revisé el comportamiento descrito en entornos emulados. La IA mencionó QEMU, pero tuve que verificar y enfatizar que QEMU usa traducción binaria y no provee medición de microarquitectura precisa (tuberías/caché), lo cual validé conceptualmente.
  - Agregué y di formato a las citas bibliográficas que la herramienta omitió incluir en el texto final.

Reflexión personal:
  - Vacíos/Errores detectados:** Noté que, aunque la IA estructura bien la información a partir de los enlaces, tiende a generalizar y omite hacer referencia explícita a la fuente de donde obtuvo cada dato.
  - Aprendizaje: Este proceso me enseñó que la IA es excelente para organizar una investigación, pero el trabajo de validación técnica de bajo nivel (como entender por qué la lectura directa de ciclos falla sin una barrera de sincronización de instrucciones) depende estrictamente del análisis crítico y la lectura de los datasheets de ARM.

- Fecha: 2026-09-20
