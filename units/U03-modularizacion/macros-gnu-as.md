# Macros en GNU as y compilación separada (C++ → objeto → ASM)

**Unidad:** U3 — Modularización (subtema 3.2)

## 1. ¿Qué es una macro en ensamblador?

Un **procedimiento** (3.1) es código que existe una vez y se *llama* con `bl`.
Una **macro** (3.2) es una plantilla que el ensamblador **expande en el momento de
ensamblar**: cada uso pega una copia del código. No hay salto, no hay retorno —
cuando el programa corre, la macro ya no existe.

```asm
// Una macro que FABRICA funciones completas:
// se invoca 3 veces y genera suma, resta y mult.
.macro  defop nombre, instr
        .global \nombre
\nombre:
        \instr  x0, x0, x1      // resultado en x0 (ABI: retorno)
        ret
.endm

        defop suma,  add
        defop resta, sub
        defop mult,  mul
```

Tres líneas de invocación → tres funciones reales en el objeto. Compruébalo:

```bash
aarch64-linux-gnu-as -o macros.o macros.s
nm macros.o          # T suma, T resta, T mult  ← símbolos generados por la macro
objdump -d macros.o  # el código expandido, ya sin rastro de la macro
```

## 2. El punto didáctico: cómo se compilan los objetos

Un programa C++ que usa esas funciones **no se compila junto**: cada mundo produce
su `.o` y el **linker** los une. Este es el flujo completo que hay que ver una vez
en la vida con tus propios ojos:

```
main.cpp ──(g++ -c)──► main.o  ─┐
                                ├──(g++)──► prog   (ejecutable)
macros.s ──(as)──────► macros.o ─┘
```

```cpp
// main.cpp — el C++ solo necesita la FIRMA; el cuerpo vive en macros.o
extern "C" long suma(long a, long b);   // extern "C": sin name mangling
```

Preguntas guía mientras lo haces:
- ¿Qué contiene `main.o` donde debería estar `suma`? (`nm main.o` → símbolo `U`, *undefined*)
- ¿Quién resuelve ese hueco y cuándo? (el linker, al final)
- ¿Qué pasa si quitas `extern "C"`? (mangling: el símbolo se llama `_Z4sumall` y el link falla)

## 3. De C++ a Python: la misma biblioteca, otro lenguaje

El mismo `macros.o` se convierte en biblioteca compartida y Python la carga con
`ctypes` — el ABI de AArch64 es el contrato que hace posible que ASM, C++ y Python
se entiendan:

```bash
gcc -shared -o libops.so macros.o
python3 -c "import ctypes; print(ctypes.CDLL('./libops.so').suma(3,4))"   # 7
```

## Prácticas de esta unidad
| Paso | Práctica |
|---|---|
| C++ + macro ASM, ver los objetos y el link | `../../practicas/P05-macros-cpp/` |
| Python llama la biblioteca ASM con ctypes | `../../practicas/P06-python-ctypes-asm/` |
| Inline assembly dentro de C (contraste) | `../U02.03-InLineAssembly/` |
