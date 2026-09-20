# División entera y módulo sin instrucción de división: algoritmos en ensamblador

**Estudiante:** Ricardo Araoz Sierra · **Materia:** Lenguajes de Interfaz SCC-1014

**Semestre:** 2026B · **Grupo B:** 17:00 h · **Tema:** 3

## Introducción

La división entera permite repartir una cantidad en grupos completos y conservar lo que sobra. Aunque un programa pueda expresarla con un operador, su ejecución necesita un mecanismo concreto: una instrucción del procesador o una secuencia de operaciones más simples. Estudiar esa secuencia permite relacionar aritmética, representación binaria, registros y control de flujo.

Esta investigación compara restas sucesivas con división binaria y analiza una rutina educativa AArch64 para operandos unsigned de 64 bits. El objetivo es obtener simultáneamente cociente y residuo, justificar su corrección y comprobar casos límite. Los hechos arquitectónicos se acompañan de referencias; el razonamiento del algoritmo se presenta como análisis y las mediciones funcionales se identifican como pruebas reales. La asistencia de IA y la reflexión del estudiante se documentan en [anexo.md](anexo.md).

## División entera, cociente y residuo

Para un dividendo no negativo `n` y un divisor positivo `d`, buscamos enteros `q` y `r` que satisfagan:

```text
n = d × q + r, con 0 ≤ r < d
```

El cociente `q` cuenta los grupos completos y el residuo `r` representa el sobrante. Por ejemplo, `23 = 5 × 4 + 3`. La igualdad por sí sola es insuficiente: `23 = 5 × 3 + 8` también es cierta, pero 8 no es un residuo válido porque todavía contiene otro grupo de 5. La restricción `r < d` permite identificar la solución única. Para valores unsigned, el residuo coincide con el módulo no negativo habitual.

## División signed y unsigned

Los mismos 64 bits admiten interpretaciones diferentes. Unsigned representa de 0 a `2^64−1`; signed en complemento a dos representa de `−2^63` a `2^63−1`. Por eso una comparación signed no sustituye a una unsigned cuando el bit más significativo vale uno.

Con cociente truncado hacia cero, `−23 / 5` produce `q = −4` y `r = −3`: sigue cumpliéndose `n = d*q+r`. En cambio, un módulo euclídeo con divisor positivo exige residuo no negativo y daría 2. Hay que especificar la convención antes de tratar números negativos; la rutina estudiada implementa únicamente unsigned. El pseudocódigo de `SDIV` determina el signo después de dividir las magnitudes [2].

## División en hardware y las instrucciones UDIV/SDIV

En A64, `UDIV Xd, Xn, Xm` interpreta los operandos como unsigned; `SDIV` los interpreta como signed. Ambas tienen variantes de 32 y 64 bits, escriben el cociente y no modifican NZCV. Con divisor cero escriben cero en el registro destino [1], [2].

Estas instrucciones no entregan directamente el residuo. Conservando los operandos, puede calcularse como `n−q*d`, por ejemplo mediante una multiplicación y resta. Que exista una sola instrucción de división no significa que tarde un ciclo: el comportamiento temporal depende de la implementación del procesador. Aquí no se midieron latencias ni se presenta un benchmark.

## ¿Por qué dividir sin instrucción de división?

Algunas plataformas carecen de soporte hardware para determinadas operaciones o tamaños; las bibliotecas runtime proporcionan rutinas auxiliares en esos casos [5]. También interesa implementar división para estudiar el recorrido de bits o diseñar una operación con una interfaz específica.

AArch64 sí dispone de división entera: el ejemplo evita usarla por una restricción educativa, no porque falte en esta arquitectura. En un sistema real, reemplazarla requeriría justificar el cambio mediante requisitos y mediciones. Tampoco debe confundirse AArch64 con todos los microcontroladores Arm: pertenecen a perfiles y conjuntos de instrucciones diferentes.

## Método 1: restas sucesivas

