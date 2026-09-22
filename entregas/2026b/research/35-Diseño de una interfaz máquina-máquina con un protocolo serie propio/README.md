# Diseño de una interfaz máquina-máquina con un protocolo serie propio

## 1. Introducción

Cuando dos dispositivos (máquinas) necesitan comunicarse entre sí sin intervención humana directa, como por ejemplo dos PCs que necesitan sincronizar información, un microcontrolador que le reporta datos de un sensor a una PC, o dos tarjetas embebidas que coordinan una tarea en conjunto, se necesita un canal físico por el cual viajen los datos, y un protocolo que indique cómo se deben enviar, estructurar e interpretar esos datos en ambos extremos. El canal físico por sí solo no es suficiente: un cable conectado entre dos dispositivos puede transportar señales eléctricas, pero sin un acuerdo previo sobre qué significan esas señales, ninguno de los dos lados puede darle sentido a lo que recibe. Es justamente ese acuerdo el que convierte una simple conexión eléctrica en comunicación real.

El protocolo serie es una de las formas más antiguas y todavía más usadas de resolver esto, porque requiere pocos cables, hardware simple (UART) y es fácil de depurar.

Entonces, si ya existen protocolos con gran adopción, ¿por qué diseñar uno propio? Esta investigación busca responder precisamente esa pregunta, analizando en qué escenarios tiene sentido optar por un protocolo propio en lugar de un estándar ya establecido.

---

## 2. Marco teórico

### 2.1 Comunicación serie (UART, síncrona/asíncrona)

Dentro de la comunicación entre máquinas existen dos maneras principales de hacerlo:

- **Paralelo:** es un protocolo donde los datos (bits) se transmiten de manera simultánea a través de varios canales físicos (cables).
- **Serie:** es un protocolo donde los bits se mandan uno a uno de manera secuencial a través de un solo medio físico (cable).

Hoy en día casi todos los protocolos de comunicación M2M utilizan comunicación serie, debido a que se necesita menos hardware.

**UART (Universal Asynchronous Receiver-Transmitter):** es el hardware que convierte bytes en pulsos eléctricos en el tiempo, sin necesidad de una señal de reloj compartida entre los dos lados. Para que esto funcione, la trama que se envíe debe llevar un cierto orden:

1. **Start bit:** avisa "aquí empieza un byte nuevo".
2. **Bits de datos:** es la información que se envía (normalmente 8 bits).
3. **Bit de paridad (opcional):** es un bit que ayuda con la verificación de errores.
4. **Stop bit:** indica que el byte ha terminado.

Además, el UART de ambas máquinas debe estar configurado a la misma velocidad, la cual se mide en baudios (la tasa de baudios define cuántos símbolos o bits por segundo transmite el UART), para asegurarse de no perder datos durante la comunicación.

Hasta este punto solo tenemos bytes viajando de un lado a otro gracias al UART, pero ahora necesitamos darle "sentido" a esos datos. Al agregar un protocolo serie propio, lo que queremos lograr es reconstruir mensajes con significado a partir de un flujo de bytes sin estructura, ahí es donde entra el siguiente punto: **framing**.

### 2.2 Framing (delimitadores, longitud fija/variable)

Es el proceso que toma los bits del nivel físico y los organiza en unidades de información llamadas tramas. Esto permite que el receptor identifique claramente el inicio y el fin de cada bloque de datos.

- **Delimitadores:** se marca el inicio y el fin del mensaje con bytes especiales reservados (ej. STX=0x02 al inicio, ETX=0x03 al final). El problema es que si el payload por casualidad contiene el mismo byte que el delimitador, el receptor se confunde y habría que agregar lógica para solucionar este problema, lo que hace la comunicación algo más compleja.
- **Longitud fija:** todos los mensajes miden exactamente N bytes. Parsear es trivial (cuentas N bytes y ya tienes el mensaje completo), pero es rígido: si necesitas mensajes de tamaños distintos, desperdicias ancho de banda rellenando con bytes vacíos.
- **Longitud variable con campo de tamaño explícito:** el mensaje empieza con un byte (o dos) que dice cuántos bytes de payload vienen después. El receptor lee ese campo primero y ya sabe exactamente cuántos bytes esperar, sin ambigüedad y sin necesidad de escapar nada. Esta es la estrategia que usan la mayoría de los protocolos serie industriales reales (Modbus RTU, por ejemplo) y la más recomendable para un diseño propio porque combina simplicidad de parseo con flexibilidad de tamaño.

