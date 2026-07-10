# P09 — Servidor web embebido en el Pico 2W con UI diseñada en Google Stitch

**Unidad:** U4 (cierre: 4.5 híbrida + competencia oficial de la materia) · **Plataforma:** Pico 2W (WiFi)
**Objetivo:** la competencia completa de la asignatura en una práctica: el Pico
sirve una **interfaz hombre-máquina** (dashboard web) que controla y monitorea una
**interfaz máquina-máquina** (sensores/actuadores en GPIO).

## Arquitectura

```
[navegador] ←WiFi/HTTP→ [Pico 2W: webserver MicroPython] ←GPIO/ADC/I²C→ [LED, temp, OLED]
```

## Enunciado
1. Conecta el Pico 2W a WiFi y levanta un servidor HTTP (socket puro o `microdot`).
   Reporta la IP en el OLED o por serial.
2. **Diseña la UI con Google Stitch** (https://stitch.withgoogle.com): un dashboard
   con al menos temperatura actual, estado del LED y un botón de encendido/apagado.
   Exporta el HTML/CSS y adáptalo para servirse desde el Pico (¡pesa poco!: sin
   frameworks, una sola página).
3. Endpoints mínimos: `GET /` (dashboard), `GET /api/temp` (JSON), `POST /led`
   (toggle). El dashboard consume `/api/temp` con `fetch()` cada 2 s.
4. **Toque de ensamblador**: la conversión ADC→décimas de °C se hace en una función
   `@micropython.asm_thumb` (aritmética entera; documenta el escalado).
5. **Tu variante**: cada equipo agrega un cuarto endpoint asignado por el docente
   (histórico en littlefs, umbral de alarma configurable, contador de visitas,
   segundo sensor, etc.).
6. Evidencia: video del navegador (celular) controlando el circuito + captura del
   diseño original en Stitch vs lo servido + `ANEXO.md`.

## Preguntas de defensa
- ¿Qué pasa si dos clientes hacen `POST /led` al mismo tiempo? ¿Tu servidor es concurrente?
- ¿Por qué conviene aritmética entera (décimas de grado) en el `asm_thumb` en vez de flotante?
- ¿Qué tuviste que recortar del HTML de Stitch para que cupiera y por qué?
- Traza una petición completa: del `fetch()` del navegador al registro del ADC y de vuelta.
