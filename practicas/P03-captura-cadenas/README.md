# P03 — Captura básica de cadenas

**Unidad:** U2 — Programación básica (subtemas 2.3 y 2.8)
**Objetivo:** capturar una cadena desde la entrada estándar con la syscall `read`,
manejar la longitud real capturada y responder con ella.

## Cómo funciona
El programa pregunta el nombre, lo lee con `read(0, buf, 64)` y saluda. El punto clave:
`read` regresa en `x0` **cuántos bytes capturó realmente** (incluido el `'\n'` final) —
esa longitud se guarda en `x19` y se usa en el `write` de respuesta. Nada de tamaños fijos.

El autograder alimenta `tests/input.txt` por stdin y compara stdout:

```bash
make test    # equivale a: echo "Rene" | ./prog
```

## Enunciado
1. Ejecuta `make test`; sigue con GDB el valor de `x0` después del `read`.
2. **Tu variante**: cambia el programa para que pida **dos** datos (nombre y no. de control)
   y responda `Hola <nombre>, control <numero>` — ajusta `tests/input.txt` (dos líneas)
   y `tests/expected.txt`.
3. Captura con formato (2.8): rechaza entrada vacía (solo `'\n'`) imprimiendo `Entrada vacia`
   y saliendo con código 1. Agrega ese caso como segundo escenario en `run_tests.sh`.
4. Asciinema de la corrida + `ANEXO.md`.

## Preguntas de defensa
- ¿Por qué el `write` final usa `x19` y no una constante? ¿Qué imprimiría si usaras 64?
- ¿Qué pasa si el usuario teclea 100 caracteres? ¿Dónde quedan los que no cupieron?
- ¿Por qué `buf` va en `.bss` y no en `.data`?
