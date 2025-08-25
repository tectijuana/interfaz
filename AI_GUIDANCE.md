
## AI_GUIDANCE.md – Curso *Lenguajes de Interfaz* (ARM 32/64 y RISC‑V)


# Guía de uso responsable de IA en *Lenguajes de Interfaz*

Este curso aborda ensamblador y conceptos de interfase a bajo nivel (ARM 32/64 y RISC‑V). Usa esta guía para aprovechar herramientas de IA (p.ej., ChatGPT) sin comprometer la integridad académica ni la comprensión técnica. (Ver descripción del repo).  

## 🎯 Objetivo
Potenciar el aprendizaje con IA para **entender** instrucciones, ABI/llamadas, organización de memoria, E/S mapeada en memoria y prácticas de depuración; nunca para “tercerizar” el trabajo.

## ✅ Usos recomendados
- Pedir **explicaciones** de instrucciones, modos de direccionamiento y flujo de control (ej. `BL`, `ADR`, ramas con condición, `auipc` + `jalr`).
- Solicitar **resúmenes** de convenciones de llamada (ABI) y preservación de registros para funciones en ARM64 o RISC‑V.
- Generar **borradores** de rutinas en ensamblador como referencia (p. ej., suma de arreglos, búsqueda lineal) y luego **ajustarlas** al ensamblador/ensamblador del curso (GAS/LLVM).
- Pedir guías para **depurar** (paso a paso, inspección de registros, banderas NZCV/CF/ZF, stack frames) en simuladores o QEMU.
- Solicitar **tests** mínimos (valores límite, casos con overflow, entradas no alineadas) para validar rutinas.
- Explicar **mapeo** de periféricos y manejo de interrupciones a nivel conceptual (prioridades, máscaras, latencia) con referencias a datasheets.

## 🚫 Usos no permitidos
- Entregar código de IA **sin comprenderlo** o **sin probarlo** en el entorno requerido.
- Aceptar definiciones de registros/ABI o direcciones de E/S **sin contrastarlas** con la documentación oficial del ISA/SoC.
- Pedir a la IA que **resuelva íntegramente** prácticas o exámenes.
- Copiar configuraciones de linker/arranque (linker scripts, vectores de interrupción) **sin verificación**.

## 🧪 Flujo sugerido con IA (pasos prácticos)
1. **Formular el problema**: describe plataforma (ARMv8‑A o RV32I/RV64I), herramienta (GAS/Clang), formato de llamadas (C ↔ ASM) y restricciones.
2. **Pedir un bosquejo**: solicita a la IA un **esqueleto** de rutina con comentarios detallados.
3. **Ajuste al toolchain**: normaliza sintaxis (AT&T vs Intel, pseudo‑instrucciones), nombres de registros y secciones (`.text`, `.data`, `.bss`).
4. **Verificación**: compila y ejecuta en emulador/simulador, inspecciona registros y memoria, agrega asserts/test vectors.
5. **Optimización**: solicita sugerencias **locales** (desenrollado, uso de registros temporales, alineación) y mide impacto.
6. **Documenta**: añade pre/post‑condiciones, preservación de registros, efectos colaterales y convenciones de retorno.

## 🧰 Prompts útiles (ejemplos)
- *“Explícame paso a paso cómo implementar una función en ARM64 que reciba puntero y longitud y regrese la suma, respetando el ABI y preservando registros.”*
- *“Genera casos de prueba para una rutina en RISC‑V que invierte un arreglo de 32‑bit; incluye valores límite y longitudes pares/impares.”*
- *“Compara `LDR`/`STR` vs `LDP`/`STP` en ARM64 y cuándo conviene cada una; incluye costos de ciclos aproximados.”*
- *“Dame un esqueleto GAS para ISR con salvado/restauración de contexto mínimo y puntos de extensión.”*

## 📋 Declaración obligatoria en entregas
Incluye al final de cada práctica/proyecto:

```
Asistencia de IA: ¿Qué pediste? ¿Qué recibiste? ¿Qué cambiaste y por qué?
Herramienta y versión:
Plataforma objetivo (ARMv7/ARMv8, RV32/RV64):
Evidencia de prueba (comando de build/ejecución, captura de registros/memoria):
```

## ✅ Checklist de verificación rápida
- [ ] La rutina **compila** sin warnings en el toolchain del curso.
- [ ] Preservas registros según ABI; el **stack** queda balanceado.
- [ ] Pruebas pasan con **valores límite** y casos adversos.
- [ ] Comentarios describen **pre/post‑condiciones** y efectos en banderas.
- [ ] Citas/datasheets referenciados cuando usas E/S mapeada o ISR.

## 🔒 Honestidad académica
El uso de IA debe declararse y limitarse a apoyo conceptual, borradores y revisión. Las evaluaciones pueden restringir o prohibir IA.

---

> Nota: Revisa siempre la documentación oficial del ISA y del SoC antes de confiar en respuestas de IA.
```
