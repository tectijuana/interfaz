# ARITMÉTICA DE PUNTO FIJO Q15 Y Q31 PARA EL PROCESAMIENTO DIGITAL DE SEÑALES EN MICROCONTROLADORES ARM


Autor: [CARRERA AGUIRRE JOEL]
Institución: [INSTITUTO TECNOLOGICO DE TIJUANA]
Curso: [LENGUAJES DE INTERFAZ]
Fecha: Septiembre de 2026

## I. INTRODUCCIÓN

El procesamiento digital de señales (DSP, *Digital Signal Processing*) constituye un área fundamental de la ingeniería electrónica y de sistemas embebidos, debido a su aplicación en campos como las telecomunicaciones, el procesamiento de audio, los sistemas de control, la instrumentación electrónica, el procesamiento biomédico y la automatización industrial. La implementación de algoritmos DSP en microcontroladores exige efectuar operaciones aritméticas de manera eficiente, manteniendo simultáneamente niveles adecuados de precisión, velocidad de procesamiento y consumo de recursos.

Una de las decisiones fundamentales durante el diseño de un sistema DSP embebido corresponde a la selección del formato numérico empleado para representar las señales y los coeficientes de los algoritmos. Las dos alternativas principales son la aritmética de punto flotante y la aritmética de punto fijo. Aunque el punto flotante proporciona un amplio rango dinámico y simplifica considerablemente el desarrollo de algoritmos matemáticos, la representación de punto fijo puede ofrecer ventajas significativas en sistemas con restricciones de memoria, procesamiento y consumo energético.

Los microcontroladores basados en la arquitectura ARM Cortex-M son ampliamente utilizados en aplicaciones embebidas debido a su bajo consumo energético, reducido costo y capacidades de procesamiento. Dentro de este entorno, la biblioteca CMSIS-DSP proporciona funciones optimizadas para la ejecución de algoritmos de procesamiento digital de señales mediante diferentes formatos numéricos, entre ellos Q15 y Q31 [1].

Los formatos Q15 y Q31 corresponden a representaciones de punto fijo orientadas principalmente al procesamiento de valores fraccionarios. Q15 emplea una palabra de 16 bits, mientras que Q31 emplea una palabra de 32 bits. Ambos permiten representar valores normalizados aproximadamente dentro del intervalo \([-1,1)\), pero presentan diferencias importantes en términos de resolución, consumo de memoria, precisión y comportamiento durante las operaciones aritméticas.

El propósito de este trabajo es analizar formalmente los fundamentos de la aritmética de punto fijo Q15 y Q31, describir sus principales características matemáticas y estudiar su aplicación en algoritmos DSP ejecutados sobre microcontroladores ARM. Asimismo, se analizan aspectos fundamentales como la cuantización, el error numérico, el overflow, la saturación, el escalamiento y la utilización de acumuladores de mayor precisión.

---

## II. DESARROLLO TÉCNICO

### A. Fundamentos de la representación de punto fijo

La representación de punto fijo permite expresar números reales mediante números enteros utilizando un factor de escala previamente establecido. A diferencia del punto flotante, donde la posición del punto binario puede variar, en el punto fijo dicha posición permanece constante durante la representación.

Si un número entero \(X\) dispone de \(F\) bits destinados a representar la parte fraccionaria, su equivalente real puede expresarse como:

$$
x=\frac{X}{2^F}
$$

donde \(x\) representa el valor real y \(X\) corresponde al valor entero almacenado en memoria.

Esta metodología permite que un microcontrolador realice operaciones utilizando instrucciones enteras convencionales. La interpretación del resultado como número fraccionario depende exclusivamente de la escala establecida.

En aplicaciones DSP, esta característica resulta particularmente importante debido a que una gran cantidad de algoritmos se basa en operaciones de multiplicación y acumulación. Si la escala se determina correctamente, es posible ejecutar dichos algoritmos empleando recursos computacionales relativamente reducidos.

---

