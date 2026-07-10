# Agentes físicos: programar electrónica por GPIO con un agente de IA

**Unidad:** U4 — menú flexible
**Concepto:** hasta ahora el agente (Claude Code) te ayudó a escribir código.
En esta práctica el agente **tiene acceso físico al hardware**: corre en un equipo
con puerto GPIO, escribe el código, lo ejecuta, **mide el resultado eléctrico real**
y corrige — el ciclo completo de un ingeniero embebido, automatizado.

## Plataformas

### Opción A — Distiller (Pamir AI)
El [Distiller](https://www.pamir.ai/) es una computadora de bolsillo pensada como
"casa física" de un agente: Linux ARM64 (8 GB RAM), **headers GPIO estilo Raspberry
Pi**, I²C/SPI/UART/PWM, USB-C, WiFi/BT, pantalla e-ink, y Claude Code corriendo
24/7 en el dispositivo con acceso remoto (VS Code vía QR). Documentación:
https://docs.pamir.ai · Firmware/ejemplos: https://github.com/Pamir-AI

### Opción B — Raspberry Pi + Claude Code (sin comprar hardware nuevo)
Una Raspberry Pi 4/5 del laboratorio con Claude Code instalado es funcionalmente
equivalente para esta práctica: agente + GPIO en la misma máquina
(`gpiozero`/`libgpiod` + un LED, botón o sensor en el header).

## La práctica

1. **Cableado humano**: el equipo conecta en protoboard: 1 LED (con resistencia),
   1 botón y un sensor I²C (temperatura o el OLED de P07). El cableado lo documenta
   el humano — el agente no puede (todavía) mover cables.
2. **Misión del agente**: se le pide en lenguaje natural, por ejemplo:
   *"Hay un LED en GPIO17 y un botón en GPIO27. Escribe y verifica un programa
   donde el LED parpadee al doble de velocidad cada vez que se presiona el botón."*
3. **Regla de oro — verificación física**: el agente debe *demostrar* que funciona
   leyendo el estado real (leer de vuelta el pin, capturar la señal del botón,
   leer el sensor I²C) — no basta con que el código "se vea bien". Documenten qué
   estrategia de auto-verificación usó el agente.
4. **Escalada**: pidan una segunda misión que involucre el sensor I²C y registro
   a archivo (conecta con 4.2), observando cómo el agente descubre la dirección
   I²C (`i2cdetect`) y depura por sí mismo.
5. **Reflexión (obligatoria en el reporte)**: ¿qué hizo bien el agente sin ayuda?,
   ¿dónde alucinó pines, direcciones o librerías?, ¿qué tuvo que verificar el humano?
   Apliquen el checklist crítico de `AI_GUIDANCE.md` — esta práctica ES el caso de
   estudio del curso sobre trabajar *con* agentes en ingeniería.

## Entregables
- Video corto: la misión dictada, el agente trabajando y el circuito respondiendo.
- Transcript de la sesión del agente (o enlace) + código final con encabezado.
- Reporte con la reflexión del punto 5 y `ANEXO.md`.

## Rúbrica adicional (sobre la general de `GRADING.md`)
- 40% verificación física demostrada (el agente midió, no supuso).
- 30% calidad de las misiones y de la escalada.
- 30% profundidad de la reflexión crítica humano↔agente.
