
![raspberry_pi_cable_pins_labels](https://github.com/user-attachments/assets/d9c8d283-a2ca-442d-877f-35c2c8269f84)


# Conectar Raspberry Pi Zero 2W a un cable consola FTDI con PuTTY

### **Objetivo:**
Aprender a conectar y acceder a la Raspberry Pi Zero 2W utilizando un cable consola FTDI y PuTTY para comunicación serie sin necesidad de usar alimentación por el cable FTDI (solo tierra, RX y TX).

---

### **Materiales necesarios:**
1. **Raspberry Pi Zero 2W**
2. **Cable consola FTDI (sin uso del pin de voltaje, solo GND, RX, TX)**
3. **PuTTY (software de terminal)**
4. **Cable microUSB para alimentar la Raspberry Pi Zero 2W**
5. **Una computadora con sistema operativo Windows, macOS o Linux**

---
Referencia: https://learn.adafruit.com/raspberry-pi-zero-creation/give-it-life
---

### **Paso 1: Conectar el cable FTDI a la Raspberry Pi Zero 2W**

1. **Identificar los pines GPIO** de la Raspberry Pi Zero 2W. Para la comunicación serie, utilizaremos los siguientes pines:
   - **GND** (Pin 6)
   - **TX (GPIO14)** (Pin 8)
   - **RX (GPIO15)** (Pin 10)

2. **Conectar el cable FTDI a los pines GPIO**:
   - El cable FTDI tiene varios cables de colores. Conéctalos de la siguiente manera:
     - **Negro (GND)** al **Pin 6 (GND)** de la Pi Zero.
     - **Blanco (RX)** al **Pin 8 (TX)** de la Pi Zero (para recibir datos desde la Raspberry Pi).
     - **Verde (TX)** al **Pin 10 (RX)** de la Pi Zero (para enviar datos a la Raspberry Pi).

   > **Nota:** No conectes el cable de **voltaje (rojo)**. Solo utilizaremos tierra (GND), transmisión (TX) y recepción (RX).

---

### **Paso 2: Instalar el driver del cable FTDI en la computadora**

1. **Descargar el driver del cable FTDI** correspondiente a tu sistema operativo:
   - [FTDI Drivers](https://ftdichip.com/drivers/)

2. **Instalar el driver** siguiendo las instrucciones del fabricante.

---

### **Paso 3: Configurar PuTTY**

1. **Descargar PuTTY** desde su sitio oficial: [PuTTY](https://www.putty.org/).

2. **Conectar el cable FTDI a la computadora** a través del puerto USB.

3. **Abrir PuTTY** y configurar la conexión serial:
   - En **Session** (sesión), selecciona la opción **Serial**.
   - En **Serial line**, selecciona el puerto COM correspondiente al cable FTDI (en Windows puedes verlo en el **Administrador de dispositivos**).
   - En **Speed**, coloca **115200** baudios, que es la velocidad estándar para la conexión serie en Raspberry Pi.

4. En la sección de **Connection > Serial**, ajusta los parámetros adicionales:
   - **Data bits**: 8
   - **Stop bits**: 1
   - **Parity**: None
   - **Flow control**: None

5. Haz clic en **Open** para iniciar la sesión de terminal.

---

### **Paso 4: Alimentar la Raspberry Pi y acceder a la consola**

1. **Conectar la Raspberry Pi Zero 2W** a la fuente de alimentación utilizando un cable microUSB.

2. Una vez encendida la Raspberry Pi, verás que PuTTY comienza a mostrar los mensajes de arranque en la ventana de la consola.

3. **Accede al sistema** introduciendo tus credenciales cuando se te solicite.

---

### ACTUALIZACION DEL FIRMWARE DE RASPBERRY ZERO 2W

