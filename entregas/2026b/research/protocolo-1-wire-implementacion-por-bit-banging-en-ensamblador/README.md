# Protocolo 1-Wire: Implementación por bit-banging en ensamblador

## Introducción

El protocolo **1-Wire**, creado originalmente por Dallas Semiconductor y actualmente perteneciente a Maxim Integrated / Analog Devices, es un tipo de comunicación serie asíncrona que permite conectar dispositivos de baja velocidad utilizando solamente un cable de datos y una conexión a tierra.

Una de sus principales características es que puede proporcionar alimentación a algunos dispositivos mediante la misma línea de datos, lo que resulta útil para sensores remotos y dispositivos de seguridad.

Como muchos microcontroladores actuales no cuentan con un controlador 1-Wire integrado, es necesario utilizar una técnica llamada **bit-banging**. Esta consiste en controlar el protocolo mediante software, cambiando manualmente el estado de un pin GPIO.

Al realizar esta implementación en un nivel bajo, utilizando lenguaje ensamblador y arquitecturas como ARM, se puede tener un mayor control sobre los tiempos de ejecución. Esto es importante en 1-Wire, ya que el protocolo requiere respetar tiempos muy específicos que se encuentran en el rango de los microsegundos.

---

## Desarrollo Técnico

### 1. Topología de Hardware y el Concepto Open-Drain

El bus 1-Wire opera bajo una topología de **colector abierto (open-collector)** o **drenador abierto (open-drain)**.

Esto significa que ningún dispositivo en el bus tiene la capacidad de forzar físicamente la línea a un nivel lógico alto (`VCC`). En su lugar, se conecta una resistencia de **pull-up externa**, generalmente de **4.7 kΩ**, entre la línea de datos y `VCC`.

El funcionamiento puede representarse de la siguiente manera:

```text
                    VCC
                     │
                  ┌──┴──┐
                  │4.7kΩ│
                  └──┬──┘
                     │
                     ├────────── Línea 1-Wire
                     │
          ┌──────────┴──────────┐
          │                     │
     Microcontrolador         Esclavo
          │                     │
          └───────── GND ───────┘
```

Para transmitir un estado lógico **"0"**, el microcontrolador o el esclavo conecta el pin a tierra, superando la resistencia y tirando el voltaje a `0 V`.

Para transmitir un estado lógico **"1"**, el dispositivo **suelta la línea**, configurándola en alta impedancia. Esto permite que la resistencia pull-up recargue la capacitancia del bus y eleve el voltaje.

En lenguaje ensamblador, esto implica que nunca escribimos directamente un `1` o un `0` en el registro de salida de datos del GPIO. En su lugar, el registro de salida se mantiene siempre en `0`, y lo que se alterna es el **registro de dirección (Direction Register)** del GPIO:

| Operación    | Configuración del pin        |
| ------------ | ---------------------------- |
| Escribir `0` | Pin configurado como salida  |
| Escribir `1` | Pin configurado como entrada |
| Leer         | Pin configurado como entrada |

---

### 2. Mapeo de Memoria (MMIO) y Barreras en ARM

En procesadores ARM, los periféricos GPIO se controlan mediante operaciones de carga y almacenamiento conocidas como **MMIO (Memory Mapped I/O)**.

Para manipular el pin con la menor latencia posible, el código ensamblador debe cargar la dirección base del puerto en un registro y utilizar desplazamientos.

Conceptualmente, en un ARM Cortex-M se requiere:

```asm
LDR R0, =GPIO_PORTA_BASE
LDR R1, =PIN_MASK
```

Donde:

* `R0` contiene la dirección base del puerto GPIO.
* `R1` contiene la máscara correspondiente al pin 1-Wire que se desea manipular.

Un aspecto crítico en arquitecturas avanzadas es el uso de **memorias caché, buffers de escritura y pipelines profundos**.

Una instrucción de almacenamiento (`STR`) que cambia la dirección del pin podría retrasarse en un buffer, afectando la temporización del protocolo.

Por ello, una implementación rigurosa requiere utilizar instrucciones de barrera de memoria como:

```asm
DSB    ; Data Synchronization Barrier
ISB    ; Instruction Synchronization Barrier
```

Estas instrucciones se utilizan después de alterar un registro del GPIO para garantizar que el cambio de estado del pin eléctrico ocurra antes de que la CPU comience a contar los retardos.

---

### 3. Cálculo Matemático de Ciclos de Reloj y Retardos

Para lograr la precisión de microsegundos que exige 1-Wire, el código ensamblador debe calcular bucles de retardo basados en la frecuencia del procesador.

Por ejemplo, si un microcontrolador Cortex-M opera a:

```text
Frecuencia = 16 MHz
```

Cada ciclo de reloj dura:

```text
1 / 16,000,000 = 62.5 ns
```

Si el protocolo requiere un retardo exacto de:

```text
2 μs = 2000 ns
```

El número de ciclos necesarios es:

```text
2000 ns / 62.5 ns = 32 ciclos
```

Por lo tanto:

```text
Retardo requerido: 2 μs
Ciclos necesarios: 32
```

