# Claude Code: Pagar para trabajar más de 6 horas
## Guía completa sobre Extra Usage y opciones de planes

---

## ⚠️ La realidad: 5 horas de ventana, NO 6 horas

Primero, aclaremos: Claude Code tiene una **ventana de 5 horas que se reinicia automáticamente**, no 6 horas.

Pero **SÍ puedes pagar para continuar trabajando** una vez alcanzadas esas 5 horas.

---

## 🎯 Opciones para trabajar más tiempo

### Opción 1: Extra Usage (Continúa pagando en ventana actual)

**¿Qué es?** Cuando alcanzas tu límite de tokens en la ventana de 5 horas, puedes habilitar "extra usage" y pagar por tokens adicionales **sin esperar el reinicio**.

**Ventaja:** Continúas inmediatamente, no esperas 5 horas.

**Costo:** Tarifas API estándar:
- **Sonnet 4.6** (recomendado): $3 por millón de tokens input, $15 millones output
- **Opus 4.7** (más potente): $5 input, $25 output
- **Haiku 4.5** (más rápido): $1 input, $5 output

**Cómo habilitar:**
1. Ve a Settings > Usage en claude.ai
2. Activa "Extra usage"
3. Establece un límite de gasto máximo (ej: $10/día)
4. Listo, pagas solo por lo que uses

---

### Opción 2: Actualizar plan a Max (menos interrupciones)

**Pro Plan → Max Plan:** Si trabajas frecuentemente, es más económico actualizar.

| Plan | Costo mensual | Tokens por 5h | Mejor para |
|------|---------------|---------------|-----------|
| **Pro** | $20 | ~44,000 | Uso ocasional (<5 sesiones/semana) |
| **Max 5x** | $100 | ~220,000 | Uso regular (5-7 sesiones/semana) |
| **Max 20x** | $200 | ~880,000 | Uso intensivo (diario) |

**Ejemplo:** Si trabajas 3-4 horas diarias en Claude Code:
- **Pro + Extra Usage:** ~$20 + $50-100/mes extra = $70-120/mes
- **Max 20x:** $200/mes (incluido todo, sin restricciones adicionales)

⚠️ **NOTA:** Desde agosto 2025 hay también **límites semanales** además de la ventana de 5 horas. Max agrega más límites semanales.

---

## 📊 Costo real si trabajas 6 horas (extra usage)

### Escenario: Trabajas 5h + necesitas 1 hora más

**Tareas típicas en sistemas embebidos:**
- Sensor + LCD: ~15-20K tokens (2 horas)
- WiFi + cloud: ~15-20K tokens (2 horas)
- Debugging: ~25-35K tokens (1 hora)

**Total en 5 horas:** ~40K tokens  
**Hora 6 (debugging extra):** ~8K tokens más

**Costo con Extra Usage (Sonnet):**
```
8,000 tokens input @ $3/MTok = $0.024
2,000 tokens output @ $15/MTok = $0.03
Total hora 6: ~$0.05 (prácticamente gratis)
```

**Si necesitas trabajar MUCHAS horas extra (100K tokens):**
```
100,000 input @ $3 = $0.30
20,000 output @ $15 = $0.30
Total: ~$0.60 por 100K tokens
```

---

## 🛠️ Estrategia recomendada para tu caso (Pico W + CLI documentation)

### Si trabajas esporádicamente (1-2 veces/semana)

**✅ Recomendación: Pro + Extra Usage**

```
Costo base: $20/mes (Pro)
Extra usage: ~$30-50/mes
Total: $50-70/mes

Con esto:
- 5h ventana regular: 44K tokens
- Extra horas pagadas: sin límite práctico
- Switch a Sonnet: barato si necesitas muchas horas
```

**Plan de trabajo:**
```
Sesión 1 (5 horas):
  - /usage → 44K tokens Pro
  - 3 componentes embebidos completados
  - /stats → consumí 35K tokens
  - Salgo

Sesión 2 (después 5+ horas):
  - Reinicia ventana automática
  - Otros 44K tokens disponibles
```

---

### Si trabajas regularmente (4-6 horas, 3+ veces/semana)

