# Aritmética de punto fijo (Q15/Q31) para DSP en microcontroladores ARM

> **Autoría:** Claude Code (Anthropic, modelo Claude Sonnet 5.5), por encargo del docente.
> Documento unificado que sintetiza dos entregas del ciclo 2026b sobre el mismo tema.
> Ver `anexo.md` para la declaración de IA y la validación realizada.

## 1. Introducción

El procesamiento digital de señales (**DSP**, *Digital Signal Processing*) se usa en sistemas embebidos para filtrado de audio, procesamiento de sensores, control de motores, comunicaciones y transformadas de Fourier. En un microcontrolador estas operaciones suelen ejecutarse en tiempo real con memoria, cómputo y energía limitados.

Una alternativa al punto flotante es la **aritmética de punto fijo**: los números fraccionarios se guardan como enteros y se interpreta que una cantidad fija de bits es la parte fraccionaria. En microcontroladores ARM se usan sobre todo los formatos **Q15** y **Q31**. La biblioteca oficial **CMSIS-DSP** define `q15_t` (16 bits, formato 1.15) y `q31_t` (32 bits, formato 1.31), y ofrece filtros, operaciones matemáticas, transformadas y matrices optimizadas para Cortex-M y Cortex-A [1], [2].

## 2. Fundamentos del punto fijo

La posición del punto binario es implícita. Un entero $X$ con $F$ bits fraccionarios representa:

$$
x = \frac{X}{2^F}
$$

Ejemplo en Q15 ($F=15$) para $0.75$:

$$
X = 0.75 \times 2^{15} = 24576 = \texttt{0x6000}
$$

El procesador solo ve el entero 24576; el programa lo interpreta como 0.75. Así los cálculos fraccionarios se hacen con sumas, multiplicaciones y desplazamientos enteros.

## 3. Formatos Q15 y Q31

### Q15 (1.15, `q15_t`)

- Resolución: $2^{-15} = 0.000030517578125$
- Rango: $-1.0 \le x \le 1 - 2^{-15} \approx 0.999969$
- CMSIS-DSP convierte a `float` dividiendo entre 32768 [3].

| Decimal | Q15 entero | Hexadecimal |
|---:|---:|---:|
| 0.0 | 0 | `0x0000` |
| 0.25 | 8192 | `0x2000` |
| 0.50 | 16384 | `0x4000` |
| 0.75 | 24576 | `0x6000` |
| -0.50 | -16384 | `0xC000` |
| Máximo positivo | 32767 | `0x7FFF` |
| -1.0 | -32768 | `0x8000` |

### Q31 (1.31, `q31_t`)

- Resolución: $2^{-31} \approx 4.6566 \times 10^{-10}$
- Rango: $-1.0 \le x \le 1 - 2^{-31} \approx 0.9999999995$
- CMSIS-DSP convierte a `float` dividiendo entre 2147483648 [4].
- Ejemplo: $0.75 \times 2^{31} = 1610612736 = \texttt{0x60000000}$; $0.5 \to \texttt{0x40000000}$.

### Comparación

| Característica | Q15 | Q31 |
|---|---:|---:|
| Tamaño | 16 bits | 32 bits |
| Formato / tipo CMSIS | 1.15 / `q15_t` | 1.31 / `q31_t` |
| Bits fraccionarios | 15 | 31 |
| Resolución | $2^{-15}$ | $2^{-31}$ |
| Producto intermedio | 2.30 | 2.62 |
| Memoria por muestra | 2 bytes | 4 bytes |
| Error de cuantización máx. (redondeo) | $2^{-16}$ | $2^{-32}$ |
| Aplicaciones típicas | Audio, filtros, sensores | DSP de alta precisión |

Q31 no es "siempre mejor": cuesta el doble de memoria y sus multiplicaciones requieren resultados intermedios de 64 bits. Q15 puede ser muy eficiente si el núcleo tiene instrucciones DSP que procesan dos valores de 16 bits a la vez.

## 4. Cuantización y error numérico

Convertir un real a punto fijo se llama **cuantización**:

$$
X = \mathrm{round}(x \cdot 2^F), \qquad \hat{x} = \frac{X}{2^F}, \qquad e = x - \hat{x}
$$

Con redondeo, el error máximo ideal es $|e| \le \tfrac{1}{2}\,2^{-F}$. La precisión final del algoritmo depende además del escalamiento, del redondeo o truncamiento y de los errores que se acumulan en operaciones sucesivas. Si las muestras vienen de un ADC de 12 o 16 bits, Q15 puede bastar según la exigencia del algoritmo. CMSIS-DSP incluye conversiones `float` ↔ Q15/Q31 y permite aplicar redondeo [7].

## 5. Suma, resta y saturación

Con el mismo formato Q, la suma se hace directo sobre los enteros:

```text
0.25 Q15 = 8192
0.50 Q15 = 16384
8192 + 16384 = 24576   →   24576 / 32768 = 0.75
```

