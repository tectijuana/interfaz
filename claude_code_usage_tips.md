# Claude Code CLI para Sistemas Embebidos
## Guía completa de uso con `/usage` y optimización de tokens

---

## 📋 Comandos esenciales de Claude Code

### Comandos de cuota y monitoreo

| Comando | Función | Cuándo usarlo |
|---------|---------|--------------|
| `/usage` | Ver cuota de tokens disponibles (ventana de 5 horas) | Al inicio de sesión y cada 15-20 min |
| `/stats` | Ver estadísticas de consumo y tasas de quema | Midiendo eficiencia de tareas |
| `/compact` | Comprimir historial de contexto para ahorrar tokens | Al alcanzar 80% de cuota usado |
| `/clear` | Resetear sesión completamente | Después de terminar cada hito del proyecto |
| `/context` | Ver espacio disponible en ventana de contexto | Antes de tareas grandes |

---

## 🔄 Tu flujo de trabajo: Sistemas embebidos en Claude Code

### 1️⃣ Comienza cada sesión: revisa cuota inmediatamente

**¿Por qué?** Tienes una ventana de 5 horas. Necesitas saber si puedes completar tu tarea actual o si debes planificar pausas.

```bash
$ claude code
Starting Claude Code session...

$ /usage
→ Quota: 900,000 tokens remaining (5-hour window)
→ Reset time: in 4 hours 55 minutes
```

**Interpretación:**
- **900K tokens** = puedes completar 3-4 componentes sustanciales (sensor, display, WiFi, cloud logging)
- **200K tokens** = máximo 1-2 tareas medianas
- **<100K tokens** = planifica esperar a que se reinicie la ventana

---

### 2️⃣ Divide tareas en hitos (milestones)

**❌ MAL:** Pedir todo de una vez
```
"Construye mi estación meteorológica completa con Pico W"
```

**✅ BIEN:** Dividir en conversaciones separadas

```
Hito 1: Código de sensor DHT22
$ /usage  → 890K tokens restantes
[trabajo en código, depuración, testing]
$ /stats  → consumí 15K tokens

$ /clear  → resetea contexto

Hito 2: Integración pantalla LCD I2C
$ /usage  → 875K tokens restantes
[trabajo en integración]
$ /clear

Hito 3: Conexión WiFi con reintento
$ /usage  → 860K tokens restantes
```

**Ventaja:** Cada `/clear` elimina el historial anterior, así no pagas el costo de contexto de tareas completadas.

---

### 3️⃣ Monitorea la tasa de quema (burn rate) durante la sesión

Cada 15-20 minutos, mira `/stats` para asegurarte de que no estés gastando demasiados tokens por tarea.

```bash
$ /stats
→ Tokens used this session: 15,000
→ Burn rate: ~3,000 tokens per major task
→ Estimated tasks remaining: 29
```

**Si la tasa es muy alta (>8K por tarea pequeña):**
- Tu prompt es demasiado vago (rellena con contexto innecesario)
- Hay demasiada iteración (muchas pruebas/error)
- Solución: sé más específico en el próximo `/clear`

---

### 4️⃣ Alcanzaste 80% de uso? Usa `/compact`

Cuando `/usage` muestre ~80% consumido, ejecuta:

```bash
$ /usage
→ Quota used: 720K / 900K (80%)

$ /compact
→ Context compressed. Saved ~150K tokens.
→ Tokens freed: 30K available for new work
```

**Beneficio:** Gana 20-30% más tokens para continuar sin esperar al reinicio de 5 horas.

---

### 5️⃣ Nueva tarea = `/clear` para resetear

Después de completar un hito:

```bash
$ /clear
→ Context cleared for new task
→ Remaining quota: 885K tokens
```

**Previene:** acumulación de contexto largo que aumenta el costo de cada interacción.

---

## 📊 Estimados de consumo de tokens por tarea

Usa estos números para planificar tu ventana de 5 horas:

