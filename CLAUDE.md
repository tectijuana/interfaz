# CLAUDE.md — Curso Lenguajes de Interfaz (SCC-1014)

Este repositorio es el curso de lenguaje ensamblador (ARM64/ARM32 y RISC-V) del TecNM campus
Instituto Tecnológico de Tijuana. **Quien trabaja en este repo con Claude Code es el docente**
(mantenimiento del curso, creación de material, revisión de entregas). Las reglas de IA para
estudiantes están en `AI_GUIDANCE.md` y se aplican a sus entregas, no a este flujo.

## Trabajo típico del docente

- **Crear/actualizar material**: lecciones y prácticas nuevas parten de `templates/`
  (en particular `templates/practica-verificable/` para toda práctica con código).
  Contenido en español, siguiendo el estilo del repo.
- **Generar variantes de problemas por alumno**: base en
  `units/U01.4-8bitComputer/BANCO-PROBLEMAS.md` (45 enunciados en 6 categorías A–F).
  Cada variante cambia datos/salida esperada (`tests/expected.txt`).
- **Revisar PRs de estudiantes**: aplicar `REVIEW_RUBRIC.md` y la rúbrica de `GRADING.md`
  (funcionamiento con `make test`, ABI/registros, estilo según `docs/estilo_codigo.md`,
  documentación, declaración de IA en `ANEXO.md`). El CI ya corre `make test` en cada PR
  que toca `practicas/`.
- **Mantener calendario y evaluación**: `SCHEDULE.md` (borrador ago–dic 2026, fechas por
  confirmar con calendario oficial TecNM), `GRADING.md`, `SYLLABUS.md`.

## Reglas del repositorio

- **Datos personales**: `entregas/` contiene trabajos históricos de alumnos con nombres y
  números de control — es referencia interna; no migrar nombres ni calificaciones a material
  público nuevo, y no usarlo como fuente de soluciones para enunciados vigentes.
- **Toda práctica es verificable**: Makefile + `tests/expected.txt` + `make test` (patrón de
  `templates/practica-verificable/`); debe pasar en ARM64 nativo y en QEMU.
- Nomenclatura: unidades `U##-nombre`, prácticas `P##-nombre`, kebab-case, sin espacios.
- Al diseñar prácticas, incluir defensa anti-copia: variantes por alumno, evidencia asciinema
  y preguntas de defensa en el README (ver `practicas/P01-hola-arm64/`).

## Contexto técnico

- Plataformas: AWS EC2 Graviton (Debian/Ubuntu ARM64), Raspberry Pi, QEMU (`qemu-aarch64`)
  para x86_64; Raspberry Pico 2W para prácticas con hardware.
- Toolchain: `as`, `ld`, `gcc`, `gdb` + GEF. Setup en `units/U01.1-setupCompilador/compilador.sh`;
  alternativas (Termux, iPhone+VPN, Docker) en `units/U01.2-*` y `docs/entorno/`.
- Verificación local sin ARM64: contenedor Debian con
  `binutils-aarch64-linux-gnu qemu-user make` y correr `make test`.

## Estructura

- `units/U01…U04` — contenido docente por unidad; `lecturas/` son los capítulos teóricos
  (rescatados del acervo 2024, ARM64/RPi).
- `docs/lecturas-avanzadas/` — capítulos avanzados (caché, virtualización, multinúcleo, SO):
  material optativo/proyecto final.
- `practicas/P##-*` — prácticas verificables. `entregas/` — histórico de alumnos.
- Gobernanza: `GRADING.md`, `REVIEW_RUBRIC.md`, `CONTRIBUTING.md`, `AI_GUIDANCE.md`, `templates/`.
