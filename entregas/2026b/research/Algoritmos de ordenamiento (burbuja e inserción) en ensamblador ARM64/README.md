[README.md](https://github.com/user-attachments/files/32449574/README.md)
# Algoritmos de ordenamiento (burbuja e inserción) en ensamblador ARM64

**Curso:** Lenguajes de Interfaz (SCC-1014) — TecNM Campus Tijuana
**Semestre:** 2026 "B" — Grupo B (17:00 h)
**Tema:** 13 — Algoritmos de ordenamiento (burbuja e inserción) en ensamblador ARM64

---

## 1. Introducción

El ordenamiento es una de las operaciones más estudiadas de la computación y, a la vez, una de las más engañosas: los algoritmos cuadráticos clásicos —burbuja e inserción— se explican en las primeras semanas de cualquier curso de estructuras de datos y de inmediato se descartan como "lentos". Sin embargo, siguen presentes en el software real. Las implementaciones industriales de `std::sort` y de *introsort* recurren a inserción para las particiones pequeñas, y buena parte del firmware embebido ordena arreglos de diez o veinte elementos donde un *quicksort* completo sería más código del que vale la pena grabar en la memoria flash.

Esta investigación toma esos dos algoritmos y los baja al nivel del ensamblador AArch64 (ARMv8-A, 64 bits). El objetivo no es demostrar que el ensamblador escrito a mano es más rápido que C compilado —adelanto que, en el caso general, no lo es— sino usar dos algoritmos suficientemente simples como lente para observar lo que normalmente queda oculto: cómo se calcula la dirección de `a[j]`, qué cuesta un intercambio, por qué un salto mal predicho puede pesar más que la comparación que lo provoca, y qué hace realmente GCC cuando se le pide optimizar. Es un ejercicio de lectura de arquitectura tanto como de programación.

El trabajo se organiza así: primero se repasan los dos algoritmos y sus invariantes; luego se describe el mapeo a AArch64 (registros, convención de llamadas, direccionamiento); se presentan las implementaciones comentadas y su banco de pruebas en C; se propone una metodología de medición; se comparan contra el código generado por GCC con distintos niveles de optimización; y se cierra con un análisis crítico y las conclusiones.

---

## 2. Desarrollo técnico

### 2.1 Los dos algoritmos y sus invariantes

**Ordenamiento burbuja.** Recorre el arreglo comparando pares adyacentes e intercambiándolos si están desordenados. Tras el pase *k*, los *k* elementos mayores ya ocupan su posición definitiva al final del arreglo; ese es su invariante y justifica que el límite del bucle interno se reduzca en uno por cada pase. La variante que se implementa aquí incluye una bandera de intercambio (`swapped`): si un pase completo no realiza ningún intercambio, el arreglo ya está ordenado y se puede terminar. Esa mejora convierte el mejor caso de Θ(n²) en Θ(n).

**Ordenamiento por inserción.** Mantiene el invariante de que el subarreglo `a[0..i-1]` está ordenado; en cada iteración toma `a[i]` como *clave*, desplaza hacia la derecha todos los elementos mayores que ella y la deposita en el hueco resultante. No intercambia: desplaza, lo que significa aproximadamente una escritura por elemento movido en lugar de las tres de un intercambio con temporal.

| Criterio | Burbuja (con bandera) | Inserción |
|---|---|---|
| Mejor caso | Θ(n) — arreglo ya ordenado | Θ(n) — arreglo ya ordenado |
| Caso promedio | Θ(n²) | Θ(n²) |
| Peor caso | Θ(n²) — orden inverso | Θ(n²) — orden inverso |
| Memoria adicional | O(1) | O(1) |
| Estable | Sí | Sí |
| Escrituras (peor caso) | ~3·n²/2 | ~n²/2 |
| Comparaciones (mejor caso) | n−1 | n−1 |

Ambos son Θ(n²) y ambos son estables, pero no son equivalentes. La diferencia decisiva está en el número de escrituras a memoria: el intercambio de burbuja cuesta dos `STR` por par desordenado, mientras que inserción hace un solo `STR` por elemento desplazado. Cormen *et al.* [4] desarrollan el análisis formal de ambos, y Knuth [5] dedica al conteo exacto de comparaciones e intercambios un tratamiento que hoy sigue siendo la referencia. Astrachan [9] revisó históricamente por qué el burbuja sobrevive en la enseñanza pese a ser dominado por inserción en casi toda métrica, y concluye que su permanencia es más pedagógica que técnica. Sobre datos casi ordenados —una situación común en la práctica, por ejemplo al reinsertar elementos en una lista ya construida— inserción es netamente superior: su costo es proporcional al número de inversiones del arreglo.

### 2.2 Mapeo a AArch64: registros y convención de llamadas

AArch64 ofrece 31 registros de propósito general de 64 bits, direccionables como `X0`–`X30` (64 bits) o `W0`–`W30` (los 32 bits bajos, con extensión por cero al escribirlos) [1]. La convención AAPCS64 [2] establece el contrato que debe respetar cualquier función llamable desde C:

- `X0`–`X7`: los primeros ocho argumentos enteros o punteros, y el valor de retorno en `X0`.
- `X9`–`X15`: temporales de libre uso (*caller-saved*); la función llamada puede destruirlos.
- `X19`–`X28`: *callee-saved*; si la función los usa, debe preservarlos en la pila y restaurarlos antes de `RET`.
- `X29` (FP) y `X30` (LR): apuntador de marco y dirección de retorno.
- `SP` debe permanecer alineado a 16 bytes en cualquier punto donde se acceda a memoria.

Este detalle tiene una consecuencia práctica directa: las dos rutinas presentadas aquí necesitan menos de ocho registros y ninguno de ellos es *callee-saved*, por lo que **no requieren prólogo ni epílogo**. No hay `stp x29, x30, [sp, #-16]!` ni ajuste de pila. Es una función hoja pura, y esa ausencia de ceremonia ahorra cuatro accesos a memoria por llamada. En rutinas con más presión de registros habría que pagar ese costo.

Los argumentos son entonces: `X0` = puntero al arreglo (`int32_t *a`) y `X1` = número de elementos (`int64_t n`).

### 2.3 Direccionamiento de arreglos

Acceder a `a[j]` con enteros de 32 bits exige multiplicar el índice por 4. AArch64 lo resuelve sin instrucción aparte gracias al direccionamiento con desplazamiento escalado por registro [1]:

```asm
ldr  w4, [x0, x3, lsl #2]    // w4 = a[j], siendo x3 el índice
```

El `lsl #2` desplaza el índice dos bits a la izquierda —es decir, lo multiplica por 4— dentro del propio cálculo de la dirección efectiva, sin consumir un ciclo extra ni un registro temporal. Para acceder a dos elementos contiguos conviene materializar la dirección una sola vez y usar desplazamiento inmediato:

```asm
add  x5, x0, x3, lsl #2      // x5 = &a[j]
ldr  w4, [x5]                // a[j]
ldr  w7, [x5, #4]            // a[j+1]
```

Esto convierte dos cálculos de dirección en uno. Existen además las formas *pre-indexed* (`[x5, #4]!`) y *post-indexed* (`[x5], #4`), que actualizan el registro base como efecto lateral y resultan naturales en recorridos secuenciales.

### 2.4 Comparación, saltos y la alternativa sin bifurcación

El ordenamiento vive de comparar. `CMP w4, w7` es en realidad un `SUBS` que descarta el resultado y solo actualiza las banderas NZCV; a continuación, `B.LE`, `B.GT`, etc., bifurcan según esas banderas. Para valores con signo se usan `GT/LT/GE/LE`; para valores sin signo, `HI/LO/HS/LS`. Confundirlos es uno de los errores más frecuentes al escribir ensamblador a mano.

El problema es que el resultado de esa comparación, sobre datos aleatorios, es impredecible por construcción: el predictor de saltos acierta alrededor de la mitad de las veces y cada fallo cuesta el vaciado del *pipeline*, del orden de una decena de ciclos en núcleos como el Cortex-A72 [6]. AArch64 permite eliminar el salto con selección condicional:

```asm
    ldr   w4, [x5]
    ldr   w7, [x5, #4]
    cmp   w4, w7
    csel  w8, w7, w4, gt      // w8 = min(a[j], a[j+1])
    csel  w9, w4, w7, gt      // w9 = max(a[j], a[j+1])
    str   w8, [x5]
    str   w9, [x5, #4]
```

`CSEL Wd, Wn, Wm, cond` escribe `Wn` si la condición se cumple y `Wm` si no, sin bifurcar. El intercambio pasa a ser incondicional: siempre se ejecutan dos `STR`, aunque no hubiera nada que intercambiar. Es un canje explícito —más escrituras a cambio de cero fallos de predicción— y su conveniencia depende de los datos: sobre entradas aleatorias suele ganar la versión sin saltos; sobre entradas casi ordenadas, donde el predictor acierta casi siempre, la versión con `B.LE` es preferible porque se salta el trabajo. Hay además un efecto secundario importante: la versión con `CSEL` no puede alimentar fácilmente la bandera `swapped`, con lo que se pierde la salida temprana del burbuja.

### 2.5 Implementación: `bubble_sort`

```asm
    .text
    .align  2
    .global bubble_sort
    .type   bubble_sort, %function

// void bubble_sort(int32_t *a, int64_t n)
//   x0 = a, x1 = n
//   x2 = límite del pase, x3 = j, w6 = bandera swapped
bubble_sort:
    cmp     x1, #2
    b.lt    .Lbs_done              // n < 2: no hay nada que ordenar
    sub     x2, x1, #1             // límite = n - 1

.Lbs_outer:
    mov     x3, xzr                // j = 0
    mov     w6, wzr                // swapped = 0

.Lbs_inner:
    cmp     x3, x2
    b.ge    .Lbs_end_inner
    add     x5, x0, x3, lsl #2     // x5 = &a[j]
    ldr     w4, [x5]               // w4 = a[j]
    ldr     w7, [x5, #4]           // w7 = a[j+1]
    cmp     w4, w7
    b.le    .Lbs_next              // en orden: no tocar
    str     w7, [x5]               // intercambio
    str     w4, [x5, #4]
    mov     w6, #1                 // swapped = 1
.Lbs_next:
    add     x3, x3, #1
    b       .Lbs_inner

.Lbs_end_inner:
    cbz     w6, .Lbs_done          // pase sin intercambios -> ordenado
    subs    x2, x2, #1             // el mayor ya quedó al final
    b.gt    .Lbs_outer

.Lbs_done:
    ret
    .size   bubble_sort, . - bubble_sort
```

Dos detalles merecen atención. `CBZ w6, .Lbs_done` comprueba y bifurca en una sola instrucción, sin pasar por las banderas. Y `SUBS x2, x2, #1` seguido de `B.GT` fusiona el decremento del límite con la condición de continuación, evitando un `CMP` adicional.

### 2.6 Implementación: `insertion_sort`

```asm
    .text
    .align  2
    .global insertion_sort
    .type   insertion_sort, %function

// void insertion_sort(int32_t *a, int64_t n)
//   x0 = a, x1 = n
//   x2 = i, w3 = clave, x4 = j, w5 = a[j], x6 = temporal
insertion_sort:
    cmp     x1, #2
    b.lt    .Lis_done
    mov     x2, #1                 // i = 1

.Lis_outer:
    cmp     x2, x1
    b.ge    .Lis_done
    ldr     w3, [x0, x2, lsl #2]   // clave = a[i]
    sub     x4, x2, #1             // j = i - 1

.Lis_inner:
    tbnz    x4, #63, .Lis_insert   // bit de signo: j < 0 -> insertar
    ldr     w5, [x0, x4, lsl #2]   // w5 = a[j]
    cmp     w5, w3
    b.le    .Lis_insert            // a[j] <= clave -> posición hallada
    add     x6, x4, #1
    str     w5, [x0, x6, lsl #2]   // a[j+1] = a[j]  (desplazar)
    sub     x4, x4, #1
    b       .Lis_inner

.Lis_insert:
    add     x6, x4, #1
    str     w3, [x0, x6, lsl #2]   // a[j+1] = clave
    add     x2, x2, #1
    b       .Lis_outer

.Lis_done:
    ret
    .size   insertion_sort, . - insertion_sort
```

`TBNZ x4, #63, etiqueta` prueba directamente el bit 63 —el bit de signo del índice de 64 bits— y bifurca si está activo. Es la forma idiomática de detectar `j < 0` en AArch64 sin `CMP` ni banderas. El uso de `B.LE` en lugar de `B.LT` es lo que conserva la estabilidad del algoritmo: los elementos iguales no se rebasan.

### 2.7 Banco de pruebas en C

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <time.h>

void bubble_sort(int32_t *a, int64_t n);
void insertion_sort(int32_t *a, int64_t n);

static int verificar(const int32_t *a, int64_t n) {
    for (int64_t i = 1; i < n; i++)
        if (a[i - 1] > a[i]) return 0;
    return 1;
}

static double medir(void (*f)(int32_t *, int64_t),
                    const int32_t *orig, int64_t n) {
    int32_t *c = malloc(n * sizeof(int32_t));
    memcpy(c, orig, n * sizeof(int32_t));
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);
    f(c, n);
    clock_gettime(CLOCK_MONOTONIC, &t1);
    double ms = (t1.tv_sec - t0.tv_sec) * 1e3
              + (t1.tv_nsec - t0.tv_nsec) / 1e6;
    if (!verificar(c, n)) { fprintf(stderr, "ERROR: no ordenado\n"); exit(1); }
    free(c);
    return ms;
}

