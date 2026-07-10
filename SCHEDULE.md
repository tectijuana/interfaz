# Planeación didáctica — Lenguajes de Interfaz (SCC-1014) · Agosto–Diciembre 2026

> ⚠️ **Borrador**: fechas estimadas sobre el patrón del ciclo anterior; confirmar contra el
> calendario oficial TecNM 2026-2027 antes de publicar a los alumnos.

Basada en:
* 📄 Temario de 4 unidades (ensamblador, programación básica, modularización, dispositivos).
* 🕒 Clases de lunes a jueves (4 h/semana: 2 teoría + 2 práctica).
* 🧪 Enfoque práctico ARM64 (AWS Graviton / Raspberry Pi / QEMU) + RISC-V como reto + Pico 2W.
* 🤖 Flujo con agentes (Claude Code) como tutor: ver `CLAUDE.md` y `AI_GUIDANCE.md`.

---

### 🎯 Resumen del ciclo

* **Inicio de clases**: 24 de agosto de 2026
* **Fin de clases**: 11 de diciembre de 2026
* **Duración efectiva**: ~16 semanas
* **Días no laborables (estimados)**: miércoles 16 de septiembre; lunes 16 de noviembre

---

### 📅 Planeación por semanas

| Semana | Fechas            | Unidad       | Temas/Subtemas                                                          | Actividades clave                                              |
| ------ | ----------------- | ------------ | ----------------------------------------------------------------------- | -------------------------------------------------------------- |
| 1      | 24–27 agosto      | Presentación | Presentación, diagnóstico, setup de entorno (AWS/QEMU/Termux)           | `compilador.sh`, cuentas, diagnóstico, organización de equipos |
| 2      | 31 ago–3 sep      | U1           | 1.1–1.3: Importancia del ensamblador, procesador, registros y memoria   | Lecturas U1; **P01 Hola ARM64** (`make test` + asciinema)      |
| 3      | 7–10 septiembre   | U1           | 1.4–1.6: Interrupciones, syscalls y modos de direccionamiento           | GDB+GEF; emulador 8 bits (banco de problemas A)                |
| 4      | 14–17 septiembre  | U1           | *Mié 16 no hay clase* — 1.7–1.8: Ensamblado, ligado, salida a pantalla  | Práctica: mensajes con syscall `write` en ARM64                |
| 5      | 21–24 septiembre  | U2           | 2.1–2.3: Ensamblador/ligador, ciclos, captura de cadenas                | E/S básica; banco de problemas B                               |
| 6      | 28 sep–1 oct      | U2           | 2.4–2.7: Comparación, saltos, ciclos condicionales                      | Ejercicios en clase + tareas                                   |
| 7      | 5–8 octubre       | U2           | 2.8–2.10: Cadenas con formato, aritmética, pila                         | Mini práctica evaluada                                         |
| 8      | 12–15 octubre     | U2           | 2.11–2.13: Conversión decimal, lógicas, desplazamiento/rotación         | Actividad: calculadora básica; banco C–D                       |
| 9      | 19–22 octubre     | U2           | 2.14–2.16: Hexadecimal, datos numéricos, archivos                       | Proyecto corto: lector/grabador de archivo                     |
| 10     | 26–29 octubre     | U3           | 3.1: Procedimientos, ABI AArch64, stack frames                          | Biblioteca de subrutinas; interop C ↔ ASM                      |
| 11     | 2–5 noviembre     | U3           | 3.2: Macros GNU as, reuso de código                                     | Proyecto de macros personalizadas                              |
| 12     | 9–12 noviembre    | U4           | 4.1–4.2: E/S mapeada, buffer de video, acceso a almacenamiento          | Lecturas U4; bare-metal intro                                  |
| 13     | 16–19 noviembre   | U4           | *Lun 16 no hay clase* — 4.3–4.4: UART (serial) y GPIO en Pico 2W        | Taller de puertos con Pico 2W                                  |
| 14     | 23–26 noviembre   | U4           | 4.5–4.6: Programación híbrida (MicroPython + ASM), USB                  | Práctica libre (Pico 2W, QEMU o hardware disponible)           |
| 15     | 30 nov–3 dic      | Integrador   | Proyecto final: aplicación funcional completa                           | Desarrollo y pruebas finales                                   |
| 16     | 7–10 diciembre    | Cierre       | Presentación de proyectos + portafolio de evidencias                    | Evaluación, rúbricas y retroalimentación                       |

---

### 🧩 Evaluaciones sugeridas

| Evaluación           | Fecha (estimada)          | Unidad(es) | Descripción                                             |
| -------------------- | ------------------------- | ---------- | ------------------------------------------------------- |
| **Parcial 1**        | Jueves **8/oct/2026**     | U1–U2      | Examen práctico + entrega de programas básicos          |
| **Parcial 2**        | Jueves **12/nov/2026**    | U2–U3      | Proyecto modular con procedimientos y macros            |
| **Final (Proyecto)** | Jueves **10/dic/2026**    | U4         | Aplicación funcional con interacción hardware/simulador |
