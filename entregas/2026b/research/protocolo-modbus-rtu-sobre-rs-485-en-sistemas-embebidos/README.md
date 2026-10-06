# Protocolo Modbus RTU sobre RS-485 en sistemas embebidos

Nombre: Moguel Benitez Dafne Jael

Número de Control: 22211616

Fecha: 19 de septiembre de 2026

## 1. Introducción

En una planta, un tablero de control o una red de sensores rara vez hay una sola tarjeta trabajando sola. Lo habitual es que un microcontrolador tenga que hablar con medidores de energía, variadores de frecuencia, sensores de temperatura o PLC que están a decenas o cientos de metros. Para eso se necesita un medio físico robusto y un protocolo sencillo. La combinación más común en la industria es **Modbus RTU sobre RS-485**.

Son dos cosas distintas que conviene no mezclar:

- **RS-485** es la capa física. Define cómo se representan eléctricamente los bits en el cable. Según Texas Instruments, es un estándar exclusivamente eléctrico: describe las características de transmisores y receptores para una línea balanceada multipunto, pero no define el protocolo ni el conector.
- **Modbus RTU** es la capa de aplicación. Define quién habla, qué formato tiene cada mensaje y cómo se detectan los errores. Modbus fue creado por Modicon en 1979 y hoy lo mantiene la Modbus Organization.

Este trabajo explica cómo funcionan ambos, cómo se combinan en un sistema embebido y qué problemas reales aparecen al implementarlos.

<img width="1163" height="514" alt="captura-de-pantalla-de-2025-01-27-15-12-48-mP423lxb5lIJp8b3" src="https://github.com/user-attachments/assets/5322194e-97b2-4c79-9316-69feddfe0caf" />


## 2. Desarrollo técnico

### 2.1 La capa física: RS-485

RS-485 usa **señalización diferencial**: cada bit se transmite con dos hilos, A y B, y el receptor interpreta la *diferencia* de voltaje entre ellos, no el voltaje respecto a tierra. Un receptor RS-485 detecta un estado lógico cuando la diferencia supera ±200 mV. Como el ruido electromagnético suele afectar a los dos hilos por igual, se cancela en la resta. Por eso RS-485 tolera mejor el ruido industrial que RS-232, que usa señales referidas a tierra.

Sus características principales son:

- **Topología multipunto en bus (daisy-chain):** los nodos se conectan a un cable troncal mediante derivaciones (*stubs*) muy cortas.
- **Distancia y velocidad:** el compromiso es inverso. Como referencia, TI cita hasta 4000 pies (unos 1200 m) a 100 kbps. A velocidades mayores la distancia útil baja.
- **Half-duplex de dos hilos** (lo más común) o full-duplex de cuatro hilos. En half-duplex, todos comparten el mismo par, así que solo un nodo puede transmitir a la vez.
- **Terminación:** se colocan resistencias de unos 120 Ω (la impedancia característica del cable) en los dos extremos del bus, no en los nodos intermedios, para evitar reflexiones.
- **Polarización (biasing / fail-safe):** cuando nadie transmite, el bus queda flotando y puede generar bytes basura. Se agregan resistencias que fijan un estado de reposo conocido.
- **Carga del bus:** el estándar clásico permite 32 unidades de carga; con transceptores de 1/8 de carga se pueden conectar hasta 256 nodos.

En un sistema embebido, el microcontrolador no genera niveles RS-485 directamente. Se usa un **transceptor** como el MAX485 o los de la familia THVD de TI, que se conecta a los pines TX y RX de la UART. Además, tiene pines **DE** (Driver Enable) y **/RE** (Receiver Enable), normalmente unidos y controlados por un GPIO: en alto el chip transmite, en bajo escucha. Esto es lo que vuelve delicada la programación, como se verá en la sección 2.5.

### 2.2 Modelo maestro/esclavo de Modbus

Modbus funciona con un modelo **cliente/servidor** (antes llamado maestro/esclavo):

- Un solo maestro inicia todas las transacciones.
- Los esclavos solo responden cuando se les pregunta; nunca hablan por iniciativa propia.
- Las direcciones de esclavo van de **1 a 247**. La dirección **0** es *broadcast* (todos reciben y ninguno responde).

Esto evita colisiones en un bus half-duplex compartido: al haber un único maestro que pregunta, en cada instante solo un nodo tiene la palabra.

### 2.3 Trama Modbus RTU

Una trama RTU tiene esta estructura:

| Campo | Tamaño | Contenido |
|---|---|---|
| Dirección | 1 byte | Esclavo destino (1–247) |
| Código de función | 1 byte | Operación solicitada |
| Datos | N bytes | Parámetros o respuesta |
| CRC | 2 bytes | CRC-16, primero el byte bajo |

