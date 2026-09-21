# DMA en microcontroladores ARM: transferencias de datos sin intervención de la CPU

**Nombre:** Navarro González Cynthia Yalid

**Número de control:** 24210511

**Carrera:** Ingeniería en Sistemas Computacionales

## 1. Introducción

El controlador de Acceso Directo a Memoria (**DMA**, por sus siglas en inglés _Direct Memory Access_) es una unidad de hardware dedicada y programable que permite realizar transferencias de datos entre la memoria y los periféricos de un microcontrolador **sin que el procesador tenga que intervenir directamente en el movimiento de cada dato**.

En los microcontroladores basados en procesadores **Arm Cortex-M**, el DMA constituye un recurso importante para aplicaciones que requieren mover datos de manera frecuente. Por ejemplo, la familia **STM32** incorpora controladores DMA que permiten gestionar solicitudes de acceso a memoria provenientes de diferentes periféricos. La cantidad de controladores, canales y características disponibles depende del modelo específico del microcontrolador.

Como ejemplo, el STM32L476 utilizado en la documentación de STMicroelectronics incorpora dos controladores DMA, denominados DMA1 y DMA2, con siete canales regulares cada uno.

Para comprender la utilidad del DMA, es necesario comparar una transferencia realizada directamente por la CPU con una transferencia gestionada por este controlador de hardware.

### 1.1 Transferencia normal sin DMA

Sin DMA, el procesador debe participar directamente en el movimiento de los datos. En este caso, la CPU ejecuta las instrucciones necesarias para obtener los datos provenientes de un periférico y almacenarlos en un búfer.

De manera conceptual, una aplicación podría realizar una operación como la siguiente:

```c
for (int i = 0; i < 100; i++) {
    buffer[i] = USART_ReceiveData();
}


```

En este caso, la CPU debe encargarse repetidamente de recibir los datos y almacenarlos en memoria. Esto consume ciclos de procesamiento que podrían utilizarse para ejecutar otras operaciones del programa.

Cuando la cantidad de datos aumenta o las transferencias son frecuentes, la intervención constante del procesador puede convertirse en una limitación para el funcionamiento del sistema.

### 1.2 Transferencia con DMA

Con DMA, el proceso se divide en una fase de configuración y una fase de transferencia automática:

1.  **Configuración:** la CPU configura el controlador DMA, indicando parámetros como la dirección de origen, la dirección de destino, la cantidad de datos y la dirección de transferencia.
    
2.  **Transferencia:** el controlador DMA realiza el movimiento de los datos mediante el bus del microcontrolador, sin que la CPU tenga que ejecutar instrucciones para mover cada elemento.
    
3.  **Ejecución de otras tareas:** mientras el DMA realiza la transferencia, la CPU puede continuar ejecutando otras instrucciones.
    
4.  **Notificación:** cuando corresponde, el DMA puede informar a la CPU mediante una interrupción que la transferencia ha finalizado o que se produjo algún evento relacionado con ella.
    

Por lo tanto, DMA permite realizar la transferencia de datos **sin intervención directa de la CPU durante el movimiento de cada elemento**. La CPU participa principalmente en la configuración inicial del controlador y, cuando se requiere, en la atención de eventos generados por el DMA.

