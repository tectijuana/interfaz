# Unidad 4 — Programación de Dispositivos

Temas 4.1–4.6 del temario, actualizados del contexto 2016 (x86/DOS) a la plataforma
del curso: **Raspberry Pico 2W (RP2350) + MicroPython con inline assembly**
(`@micropython.asm_thumb`), simulación en **Wokwi**, UI con **Google Stitch** y
**agentes físicos** programando electrónica por GPIO.

## Mapa del temario oficial → Pico 2W

| Subtema (2016) | Equivalente 2026 |
|---|---|
| 4.1 Buffer de video modo texto | OLED SSD1306 como framebuffer: píxeles al buffer y rutina acelerada con `asm_thumb` (`oled/` + P07) |
| 4.2 Acceso a discos | Filesystem flash del Pico (littlefs): bitácora de sensor a archivo (conecta con P04) |
| 4.3 Puerto serial | UART real Pico↔laptop con el sensor de temperatura interno `ADC(4)` (P08) |
| 4.4 Puerto paralelo | GPIO como bus paralelo (LEDs/7 segmentos); avanzado: PIO del RP2350 (ensamblador de periféricos) |
| 4.5 Programación híbrida | WiFi + API de clima/LLM en el OLED, con etapa obligatoria en `asm_thumb` (menú) |
| 4.6 Puerto USB | USB-CDC del propio Pico: protocolo laptop↔Pico |

## El puente desde U3

En P06 Python cargó ensamblador en Linux vía ctypes. En el Pico el mecanismo es
**nativo**: MicroPython compila el decorador `@micropython.asm_thumb` en el propio
micro (Cortex-M33, Thumb-2) — Python y ASM en el mismo archivo `.py`, sin toolchain.

## Estructura de evaluación

**3 prácticas obligatorias** (todas con evidencia en video/asciinema y variante Wokwi):
1. `../../practicas/P07-oled-framebuffer-asm/` — framebuffer OLED + rutina `asm_thumb` con medición de speedup.
2. `../../practicas/P08-uart-temperatura/` — UART + ADC: telemetría de temperatura.
3. `../../practicas/P09-webserver-stitch/` — servidor web embebido en el Pico con UI diseñada en Google Stitch (la competencia oficial de la materia: interfaz hombre-máquina y máquina-máquina).

**Menú flexible por equipos** (elegir al menos una):
- Clima desde API web + render en OLED (WiFi).
- Respuesta de un LLM (ChatGPT/Claude API) mostrada en el OLED.
- Bus paralelo con GPIO y display 7 segmentos.
- PIO del RP2350: periférico programado en ensamblador PIO.
- Bitácora littlefs de sensor con rotación de archivo.
- USB-CDC: protocolo binario laptop↔Pico.
- **Agente físico en GPIO**: ver `agentes-gpio-distiller.md` — un agente (Claude Code)
  programa y verifica electrónica real por el puerto GPIO (Distiller de Pamir AI
  o Raspberry Pi + agente).
- **Reto RISC-V**: el RP2350 trae núcleos RISC-V (Hazard3) conmutables — arrancar
  el Pico en modo RISC-V y comparar el ISA con ARM.

## Simulación y CI
- **Wokwi** (https://wokwi.com): vía oficial sin hardware; material previo en el acervo.
- `wokwi-cli` permite correr la simulación en GitHub Actions — el patrón `make test`
  del curso extendido a hardware simulado.
- **Snakie** (https://snakie.com): IDE MicroPython robotics-first (editor Monaco + LLM
  integrado) para cuando sí hay Pico físico — sync en vivo editor↔hardware, pestaña de
  instrumentos en vivo (IMU, rangefinder, ADC como multímetro), generador automático de
  esquemático/breadboard y detección de componentes por I²C. Complementa a Wokwi: éste
  simula sin hardware, Snakie acelera el ciclo edición-depuración una vez que el Pico
  está conectado. Video introductorio: https://www.youtube.com/watch?v=qfT_Ndq-tJI

## Lecturas de la unidad
- `lecturas/lecture07.md` — Excepciones y llamadas al sistema.
- `lecturas/lecture08.md` — Programación de dispositivos y acceso a hardware.
- `lecturas/lesson11.md` — Interrupciones y control de procesos.
- `lecturas/lesson12.md` — Interfaces de E/S y control de dispositivos.
- `oled/` — sesión práctica OLED (2025a).
- `../../docs/recursos/bare-metal/` — startup.s, linker script, guía bare-metal.
- `../../docs/recursos/pico-2-w-pinout.pdf` — pinout oficial.
