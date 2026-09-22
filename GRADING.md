# Evaluación y Rúbricas

## Ponderaciones
- Prácticas (P01–P06): 40%
- Quizzes/Evaluaciones: 15%
- Participación y peer-review: 10%
- Proyecto Final: 35%

> **P07–P09** (prácticas de hardware con Pico 2W, Unidad 4) se evalúan dentro del
> **Proyecto Final**: son sus hitos técnicos y usan la misma rúbrica de abajo con el
> criterio de funcionamiento adaptado a hardware (ver nota en la rúbrica y el
> `rubrica.md` de cada práctica).

## Rúbrica general de prácticas (100 pts)
- **Funcionamiento verificable (30 pts):** el programa ensambla sin errores y `make test` pasa **en el entorno del alumno** (ARM64 nativo o QEMU); evidencia de ejecución con asciinema o corrida en hardware real. *En prácticas de hardware sin `make test` (P07–P09), estos puntos se ganan con la evidencia definida en el `rubrica.md` de la práctica (video/captura Wokwi + mediciones + asciinema del REPL).*
- **Uso correcto de la arquitectura (25 pts):** convenciones de llamada (ABI), preservación de registros, manejo correcto de pila y modos de direccionamiento apropiados.
- **Calidad de código (20 pts):** encabezado del programador, etiquetas y comentarios claros, estructura legible según `docs/estilo_codigo.md`.
- **Documentación (15 pts):** README de la práctica con instrucciones de compilación/ejecución, conclusiones y observaciones al final.
- **Declaración de IA (10 pts):** ANEXO.md con nivel de participación (0–4), prompts utilizados, cambios realizados y validación, conforme a `AI_GUIDANCE.md`. Nivel declarado 3–4 sin una "Explicación propia de una decisión técnica central" adecuada en el ANEXO.md: estos 10 pts se califican en proporción a la comprensión propia demostrada ahí, no a la calidad del código/documento entregado. Sin nivel declarado: 2/10.

Cada práctica puede extender esta rúbrica en `practicas/*/rubrica.md`.
