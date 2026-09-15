# Desenrollado de bucles (loop unrolling) manual y su efecto en el rendimiento

## 1. Introducción

El **desenrollado de bucles** (*loop unrolling*) es una técnica de optimización de código que consiste en reescribir un bucle de manera que, en cada iteración del bucle transformado, se ejecuten manualmente varias iteraciones equivalentes del bucle original. En lugar de repetir un bloque de instrucciones `N` veces mediante una única iteración por ciclo, el cuerpo del bucle se replica `k` veces dentro de una sola iteración, reduciendo el número total de iteraciones a `N/k` (más, en su caso, un remanente para manejar los casos en que `N` no es múltiplo de `k`).

Esta técnica puede aplicarse de dos formas: **automática**, cuando el compilador la realiza como parte de sus optimizaciones (por ejemplo, con `-funroll-loops` en GCC), o **manual**, cuando es el propio programador quien reescribe explícitamente el código fuente para reducir el número de saltos y comparaciones de control. El desenrollado manual es relevante en contextos donde el compilador no aplica la optimización de forma efectiva —código con dependencias complejas, bucles con condiciones no triviales, o plataformas embebidas con compiladores poco agresivos— y constituye, además, un ejercicio didáctico fundamental para comprender cómo el hardware subyacente (unidad de control, *pipeline*, memoria caché) afecta el rendimiento real de un programa más allá de su complejidad algorítmica asintótica.

La motivación central del desenrollado de bucles es reducir el **overhead de control**: cada iteración de un bucle implica, típicamente, una comparación de la condición de parada, un salto condicional y, en muchos casos, el incremento de una variable índice. Cuando el cuerpo del bucle es pequeño en comparación con este overhead, el costo relativo de controlar el bucle puede superar el costo de la operación útil que se realiza, motivando la técnica que se desarrolla en este documento.

---

## 2. Desarrollo técnico

### 2.1 Bucle original y bucle desenrollado

Considérese la suma de los elementos de un arreglo de `N` enteros. La versión **no desenrollada** en C es la siguiente:

```c
// suma_normal.c
#include <stdio.h>

long suma_normal(const int *arreglo, int n) {
    long total = 0;
    for (int i = 0; i < n; i++) {
        total += arreglo[i];   // una suma por iteración
    }
    return total;
}
```

En cada una de las `n` iteraciones se ejecutan: la comparación `i < n`, el incremento `i++`, el acceso a memoria `arreglo[i]` y la suma `total +=`. El **desenrollado manual con factor 4** reescribe el mismo bucle de la siguiente forma:

```c
// suma_desenrollada.c
#include <stdio.h>

long suma_desenrollada(const int *arreglo, int n) {
    long total = 0;
    int i = 0;
    int limite = n - (n % 4);          // mayor múltiplo de 4 menor o igual a n

    for (; i < limite; i += 4) {
        total += arreglo[i];
        total += arreglo[i + 1];
        total += arreglo[i + 2];
        total += arreglo[i + 3];       // 4 sumas por iteración
    }

    for (; i < n; i++) {               // remanente: elementos sobrantes
        total += arreglo[i];
    }
    return total;
}
```

Aquí, el ciclo principal realiza cuatro sumas por cada evaluación de la condición `i < limite` y cada incremento de `i`, reduciendo en un factor aproximado de 4 el número de comparaciones y saltos de control. El segundo bucle (*remainder loop*) es indispensable: procesa los elementos finales cuando `n` no es múltiplo del factor de desenrollado, y su omisión es uno de los errores más frecuentes al aplicar esta técnica manualmente.

### 2.2 Efecto sobre el rendimiento

El desenrollado de bucles mejora el rendimiento por tres razones principales, respaldadas por los fundamentos de arquitectura de computadoras:

1. **Reducción del overhead de control.** Menos comparaciones y saltos condicionales significan menos instrucciones ejecutadas en total y, potencialmente, menos fallos de predicción de salto (*branch misprediction*), los cuales son costosos porque obligan a vaciar el *pipeline* de instrucciones del procesador.

