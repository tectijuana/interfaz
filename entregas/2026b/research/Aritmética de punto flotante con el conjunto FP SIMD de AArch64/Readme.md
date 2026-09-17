# Aritmética de Punto Flotante con el Conjunto FP/SIMD en AArch64

**Alumno:** Ballesteros Cruz Aldo Juventino.

**Matricula:** 23211920.

**Carrera:** Ingeniería en Sistemas Computacionales.

**Materia:** Programación Lógica y Funcional.

**Docente:** Rene Solis Reyes.

---

## Introducción: ¿Qué es la aritmética de punto flotante y cómo funciona en AArch64?


La **aritmética de punto flotante** es una forma de representar y realizar operaciones con números reales dentro de los sistemas informáticos. Este tipo de representación permite trabajar con valores que contienen partes fraccionarias y con números que pueden tener magnitudes muy grandes o muy pequeñas.

El término "punto flotante" hace referencia a que la posición del punto decimal puede variar dentro del número. Esto permite representar un rango amplio de valores utilizando una cantidad limitada de bits.

Los números de punto flotante son esenciales en informática debido a que una gran cantidad de aplicaciones científicas, de ingeniería, gráficas y financieras necesitan trabajar con valores que no necesariamente son números enteros.

En arquitecturas modernas como **AArch64**, estas operaciones pueden realizarse mediante el conjunto de instrucciones **FP/SIMD**, que permite tanto realizar operaciones escalares de punto flotante como procesar múltiples datos simultáneamente mediante SIMD.

---

## Desarrollo: Representación de números de punto flotante

La idea general de la representación de punto flotante consiste en dividir un número en diferentes componentes.

Las partes principales son:

* **Mantisa:** contiene los dígitos significativos del número.
* **Exponente:** determina la posición del punto decimal respecto a la mantisa.

En los sistemas informáticos, los números de punto flotante normalmente se representan utilizando **base 2**, es decir, mediante el sistema binario.

Por ejemplo, el número decimal:

```text
0.125
```

puede representarse en binario como:

```text
0.001
```

La representación binaria permite que el hardware pueda realizar operaciones aritméticas utilizando los circuitos digitales del procesador.

Los números de punto flotante también pueden representarse conceptualmente mediante una notación similar a la notación científica, utilizando una parte significativa y un exponente.

---

## ¿Qué es AArch64?


**AArch64** es el estado de ejecución de 64 bits de la arquitectura **ARMv8-A** y de arquitecturas ARM posteriores.

Esta arquitectura proporciona un conjunto de instrucciones de 64 bits, registros más grandes, direccionamiento de memoria mejorado, características de seguridad y mejoras de rendimiento respecto al estado de ejecución AArch32.

AArch64 se encuentra principalmente en procesadores de la familia **ARM Cortex-A**, utilizados en sistemas operativos como Linux, Android y Windows para ARM, además de diferentes plataformas integradas.

### Características principales de AArch64

* **Ejecución de instrucciones de 64 bits.**
* **Registros de 64 bits.**
* **Instrucciones de longitud fija de 32 bits.**
* **Espacio de direcciones virtuales más grande.**
* **Mejora del manejo de excepciones.**
* **Mejor rendimiento de punto flotante.**
* **Soporte avanzado de SIMD mediante NEON.**
* **Funciones de seguridad mejoradas.**

---

## Procesadores ARM que soportan AArch64

Diversos procesadores basados en **ARMv8-A** y **ARMv9-A** son compatibles con AArch64.

Algunos ejemplos son:

* Cortex-A53.
* Cortex-A55.
* Cortex-A57.
* Cortex-A72.
* Cortex-A73.
* Cortex-A76.
* Serie Cortex-X.
* Serie Neoverse.
* Apple M1, M2, M3 y procesadores posteriores.

---

## ¿Qué es SIMD?

**SIMD** (*Single Instruction, Multiple Data*) es una técnica de procesamiento paralelo que permite realizar una misma operación sobre múltiples elementos de datos mediante una sola instrucción.

En lugar de procesar cada dato de forma individual y secuencial, SIMD permite trabajar con varios datos simultáneamente.

Por ejemplo, si tenemos cuatro valores:

```text
A = [1, 2, 3, 4]
B = [5, 6, 7, 8]
```

