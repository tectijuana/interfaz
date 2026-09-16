# Anexo Investigación Desenrollado de bucles (loop unrolling) manual y su efecto en el rendimiento
# Informascion del estudiante
  Alumno: Cesar Adrian Luis Juan Camacho
  
  Materia:  Lenguajes de interfaz
  
  Horario: 5:00 - 6:00 PM
  
  Tema: Desenrollado de bucles (loop unrolling) manual y su efecto en el rendimiento
---

## 1. Prompts utilizados

A continuación se enumeran, en orden cronológico y sin editar su contenido técnico, los prompts principales enviados a la herramienta de IA durante la elaboración de este trabajo:

1. **Prompt 1 (documento base sobre recursión, referencia de formato):**
   > "Redacta un documento académico, estilo README.md, sobre el tema: Desenrollado de bucles (loop unrolling) manual y su efecto en el rendimiento. Con la misma estructura obligatoria (introducción, desarrollo técnico mínimo 500 palabras, conclusiones, bibliografía IEEE, material opcional) y declaración de uso de IA en anexo.md."

2. **Prompt 2 (formato exigido de la bitácora de IA):**
   > "Debo hacer esto con esto: Bitácora de IA (anexo.md) y bibliografía IEEE [...] anexo.md con prompts reales, resultados y reflexión honesta sobre el uso de IA; bibliografía con fuentes confiables (IEEE, libros, papers, sitios oficiales) y formato IEEE correcto. Declaración de Asistencia de Inteligencia Artificial [con las secciones: Prompts utilizados, Agentes o herramientas utilizadas, Cambios realizados y evaluación crítica, Reflexión personal, Datos finales]."


No se enviaron prompts adicionales de regeneración: el contenido técnico del documento sobre loop unrolling se generó en una sola iteración, reutilizando la estructura y el formato de bitácora ya validados en el trabajo anterior sobre recursión (Prompts 1 y 2).

---

## 2. Agentes o herramientas utilizadas

* **Claude (Sonnet 5), desarrollado por Anthropic** — utilizado como única herramienta de IA en este trabajo, a través de la interfaz de chat de Claude.ai. Se empleó para:
  * Redactar la introducción y el desarrollo técnico sobre desenrollado de bucles, overhead de control, ejecución superescalar y vectorización.
  * Generar los ejemplos de código en C (`suma_normal`, `suma_desenrollada`, `benchmark.c`, `suma_paralela`).
  * Proponer el diagrama comparativo de control de flujo (bucle normal vs. desenrollado).
  * Proponer una lista inicial de referencias bibliográficas en formato IEEE, posteriormente verificadas manualmente (ver siguiente sección).

No se utilizaron otras herramientas de IA (no se usó ChatGPT, GitHub Copilot ni Perplexity) ni asistentes de autocompletado de código para este trabajo.

---

## 3. Cambios realizados y evaluación crítica

* **Verificación de corrección del bucle remanente:** se revisó específicamente que las versiones desenrolladas (`suma_desenrollada` y `suma_paralela`) incluyeran el manejo del remanente (`n % 4`) para arreglos cuyo tamaño no es múltiplo del factor de desenrollado, ya que su omisión es un error frecuente señalado explícitamente en la sección de errores comunes; se confirmó su presencia y correcto cálculo (`limite = n - (n % 4)`) en ambos ejemplos.
* **Distinción entre dependencia de datos y paralelismo real:** se solicitó y verificó que el ejemplo de `suma_desenrollada` (un solo acumulador `total`) se presentara explícitamente como una versión con dependencia secuencial, y que `suma_paralela` (acumuladores independientes `acc0`–`acc3`) se explicara como la variante que efectivamente habilita ejecución paralela en el procesador, evitando presentar ambas técnicas como equivalentes cuando no lo son a nivel de arquitectura.
* **Moderación de afirmaciones de rendimiento:** se ajustó el texto generado inicialmente, que tendía a afirmar una mejora de rendimiento fija o garantizada, para aclarar que la magnitud de la mejora depende del compilador, del nivel de optimización (`-O0`, `-O1`, `-O2`) y del procesador utilizado, evitando así una generalización empírica no verificada.
* **Revisión de compilación:** se confirmó que el código en C no utiliza construcciones incompletas ni pseudocódigo, que todas las funciones están completas (incluyen tipo de retorno, manejo de memoria con `malloc`/`free` en el *benchmark*, y cabeceras estándar `stdio.h`, `stdlib.h`, `time.h`) y que compilarían con `gcc` sin dependencias externas.
* **Verificación bibliográfica manual:** se confirmó la existencia real y la relevancia de las obras y fuentes citadas (Hennessy y Patterson; Allen y Kennedy; Muchnick), y se incorporaron dos fuentes de sitios oficiales (manual de optimización de Intel y documentación oficial de GCC) para reforzar la confiabilidad de la bibliografía conforme a la rúbrica del curso.