En ensamblador ARM, un bucle de retardo típico utiliza una instrucción de resta (`SUBS`) y un salto condicional (`BNE`).

Si el bucle consume aproximadamente **3 ciclos por iteración**, el registro contador debe inicializarse con un valor cercano a `10` para agotar los ciclos requeridos.

Ejemplo conceptual:

```asm
MOV  R2, #10

RETARDO:
    SUBS R2, R2, #1
    BNE  RETARDO
```

El cálculo determinista de los ciclos constituye una de las principales ventajas técnicas de utilizar ensamblador frente a lenguajes de alto nivel como C, donde el compilador puede modificar los ciclos generados al aplicar diferentes niveles de optimización, como `-O2` o `-O3`.

---

### 4. Gestión de Interrupciones y Cambio de Contexto

Uno de los principales problemas del **bit-banging** es el *jitter* o fluctuación temporal introducida por las interrupciones del sistema.

Si la CPU se encuentra a la mitad de una ventana de lectura crítica y ocurre una interrupción, por ejemplo el `SysTick` del sistema operativo, el procesador saltará al manejador correspondiente.

Al regresar, la ventana temporal estricta de **15 microsegundos** de 1-Wire puede haber expirado, provocando la corrupción de los datos.

Para evitar esto, el programador de ensamblador debe **enmascarar las interrupciones** antes de iniciar un slot de tiempo crítico.

En ARM Cortex-M se utilizan:

```asm
CPSID i    ; Deshabilitar interrupciones
```

y posteriormente:

```asm
CPSIE i    ; Habilitar interrupciones
```

La secuencia general es:

```text
┌─────────────────────────────┐
│ CPSID i                     │
│ Deshabilitar interrupciones │
└──────────────┬──────────────┘
               │
               ▼
      Operación 1-Wire crítica
               │
               ▼
┌──────────────┴──────────────┐
│ CPSIE i                     │
│ Habilitar interrupciones    │
└─────────────────────────────┘
```

Las interrupciones se deshabilitan temporalmente durante la operación crítica y se restauran inmediatamente después de capturar o enviar el bit.

---

### 5. Anatomía de los Tiempos (Time Slots) y Secuencias Lógicas

El protocolo define cuatro operaciones atómicas. Su implementación en ensamblador requiere aplicar los retardos previamente calculados y gestionar las interrupciones durante las fases críticas.

#### 5.1 Secuencia de Reset y Presence Pulse

Toda transacción inicia con un **Reset**.

El maestro:

1. Configura el pin como salida, tirando la línea a `0 V`.
2. Mantiene la línea baja durante al menos **480 μs**.
3. Cambia el pin a entrada.
4. Espera entre **15 y 60 μs**.
5. Verifica si el esclavo responde mediante un **Presence Pulse**.

Si existe un esclavo conectado, este responde tirando la línea a `0 V` durante un periodo de **60 a 240 μs**.

El ensamblador debe muestrear el registro de entrada en el momento correspondiente y verificar el bit asociado.

Secuencia conceptual:

```text
Maestro                         Esclavo
  │                                │
  │──── Línea LOW ≥ 480 μs ──────>│
  │                                │
  │──── Liberar línea ────────────>│
  │                                │
  │<──── Presence Pulse ───────────│
  │      60 - 240 μs               │
  │                                │
```

---

#### 5.2 Escritura: Write 0 y Write 1

La escritura de bits utiliza diferentes duraciones para representar un `0` o un `1`.

##### Write 1

Para escribir un `1`, el maestro:

1. Tira la línea a bajo.
2. Mantiene el nivel bajo durante un periodo muy breve de **1 a 15 μs**.
3. Libera la línea configurando el pin como entrada.
4. El slot completo debe durar al menos **60 μs**.

```text
WRITE 1

LOW             Liberar
│                  │
▼                  ▼
┌───────┐          ┌──────────────────
│ 1-15μs│          │
└───────┴──────────┴──────────────────
       Línea liberada
```

##### Write 0

Para escribir un `0`, el maestro tira la línea a bajo y la mantiene así durante todo el slot:

```text
WRITE 0

LOW
│
▼
┌────────────────────────────────────┐
│          60 - 120 μs               │
└────────────────────────────────────┘
```

---

#### 5.3 Lectura: Read Slot

Para leer un bit, el maestro inicia el slot tirando la línea a bajo durante un mínimo de **1 μs** y posteriormente cambia el pin a entrada.

El estándar establece que el maestro debe muestrear el estado del pin dentro de una ventana de **15 μs** desde que la señal inicial cayó.

La secuencia de lectura en ensamblador puede estructurarse de la siguiente manera.

##### Paso 1: Deshabilitar interrupciones e iniciar el slot

Se deshabilitan las interrupciones mediante `CPSID i`.

Posteriormente se inicia el slot forzando el pin a salida:

```asm
CPSID i

STR R1, [R0, #GPIO_DIR_OFFSET]
DSB
```

El `DSB` se utiliza para asegurar que el hardware registre el cambio.

##### Paso 2: Retardo inicial

