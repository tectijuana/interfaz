# P08 — Rúbrica específica

Extiende la rúbrica general de `GRADING.md`. Solo cambia cómo se ganan los
**30 pts de funcionamiento verificable** (no hay `make test` en hardware):

| Evidencia | Pts |
|---|---:|
| Lectura del sensor interno `ADC(4)` convertida a °C con la fórmula del datasheet documentada | 6 |
| UART0 a 115200 8N1 transmitiendo la trama `TEMP,<no.control>,<celsius>\r\n` cada segundo | 8 |
| Recepción demostrada en la modalidad elegida (laptop con `screen`/`minicom` + asciinema, segundo Pico, o monitor de Wokwi) | 8 |
| Checksum XOR en `@micropython.asm_thumb` verificado en el receptor | 8 |

La variante (umbral de alarma y periodo de muestreo asignados) debe corresponder a la
del equipo. Los demás criterios aplican igual que en `GRADING.md`.