| Tarea | Tokens estimados | Notas |
|-------|------------------|-------|
| Generar código básico de sensor DHT22 | 8-12K | Sensor simple, código MicroPython limpio |
| Integrar LCD I2C + lectura de sensor | 15-25K | Incluye debugging, iteraciones |
| Conexión WiFi con lógica de reintento | 12-18K | Setup, manejo de errores |
| Depuración de problemas GPIO/I2C | 20-35K | Diagnósticos, scripts de test, múltiples iteraciones |
| Proyecto completo (3-4 hitos) | 50-80K | Sensor + display + WiFi + cloud logging |
| Documentación + BOM + diagrama de pines | 5-10K | Markdown, tablas ASCII |

**Ejemplo con 900K tokens iniciales:**
```
15K (sensor) + 20K (display) + 15K (WiFi) + 25K (debug) = 75K
Restante: 825K para futuras sesiones o proyectos
```

---

## 🛠️ Estrategias para ahorrar tokens

### A. Crea un archivo `CLAUDE.md` en tu proyecto

**Primera sesión:** 
```bash
$ cat > CLAUDE.md << 'EOF'
# Smart Plant Watering System

## Hardware
- **Microcontroller:** Raspberry Pi Pico W
- **Sensor:** Capacitive soil moisture (analog GPIO 26)
- **Pump relay:** 5V relay on GPIO 13
- **Display:** 16x2 LCD on I2C (SDA=GPIO 4, SCL=GPIO 5)
- **Cloud:** Firebase Realtime Database

## Milestones
- [x] Sensor reading code (DHT22 format)
- [ ] LCD integration
- [ ] WiFi + cloud logging

## Known issues
- GPIO 15 has weak pull-up, needs external resistor
- I2C frequency must be 100kHz for this LCD model
EOF
```

**Sesiones futuras:**
Claude Code lee `CLAUDE.md` automáticamente. No necesitas re-explicar la configuración de hardware cada vez → **ahorras 5-10K tokens por sesión**.

---

### B. Prompts específicos = menos iteraciones = menos tokens

**❌ VAGO:**
```
"Hazme código WiFi para Pico W"
```
→ Necesita 3-4 iteraciones de feedback

**✅ ESPECÍFICO:**
```
"Genera código MicroPython para conectar Pico W a WiFi:
- SSID: 'MyNetwork', Password: 'secret123'
- Reintenta 3 veces si falla
- Timeout de 10 segundos por intento
- Imprime estado en serial (USB)
- Si conecta: print('Connected! IP: X.X.X.X')
- Si falla: modo fallback (LED rojo parpadeante)
- Incluye try/except para errores de red
Código completo, listo para copiar/pegar."
```
→ Lo resuelve en 1-2 iteraciones

**Token saved:** 5-10K por tarea

---

### C. Usa `/compact` estratégicamente

**Momento ideal:**
- Después de 4-5 tareas pequeñas acumuladas
- Cuando `/usage` muestre 75-80% consumido
- Antes de una tarea grande que conozcas costará mucho

**Efecto:**
```bash
$ /usage
→ Before compact: 720K / 900K (80%)

$ /compact
→ Context compressed: summary + key code preserved

$ /usage
→ After compact: 750K / 900K (83%)
→ Freed ~30K tokens!
```

---

## 📝 Ejemplo: Sesión en tiempo real