### B. Representación Q15

El formato Q15 utiliza una palabra de 16 bits y normalmente se interpreta como un formato de signo con 15 bits fraccionarios. Su representación matemática es:

$$
x=\frac{X}{2^{15}}
$$

Por consiguiente, el intervalo representable es aproximadamente:

$$
-1\leq x<1
$$

La resolución correspondiente es:

$$
\Delta_{Q15}=2^{-15}
$$

es decir:

$$
\Delta_{Q15}=\frac{1}{32768}\approx3.05176\times10^{-5}
$$

El valor entero mínimo es \(-32768\), mientras que el máximo es \(32767\). Por ejemplo, para representar el valor \(0.5\), se obtiene:

$$
X=0.5\times32768=16384
$$

Por lo tanto:

$$
0.5_{Q15}=16384_{10}=0x4000
$$

De manera similar, un valor de \(0.25\) se representa mediante:

$$
0.25\times32768=8192
$$

Por tanto:

$$
0.25_{Q15}=8192
$$

La representación Q15 resulta apropiada para señales normalizadas debido a su relación entre resolución y consumo de memoria. Cada muestra requiere solamente 16 bits, lo que permite reducir significativamente el almacenamiento requerido cuando se procesan grandes cantidades de datos.

---

### C. Representación Q31

El formato Q31 utiliza una palabra de 32 bits y dispone de 31 bits fraccionarios. Matemáticamente, puede expresarse como:

$$
x=\frac{X}{2^{31}}
$$

El rango representable es:

$$
-1\leq x<1
$$

y la resolución es:

$$
\Delta_{Q31}=2^{-31}
$$

por lo que:

$$
\Delta_{Q31}\approx4.65661\times10^{-10}
$$

Para representar \(0.5\), se obtiene:

$$
X=0.5\times2^{31}
$$

$$
X=1073741824
$$

En representación hexadecimal:

$$
0.5_{Q31}=0x40000000
$$

El incremento mínimo representable en Q31 es considerablemente menor que en Q15. Por esta razón, Q31 proporciona una precisión numérica superior y puede resultar adecuado para algoritmos DSP sensibles a los errores de cuantización.

No obstante, esta mayor precisión implica un consumo de memoria superior. Mientras que una muestra Q15 ocupa 2 bytes, una muestra Q31 requiere 4 bytes.

---

### D. Cuantización y error numérico

La conversión de un valor real a punto fijo se denomina cuantización. Para un número real \(x\), el valor entero cuantizado puede calcularse mediante:

$$
X=round(x2^F)
$$

El valor reconstruido se obtiene mediante:

$$
\hat{x}=\frac{X}{2^F}
$$

La diferencia entre el valor original y el valor reconstruido corresponde al error de cuantización:

$$
e=x-\hat{x}
$$

En una cuantización basada en redondeo, el error máximo ideal puede aproximarse mediante:

$$
|e_{max}|\leq\frac{1}{2}2^{-F}
$$

En consecuencia, para Q15:

$$
|e_{max}|\leq2^{-16}
$$

mientras que para Q31:

$$
|e_{max}|\leq2^{-32}
$$

Esto demuestra matemáticamente la mayor resolución de Q31. Sin embargo, la precisión final de un algoritmo no depende exclusivamente del formato utilizado. También deben considerarse el escalamiento, el redondeo, el truncamiento y los errores acumulativos producidos por las operaciones sucesivas.

---

### E. Operaciones de suma y saturación

La suma de dos números pertenecientes al mismo formato Q puede realizarse directamente sobre sus representaciones enteras. Por ejemplo:

$$
0.25+0.25=0.5
$$

En Q15:

$$
8192+8192=16384
$$

y:

$$
\frac{16384}{32768}=0.5
$$

Sin embargo, cuando el resultado excede el rango representable puede producirse un desbordamiento (*overflow*). Considérese:

$$
0.75+0.75=1.5
$$

