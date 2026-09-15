# Aritmética de punto fijo (Q15/Q31) para DSP en microcontroladores ARM

## Introducción

El procesamiento digital de señales (DSP, *Digital Signal Processing*) constituye una tecnología fundamental en aplicaciones embebidas como procesamiento de audio, comunicaciones digitales, instrumentación, control de motores, sensores y sistemas de adquisición de datos. En estas aplicaciones, los microcontroladores ARM Cortex-M son ampliamente utilizados debido a su bajo consumo energético, capacidad de procesamiento y disponibilidad de instrucciones orientadas a operaciones matemáticas y de procesamiento de señales.

Una de las decisiones importantes al implementar algoritmos DSP en un microcontrolador consiste en seleccionar la representación numérica adecuada. Aunque la aritmética de punto flotante facilita el desarrollo de algoritmos, la representación de punto fijo continúa siendo especialmente importante en sistemas donde se busca reducir el consumo de recursos, utilizar microcontroladores sin una unidad de punto flotante o aprovechar eficientemente las instrucciones DSP del procesador.

Los formatos Q15 y Q31 son dos de las representaciones de punto fijo más utilizadas en el ecosistema ARM y en la biblioteca CMSIS-DSP. Q15 emplea generalmente enteros con signo de 16 bits y representa valores fraccionarios utilizando 15 bits para la parte fraccionaria. Q31 utiliza enteros con signo de 32 bits y proporciona una mayor resolución. La biblioteca CMSIS-DSP incluye funciones específicas para operaciones vectoriales, filtros, transformadas y otras funciones matemáticas utilizando estos formatos. [1], [2]

El objetivo de este trabajo es explicar el funcionamiento de la aritmética de punto fijo Q15 y Q31, sus operaciones básicas, ventajas, limitaciones y aplicación en algoritmos DSP implementados sobre microcontroladores ARM Cortex-M.

## Desarrollo técnico

### 1. Concepto de aritmética de punto fijo

En una representación de punto fijo, la posición del punto binario se mantiene constante. En lugar de almacenar directamente un número decimal, se almacena un entero que debe interpretarse considerando un factor de escala.

Para una representación Q15 utilizada habitualmente para señales normalizadas, el valor real puede obtenerse mediante:

**x_real = x_Q15 / 2^15**

Por lo tanto:

**x_real = x_Q15 / 32768**

El formato Q31 utiliza el mismo principio, pero con 31 bits fraccionarios:

**x_real = x_Q31 / 2^31**

es decir:

**x_real = x_Q31 / 2147483648**

La documentación de CMSIS-DSP confirma estas relaciones para la conversión de valores Q15 y Q31 a punto flotante. [2], [3]

En términos prácticos, Q15 permite representar aproximadamente el intervalo [-1, 1), mientras que Q31 ofrece el mismo intervalo normalizado pero con una resolución considerablemente mayor. Para Q15, los límites enteros son -32768 y 32767; para Q31 son -2147483648 y 2147483647. [1]

### 2. Conversión entre punto flotante y punto fijo

Para convertir un número de punto flotante normalizado a Q15 se utiliza:

**Q15 = round(x × 2^15)**

Por ejemplo, para convertir 0.5:

**Q15 = 0.5 × 32768 = 16384**

Por tanto, el entero 16384 representa el valor real 0.5.

En Q31:

**Q31 = round(x × 2^31)**

Para el mismo valor:

**Q31 = 0.5 × 2147483648 = 1073741824**

Posteriormente, para recuperar el valor real se divide el entero entre el mismo factor de escala.

Es importante aplicar saturación durante la conversión. Si un valor normalizado excede el intervalo representable, no debe producirse un desbordamiento convencional que cambie el signo o genere un resultado inesperado. En su lugar, debe limitarse al valor máximo o mínimo permitido. CMSIS-DSP proporciona mecanismos específicos para realizar estas operaciones de saturación. [1], [4]

### 3. Operaciones aritméticas en Q15

La suma de dos números Q15 es relativamente sencilla porque ambos utilizan la misma escala:

**z_Q15 = x_Q15 + y_Q15**

Sin embargo, antes de almacenar el resultado debe verificarse si existe overflow. Por ejemplo, sumar dos valores cercanos a 1 puede superar el máximo representable.

La multiplicación requiere mayor atención. Si:

**x_real = x_Q15 / 2^15**

y

**y_real = y_Q15 / 2^15**

entonces:

**x_real × y_real = (x_Q15 × y_Q15) / 2^30**