**✅ Recomendación: Max 5x**

```
Costo: $100/mes
Beneficio: 220K tokens por ventana de 5 horas

Comparación:
- Pro + extra típico: $70-90/mes
- Max 5x: $100/mes
- Ventaja: 5x más tokens, sin preocuparse por extra costs
```

**Ejemplo mes con 3 sesiones intensivas:**
```
Semana 1: Sesión 3 horas (sensor + LCD) = 40K tokens
Semana 2: Sesión 5 horas (WiFi + cloud) = 70K tokens
Semana 3: Sesión 4 horas (debugging) = 50K tokens
Semana 4: Sesión 2 horas (documentación) = 15K tokens

Total: 175K tokens consumidos
- Con Pro: $20 + $80 extra = $100 ✗ (casi igual que Max)
- Con Max 5x: $100 todo incluido ✓ (mejor)
```

---

### Si trabajas intensivo (6+ horas diarias)

**✅ Recomendación: Max 20x O API Pay-as-you-go**

```
Max 20x: $200/mes
- 880K tokens por ventana de 5h
- Semana típica: 2-3 sesiones sin estrés
- Extra: acceso a Opus (más potente)

API Pay-as-you-go:
- Sonnet: $3/$15 per million tokens
- Sin caps, sin límites semanales
- Útil si trabajo es muy variable
```

**Desglose de costos API (Sonnet):**
```
100K tokens/hora × 6 horas = 600K tokens/sesión

Estimado:
- Input (60%): 360K @ $3/M = $1.08
- Output (40%): 240K @ $15/M = $3.60
- Total/sesión: ~$4.68
- Mes (5 sesiones): ~$23/mes

Pero con caching (Claude Code lee archivos repetidamente):
- Cache reads: 90% del uso, cuesta 0.1x
- Cache writes: 6% del uso, cuesta 1.25x
- Input/output: <1% del uso

Realidad mes 5 sesiones intensas: ~$100-150/mes API
```

**Verdict: Max 20x vale la pena ($200/mes) vs API (~$150/mes) si usas Opus frecuentemente.**

---

## 💰 Tabla de decisión

### ¿Cuándo actualizar a qué plan?

```
Mi uso actual:          Recomendación:           Costo esperado:
────────────────────────────────────────────────────────────────
<1 sesión/semana       Pro + Extra Usage         $20-40/mes
1-3 sesiones/semana    Pro + Extra Usage         $40-70/mes
3-5 sesiones/semana    Max 5x                    $100/mes
5+ sesiones/semana     Max 5x o Max 20x          $100-200/mes
Diario (6+ horas)      Max 20x o API             $150-300/mes
```

---

## 🚀 Cómo habilitar Extra Usage ahora

### Paso 1: Entra en Settings de Claude

```
1. Ve a claude.ai
2. Haz clic en tu avatar (esquina superior derecha)
3. Selecciona "Settings"
4. Ve a "Usage"
```

### Paso 2: Activa Extra Usage

```
1. Busca "Extra Usage"
2. Haz clic en "Enable"
3. Confirma tu método de pago (tarjeta)
4. Establece límite de gasto (ej: $5/día, $50/mes)
5. Listo
```

### Paso 3: En Claude Code, monitorea

```bash
$ /usage
→ Quota: 40,000 / 44,000 (Pro)

[Trabajas más, alcanzas límite]

$ /usage
→ Quota: 0 / 44,000 (Pro)
→ Extra Usage: ENABLED
→ Remaining: $50 budget available
```

Continúas sin interrupciones, pagando solo lo extra que uses.

---

## 🎯 Mejor práctica para tu caso específico

**Proyecto: Documentación CLI + Pico W/Raspberry Pi**

### Sesión típica (planeada para 6 horas)

