# P06 — Python llama ensamblador (ctypes + biblioteca compartida)

**Unidad:** U3 — Modularización (cierre: ASM como biblioteca para lenguajes de alto nivel)
**Objetivo:** convertir las funciones ASM de P05 en una biblioteca compartida
(`libops.so`) y usarlas desde Python con `ctypes` — el mismo mecanismo con el que
NumPy o cualquier extensión nativa acelera Python.

## El flujo

```
ops.s ──(as)──► ops.o ──(gcc -shared)──► libops.so ──(ctypes.CDLL)──► Python
```

⚠️ **Requiere ARM64 nativo** (el intérprete de Python debe ser aarch64):
AWS Graviton, Raspberry Pi, **Termux en tu teléfono**, o en laptop x86:
```bash
docker run --rm --platform linux/arm64 -v $PWD:/work -w /work debian:stable-slim \
  bash -c "apt-get update -qq && apt-get install -y -qq gcc make python3 && make test"
```

## Enunciado
1. `make test` y luego `file libops.so` — ¿qué arquitectura reporta?
2. En Python interactivo, llama `lib.suma(2**62, 2**62)` — explica el resultado con
   lo que sabes de registros de 64 bits.
3. **Tu variante**: agrega a la biblioteca una función `pot(base, exp)` (potencia con
   ciclo de multiplicaciones en ASM) y úsala desde Python. Ajusta el expected.
4. Mide con `time` 1 millón de llamadas a `lib.suma` vs una función `suma` en Python
   puro. ¿Ganó el ASM? Explica el overhead de ctypes en tus conclusiones.
5. Asciinema + `ANEXO.md`.

## Preguntas de defensa
- ¿Qué hace `gcc -shared` que no hace el `ld` de las prácticas anteriores?
- ¿Por qué hay que declarar `argtypes`/`restype`? ¿Qué pasa si no?
- ¿Dónde interviene el ABI de AArch64 cuando Python llama `lib.mult(7,5)`?
