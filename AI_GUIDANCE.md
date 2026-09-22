
# AI_GUIDANCE.md  
**Uso responsable y profesional de Inteligencia Artificial en el curso**

## 📘 Guía para estudiantes  
Este documento establece las pautas para el uso ético, reflexivo y técnicamente riguroso de herramientas de **Inteligencia Artificial (IA)** en el contexto del desarrollo de software y hardware embebido.

---

## 🎯 Objetivo

Aprovechar herramientas de IA como apoyo en el **aprendizaje técnico, la documentación y la exploración de código**, sin sustituir la **validación experimental**, el **razonamiento ingenieril** ni el **trabajo personal** sobre plataformas de hardware reales.

---

## ✅ Usos recomendados y valorados
- Solicitar explicaciones de conceptos clave: comunicación UART, I2C, SPI, interrupciones, timers, ADC, DMA.
- Generar **ejemplos de código de referencia** en C, C++ o ensamblador.
- Explorar variantes en la implementación de controladores, protocolos o rutinas de bajo nivel.
- Apoyarse en IA para generar **comentarios explicativos** o documentación técnica del código.
- Traducir o resumir secciones complejas de manuales técnicos o datasheets.

---

## 🚫 Usos no permitidos
- Entregar código generado por IA sin comprender su funcionamiento ni realizar pruebas en hardware.
- Utilizar IA para diseñar esquemas eléctricos o temporizaciones sin consultar **fuentes oficiales ni validar experimentalmente**.
- Delegar en IA la selección de componentes o estimación de consumo energético sin análisis ingenieril.

---

## 🧠 Buenas prácticas recomendadas

1. **Valida en hardware real**  
   La IA puede generar código que compila, pero solo tú puedes verificar su funcionamiento en un entorno físico.

2. **Consulta siempre el datasheet**  
   Usa la IA como apoyo complementario, pero **la fuente oficial es el fabricante**.

3. **Transparencia profesional**  
   Declara claramente qué parte de tu trabajo fue asistida por IA.

4. **Prompts técnicos y reflexión**  
   Formula preguntas específicas y registra tus *prompts*. Evalúa críticamente las respuestas.

5. **Explora con criterio múltiples herramientas**  
   Puedes usar ChatGPT, Copilot, Perplexity, etc., pero sé selectivo y consciente de sus limitaciones.

6. **Incluye reflexión final**  
   Comenta qué aprendiste, qué ajustaste y cómo validaste tus resultados.

---

## 🎚️ Niveles de participación de IA

La transparencia total sobre el uso de IA **exime de sanción por deshonestidad académica**
(ocultar el uso es la falta grave, no usar la herramienta). Pero declarar honestamente no
exime de que la calificación refleje el aprendizaje **realmente demostrado** — se evalúa tu
comprensión, no la calidad del artefacto entregado. Este es el criterio que ya aplican
Tec de Monterrey y UNAM en sus lineamientos de IA generativa, y el que sigue este curso.

Declara en el ANEXO.md el nivel que corresponda:

| Nivel | Descripción |
|-------|-------------|
| **0 — Sin IA** | Trabajo 100% propio. |
| **1 — Consulta puntual** | Dudas conceptuales o de sintaxis; sin generación sustancial de código o texto. |
| **2 — Asistido** | La IA generó fragmentos o un borrador; tú lo reescribiste/adaptaste y puedes explicarlo línea por línea. |
| **3 — Colaborativo extenso** | La IA generó la mayor parte del código o texto; tú lo revisaste, corregiste errores y validaste personalmente en tu entorno. |
| **4 — Delegado a agente autónomo** | Un agente (Codex, Claude Code u otro con ejecución/navegación autónoma) hizo la investigación, implementación y validación con supervisión mínima directa de tu parte. |

