# Práctica con Micro:bit 2.0 y C# en Windows 10/11

## Introducción

La **BBC micro:bit** es una pequeña placa de desarrollo diseñada para facilitar el aprendizaje de la programación y la electrónica. La versión 2.0 incluye mejoras como:

- Procesador más potente.
- Micrófono y altavoz integrados.
- Sensor táctil.
- Conectividad Bluetooth y USB.

En esta lección, aprenderás a:

- Programar la micro:bit para enviar datos al PC.
- Desarrollar una aplicación en C# que se comunique con la micro:bit.
- Establecer conectividad entre la micro:bit y una aplicación de escritorio en Windows 10/11.

## Objetivos

- **Programar** la micro:bit para enviar datos vía puerto serial.
- **Desarrollar** una aplicación en C# para leer datos desde la micro:bit.
- **Comprender** cómo establecer comunicación serial entre dispositivos.

## Requisitos

- Una **micro:bit versión 2.0**.
- Cable USB para conectar la micro:bit al PC.
- **Visual Studio 2019** o superior instalado en Windows 10/11.
- Conexión a Internet para descargar paquetes NuGet si es necesario.

---

## Programación de la micro:bit

### Paso 1: Acceder al editor de MakeCode

1. Visita [Microsoft MakeCode para micro:bit](https://makecode.microbit.org/).
2. Crea un **nuevo proyecto**.

### Paso 2: Escribir el código para la micro:bit

Utilizaremos JavaScript (TypeScript) en el editor de MakeCode.

```javascript
let contador = 0
input.onButtonPressed(Button.A, function () {
    contador += 1
    basic.showNumber(contador)
    serial.writeLine(contador.toString())
})
```

#### Explicación del código

- **Inicialización**:
  - `let contador = 0`: Declara una variable `contador` y la inicializa en 0.
- **Evento al presionar el botón A**:
  - `input.onButtonPressed(Button.A, function () { ... })`: Define una función que se ejecuta al presionar el botón A.
  - `contador += 1`: Incrementa la variable `contador` en 1.
  - `basic.showNumber(contador)`: Muestra el valor actual de `contador` en la pantalla de la micro:bit.
  - `serial.writeLine(contador.toString())`: Envía el valor de `contador` al puerto serial como una cadena de texto.

### Paso 3: Descargar el programa a la micro:bit

1. Haz clic en **"Descargar"** en el editor de MakeCode.
2. Copia el archivo `.hex` descargado a la micro:bit:
   - La micro:bit aparecerá como una unidad de almacenamiento extraíble.
   - Arrastra y suelta el archivo `.hex` en la unidad de la micro:bit.

---

## Desarrollo de la aplicación en C#

### Paso 1: Crear un nuevo proyecto en Visual Studio

1. Abre **Visual Studio**.
2. Selecciona **"Crear un nuevo proyecto"**.
3. Elige **"Aplicación de consola"** (.NET Core o .NET 5/6/7).
4. Nombra el proyecto como `MicrobitSerialReader`.

### Paso 2: Agregar el paquete System.IO.Ports

Si estás utilizando .NET Core o superior, es posible que necesites instalar el paquete `System.IO.Ports`:

1. Haz clic derecho en el proyecto y selecciona **"Administrar paquetes NuGet"**.
2. Busca `System.IO.Ports` y asegúrate de que está instalado.

### Paso 3: Escribir el código en C#

```csharp
using System;
using System.IO.Ports;

namespace MicrobitSerialReader
{
    class Program
    {
        static void Main(string[] args)
        {
            // Configurar el puerto serial
            SerialPort puertoSerial = new SerialPort();

            // Establecer el nombre del puerto (verificar en el Administrador de dispositivos)
            puertoSerial.PortName = "COM3"; // Cambiar al puerto correspondiente

            // Configurar la velocidad de baudios
            puertoSerial.BaudRate = 115200;

            // Otros parámetros del puerto serial
            puertoSerial.Parity = Parity.None;
            puertoSerial.DataBits = 8;
            puertoSerial.StopBits = StopBits.One;
            puertoSerial.Handshake = Handshake.None;

            // Evento para manejar los datos recibidos
            puertoSerial.DataReceived += new SerialDataReceivedEventHandler(DatosRecibidos);

            try
            {
                // Abrir el puerto serial
                puertoSerial.Open();
                Console.WriteLine("Conexión establecida. Presiona ENTER para finalizar.");
                Console.ReadLine();
                // Cerrar el puerto serial al finalizar
                puertoSerial.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al abrir el puerto serial: " + ex.Message);
            }
        }

        private static void DatosRecibidos(object sender, SerialDataReceivedEventArgs e)
        {
            // Leer los datos recibidos
            SerialPort sp = (SerialPort)sender;
            string datos = sp.ReadLine();
            Console.WriteLine("Datos recibidos: " + datos);
        }
    }
}
```

#### Explicación del código

- **Espacios de nombres**:
  - `using System;`: Incluye funcionalidades básicas de C#.
  - `using System.IO.Ports;`: Permite trabajar con puertos seriales.
- **Configuración del puerto serial**:
  - `SerialPort puertoSerial = new SerialPort();`: Crea una instancia del puerto serial.
  - `puertoSerial.PortName = "COM3";`: Especifica el puerto COM (debes verificar cuál es en tu sistema).
  - `puertoSerial.BaudRate = 115200;`: Configura la velocidad de transmisión.
  - Otros parámetros (`Parity`, `DataBits`, `StopBits`, `Handshake`) se establecen para coincidir con la configuración de la micro:bit.
- **Evento DataReceived**:
  - `puertoSerial.DataReceived += new SerialDataReceivedEventHandler(DatosRecibidos);`: Asocia el evento de recepción de datos con el método `DatosRecibidos`.
- **Método DatosRecibidos**:
  - Lee los datos entrantes y los muestra en la consola.
- **Manejo de excepciones**:
  - Utiliza un bloque `try-catch` para manejar posibles errores al abrir el puerto.

### Paso 4: Identificar el puerto COM de la micro:bit

1. Conecta la micro:bit al PC.
2. Abre el **Administrador de dispositivos**.
3. Expande la sección **"Puertos (COM y LPT)"**.
4. Busca un dispositivo llamado **"BBC micro:bit CMSIS-DAP (COMx)"**.
5. Anota el número de puerto COM (por ejemplo, COM3) y actualiza `puertoSerial.PortName` en el código.

---

## Ejecución y Pruebas

### Paso 1: Ejecutar la aplicación en C#

1. Presiona **F5** o haz clic en **"Iniciar"** para ejecutar la aplicación.
2. Deberías ver el mensaje: `Conexión establecida. Presiona ENTER para finalizar.`

### Paso 2: Interactuar con la micro:bit

1. Presiona el **botón A** en la micro:bit.
2. Observa cómo el contador incrementa en la pantalla de la micro:bit.
3. En la consola de Visual Studio, deberías ver los datos recibidos:

```
Datos recibidos: 1
Datos recibidos: 2
Datos recibidos: 3
...
```

### Paso 3: Finalizar la aplicación

- Cuando hayas terminado, vuelve a la consola y presiona **ENTER** para cerrar el puerto serial y finalizar la aplicación.

---

## Conclusión

En esta práctica, has aprendido a:

- Programar la micro:bit para enviar datos a través del puerto serial.
- Configurar y utilizar una aplicación en C# para leer datos desde un puerto serial.
- Establecer comunicación entre hardware y software en un entorno Windows.

Este es un punto de partida para desarrollar proyectos más avanzados que involucren interacción en tiempo real entre la micro:bit y aplicaciones de escritorio.

---

## Notas Adicionales

- **Seguridad**: Asegúrate de manejar adecuadamente las excepciones para evitar bloqueos en tu aplicación.
- **Puerto Serial Único**: Sólo una aplicación puede acceder al puerto serial a la vez. Cierra otras aplicaciones que puedan estar utilizando el puerto (por ejemplo, programas de monitoreo serial).
- **Extensiones**: Puedes ampliar este ejemplo para enviar comandos desde la aplicación en C# a la micro:bit.

---

¡Felicidades! Has completado con éxito la práctica de comunicación entre la micro:bit y una aplicación de escritorio en C#.
