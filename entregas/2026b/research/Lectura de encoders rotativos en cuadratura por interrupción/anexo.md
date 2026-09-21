# Anexo — Bitácora de uso de LLM

En este documento se registra el uso de un modelo de lenguaje (LLM) como una herramienta de apoyo correspondiente a la realización del trabajo de investigación del tema **Lectura de Encoders Rotativos en Cuadratura por Interrupción**.
Se hace documentación de los prompts utilizados, los resultados obtenidos y una reflexión crítica acerca de su uso y posibles sesgos encontrados al momento de su utilidad.

## 1. Herramienta de IA utilizada

**Modelo:** Gemini (Google)  
**Fecha de consulta:** 20 de septiembre de 2026  
**Uso principal:** Formulación, estructuración y generación del archivo `README.md`, creación de diagramas ilustrativos y cuadros informativos.

---

## 2. Registro de prompts y resultados obtenidos.

### Prompt 1 - Creación y estructura del README.md

> "Necesito realizar un trabajo de investigación en formato markdown para la materia de lenguajes de interfaz, acerca del siguiente tema: Lectura de encoders rotativos en cuadratura por interrupción. Ayúdame a estructurar la investigación junto con los temas/puntos mas importantes. y bien detallados. Añade y señala espacios en blanco para agregar imagenes, diagramas y cuadros informativos posteriormente".

**Resultado obtenido:** un archivo README.md con las estructura de la investigación formada por una introducción, desarrollo técnico dividido en varias secciones, espacios dedicados para diagramas de apoyo visual y cuadros informativos.

---

### Prompt 2 - Generación de diagrama "Diagrama de tiempos de ondas cuadradas A y B, y fases para sentido CW y CCW"

> "Genera un diagrama de tiempos mostrando las ondas cuadradas A y B desplazadas 90 grados, indicando las fases 00, 01, 11, 10 para sentido CW y CCW."

**Resultado obtenido:** Un gráfico que ilustra las señales digitales de los canales A y B para determinar el sentido de giro mediante un desfase de 90°: muestra cómo en **rotación horaria (CW)** la secuencia de estados transita por `00 → 01 → 11 → 10` (el Canal A se adelanta al Canal B), mientras que en **rotación antihoraria (CCW)** la secuencia se invierte a `00 → 10 → 11 → 01` (el Canal B se adelanta al Canal A), permitiendo identificar la dirección del movimiento a partir de los flancos de subida y bajada de las señales.

---

### Prompt 3 - Generación de tabla comparativa acerca de modo de decodificación, eventos por ciclo, ventajas, desventajas y carga computacional para la CPU

> "Crea una tabla comparativa que incluya: Modo de Decodificación, Eventos por Ciclo, Ventajas, Desventajas y Carga Computacional para la CPU."

**Resultado obtenido:**  Una tabla comparativa que contrasta los modos **1X**, **2X** y **4X** evaluando sus eventos por ciclo, ventajas, desventajas y carga para la CPU: muestra cómo el **Modo 1X** ofrece un algoritmo muy simple y carga muy baja sacrificando resolución física (25%), el **Modo 2X** duplica la resolución con una carga moderada al detectar ambos flancos en un pin, y el **Modo 4X** ofrece la máxima resolución posible al aprovechar todos los estados de la cuadratura a costa de una carga computacional alta (cuatriplica las interrupciones) y mayor sensibilidad a variaciones en la señal.

---

### Prompt 4 - Generación de diagrama de secuencias de llamadas de retorno y control de flujo en la suspensión y reanudación de un stream

> "Genera un esquema eléctrico del circuito de filtrado RC (Resistencia-Capacitor) y Schmitt Trigger conectado entre el encoder y el pin de interrupción del microcontrolador."

**Resultado obtenido:** Un esquema eléctrico que muestra acondicionamiento de la señal proveniente del canal del encoder (**Encoder Channel Output**), utilizando una resistencia de pull-up ($R_{pullup}$) para asegurar niveles lógicos estables y un filtro pasivo pasa-bajas formado por $R_{filter}$ y $C_{filter}$ para eliminar el ruido eléctrico. 

---

### Prompt 5 - Generación de una matriz de transición de estados.

