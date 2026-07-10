
### **Práctica: Emulación de un Sensor de Temperatura TMP102 sobre I2C en Corellium**

### **Objetivo**

Simular un sensor de temperatura digital **TMP102** utilizando la emulación de dispositivos en **Corellium** y leer los datos de temperatura a través del protocolo **I2C**.

---

### **Paso 1: Acceso a la Plataforma Corellium**

1. **Accede a tu cuenta de Corellium**:

   * Dirígete a la plataforma de **Corellium** usando el enlace de tu cuenta.
   * Inicia sesión si es necesario.

2. **Selecciona un dispositivo virtualizado**:

   * En la página principal de Corellium, selecciona un dispositivo emulado (por ejemplo, **Raspberry Pi 4** con **Ubuntu Server** o cualquier dispositivo que soporte I2C).
   * En la interfaz de Corellium, asegúrate de estar dentro de la consola del dispositivo seleccionado.

---

### **Paso 2: Configuración del Entorno**

1. **Accede a la consola**:

   * En la interfaz web de Corellium, abre la consola (como la que se muestra en tu imagen) donde puedes ejecutar comandos en el dispositivo virtual.

2. **Actualiza el sistema**:

   * En la terminal de Ubuntu, asegúrate de que el sistema esté actualizado. Ejecuta:

     ```bash
     sudo apt update
     sudo apt upgrade -y
     ```

3. **Instala Python y la biblioteca I2C**:

   * Corellium emula un sistema como si fuera un dispositivo real, por lo que debes instalar las herramientas necesarias para trabajar con el sensor TMP102 y el protocolo I2C.

     ```bash
     sudo apt install python3-pip
     sudo apt install python3-smbus  # Biblioteca para trabajar con I2C
     sudo pip3 install smbus2  # Para facilitar la comunicación con I2C
     ```

---

### **Paso 3: Emulación del Sensor de Temperatura TMP102**

Corellium permite emular dispositivos como el TMP102 conectados a un bus **I2C virtualizado**.

1. **Conexión del sensor TMP102**:

   * En la interfaz de Corellium, asegúrate de que el **bus I2C** está habilitado en el dispositivo virtual y que puedes agregar el **sensor TMP102** como un dispositivo virtualizado.
   * Esto lo harás a través de la interfaz de **CoreModel** de Corellium o configurando el dispositivo en la máquina virtual que estás emulando.

   Si la plataforma permite crear dispositivos I2C, puedes crear un modelo para el **sensor TMP102** (en caso de que no lo tengas, usa el código simulado para continuar).

2. **Verifica la conexión I2C**:

   * Ejecuta el siguiente comando para verificar que el bus I2C está disponible y detectando el sensor:

     ```bash
     sudo i2cdetect -y 1
     ```

   Este comando debería mostrar la dirección del TMP102 en el bus I2C (por lo general, `0x48` para el TMP102).

---

### **Paso 4: Escribir y Ejecutar el Código en Python**

1. **Crear el archivo Python para leer la temperatura**:

   * Crea un archivo llamado `sensor_temperatura.py`:

     ```bash
     nano sensor_temperatura.py
     ```

2. **Código de Python para leer la temperatura**:

   * Escribe el siguiente código para interactuar con el sensor TMP102:

     ```python
     import smbus2
     import time

     # Dirección I2C del TMP102
     TMP102_ADDRESS = 0x48
     TEMPERATURE_REGISTER = 0x00  # Registro de temperatura

     # Crear una instancia del bus I2C
     bus = smbus2.SMBus(1)

     # Función para leer la temperatura
     def leer_temperatura():
         # Leer 2 bytes de datos del sensor
         datos = bus.read_i2c_block_data(TMP102_ADDRESS, TEMPERATURE_REGISTER, 2)
         
         # Convertir los datos en un valor de temperatura
         raw_temp = (datos[0] << 8) | datos[1]
         
         # Si el valor es negativo, ajustarlo
         if raw_temp & 0x8000:
             raw_temp -= 1 << 16
         
         # Calcular la temperatura en grados Celsius (resolución de 0.0625°C)
         temperatura = raw_temp * 0.0625
         return temperatura

     # Mostrar la temperatura en un bucle
     try:
         while True:
             temperatura = leer_temperatura()
             print(f"Temperatura: {temperatura:.2f} °C")
             time.sleep(1)  # Esperar 1 segundo antes de leer de nuevo
     except KeyboardInterrupt:
         print("Lectura de temperatura finalizada.")
     ```

   Este código leerá la temperatura desde el sensor TMP102 cada segundo y la imprimirá en la consola.

3. **Guardar y salir**:

   * Después de pegar el código, guarda y sal del editor presionando `CTRL + X`, luego `Y` para confirmar, y `Enter` para salir.

---

### **Paso 5: Ejecución del Código**

1. **Ejecuta el script de Python**:

   En la consola de Corellium, ejecuta el siguiente comando para iniciar el script que leerá la temperatura:

   ```bash
   python3 sensor_temperatura.py
   ```

   Este comando debería comenzar a mostrar la temperatura leída desde el sensor TMP102, emulado por Corellium. Los valores de temperatura se mostrarán en grados Celsius.

---

### **Paso 6: Monitorear la Salida**

* Verás la salida similar a esta:

  ```
  Temperatura: 25.00 °C
  Temperatura: 25.06 °C
  Temperatura: 25.12 °C
  ```

  Esto indica que el sensor está funcionando correctamente y está reportando la temperatura en tiempo real.

---

### **Paso 7: Finalizar y Limpieza**

1. **Interrumpe la ejecución del script**:

   * Si deseas detener el script, simplemente presiona `CTRL + C` en la consola.

2. **Revisar el sistema de logs**:

   * Si necesitas revisar los logs o el estado de la máquina, puedes usar los comandos de administración como:

     ```bash
     dmesg
     tail -f /var/log/syslog
     ```

---

### **Conclusión**

Has creado y ejecutado con éxito una práctica de emulación de un **sensor de temperatura TMP102** en **Corellium** utilizando la emulación I2C. Este ejercicio te ha permitido familiarizarte con la configuración del entorno, la simulación de dispositivos, la escritura de código Python y la ejecución dentro de una máquina virtualizada.


