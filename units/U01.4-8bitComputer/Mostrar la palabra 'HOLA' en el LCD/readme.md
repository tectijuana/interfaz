# Martinez Guzman Leonardo Rafael #22210318
# Mostrar **HOLA** en un LCD (Arduino)

A continuación se muestran los pasos para programar un **LCD 16×2 (HD44780)** con Arduino y mostrar la palabra **HOLA**. Se incluyen dos métodos: **modo paralelo (4-bit)** y **modo I²C**.

---

## 📌 Materiales
- Arduino (Uno, Nano, Mega, etc.)  
- LCD 16×2 (HD44780 o compatible)  
- Potenciómetro de 10 kΩ (para contraste)  
- Cables de conexión  
- (Opcional) Módulo adaptador **I²C** para el LCD  
- Fuente de 5 V (desde Arduino)

---

# 🔹 Método A — Conexión en paralelo (4-bit)

### 1️⃣ Cableado típico
- **VSS** → GND  
- **VDD** → 5V  
- **V0 (contraste)** → cursor central del potenciómetro (otros extremos: 5V y GND)  
- **RS** → Arduino pin **7**  
- **RW** → GND  
- **E** → Arduino pin **8**  
- **D4** → Arduino pin **9**  
- **D5** → Arduino pin **10**  
- **D6** → Arduino pin **11**  
- **D7** → Arduino pin **12**  
- (Opcional) **LED+** → 5V con resistencia (si no la incluye)  
- (Opcional) **LED-** → GND  

---

### 2️⃣ Código Arduino (paralelo)
```cpp
#include <LiquidCrystal.h>

// Configuración: LiquidCrystal(rs, enable, d4, d5, d6, d7)
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

void setup() {
  lcd.begin(16, 2);     // Inicializa el LCD 16x2
  lcd.clear();          // Limpia pantalla
  lcd.setCursor(0, 0);  // Columna 0, fila 0
  lcd.print("HOLA");    // Escribe HOLA
}

void loop() {
  // No se necesita más
}
