# Vectorización con NEON: Procesamiento de Datos en Paralelo

## Nombre: Barraza Sánchez Luz del Carmen

## Introducción

En el contexto de la computación de alto rendimiento, el procesamiento de señales digitales (DSP), la visión por computadora y el aprendizaje profundo (*Deep Learning*), la capacidad de ejecutar operaciones de manera paralela a nivel de instrucción es fundamental para maximizar la eficiencia energética y el rendimiento del hardware. La computación de Tipo Instrucción Única, Múltiples Datos (SIMD, por sus siglas en inglés *Single Instruction, Multiple Data*) permite aplicar una misma operación aritmética o lógica sobre un conjunto de datos agrupados en vectores, reduciendo significativamente la latencia y la sobrecarga del bucle de instrucciones (*loop overhead*).

En la arquitectura de procesadores ARM, la extensión SIMD avanzada de mayor relevancia es **ARM NEON**, la cual ha evolucionado sustancialmente desde sus orígenes en ARMv7 (AArch32) hasta su consolidación en ARMv8/v9 (AArch64). Simultáneamente, el surgimiento del conjunto de instrucciones abierto RISC-V ha introducido la Extensión Vectorial de RISC-V (RVV), planteando un paradigma alternativo de longitud vectorial variable frente a la longitud fija de NEON. El presente ensayo examina la arquitectura y los mecanismos de vectorización con NEON en entornos AArch32 y AArch64, analiza sus ventajas de procesamiento en paralelo y contrapone su diseño frente a la propuesta de RISC-V.

---

## Desarrollo Técnico

### 1. Fundamentos de la Arquitectura ARM NEON (AArch32 vs. AArch64)

La tecnología ARM NEON es un motor SIMD de 128 bits diseñado para acelerar la multimedia y el procesamiento numérico. Opera con registros vectoriales que pueden subdividirse en carril de datos (*lanes*) de diversos tamaños: enteros de 8, 16, 32 o 64 bits, y números de punto flotante de precisión simple (32 bits) o doble (64 bits, introducido plenamente en AArch64).

#### AArch32 (ARMv7-A / AArch32)
En arquitecturas de 32 bits, el banco de registros de NEON está estrechamente acoplado con la unidad VFP (*Vector Floating-Point*). Consta de:
* **32 registros de 64 bits (`D0` - `D31`)**, o alternativamente,
* **16 registros de 128 bits (`Q0` - `Q15`)**, donde cada registro `Q` sobrepone exactamente un par de registros `D` (por ejemplo, `Q0` comprende `D0` y `D1`).

La sintaxis en 32 bits exige la especificación explícita de los tipos de datos en la mnemónica de la instrucción (por ejemplo, `VADD.I32 q0, q1, q2`).

#### AArch64 (ARMv8-A en adelante)
En el estado de ejecución de 64 bits (AArch64), el modelo de registros fue completamente reestructurado para eliminar la superposición confusa de AArch32:
* Se dispone de **32 registros independientes de 128 bits (`V0` a `V31`)**.
* Los registros se pueden direccionar como escalares de 8/16/32/64/128 bits (`B`, `H`, `S`, `D`, `Q`) o como vectores con formato de carril explícito (p. ej., `v0.4s` representa un registro de 128 bits visto como 4 elementos enteros de 32 bits).

```
Estructura de Registros NEON en AArch64 (Registro V0 de 128 bits):
+---------------------------------------------------------------+
|                        V0 (128 bits)                          |
+-----------------------+-----------------------+---------------+
|     v0.2d (2 x 64b)   |     v0.2d (2 x 64b)   |  (Double)     |
+-----------+-----------+-----------+-----------+---------------+
|  v0.4s    |  v0.4s    |  v0.4s    |  v0.4s    |  (Single 32b) |
+-----+-----+-----+-----+-----+-----+-----+-----+---------------+
|v0.8h|v0.8h|v0.8h|v0.8h|v0.8h|v0.8h|v0.8h|v0.8h|  (Half 16b)   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+---------------+
|B0|B1|B2|B3|B4|B5|B6|B7|B8|B9|B10|B11|B12|B13|B14|B15| (Byte 8b) |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+---------------+
```

