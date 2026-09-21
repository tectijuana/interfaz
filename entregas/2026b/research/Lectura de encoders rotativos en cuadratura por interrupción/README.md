# Lectura de Encoders Rotativos en Cuadratura por Interrupción

---

## 1. Introducción
Los encoders rotativos son dispositivos electromecánicos que convierten la posición angular o el movimiento de un eje en señales digitales. En los sistemas embebidos de control de movimiento, la precisión y la baja latencia son fundamentales; por ello, la lectura eficiente de estos sensores determina el rendimiento del sistema. 

El método de adquisición mediante **interrupciones por hardware (External Interrupts / GPIO Interrupts)** permite al procesador reaccionar en tiempo real ante los cambios de estado de las señales del encoder, liberando a la Unidad Central de Procesamiento (CPU) del consumo excesivo de recursos que representa el monitoreo por sondeo activo (*polling*).

---

## 2. Principio de Funcionamiento del Encoder Rotativo en Cuadratura

### 2.1. Genética de la Cuadratura (Canales A y B)
Un encoder en cuadratura genera dos señales de onda cuadrada desplazadas en fase $90^\circ$ (1/4 de período). A estas señales se les conoce como Canal A y Canal B.

* **Resolución y Pulso:** La cantidad de ciclos completos por revolución se define como PPR (*Pulses Per Revolution*).
* **Desfase:**
  * **Sentido Horario (CW):** El canal A se adelanta al canal B por $90^\circ$.
  * **Sentido Antihorario (CCW):** El canal B se adelanta al canal A por $90^\circ$.

> <img width="947" height="517" alt="diagrama de tiempos de encoder en cuadratura" src="https://github.com/user-attachments/assets/7fd40d16-ef73-4ecd-95b9-f081a1874257" />


---

### 2.2. Modos de Decodificación ($1\text{X}$, $2\text{X}$, $4\text{X}$)
El nivel de detalle con el que se procesan las señales del encoder define la resolución lógica del sistema:

* **Modo 1X:** Detecta solo el flanco de subida (o bajada) de un único canal (ej. Flanco de subida de A).
* **Modo 2X:** Detecta ambos flancos (subida y bajada) de un solo canal (A).
* **Modo 4X:** Detecta todos los flancos posibles (subida y bajada) de **ambos** canales (A y B). Ofrece el quádruple de la resolución nativa del encoder.

#### Tabla Comparativa de Modos de Decodificación

| Modo de Decodificación | Eventos por Ciclo (PPR) | Ventajas | Desventajas | Carga Computacional para la CPU |
| :--- | :--- | :--- | :--- | :--- |
| **Modo 1X** | 1 por período ($1 \times \text{PPR}$) | • Algoritmo de lectura extremadamente simple.<br>• Mínima frecuencia de disparo de interrupciones.<br>• Inmunidad nativa a rebotes mecánicos en el canal B. | • Desaprovecha la resolución física del sensor ($25\%$ de la resolución potencial).<br>• Menor precisión en velocidades muy bajas. | **Muy Baja:** Ideal para microcontroladores limitados o sistemas con múltiples encoders. |
| **Modo 2X** | 2 por período ($2 \times \text{PPR}$) | • Duplica la resolución del encoder sin costo adicional de hardware.<br>• Buen balance entre resolución angular y uso de recursos del sistema. | • Sensible a asimetrías de ciclo de trabajo (*duty cycle*) del sensor.<br>• Requiere detectar ambos flancos en un pin GPIO. | **Moderada:** Procesa el doble de interrupciones por revolución que el modo 1X. |
| **Modo 4X** | 4 por período ($4 \times \text{PPR}$) | • Máxima resolución posible (utiliza todos los estados de la cuadratura).<br>• Permite detectar cambios de dirección instantáneos en cualquier transición de fase. | • Sensible a variaciones de tolerancia de la señal de $90^\circ$.<br>• Mayor riesgo de saturación de CPU a altas velocidades (RPM) si no hay filtro RC. | **Alta:** Cuatriplica el número de llamadas a la ISR por ciclo respecto al modo 1X. |

---

## 3. Hardware e Interfaz Física

### 3.1. Electrónica Interna y Acondicionamiento de Señal
Los encoders pueden ser de tipo óptico o magnético, con salidas tipo *Push-Pull* o *Open-Collector* (Colector Abierto).

* **Resistencias de Pull-Up:** Requeridas para asegurar un nivel lógico alto en salidas Open-Collector.
* **Inmunidad al Ruido:** Las líneas del encoder en entornos industriales son propensas a acoples electromagnéticos (EMI).
* **Filtros RC Pasivos:** Implementados para atenuar transitorios de alta frecuencia antes de ingresar al pin GPIO.