int main(void) {
    const int64_t tam[] = { 100, 500, 1000, 2000, 5000 };
    for (size_t k = 0; k < sizeof(tam) / sizeof(tam[0]); k++) {
        int64_t n = tam[k];
        int32_t *a = malloc(n * sizeof(int32_t));

        srand(42);
        for (int64_t i = 0; i < n; i++) a[i] = rand() % 100000;  // aleatorio
        printf("n=%5ld  aleatorio  burbuja=%8.3f ms  insercion=%8.3f ms\n",
               n, medir(bubble_sort, a, n), medir(insertion_sort, a, n));

        for (int64_t i = 0; i < n; i++) a[i] = (int32_t)i;        // ordenado
        printf("n=%5ld  ordenado   burbuja=%8.3f ms  insercion=%8.3f ms\n",
               n, medir(bubble_sort, a, n), medir(insertion_sort, a, n));

        for (int64_t i = 0; i < n; i++) a[i] = (int32_t)(n - i);  // inverso
        printf("n=%5ld  inverso    burbuja=%8.3f ms  insercion=%8.3f ms\n",
               n, medir(bubble_sort, a, n), medir(insertion_sort, a, n));

        free(a);
    }
    return 0;
}
```

### 2.8 Compilación y ejecución

Sobre hardware ARM64 nativo (Raspberry Pi con SO de 64 bits, Apple Silicon bajo Linux, servidor Graviton):

```bash
gcc -O2 -c main.c -o main.o
as sorts.s -o sorts.o
gcc main.o sorts.o -o sorts
./sorts
```

Desde un equipo x86-64, con compilación cruzada y emulación:

```bash
sudo apt install gcc-aarch64-linux-gnu qemu-user
aarch64-linux-gnu-gcc -O2 -static main.c sorts.s -o sorts
qemu-aarch64 ./sorts
```

Nota metodológica importante: QEMU emula la *semántica* de las instrucciones, no la microarquitectura. Los tiempos medidos bajo emulación sirven para verificar la corrección y para comparar el orden de crecimiento (n² sigue viéndose como n²), pero **no son válidos para conclusiones sobre caché, predicción de saltos o costo real de `CSEL` frente a `B.LE`**. Cualquier afirmación sobre esos efectos exige hardware real.

### 2.9 Metodología de medición y tabla de resultados

Recomendaciones para que los números signifiquen algo: usar `CLOCK_MONOTONIC` y no `clock()`; repetir cada medición al menos cinco veces y reportar la mediana, no el promedio; sembrar el generador con `srand(42)` para que la entrada aleatoria sea reproducible; y siempre ordenar una copia del arreglo original, nunca el mismo arreglo dos veces. Si hay acceso a EL1 o el sistema lo permite desde espacio de usuario, el contador de ciclos `PMCCNTR_EL0` da una resolución mucho mayor que el reloj de pared [1].

La siguiente tabla debe completarse con mediciones propias; el patrón esperado se describe en la columna final.

| n | Distribución | Burbuja (ms) | Inserción (ms) | Comportamiento esperado |
|---|---|---|---|---|
| 1000 | Aleatorio | | | Inserción ≈ 2× más rápida (menos escrituras) |
| 1000 | Ordenado | | | Ambos Θ(n), tiempos casi nulos |
| 1000 | Inverso | | | Peor caso de ambos; la brecha se ensancha |
| 5000 | Aleatorio | | | Tiempo ×25 respecto a n=1000 (crecimiento n²) |
| 5000 | Inverso | | | Máximo de ambos |

El contraste entre n=1000 y n=5000 es la evidencia experimental de la complejidad cuadrática: al quintuplicar el tamaño, el tiempo debe multiplicarse por unas 25 veces.

### 2.10 Comparación contra el código generado por GCC

Compilando las mismas funciones escritas en C con `aarch64-linux-gnu-gcc -S` se obtiene material de comparación directa:

- **`-O0`**: cada variable local vive en la pila. El bucle interno se llena de pares `LDR`/`STR` que solo sirven para leer y reescribir `i`, `j` y la clave. El código es literal, larguísimo y claramente más lento que el ensamblador escrito a mano. Ganarle a `-O0` no demuestra absolutamente nada.
- **`-O2`**: GCC asigna las variables a registros, elimina el cálculo redundante de direcciones, aplica reducción de fuerza sobre el índice, invierte y rota los bucles, y en ocasiones emite `CSEL` por su cuenta. El resultado es sustancialmente equivalente al ensamblador manual y en algunos casos mejor, porque el compilador conoce el modelo de costos del núcleo objetivo y programa las instrucciones en consecuencia.
- **`-Os`**: prioriza el tamaño del binario. Evita el desenrollado y prefiere secuencias compactas. En un microcontrolador con memoria flash limitada suele ser la opción correcta, aun sacrificando algunos ciclos.

La lectura honesta de este experimento es que, para algoritmos de esta simplicidad, **el ensamblador escrito a mano rara vez le gana a GCC con `-O2`**. Lo que sí aporta es visibilidad: permite entender qué transformaciones hizo el compilador y por qué. El ensamblador manual conserva valor real en nichos concretos —código de arranque, rutinas de interrupción, acceso a registros de sistema, criptografía con requisitos de tiempo constante, o aprovechamiento de instrucciones que el compilador no genera—, no en reimplementar un ordenamiento cuadrático.

---

## 3. Análisis crítico

**¿Tiene sentido escribir ordenamiento a mano en 2026?** Como producto, no; como ejercicio, sí. Las tres semanas invertidas en depurar un bucle interno de veinte instrucciones enseñan más sobre AAPCS64, direccionamiento y banderas que cualquier lectura del manual. El valor está en el proceso, y conviene decirlo sin adornos en lugar de fabricar un argumento de rendimiento que las mediciones no sostienen.

**El techo real es la vectorización.** NEON procesa cuatro enteros de 32 bits por instrucción [8], y existen redes de ordenamiento vectorizadas que superan a cualquier versión escalar por un margen amplio. Pero burbuja e inserción son algoritmos intrínsecamente secuenciales —cada paso depende del resultado del anterior— y no se vectorizan de forma natural. Esa es la barrera estructural: no se trata de escribir el escalar más pulido posible, sino de que el algoritmo mismo impide el paralelismo.

**El caso embebido sí sostiene a inserción.** En un microcontrolador con 32 KB de flash, ordenando lecturas de sensores en lotes de veinte, inserción es defendible: veinte instrucciones frente a los cientos de bytes que ocupa una implementación completa de *quicksort*, sin recursión, sin pila que desborde, con comportamiento temporal predecible. En sistemas de tiempo real, la ausencia de recursión y la cota determinista importan más que el caso promedio.

**La elección entre `B.LE` y `CSEL` no tiene respuesta única.** Depende de la distribución de los datos y de la microarquitectura concreta. Cualquier afirmación categórica sobre cuál es mejor, hecha sin medir en el núcleo objetivo, es una suposición disfrazada de conclusión.

**Sobre el burbuja.** Astrachan [9] argumenta que ni siquiera debería enseñarse: inserción lo domina en escrituras, en datos casi ordenados y en simplicidad conceptual, y no tiene ninguna ventaja compensatoria. Mi postura, tras implementar ambos, es que el burbuja conserva un valor didáctico —la bandera `swapped` es un buen ejemplo de salida temprana, y el límite decreciente ilustra bien cómo un invariante se traduce en código—, pero como algoritmo a emplear en un sistema real no hay caso en que sea la elección correcta.

---

## 4. Conclusiones

Implementar burbuja e inserción en AArch64 confirmó lo que el análisis asintótico anticipa —ambos son Θ(n²), ambos son estables— y reveló lo que ese análisis oculta: la diferencia práctica entre ambos está en el número de escrituras a memoria, no en el conteo de comparaciones. Inserción desplaza donde burbuja intercambia, y esa sola diferencia le da una ventaja consistente en datos aleatorios.

A nivel de arquitectura, el ejercicio dejó tres lecciones concretas. La primera es que el direccionamiento con desplazamiento escalado (`[x0, x3, lsl #2]`) elimina cálculos de dirección que en C quedan invisibles. La segunda es que AAPCS64 no es burocracia: entenderlo permitió reconocer que ambas rutinas son funciones hoja sin necesidad de prólogo, ahorrando accesos a pila en cada llamada. La tercera es que el costo de un salto mal predicho puede superar al de la comparación que lo origina, lo que convierte a `CSEL` en una alternativa real —aunque no universalmente mejor— frente a la bifurcación.

La comparación contra GCC fue la parte más instructiva y la más humillante. Ganarle a `-O0` es trivial e irrelevante; igualar a `-O2` es difícil y superarlo, en este problema, prácticamente imposible. El compilador aplica de forma sistemática transformaciones que a mano hay que recordar una por una. Esto no invalida el aprendizaje del ensamblador: lo reubica. Su lugar hoy no es competir con el compilador en código ordinario, sino leer lo que el compilador produce, trabajar donde el compilador no llega y entender por qué el hardware se comporta como se comporta.

---

## 5. Bibliografía

[1] Arm Ltd., *Arm Architecture Reference Manual for A-profile Architecture*, Doc. DDI 0487, Arm Ltd., Cambridge, U.K., 2024.

[2] Arm Ltd., *Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64)*, Arm Ltd., Cambridge, U.K., 2024. [En línea]. Disponible: https://github.com/ARM-software/abi-aa

