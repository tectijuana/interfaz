# Unidad 3 — Modularización (Procedimientos y Macros)

Temas 3.1–3.2 del temario: subrutinas, paso de parámetros según el ABI de AArch64,
preservación de registros, stack frames y macros del ensamblador GNU (`.macro`/`.endm`).

## Ruta didáctica de la unidad

La secuencia va de "ver cómo se compilan los objetos" a "usar ASM desde un lenguaje
de alto nivel":

1. **Procedimientos y ABI** (3.1) — `lecturas/lecture04.md`: subrutinas, paso de
   parámetros y stack frames en ARM64.
2. **Macros y compilación separada** (3.2) — `macros-gnu-as.md`: una macro GNU as
   fabrica funciones; C++ las llama; se inspeccionan los `.o` con `nm`/`objdump`.
3. **Prácticas verificables**:

| Paso | Práctica |
|---|---|
| C++ + macro ASM: objetos, símbolos T/U y linker | `../../practicas/P05-macros-cpp/` |
| Python + ctypes carga la biblioteca ASM (`libops.so`) | `../../practicas/P06-python-ctypes-asm/` |
| Contraste: inline assembly dentro de C | `../U02.03-InLineAssembly/` |