![7. Diagrama en bloque de un canal DMA. | Download Scientific Diagram](https://www.researchgate.net/profile/Santiago-Perez-5/publication/282335835/figure/fig53/AS:668972395556868@1536506856205/Diagrama-en-bloque-de-un-canal-DMA.png)

## 2. Configuración del DMA en microcontroladores STM32

En los microcontroladores STM32, la configuración del DMA puede realizarse directamente mediante registros o mediante las bibliotecas proporcionadas por STMicroelectronics, como la **HAL (Hardware Abstraction Layer)**.

El uso de HAL permite trabajar con estructuras y funciones de C que simplifican la configuración de los periféricos y del controlador DMA. De esta manera, el programador puede establecer los parámetros principales de una transferencia sin tener que manipular todos los registros de hardware directamente.

En diferentes familias STM32 pueden existir diferencias en la forma de configurar los controladores DMA. Por esta razón, siempre es necesario consultar la documentación correspondiente al microcontrolador utilizado.

### 2.1 Dirección de transferencia

![Definición de DMA - ¿Qué es DMA?](https://techterms.com/img/xl/dma_539.png)  
Uno de los parámetros principales es la dirección en la que se moverán los datos. Las configuraciones habituales son:

-   **Periférico → memoria:** utilizada, por ejemplo, para recibir datos de un ADC y almacenarlos en RAM.
    
-   **Memoria → periférico:** utilizada para enviar datos desde un búfer hacia UART, SPI u otros periféricos.
    
-   **Memoria → memoria:** permite copiar información de una región de memoria hacia otra cuando el controlador DMA del microcontrolador admite esta modalidad.
    

La dirección determina cómo debe interpretar el controlador DMA las direcciones de origen y destino.

### 2.2 Modo de transferencia

El DMA puede disponer de diferentes modos de funcionamiento. Entre los más comunes se encuentran:

-   **Normal:** la transferencia termina cuando se alcanza la cantidad de datos configurada.
    
-   **Circular:** al finalizar una transferencia, el controlador puede reutilizar el búfer y continuar con nuevas transferencias.
    

El modo circular resulta especialmente útil cuando un periférico genera datos continuamente. Por ejemplo, puede utilizarse para almacenar continuamente muestras provenientes de un ADC.

En determinados controladores STM32, el modo memoria a memoria no debe utilizarse en modo circular, por lo que la configuración debe realizarse de acuerdo con las características específicas del dispositivo.

### 2.3 Prioridad

Cuando diferentes solicitudes necesitan utilizar los recursos del DMA, el controlador puede utilizar niveles de prioridad para determinar cuál solicitud debe recibir atención.

Dependiendo de la familia STM32, pueden existir niveles como:

-   `DMA_PRIORITY_LOW`
    
-   `DMA_PRIORITY_MEDIUM`
    
-   `DMA_PRIORITY_HIGH`
    
-   `DMA_PRIORITY_VERY_HIGH`
    

La prioridad permite organizar las transferencias cuando existen múltiples solicitudes provenientes de diferentes periféricos.

### 2.4 Incremento de direcciones y tamaño de datos

Otros parámetros importantes son los relacionados con el incremento de las direcciones y el tamaño de los datos.

Por ejemplo:

-   `PeriphInc`: determina si la dirección del periférico se incrementa.
    
-   `MemInc`: determina si la dirección de memoria se incrementa.
    
-   `PeriphDataAlignment`: establece el tamaño de los datos del periférico.
    
-   `MemDataAlignment`: establece el tamaño de los datos en memoria.
    

El tamaño de los datos puede configurarse de acuerdo con las capacidades del periférico y del controlador, utilizando unidades como **Byte, Halfword o Word**.

Una configuración incorrecta de estos parámetros puede ocasionar que los datos se almacenen de forma incorrecta.

## 3. Implementación práctica: UART en modo DMA

Uno de los usos comunes del DMA en microcontroladores es la comunicación mediante **UART**. En una transmisión tradicional, la CPU puede encargarse directamente de enviar los datos uno por uno. Con DMA, es posible proporcionar al controlador un búfer ubicado en memoria y solicitar que los datos sean transferidos automáticamente hacia el periférico UART.

En este trabajo se utiliza como referencia un microcontrolador STM32 basado en **Arm Cortex-M**, una familia de procesadores orientada principalmente a sistemas embebidos y microcontroladores. Este tipo de implementación corresponde al entorno de procesamiento de 32 bits utilizado habitualmente en los microcontroladores Cortex-M.

De esta manera, la CPU no necesita ejecutar instrucciones para mover cada byte individualmente, sino que configura inicialmente la transferencia y permite que el hardware DMA se encargue del movimiento de los datos.

### 3.1 Inicialización y habilitación de relojes

Antes de utilizar el controlador DMA es necesario habilitar su reloj. En STM32, esto puede realizarse mediante funciones de HAL como:

```c
__HAL_RCC_DMA1_CLK_ENABLE();


```

También deben configurarse las interrupciones correspondientes cuando se desea utilizar el DMA mediante interrupciones.

Para ello se utiliza el controlador de interrupciones **NVIC (Nested Vectored Interrupt Controller)**, utilizado por los procesadores Arm Cortex-M para administrar las interrupciones de los periféricos y otros recursos internos del microcontrolador.

Por ejemplo:

```c
HAL_NVIC_SetPriority(DMA1_Channel4_IRQn, 0, 0);
HAL_NVIC_EnableIRQ(DMA1_Channel4_IRQn);


```

Los canales y nombres concretos dependen del modelo de microcontrolador y de la asignación de periféricos correspondiente.

Es importante señalar que el uso del NVIC es característico de la arquitectura Cortex-M. No debe asumirse que un sistema Arm de 64 bits utiliza exactamente el mismo mecanismo, ya que las plataformas Arm64 emplean sistemas de interrupciones diferentes dependiendo del procesador y de la plataforma.

### 3.2 Envío de datos mediante DMA

Una transmisión mediante UART puede iniciarse utilizando una función de HAL como:

```c
HAL_UART_Transmit_DMA(&huart1, (uint8_t *)mensaje1, sizeof(mensaje1));


```

En este caso, la aplicación proporciona al controlador UART un búfer que contiene los datos que deben transmitirse.

El flujo general puede representarse de la siguiente manera:

**Búfer en RAM → DMA → UART → dispositivo externo**

Una vez iniciada la transferencia, el DMA se encarga de mover los datos hacia el periférico **sin que la CPU tenga que intervenir directamente en el movimiento de cada byte**. De esta manera, la CPU puede continuar ejecutando otras instrucciones.

Este principio no es exclusivo de los microcontroladores basados en Arm. El DMA también puede implementarse en sistemas basados en otras arquitecturas, como **RISC-V**, ya que el controlador DMA es un recurso de hardware independiente de la arquitectura del conjunto de instrucciones del procesador.

### 3.3 Recepción de datos mediante DMA

El DMA también puede utilizarse para recibir datos desde UART hacia un búfer de memoria.

Por ejemplo:

```c
HAL_UART_Receive_DMA(&huart1, (uint8_t *)datos_rx, 3);


```

En este caso, el flujo de información es inverso:

**UART → DMA → búfer en RAM**

Esta configuración resulta útil cuando el microcontrolador necesita recibir una cantidad determinada de datos **sin que la CPU tenga que procesar cada byte individualmente**.

En un microcontrolador RISC-V que disponga de DMA y UART, puede utilizarse un principio similar: el procesador configura la transferencia y el controlador DMA mueve los datos entre el periférico y la memoria. Sin embargo, las funciones, registros y controladores utilizados serían diferentes de los de STM32 HAL.

----------

## 4. Transferencias memoria a memoria mediante DMA

El DMA no solamente puede utilizarse para comunicar memoria con periféricos. Algunos microcontroladores STM32 permiten realizar transferencias directamente entre dos regiones de memoria.

Este funcionamiento se conoce como **Memory-to-Memory (M2M)**.

En este modo, la transferencia puede iniciarse mediante software sin necesidad de que un periférico genere una solicitud de DMA.

El flujo básico es:

**Memoria origen → DMA → memoria destino**

Una vez configuradas las direcciones de origen y destino y la cantidad de datos, el DMA puede comenzar la transferencia.

La existencia de esta modalidad muestra que el DMA puede utilizarse como un mecanismo general para mover bloques de información dentro del sistema de memoria del microcontrolador.

### 4.1 Ejemplo de transferencia memoria a memoria

Se pueden utilizar dos búferes:

```c
uint8_t Buffer_Src[] = {0,1,2,3,4,5,6,7,8,9};
uint8_t Buffer_Dest[10];


```

El primer búfer contiene los datos originales y el segundo será utilizado como destino.

La transferencia puede iniciarse mediante:

```c
HAL_DMA_Start(
    &hdma_memtomem_dma1_channel1,
    (uint32_t)Buffer_Src,
    (uint32_t)Buffer_Dest,
    10
);


```

Posteriormente, el programa puede consultar el estado de la transferencia:

```c
while (HAL_DMA_PollForTransfer(
    &hdma_memtomem_dma1_channel1,
    HAL_DMA_FULL_TRANSFER,
    100
) != HAL_OK)
{
    __NOP();
}


```

Cuando la operación termina correctamente, los datos contenidos en `Buffer_Src` deben encontrarse también en `Buffer_Dest`.

Este ejemplo demuestra que el DMA puede realizar operaciones de copia de memoria **sin que la CPU tenga que ejecutar una instrucción de copia para cada elemento**.

### 4.2 Relación con otras arquitecturas

El concepto de transferencia memoria a memoria no es exclusivo de ARM. Un controlador DMA puede formar parte de diferentes sistemas embebidos independientemente de que el procesador utilice una arquitectura Arm o RISC-V.

En un microcontrolador **Arm Cortex-M**, como el STM32 utilizado en este ejemplo, el procesador configura el controlador DMA mediante software y posteriormente el hardware realiza la transferencia **sin intervención directa de la CPU en el movimiento de cada elemento**.

En un sistema basado en **RISC-V**, puede existir una organización similar:

**CPU RISC-V → configuración del DMA → DMA → memoria**

La principal diferencia se encuentra en la implementación concreta del hardware y en la forma en que el software configura sus registros y periféricos.

Por otro lado, en sistemas **Arm64** también pueden existir controladores DMA, aunque normalmente se encuentran en plataformas de mayor complejidad que los microcontroladores Cortex-M. Por esta razón, la forma de configuración, administración de memoria e interrupciones puede ser diferente.

----------

## 5. Transferencias mediante interrupciones

Otra forma de controlar una transferencia DMA consiste en utilizar interrupciones en lugar de consultar continuamente su estado mediante _polling_.

Para utilizar este mecanismo es necesario habilitar la interrupción correspondiente al canal DMA mediante el NVIC.

Después de habilitarla, el controlador puede notificar diferentes eventos, como:

-   Transferencia completada.
    
-   Transferencia parcialmente completada.
    
-   Error durante la transferencia.
    

En una aplicación STM32 basada en Cortex-M, el flujo puede representarse como:

**DMA → IRQ → `HAL_DMA_IRQHandler()` → callback**

Un manejador de interrupción puede tener una estructura como:

```c
void DMA1_Channel1_IRQHandler(void)
{
    HAL_DMA_IRQHandler(&hdma_memtomem_dma1_channel1);
}


```

Posteriormente, HAL puede ejecutar el callback configurado para indicar que la transferencia terminó correctamente.

Por ejemplo:

```c
void XferCpltCallback(DMA_HandleTypeDef *hdma)
{
    __NOP();
}


```

En este caso, la función se ejecutará cuando la transferencia haya finalizado correctamente.

El uso de interrupciones permite evitar que el programa tenga que permanecer consultando constantemente el estado del DMA. Esto resulta especialmente útil cuando el microcontrolador debe realizar otras tareas mientras la transferencia se encuentra en progreso.

Durante la transferencia, **la CPU no necesita intervenir directamente en el movimiento de los datos**; únicamente puede atender la interrupción cuando el controlador DMA informa que ocurrió un evento.

### 5.1 Interrupciones en diferentes arquitecturas

La forma de manejar las interrupciones depende de la arquitectura y del diseño específico del microcontrolador o sistema.

En **Arm Cortex-M**, el NVIC forma parte del modelo de interrupciones de la familia Cortex-M y permite gestionar eventos generados por periféricos como el DMA.

En **RISC-V**, el mecanismo de interrupciones utiliza elementos propios de esta arquitectura y del microcontrolador específico. Por lo tanto, aunque el principio general puede ser similar —el DMA genera un evento y el procesador ejecuta una rutina de atención—, los registros, controladores y mecanismos utilizados pueden ser diferentes.

En **Arm64**, las plataformas utilizan sistemas de interrupciones propios de los procesadores Arm de 64 bits y de la plataforma en la que se encuentren integrados. Por ello, no sería correcto aplicar directamente el ejemplo de NVIC utilizado en Cortex-M a un sistema Arm64.

Esto permite observar que el concepto de DMA puede mantenerse entre arquitecturas diferentes, mientras que la interfaz concreta entre el software y el hardware cambia según el sistema.

----------

## 6. DMA como interfaz entre software y hardware

Una de las características más importantes del DMA es que permite observar claramente la comunicación entre diferentes niveles de un sistema embebido.

En una aplicación basada en STM32 y programada en C, la relación puede representarse de la siguiente manera:

**Programa en C → HAL → controlador DMA → bus del microcontrolador → memoria/periférico**

El programa define la operación que necesita realizar. Posteriormente, mediante funciones de la HAL, se configuran los recursos correspondientes del microcontrolador.

Por ejemplo, una llamada como:

```c
HAL_UART_Transmit_DMA(&huart1, buffer, tamaño);


```

permite que el software solicite una transferencia utilizando el hardware DMA asociado al periférico UART.

En un nivel inferior, la configuración realizada mediante HAL termina relacionándose con registros y recursos físicos del microcontrolador.

Esta relación es especialmente importante en el estudio de los **lenguajes de interfaz**, ya que permite comprender cómo un programa escrito en C puede controlar recursos físicos del microcontrolador.

El proceso puede visualizarse como:

**Código C → funciones HAL → configuración de registros → controlador DMA → bus → periférico/memoria**

### 6.1 El DMA en ARM32, ARM64 y RISC-V

El concepto de interfaz entre software y hardware mediante DMA puede observarse en diferentes arquitecturas.

En un microcontrolador **Arm Cortex-M**, el programa normalmente utiliza funciones o controladores específicos del fabricante para configurar el DMA. En el caso de STM32, la biblioteca HAL proporciona una capa que facilita esta comunicación.

En sistemas **Arm64**, el concepto general continúa existiendo: el software configura un controlador DMA para realizar transferencias de datos entre memoria y determinados dispositivos. Sin embargo, estos sistemas suelen tener una organización de hardware y software más compleja, por lo que no necesariamente utilizan las mismas bibliotecas, registros o mecanismos de interrupción de un Cortex-M.

Por su parte, **RISC-V** representa una arquitectura diferente de ARM. Un microcontrolador RISC-V puede incorporar un controlador DMA y permitir que el procesador configure transferencias entre memoria y periféricos. En este caso, las instrucciones del procesador y los registros de control son diferentes, pero el principio de delegar una transferencia de datos a un bloque de hardware especializado puede mantenerse.

De esta manera, puede establecerse una comparación conceptual:

**Arm Cortex-M:**

**Código C → HAL/controlador → DMA → memoria/periférico**

**Arm64:**

**Software/controlador → DMA → memoria/dispositivo**

**RISC-V:**

**Código/controlador → DMA → memoria/periférico**

La comparación muestra que el DMA no pertenece exclusivamente a una arquitectura determinada. Es una técnica de organización del hardware que puede implementarse en diferentes tipos de sistemas de procesamiento.

----------

## 7. Aplicaciones del DMA en microcontroladores

El DMA puede utilizarse en diferentes tipos de aplicaciones embebidas. Su utilidad aumenta cuando un periférico produce o consume datos con frecuencia, ya que el movimiento de estos datos puede realizarse **sin intervención directa de la CPU**.

### 7.1 ADC y adquisición de datos

Un ADC puede producir continuamente muestras de una señal analógica. En lugar de que la CPU tenga que leer cada resultado y almacenarlo manualmente, el DMA puede transferir las muestras hacia un búfer de RAM.

El flujo sería:

**ADC → DMA → RAM**

Esto resulta útil en sistemas de adquisición de señales y sensores.

En microcontroladores basados en Arm Cortex-M, esta técnica permite aprovechar los periféricos internos del dispositivo sin dedicar constantemente al procesador a la transferencia de cada muestra.

### 7.2 Comunicación UART

En UART, DMA puede utilizarse tanto para transmisión como para recepción:

**RAM → DMA → UART**

o:

**UART → DMA → RAM**

Esto permite manejar bloques de datos **sin que la CPU tenga que intervenir directamente en cada byte**.

### 7.3 Comunicación SPI e I2C

Los periféricos de comunicación como SPI e I2C también pueden utilizar DMA en los microcontroladores que proporcionen esta funcionalidad.

Esto permite transferir bloques de información entre el periférico y la memoria de manera automática.

La implementación concreta depende del microcontrolador. Por ejemplo, un STM32 puede proporcionar determinados canales o solicitudes DMA asociados a sus periféricos, mientras que un microcontrolador RISC-V puede utilizar una organización de DMA diferente.

### 7.4 Adquisición continua

Cuando se necesita recibir información continuamente, puede utilizarse un búfer junto con configuraciones de DMA apropiadas. El modo circular resulta especialmente útil en este tipo de aplicaciones, ya que permite reutilizar el espacio de memoria para nuevas transferencias.

Este funcionamiento puede emplearse, por ejemplo, en sistemas de sensores, adquisición de señales o procesamiento periódico de datos.

### 7.5 DMA en diferentes arquitecturas

Aunque los ejemplos principales de este trabajo corresponden a microcontroladores Arm Cortex-M, el principio de DMA también puede encontrarse en otras arquitecturas.

En **RISC-V**, determinados microcontroladores y sistemas embebidos incorporan controladores DMA para disminuir la intervención directa del procesador en transferencias de datos.

En **Arm64**, el DMA también se utiliza en plataformas que requieren transferencias eficientes entre memoria y dispositivos. Sin embargo, debido a que Arm64 se utiliza habitualmente en sistemas con una organización diferente a la de un microcontrolador Cortex-M, los mecanismos utilizados pueden ser considerablemente más complejos.

Por esta razón, en este trabajo ARM64 se considera principalmente como una referencia para observar que el concepto de DMA puede extenderse a otros sistemas Arm, mientras que el análisis práctico se mantiene centrado en microcontroladores.

----------

## 8. Ventajas y consideraciones del uso de DMA en microcontroladores

El uso de DMA proporciona varias ventajas en aplicaciones de firmware:

> -   Reduce la cantidad de ciclos de procesamiento que la CPU necesita dedicar al movimiento de datos.
>     
> -   Permite que la CPU continúe ejecutando otras instrucciones mientras se realiza una transferencia.
>     
> -   Facilita el procesamiento continuo de datos provenientes de periféricos.
>     
> -   Permite trabajar con bloques de datos de manera eficiente.
>     
> -   Puede utilizarse junto con interrupciones para notificar la finalización de las transferencias.
>     
> -   Permite realizar transferencias memoria a memoria en los microcontroladores que soportan esta función.
>     
> -   Facilita aplicaciones de adquisición de datos mediante periféricos como ADC.
>     
> -   Puede utilizarse con interfaces de comunicación como UART, SPI e I2C.
>     

**Sin embargo, la utilización del DMA también requiere una configuración adecuada. Algunos aspectos importantes son:**

> -   Configuración correcta de las direcciones de origen y destino.
>     
> -   Selección adecuada del canal DMA asociado al periférico.
>     
> -   Configuración correcta del tamaño de los datos.
>     
> -   Configuración de los incrementos de memoria y periféricos.
>     
> -   Selección apropiada del modo Normal o Circular.
>     
> -   Configuración correcta de las prioridades.
>     
> -   Habilitación de las interrupciones cuando sean necesarias.
>     
> -   Sincronización adecuada entre el DMA y el programa principal.
>     
> -   Uso correcto de los búferes de memoria.
>     

Una configuración incorrecta puede provocar que los datos se almacenen en posiciones equivocadas, que una transferencia no se complete o que el programa interprete información antes de que el DMA haya terminado de escribirla.

Por ello, el estudio del DMA permite comprender no solamente la transferencia de datos, sino también la relación existente entre la arquitectura del procesador, el hardware del microcontrolador y el software utilizado para controlarlo.

----------

## 9. Conclusiones

El Acceso Directo a Memoria constituye un mecanismo importante en el diseño de aplicaciones para microcontroladores ARM basados en arquitecturas Cortex-M.

Los ejemplos de UART, ADC y transferencias memoria a memoria muestran que el DMA puede utilizarse en diferentes situaciones donde existe un flujo frecuente de información entre memoria y periféricos o entre regiones de memoria, realizando el movimiento de los datos **sin intervención directa de la CPU**.

La utilización de bibliotecas como HAL también demuestra la relación entre el software y el hardware. Una instrucción escrita en C puede iniciar una operación que posteriormente será realizada por un controlador DMA mediante los recursos internos del microcontrolador.

El concepto de DMA tampoco está limitado a una sola arquitectura. Arm Cortex-M, sistemas Arm64 y plataformas basadas en RISC-V pueden utilizar mecanismos de DMA, aunque la implementación concreta, los registros, las interrupciones y los controladores utilizados pueden ser diferentes.

En este sentido, **ARM32/Cortex-M representa el enfoque principal de este trabajo**, debido a su presencia directa en microcontroladores como STM32 y SAM D. ARM64 y RISC-V permiten ampliar la perspectiva y observar que la transferencia de datos mediante hardware especializado puede utilizarse en diferentes arquitecturas de procesamiento.

## 10. Referencias

[1] Ampheo, "What is DMA (Direct Memory Access), and how do I use it?", _Medium_, Jun. 19, 2025. [En línea]. Disponible en: [https://medium.com/@pqshedy33/what-is-dma-direct-memory-access-and-how-do-i-use-it-4249aec1bf13](https://medium.com/@pqshedy33/what-is-dma-direct-memory-access-and-how-do-i-use-it-4249aec1bf13). [Accedido: 20-sep.-2026].

[2] Arm Ltd., "Arm Technical Documentation," _Arm Developer_. [En línea]. Disponible en: [https://support.arm.com/documentation/dto0038/c/CHDEFACB](https://support.arm.com/documentation/dto0038/c/CHDEFACB). [Accedido: 20-sep.-2026].

[3] "DMA-STM32," _DMA MICROCONTROLADORES_. [En línea]. Disponible en: [https://es.scribd.com/document/528674077/DMA-STM32](https://es.scribd.com/document/528674077/DMA-STM32). [Accedido: 20-sep.-2026].

[4] STMicroelectronics, "Getting started with DMA," _STM32 Microcontrollers Wiki_. [En línea]. Disponible en: [https://wiki.st.com/stm32mcu/wiki/Getting_started_with_DMA](https://wiki.st.com/stm32mcu/wiki/Getting_started_with_DMA). [Accedido: 20-sep.-2026].

[5] Microchip Technology Inc., "SAM D Arm Cortex-M-Based Microcontrollers," _Microchip Technology_. [En línea]. Disponible en: [https://www.microchip.com/en-us/products/microcontrollers/32-bit-mcus/pic32-sam/sam-d](https://www.microchip.com/en-us/products/microcontrollers/32-bit-mcus/pic32-sam/sam-d). [Accedido: 20-sep.-2026].