Por tanto, el producto de dos números Q15 produce inicialmente un resultado con una escala equivalente a Q30. Para recuperar el formato Q15 es necesario realizar un desplazamiento de 15 bits:

**z_Q15 ≈ (x_Q15 × y_Q15) >> 15**

El uso de un acumulador de mayor tamaño es recomendable para evitar pérdidas de información y desbordamientos durante operaciones consecutivas.

### 4. Operaciones aritméticas en Q31

En Q31 ocurre un fenómeno similar, pero el producto de dos valores de 32 bits requiere potencialmente hasta 64 bits para conservar el resultado completo:

**x_Q31 × y_Q31 → producto de 64 bits**

Posteriormente, el resultado debe ser escalado para volver al formato Q31.

La mayor ventaja de Q31 frente a Q15 es su resolución. Al disponer de más bits fraccionarios, puede representar diferencias mucho más pequeñas entre valores. Esto resulta particularmente importante en algoritmos donde los errores de cuantización afectan significativamente al resultado, como filtros IIR, estimación espectral, control digital y determinados algoritmos de audio.

Sin embargo, Q31 también consume el doble de memoria por muestra respecto de Q15 y puede requerir operaciones de mayor tamaño. Por ello, la selección del formato depende del compromiso entre precisión, memoria y rendimiento.

### 5. Saturación y overflow

Uno de los problemas fundamentales de la aritmética de punto fijo es el overflow. Si una operación genera un valor mayor que el máximo representable, un procesador que simplemente descarte los bits superiores puede producir un resultado completamente incorrecto.

Por ejemplo, en una representación con signo de 16 bits, el máximo entero es 32767. Si una suma produce 40000 y se interpreta directamente como entero de 16 bits, el resultado puede convertirse en un número negativo debido al desbordamiento.

La saturación evita este comportamiento. En términos conceptuales:

* Si el resultado es mayor que el máximo → se utiliza el máximo.
* Si el resultado es menor que el mínimo → se utiliza el mínimo.
* Si está dentro del intervalo → se conserva el resultado.

Esta característica es especialmente importante en DSP porque los filtros y operaciones vectoriales pueden acumular numerosos productos. CMSIS-DSP advierte explícitamente sobre los riesgos de overflow y saturación en operaciones como convoluciones y filtros de punto fijo. [5], [6]

### 6. Aplicación en filtros FIR

Un ejemplo representativo es un filtro FIR (*Finite Impulse Response*). Su ecuación es:

**y[n] = Σ h[k]x[n-k]**

donde x[n] representa la señal de entrada y h[k] los coeficientes del filtro.

Cuando se utilizan Q15, tanto la señal como los coeficientes pueden almacenarse como valores de 16 bits. Cada multiplicación produce un resultado de mayor precisión y los productos se acumulan antes de realizar la conversión final.

CMSIS-DSP dispone de funciones como `arm_fir_q15()` y `arm_fir_q31()` para implementar filtros FIR directamente con estas representaciones. En la implementación Q15 documentada por ARM, los productos 2.30 pueden acumularse utilizando un acumulador interno de 64 bits, reduciendo considerablemente el riesgo de overflow durante la acumulación. [6]

Esto demuestra una de las principales ventajas de utilizar una biblioteca DSP optimizada: el programador no necesita implementar desde cero todos los mecanismos de escalamiento, acumulación y manipulación de datos.

### 7. CMSIS-DSP y microcontroladores ARM Cortex-M

CMSIS-DSP es una biblioteca desarrollada para proporcionar funciones matemáticas y de procesamiento de señales optimizadas para procesadores ARM. Incluye operaciones para Q7, Q15, Q31 y diferentes formatos de punto flotante. Entre sus funciones se encuentran filtros FIR e IIR, transformadas FFT, operaciones matriciales, funciones estadísticas, procesamiento complejo y operaciones vectoriales. [1], [7]

Los tipos `q15_t` y `q31_t` se utilizan para representar datos de punto fijo en la biblioteca. Además, CMSIS-DSP proporciona funciones de conversión entre formatos. Por ejemplo, la conversión de Q15 a Q31 puede realizarse mediante un desplazamiento de 16 bits, mientras que la conversión inversa requiere reducir la representación de 32 a 16 bits. [2], [3]

Una ventaja importante de utilizar CMSIS-DSP es que las implementaciones pueden aprovechar las características específicas de diferentes arquitecturas ARM. La biblioteca contempla distintas arquitecturas y extensiones, incluyendo implementaciones optimizadas para procesadores con extensiones DSP. [7]