El valor \(1.5\) no puede representarse en Q15 ni Q31 cuando se utiliza la representación fraccionaria normalizada.

Una estrategia habitual para evitar consecuencias no deseadas consiste en utilizar saturación. En lugar de permitir que el resultado experimente un desbordamiento circular, se limita al máximo o mínimo disponible.

Para Q15:

$$
X_{sat}=
\begin{cases}
32767,&X>32767\\
-32768,&X<-32768\\
X,&\text{en otro caso}
\end{cases}
$$

Para Q31:

$$
X_{sat}=
\begin{cases}
2147483647,&X>2147483647\\
-2147483648,&X<-2147483648\\
X,&\text{en otro caso}
\end{cases}
$$

La saturación resulta especialmente importante en DSP, ya que evita que una señal que supera ligeramente el rango permitido se convierta abruptamente en un valor de signo contrario.

---

### F. Multiplicación en Q15

La multiplicación requiere considerar la posición implícita del punto binario. Sean dos números Q15:

$$
x=\frac{X}{2^{15}}
$$

$$
y=\frac{Y}{2^{15}}
$$

El producto es:

$$
xy=\frac{XY}{2^{30}}
$$

Por lo tanto, el producto de dos valores Q15 genera inicialmente un resultado con 30 bits fraccionarios.

Para obtener nuevamente una representación Q15 es necesario realizar el escalamiento correspondiente:

$$
Z=\frac{XY}{2^{15}}
$$

Este proceso puede involucrar desplazamientos, redondeo y saturación. La implementación específica depende del algoritmo y de las funciones utilizadas.

CMSIS-DSP incorpora funciones optimizadas para trabajar con datos Q15 y contempla el manejo de los productos y acumulaciones intermedias [1], [2].

---

### G. Multiplicación en Q31

En Q31, dos números se representan como:

$$
x=\frac{X}{2^{31}}
$$

$$
y=\frac{Y}{2^{31}}
$$

Por lo tanto:

$$
xy=\frac{XY}{2^{62}}
$$

El producto completo requiere potencialmente 64 bits. Para regresar al formato Q31 es necesario realizar un desplazamiento de 31 posiciones:

$$
Z=\frac{XY}{2^{31}}
$$

La utilización de un resultado intermedio de mayor tamaño es importante para evitar pérdidas innecesarias de precisión. CMSIS-DSP implementa diferentes estrategias de acumulación y escalamiento para sus funciones Q31 [1], [2].

---

### H. Aplicación en filtros FIR

Una aplicación representativa de la aritmética de punto fijo corresponde a los filtros FIR (*Finite Impulse Response*). La ecuación de un filtro FIR de orden \(N-1\) es:

$$
y[n]=\sum_{k=0}^{N-1}b[k]x[n-k]
$$

donde \(x[n]\) representa la señal de entrada, \(b[k]\) los coeficientes del filtro y \(y[n]\) la señal de salida.

La ecuación requiere múltiples operaciones de multiplicación y acumulación, conocidas como operaciones MAC (*Multiply-Accumulate*). Debido a ello, los filtros FIR constituyen una aplicación especialmente adecuada para evaluar las ventajas y limitaciones de la aritmética Q15/Q31.

CMSIS-DSP proporciona las funciones `arm_fir_q15()` y `arm_fir_q31()` para la implementación de filtros FIR utilizando estas representaciones [2].

En la implementación Q15 estándar, los productos intermedios se generan con mayor precisión y posteriormente se realiza el escalamiento necesario para obtener la salida en formato Q15. El empleo de acumuladores de mayor tamaño permite disminuir el riesgo de overflow durante la suma de múltiples productos.

Las versiones rápidas de determinadas funciones reducen el costo computacional, pero requieren un análisis más cuidadoso del rango de entrada y del posible desbordamiento. Por ello, existe un compromiso entre precisión, velocidad y rango dinámico.

---

### I. Escalamiento y control del rango dinámico