2. **Mejor aprovechamiento del *pipeline* y de la ejecución superescalar.** Los procesadores modernos pueden despachar y ejecutar varias instrucciones independientes en el mismo ciclo de reloj. Al desenrollar el bucle, las cuatro sumas del ejemplo anterior son independientes entre sí (no existe dependencia de datos entre `arreglo[i]` y `arreglo[i+1]`), lo cual facilita que el planificador de instrucciones del procesador las ejecute en paralelo dentro de sus unidades funcionales disponibles.

3. **Facilitación de la vectorización.** Muchos compiladores utilizan el desenrollado como paso previo a la generación de instrucciones **SIMD** (*Single Instruction, Multiple Data*, como las extensiones SSE/AVX en arquitecturas x86), que procesan varios elementos de datos con una sola instrucción de máquina.

No obstante, el desenrollado también presenta costos que deben evaluarse:

- **Aumento del tamaño del código (*code bloat*)**, lo cual puede degradar el rendimiento si el bucle desenrollado ya no cabe en la memoria caché de instrucciones (I-cache), provocando más fallos de caché que los que se evitan en el control del bucle.
- **Rendimientos decrecientes.** A partir de cierto factor de desenrollado, el beneficio marginal disminuye porque el cuello de botella deja de ser el overhead de control y pasa a ser, por ejemplo, el ancho de banda de memoria.
- **Mayor complejidad y menor legibilidad del código fuente**, con mayor riesgo de errores de índice, especialmente en la gestión del bucle remanente.

### 2.3 Comparación empírica simplificada

Para ilustrar el efecto, se puede medir el tiempo de ejecución de ambas versiones sobre un arreglo grande usando un script de referencia:

```c
// benchmark.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

long suma_normal(const int *arreglo, int n) {
    long total = 0;
    for (int i = 0; i < n; i++) total += arreglo[i];
    return total;
}

long suma_desenrollada(const int *arreglo, int n) {
    long total = 0;
    int i = 0;
    int limite = n - (n % 4);
    for (; i < limite; i += 4) {
        total += arreglo[i];
        total += arreglo[i + 1];
        total += arreglo[i + 2];
        total += arreglo[i + 3];
    }
    for (; i < n; i++) total += arreglo[i];
    return total;
}

int main(void) {
    int n = 100000000;
    int *arreglo = malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) arreglo[i] = i % 7;

    clock_t inicio = clock();
    long r1 = suma_normal(arreglo, n);
    clock_t fin = clock();
    printf("Normal:      resultado=%ld tiempo=%.4f s\n",
           r1, (double)(fin - inicio) / CLOCKS_PER_SEC);

    inicio = clock();
    long r2 = suma_desenrollada(arreglo, n);
    fin = clock();
    printf("Desenrollada: resultado=%ld tiempo=%.4f s\n",
           r2, (double)(fin - inicio) / CLOCKS_PER_SEC);

    free(arreglo);
    return 0;
}
```

Compilación sin optimizaciones agresivas del compilador (para aislar el efecto del desenrollado manual): `gcc -O1 benchmark.c -o benchmark`. En estas condiciones, la versión desenrollada manualmente típicamente reporta un tiempo de ejecución menor que la versión normal, debido a la reducción de instrucciones de control por elemento procesado; la magnitud exacta de la mejora depende del procesador, del compilador y del nivel de optimización empleado, por lo que se recomienda ejecutar el *benchmark* en el entorno específico de evaluación en lugar de asumir una cifra fija.

### 2.4 Errores comunes al desenrollar manualmente

1. **Omitir el bucle remanente**, provocando que se procesen incorrectamente (o se ignoren) los elementos finales cuando `n` no es múltiplo del factor de desenrollado.
2. **Introducir dependencias de datos entre las copias del cuerpo del bucle**, lo cual anula la posibilidad de ejecución paralela y puede incluso alterar el resultado si existe una dependencia real (por ejemplo, en una recurrencia como `x[i] = x[i-1] + valor`).
3. **Elegir un factor de desenrollado excesivo**, generando *code bloat* y degradando el rendimiento por presión sobre la caché de instrucciones, en lugar de mejorarlo.
4. **Desenrollar bucles ya optimizados automáticamente por el compilador**, duplicando el esfuerzo sin beneficio adicional y reduciendo la legibilidad del código sin justificación medible.