> <img width="947" height="512" alt="Esquema electrico del circuito de filtrado RC y Schmitt Trigger" src="https://github.com/user-attachments/assets/94055368-8c76-43e9-9fff-92560d904223" />


#### Descripción de los Componentes del Circuito de Acondicionamiento

1. **Resistencia Pull-Up ($R_{\text{pullup}}$):** 
   Asegura un nivel lógico alto ($V_{CC}$) constante cuando la salida del encoder se encuentra en estado flotante o es de tipo colector abierto (*Open-Collector*). Evita estados indeterminados en la línea de entrada.

2. **Filtro Pasa-Bajas RC ($R_{\text{filter}}$ y $C_{\text{filter}}$):** 
   Forma una red atenuadora pasiva que filtra el ruido electromagnético de alta frecuencia y absorbe los picos de voltaje transitorios provocados por el rebote mecánico (*chatter*). La frecuencia de corte ($f_c$) del filtro se calcula mediante:
   
   $$f_c = \frac{1}{2\pi \cdot R_{\text{filter}} \cdot C_{\text{filter}}}$$

3. **Inversor / Buffer Schmitt Trigger:** 
   Aporta histeresis de voltaje al sistema. Elimina la zona de incertidumbre y la lenta tasa de variación (*slew rate*) introducida por el capacitor en las transiciones de voltaje, entregando una onda cuadrada de flancos rápidos y limpios al pin de interrupción del microcontrolador.

---

### 3.2. Problema del Rebote Mecánico (*Debouncing*)
En encoders de contacto mecánico (a diferencia de los ópticos), la conmutación genera rebotes (*chatter*) que provocan múltiples interrupciones falsas por un solo paso.

* **Solución Hardware:** Filtros pasivos y compuertas *Schmitt Trigger*.
* **Solución Software:** Temporizadores de bloqueo (*dead-time*), validación de estados válidos en la Matriz de Estados.

---

## 4. Implementación del Algoritmo por Interrupción

### 4.1. Configuración de Pines y Registros GPIO
Para procesar las señales por interrupción, los pines conectados a A y B deben configurarse adecuadamente a nivel de lenguaje ensamblador o C sobre registros:

1. Configuración del vector de interrupciones para los pines GPIO seleccionados.
2. Selección del disparador (*Trigger*): Flanco de Subida (*Rising*), Bajada (*Falling*) o Ambos (*Change/Any edge*).
3. Habilitación de la máscara de interrupciones globales y específicas (`EXTI_IMR`, `NVIC` en ARM Cortex-M, o registros `EIMSK`/`PCMSK` en AVR).

---

### 4.2. Algoritmo de Matriz de Estados (*State Machine Decoders*)
Para maximizar la eficiencia dentro de la **Rutina de Servicio de Interrupción (ISR)**, se evita el uso de condicionales `if-else` anidados o estructuras `switch-case` lentas. En su lugar, se utiliza una **Matriz de Transición de Estados** indexada mediante operaciones a nivel de bits (*bitwise operations*).

#### Lógica del Índice de la Matriz:
El índice de la matriz se calcula combinando el estado anterior de las señales ($A_{\text{previo}}, B_{\text{previo}}$) con el estado actual ($A_{\text{actual}}, B_{\text{actual}}$):

$$\text{Índice} = (A_{\text{previo}} \ll 3) \mid (B_{\text{previo}} \ll 2) \mid (A_{\text{actual}} \ll 1) \mid B_{\text{actual}}$$

#### Tabla de Transición de Estados (Modo 4X):

| Índice | Estado Previo ($A_p B_p$) | Estado Actual ($A_a B_a$) | Acción ($+1$, $-1$, $0$, Error) | Condición / Interpretación |
| :---: | :---: | :---: | :---: | :--- |
| **0** | `00` | `00` | $0$ | Sin cambio de estado |
| **1** | `00` | `01` | $-1$ | Paso en sentido antihorario (CCW) |
| **2** | `00` | `10` | $+1$ | Paso en sentido horario (CW) |
| **3** | `00` | `11` | $0$ (Error) | Transición inválida (doble cambio simultáneo) |
| **4** | `01` | `00` | $+1$ | Paso en sentido horario (CW) |
| **5** | `01` | `01` | $0$ | Sin cambio de estado |
| **6** | `01` | `10` | $0$ (Error) | Transición inválida (doble cambio simultáneo) |
| **7** | `01` | `11` | $-1$ | Paso en sentido antihorario (CCW) |
| **8** | `10` | `00` | $-1$ | Paso en sentido antihorario (CCW) |
| **9** | `10` | `01` | $0$ (Error) | Transición inválida (doble cambio simultáneo) |
| **10** | `10` | `10` | $0$ | Sin cambio de estado |
| **11** | `10` | `11` | $+1$ | Paso en sentido horario (CW) |
| **12** | `11` | `00` | $0$ (Error) | Transición inválida (doble cambio simultáneo) |
| **13** | `11` | `01` | $+1$ | Paso en sentido horario (CW) |
| **14** | `11` | `10` | $-1$ | Paso en sentido antihorario (CCW) |
| **15** | `11` | `11` | $0$ | Sin cambio de estado |

