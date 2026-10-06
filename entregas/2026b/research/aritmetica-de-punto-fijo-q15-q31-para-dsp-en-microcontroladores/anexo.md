# Declaración de uso de IA

- **Herramienta:** Claude Code (Anthropic), modelo Claude Sonnet 5.5.
- **Autoría:** este documento fue redactado por Claude Code a petición del docente, que decidió unificar dos entregas del ciclo 2026b que trataban el mismo tema.
- **Origen del contenido:** síntesis de ambas entregas, sin contenido nuevo de fuentes externas. Se conservaron los ejemplos numéricos, las comparaciones, los ejemplos de CMSIS-DSP y las referencias de ambos trabajos, eliminando lo repetido. Las entregas originales siguen en el historial de git.

## Validación realizada

- Se recalcularon los ejemplos numéricos: $0.75 \to 24576$ (`0x6000`) en Q15; $0.75 \to 1610612736$ (`0x60000000`) y $0.5 \to 1073741824$ (`0x40000000`) en Q31; $24576 \times -16384 = -402653184$ y $-402653184 \gg 15 = -12288$ ($-0.375$).
- Se corrigieron errores de las entregas originales: un valor `245760` que debía ser `24576`, el nombre del autor *Zölzer* y la notación de las ecuaciones del FIR.

## Limitaciones

- **No se consultó la documentación de CMSIS-DSP/CMSIS-Core** durante esta unificación. Las afirmaciones sobre funciones, acumuladores (34.30 y 2.62) y saturación provienen de las entregas y siguen sin comprobarse contra Arm.
- **No se ejecutó nada en hardware ARM real ni en emulación.** No se presentan mediciones de rendimiento ni de ciclos.
- Las URL de las referencias [3], [4] y [7] no se indicaron en las entregas; falta completarlas.
