# Evaluación y Rúbricas

## Ponderaciones
- Prácticas (P01–P06): 40%
- Quizzes/Evaluaciones: 15%
- Participación y peer-review: 10%
- Proyecto Final: 35%

## Rúbrica general de prácticas (100 pts)
- **Funcionamiento verificable (30 pts):** el programa ensambla sin errores y `make test` pasa (local, QEMU o CI); evidencia de ejecución con asciinema o corrida en hardware real.
- **Uso correcto de la arquitectura (25 pts):** convenciones de llamada (ABI), preservación de registros, manejo correcto de pila y modos de direccionamiento apropiados.
- **Calidad de código (20 pts):** encabezado del programador, etiquetas y comentarios claros, estructura legible según `docs/estilo_codigo.md`.
- **Documentación (15 pts):** README de la práctica con instrucciones de compilación/ejecución, conclusiones y observaciones al final.
- **Declaración de IA (10 pts):** ANEXO.md con prompts utilizados, cambios realizados y validación, conforme a `AI_GUIDANCE.md`.

Cada práctica puede extender esta rúbrica en `practicas/*/rubrica.md`.