[3] D. A. Patterson y J. L. Hennessy, *Computer Organization and Design: The Hardware/Software Interface, ARM Edition*. Cambridge, MA, EE.UU.: Morgan Kaufmann, 2017.

[4] T. H. Cormen, C. E. Leiserson, R. L. Rivest y C. Stein, *Introduction to Algorithms*, 4a ed. Cambridge, MA, EE.UU.: MIT Press, 2022.

[5] D. E. Knuth, *The Art of Computer Programming, Vol. 3: Sorting and Searching*, 2a ed. Reading, MA, EE.UU.: Addison-Wesley, 1998.

[6] Arm Ltd., *Arm Cortex-A72 Software Optimization Guide*, Doc. UAN 0016A, Arm Ltd., Cambridge, U.K., 2015.

[7] Free Software Foundation, *Using the GNU Compiler Collection (GCC)*, Boston, MA, EE.UU.: FSF, 2024. [En línea]. Disponible: https://gcc.gnu.org/onlinedocs/

[8] Arm Ltd., *Arm Neon Programmer's Guide for Armv8-A*, Arm Ltd., Cambridge, U.K., 2020.

[9] O. Astrachan, "Bubble sort: An archaeological algorithmic analysis," en *Proc. 34th SIGCSE Tech. Symp. Computer Science Education*, Reno, NV, EE.UU., 2003, pp. 1–5.

[10] IEEE/Open Group, *IEEE Standard for Information Technology—Portable Operating System Interface (POSIX)*, IEEE Std 1003.1-2017, 2018.