una operación vectorial puede realizar las cuatro sumas al mismo tiempo:

```text
A + B = [6, 8, 10, 12]
```

Esto permite aprovechar el **paralelismo a nivel de datos** y puede mejorar el rendimiento en aplicaciones que realizan grandes cantidades de operaciones similares.

### Características principales de SIMD

* **Paralelismo de datos.**
* **Instrucciones SIMD.**
* **Unidades de procesamiento SIMD.**
* **Procesamiento de múltiples elementos simultáneamente.**
* **Aplicaciones en gráficos, procesamiento multimedia y cálculos científicos.**

En resumen, SIMD permite aprovechar el paralelismo a nivel de datos para realizar determinadas operaciones de manera más eficiente.

---

## Conjunto FP/SIMD en AArch64

En AArch64, la unidad **FP/SIMD** utiliza un banco de **32 registros de 128 bits**, denominados **V0-V31**.

Estos registros pueden utilizarse de diferentes maneras dependiendo de la precisión y del modo de operación.

| Sufijo |   Tamaño | Precisión         | Uso típico                                     |
| ------ | -------: | ----------------- | ---------------------------------------------- |
| `B`    |   8 bits | Byte              | Enteros pequeños                               |
| `H`    |  16 bits | Media precisión   | Audio y aplicaciones de aprendizaje automático |
| `S`    |  32 bits | Simple precisión  | Gráficos y videojuegos                         |
| `D`    |  64 bits | Doble precisión   | Cálculo científico                             |
| `Q`    | 128 bits | Registro completo | Operaciones SIMD                               |

Esta flexibilidad permite seleccionar el nivel de precisión adecuado dependiendo de las necesidades de la aplicación.

Por ejemplo, los gráficos 3D pueden utilizar valores de **32 bits** para realizar operaciones de manera eficiente, mientras que determinadas aplicaciones científicas requieren **64 bits** para obtener una mayor precisión.

---

## Modos de operación

El conjunto FP/SIMD de AArch64 puede utilizarse principalmente mediante dos formas de operación:

### Modo escalar

En el **modo escalar**, una instrucción trabaja con un solo valor de punto flotante.

Por ejemplo:

```text
FADD S0, S1, S2
```

Esta instrucción realiza una suma entre valores almacenados en registros de precisión simple.

### Modo vectorial

En el **modo vectorial**, una instrucción puede operar sobre varios valores almacenados dentro de un registro SIMD.

Por ejemplo:

```text
FADD V0.4S, V1.4S, V2.4S
```

En este caso, la operación se realiza sobre cuatro elementos de 32 bits simultáneamente.

---

## Instrucciones FP escalares

| Instrucción | Descripción          | Ejemplo           |
| ----------- | -------------------- | ----------------- |
| `FADD`      | Suma                 | `FADD S0, S1, S2` |
| `FSUB`      | Resta                | `FSUB S0, S1, S2` |
| `FMUL`      | Multiplicación       | `FMUL S0, S1, S2` |
| `FDIV`      | División             | `FDIV S0, S1, S2` |
| `FMLA`      | Multiplicar-acumular | `FMLA S0, S1, S2` |
| `FSQRT`     | Raíz cuadrada        | `FSQRT S0, S1`    |
| `FCMP`      | Comparación          | `FCMP S0, S1`     |
| `SCVTF`     | Entero → Flotante    | `SCVTF S0, W0`    |
| `FCVTZS`    | Flotante → Entero    | `FCVTZS W0, S0`   |

Estas instrucciones permiten realizar operaciones aritméticas y conversiones entre valores enteros y de punto flotante.

---

## Instrucciones SIMD vectoriales

| Instrucción | Descripción                    | Ejemplo                    |
| ----------- | ------------------------------ | -------------------------- |
| `LD1`       | Carga vectorial                | `LD1 {V0.4S}, [X0]`        |
| `ST1`       | Almacenamiento vectorial       | `ST1 {V0.4S}, [X0]`        |
| `FADD`      | Suma vectorial                 | `FADD V0.4S, V1.4S, V2.4S` |
| `FMUL`      | Multiplicación vectorial       | `FMUL V0.4S, V1.4S, V2.4S` |
| `FMLA`      | Multiplicar-acumular vectorial | `FMLA V0.4S, V1.4S, V2.4S` |
| `FADDV`     | Reducción horizontal           | `FADDV S0, V0.4S`          |