```bash
# Hora 1-5 (Ventana Pro estándar: 44K tokens)
$ claude code
$ /usage
→ 44,000 tokens disponibles

# Tarea 1: Código sensor (1 hora, 15K tokens)
# Tarea 2: LCD integration (1 hora, 15K tokens)
# Tarea 3: WiFi + cloud (1.5 horas, 10K tokens)
# Tarea 4: Debugging (1.5 horas, 4K tokens)
→ Total usado: 44K tokens (perfecto)

# Hora 6 (si necesitas continuar: Extra Usage)
$ /usage
→ Quota: 0 / 44,000 (Pro limit reached)
→ Extra Usage: ENABLED, $40 available

# Tarea 5: Documentación markdown (1 hora, 5K tokens)
→ Costo extra: ~$0.15 (prácticamente gratis)

$ /usage
→ Extra Usage spent: $0.15
```

**Presupuesto mes (3 sesiones):**
```
Pro plan: $20
Extra usage típico: $0.50 (casi nada)
Total: $20.50/mes

Presupuesto anual: ~$250
```

---

## ⚠️ Cuidados importantes

### 1. Entender la ventana de 5 horas

```
INCORRECTO:
"Trabajo 6 horas seguidas, ¿cuándo se reinicia?"
→ La ventana es DESDE tu primer mensaje

CORRECTO:
"Empiezo 09:00 → ventana va hasta 14:00
 Puedo continuar pagando después de 14:00 con Extra Usage"
```

### 2. Limits semanales (desde agosto 2025)

Además de la ventana de 5h, hay **limits semanales**:
- Pro: límite semanal bajo
- Max 5x: límite semanal 5x mayor
- Max 20x: límite semanal 20x mayor

**Implicación:** Si trabajas TODOS los días, Max conviene.

### 3. Modelo importa mucho

```
Sonnet 4.6: $3/$15 per M tokens (recomendado)
Opus 4.7: $5/$25 per M tokens (33% más caro)
Haiku 4.5: $1/$5 per M tokens (pero menos potente)

Cambiar a Opus por error = 10-20% de costo extra
```

**En Claude Code, cambia modelo con:**
```bash
$ /model
```

---

## 📋 Checklist antes de empezar

- [ ] ¿Tengo Pro plan activado? (o Max)
- [ ] ¿Habilité Extra Usage? (Settings > Usage)
- [ ] ¿Configuré límite de gasto? (ej: $10/día)
- [ ] ¿Mi tarjeta de crédito está validada?
- [ ] ¿Estoy usando Sonnet 4.6 (no Opus)?
- [ ] ¿Creé `CLAUDE.md` para ahorrar tokens?
- [ ] ¿Planeo usar `/compact` y `/clear`?

---

## 🎯 Resumen: ¿Cuánto gastaré?

### Escenario realista: Trabajas 6 horas/semana en Pico W

```
Opción A: Pro + Extra Usage
─────────────────────────────
Pro plan base:      $20/mes
Extra usage típico: $5-10/mes (ocasional overflow)
Total:              $25-30/mes
Anual:              ~$300-360

Opción B: Max 5x (si trabajas 3+ sesiones/semana)
─────────────────────────────
Max 5x plan:        $100/mes
Total:              $100/mes
Anual:              ~$1,200

VERDICT: Pro + Extra Usage es más económico para tu caso
COSTO REAL: ~$25-30/mes (~$300/año)
```

---

## ✅ Próximos pasos

1. **Abre Settings en claude.ai**
2. **Ve a Usage → Enable Extra Usage**
3. **Establece límite de gasto (ej: $5/día)**
4. **Confirma tarjeta de pago**
5. **Inicia Claude Code:** `$ claude code`
6. **Verifica:** `$ /usage` debe mostrar "Extra Usage: ENABLED"
7. **Trabaja sin preocuparte** — pagas solo lo que use extra

---

## 📚 Recursos adicionales

- **Help Center:** https://support.claude.com/en/articles/12429409-manage-extra-usage-for-paid-claude-plans
- **Claude Code Help:** https://support.claude.com/en/articles/11145838-use-claude-code-with-your-pro-or-max-plan
- **Settings > Usage:** Dashboard donde ves gasto en tiempo real

---

**¡Listo! Ya puedes trabajar más de 5 horas pagando solo por lo extra.** 💰

Presupuesto estimado: **$25-30/mes** para 6 horas/semana de embedded systems.