```bash
$ claude code
Starting Claude Code session...

$ /usage
→ Quota: 900,000 tokens
→ Window: 5 hours

─────────────────────────────────────
TASK 1: DHT22 Sensor Reading
─────────────────────────────────────

$ "Genera código MicroPython para leer DHT22 en GPIO 15 
de Pico W. Incluye manejo de errores para fallos de sensor.
Código completo con comentarios."

[Claude genera 40 líneas, código probado]

$ /stats
→ Task 1 used: 15,000 tokens
→ Total session: 15K / 900K

$ /clear
→ Context cleared
→ Remaining: 885,000 tokens

─────────────────────────────────────
TASK 2: LCD I2C Integration
─────────────────────────────────────

$ "Integra pantalla LCD 16x2 en I2C (SDA=GPIO4, SCL=GPIO5).
Código debe leer sensor DHT22 y mostrar temp/humedad.
Actualiza cada 2 segundos. Formato: 'T: 24.5°C H: 65%'"

[Claude integra LCD, añade funciones de display]

$ /stats
→ Task 2 used: 18,000 tokens
→ Total this session: 33K / 900K

$ /clear
→ Remaining: 867,000 tokens

─────────────────────────────────────
TASK 3: WiFi + Cloud Logging
─────────────────────────────────────

$ "Añade WiFi para Pico W. Conecta a red 'HomeNet'.
Cada 5 minutos, envía JSON con timestamp, temp, humedad
a endpoint: http://api.example.com/log
Incluye retry si falla red. No bloquear lectura de sensor."

[Claude genera módulo WiFi con no-blocking]

$ /stats
→ Task 3 used: 22,000 tokens
→ Total session: 55K / 900K

$ /usage
→ Remaining: 845,000 tokens
→ Burn rate: ~18K per major task
→ Can complete ~47 more major tasks
```

---

## 🎯 Flujo recomendado para tu proyecto

### Sesión típica (2-3 horas)

```
1. /usage                                    → Verificar cuota
2. Tarea 1 (componente A) → /stats → /clear → ~15-25K tokens
3. Tarea 2 (componente B) → /stats → /clear → ~15-25K tokens
4. Tarea 3 (componente C) → /stats → /clear → ~15-25K tokens
5. /usage → revisar antes de siguiente sesión
```

**Total por sesión:** 45-75K tokens  
**Sesiones posibles con 900K:** 12-20 sesiones de 5 horas

---

## ⚠️ Errores comunes que desperdician tokens

### Error 1: No limpiar contexto entre tareas
```bash
❌ MALO:
  - Completa tarea 1 (sensor)
  - Completa tarea 2 (display) [SIN /clear]
  - Completa tarea 3 (WiFi) [SIN /clear]
  → Costo: contexto crece, cada tarea es más cara
  → Total: 25K + 35K + 45K = 105K
  
✅ BIEN:
  - Completa tarea 1 /clear [15K]
  - Completa tarea 2 /clear [20K]
  - Completa tarea 3 /clear [22K]
  → Total: 57K (¡48K ahorrados!)
```

### Error 2: Prompts vagos = muchas iteraciones
```bash
❌ MALO:
  "Hazme WiFi para Pico W"
  → Necesita 4-5 turnos de "añade esto", "cambia aquello"
  → Costo: 40K tokens
  
✅ BIEN:
  "Genera código para conectar Pico W a WiFi 'MySSID' 
   con contraseña 'pass123'. Reintenta 3 veces, timeout 
   10s. Imprime IP en serial. Try/except para errores."
  → Se resuelve en 1-2 turnos
  → Costo: 12K tokens (¡28K ahorrados!)
```

### Error 3: Depuración sin límites
```bash
❌ MALO:
  "¿Por qué no funciona mi I2C?"
  [Claude sugiere soluciones]
  "Probé eso, sigue sin funcionar"
  [Más sugerencias]
  ... (10+ iteraciones)
  → Costo: 50K+ tokens
  
✅ BIEN:
  "Mi I2C no funciona. Estado actual:
   - Código: [copiar/pegar código]
   - Error: 'OSError: scan found []'
   - He verificado: pines correctos, 4.7K pull-ups, 
     voltaje 3.3V
   Piensa paso a paso: (1) hardware issues, (2) software bugs, 
   (3) diagnostic script. Dame script para probar cada uno."
  → Clara estructura de diagnóstico
  → Menos iteraciones: 25-30K tokens
```

---

## 📚 Prompts específicos para tareas comunes

### Tarea: Generar código sensor Pico W

