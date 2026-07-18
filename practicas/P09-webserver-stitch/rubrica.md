# P09 — Rúbrica específica

Extiende la rúbrica general de `GRADING.md`. Solo cambia cómo se ganan los
**30 pts de funcionamiento verificable** (no hay `make test` en hardware):

| Evidencia | Pts |
|---|---:|
| Pico 2W en WiFi sirviendo el dashboard; IP reportada en OLED o serial | 6 |
| Endpoints `GET /` , `GET /api/temp` (JSON) y `POST /led` funcionando; `fetch()` cada 2 s | 8 |
| Video del navegador (celular) controlando el circuito en vivo | 6 |
| Conversión ADC→décimas de °C en `@micropython.asm_thumb` con el escalado documentado | 6 |
| Cuarto endpoint de la variante asignada al equipo | 4 |

La comparación "diseño original vs lo servido" (Stitch u otra herramienta, ver README)
cuenta en el criterio de documentación. Los demás criterios aplican igual que en
`GRADING.md`.