Problema: $0.75 + 0.50 = 1.25$ no cabe en Q15. Hay dos comportamientos posibles:

- **Desbordamiento (*wrap-around*):** `32767 + 1 → -32768`. El cambio de signo distorsiona fuertemente la señal.
- **Saturación:** `32767 + 1 → 32767`. El resultado se fija al extremo del rango, evitando discontinuidades.

$$
X_{sat}=\begin{cases}32767,&X>32767\\-32768,&X<-32768\\X,&\text{otro caso}\end{cases}
\quad(\text{Q15})
$$

En Q31 los límites son $2147483647$ y $-2147483648$. En DSP suele preferirse la saturación, y CMSIS-DSP la usa en varias operaciones Q15/Q31 (p. ej. multiplicación) [5].

## 6. Multiplicación

Multiplicar aumenta los bits fraccionarios: $1.15 \times 1.15 = 2.30$. Para volver a Q15 se desplaza 15 bits:

```text
resultadoQ15 = (a × b) >> 15      // producto en al menos 32 bits
```

Ejemplo: $0.75 \times (-0.5)$:

```text
24576 × -16384 = -402653184
-402653184 >> 15 = -12288      →   -12288 / 32768 = -0.375
```

En Q31 el producto es $1.31 \times 1.31 = 2.62$ y requiere 64 bits:

```text
producto64   = (int64)a * b;
resultadoQ31 = producto64 >> 31;
```

**Caso límite:** $-1 \times -1 = +1$, pero ni Q15 ni Q31 pueden representar $+1.0$ exacto. Una implementación correcta satura al máximo positivo. Por eso no basta con "enteros y desplazamientos": hay que controlar **escalado, precisión, redondeo y saturación**.

## 7. Acumulación, MAC y filtros FIR

La operación fundamental en DSP es **MAC** (*Multiply-Accumulate*): $acc \leftarrow acc + a \cdot b$. Un filtro FIR la repite en cada salida:

$$
y[n] = \sum_{k=0}^{N-1} h[k]\,x[n-k]
$$

Aunque cada producto esté en rango, la suma de muchos productos puede exceder el acumulador. Según la documentación de CMSIS-DSP [6]:

- `arm_fir_q15()` genera productos 1.15 × 1.15 (2.30) y los acumula internamente en 64 bits (formato 34.30). Algunas versiones rápidas reducen las protecciones contra desbordamiento a cambio de velocidad.
- `arm_fir_q31()` usa un acumulador de 64 bits en formato 2.62, pero con un solo bit de guarda; la documentación recomienda reducir antes la amplitud de entrada si hace falta.

Conclusión: Q31 da más precisión, **no** más seguridad automática; puede exigir un escalado más cuidadoso.

## 8. Escalamiento y rango dinámico

Antes de portar un algoritmo de `float` a Q15/Q31 hay que conocer el rango máximo de cada señal y variable intermedia. Para un FIR:

$$
|y[n]| \le \sum_{k=0}^{N-1} |h[k]|\,|x[n-k]|
$$

Si ese máximo excede el rango, se reescala la señal o los coeficientes ($x_s[n] = x[n]\,2^{-S}$). Escala demasiado pequeña pierde precisión (pocos bits significativos); demasiado grande provoca desbordamiento.

## 9. Instrucciones DSP de ARM y CMSIS-DSP

CMSIS-Core ofrece intrínsecos para Cortex-M con extensión DSP [8]:

- `__SMLAD()`: dos multiplicaciones con signo de 16 bits, sumando ambos productos a un acumulador de 32 bits. Útil con dos valores Q15 empaquetados en una palabra.
- `__SMLALD()`: igual, pero con acumulador de 64 bits.

**No todos los Cortex-M tienen el mismo conjunto DSP**; no se debe suponer que cualquiera ejecuta `SMLAD`. CMSIS permite usar una interfaz común en C sin escribir todo en ensamblador [1], [8].

Multiplicación Q15 con CMSIS-DSP:

```c
#include "arm_math.h"

q15_t entradaA[4] = { 16384, 24576, -16384, 8192 };   // 0.50, 0.75, -0.50, 0.25
q15_t entradaB[4] = { 16384, 16384,  16384, 16384 };  // 0.50 en las cuatro
q15_t resultado[4];

arm_mult_q15(entradaA, entradaB, resultado, 4);
// ≈ 0.25, 0.375, -0.25, 0.125 (con saturación si hiciera falta)
```

Filtro FIR Q15 por bloques:

```c
#include "arm_math.h"

#define NUM_TAPS   8
#define BLOCK_SIZE 32

q15_t coefficients[NUM_TAPS];
q15_t state[NUM_TAPS + BLOCK_SIZE - 1];
q15_t input[BLOCK_SIZE];
q15_t output[BLOCK_SIZE];

arm_fir_instance_q15 filter;

int main(void)
{
    arm_fir_init_q15(&filter, NUM_TAPS, coefficients, state, BLOCK_SIZE);

    while (1) {
        arm_fir_q15(&filter, input, output, BLOCK_SIZE);
    }
}
```