El escalamiento es una técnica fundamental para implementar algoritmos de punto fijo correctamente. Antes de convertir un algoritmo de punto flotante a Q15 o Q31, debe determinarse el rango máximo esperado de cada señal y variable intermedia.

Para un filtro FIR, una estimación del máximo valor de salida puede expresarse como:

$$
|y[n]|\leq\sum_{k=0}^{N-1}|b[k]||x[n-k]|
$$

Si el resultado supera el rango permitido, es necesario modificar la escala de la señal o de los coeficientes.

Una estrategia consiste en utilizar un factor de escala:

$$
x_s[n]=x[n]2^{-S}
$$

donde \(S\) se selecciona de acuerdo con el rango máximo esperado.

El escalamiento incorrecto puede ocasionar dos situaciones opuestas. Si la escala es demasiado pequeña, se pierde precisión porque se utilizan pocos bits significativos. Si la escala es demasiado grande, puede producirse overflow. Por esta razón, el diseño de sistemas DSP de punto fijo requiere un análisis previo del rango dinámico.

---

### J. Comparación técnica entre Q15 y Q31

| Parámetro               |                      Q15 |                   Q31 |
| ----------------------- | -----------------------: | --------------------: |
| Longitud de palabra     |                  16 bits |               32 bits |
| Bits fraccionarios      |                       15 |                    31 |
| Rango normalizado       |               \([-1,1)\) |            \([-1,1)\) |
| Resolución              |              \(2^{-15}\) |           \(2^{-31}\) |
| Memoria por muestra     |                  2 bytes |               4 bytes |
| Precisión               |                 Moderada |                  Alta |
| Costo de almacenamiento |                     Bajo |                  Alto |
| Error de cuantización   |                    Mayor |                 Menor |
| Aplicaciones típicas    | Audio, filtros, sensores | DSP de alta precisión |

Q15 presenta una ventaja significativa en sistemas con restricciones de memoria. Además, puede ser especialmente conveniente cuando el error de cuantización introducido es suficientemente pequeño en relación con el ruido inherente de la aplicación.

Q31, por su parte, ofrece una mayor resolución y resulta apropiado cuando pequeñas variaciones de la señal deben conservarse durante múltiples operaciones. Su principal desventaja es el incremento en el consumo de memoria.

---

### K. Implementación mediante CMSIS-DSP

CMSIS-DSP constituye una biblioteca optimizada para procesadores Arm y proporciona funciones para diversas operaciones DSP. Su utilización permite reducir la necesidad de desarrollar rutinas aritméticas específicas para cada aplicación.

Un ejemplo básico de inicialización de un filtro FIR Q15 es:

```c
#include "arm_math.h"

#define NUM_TAPS 8
#define BLOCK_SIZE 32

q15_t coefficients[NUM_TAPS];
q15_t state[NUM_TAPS + BLOCK_SIZE - 1];

q15_t input[BLOCK_SIZE];
q15_t output[BLOCK_SIZE];

arm_fir_instance_q15 filter;

int main(void)
{
    arm_fir_init_q15(
        &filter,
        NUM_TAPS,
        coefficients,
        state,
        BLOCK_SIZE
    );

    while (1)
    {
        arm_fir_q15(
            &filter,
            input,
            output,
            BLOCK_SIZE
        );
    }
}
```

La función `arm_fir_init_q15()` configura la estructura necesaria para el filtro, mientras que `arm_fir_q15()` ejecuta el procesamiento de un bloque de muestras. Una estructura equivalente puede emplearse mediante las funciones Q31.

Este enfoque permite desarrollar aplicaciones DSP manteniendo una separación entre el algoritmo y las optimizaciones específicas de la arquitectura ARM.

---

## III. CONCLUSIONES

La aritmética de punto fijo constituye una metodología eficiente para la implementación de algoritmos de procesamiento digital de señales en microcontroladores ARM, particularmente en sistemas embebidos donde existen restricciones de memoria, procesamiento y consumo energético. Los formatos Q15 y Q31 permiten representar señales fraccionarias mediante números enteros, aprovechando las capacidades de procesamiento disponibles en diferentes arquitecturas ARM Cortex-M.