---

### 4.3. Código de Ejemplo en Lenguaje de Interfaz / C Nivel de Registro

```c
// Definición de la matriz de transición de estados
// Retorna: 1 (Horario), -1 (Antihorario), 0 (Sin cambio o Estado Inválido)
static const int8_t ENCODER_STATES[] = {
    0, -1,  1,  0,
    1,  0,  0, -1,
   -1,  0,  0,  1,
    0,  1, -1,  0
};

static volatile int32_t encoder_count = 0;
static uint8_t encoder_state_history = 0;

// Rutina de Servicio de Interrupción (ISR)
void ISR_Encoder_Handler(void) {
    // 1. Leer directamente los pines de entrada desde el registro GPIO
    uint8_t current_pins = (READ_REG_GPIO() & MASK_PINS_AB) >> SHIFT_OFFSET;
    
    // 2. Desplazar el historial 2 bits a la izquierda y combinar con el nuevo estado
    encoder_state_history = ((encoder_state_history << 2) | current_pins) & 0x0F;
    
    // 3. Actualizar la variable de posición global usando la matriz
    encoder_count += ENCODER_STATES[encoder_state_history];
    
    // 4. Limpiar bandera de interrupción en el registro de estatus
    CLEAR_INTERRUPT_FLAG();
}
```

---

## 5. Análisis de Rendimiento: Latencia, Jitter y Cargas de CPU

### 5.1. Overhead Computacional y Frecuencia Máxima de Conteo
Cada interrupción impone un costo en ciclos de reloj (*Context Switching*):
1. Salvaguarda de registros en el *Stack*.
2. Ejecución del código de la ISR.
3. Restauración de registros y retorno de la interrupción (`RETI`).

La frecuencia máxima leíble antes de perder pulsos o bloquear la CPU se calcula mediante:

$$f_{\text{max}} = \frac{1}{T_{\text{ISR\_ejecución}} + T_{\text{overhead\_hardware}}}$$

> **[ ESPACIO RESERVADO PARA IMAGEN 2 ]**
> * **Descripción requerida:** Gráfica del porcentaje de uso de la CPU vs. Frecuencia de pulsos del Encoder (demostrando la saturación por interrupciones a altas RPM).

---

### 5.2. Uso de Periféricos Deduplicados (Timers en Modo Encoder)
Como alternativa avanzada para evitar la sobrecarga de la CPU a elevadas revoluciones, los microcontroladores modernos (ARM STM32, ESP32, PIC32) incorporan **Timers de Hardware dedicados con interfaz de encoder en cuadratura**. Estos decodifican la cuadratura directamente mediante lógica digital síncrona sin disparar interrupciones por cada flanco, solo generando interrupciones por desbordamiento (*overflow*).

---

## 6. Conclusiones
* La lectura por interrupciones en cuadratura mediante **GPIO/EXTI** es la solución ideal en sistemas de bajo costo o baja frecuencia de actualización, garantizando una respuesta inmediata del microcontrolador.
* La optimización de la ISR mediante **matrices de transición de estados y operaciones bitwise** minimiza el tiempo de ejecución y previene el desbordamiento de la pila de memoria.
* Para aplicaciones de alta velocidad, se debe considerar el filtrado estricto por hardware para eliminar rebotes y la migración hacia módulos de hardware dedicados (*Hardware Quadrature Encoder Interface - QEI*).

---

## 7. Bibliografía (Formato IEEE)

* [1] M. Barr, "Reading quadrature encoders," *Embedded Systems Programming*, vol. 17, no. 2, pp. 43-48, Feb. 2004.
* [2] Microchip Technology Inc., "Section 15. Quadrature Encoder Interface (QEI)," *dsPIC33F/PIC24H Family Reference Manual*, DS70208B, 2009.
* [3] STMicroelectronics, "RM0008 Reference Manual: STM32F101xx, STM32F102xx, STM32F103xx, STM32F105xx and STM32F107xx advanced ARM®-based 32-bit MCUs," DocID13902 Rev 17, 2015.
* [4] J. W. Valvano, *Embedded Systems: Real-Time Interfacing to ARM Cortex-M Microcontrollers*, 5th ed. Austin, TX, USA: Jonathan W. Valvano, 2017.
* [5] Texas Instruments, "Quadrature Encoder Interface (QEI) Module," *TM4C123GH6PM Microcontroller Data Sheet*, DS-TM4C123GH6PM-15842.2741, 2014.