Se inicia `q=0`, `r=n`; mientras `r>=d`, se resta `d` y se incrementa `q`. Para 23 y 5, los residuos parciales son 23, 18, 13, 8 y 3. Cuatro restas producen cociente 4. Cada paso mantiene la igualdad porque aumenta `d*q` exactamente lo que disminuye `r`.

Su sencillez facilita aprender ciclos y comparaciones, pero realiza exactamente `q` restas: cuesta `O(q+1)` operaciones de palabra. Para un dividendo de `w` bits y divisor 1, el peor caso crece como `2^w`. Esta es una cuenta teórica, no una medición. Además, si no se descarta divisor cero, restar cero no reduce el residuo y puede impedir la terminación.

## Método 2: división binaria mediante desplazamientos y restas

La rutina estudiada construye el cociente desde su bit más significativo. En vez de retirar un divisor por paso, retira múltiplos `d*2^k`. El siguiente procedimiento describe exactamente la implementación:

1. Resolver divisor cero; si `n<d`, devolver `(0,n)`.
2. Inicializar `r=n`, `q=0`, `D=d` y `bit=1`.
3. Mientras `D <= (n >> 1)`, desplazar `D` y `bit` una posición a la izquierda.
4. Si `r>=D`, efectuar `r-=D` y `q+=bit`.
5. Desplazar `D` y `bit` una posición a la derecha; repetir el paso 4 mientras `bit` sea distinto de cero.

En `23/5`, la alineación produce `D=20`, `bit=4`. Se resta 20 y queda `r=3`, `q=4`. Después se comparan 10 y 5, sin restarlos. El resultado final es `(4,3)`.

**Análisis de corrección.** Durante el recorrido, `D=d*bit` y `n=d*q+r`. Una resta seleccionada conserva ambas relaciones con la actualización correspondiente del cociente. Antes de cada decisión, `r<2*D`, entendido matemáticamente: al restar una vez queda `r<D`; si no se resta, esa desigualdad ya se cumple. Al bajar al siguiente peso vuelve a cumplirse la condición inicial. Tras procesar `D=d`, resulta `0<=r<d`. Cada peso se visita una vez y el desplazamiento de `bit` garantiza la terminación.

## Restoring division o algoritmo equivalente

La división restauradora clásica intenta restar un divisor desplazado; si la resta sería negativa, restaura el valor anterior y escribe cero en el bit correspondiente. Una comparación previa permite decidir si debe conservarse el residuo sin modificarlo [3].

La implementación utiliza esta alternativa de comparación y resta condicional con divisor alineado. No es el algoritmo *non-restoring*, que conserva residuos parciales negativos y alterna sumas y restas. La distinción ayuda a explicar por qué aquí bastan comparaciones unsigned y nunca se almacena un residuo negativo.

## Implementación en AArch64

Se desarrolló y probó localmente una rutina de ejemplo. Su archivo fuente no se adjunta: el código es opcional según la lista de temas del Grupo B. Aquí se documentan su interfaz, algoritmo y un fragmento explicativo.

| Registro | Función |
|---|---|
| `x0` | Dividendo de entrada; cociente de salida |
| `x1` | Divisor de entrada; residuo de salida |
| `x2` | Residuo parcial |
| `x3` | Divisor desplazado |
| `x4` | Peso del bit del cociente |
| `x5` | Límite seguro `n >> 1` |

`LSL` duplica el divisor y su peso; `LSR` recorre los pesos hacia abajo. `CMP` establece las banderas para `B.LO` y `B.HI`, que interpretan el orden unsigned. `SUB` reduce el residuo y `ADD` incorpora el peso seleccionado. `CBZ` atiende divisor cero y `CBNZ` controla el final del recorrido.

```asm
    cmp     x2, x3
    b.lo    .Lsiguiente
    sub     x2, x2, x3
    add     x0, x0, x4
```

Es una función hoja, sin llamadas externas, pila ni memoria. Modifica `x0–x5` y NZCV; preserva los demás registros. Esto respeta los registros que debe conservar una subrutina según AAPCS64 [4]. Los símbolos `division_sin_div` y `_division_sin_div` comparten la misma entrada para facilitar el enlace en ELF y macOS. En C, el retorno se declara como una estructura de dos `uint64_t`, en orden cociente y residuo; declarar solamente un entero perdería el segundo resultado.