Las instrucciones vectoriales permiten aprovechar los registros V0-V31 para trabajar con varios elementos al mismo tiempo.

---

## Modos de redondeo

Las operaciones de punto flotante pueden requerir redondeo cuando el resultado exacto no puede representarse completamente con la precisión disponible.

Entre los modos de redondeo se encuentran:

* **Redondeo al más cercano:** es el modo utilizado de forma predeterminada.
* **Redondeo hacia cero:** el resultado se aproxima hacia cero.
* **Redondeo hacia +infinito:** el resultado se aproxima hacia el infinito positivo.
* **Redondeo hacia -infinito:** el resultado se aproxima hacia el infinito negativo.

Los modos de redondeo pueden ser importantes en aplicaciones científicas y numéricas, donde pequeñas diferencias en los resultados pueden acumularse durante una gran cantidad de operaciones.

---

## Relación entre punto flotante y SIMD

El conjunto **FP/SIMD** combina dos capacidades importantes.

Por un lado, permite realizar operaciones de **punto flotante** con diferentes niveles de precisión. Por otro, mediante SIMD permite aplicar una misma operación sobre varios datos de forma simultánea.

La diferencia puede observarse de la siguiente manera:

```text
Modo escalar

S1 ─────┐
        ├── FADD ──> S0
S2 ─────┘


Modo vectorial

V1.4S ─────┐
            ├── FADD ──> V0.4S
V2.4S ─────┘

   4 operaciones simultáneas
```

De esta manera, una aplicación que realiza repetidamente la misma operación sobre grandes cantidades de datos puede aprovechar el procesamiento vectorial para mejorar su rendimiento.

---

## Aplicaciones del conjunto FP/SIMD

Las operaciones de punto flotante y SIMD pueden ser utilizadas en diferentes áreas donde se requiere procesar grandes cantidades de datos.

Algunos ejemplos son:

* **Gráficos 2D y 3D.**
* **Videojuegos.**
* **Procesamiento de imágenes.**
* **Procesamiento de audio y video.**
* **Cálculos científicos.**
* **Simulaciones.**
* **Aplicaciones de aprendizaje automático.**
* **Procesamiento de señales.**

El beneficio de SIMD depende del tipo de algoritmo utilizado. Los algoritmos que realizan operaciones independientes sobre múltiples elementos pueden aprovechar mejor este tipo de procesamiento.

---

## Conclusiones personales

Aprender cómo funciona la **aritmética de punto flotante y las extensiones SIMD en AArch64** permite comprender mejor cómo los procesadores modernos realizan operaciones numéricas de manera eficiente.

Me pareció interesante comprender la diferencia entre el **modo escalar y el modo vectorial**, ya que permite observar cómo una misma operación puede realizarse sobre un solo dato o sobre varios datos simultáneamente.

También resulta importante conocer los registros especializados **V0-V31** y las diferentes formas en que pueden utilizarse dependiendo de la precisión requerida. Esto permite entender mejor cómo se pueden optimizar determinadas aplicaciones de alto rendimiento.

Además, los diferentes **modos de redondeo** muestran que la representación de números de punto flotante no siempre produce resultados exactos, por lo que es importante considerar la precisión utilizada en aplicaciones científicas y numéricas.

Finalmente, aunque SIMD puede proporcionar ventajas importantes de rendimiento, no todos los algoritmos pueden vectorizarse de manera eficiente. Por esta razón, es necesario evaluar si una optimización manual es conveniente o si el compilador puede realizarla automáticamente.

---

## Referencias

[1] Indian Institute of Embedded Systems, "What is AArch64? Architecture, register set, features & ARM64 explained," IIES, Sep. 5, 2024. [En línea]. Disponible en: https://iies.in/blog/aarch64-a-deep-dive-into-its-architecture-and-design/. [Consultado: 16-sep-2026].

[2] "SIMD: definición y características," Studocu. [En línea]. Disponible en: https://www.studocu.com/es-mx/messages/question/5049955/simd-definicion-y-caracteristicas. [Consultado: 16-sep-2026].
