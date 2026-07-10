# P07 — OLED como framebuffer + inline assembly en MicroPython

**Unidad:** U4 (subtema 4.1 — buffer de video) · **Plataforma:** Pico 2W + OLED SSD1306 (I²C) · **Simulador:** Wokwi
**Objetivo:** entender que "la pantalla" es un buffer de bytes en memoria, y acelerar
una operación sobre ese buffer con ensamblador Thumb dentro de MicroPython.

## Base conceptual
El SSD1306 de 128×64 se maneja con un `framebuf` de 1024 bytes (1 bit = 1 píxel).
Dibujar = escribir bytes; `show()` = volcar el buffer por I²C. Es el mismo modelo
del "buffer de video en modo texto" del temario, con memoria de verdad enfrente.

## Inline assembly nativo del Pico
MicroPython compila esto **dentro del micro** (Cortex-M33, Thumb-2) — no hay
toolchain externo:

```python
import micropython

@micropython.asm_thumb
def invertir(r0, r1):        # r0 = dirección del buffer, r1 = longitud en bytes
    label(LOOP)
    ldrb(r2, [r0, 0])        # lee un byte del framebuffer
    mvn(r2, r2)              # invierte todos los bits
    strb(r2, [r0, 0])        # lo escribe de vuelta
    add(r0, 1)
    sub(r1, 1)
    bgt(LOOP)

# uso:  invertir(fb_bytearray_address, 1024)  → pantalla en negativo
```

## Enunciado
1. Arma el circuito (o el proyecto Wokwi): Pico 2W + SSD1306 por I²C. Muestra tu
   nombre y número de control con `framebuf.text()`.
2. Implementa `invertir()` en dos versiones: Python puro (ciclo sobre el
   `bytearray`) y `asm_thumb`. Mide ambas con `time.ticks_us()` y reporta el
   **speedup** en una tabla.
3. **Tu variante**: además de invertir, implementa en `asm_thumb` una de estas
   operaciones sobre el buffer (asignada por el docente): limpiar, espejo
   horizontal por página, scroll vertical de 8 píxeles, o patrón ajedrez.
4. Evidencia: video/gif del OLED (o captura Wokwi) + asciinema del REPL con las
   mediciones + `ANEXO.md`.

## Preguntas de defensa
- ¿Por qué `ldrb/strb` y no `ldr/str`? ¿Qué cambiaría con acceso por palabras de 32 bits?
- ¿Dónde vive el buffer: en el Pico o en el OLED? ¿Qué hace exactamente `show()`?
- ¿Por qué el `asm_thumb` es más rápido si Python "también" ejecuta en el mismo CPU?
- ¿Qué registros puede usar libremente `asm_thumb` y quién define esa regla?