### 8. Comparación entre Q15 y Q31

Q15 es especialmente conveniente cuando la memoria disponible es limitada y la precisión requerida es moderada. Al utilizar 16 bits por muestra, permite almacenar el doble de muestras en la misma cantidad de memoria que Q31. Esto puede ser beneficioso en sistemas de audio, sensores y procesamiento de señales donde se manejan grandes buffers.

Q31, por otra parte, ofrece una resolución significativamente superior. Esto permite reducir el error de cuantización, aunque requiere mayor memoria y puede incrementar el costo computacional de algunas operaciones.

Por esta razón, no existe un formato universalmente superior. La elección debe realizarse considerando el rango dinámico de la señal, precisión necesaria, memoria disponible, velocidad de procesamiento y características específicas del microcontrolador.

### 9. Consideraciones prácticas de implementación

Al implementar DSP en punto fijo deben definirse cuidadosamente las escalas de todas las variables. Un error frecuente consiste en utilizar diferentes escalas para señales que posteriormente serán sumadas o comparadas.

También es necesario analizar los productos intermedios y las acumulaciones. Una expresión matemáticamente correcta puede producir overflow cuando se implementa directamente con enteros de tamaño limitado.

Una estrategia habitual consiste en normalizar las señales para mantenerlas dentro de un intervalo conocido y utilizar acumuladores de mayor tamaño. Posteriormente, se realiza el redimensionamiento mediante desplazamientos y, cuando sea necesario, saturación.

En algoritmos complejos también puede resultar conveniente utilizar Q15 para almacenar señales y Q31 para realizar determinados cálculos intermedios que requieren mayor precisión. ARM muestra, por ejemplo, casos en CMSIS-DSP donde una operación de energía resulta demasiado sensible a la precisión de Q15 y se convierte a Q31 para mejorar la exactitud. [8]

## Conclusiones

La aritmética de punto fijo constituye una alternativa eficiente para implementar algoritmos de procesamiento digital de señales en microcontroladores ARM. Los formatos Q15 y Q31 permiten representar señales normalizadas mediante enteros, evitando en determinadas aplicaciones el costo computacional y de memoria asociado al punto flotante.

Q15 ofrece una solución eficiente en memoria y resulta apropiado para numerosas aplicaciones de audio, filtrado y adquisición de señales. Q31 proporciona mayor precisión y es recomendable cuando los errores de cuantización o la acumulación de operaciones pueden afectar significativamente al resultado.

No obstante, trabajar con punto fijo requiere un análisis cuidadoso del escalamiento, overflow, saturación y precisión de los resultados intermedios. La selección incorrecta de la escala puede provocar pérdida de información o resultados numéricamente inestables.

La biblioteca CMSIS-DSP facilita considerablemente la implementación al proporcionar funciones optimizadas para operaciones Q15 y Q31, filtros, transformadas y procesamiento vectorial. Por ello, el uso combinado de una representación de punto fijo apropiada y las funciones optimizadas de CMSIS-DSP constituye una estrategia efectiva para desarrollar sistemas DSP eficientes sobre microcontroladores ARM Cortex-M.

En conclusión, Q15 y Q31 continúan siendo representaciones relevantes para sistemas embebidos debido a su equilibrio entre precisión, memoria y rendimiento. La decisión entre ambos formatos debe realizarse a partir de los requisitos concretos de la aplicación y no únicamente de la cantidad de bits disponible.

## Bibliografía

[1] Arm, “CMSIS-DSP: Fixed point datatypes,” *Arm CMSIS-DSP Documentation*, 2026.

[2] Arm, “CMSIS-DSP: Convert 16-bit fixed point value,” *Arm CMSIS-DSP Documentation*, 2026.

[3] Arm, “CMSIS-DSP: Convert 32-bit fixed point value,” *Arm CMSIS-DSP Documentation*, 2026.

[4] Arm Software, “CMSIS-DSP fixed-point implementation,” *GitHub*, Arm-software/CMSIS-DSP, 2026.

[5] Arm, “CMSIS-DSP: Convolution,” *Arm CMSIS-DSP Documentation*, 2026.

[6] Arm, “CMSIS-DSP: Finite Impulse Response (FIR) Filters,” *Arm CMSIS-DSP Documentation*, 2026.

[7] Arm, *Digital Signal Processing using Arm Cortex-M based Microcontrollers: Theory and Practice*, Arm Education Media, 2025.

[8] Arm, “Write the CMSIS-DSP Q15 implementation,” *Arm Learning Paths*, 2026.