```markdown
**Contexto:**
- Microcontroller: Raspberry Pi Pico W
- Sensor: DHT22 en GPIO 15
- Objetivo: Lectura cada 10 segundos

**Requisitos:**
1. Código MicroPython completo
2. Manejo de errores si sensor falla
3. Imprime a serial: "Temp: 25.5°C, Humidity: 60%"
4. Comentarios explicando cada parte
5. Sin dependencias externas (solo machine, time)

**Formato:**
- Script listo para copiar/pegar
- Incluye comentarios para principiantes
- Una función read_dht22() reutilizable

Genera el código completo.
```

**Tokens esperados:** 8-12K

---

### Tarea: Integrar LCD I2C

```markdown
**Contexto:**
- Ya tengo código DHT22 funcionando en GPIO 15
- Display LCD 16x2 en I2C (SDA=GPIO4, SCL=GPIO5)
- Dirección I2C: 0x27

**Requisitos:**
1. Función para inicializar LCD
2. Función para escribir temp/humedad en dos líneas
3. Actualiza cada 2 segundos (no bloquea sensor)
4. Manejo de I2C timeout
5. Comentarios claros

**Formato esperado:**
```python
def init_lcd():
    # código aquí
    
def display_reading(temp, humidity):
    # código aquí

while True:
    temp, humidity = read_dht22()
    display_reading(temp, humidity)
    time.sleep(2)
```

Genera el código.
```

**Tokens esperados:** 15-20K

---

### Tarea: Depuración de GPIO/I2C

```markdown
**Problema:** Mi I2C no encuentra el LCD (scan devuelve [])

**He verificado:**
- Pines: SDA=GPIO4, SCL=GPIO5 ✓
- Pull-ups: 4.7K resistencias ✓
- Voltaje: 3.3V medido con multímetro ✓
- LCD enciende (backlight visible) ✓

**Código actual:**
[pegar código aquí]

**Error exacto:**
```
>>> i2c.scan()
[]
```

**Por favor:**
1. Piensa paso a paso qué podría estar mal
2. Dame un script de diagnóstico que pruebe:
   - Frecuencia I2C correcta (100kHz vs 400kHz)
   - Pins activos (toggle LED en GPIO4/GPIO5)
   - Voltaje en los pines durante scan()
3. Sugiere 3 soluciones probables con código

Proporciona script de diagnóstico completo.
```

**Tokens esperados:** 25-35K (debugging es costoso)

---

## 🚀 Próximos pasos

### Para tu primer proyecto con Claude Code:

1. **Crea `CLAUDE.md`** con especificaciones hardware
2. **Divide en 3-4 hitos** máximo por sesión
3. **Antes de empezar:** `/usage` → verifica cuota
4. **Cada hito:** `/stats` para medir eficiencia
5. **Termina cada hito:** `/clear` para resetear
6. **Al 80% de cuota:** `/compact` para ahorrar

### Checklist de prompts efectivos:

- [ ] Especifica GPIO exactos y direcciones I2C
- [ ] Incluye modelo sensor y pantalla
- [ ] Pide código "listo para copiar/pegar"
- [ ] Define manejo de errores esperado
- [ ] Documenta en `CLAUDE.md` después de completar

---

## 📖 Resumen rápido

| Concepto | Acciones |
|----------|----------|
| **Al inicio** | `/usage` → verifica tokens disponibles |
| **Durante trabajo** | `/stats` cada 15-20 min → monitorea tasa |
| **Entre tareas** | `/clear` → resetea contexto, ahorra tokens |
| **Al 80% cuota** | `/compact` → comprime, recupera ~30K tokens |
| **Documentación** | `CLAUDE.md` → ahorra 5-10K tokens futuras sesiones |

---

**¡Listo para empezar tu proyecto!** 🎯

Con esta estrategia y tus 900K tokens semanales, puedes completar 2-3 proyectos completos de Raspberry Pi/Pico W sin preocuparte por limits.
