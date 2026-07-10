# P05 — Macros en ASM invocadas desde C++ (compilación separada)

**Unidad:** U3 — Modularización (subtema 3.2)
**Objetivo:** ver con tus propios ojos cómo se compilan y ligan los objetos:
una macro GNU as **fabrica tres funciones** (`suma`, `resta`, `mult`) y un programa
C++ las llama a través del ABI de AArch64.

## El flujo que esta práctica demuestra

```
main.cpp ──(g++ -c)──► main.o  ─┐
                                ├──(g++)──► prog
macros.s ──(as)──────► macros.o ─┘
```

```bash
make simbolos   # nm de cada objeto: T (definido) vs U (indefinido)
make test       # compila por separado, liga y valida la salida
```

## Enunciado
1. Corre `make simbolos` **antes** de ligar y explica en tus conclusiones qué significa
   la `U` junto a `suma` en `main.o` y quién la resuelve.
2. Corre `objdump -d macros.o` y localiza las 3 expansiones de la macro — ¿dónde quedó
   el texto `.macro`?
3. **Tu variante**: agrega una cuarta operación con la misma macro (`and`, `orr`, `eor`
   o `lsl`) y su línea en `main.cpp` + `tests/expected.txt`.
4. Rompe el `extern "C"` (quítalo), corre `make` y pega el error del linker en tus
   conclusiones junto al símbolo mangleado (`nm main.o`).
5. Asciinema de `make simbolos && make test` + `ANEXO.md`.

## Preguntas de defensa
- ¿La macro existe en tiempo de ejecución? ¿Qué diferencia hay con una función llamada con `bl`?
- ¿Por qué la misma macro puede generar `add`, `sub` y `mul` sin duplicar código fuente?
- ¿Qué contrato hace posible que C++ llame código ensamblador? ¿Dónde está escrito?
