## Prompts reales utilizados y resultados obtenidos

### Prompt 1
> "Mi tema asignado es el número 8 de la lista de investigación: Sentencias
> switch/case mediante tablas de saltos en ARM64. Ayúdame a entenderlo e
> investigarlo."

**Resultado:** Explicación general del mecanismo de jump tables: por qué el
compilador las usa en lugar de comparaciones encadenadas cuando los valores
de los casos son consecutivos, y qué ventaja de rendimiento ofrece (O(1) en
lugar de O(n)).

### Prompt 2
> "Busca fuentes técnicas confiables y actualizadas sobre la implementación
> de jump tables en ARM64/AArch64 para usarlas como bibliografía."

**Resultado:** Búsqueda web dirigida a documentación oficial de ARM Developer
(instrucciones A64: `ADR`, `LDRSW`, `BR`), un artículo técnico especializado
en AArch64 del blog de ingeniería de Microsoft, y un repositorio educativo de
GitHub centrado en jump tables para ARM64.

### Prompt 3
> "Con esas fuentes, genera un borrador de README.md que incluya introducción,
> desarrollo técnico de al menos 500 palabras, conclusiones y bibliografía en
> formato IEEE, siguiendo la rúbrica de la tarea."

**Resultado:** Borrador estructurado que describe el flujo completo de
instrucciones (validación de rango, cálculo de dirección base con `adr`,
lectura de desplazamiento con `ldrsw`, salto indirecto con `br`), con un
ejemplo de código ensamblador comentado y 4 referencias en formato IEEE.

### Prompt 4
> "Tengo dudas sobre la estructura de carpetas correcta en el repositorio
> del curso y sobre un bloque de metadata que vi en otro archivo; ¿aplica a
> mi entrega?"

**Resultado:** Aclaración de la ruta correcta dentro del fork
(`entregas/2026b/research/<nombre-del-tema>/`), corrección de una carpeta
duplicada creada por error, y explicación de que la tabla de metadata (YAML
frontmatter) pertenecía únicamente al documento de la lista de 41 temas, no
a las entregas individuales.