El formato Q15 utiliza 16 bits, de los cuales 15 corresponden a la parte fraccionaria, proporcionando una resolución de \(2^{-15}\). Su principal ventaja consiste en el reducido consumo de memoria, por lo que resulta apropiado para aplicaciones donde se procesan grandes cantidades de muestras y la precisión requerida es moderada.

Por otra parte, Q31 utiliza 32 bits y proporciona una resolución de \(2^{-31}\), considerablemente superior a la de Q15. Esta característica permite disminuir el error de cuantización y conservar mayor precisión durante las operaciones sucesivas. No obstante, requiere el doble de memoria por muestra y puede demandar operaciones intermedias de mayor tamaño.

Uno de los aspectos críticos en cualquier implementación de punto fijo corresponde al control del overflow. Las operaciones de multiplicación y acumulación pueden generar resultados que excedan el rango representable. En consecuencia, resulta necesario emplear técnicas de escalamiento, saturación y utilización de acumuladores apropiados.

La biblioteca CMSIS-DSP facilita la implementación de algoritmos Q15 y Q31 en microcontroladores ARM al proporcionar funciones optimizadas para filtros FIR, convolución, transformadas y operaciones matemáticas. Su utilización permite aprovechar las características de las arquitecturas ARM sin necesidad de desarrollar completamente las rutinas de bajo nivel.

En términos generales, Q15 constituye una alternativa adecuada cuando el ahorro de memoria y la eficiencia son factores prioritarios, mientras que Q31 debe considerarse cuando se requiere mayor precisión numérica. La selección definitiva debe realizarse mediante un análisis conjunto de los requisitos del algoritmo, el rango dinámico de las señales, la precisión necesaria, la memoria disponible y las características particulares del microcontrolador.

En consecuencia, la implementación correcta de DSP mediante punto fijo no consiste únicamente en seleccionar un formato numérico, sino en diseñar cuidadosamente la cadena completa de representación, cuantización, escalamiento, multiplicación, acumulación y saturación. Una adecuada planificación de estos elementos permite obtener sistemas DSP eficientes, deterministas y apropiados para aplicaciones embebidas en tiempo real.

---

## REFERENCIAS

[1] Arm Limited, “CMSIS-DSP: Fixed point datatypes,” *CMSIS-DSP Documentation*, 2026. [Online]. Available: https://arm-software.github.io/CMSIS-DSP/main/group__FIXED.html

[2] Arm Limited, “CMSIS-DSP: Finite Impulse Response (FIR) Filters,” *CMSIS-DSP Documentation*, 2026. [Online]. Available: https://arm-software.github.io/CMSIS-DSP/latest/group__FIR.html

[3] Arm Limited, “CMSIS-DSP,” *GitHub Repository*, 2026. [Online]. Available: https://github.com/ARM-software/CMSIS-DSP

[4] Arm Limited, “CMSIS-DSP: Basic Math Functions,” *CMSIS-DSP Documentation*, 2026. [Online]. Available: https://arm-software.github.io/CMSIS-DSP/latest/group__groupMath.html

[5] Arm Limited, “CMSIS-DSP: Convolution,” *CMSIS-DSP Documentation*, 2026. [Online]. Available: https://arm-software.github.io/CMSIS-DSP/latest/group__Conv.html

[6] Arm Limited, “CMSIS-Core,” *CMSIS Documentation*, 2026. [Online]. Available: https://arm-software.github.io/CMSIS_6/latest/Core/

[7] V. Zölzer, *Digital Audio Signal Processing*, 2nd ed. Chichester, U.K.: Wiley, 2008.

[8] R. Lyons, *Understanding Digital Signal Processing*, 3rd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2011.

[9] A. V. Oppenheim and R. W. Schafer, *Discrete-Time Signal Processing*, 3rd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2010.
