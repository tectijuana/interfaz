
Ahora vamos a adaptar esta práctica para **simular un sensor GPS** en lugar de un sensor de temperatura.

En este caso, el GPS generalmente se conecta a un dispositivo a través de una interfaz **serial (UART)**, y su salida son coordenadas geográficas (latitud, longitud) que se actualizan en tiempo real. Vamos a simular un **módulo GPS** conectado a un puerto UART en un entorno virtualizado como **Corellium**.

Te guiaré para crear una práctica similar a la anterior, pero con un **GPS simulado**.

### **Práctica: Emulación de un Sensor GPS sobre UART en Corellium**

### **Objetivo**

Simular un **sensor GPS** que emite datos sobre la posición (latitud, longitud) en formato **NMEA** a través de la interfaz **UART** y leer esos datos en un sistema virtualizado usando **Corellium**.

---

### **Paso 1: Acceso a la Plataforma Corellium**

1. **Accede a tu cuenta de Corellium**:

   * Dirígete a la plataforma de **Corellium** usando el enlace de tu cuenta.
   * Inicia sesión si es necesario.

2. **Selecciona un dispositivo virtualizado**:

   * En la página principal de Corellium, selecciona un dispositivo emulado (por ejemplo, **Raspberry Pi 4** con **Ubuntu Server** o cualquier dispositivo que soporte UART).
   * Asegúrate de estar en la **consola** del dispositivo seleccionado.

---

### **Paso 2: Configuración del Entorno**

1. **Accede a la consola**:

   * En la interfaz web de Corellium, abre la consola de terminal, donde podrás ejecutar comandos en el dispositivo virtual.

2. **Actualiza el sistema**:

   * Actualiza el sistema de la máquina virtual emulada para asegurarte de que todo esté al día:

     ```bash
     sudo apt update
     sudo apt upgrade -y
     ```

3. **Instala Python y la biblioteca de comunicación UART**:

   * Asegúrate de que Python y las herramientas necesarias para la comunicación UART estén instaladas:

     ```bash
     sudo apt install python3-pip
     sudo apt install pyserial  # Biblioteca para trabajar con puertos UART
     ```

---

### **Paso 3: Emulación del Módulo GPS**

1. **Conexión del GPS emulado**:

   * En Corellium, puedes simular el puerto UART y conectar un módulo **GPS** que emule las salidas NMEA. Aunque en la práctica real un GPS enviaría cadenas NMEA por UART, en Corellium puedes configurar el bus UART como un **dispositivo virtualizado** y asociarlo con un puerto que simule los datos GPS.

   * Si Corellium tiene soporte para dispositivos UART, puedes crear un puerto virtual UART donde se simulen los datos GPS.

   Si la plataforma lo permite, puedes emular la salida de un módulo GPS enviando cadenas de datos como las siguientes:

   ```txt
   $GPGGA,123519,4807.038,N,01131.000,E,1,08,0.9,545.4,M,46.9,M,,*47
   $GPRMC,123519,A,4807.038,N,01131.000,E,022.4,084.4,230394,003.1,W*6A
   ```

   * Estas son cadenas típicas del protocolo NMEA que un **módulo GPS real** enviaría.

---

### **Paso 4: Escribir y Ejecutar el Código en Python**

1. **Crear el archivo Python para leer los datos GPS**:

   * Crea un archivo llamado `leer_gps.py` en la consola de Corellium:

     ```bash
     nano leer_gps.py
     ```

2. **Código de Python para leer los datos GPS**:

   * Usa el siguiente código Python para leer las cadenas NMEA del puerto UART y extraer la información relevante (latitud, longitud):

     ```python
     import serial
     import time

     # Configura el puerto UART (ajusta el nombre del puerto según Corellium)
     UART_PORT = "/dev/ttyAMA0"  # O el puerto que Corellium emule para UART
     BAUD_RATE = 9600  # Velocidad de transmisión típica para GPS

     # Abre el puerto UART
     ser = serial.Serial(UART_PORT, BAUD_RATE, timeout=1)

     # Función para parsear las cadenas NMEA
     def parse_nmea(sentence):
         if sentence.startswith('$GPGGA'):  # Comienza con la información GGA
             data = sentence.split(',')
             lat = data[2]
             lon = data[4]
             print(f"Latitud: {lat}, Longitud: {lon}")

     try:
         while True:
             # Lee una línea desde el puerto UART
             line = ser.readline().decode('ascii', errors='replace').strip()
             if line:
                 parse_nmea(line)
             time.sleep(1)
     except KeyboardInterrupt:
         print("Lectura de GPS finalizada.")
         ser.close()
     ```

   **Explicación del código**:

   * **`serial.Serial()`**: Abre el puerto UART para leer datos del GPS simulado.
   * **`parse_nmea()`**: Función para extraer latitud y longitud de las cadenas NMEA recibidas.
   * **`ser.readline()`**: Lee las líneas del puerto UART que emulan las cadenas NMEA de un GPS.
   * El código se ejecuta en un bucle infinito, leyendo las cadenas y mostrando las coordenadas de latitud y longitud en tiempo real.

3. **Guardar y salir**:

   * Después de pegar el código, guarda y sal del editor presionando `CTRL + X`, luego `Y` para confirmar, y `Enter` para salir.

---

### **Paso 5: Ejecución del Código**

1. **Ejecuta el script de Python**:

   En la consola de Corellium, ejecuta el siguiente comando para iniciar el script que leerá los datos GPS:

   ```bash
   python3 leer_gps.py
   ```

   Este comando debería comenzar a mostrar las coordenadas GPS leídas desde el sensor GPS simulado en Corellium. Ejemplo de salida:

   ```txt
   Latitud: 4807.038, Longitud: 01131.000
   Latitud: 4807.039, Longitud: 01131.001
   ```

---

### **Paso 6: Monitorear la Salida**

* Verás las coordenadas de latitud y longitud que el **GPS simulado** emite en formato NMEA.

---

### **Paso 7: Finalizar y Limpieza**

1. **Interrumpe la ejecución del script**:

   * Si deseas detener el script, simplemente presiona `CTRL + C` en la consola.

2. **Revisar los logs del sistema**:

   * Si necesitas revisar los logs o el estado de la máquina, puedes usar los siguientes comandos:

     ```bash
     dmesg
     tail -f /var/log/syslog
     ```

---

Este ejercicio te permite interactuar con dispositivos emulados y obtener datos GPS, tal como lo harías con un módulo GPS físico real.


