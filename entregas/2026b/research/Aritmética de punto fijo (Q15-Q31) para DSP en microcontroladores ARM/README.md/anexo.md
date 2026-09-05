ESTUDIANTE: CARRERA AGUIRRE JOEL 
MATRICULA: 23211930
MATERIA: LENGUAJES DE INTERFAZ GRUPO B
UNIVERSIDAD: INSTITUTO TECNOLOGICO DE TIJUANA


Investigación: Aritmética de punto fijo (Q15/Q31) para DSP en microcontroladores ARM
Desarrollo técnico

La aritmética de punto fijo es una técnica ampliamente utilizada en el procesamiento digital de señales (DSP, Digital Signal Processing ) cuando se requiere realizar operaciones matemáticas de manera eficiente en microcontroladores. A diferencia de la aritmética de punto flotante, donde la posición del punto decimal puede variar, en punto fijo la posición de la parte fraccionaria permanece determinada. Esto permite representar números reales utilizando registros enteros y realizar operaciones con menor consumo de recursos computacionales. En el ecosistema ARM, especialmente en microcontroladores Cortex-M, los formatos Q15 y Q31 son importantes para implementar filtros digitales, transformadas, control de motores, audio y otras aplicaciones DSP. La biblioteca CMSIS-DSP de Arm proporciona funciones específicas para trabajar con datos Q15 y Q31.

El formato Q15 utiliza 16 bits con signo: un bit representa el signo y los otros 15 bits representan la parte fraccionaria. En términos prácticos, permite representar valores aproximadamente desde -1.0 hasta 0.999969 , utilizando una escala de\(2^{15}=32768\). Por ejemplo, el valor decimal 0.5 se representa como:

$$ 0.5 \times 2^{15}=16384 $$

Por lo tanto, 0.5 se almacena como el entero 16384, que en hexadecimal corresponde a 0x4000 . Para recuperar el valor real, se realiza:

$$ Valor_{real}=\frac{Valor_{entero}}{2^{15}} $$

La documentación de CMSIS-DSP identifica Q15 como un tipo de datos de 16 bits y Q31 como uno de 32 bits.

El formato Q31 , por su parte, utiliza 32 bits con signo, con 31 bits destinados a la fracción. Su rango práctico es aproximadamente de -1.0 a 0.9999999995 . La conversión se realiza utilizando\(2^{31}\). Por ejemplo, para representar 0,5:

$$ 0.5\times2^{31}=1073741824 $$

El resultado es 0x40000000 . Al igual que en Q15, para recuperar el valor real se divide el número entero entre\(2^{31}\). CMSIS-DSP define específicamente los tipos Q15 y Q31 y proporciona operaciones matemáticas para ellos.

Una de las principales ventajas de utilizar punto fijo en DSP es la eficiencia computacional . Muchos microcontroladores ARM Cortex-M están diseñados para ejecutar operaciones enteras de manera rápida, y determinadas familias incluyen instrucciones DSP que permiten acelerar multiplicaciones, acumulaciones y otras operaciones utilizadas frecuentemente en filtros digitales. Esto resulta especialmente importante en sistemas embebidos donde existen restricciones de memoria, consumo energético y tiempo de procesamiento.

Operaciones aritméticas en Q15 y Q31

En la suma y resto, ambos números deben utilizar el mismo formato. Por ejemplo, en Q15:

$$ 0.25\times32768=8192 $$

y:

$$ 0.125\times32768=4096 $$

Por lo tanto:

$$ 8192+4096=12288 $$

Al convertir nuevamente:

$$ \frac{12288}{32768}=0.375 $$

Uno de los problemas principales es el desbordamiento ( overflow ) . Si una operación produce un resultado superior al rango permitido, el sistema puede necesitar aplicar saturación . En lugar de permitir que el resultado se desborde y produzca un valor incorrecto, la saturación limita el resultado al máximo o mínimo representable. CMSIS-DSP incluye mecanismos y funciones de saturación para este propósito.

La multiplicación requiere especial atención. Cuando se multiplican dos valores Q15, los operandos son enteros de 16 bits, pero el resultado matemático puede requerir hasta 32 bits. Por ejemplo:

$$ 0.5\times0.25=0.125 $$

Los valores codificados son:

$$ 0.5=16384 $$ $$ 0.25=8192 $$

Entonces:

$$ 16384\times8192=134217728 $$

Como el producto contiene el doble de bits fraccionarios, es necesario realizar un ajuste mediante desplazamiento para regresar al formato Q15. Conceptualmente:

$$ Q15_{resultado}=\frac{Q15_A\times Q15_B}{2^{15}} $$

En Q31 ocurre un proceso similar, aunque el producto puede requerir hasta 64 bits antes de regresar a un resultado de 32 bits. Las implementaciones ARM deben manejar cuidadosamente los desplazamientos y la saturación para evitar pérdida excesiva de precisión u desbordamiento. La documentación de Arm muestra que las operaciones de multiplicación Q15 y Q31 pueden utilizar resultados ampliados y mecanismos de saturación.

Una ventaja importante de Q31 sobre Q15 es su mayor precisión . Q15 solamente dispone de 15 bits fraccionarios, mientras que Q31 dispone de 31. Esto significa que Q31 puede representar cambios mucho más pequeños entre valores consecutivos. Sin embargo, Q31 utiliza el doble de memoria para muestra y algunas operaciones pueden requerir más procesamiento. Por esta razón, la elección depende de los requisitos de la aplicación.

