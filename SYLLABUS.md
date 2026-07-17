# Syllabus — Lenguajes de Interfaz (SCC-1014)

**Duración:** 16 semanas (agosto–diciembre 2026)  
**Modalidad:** Teórico–práctico con laboratorio  
**SATCA:** 2-2-4  
**Carrera:** Ingeniería en Sistemas Computacionales

## Descripción
Curso centrado en la programación en lenguaje ensamblador y lenguajes de bajo nivel para arquitecturas **ARM (32/64 bits)** y **RISC-V**, orientado al diseño de interfaces hombre-máquina y máquina-máquina. Se cubren registros y memoria, interrupciones, llamadas al sistema, modos de direccionamiento, modularización (procedimientos y macros), programación híbrida C ↔ ASM y programación de dispositivos (puertos serial, paralelo y USB), con un proyecto final integrador.

## Resultados de aprendizaje
1. Explicar el funcionamiento del procesador, sus registros y la memoria a nivel de arquitectura (U1).
2. Programar rutinas en ensamblador con control de flujo, aritmética, manejo de cadenas y pila (U2).
3. Modularizar código mediante procedimientos y macros, aplicando convenciones de llamada (ABI) (U3).
4. Programar dispositivos y periféricos (video, disco, puertos serial/paralelo/USB) e integrar C con ensamblador (U4).
5. Integrar un **proyecto final** funcional con interacción hardware o simulador, documentado y probado.

## Evaluación
- Prácticas (5–6) — 40%
- Evaluaciones/Quizzes — 15%
- Participación y revisiones por pares — 10%
- **Proyecto Final** — 35%

Detalles en [GRADING.md](./GRADING.md). Calendario de parciales y semanas en [SCHEDULE.md](./SCHEDULE.md).

## Herramientas
- Toolchain GNU: `gcc`, `as`, `ld`, `gdb` + GEF; emulación con `qemu`.
- Plataformas: AWS EC2 Graviton (ARM64), Raspberry Pi, QEMU; Raspberry Pico 2W para prácticas con hardware; RISC-V como reto.
- Temario completo en [docs/temario_interfaz.md](./docs/temario_interfaz.md).

## Bibliografía y recursos
- ARM Architecture Reference Manual.
- Patterson & Hennessy — *Computer Organization and Design, RISC-V Edition*.
- Sloss, Symes & Wright — *ARM System Developer's Guide*.
- Referencias completas en [BIBLIOGRAPHY.md](./BIBLIOGRAPHY.md).

## Políticas
Asistencia, conducta, integridad académica y entregas tardías en [POLICIES.md](./POLICIES.md). Uso responsable de IA en [AI_GUIDANCE.md](./AI_GUIDANCE.md).