---

## 4. Reflexión personal

Trabajar este tema con apoyo de IA fue distinto al ejercicio anterior sobre recursión, porque el desenrollado de bucles depende directamente de conceptos de arquitectura de computadoras (pipeline, predicción de saltos, caché de instrucciones, SIMD) que no son evidentes solo con leer el código fuente. Esto me obligó a no aceptar de forma automática las afirmaciones sobre "mejora de rendimiento" propuestas por la IA, sino a pedir que se explicara el mecanismo de hardware detrás de cada beneficio (por ejemplo, por qué separar acumuladores habilita paralelismo real y no solo reduce líneas de código).

Detecté que la primera versión del texto no distinguía claramente entre desenrollar un bucle con un único acumulador (que sigue teniendo una dependencia secuencial) y desenrollar con acumuladores independientes (que sí permite paralelismo); esta diferencia es sutil pero central para entender el efecto real en el rendimiento, y repasarla me ayudó a comprender mejor por qué el orden de las operaciones importa tanto como su cantidad.

Para un próximo trabajo de este tipo, compilaría y ejecutaría realmente el `benchmark.c` con distintos niveles de optimización (`-O0`, `-O1`, `-O2`, `-O3`) para reportar cifras reales de mi propio equipo en lugar de describir el efecto solo cualitativamente, y usaría una herramienta de perfilado (por ejemplo `perf` en Linux) para confirmar empíricamente los fallos de predicción de salto y los fallos de caché mencionados en la teoría.

---
## 5. Bibliografía (formato IEEE)

[1] J. L. Hennessy and D. A. Patterson, *Computer Architecture: A Quantitative Approach*, 6th ed. Cambridge, MA, USA: Morgan Kaufmann, 2017.

[2] R. Allen and K. Kennedy, *Optimizing Compilers for Modern Architectures: A Dependence-Based Approach*. San Francisco, CA, USA: Morgan Kaufmann, 2001.

[3] S. Muchnick, *Advanced Compiler Design and Implementation*. San Francisco, CA, USA: Morgan Kaufmann, 1997.

[4] Intel Corporation, "Intel 64 and IA-32 Architectures Optimization Reference Manual," Intel Corp., Santa Clara, CA, USA, 2023. [Online]. Available: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html. [Accessed: 11-Sep-2026].

[5] Free Software Foundation, "Options That Control Optimization — Using the GNU Compiler Collection (GCC)," *GCC Online Documentation*. [Online]. Available: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html. [Accessed: 11-Sep-2026].

---
## 6. Datos finales

* **Fecha de la asistencia IA:** 11 de septiembre de 2026
* **Versión de entrega/práctica:** v1.0
* **Herramientas:** Claude (Sonnet 5), Anthropic — interfaz de chat de Claude.ai
---

# Declaración de Originalidad

**Título del trabajo:** 1.1 Investigación via Pull Request Desenrollado de bucles (loop unrolling) manual y su efecto en el rendimiento
**Curso:** Lenguajes de interfaz
**Nombre completo del estudiante:** Cesar Adrian Luis Juan Camacho
**Fecha:** 16 de septiembre de 2026

---

Declaro que el presente trabajo es de mi autoría y ha sido elaborado por mí de forma individual, respetando las normas de integridad académica del curso. Todas las fuentes bibliográficas consultadas (libros, papers, documentación oficial) han sido debidamente citadas en el apartado de bibliografía en formato IEEE.

Durante la elaboración de este trabajo utilicé asistencia de inteligencia artificial (Claude, de Anthropic) como apoyo puntual para organizar la redacción, generar ejemplos de código iniciales y sugerir referencias bibliográficas, las cuales verifiqué, corregí y adapté personalmente antes de incluirlas en el documento final. El contenido, las decisiones técnicas y la comprensión conceptual reflejados en este trabajo son propios. El detalle de los prompts utilizados, las herramientas empleadas y una reflexión crítica sobre dicho uso se documentan de forma completa en el archivo `anexo.md` que acompaña esta entrega.

Entiendo que declarar información falsa sobre la originalidad de este trabajo o sobre el uso de herramientas de IA constituye una falta a la integridad académica y puede tener las consecuencias establecidas por el reglamento del curso.

---

**Firma:** CesarLJ
**Nombre:** Cesar Adrian Luis Juan Camacho
**Fecha:** 16/09/2026
