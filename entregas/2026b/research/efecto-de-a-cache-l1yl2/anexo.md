# Bitácora de Uso de Inteligencia Artificial y Referencias IEEE

## 1. Registro de Prompts y Respuestas (Prompts Reales)

### Prompt 1
* **Entrada del usuario:** *"Explicación del efecto de la caché L1/L2 al recorrer matrices en C por filas vs columnas con análisis de líneas de caché de 64 bytes."*
* **Uso de la respuesta:** Se utilizó la estructura teórica sobre el cálculo de direcciones y la tasa de fallos de caché ($1/16$ vs $100\%$) para redactar las Secciones 2 y 3 del documento principal.

### Prompt 2
* **Entrada del usuario:** *"Genera una tabla comparativa en Markdown entre el acceso row-major y column-major evaluando patrones de acceso, L1 misses y tiempo relativo."*
* **Uso de la respuesta:** Sirvió de base para sintetizar la tabla presentada en la Sección 4.

---

## 2. Reflexión Honesta sobre el Uso de IA
La herramienta de Inteligencia Artificial facilitó la estructuración rápida del contenido y la generación de la tabla comparativa. Sin embargo, se realizaron las siguientes revisiones y adiciones manuales para garantizar el rigor académico:
* Se verificaron manualmente las operaciones matemáticas de direccionamiento de memoria para arreglos en C.
* Se profundizaron los conceptos de *Hardware Prefetching* y la técnica de *Tiling/Blocking*, los cuales no habían sido detallados adecuadamente en la respuesta inicial de la IA.
* Se redactaron las conclusiones y el análisis crítico desde la perspectiva propia para dar coherencia y evitar un tono genérico.

---

## 3. Bibliografía IEEE

* [1] J. L. Hennessy and D. A. Patterson, *Computer Architecture: A Quantitative Approach*, 6th ed. Cambridge, MA, USA: Morgan Kaufmann, 2017.
* [2] U. Drepper, "What Every Programmer Should Know About Memory," Red Hat, Inc., Tech. Rep., 2007.
* [3] R. Bryant and D. O'Hallaron, *Computer Systems: A Programmer's Perspective*, 3rd ed. Boston, MA, USA: Pearson, 2015.
* [4] Intel Corporation, "Intel® 64 and IA-32 Architectures Optimization Reference Manual," Order No. 248966-046, Apr. 2023.