**Si declaras nivel 3 o 4**, el ANEXO.md debe incluir además una **explicación propia**
(mínimo ~150 palabras, en tus palabras, sin apoyo de IA para redactarla) de **una decisión
técnica central** del trabajo entregado — no una reflexión genérica. Si esa explicación es
ausente, vaga, o revela que no comprendiste el punto central (p. ej. "me perdí con la lógica
del algoritmo"), la categoría de "Declaración de IA" / "Aporte Propio" de la rúbrica
correspondiente (`GRADING.md` o `REVIEW_RUBRIC.md`) se califica bajo, en proporción a esa
falta de comprensión demostrada — no en cero, y sin sanción por deshonestidad, porque
declaraste con honestidad.

Explorar herramientas nuevas (agentes autónomos, no solo copiar-pegar) es una habilidad
digital valiosa para un ingeniero en sistemas computacionales, y se valora positivamente
que la explores — siempre que puedas dar cuenta de lo que hizo la herramienta.

---

## 📝 Formato obligatorio de declaración en prácticas o proyectos

```markdown
### Asistencia de Inteligencia Artificial

- **Nivel de participación de IA**: 0–4 (ver tabla en este documento)

- **Prompts utilizados**:
  - "¿Qué registros debe preservar una función en el ABI de AArch64 y por qué x19–x28 son callee-saved?"
  - "Explica la diferencia entre `ldr x1, =msg` y `adr x1, msg` en GNU as."

- **Herramientas utilizadas**:
  - ChatGPT
  - GitHub Copilot

- **Cambios y validación**:
  - El ejemplo generado usaba `mov x2, longitud` con una etiqueta inválida; lo corregí a `mov x2, #len`.
  - Verifiqué la salida con `make test` en QEMU y después en la instancia Graviton.
  - Confirmé los números de syscall contra la tabla oficial de Linux AArch64, no contra lo que dijo la IA.

- **Reflexión personal**:
  La IA me ayudó a entender la convención de llamadas, pero inventó un número de syscall. Esto reforzó mi hábito de validar contra la documentación oficial y con `strace`.

- **Explicación propia de una decisión técnica central** *(obligatorio solo si el nivel declarado es 3 o 4)*:
  Redactada por el estudiante, sin apoyo de IA, explicando con sus propias palabras una decisión técnica central del trabajo entregado.

- **Fecha**: 2026-09-18
- **Plataforma utilizada**: AWS EC2 Graviton (Debian ARM64); verificación local con QEMU
```

---

## 🧠 Pensamiento crítico y uso responsable de LLMs

Orientar al estudiante en el uso crítico y reflexivo de LLMs (modelos de lenguaje como ChatGPT) en prácticas y proyectos académicos, asegurando que el contenido generado sea comprendido, verificado y mejorado antes de entregarlo.


### 🔹 Checklist de preguntas críticas

#### 👤 QUIÉN
- ¿Quién se beneficia de este diseño, código o propuesta?
- ¿Quién sería responsable si falla este sistema?
- ¿Quién falta en el análisis (usuarios finales, cliente, equipo de soporte)?
- ¿Quién ya resolvió un problema similar (estándares, frameworks, bibliografía)?

#### 📌 QUÉ
- ¿Qué problema técnico estoy intentando resolver realmente?
- ¿Qué parte de la respuesta de la IA son hechos comprobables y qué son suposiciones?
- ¿Qué está asumiendo la IA sin que yo lo haya validado (plataforma, librerías, contexto)?
- ¿Qué información o detalle falta (diagramas, dependencias, pruebas)?

#### 🕒 CUÁNDO
- ¿Cuándo debe tomarse esta decisión técnica?
- ¿Cuándo en el ciclo de vida del software es más apropiado aplicar esta solución?
- ¿Cuándo he visto errores similares en otros proyectos?
- ¿Cuándo sería riesgoso implementar lo que propone la IA?

#### 🌍 DÓNDE
- ¿De dónde provienen los datos o ejemplos que usó la IA?
- ¿Dónde se implementará este sistema (nube, local, IoT) y cambia eso la validez?
- ¿Dónde puede fallar este diseño (rendimiento, seguridad, escalabilidad)?
- ¿Dónde encuentro documentación oficial o pruebas que lo respalden?

#### ❓ POR QUÉ
- ¿Por qué este enfoque es mejor que otras alternativas?
- ¿Por qué creo que la salida es correcta y no un error del modelo?
- ¿Por qué otros podrían verlo distinto (otro lenguaje, paradigma, contexto)?
- ¿Por qué no hemos resuelto esto con técnicas tradicionales ya conocidas?

#### ⚙️ CÓMO
- ¿Cómo mediré el éxito de implementar esta propuesta (tests, benchmarks, validación)?
- ¿Cómo podría fallar este código en producción?
- ¿Cómo pruebo la validez de lo que me dio la IA antes de usarlo?
- ¿Cómo explicaré mi decisión de usar IA a mis compañeros, profesor o cliente?


### 📌 Ejemplos de aplicación en cursos
- Lenguajes de Interfaz (ARM/Assembly):
Si la IA genera un programa, preguntar:
“¿Qué registros preserva y dónde lo verifico en el ABI oficial de ARM?”
- Patrones de Diseño (GoF en C#):
Si la IA sugiere Singleton, cuestionar:
“¿Por qué elegir este patrón y no otro? ¿Dónde sería un antipatrón en sistemas distribuidos?”
- Bases de Datos:
Si la IA entrega un query SQL:
“¿Cómo afectará el rendimiento en tablas grandes? ¿Qué índices faltan?”
- Cultura Digital – IoT con micro:bit:
Si la IA genera un script:
“¿Cómo sé que maneja errores de hardware? ¿Dónde lo pruebo antes de cargarlo al dispositivo?”


### 📝 Responsabilidad académica
1. Documentar en ANEXO.md:
- Prompts utilizados.
- Cambios o mejoras realizadas tras usar pensamiento crítico.
- Referencias oficiales o pruebas adicionales consultadas.
2. Reflexionar:
- ¿Qué sesgos, errores o vacíos encontré en la respuesta de la IA?
- ¿Qué aprendí del proceso de revisión?