## Ejemplo de ejecución

**Resultados reales:** ejecución nativa en macOS 26.6.2 ARM64, con Apple Clang 21.0.0, el 19 de septiembre de 2026. `MAX` representa `18446744073709551615`.

| Dividendo | Divisor | Cociente observado | Residuo observado |
|---:|---:|---:|---:|
| 23 | 5 | 4 | 3 |
| 100 | 10 | 10 | 0 |
| 7 | 9 | 0 | 7 |
| 0 | 5 | 0 | 0 |
| 1 | 1 | 1 | 0 |
| 5 | 1 | 5 | 0 |
| 5 | 5 | 1 | 0 |
| 1 | 2 | 0 | 1 |
| MAX | 1 | MAX | 0 |
| 23 | 0 | MAX | 23 |

Pasaron **165,998 casos, con cero fallos**: los diez anteriores, 196 combinaciones de límites, 65,536 pares entre 0 y 255, 256 casos alrededor de potencias de dos y 100,000 pares pseudoaleatorios. Se compararon cociente y residuo con `/` y `%` de C exclusivamente en el programa de prueba. La reconstrucción `d*q+r` usó 128 bits para evitar que un overflow ocultara errores.

Se ensambló también un objeto ELF AArch64 con Clang. El desensamblado verificó 25 instrucciones, sin `UDIV`, `SDIV` ni llamadas externas. El código máquina coincide con el objeto Mach-O, pero no se ejecutó en Linux ni se probó GNU `as`. El [anexo](anexo.md#evidencia-de-las-pruebas-locales) registra el procedimiento y los resultados; la fuente y el programa de prueba se conservan localmente y esta entrega no permite reproducirlos por sí sola; GNU documenta por separado las directivas específicas de AArch64 [6].

## Comparación de métodos

Aquí `w` es el ancho de palabra; los costes cuentan operaciones sobre registros, no operaciones individuales sobre bits.

| Aspecto | Restas sucesivas | División binaria implementada | UDIV/SDIV |
|---|---|---|---|
| Coste conceptual | `O(q+1)` | `O(w)` | Una instrucción para el cociente; latencia según CPU |
| Iteraciones | `q` restas | Hasta 63 desplazamientos de alineación y 64 decisiones | Sin ciclo software explícito |
| Implementación | Muy sencilla | Exige controlar pesos y overflow | Sencilla si está disponible |
| Cociente y residuo | Se obtienen juntos | Se obtienen juntos | El residuo requiere operaciones adicionales |
| Hardware necesario | Comparación, resta y salto | Además desplazamientos y suma | Soporte de división de la ISA |
| Valor educativo | Invariante y bucles | Bits, banderas, ABI y límites | Semántica de instrucciones |

La cota de la rutina no significa tiempo constante: tanto las iteraciones como los saltos dependen de los operandos. La comparación tampoco demuestra que el software sea más rápido que el hardware.

## Consideraciones especiales

**Divisor cero.** Se devuelve `(UINT64_MAX,n)` como convención explícita de error. No constituye una división matemática ni reproduce la salida cero de `UDIV`. El llamador debe comprobar el divisor original: `UINT64_MAX` también es el cociente válido de `UINT64_MAX/1`.

**Overflow y tamaño de palabra.** Antes de duplicar `D`, se exige `D<=floor(n/2)`. Por tanto, `2*D<=n<=UINT64_MAX`: no se pierde ningún bit alto. Como `d>=1`, el peso tampoco supera `2^63`. La comparación previa a cada resta impide underflow y la suma de pesos distintos nunca excede el cociente representable. Cambiar a registros `w` reduciría el dominio a 32 bits y exigiría repetir la validación.

**Números negativos.** Una extensión signed debe guardar los signos, dividir magnitudes unsigned y corregir cociente y residuo según la convención elegida. La magnitud de `INT64_MIN` no cabe en signed positivo, pero sí en unsigned. `INT64_MIN/−1` exige un resultado positivo no representable en signed de 64 bits. Del pseudocódigo de `SDIV` se deduce que conserva los 64 bits bajos, dando el patrón de `INT64_MIN` [2]; una interfaz de software puede optar por informar error. No se debe trasladar esa operación directamente a C signed, donde el cociente no representable produce comportamiento indefinido [7].

## Aplicaciones

La división por software permite implementar aritmética en sistemas embebidos sin divisor apropiado, rutinas de bajo nivel y bibliotecas runtime. GCC documenta, por ejemplo, `__udivmoddi4`, que calcula cociente y residuo con una interfaz diferente a la de esta entrega [5]. También sirve como base conceptual para operaciones de mayor precisión, aunque ampliar el ancho requiere otro tratamiento de registros y acarreos.

Como ejercicio de arquitectura, obliga a distinguir resultados matemáticos, representación finita y contrato de llamada. La rutina presentada prioriza claridad; no ofrece tiempo constante ni pretende reemplazar una biblioteca optimizada.

## Conclusiones

El cambio decisivo entre los dos métodos estudiados consiste en seleccionar pesos binarios del cociente en lugar de contar divisores uno por uno. Esto limita el trabajo al ancho de los operandos y permite obtener el residuo durante el mismo recorrido.

La corrección depende de detalles concretos: comparación unsigned, alineación sin pérdida de bits, divisor cero explícito y conservación del contrato de llamada. Las pruebas aportan evidencia amplia de funcionamiento, complementada por el invariante; no constituyen una prueba exhaustiva de los `2^128` pares posibles ni una comparación de rendimiento. Comprender estas diferencias permite evaluar una rutina por sus condiciones de uso y resultados comprobables.

## Referencias

[1] Arm Ltd., “UDIV (quotient): Unsigned divide,” *Arm A-profile A64 Instruction Set Architecture*, DDI 0602, versión 2026-06, 2026. [En línea]. Disponible: [documento en línea](https://support.arm.com/documentation/ddi0602/2026-06/Base-Instructions/UDIV--quotient---Unsigned-divide-). [Consultado: 19-sep-2026].

[2] Arm Ltd., “SDIV (quotient): Signed divide,” *Arm A-profile A64 Instruction Set Architecture*, DDI 0602, versión 2026-06, 2026. [En línea]. Disponible: [documento en línea](https://support.arm.com/documentation/ddi0602/2026-06/Base-Instructions/SDIV--quotient---Signed-divide-). [Consultado: 19-sep-2026].

[3] R. Robucci, “Lecture 18 – Iterative Arithmetic Implementations,” University of Maryland, Baltimore County, s. f. [En línea]. Disponible: [documento en línea](https://eclipse.umbc.edu/robucci/cmpeRSD/Lectures/Lecture18__Iterative_Implementations_of_Elementary_Arithmetic_Functions/). [Consultado: 19-sep-2026].

[4] Arm Ltd., *Procedure Call Standard for the Arm 64-bit Architecture (AArch64)*, AAPCS64, versión 2025Q4, 2026, secs. 6.1.1 y 6.9. [En línea]. Disponible: [documento en línea](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst). [Consultado: 19-sep-2026].

[5] Free Software Foundation, “Routines for integer arithmetic,” *GNU Compiler Collection Internals*, s. f. [En línea]. Disponible: [documento en línea](https://gcc.gnu.org/onlinedocs/gccint/Integer-library-routines.html). [Consultado: 19-sep-2026].

[6] Free Software Foundation, “AArch64 Machine Directives,” *Using as*, GNU Binutils, s. f. [En línea]. Disponible: [documento en línea](https://sourceware.org/binutils/docs/as/AArch64-Directives.html). [Consultado: 19-sep-2026].

[7] ISO/IEC JTC1/SC22/WG14, *Programming Languages — C*, borrador de comité N1570, 12-abr-2011, sec. 6.5.5, párr. 6. [En línea]. Disponible: [documento en línea](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf). [Consultado: 19-sep-2026].
