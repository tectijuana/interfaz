# P07 — Rúbrica específica

Extiende la rúbrica general de `GRADING.md`. Solo cambia cómo se ganan los
**30 pts de funcionamiento verificable** (no hay `make test` en hardware):

| Evidencia | Pts |
|---|---:|
| OLED (o Wokwi) mostrando nombre y número de control con `framebuf.text()` | 8 |
| `invertir()` funcionando en ambas versiones (Python puro y `asm_thumb`), video/gif o captura Wokwi | 8 |
| Tabla de mediciones con `time.ticks_us()` y speedup reportado; asciinema del REPL | 8 |
| Operación de la variante asignada (limpiar / espejo / scroll / ajedrez) funcionando | 6 |

Los demás criterios (ABI/arquitectura, calidad de código, documentación, ANEXO de IA)
aplican igual que en `GRADING.md`. Las preguntas de defensa del README son parte de
la documentación.
