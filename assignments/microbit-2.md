¡Claro! A continuación, te presento una práctica detallada para implementar un **termómetro remoto** utilizando la **micro:bit versión 2** con comunicación por **radio**. En este escenario, una micro:bit transmitirá la temperatura medida a través de radio, y una PC en el laboratorio ejecutará una aplicación en **C#** para recibir y mostrar estos datos.

Este proyecto consta de dos partes principales:

1. **Micro:bit Transmisora:** Mide la temperatura y envía los datos vía radio.
2. **Micro:bit Receptora conectada a la PC:** Recibe los datos vía radio y los envía a la PC a través del puerto serial. La PC ejecuta una aplicación en C# que lee y muestra la temperatura recibida.

## **Requisitos Previos**

### **Hardware:**

- **Dos micro:bit versión 2**
- **Dos cables USB** para conectar las micro:bits a las PC (solo la micro:bit receptora necesitará estar conectada a la PC que ejecutará la aplicación en C#).
- **PC con Windows** (para ejecutar la aplicación en C#)
- **Baterías o fuente de alimentación** para la micro:bit transmisora (opcional, si no se conecta a una PC).

### **Software:**

- **Editor para programar las micro:bit:** Recomiendo **Mu Editor** para programar en **MicroPython**.
  - [Descargar Mu Editor](https://codewith.mu/en/download)
- **Visual Studio** (o cualquier otro IDE compatible con C#) para desarrollar la aplicación en C#.
  - [Descargar Visual Studio](https://visualstudio.microsoft.com/es/downloads/)
- **Drivers para micro:bit:** Asegúrate de que Windows reconozca ambas micro:bits. Normalmente, Windows instala los drivers automáticamente al conectar la micro:bit.

## **Arquitectura del Proyecto**

1. **Micro:bit Transmisora:**
   - Lee la temperatura integrada.
   - Envía la temperatura medida a través de la radio.

2. **Micro:bit Receptora:**
   - Escucha los mensajes de radio.
   - Cuando recibe una temperatura, la envía a la PC a través del puerto serial.

3. **Aplicación en C#:**
   - Lee los datos del puerto serial.
   - Muestra la temperatura en una interfaz gráfica.

## **Parte 1: Configurar la Micro:bit Transmisora**

### **Paso 1: Programar la Micro:bit Transmisora**

1. **Abrir Mu Editor:**
   - Descarga e instala [Mu Editor](https://codewith.mu/en/download) si aún no lo tienes.
   - Abre Mu Editor y selecciona el modo **MicroPython**.

2. **Escribir el Código de Transmisión:**

   ```python
   from microbit import *
   import radio
   import utime

   # Inicializar la radio
   radio.on()
   radio.config(channel=7)  # Puedes elegir cualquier canal entre 0 y 83

   while True:
       temp = temperature()
       mensaje = "TEMP:" + str(temp)
       radio.send(mensaje)
       display.show(str(temp))
       sleep(1000)  # Espera 1 segundo antes de la siguiente lectura
       display.clear()
   ```

   **Explicación del Código:**
   - **Inicialización de la Radio:**
     - `radio.on()`: Enciende la radio.
     - `radio.config(channel=7)`: Configura el canal de radio (asegúrate de que ambos micro:bits usen el mismo canal).
   - **Bucle Principal:**
     - Lee la temperatura integrada con `temperature()`.
     - Formatea el mensaje como `"TEMP:<valor>"`.
     - Envía el mensaje vía radio con `radio.send(mensaje)`.
     - Muestra la temperatura en la pantalla de la micro:bit.
     - Espera 1 segundo antes de la siguiente lectura.

3. **Cargar el Programa en la Micro:bit Transmisora:**
   - Guarda el archivo con un nombre descriptivo, por ejemplo, `transmisor.py`.
   - Conecta la micro:bit a la PC mediante el cable USB.
   - Haz clic en el botón **"Flash"** en Mu Editor para cargar el programa a la micro:bit.

### **Paso 2: Verificar el Funcionamiento**

- La micro:bit transmisora debería mostrar la temperatura en su pantalla y enviar continuamente los datos vía radio.

## **Parte 2: Configurar la Micro:bit Receptora y la Aplicación en C#**

### **Paso 1: Programar la Micro:bit Receptora**

1. **Abrir Mu Editor:**
   - Abre una nueva instancia de Mu Editor y selecciona el modo **MicroPython**.

2. **Escribir el Código de Recepción y Transmisión Serial:**

   ```python
   from microbit import *
   import radio

   # Inicializar la radio
   radio.on()
   radio.config(channel=7)  # Debe coincidir con el canal del transmisor

   while True:
       mensaje = radio.receive()
       if mensaje:
           if mensaje.startswith("TEMP:"):
               temp = mensaje.split(":")[1]
               uart.init(baudrate=9600)
               uart.write(temp + "\n")
               display.show(str(temp))
               sleep(1000)
               display.clear()
       sleep(100)  # Pequeña pausa para evitar sobrecarga
   ```

   **Explicación del Código:**
   - **Inicialización de la Radio:**
     - `radio.on()`: Enciende la radio.
     - `radio.config(channel=7)`: Configura el mismo canal que la micro:bit transmisora.
   - **Bucle Principal:**
     - `radio.receive()`: Escucha mensajes entrantes.
     - Si el mensaje comienza con `"TEMP:"`, extrae el valor de la temperatura.
     - Inicializa la comunicación serial (`uart`) a 9600 bps.
     - Envía la temperatura a través del puerto serial.
     - Muestra la temperatura en la pantalla de la micro:bit receptora.
     - Pausa para evitar sobrecarga del display.

3. **Cargar el Programa en la Micro:bit Receptora:**
   - Guarda el archivo con un nombre descriptivo, por ejemplo, `receptor.py`.
   - Conecta la micro:bit receptora a la PC mediante el cable USB.
   - Haz clic en el botón **"Flash"** en Mu Editor para cargar el programa a la micro:bit.

### **Paso 2: Crear la Aplicación en C# para Recibir Datos**

#### **Configuración del Proyecto en Visual Studio**

1. **Instalar Visual Studio:**
   - Si no lo tienes instalado, descarga e instala [Visual Studio Community Edition](https://visualstudio.microsoft.com/es/vs/community/), que es gratuito.

2. **Crear un Nuevo Proyecto:**
   - Abre Visual Studio.
   - Selecciona **"Crear un nuevo proyecto"**.
   - Elige **"Aplicación de Windows Forms (.NET Framework)"** o **"Aplicación de Consola (.NET Core)"** según tu preferencia. Para una interfaz gráfica sencilla, **Windows Forms** es recomendable.
   - Nombra el proyecto, por ejemplo, `TermometroRemoto`.

#### **Implementación de la Aplicación en C#**

A continuación, proporcionaré un ejemplo usando **Windows Forms** para crear una interfaz gráfica que muestra la temperatura recibida.

1. **Agregar Referencia a System.IO.Ports:**
   - En el Explorador de Soluciones, haz clic derecho en **"Referencias"** y selecciona **"Agregar referencia..."**.
   - En la ventana que se abre, busca y selecciona **"System.IO.Ports"** y haz clic en **"Aceptar"**.

2. **Diseñar la Interfaz de Usuario:**
   - Abre el formulario principal (`Form1.cs`) en el diseñador.
   - Agrega los siguientes controles desde la Caja de Herramientas:
     - **Label:** Para mostrar el texto "Temperatura:"
     - **Label:** Para mostrar el valor de la temperatura recibida.
     - **Button:** Para **"Conectar"** y **"Desconectar"** el puerto serial.

   **Ejemplo de Diseño:**

   - **Label1:** `Texto = "Temperatura:"`
   - **Label2:** `Texto = "-- °C"` (este label se actualizará con la temperatura recibida)
   - **Button1:** `Texto = "Conectar"`
   - **Button2:** `Texto = "Desconectar"`

3. **Código del Formulario Principal (`Form1.cs`):**

   ```csharp
   using System;
   using System.IO.Ports;
   using System.Windows.Forms;

   namespace TermometroRemoto
   {
       public partial class Form1 : Form
       {
           private SerialPort _serialPort;

           public Form1()
           {
               InitializeComponent();
               InitializeSerialPort();
           }

           private void InitializeSerialPort()
           {
               _serialPort = new SerialPort();
               _serialPort.BaudRate = 9600;
               _serialPort.Parity = Parity.None;
               _serialPort.StopBits = StopBits.One;
               _serialPort.DataBits = 8;
               _serialPort.Handshake = Handshake.None;
               _serialPort.DataReceived += new SerialDataReceivedEventHandler(DataReceivedHandler);

               // Opcional: Lista de puertos disponibles
               foreach (string port in SerialPort.GetPortNames())
               {
                   comboBoxPorts.Items.Add(port);
               }

               if (comboBoxPorts.Items.Count > 0)
                   comboBoxPorts.SelectedIndex = 0;
           }

           private void buttonConectar_Click(object sender, EventArgs e)
           {
               try
               {
                   _serialPort.PortName = comboBoxPorts.SelectedItem.ToString();
                   _serialPort.Open();
                   labelEstado.Text = "Estado: Conectado";
                   buttonConectar.Enabled = false;
                   buttonDesconectar.Enabled = true;
               }
               catch (Exception ex)
               {
                   MessageBox.Show("Error al abrir el puerto serial: " + ex.Message);
               }
           }

           private void buttonDesconectar_Click(object sender, EventArgs e)
           {
               try
               {
                   _serialPort.Close();
                   labelEstado.Text = "Estado: Desconectado";
                   buttonConectar.Enabled = true;
                   buttonDesconectar.Enabled = false;
               }
               catch (Exception ex)
               {
                   MessageBox.Show("Error al cerrar el puerto serial: " + ex.Message);
               }
           }

           private void DataReceivedHandler(object sender, SerialDataReceivedEventArgs e)
           {
               try
               {
                   string data = _serialPort.ReadLine().Trim();
                   this.BeginInvoke(new Action(() =>
                   {
                       labelTemperatura.Text = data + " °C";
                   }));
               }
               catch (Exception)
               {
                   // Manejo de errores opcional
               }
           }

           private void Form1_FormClosing(object sender, FormClosingEventArgs e)
           {
               if (_serialPort.IsOpen)
                   _serialPort.Close();
           }
       }
   }
   ```

   **Explicación del Código:**
   - **Inicialización del Puerto Serial:**
     - Configura los parámetros del puerto serial (baud rate, paridad, bits de datos, etc.) que deben coincidir con la configuración de la micro:bit receptora.
     - Añade los puertos disponibles a un **ComboBox** (`comboBoxPorts`) para que el usuario seleccione el puerto correcto.
   - **Conectar y Desconectar:**
     - **Botón "Conectar":** Abre el puerto serial seleccionado y actualiza el estado.
     - **Botón "Desconectar":** Cierra el puerto serial y actualiza el estado.
   - **Manejo de Datos Recibidos:**
     - El evento `DataReceivedHandler` se ejecuta cada vez que se reciben datos en el puerto serial.
     - Lee una línea de datos, la limpia y actualiza el **Label** correspondiente con la temperatura recibida.
     - Utiliza `BeginInvoke` para actualizar los controles de la interfaz gráfica desde un hilo diferente.
   - **Cierre del Formulario:**
     - Asegura que el puerto serial se cierre correctamente cuando se cierra la aplicación.

4. **Agregar Controles Adicionales:**

   Para completar la interfaz gráfica, realiza lo siguiente:

   - **ComboBox para Puertos Seriales:**
     - Agrega un **ComboBox** (`comboBoxPorts`) para listar los puertos seriales disponibles.
   - **Label para Estado de Conexión:**
     - Agrega un **Label** (`labelEstado`) para mostrar el estado de la conexión (e.g., "Conectado", "Desconectado").
   - **Label para Temperatura:**
     - Asegúrate de tener un **Label** (`labelTemperatura`) que se actualizará con la temperatura recibida.

   **Ejemplo de Código de Diseño (Opcional):**

   Asegúrate de nombrar los controles correctamente y asociar los eventos de clic de los botones a los métodos correspondientes (`buttonConectar_Click` y `buttonDesconectar_Click`).

5. **Compilar y Ejecutar la Aplicación:**

   - Compila el proyecto para asegurarte de que no haya errores.
   - Ejecuta la aplicación.
   - Selecciona el puerto serial correcto desde el **ComboBox**.
   - Haz clic en **"Conectar"**.
   - La aplicación debería mostrar la temperatura recibida desde la micro:bit transmisora en tiempo real.

### **Paso 3: Verificar el Funcionamiento**

1. **Conectar las Micro:bits:**
   - **Transmisora:** Conecta la micro:bit transmisora a una fuente de alimentación (PC o batería).
   - **Receptora:** Conecta la micro:bit receptora a la PC que ejecutará la aplicación en C# mediante el cable USB.

2. **Ejecutar la Aplicación en C#:**
   - Abre la aplicación en Visual Studio.
   - Selecciona el puerto serial correspondiente a la micro:bit receptora.
   - Haz clic en **"Conectar"**.
   - Observa cómo la temperatura se actualiza en la interfaz gráfica conforme la micro:bit transmisora envía los datos vía radio.

   **Salida Esperada en la Aplicación:**

   ![Interfaz de la Aplicación](https://i.imgur.com/yourimagelink.png) *(Reemplaza con una captura de pantalla real si lo deseas)*

   ```
   Temperatura: 25 °C
   Estado: Conectado
   ```

## **Parte 3: Mejoras y Extensiones Opcionales**

Para enriquecer aún más este proyecto, considera las siguientes mejoras:

1. **Interfaz Gráfica Mejorada:**
   - Utiliza gráficos para mostrar la temperatura a lo largo del tiempo.
   - Añade indicadores visuales para diferentes rangos de temperatura (por ejemplo, colores cambiantes).

2. **Alertas y Notificaciones:**
   - Implementa alertas cuando la temperatura supera ciertos umbrales.
   - Envía notificaciones por correo electrónico o mensajes si la temperatura es demasiado alta o baja.

3. **Registro de Datos:**
   - Guarda las lecturas de temperatura en un archivo o base de datos para análisis posterior.

4. **Comunicación Bidireccional:**
   - Permite que la PC envíe comandos a la micro:bit transmisora para, por ejemplo, ajustar la frecuencia de envío de datos.

5. **Uso de Múltiples Sensores:**
   - Añade más sensores (como de humedad, luminosidad, etc.) y transmite múltiples tipos de datos.

## **Consideraciones Adicionales**

1. **Canales de Radio:**
   - Asegúrate de que ambas micro:bits estén configuradas para usar el mismo canal de radio para evitar interferencias.

2. **Distancia y Obstáculos:**
   - La comunicación por radio tiene un alcance limitado y puede verse afectada por obstáculos físicos. Realiza pruebas en el entorno del laboratorio para asegurar una comunicación estable.

3. **Manejo de Errores:**
   - Implementa verificaciones adicionales para asegurar la integridad de los datos recibidos.
   - Considera agregar mecanismos de reintento o confirmación de recepción.

4. **Optimización de Energía:**
   - Si la micro:bit transmisora funciona con baterías, optimiza el código para reducir el consumo de energía, por ejemplo, reduciendo la frecuencia de envío o utilizando modos de bajo consumo.

## CIERRE

Este proyecto de **termómetro remoto** integra la **micro:bit versión 2** con **C#** para crear una solución completa de monitoreo de temperatura. A través de la comunicación por radio, se logra una transmisión eficiente de datos desde la micro:bit transmisora hasta una PC receptora, donde una aplicación en C# procesa y muestra la información.

Este enfoque no solo refuerza conceptos de programación y comunicación inalámbrica, sino que también proporciona una experiencia práctica valiosa para estudiantes universitarios en áreas de sistemas embebidos, programación de microcontroladores y desarrollo de aplicaciones de escritorio.

