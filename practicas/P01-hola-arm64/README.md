# P01 — Hola Mundo en ARM64 (práctica piloto verificable)

**Unidad:** U1 — Introducción al Lenguaje Ensamblador
**Objetivo:** ensamblar, ligar y ejecutar tu primer programa ARM64 usando llamadas al sistema
de Linux (`write`, `exit`), y validar la salida con `make test`.

## Enunciado
1. Completa el encabezado de `src/main.s` con tus datos.
2. Modifica el mensaje para que imprima: `Hola <TuNombre> desde ARM64` (ajusta `tests/expected.txt`).
3. Ejecuta `make test` hasta que pase en verde.
4. Graba la corrida con asciinema (`asciinema rec p01.cast -c "make test"`) y agrega el enlace aquí.
5. Llena `ANEXO.md` con tu declaración de IA (obligatoria, ver `AI_GUIDANCE.md`).

## Entrega
Publica un **Gist** en tu cuenta de GitHub con la práctica completa (`main.s`,
`Makefile`, `expected.txt`, este README con tus respuestas y `ANEXO.md`) y reporta
la URL en **iDoceo Connect o Google Classroom** (ver "Entrega de prácticas
(estudiantes)" en `CONTRIBUTING.md`). Corre `make test` en tu entorno y adjunta la
evidencia asciinema; la rúbrica completa está en `GRADING.md`.

## Preguntas de defensa (respóndelas en tus conclusiones)
- ¿Qué hace `svc #0` y por qué `x8` lleva el número de syscall?
- ¿Qué pasa si `x2` (longitud) es mayor que el tamaño real del mensaje? Pruébalo.
- ¿Qué registros debe preservar tu programa según el ABI de AArch64?
