# Anexo: Bitácora de uso de LLM

## 1. Prompts reales utilizados

### 1.1. Prompt principal

Se utilizó el siguiente prompt para solicitar la generación de la investigación:

> Actúa como un experto en Arquitectura de Computadores, Lenguaje Ensamblador y Compiladores para la arquitectura ARM64 (AArch64).
>
> Necesito que redactes una investigación completa en formato Markdown sobre el tema: "Sentencias switch/case mediante tablas de saltos en ARM64".
>
> El contenido debe cumplir estrictamente con los criterios de estructura y contenido:
>
> * Generar un archivo `README.md` con título, introducción, desarrollo técnico de mínimo 500 palabras, conclusiones y bibliografía en formato IEEE con 3 a 5 referencias académicas o documentación oficial técnica.
> * Explicar el mecanismo de tablas de saltos en ARM64 e incluir instrucciones como `ADRP`, `ADD`, `LDR`, `BR` y `LDRSW`.
> * Presentar un ejemplo práctico en C y su correspondiente traducción o desensamblado ARM64.
> * Analizar rendimiento, accesos a memoria, predicción de saltos y criterios de selección del compilador.
> * Generar un archivo `anexo.md` con prompts utilizados, resultados obtenidos y reflexión crítica sobre el uso de la IA.
> * Mantener un tono académico y técnico.

### 1.2. Estrategia de prompting

La estrategia consistió en formular una instrucción principal estructurada, delimitando el tema, la arquitectura objetivo, los entregables, la extensión mínima y los criterios técnicos de evaluación.

Se establecieron requisitos explícitos para reducir respuestas demasiado generales y orientar la generación hacia una investigación que relacionara el lenguaje C, el ensamblador AArch64 y las decisiones de optimización del compilador.

No se documentan prompts adicionales como si hubieran sido ejecutados realmente. La organización del contenido y la revisión crítica se consideran parte del proceso de elaboración y validación del resultado.

---

## 2. Resultados obtenidos

La IA generó una investigación organizada en secciones, con explicaciones conceptuales y técnicas sobre las tablas de saltos en ARM64.

Los principales resultados fueron:

| Elemento solicitado    | Resultado obtenido                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------------------ |
| Introducción           | Explicación de las diferencias entre comparaciones secuenciales y tablas de saltos.                          |
| Desarrollo técnico     | Descripción del funcionamiento de las tablas, el cálculo de índices y la transferencia indirecta de control. |
| Instrucciones AArch64  | Explicación del uso de `ADRP`, `ADD`, `LDRSW`, `CMP`, `B.HI` y `BR`.                                         |
| Ejemplo en C           | Implementación de una función con `switch/case` y un caso predeterminado.                                    |
| Ejemplo en ensamblador | Fragmento ilustrativo con tabla de desplazamientos relativos de 32 bits.                                     |
| Rendimiento            | Análisis de accesos a memoria, predicción de saltos, densidad de casos y tamaño de las tablas.               |
| Conclusiones           | Síntesis del impacto de esta optimización en el compilador y el procesador.                                  |
| Bibliografía           | Referencias a documentación técnica de Arm, GCC, LLVM y AAPCS64.                                             |
| Anexo                  | Registro de la estrategia de prompting y reflexión crítica sobre el uso de LLM.                              |

El resultado permite disponer de una base documental que puede ampliarse con pruebas reales de compilación, mediciones de rendimiento y referencias bibliográficas verificadas.

---

## 3. Reflexión crítica

### 3.1. ¿Ayudó la IA en el proceso?

Sí. La IA facilitó la estructuración de la investigación y la explicación de un tema que requiere relacionar conceptos de compiladores, lenguaje ensamblador y arquitectura de computadores.

También permitió generar un ejemplo de código C y una representación ilustrativa en ensamblador ARM64, lo que ayuda a comprender cómo una estructura de control de alto nivel puede convertirse en operaciones de bajo nivel.

Su principal aportación fue acelerar la elaboración del documento y ofrecer una base conceptual organizada. Sin embargo, la generación automática no sustituye la comprobación del código ni la consulta de documentación técnica oficial.

### 3.2. ¿Hubo sesgos, hallazgos imprecisos o errores en las instrucciones ARM64 corregidos manualmente?

La principal limitación que debe considerarse es que la IA puede presentar una implementación ilustrativa como si fuera una traducción exacta del compilador. En realidad, GCC y Clang pueden generar diferentes secuencias de instrucciones según la versión, las opciones de optimización y el contexto del programa.

Por ello, es importante distinguir entre un ejemplo de ensamblador válido como representación conceptual y una salida obtenida mediante compilación real.

En la revisión técnica deben considerarse especialmente los siguientes aspectos:

* `LDRSW` realiza una carga de 32 bits con extensión de signo a 64 bits.
* `BR` utiliza una dirección contenida en un registro para transferir el control.
* `ADRP` obtiene una dirección relativa a una página, por lo que normalmente requiere una instrucción complementaria para formar la dirección completa.
* Los desplazamientos relativos de una tabla deben interpretarse respecto de la base utilizada por la implementación.
* La generación de una tabla de saltos no está garantizada por la presencia de una sentencia `switch`.

El ensamblador presentado es ilustrativo y coherente con ese mecanismo, pero no se afirma que haya sido ensamblado o ejecutado experimentalmente. Una validación adicional mediante un compilador cruzado AArch64 permitiría confirmar la sintaxis y contrastar la implementación con el código generado.

### 3.3. ¿Qué tan precisa fue en el formato IEEE y las 500 palabras mínimas?

La respuesta fue estructurada con una bibliografía numerada siguiendo el estilo general IEEE y con referencias a documentación oficial relevante.

No obstante, la inclusión de enlaces oficiales no garantiza por sí sola el cumplimiento estricto de todos los requisitos bibliográficos IEEE. Para una entrega definitiva, deben comprobarse los títulos, versiones, fechas de publicación, fechas de consulta y demás datos editoriales disponibles.

Respecto al desarrollo técnico, se elaboró un apartado extenso que supera el mínimo solicitado de 500 palabras. Aun así, el cumplimiento debe comprobarse sobre el archivo final, considerando qué secciones cuentan para la extensión requerida según los criterios del docente.

En conclusión, la IA fue útil para producir una primera versión estructurada, pero la calidad académica final depende de la revisión humana, la verificación de las referencias y la comprobación técnica del código.

---

## 4. Consideración final

El uso de un LLM en esta investigación se considera una herramienta de apoyo para la redacción, organización y comprensión de conceptos técnicos. La responsabilidad de validar la información, comprobar la implementación ARM64 y garantizar la integridad académica del documento corresponde al estudiante.
