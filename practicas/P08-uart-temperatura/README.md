# P08 — Puerto serial: telemetría de temperatura por UART

**Unidad:** U4 (subtema 4.3 — puerto serial) · **Plataforma:** Pico 2W · **Simulador:** Wokwi
**Objetivo:** transmitir datos reales por un UART configurado a mano (baudrate,
formato de trama) y entender qué viaja por los pines TX/RX.

## Enunciado
1. Lee el **sensor de temperatura interno** del RP2350 (`ADC(4)`) y conviértelo a °C
   (documenta la fórmula del datasheet en un comentario).
2. Configura `UART0` (GP0=TX, GP1=RX) a **115200 8N1** y transmite cada segundo una
   trama de texto: `TEMP,<no.control>,<celsius>\r\n`.
3. Recepción (elige según tu equipo):
   - **Pico↔laptop**: adaptador USB-serial o el USB-CDC del segundo Pico, leyendo
     con `screen`/`minicom` — asciinema obligatorio.
   - **Pico↔Pico**: un segundo Pico recibe, parsea la trama y enciende el LED si
     la temperatura supera un umbral.
   - **Wokwi**: usa el monitor serial del simulador.
4. **Checksum en ensamblador**: agrega al final de la trama un checksum simple
   (XOR de los bytes del payload) calculado con `@micropython.asm_thumb`, y
   verifícalo en el receptor. `TEMP,22211539,27.3,5A\r\n`
5. **Tu variante**: el umbral de alarma y el periodo de muestreo los asigna el
   docente por equipo.

## Preguntas de defensa
- ¿Qué significa 8N1? Dibuja la trama de UN byte en el tiempo (start/datos/stop).
- Si TX manda a 115200 y RX escucha a 9600, ¿qué se recibe y por qué?
- ¿Por qué UART no necesita reloj compartido y SPI/I²C sí?
- ¿Qué detecta tu checksum XOR y qué NO puede detectar?