### 2.5 Relación con la vectorización y el hardware

El desenrollado de bucles no debe entenderse de forma aislada: en las arquitecturas modernas está estrechamente ligado a la **vectorización automática**, donde el compilador agrupa varias iteraciones desenrolladas en una sola instrucción SIMD que opera sobre un registro vectorial (por ejemplo, procesando cuatro enteros de 32 bits en un registro de 128 bits con SSE). Por ello, el desenrollado manual con un factor múltiplo del ancho del registro vectorial del procesador objetivo (4, 8 o 16, según la arquitectura) suele ser más efectivo que factores arbitrarios, ya que facilita al compilador —o al programador que utiliza *intrinsics*— generar código vectorizado eficiente.

---

## 3. Conclusiones

El desenrollado de bucles manual es una técnica de optimización de bajo nivel que reduce el overhead de control de un bucle al procesar varios elementos por iteración, favoreciendo además la ejecución superescalar y la vectorización en procesadores modernos. Sin embargo, su beneficio no es incondicional: el tamaño del código generado, la presión sobre la caché de instrucciones y la posible interferencia con las optimizaciones automáticas del compilador imponen límites prácticos al factor de desenrollado óptimo. La aplicación correcta de esta técnica exige manejar cuidadosamente el bucle remanente, evitar introducir dependencias de datos espurias entre las copias del cuerpo del bucle, y —sobre todo— validar el beneficio real mediante mediciones empíricas en el hardware y compilador objetivo, en lugar de asumir una mejora universal. En consecuencia, el desenrollado manual debe reservarse para secciones de código identificadas como críticas mediante perfilado (*profiling*), y no aplicarse de forma indiscriminada.

## 4. Material complementario (opcional)

### Diagrama comparativo de control de flujo

```
Bucle normal (n=8, factor=1):
i=0: cmp i<n; suma; i++
i=1: cmp i<n; suma; i++
i=2: cmp i<n; suma; i++
i=3: cmp i<n; suma; i++
i=4: cmp i<n; suma; i++
i=5: cmp i<n; suma; i++
i=6: cmp i<n; suma; i++
i=7: cmp i<n; suma; i++
  -> 8 comparaciones, 8 saltos, 8 incrementos

Bucle desenrollado (n=8, factor=4):
i=0: cmp i<8; suma[0]; suma[1]; suma[2]; suma[3]; i+=4
i=4: cmp i<8; suma[4]; suma[5]; suma[6]; suma[7]; i+=4
  -> 2 comparaciones, 2 saltos, 2 incrementos (misma cantidad de sumas)
```

El diagrama evidencia la reducción del overhead de control (comparaciones, saltos e incrementos) sin alterar el número de operaciones útiles (las ocho sumas), que es precisamente el objetivo de la técnica.

### Código adicional: desenrollado con acumuladores independientes

Una variante que además mejora el paralelismo consiste en usar **acumuladores separados**, rompiendo la dependencia secuencial sobre una única variable `total`:

```c
// suma_acumuladores.c
long suma_paralela(const int *arreglo, int n) {
    long acc0 = 0, acc1 = 0, acc2 = 0, acc3 = 0;
    int i = 0;
    int limite = n - (n % 4);

    for (; i < limite; i += 4) {
        acc0 += arreglo[i];
        acc1 += arreglo[i + 1];
        acc2 += arreglo[i + 2];
        acc3 += arreglo[i + 3];
    }

    long total = acc0 + acc1 + acc2 + acc3;
    for (; i < n; i++) total += arreglo[i];
    return total;
}
```

Al usar cuatro acumuladores independientes (`acc0`...`acc3`), se elimina la dependencia de datos secuencial que existía en `suma_desenrollada` (donde cada suma dependía del valor anterior de `total`), permitiendo que el procesador ejecute las cuatro sumas verdaderamente en paralelo dentro del mismo ciclo de iteración, antes de combinarlas en un único resultado final.
