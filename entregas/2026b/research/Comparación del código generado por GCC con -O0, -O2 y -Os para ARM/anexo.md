### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - Gemini: "Que es el gcc para ARM"
  - Gemini: "Como funciona el codigo gcc en -O0, -O2 y -Os"
  - Claude: "Hazme esto en formato .md y markdown, las referencias cambialas a IEEE."

- **Herramientas utilizadas**:
  - Gemini
  - Claude

- **Cambios y validación**:
  - El borrador inicial afirmaba que cada iteración del bucle en `-O0` hacía 12 accesos a memoria. Al contar las instrucciones del listado resultaron ser 9, y lo corregí.
  - El código de `-Os` usaba `cbz` junto con `subs`/`bne`, lo cual no equivale a `i < n` cuando `n` es negativo. Lo reemplacé por `cmp r1, #0` + `ble`.
  - Corregí varias afirmaciones técnicas del borrador: `-O2` no activa `-funroll-loops`, `-Os` no selecciona Thumb-2 (eso lo determinan `-mthumb`, `-march` o `-mcpu`), y GIMPLE no es un AST sino una representación de tres direcciones en SSA.
  - Reemplacé el rango "40 %–70 % de reducción de tiempo" por una formulación cualitativa, porque no encontré una cifra universal que lo respalde.
  - Las referencias las generó la IA de memoria, así que solo las verifique.
 
- **Reflexión personal**:
  La IA me ayudó a estructurar la investigación y a encontrar fuentes, pero el borrador inicial contenía errores que solo detecté al revisar el ensamblador línea por línea, como el conteo de accesos a memoria y un bucle incorrecto para valores negativos. Sobre el tema, concluyo que no existe un nivel de optimización universalmente mejor. `-O0` sirve solo para depurar, `-O2` es el equilibrio habitual cuando hay memoria de sobra, y `-Os` es la opción natural en microcontroladores con Flash y SRAM limitadas, aunque su ventaja de velocidad depende de la caché y de la Flash del dispositivo. Por eso la decisión final debe apoyarse en mediciones sobre el hardware real y no solo en la teoría.

- **Fecha**: 2026-09-19
- **Plataforma utilizada**: Gemini y Claude
