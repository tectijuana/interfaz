
# AI_GUIDANCE.md  
**Uso responsable y profesional de Inteligencia Artificial en el curso *Lenguajes de Interfaz* (ARM 32/64 y RISC‑V)**

## 📘 Guía para estudiantes  
Este curso trabaja ensamblador y conceptos de interfase a bajo nivel. Esta guía te orienta para aprovechar herramientas de **Inteligencia Artificial (IA)** (como ChatGPT) sin comprometer tu **formación técnica**, la **comprensión del ISA** ni la **integridad académica**.

---

## 🎯 Objetivo

Usar la IA como apoyo en el aprendizaje de arquitecturas, instrucciones y procesos de depuración a bajo nivel, sin delegar el razonamiento, diseño ni pruebas. La IA **puede sugerir, pero no sustituir tu entendimiento**.

---

## ✅ Usos permitidos y recomendados
- Pedir explicaciones de instrucciones, modos de direccionamiento y control de flujo (`BL`, `ADR`, `auipc`, `jalr`, `RET`, `BEQ`, etc.).
- Resumir convenciones de llamada (ABI) y preservación de registros en ARM64 y RISC‑V.
- Generar borradores de rutinas simples en ensamblador (suma, búsqueda, inversión), que luego **debes adaptar** a la sintaxis y convenciones del curso (GAS, LLVM).
- Obtener guías para depuración paso a paso: registros, banderas (NZCV, CF, ZF), stack frames.
- Solicitar test cases (valores límite, entradas no alineadas, casos de overflow).
- Explicar mapeo de periféricos e interrupciones (prioridades, máscaras, latencia), con referencias a la documentación del SoC.

---

## 🚫 Usos no permitidos
- Entregar rutinas generadas por IA sin haberlas probado ni entendido.
- Confiar en IA para direcciones de E/S, ABI, offsets o ISR sin validar con datasheets y documentación oficial.
- Pedir soluciones completas a prácticas o exámenes.
- Copiar configuraciones de linker, inicialización o secciones sin comprenderlas.

---

## ⚙️ Flujo sugerido para trabajar con IA

1. **Define el contexto**  
   Plataforma (ARMv8‑A, RV32I, etc.), toolchain (GAS, Clang, LLVM), tipo de interfase (C ↔ ASM), restricciones.

2. **Solicita un borrador guiado**  
   Pide esqueleto comentado con roles de registros, estructura del stack y convenciones.

3. **Ajusta la sintaxis y ABI**  
   Alinea nombres de registros, formato (AT&T vs Intel), secciones (`.text`, `.bss`), y alineación.

4. **Compila y ejecuta**  
   Usa QEMU, emuladores, o simuladores para validar funcionalidad. Inspecciona registros, memoria y stack.

5. **Optimiza localmente**  
   Pide sugerencias de uso eficiente de registros, reducción de ciclos o alineación de datos.

6. **Documenta profesionalmente**  
   Indica precondiciones, postcondiciones, registros afectados, convenciones de retorno, y referencias técnicas.

---

## 🧰 Prompts recomendados (ejemplos)

- *“Explica cómo implementar una función en ARM64 que reciba un arreglo y regrese su suma, respetando ABI y preservando registros.”*
- *“Genera casos de prueba para una rutina en RISC‑V que invierte un arreglo de 32 bits; incluye longitudes impares.”*
- *“¿Cuál es la diferencia entre `STR` y `STP` en ARM64? ¿Qué conviene usar en acceso alineado?”*
- *“Esqueleto de ISR en RISC‑V con restauración mínima de contexto y posibilidad de anidamiento.”*

---

## 📝 Declaración obligatoria en entregas

Incluye una sección clara al final de cada práctica o proyecto con la siguiente estructura:

```markdown
### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "¿Cómo implementar una rutina en RISC‑V para sumar elementos de un arreglo con control de overflow?"
  - "Esqueleto en GAS para ISR con push/pop mínimos."

- **Herramientas utilizadas**:
  - ChatGPT (GPT-4o)
  - Perplexity AI

- **Cambios y validación**:
  - Ajusté nombres de registros y secciones al formato GAS.
  - Verifiqué la rutina en QEMU con inputs alineados y no alineados.
  - Validé el manejo de banderas y condiciones de retorno.

- **Reflexión personal**:
  Me ayudó a entender cómo se organiza el stack frame. Detecté errores en el manejo de registros temporales sugeridos por IA y los corregí tras revisar el ABI.

- **Fecha**: 2025-09-18  
- **Plataforma objetivo**: ARMv8-A (Raspberry Pi) – RV32I (SiFive emulado)  
- **Evidencia de prueba**: comandos de build, capturas de dump de registros y memoria  
````

---

## ✅ Checklist técnico de verificación

* [ ] El código **compila** sin warnings con el toolchain del curso.
* [ ] Se respeta el ABI (registros preservados, stack balanceado).
* [ ] Hay **pruebas funcionales** con inputs normales y casos límite.
* [ ] Comentarios claros de pre/postcondición, flags afectados.
* [ ] Toda E/S o vector de interrupción está referenciado en documentación técnica.

---

## 🔒 Honestidad académica

El uso de IA está permitido como **apoyo a la comprensión y diseño técnico**, nunca como reemplazo de tu razonamiento. El uso indebido puede tener consecuencias académicas. Durante evaluaciones, el uso de IA puede estar restringido o prohibido.

---

> 📌 Revisa siempre la documentación oficial del ISA (ARM Architecture Reference Manual, RISC‑V Privileged Spec) y del SoC que estés usando.
> 💡 La IA ayuda, pero el **dominio real se logra con lectura técnica y pruebas**.

```