---

### 2. Procesamiento de Datos en Paralelo e Intrísecos C/C++

Existen tres métodos para aprovechar la vectorización con NEON:
1. **Auto-vectorización del compilador:** El compilador (GCC o Clang) detecta bucles independientes y genera instrucciones NEON automáticamente (`-O3 -mfpu=neon` en ARM32 o `-O3` en ARM64).
2. **Ensamblador directo:** Escritura manual de código `.s` para un control fino sobre el despliegue del bucle y la tubería de ejecución (*pipeline*).
3. **Intrínsecos de NEON (`<arm_neon.h>`):** Funciones especiales codificadas en C/C++ que el compilador mapea directamente a instrucciones SIMD, ofreciendo equilibrio entre control de hardware y portabilidad del código.

#### Ejemplo de Algoritmo de Suma Vectorial en AArch64 (Intrínsecos)

Consideremos el procesamiento en paralelo de dos arreglos de enteros de 32 bits:

```c
#include <arm_neon.h>

void suma_vectorial_neon(const int32_t *a, const int32_t *b, int32_t *c, int n) {
    int i = 0;
    // Procesamiento vectorizado: 4 elementos por iteración (128 bits / 32 bits)
    for (; i <= n - 4; i += 4) {
        int32x4_t va = vld1q_s32(&a[i]); // Carga 4 enteros de 32 bits en registro V
        int32x4_t vb = vld1q_s32(&b[i]); // Carga 4 enteros de 32 bits en registro V
        int32x4_t vc = vaddq_s32(va, vb); // Suma SIMD en paralelo
        vst1q_s32(&c[i], vc);           // Almacena el resultado
    }
    // Bucle remanente para los elementos sobrantes (procesamiento escalar)
    for (; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}
```

Al compilar este fragmento para AArch64, el núcleo del bucle genera instrucciones limpias como:
`LD1 {v0.4s}, [x0], #16`
`LD1 {v1.4s}, [x1], #16`
`ADD v2.4s, v0.4s, v1.4s`
`ST1 {v2.4s}, [x2], #16`

Este flujo reduce en un factor de 4 las instrucciones de control del bucle y aprovecha la ejecución paralela en las unidades funcionales del procesador.

---

### 3. Diagrama de Flujo del Procesamiento Paralelo con NEON

El siguiente esquema ilustra cómo un flujo de datos continuo es procesado en paralelo a través del registro vectorial de 128 bits mediante la técnica de empacado (*data packing*).

```mermaid
graph TD
    subgraph Memoria RAM / Caché
        MemA[Vector A: A3 | A2 | A1 | A0]
        MemB[Vector B: B3 | B2 | B3 | B0]
    end

    subgraph Registros Vectoriales ARM NEON (128-bit)
        RegV0["Registro V0.4S (va)\n[ A3 | A2 | A1 | A0 ]"]
        RegV1["Registro V1.4S (vb)\n[ B3 | B2 | B1 | B0 ]"]
    end

    subgraph Unidad Aritmético Lógica SIMD (ALU)
        ALU0["ALU Lane 0: A0 + B0"]
        ALU1["ALU Lane 1: A1 + B1"]
        ALU2["ALU Lane 2: A2 + B2"]
        ALU3["ALU Lane 3: A3 + B3"]
    end

    subgraph Registro Resultado
        RegV2["Registro V2.4S (vc)\n[ R3 | R2 | R1 | R0 ]"]
    end

    MemA -->|vld1q_s32| RegV0
    MemB -->|vld1q_s32| RegV1

    RegV0 --- ALU0
    RegV0 --- ALU1
    RegV0 --- ALU2
    RegV0 --- ALU3

    RegV1 --- ALU0
    RegV1 --- ALU1
    RegV1 --- ALU2
    RegV1 --- ALU3

    ALU0 --> RegV2
    ALU1 --> RegV2
    ALU2 --> RegV2
    ALU3 --> RegV2
```