El campo de datos es de tipo *big-endian* (byte alto primero), pero el CRC se envía al revés (byte bajo primero). Es una fuente clásica de errores al implementar el protocolo.

La PDU (código de función + datos) tiene un máximo de 253 bytes, por lo que la trama RTU completa mide como máximo 256 bytes.

**Funciones más usadas:**

| Código | Operación |
|---|---|
| 0x01 | Leer *coils* (salidas digitales) |
| 0x02 | Leer entradas discretas |
| 0x03 | Leer *holding registers* |
| 0x04 | Leer *input registers* |
| 0x05 / 0x06 | Escribir un coil / un registro |
| 0x0F / 0x10 | Escribir varios coils / varios registros |

Modbus organiza los datos en cuatro tablas (coils, entradas discretas, input registers y holding registers), y cada una tiene sus propias direcciones. Un registro tiene 16 bits. Si se quiere transmitir un valor de 32 bits o un `float`, hay que usar dos registros consecutivos, y el orden de las palabras no está estandarizado: depende del fabricante.

**Ejemplo real de una transacción.** Se pide al esclavo 1 leer 2 registros holding desde la dirección 0. Calculé los CRC con el algoritmo estándar (polinomio 0xA001, valor inicial 0xFFFF):

```
Petición:   01 03 00 00 00 02 C4 0B
            │  │  └──┬──┘ └──┬──┘ └─ CRC (bajo, alto)
            │  │  dirección  cantidad
            │  └─ función 0x03
            └─ esclavo 1

Respuesta:  01 03 04 00 0A 00 0B 9B F6
                     │  └──┬──┘ └──┬──┘
                     │   reg 0 =10  reg 1 =11
                     └─ 4 bytes de datos
```

**Manejo de errores.** Si el esclavo no puede atender la petición, responde con el código de función con el bit 7 activado (función + 0x80) seguido de un código de excepción. Por ejemplo, si se pide la función 0x03 y la dirección no existe, la respuesta es `01 83 02 C0 F1`: el `0x83` indica error en la función 3 y el `0x02` significa "dirección de datos ilegal". Otros códigos comunes son 0x01 (función ilegal), 0x03 (valor ilegal) y 0x04 (fallo del dispositivo).

### 2.4 Detección de fin de trama y CRC

A diferencia de Modbus ASCII, que usa caracteres delimitadores, RTU no tiene marcas de inicio ni de fin. El receptor sabe que una trama terminó cuando hay un **silencio** en la línea. La especificación de Modbus sobre línea serie fija dos tiempos:

- **t1.5:** si pasa más de 1.5 tiempos de carácter entre dos bytes, la trama se considera dañada.
- **t3.5:** un silencio de al menos 3.5 tiempos de carácter marca el fin de una trama y el inicio de la siguiente.

Cada carácter ocupa **11 bits** (1 de inicio, 8 de datos, 1 de paridad y 1 de parada). La paridad par es la configuración por defecto, y si no se usa paridad, se agregan 2 bits de parada para mantener 11 bits. Con esto, el tiempo depende del baud rate:

| Baud rate | Tiempo por carácter | t3.5 |
|---|---|---|
| 9600 | 1.146 ms | 4.01 ms |
| 19200 | 0.573 ms | 2.005 ms |

Para velocidades mayores a 19200 baud, la especificación no calcula los tiempos, sino que los fija en **750 µs** (t1.5) y **1.75 ms** (t3.5), porque exigir tiempos tan cortos al software sería poco realista.

El CRC-16 se calcula sobre todos los bytes de dirección, función y datos. El receptor recalcula el CRC y, si no coincide con el recibido, descarta la trama en silencio.

### 2.5 Implementación en un sistema embebido

Al programar un nodo Modbus RTU en un microcontrolador aparecen varios puntos críticos:

1. **Control de dirección (DE/RE).** El GPIO debe ponerse en alto antes de transmitir y regresar a bajo apenas termine el último bit. El error más común es apagar DE cuando el buffer de transmisión queda vacío (bandera TXE), cuando en realidad el último byte todavía se está desplazando fuera del registro. Hay que esperar la bandera de **transmisión completa (TC)**. Algunos microcontroladores, como varios de la familia STM32, tienen un modo de hardware para controlar DE automáticamente desde la UART.
2. **Temporizador para t3.5.** El fin de trama se detecta con un temporizador que se reinicia con cada byte recibido. Si vence, se procesa la trama. Muchas implementaciones usan además la interrupción de línea inactiva (*IDLE*) de la UART.
3. **Tiempo de respuesta (turnaround).** El esclavo debe esperar a que pase el silencio de fin de trama antes de responder, y el maestro debe esperar un tiempo máximo de respuesta (*timeout*) antes de declarar un fallo o reintentar.
4. **Máquina de estados.** Lo más robusto es modelar la recepción como una máquina de estados (inactivo, recibiendo, trama completa, error), sin bloqueos en la interrupción.
5. **Bibliotecas existentes.** Proyectos como libmodbus, FreeMODBUS o ArduinoModbus ya resuelven estos detalles, pero, igual que con el OLED por registros, escribir el código propio ayuda a entender qué pasa realmente en el bus.