> "Genera una matriz de estados simplificada en formato de tabla (Índice de 0 a 15, Estado Previo, Estado Actual, Acción: +1, -1, 0 o Error por cambio doble de estado)"

**Resultado obtenido:**  Una tabla para decodificación de cuadratura que define las 16 combinaciones posibles entre el estado previo ($A_p B_p$) y el estado actual ($A_a B_a$) del encoder para determinar la acción correspondiente: asigna un valor de **+1** para avances en sentido horario (CW), **-1** para sentido antihorario (CCW), **0** cuando no hay cambio de estado, y **0 (Error)** para transiciones inválidas donde ambos canales cambian simultáneamente, permitiendo actualizar el conteo de posición de forma rápida y eficiente en código.

---

### Prompt 6 - Generación de una gráfica visual sobre el porcentaje de uso de la CPU vs la frencuencia de pulsos del encoder.

> "Genera una gráfica visual del porcentaje de uso de la CPU vs. Frecuencia de pulsos del Encoder (demostrando la saturación por interrupciones a altas RPM)"

**Resultado obtenido:**  Un gráfico que demuestra cómo el **Manejo por Interrupciones GPIO en Modo 4X** incrementa la carga de procesamiento exponencialmente conforme aumenta la frecuencia/velocidad, superando el límite de tiempo real (~80%) e ingresando a una **zona de saturación de CPU** y pérdida de pulsos hacia los 20,000 Hz (~4800 RPM).

---

## 3. Reflexión crítica general

### ¿Ayudó?
La utilización del modelo de lenguaje (LLM) demostró ser altamente eficiente y un catalizador clave para la estructuración y desarrollo del trabajo de investigación. Sus principales aportes fueron:

1. **Estructuración técnica rigurosa:** Permitió organizar de manera lógica y coherente temas complejos de nivel de registro y hardware, adaptados al nivel académico de la materia de *Lenguajes de Interfaz*.
2. **Generación de código optimizado:** Proporcionó directamente la lógica de decodificación por matriz de transiciones (*state machine*) y operaciones a nivel de bits (*bitwise*), ahorrando tiempo en el diseño algorítmico básico de la ISR.
3. **Apoyo gráfico e icónico:** Generó esquemáticos eléctricos, diagramas de tiempo y gráficas de rendimiento cuantitativo de CPU que facilitaron la visualización gráfica de los conceptos teóricos.
4. **Formato e integración:** Automatizó la redacción fluida en sintaxis Markdown, el formateo de ecuaciones matemáticas en LaTeX y la estructuración de referencias en estándar IEEE.

### ¿Hubo sesgos o errores?
Durante la interacción con la herramienta se identificaron algunos puntos de atención y errores menores que requirieron intervención humana:

1. **Sintaxis de LaTeX en visores Markdown:** El modelo generó inicialmente expresiones matemáticas en bloque utilizando guiones bajos directos dentro de etiquetas de texto (por ejemplo, `T_{\text{ISR\_ejecución}}`), lo cual causaba errores de renderizado en plataformas como GitHub (*math rendering error*). Esto requirió corregir las etiquetas a texto plano o escapar adecuadamente los caracteres.
2. **Sesgo hacia la simplificación de código:** En las primeras iteraciones de código, la IA tendía a entregar ejemplos genéricos de alto nivel (como funciones del ecosistema Arduino) en lugar de rutinas orientadas a registros y arquitecturas específicas, por lo que fue necesario refinar las instrucciones para obtener código cercano al nivel de interfaz de hardware.

### Conclusión del uso de la herramienta LLM
El uso del LLM no sustituyó el criterio técnico ni el conocimiento en sistemas embebidos, pero actuó como un **asistente de investigación y coautor técnico sumamente efectivo**. 

La herramienta permitió acelerar de forma notable las fases de maquetación, síntesis teórica y desarrollo de recursos visuales, permitiendo al usuario enfocarse en la validación conceptual, la corrección del formato y el análisis crítico de la ingeniería involucrada. En conclusión, la integración de la IA en este tipo de trabajos académicos optimiza la productividad siempre y cuando exista una revisión humana informada que corrija las inconsistencias de formato y garantice la precisión técnica.