### 2.3 Detección de errores (paridad, checksum, CRC)

Una vez que el receptor ha logrado delimitar el mensaje de manera correcta, surge otro problema: la integridad de los datos. Durante la transmisión serie, la información viaja por un medio físico (cable), por lo cual puede estar sujeta a interferencia electromagnética, caídas de voltaje o ruido de otros equipos. Esto podría voltear bits y hacer que el mensaje recibido sea erróneo si el receptor no aplica alguna lógica para verificar la integridad de los datos; en entornos industriales o médicos esto puede resultar en un resultado grave, debido a la sensibilidad de los datos.

Algunos mecanismos que se pueden implementar en un protocolo de comunicación para la detección de errores son los siguientes:

- **Paridad:** el método de detección más simple. Consiste en agregar un bit ("bit de paridad") a la trama, el cual indica si el número de bits encendidos (1) en el byte es par o impar. Si el byte no se corrompió, debería concordar el bit de paridad con el número de bits encendidos. En la práctica tiene un inconveniente: si el ruido altera dos bits al mismo tiempo, la paridad puede seguir "cuadrando" y el error pasa completamente desapercibido. Por esta limitación, en protocolos de aplicación modernos casi nunca se usa como único mecanismo de verificación.
- **Checksum:** un valor calculado a partir de la suma (u otra operación simple) de los bytes del mensaje, que se anexa al final de la trama para que el receptor pueda recalcularlo y compararlo. Si son iguales, lo más probable es que no hubiera algún error durante la transmisión. Este método es más efectivo que el de paridad, pero aun así se deben tener en cuenta posibles colisiones del algoritmo, es decir, que algunas combinaciones de números den el mismo resultado.
- **CRC (Cyclic Redundancy Check):** el mecanismo más robusto. A diferencia del checksum, que trata los datos como números a sumar, el CRC trata el mensaje completo como un polinomio binario y calcula el residuo de una división polinomial fija (definida por un polinomio generador). Esto lo hace extremadamente sensible incluso a errores en ráfaga (varios bits consecutivos alterados), que es precisamente el tipo de error más común en líneas seriales sometidas a ruido eléctrico. Por su buen balance entre robustez y costo computacional, el CRC de 16 bits (CRC-16) es el tamaño más usado en protocolos serie de referencia como Modbus RTU, y es la opción más recomendada para el diseño de un protocolo serie propio.

### 2.4 Control de flujo y manejo de errores (timeouts, ACK/NACK)

Suponiendo que utilizamos CRC para detectar que una trama llegó corrupta, esto resuelve solo la mitad del problema; el protocolo también debe definir qué hacer cuando eso ocurre. Los mecanismos típicos son:

- **ACK/NACK:** el receptor responde explícitamente confirmando la recepción correcta de una trama (ACK) o solicitando su reenvío si el CRC no coincidió (NACK).
- **Timeout:** si el transmisor no recibe una confirmación dentro de un tiempo determinado, asume que el mensaje (o la confirmación misma) se perdió en el trayecto, y actúa en consecuencia.
- **Reintentos limitados:** para evitar que el sistema quede reintentando indefinidamente si el otro dispositivo está desconectado o falló, se define un número máximo de intentos antes de reportar un error definitivo al nivel superior del sistema.
- **Número de secuencia:** un contador incremental incluido en cada trama, que permite al receptor identificar duplicados (cuando un ACK se pierde y el transmisor reenvía un mensaje que en realidad ya había llegado) o detectar mensajes recibidos fuera de orden.