Se introduce un retardo calibrado de aproximadamente **2 μs** mediante un bucle basado en ciclos de reloj.

```asm
; Bucle de retardo calibrado
; Aproximadamente 2 μs
```

##### Paso 3: Liberar la línea

El pin se cambia a entrada mediante:

```asm
STR R2, [R0, #GPIO_DIR_OFFSET]
DSB
```

Esto permite que la resistencia de pull-up o el esclavo determinen el estado del bus.

##### Paso 4: Alcanzar la ventana de muestreo

Se añade otro retardo preciso para alcanzar la ventana de lectura de aproximadamente **12 a 15 μs**.

##### Paso 5: Muestrear el estado del pin

Se lee el registro de entrada:

```asm
LDR R3, [R0, #GPIO_IN_OFFSET]
```

Después se utiliza `TST` para aislar el bit correspondiente:

```asm
TST R3, R1
```

Finalmente, se restauran las interrupciones:

```asm
CPSIE i
```

y mediante saltos condicionales como `BNE` o `BEQ` se determina si el dispositivo leyó un `1` o un `0`.

La secuencia completa puede representarse así:

```text
CPSID i
   │
   ▼
Forzar pin a salida
   │
   ▼
DSB
   │
   ▼
Retardo ≈ 2 μs
   │
   ▼
Cambiar pin a entrada
   │
   ▼
DSB
   │
   ▼
Retardo hasta ventana de muestreo
   │
   ▼
LDR → Leer GPIO
   │
   ▼
TST → Aislar bit
   │
   ▼
BNE / BEQ
   │
   ▼
CPSIE i
```

---

## Caso de Uso Práctico: Sensor de Temperatura DS18B20

El dispositivo 1-Wire más representativo en la industria es el **sensor de temperatura DS18B20**.

Para interactuar con él utilizando rutinas de *bit-banging*, el flujo en ensamblador implica:

```text
       ┌──────────────┐
       │    RESET     │
       └──────┬───────┘
              │
              ▼
       ┌──────────────┐
       │   Presence   │
       │     Pulse    │
       └──────┬───────┘
              │
              ▼
       ┌──────────────┐
       │  Write Slots │
       │   0xCC       │
       └──────┬───────┘
              │
              ▼
       ┌──────────────┐
       │  Write Slots │
       │   0x44       │
       └──────┬───────┘
              │
              ▼
       ┌──────────────┐
       │  Read Slots  │
       └──────┬───────┘
              │
              ▼
       ┌──────────────┐
       │ 16 bits de   │
       │ temperatura  │
       └──────────────┘
```

El controlador debe enviar:

| Comando | Nombre    | Función                                                                  |
| ------- | --------- | ------------------------------------------------------------------------ |
| `0xCC`  | Skip ROM  | Omite la lectura del número de serie si es el único componente en el bus |
| `0x44`  | Convert T | Inicia la lectura térmica                                                |

Posteriormente, el controlador utiliza múltiples **Read Slots** para extraer los **16 bits de resolución de la temperatura** almacenados en la memoria *scratchpad* del sensor.

---

## Conclusión

La implementación del bus 1-Wire mediante **bit-banging en lenguaje ensamblador** permite comprender la relación que existe entre el procesador, la memoria y el funcionamiento eléctrico de un bus *open-drain*.

Trabajar directamente con los ciclos de reloj permite cumplir con los tiempos establecidos por el protocolo de Maxim Integrated. Sin embargo, también existen algunas desventajas, como un mayor uso de la CPU y una mayor latencia en el sistema debido a la necesidad de desactivar las interrupciones durante ciertas operaciones.

Aunque actualmente existen alternativas como el uso de hardware externo o periféricos UART para reducir la carga del procesador, realizar este tipo de controladores en ensamblador sigue siendo importante para comprender cómo se manejan los tiempos en sistemas embebidos.

---

## Bibliografía

1. Maxim Integrated, **“1-Wire Communication Through Software,”** *Application Note 126*, 2002.
   https://d1.amobbs.com/bbs_upload782111/files_7/armok01153399.pdf

2. Maxim Integrated, **“Using a UART to Implement a 1-Wire Bus Master,”** *Application Note 214*.
   https://www.analog.com/en/resources/app-notes/reading-and-writing-1wirereg-devices-through-serial-interfaces.html

3. Arm Limited, ***Armv8-M Architecture Reference Manual***, DDI0553B, 2021.
   https://community.arm.com/cfs-file/__key/communityserver-discussions-components-files/471/DDI0553B_y_armv8m_arm.pdf

4. J. Yiu, ***The Definitive Guide to ARM Cortex-M3 and Cortex-M4 Processors***, 3rd ed. Newnes, 2013.
   https://shop.elsevier.com/books/the-definitive-guide-to-arm-cortex-m3-and-cortex-m4-processors/yiu/978-0-12-408082-9

5. C. Maxfield, ***Bebop to the Boolean Boogie: An Unconventional Guide to Electronics***, 3rd ed. Newnes, 2008.
   https://shop.elsevier.com/books/bebop-to-the-boolean-boogie/maxfield/978-1-85617-507-4