### 2.6 Rendimiento: cuánto tarda una consulta

Como el protocolo es de tipo pregunta-respuesta, el tiempo de una lectura se puede calcular. Para leer **10 registros** con la función 0x03:

- Petición: 8 bytes. Respuesta: 3 + 20 + 2 = 25 bytes. Total: 33 bytes × 11 bits = 363 bits.
- A **9600 baud**: 363 / 9600 ≈ **37.8 ms** de transmisión, más dos silencios de 4.01 ms, para un total cercano a **46 ms**, sin contar el tiempo de procesamiento del esclavo.
- A **115200 baud**: 363 / 115200 ≈ **3.2 ms**, más dos silencios de 1.75 ms, para unos **6.7 ms**.

Con 20 esclavos consultados uno tras otro a 9600 baud, un ciclo completo de lectura ronda el segundo. Esto explica por qué en la práctica se ajusta el baud rate y se agrupan las lecturas en bloques grandes en vez de pedir registro por registro.

### 2.7 Comparación con otras alternativas

| Característica | Modbus RTU / RS-485 | I²C | CAN |
|---|---|---|---|
| Distancia típica | Hasta ~1200 m | Centímetros a pocos metros | Hasta ~1 km a baja velocidad |
| Nodos | Hasta 247 (32 con carga estándar) | Limitado por direcciones y capacitancia | Decenas |
| Acceso al bus | Un maestro que sondea | Un maestro | Multimaestro con arbitraje |
| Robustez al ruido | Alta (diferencial) | Baja | Alta (diferencial) |
| Complejidad | Baja | Baja | Media |

## 3. Análisis crítico

La popularidad de Modbus RTU sobre RS-485 viene más de su simplicidad y de décadas de equipos instalados que de sus méritos técnicos. Sus ventajas son claras: es abierto, no exige licencias, se implementa con pocos recursos (una UART, un transceptor y unos cuantos cientos de bytes de código) y casi cualquier equipo industrial lo soporta.

También tiene limitaciones importantes:

- **Sin seguridad.** No hay autenticación ni cifrado; cualquiera conectado al bus puede leer o escribir registros.
- **Sondeo ineficiente.** Como los esclavos no pueden avisar de un evento, el maestro debe preguntar constantemente, lo que desperdicia ancho de banda y añade latencia.
- **Semántica ambigua.** El significado de cada registro depende del fabricante, y detalles como el orden de bytes en valores de 32 bits no están definidos.
- **Detección de errores limitada.** El CRC-16 detecta bien errores de transmisión, pero el protocolo no corrige nada: se descarta la trama y se depende del reintento del maestro.

Aun así, sigue siendo una elección razonable cuando se busca conectar equipos heterogéneos con bajo costo y distancias largas. Si se necesitan eventos, mayor velocidad o seguridad, conviene considerar CAN, Modbus TCP o Ethernet industrial.

## 4. Conclusiones

Modbus RTU sobre RS-485 combina una capa física robusta y económica con un protocolo simple y determinista. Para implementarlo correctamente en un sistema embebido no basta con enviar bytes: hay que respetar los silencios de t1.5 y t3.5, calcular el CRC con el orden de bytes correcto y controlar con cuidado el sentido del transceptor (DE/RE), esperando a que termine la transmisión antes de volver a escuchar. Conocer estos detalles permite diagnosticar fallas comunes en campo, como tramas truncadas, esclavos que no responden o bytes corruptos por un bus mal terminado.

## Bibliografía
[1] T. Kugelstadt, "The RS-485 Design Guide," Texas Instruments, Application Report SLLA272D, May 2021. [Online]. Available: https://www.ti.com/lit/an/slla272d/slla272d.pdf

[2] TIA/EIA, Electrical Characteristics of Generators and Receivers for Use in Balanced Digital Multipoint Systems, TIA/EIA-485-A, 1998. https://es.wikipedia.org/wiki/TIA-485

[3] D. Price, "Implementación de comunicación Modbus RTU en controladores embebidos," Industrial Monitor Direct, Apr. 13, 2026. [Online]. Available: https://industrialmonitordirect.com/es/blogs/knowledgebase/implementing-modbus-rtu-communication-on-embedded-controllers