---

### 4. Análisis Comparativo: ARM NEON vs. RISC-V Vector Extension (RVV)

Aunque ARM NEON domina la informática móvil y embebida actual, el modelo de SIMD fija enfrenta limitaciones frente a arquitecturas vectoriales agnósticas a la longitud como la Extensión Vectorial de RISC-V (**RVV**).

| Característica | ARM NEON (AArch32 / AArch64) | RISC-V Vector Extension (RVV) |
| :--- | :--- | :--- |
| **Paradigma** | SIMD de Ancho Fijo (Fixed-width SIMD) | Computación Vectorial Pura (Vector-length agnostic) |
| **Tamaño de Registro** | Fijo: 64/128 bits (128 bits nativo en AArch64) | Variable según implementación hardware ($VLEN$, ej. 128, 256, 512, 1024+ bits) |
| **Control de Longitud** | Hardcodeado en la instrucción o plantilla | Dinámico vía registro de configuración de longitud `setvl` / `vsetvli` |
| **Tratamiento de Remanentes** | Bucle escalar secundario o máscaras explícitas | Manejo implícito configurando la longitud del vector ($vlen$) |
| **Evolución en ARM** | Evolucionó hacia **SVE/SVE2** (Scalable Vector Extension) | Diseñado desde el origen como arquitectura escalar/vectorial flexible |

#### Diferencia Filosófica de Diseño:
* **ARM NEON:** Si se requiere escalar el hardware a registros más anchos (por ejemplo, 256 o 512 bits), la arquitectura debe modificar el ISA o migrar a **SVE** (*Scalable Vector Extension*). El código recompilado para NEON de 128 bits no aprovecha automáticamente los 256 bits sin reescritura o re-compilación.
* **RISC-V RVV:** Un mismo archivo binario puede ejecutarse en un microcontrolador IoT con $VLEN=128$ bits o en un supercomputador con $VLEN=2048$ bits. El código lee la longitud vectorial soportada en tiempo de ejecución y adapta el procesamiento sin necesidad de bucles de limpieza para el remanente (*tail handling*).

---

## Conclusiones

La tecnología **ARM NEON** se ha consolidado como un componente indispensable para lograr un procesamiento paralelo eficiente en dispositivos móviles, de borde y centros de datos equipados con arquitecturas ARM32 y ARM64. Su integración de registros de 128 bits permite multiplicar el rendimiento sintético en algoritmos matriciales, procesado de audio/video y kernels de redes neuronales, manteniendo una excelente relación de consumo energético por vatio.

Por otro lado, la evolución hacia arquitecturas emergentes pone de manifiesto que los esquemas SIMD de ancho fijo como NEON están cediendo terreno ante conceptos vectoriales escalables. Mientras que ARM responde a esta necesidad en servidores de alto rendimiento con **SVE/SVE2**, la arquitectura abierta **RISC-V (RVV)** demuestra la elegancia teórica y práctica de desvincular el código ejecutable de la longitud física de los registros. No obstante, en el panorama industrial actual, la madurez del ecosistema de herramientas, bibliotecas optimizadas y soporte en compiladores consolida a ARM NEON como la solución de vectorización de mayor impacto y despliegue en el mercado actual.

---

## Bibliografía

1. ARM Limited, "ARM Cortex-A Series Programmer's Guide for ARMv8-A," *ARM Documentation*, Doc. ID: DEN0024A, 2015.
2. ARM Limited, "ARM Neon Intrinsics Reference," *Developer Documentation*, [En línea]. Disponible en: https://developer.arm.com/architectures/instruction-sets/simd-isas/neon.
3. RISC-V International, "RISC-V Vector Extension Specification," Version 1.0, Nov. 2021.
4. D. Patterson y J. L. Hennessy, *Computer Organization and Design ARM Edition: The Hardware Software Interface*, Morgan Kaufmann, 2016.
5. A. Waterman y K. Asanović, "The RISC-V Instruction Set Manual, Volume I: Unprivileged ISA," *RISC-V Foundation*, Doc. Version 20191213, 2019.