`arm_fir_init_q15()` prepara la estructura y `arm_fir_q15()` procesa un bloque. Existen funciones equivalentes para Q31.

## 10. ¿Q15, Q31 o punto flotante?

**Q15 conviene cuando:** 15 bits fraccionarios bastan, hay que ahorrar memoria, se procesan muchas muestras, el núcleo tiene SIMD/DSP de 16 bits o los datos vienen de sensores/convertidores de resolución similar.

**Q31 conviene cuando:** el error de Q15 es significativo, hay memoria suficiente, los 64 bits intermedios no penalizan el rendimiento o el algoritmo debe conservar pequeñas variaciones de amplitud o de coeficientes.

**Punto fijo frente a `float`:**

| Ventajas del punto fijo | Desventajas |
|---|---|
| Representación compacta | El programador administra el escalado |
| Control explícito de la precisión | Riesgo de desbordamiento y saturación |
| Operaciones enteras eficientes | La multiplicación cambia de formato |
| Comportamiento predecible | Cada etapa exige análisis de rango |
| Aprovecha instrucciones DSP/SIMD | Error de cuantización |

Tampoco es cierto que punto fijo siempre sea más rápido: con una FPU eficiente, `float` puede ser competitivo y simplificar el código. La elección depende del núcleo, la frecuencia, la FPU, la memoria, el número de muestras, la precisión requerida y el algoritmo.

## 11. Buenas prácticas

1. Determinar el rango máximo y mínimo de las señales.
2. Documentar el formato Q de cada variable.
3. Reservar margen (*headroom*) antes de acumulaciones grandes.
4. Usar registros más anchos para productos y acumuladores intermedios.
5. Reescalar tras cada multiplicación.
6. Saturar cuando corresponda.
7. Considerar el redondeo y la cuantización.
8. Probar casos límite como `-1 × -1`.
9. Comparar contra una implementación de referencia en `float`.
10. Verificar los peores casos de acumulación en filtros y convoluciones, con señales cercanas a escala completa.
11. Usar CMSIS-DSP antes de escribir a mano una rutina crítica.
12. Revisar qué instrucciones DSP tiene el Cortex-M concreto.

## 12. Conclusiones

Q15 y Q31 siguen siendo herramientas centrales para DSP en microcontroladores ARM: guardan valores fraccionarios como enteros con una escala binaria conocida, sin manejar un exponente como el punto flotante. Q15 ahorra memoria y aprovecha instrucciones de dos operandos de 16 bits; Q31 ofrece mucha más precisión a cambio de memoria y acumuladores de 64 bits.

Lo esencial no es multiplicar y desplazar, sino controlar **escalado, saturación, redondeo, cuantización y desbordamiento de acumuladores**. Mayor precisión no implica mayor seguridad. La selección entre Q15, Q31 y `float` debe basarse en los requisitos reales y en el microcontrolador específico, y toda implementación debe probarse con datos límite y compararse con una referencia de mayor precisión antes de usarse en una aplicación real.

## Referencias

[1] Arm Limited, "CMSIS-DSP," *GitHub Repository*, 2026. <https://github.com/ARM-software/CMSIS-DSP>

[2] Arm Limited, "CMSIS-DSP: Fixed point datatypes," *CMSIS-DSP Documentation*, 2026. <https://arm-software.github.io/CMSIS-DSP/main/group__FIXED.html>

[3] Arm Limited, "Convert 16-bit fixed point value," *CMSIS-DSP Documentation*, 2026.

[4] Arm Limited, "Convert 32-bit fixed point value," *CMSIS-DSP Documentation*, 2026.

[5] Arm Limited, "CMSIS-DSP: Basic Math Functions," *CMSIS-DSP Documentation*, 2026. <https://arm-software.github.io/CMSIS-DSP/latest/group__groupMath.html>

[6] Arm Limited, "CMSIS-DSP: Finite Impulse Response (FIR) Filters," *CMSIS-DSP Documentation*, 2026. <https://arm-software.github.io/CMSIS-DSP/latest/group__FIR.html>

[7] Arm Limited, "Convert 32-bit floating point value," *CMSIS-DSP Documentation*, 2026.

[8] Arm Limited, "Intrinsic Functions for SIMD Instructions," *CMSIS-Core Documentation*, 2026. <https://arm-software.github.io/CMSIS_6/latest/Core/>

[9] U. Zölzer, *Digital Audio Signal Processing*, 2nd ed. Chichester, U.K.: Wiley, 2008.

[10] R. G. Lyons, *Understanding Digital Signal Processing*, 3rd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2011.

[11] A. V. Oppenheim and R. W. Schafer, *Discrete-Time Signal Processing*, 3rd ed. Upper Saddle River, NJ, USA: Prentice Hall, 2010.