### 2.5 Protocolos existentes como referencia (Modbus RTU, HDLC)

Antes de diseñar un protocolo propio, es útil observar cómo protocolos serie ya consolidados resuelven estos mismos problemas, ya que sirven como punto de comparación para crear uno propio:

- **Modbus RTU:** protocolo serie ampliamente adoptado en automatización industrial. Usa una estructura de trama similar a la que se está tratando en esta investigación (dirección, código de función, datos, CRC-16), lo que lo convierte en una referencia directa para validar las decisiones de diseño propias.
- **HDLC:** protocolo de enlace que resuelve el framing mediante *bit stuffing* en lugar de un campo de longitud explícito, útil como referencia si se quisiera explorar esa alternativa de framing.

---

## 3. Diseño de un protocolo serie propio

### 3.1 Requisitos del sistema

Antes de empezar con la parte del diseño de la trama, manejo de errores, etc., debemos definir bien los requerimientos del sistema, respondiendo preguntas como: ¿cuántos dispositivos se van a comunicar?, ¿qué tipo de datos se van a transmitir?, ¿con qué frecuencia estos datos se van a transmitir?, ¿con qué hardware se cuenta para la implementación del protocolo? Estas y muchas otras preguntas condicionan directamente el diseño.

Respondiendo a las preguntas planteadas, para efectos de esta investigación se definió el siguiente escenario base, sobre el cual se diseñará y probará el protocolo:

- **Dispositivos involucrados:** se plantea un escenario de dos dispositivos (transmisor y receptor), pero se incluye desde el diseño la posibilidad de escalar a un bus compartido con varios dispositivos (aunque el pequeño prototipo en código solo contempla comunicación punto a punto).
- **Tipo de datos:** datos cortos y estructurados, como lecturas de sensores o comandos de control (ejemplo: 2 bytes representando un valor numérico).
- **Frecuencia de transmisión:** modelo de petición-respuesta, donde un dispositivo solicita información y el otro responde, en lugar de transmisión continua o basada en eventos con marcas de tiempo.
- **Hardware disponible:** se asume hardware capaz de calcular CRC-16 sin impacto significativo en el rendimiento, lo cual justifica optar por CRC en lugar de un checksum simple.
- **Tolerancia a errores del entorno:** entorno con ruido moderado, no crítico, lo que permite priorizar simplicidad sobre mecanismos de recuperación más agresivos (aunque igual se contempla ACK/NACK y reintentos como parte del diseño).

### 3.2 Estructura de la trama

Con base en los requisitos anteriores y en lo estudiado en el marco teórico (framing por longitud variable + CRC-16), se propone la siguiente estructura:

```
| STX  | ADDR | CMD  | LEN  | PAYLOAD (LEN bytes) | CRC16 (2B) | ETX  |
| 1B   | 1B   | 1B   | 1B   | 0-255 bytes          | 2B         | 1B   |
```

| Campo | Tamaño | Función |
|---|---|---|
| STX | 1 byte | Marca el inicio de la trama (0x02); permite resincronizar al receptor si se desfasa |
| ADDR | 1 byte | Identifica al dispositivo destinatario; necesario si el protocolo opera sobre un bus compartido |
| CMD | 1 byte | Define el tipo de mensaje u operación solicitada |
| LEN | 1 byte | Indica el tamaño del payload que sigue, resolviendo el framing de longitud variable |
| PAYLOAD | 0-255 bytes | Datos reales del mensaje, cuyo contenido depende del valor de CMD |
| CRC16 | 2 bytes | Verifica la integridad de ADDR+CMD+LEN+PAYLOAD |
| ETX | 1 byte | Marca el fin de la trama (0x03); segunda verificación de sincronía |

El overhead fijo es de 7 bytes por mensaje, independientemente del tamaño del payload.

### 3.3 Semántica de comandos

Sobre la trama genérica se define un pequeño diccionario de comandos que le da significado de aplicación al campo CMD, para el escenario sensor–controlador planteado en 3.1:

| CMD | Nombre | Dirección | Payload esperado |
|---|---|---|---|
| 0x01 | READ_REQUEST | Controlador → Sensor | vacío |
| 0x02 | READ_RESPONSE | Sensor → Controlador | 2 bytes (valor leído) |
| 0x06 | ACK | Cualquiera | vacío |
| 0x15 | NACK | Cualquiera | 1 byte (código de error) |

### 3.4 Máquina de estados del parser/receptor

Dado que UART entrega bytes individuales sin agrupar (ver marco teórico), el receptor no puede esperar una trama completa de forma bloqueante, debe reconstruirla byte a byte mediante una máquina de estados finitos:

```
WAIT_STX → READ_ADDR → READ_CMD → READ_LEN → READ_PAYLOAD → READ_CRC → WAIT_ETX → (vuelve a WAIT_STX)
```

Cada estado consume un byte (o, en READ_PAYLOAD, acumula bytes hasta alcanzar el valor indicado por LEN) y avanza al siguiente. La trama solo se considera válida y se entrega a la aplicación cuando el ciclo se completa (se recibe ETX y el CRC calculado coincide con el recibido); en cualquier otro caso, se descarta y el receptor regresa a WAIT_STX, listo para resincronizar con la siguiente trama.

### 3.5 Manejo de errores y casos límite

Además del control de flujo descrito en el marco teórico (ACK/NACK, timeout, reintentos), el diseño contempla explícitamente:

- **CRC inválido:** la trama se descarta (o se responde NACK) y el receptor regresa a WAIT_STX.
- **STX recibido a mitad de otra trama:** indica que la trama anterior se perdió o corrompió antes de completarse; el parser reinicia y comienza una nueva trama desde ese STX.
- **LEN fuera de rango:** si indica un payload mayor al máximo permitido por el diseño, la trama se descarta de inmediato sin leer el payload, evitando desbordes de buffer.
- **Timeout a mitad de trama:** si la transmisión se interrumpe antes de completar la trama, un timeout interno regresa al receptor a WAIT_STX para no quedar bloqueado indefinidamente.

---

## 4. Conclusiones

El diseño de una interfaz máquina-máquina con un protocolo serie propio implica resolver, de forma explícita, problemas que los protocolos estándar ya resuelven de manera transparente: delimitar mensajes dentro de un flujo continuo de bytes (framing), garantizar la integridad de los datos frente a ruido en el canal físico (CRC), y definir qué hacer cuando algo falla (control de flujo). A lo largo de esta investigación se demostró que, con un diseño relativamente simple, trama de longitud variable con CRC-16 y una máquina de estados clara en el receptor, es posible construir un protocolo funcional y razonablemente robusto sin necesidad de adoptar un estándar completo como Modbus o PROFINET.

---

## 5. Referencias bibliográficas
[1] TIA/EIA-232-F. Interface Between Data Terminal Equipment and Data Circuit-Terminating Equipment Employing Serial Binary Data Interchange.*]

[2] Axelson, J. (2007). Serial Port Complete: COM Ports, USB Virtual COM Ports, and Ports for Embedded Systems (2.ª ed.). Lakeview Research.

[3] INCIBE-CERT. (2018). El protocolo serie, entiéndelo y protégelo. Instituto Nacional de Ciberseguridad. https://www.incibe.es/incibe-cert/blog/el-protocolo-serie-entiendelo-y-protegelo

[4] CIATEQ. (s.f.). Implementación de protocolo de comunicación [Documento técnico]. Repositorio Institucional CIATEQ. https://ciateq.repositorioinstitucional.mx/jspui/bitstream/1020/502/1/Implementacion%20de%20protocolo%20de%20comunicacion.pdf

[5] Telecommunications Industry Association. (1997). Interface Between Data Terminal Equipment and Data Circuit-Terminating Equipment Employing Serial Binary Data Interchange (TIA/EIA-232-F).