En DSP, Q15 puede resultar conveniente cuando se procesan grandes cantidades de muestras y se busca reducir el consumo de memoria. Q31 es preferible cuando la precisión numérica es más importante. Un ejemplo es el procesamiento de señales de audio o algoritmos donde pequeños errores acumulados pueden afectar significativamente el resultado. Arm incluso casos documentados en los que Q15 no proporciona suficiente precisión para determinados cálculos de energía y se utiliza Q31 para mejorar la exactitud.

Uso en microcontroladores ARM

El ecosistema ARM proporciona la biblioteca CMSIS-DSP , que contiene funciones optimizadas para el procesamiento digital de señales en procesadores Cortex-M y Cortex-A. Esta biblioteca incluye operaciones matemáticas, filtros FIR e IIR, transformadas, operaciones matriciales, complejo de procesamiento y otras herramientas DSP.

CMSIS-DSP incluye funciones específicas para Q15 y Q31, así como conversiones entre diferentes formatos. Por ejemplo, existen funciones para convertir señales Q15 a Q31 y viceversa. Esto permite que una aplicación utilice Q15 para almacenar señales y posteriormente convertir los datos a Q31 cuando necesite mayor precisión.

Un ejemplo típico es un filtro FIR. En un filtro FIR se realizan múltiples multiplicaciones y acumulaciones:

$$ y[n]=\sum_{k=0}^{N-1}h[k]x[n-k] $$

donde\(x[n]\)representa las muestras de entrada y\(h[k]\)representan los coeficientes del filtro. Cuando se implementa en punto fijo, tanto las muestras como los coeficientes pueden almacenarse en Q15 o Q31. Sin embargo, las múltiples acumulaciones pueden producir valores mayores que el rango disponible, por lo que es necesario considerar escalamiento y saturación. La documentación de CMSIS-DSP advierte precisamente sobre el riesgo de desbordamiento en operaciones como convolución cuando se acumulan numerosos productos.

Los microcontroladores ARM Cortex-M también pueden contar con instrucciones especializadas para DSP. Por ejemplo, el Cortex-M4 incluye instrucciones relacionadas con conversiones entre punto flotante y punto fijo, permitiendo especificar el número de bits fraccionarios.Esto facilita la implementación de algoritmos que combinan datos enteros y operaciones de punto fijo.

Otra consideración importante es el redondeo . Al convertir un número flotante a Q15 o Q31, el resultado debe aproximarse al entero disponible. CMSIS-DSP contempla conversiones y mecanismos de redondeo para reducir el error de cuantización. En una conversión Q15, por ejemplo, un valor flotante se multiplica por 32768 y posteriormente se almacena como entero de 16 bits, aplicando saturación cuando sea necesario.

En términos generales, el flujo de trabajo de una aplicación DSP con punto fijo puede ser:

Señal real → escalamiento → conversión a Q15/Q31 → procesamiento DSP → saturación/redondeo → conversión a formato de salida.

La selección entre Q15 y Q31 debe realizarse considerando precisión, rango, memoria, velocidad de procesamiento y riesgo de desbordamiento. Q15 es atractivo para aplicaciones con recursos limitados, mientras que Q31 ofrece mayor resolución y es apropiado para algoritmos que requieren una representación numérica más precisa.

Conclusiones

La aritmética de punto fijo constituye una herramienta fundamental para implementar algoritmos DSP de manera eficiente en microcontroladores ARM. Los formatos Q15 y Q31 permiten representar números fraccionarios mediante enteros, evitando en muchas aplicaciones el costo computacional asociado con las operaciones de punto flotante.

Q15 utiliza 16 bits y proporciona un buen equilibrio entre precisión, velocidad y consumo de memoria, mientras que Q31 utiliza 32 bits y proporciona una resolución considerablemente mayor. La principal dificultad de ambos formatos consiste en controlar correctamente el escalamiento, los desplazamientos, el redondeo y la saturación para evitar errores numéricos y desbordamientos.

En aplicaciones como filtros digitales, procesamiento de audio, control de motores y análisis de señales, el uso de CMSIS-DSP facilita considerablemente la implementación de estas técnicas al proporcionar funciones optimizadas para procesadores ARM. Por ello, comprender Q15 y Q31 es importante para desarrollar sistemas embebidos capaces de realizar procesamiento de señales en tiempo real con recursos limitados.

Bibliografía — formato IEEE

[1] Arm, “CMSIS-DSP: tipos de datos de punto fijo”, Arm Software , 2026.Documentación oficial CMSIS-DSP

[2] Arm, “Biblioteca de software CMSIS-DSP”, Arm Software , 2026.Documentación oficial CMSIS-DSP

[3] Arm, “Guía de usuario genérica de dispositivos Cortex-M4”, Arm Limited .Guía del usuario genérica de los dispositivos Cortex-M4

[4] Arm, “Escriba la implementación CMSIS-DSP Q15”, Arm Learning Paths , 2026.Rutas de aprendizaje de ARM — CMSIS-DSP Q15

[5] Arm, “CMSIS-DSP: Convolución”, Arm Software , 2026.CMSIS-DSP — Convolución

[6] Arm, “Implementación de punto fijo CMSIS-DSP”, GitHub — ARM-software/CMSIS-DSP , 2026.Repositorio oficial CMSIS-DSP

[7] Nuvoton Technology Corporation, “¿Por qué el DSP necesita el formato Q? ¿Qué significan q31, q15, q7 y f32?”, Soporte técnico de Nuvoton , 2016.Preguntas frecuentes técnicas de Nuvoton

[8] Arm, “CMSIS-DSP 1.17.1”, Arm Keil Packs , julio de 2026.Paquete Arm CMSIS-DSP
