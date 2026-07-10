# P02 — Modos de direccionamiento en ARM64

**Unidad:** U1 — Introducción al Lenguaje Ensamblador (subtema 1.6)
**Objetivo:** distinguir y usar los modos de direccionamiento de AArch64: inmediato,
carga literal, registro base, base+desplazamiento, pre-indexado y post-indexado.

## Cómo funciona el programa
`src/main.s` recorre la cadena `"ABCDE"` y cada línea de la salida demuestra un modo:

| Salida | Modo | Instrucción |
|:--:|---|---|
| `@` | Inmediato | `mov w2, #'@'` |
| `A` | Post-indexado | `ldrb w2, [x4], #1` — lee y **después** avanza |
| `B` | Registro base | `ldrb w2, [x4]` |
| `D` | Base + desplazamiento | `ldrb w2, [x4, #2]` — x4 no cambia |
| `E` | Pre-indexado | `ldrb w2, [x4, #3]!` — avanza y **después** lee |

## Enunciado
1. Ejecuta `make test` y verifica que pasa; sigue el programa instrucción por instrucción
   con GDB+GEF observando cómo cambia `x4` en cada modo (`si` + `registers`).
2. **Tu variante**: cambia la cadena de datos por las 5 letras de tu apellido (o tu nombre)
   y ajusta desplazamientos y `tests/expected.txt` para demostrar los mismos 5 modos
   **sin repetir ninguna letra en la salida**.
3. Graba la sesión GDB con asciinema y agrega el enlace aquí.
4. Llena `ANEXO.md` (declaración de IA obligatoria).

## Preguntas de defensa (respóndelas en tus conclusiones)
- ¿Qué valor queda en `x4` al terminar y por qué?
- ¿Por qué post-indexado lee la **misma** dirección que registro base si se ejecutan seguidos?
- ¿Qué modo usarías para recorrer un arreglo en un ciclo y por qué?
- `ldr x4, =datos` no es una instrucción real de carga inmediata — ¿qué genera el ensamblador?
