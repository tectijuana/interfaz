# Investigación Técnica: Algoritmos de Ordenamiento (Burbuja e Inserción) en Ensamblador ARM64 (AArch64)

---

## 1. Introducción y Contexto de la Arquitectura ARM64

Los algoritmos de ordenamiento cuadráticos ($O(n^2)$), como **Bubble Sort** e **Insertion Sort**, representan problemas estándar en computación para el análisis de algoritmos y la optimización de código de bajo nivel. 

Al implementarlos en la arquitectura **ARMv8-A / ARMv9-A (AArch64)**, entran en juego características fundamentales de la microarquitectura RISC moderna:
- Conjunto de instrucciones de carga/almacenamiento (*load/store architecture*).
- Modos de direccionamiento base con registro escalado por desplazamiento.
- Convención de llamadas estándar (AAPCS64: *Procedure Call Standard for the ARM 64-bit Architecture*).
- Impacto de saltos condicionales (*branch prediction*) y tráfico de memoria caché (instrucciones `ldr` y `str`).

---

## 2. Convenciones de Llamada y Modos de Direccionamiento

### 2.1 Registros Utilizados (AAPCS64)
- **`X0` – `X7`**: Registros para el paso de argumentos y valores de retorno. No se conservan entre llamadas de función (*caller-saved*).
  - `X0`: Puntero base a la matriz de datos en memoria (`int *arr`).
  - `X1`: Cantidad de elementos dentro del vector (`int n`).
- **Registros `W` vs. `X`**:
  - `Xn` (64 bits): Empleados para direcciones de memoria y punteros.
  - `Wn` (32 bits): Empleados para los elementos enteros (`int32_t`) a manipular.

### 2.2 Direccionamiento Indexado y Escalado
En C/C++, acceder a `arr[i]` donde los elementos son de 4 bytes requiere calcular la dirección:

$$\text{Dirección} = \text{base} + (i \times 4)$$

En ARM64 esto se realiza en un solo ciclo de instrucción mediante el desplazamiento aritmético lógico (`lsl #2` equivale a multiplicar por $2^2 = 4$):

```assembly
ldr w2, [x0, x1, lsl #2]    // Carga arr[x1] en w2
str w2, [x0, x1, lsl #2]    // Guarda w2 en arr[x1]
3. Algoritmo de Ordenamiento Burbuja (Bubble Sort)3.1 Fundamento TeóricoEl ordenamiento burbuja itera repetidamente por la lista, comparando pares adyacentes e intercambiándolos si están en orden inverso. Al final de la iteración $k$, el $k$-ésimo elemento mayor queda colocado en su posición definitiva.Para optimizar su desempeño a nivel de ensamblador, se incorpora una bandera booleana (swapped) que detecta si no se ejecutaron intercambios en una pasada completa, interrumpiendo el flujo tempranamente ($O(n)$ en el mejor caso).3.2 Código Ensamblador ARM64: bubble_sort.sCode snippet// ============================================================================
// Prototipo C: void bubble_sort(int *arr, int n);
// Parámetros:
//   X0: Puntero base del arreglo (arr)
//   X1: Longitud del arreglo (n)
// Registros de trabajo:
//   X2: Índice j del bucle interno
//   W3: Elemento actual arr[j]
//   W4: Elemento siguiente arr[j+1]
//   W5: Bandera de intercambio (flag swapped)
//   X6: Índice j + 1
// ============================================================================

.global bubble_sort
.type bubble_sort, %function

bubble_sort:
    cmp x1, #1
    b.le .Lbubble_exit           // Si n <= 1, ya está ordenado

    sub x1, x1, #1               // Límite superior exterior: (n - 1)

.Louter_loop:
    mov x2, #0                   // j = 0
    mov w5, #0                   // swapped = 0 (false)

.Linner_loop:
    // Carga de pares contiguos
    ldr w3, [x0, x2, lsl #2]     // w3 = arr[j]
    add x6, x2, #1               // x6 = j + 1
    ldr w4, [x0, x6, lsl #2]     // w4 = arr[j+1]

    cmp w3, w4
    b.le .Lno_swap               // Si arr[j] <= arr[j+1], no intercambiar

    // Intercambio en memoria
    str w4, [x0, x2, lsl #2]     // arr[j] = arr[j+1]
    str w3, [x0, x6, lsl #2]     // arr[j+1] = arr[j]
    mov w5, #1                   // swapped = 1 (true)

.Lno_swap:
    add x2, x2, #1               // j++
    cmp x2, x1
    b.lt .Linner_loop            // Mientras j < límite_exterior

    cbz w5, .Lbubble_exit        // Si swapped == 0, terminar ejecución
    subs x1, x1, #1              // Reducir límite (elemento mayor ya fijado)
    b.gt .Louter_loop

.Lbubble_exit:
    ret
4. Algoritmo de Ordenamiento por Inserción (Insertion Sort)4.1 Fundamento TeóricoInsertion Sort divide virtualmente la lista en una porción ordenada y una desordenada. En cada iteración, extrae un elemento clave (key) del sector desordenado y lo compara hacia atrás, desplazando los elementos mayores hacia la derecha para hacer espacio antes de colocarlo.A nivel de hardware, es considerablemente más eficiente que Bubble Sort debido a que:Mantiene el elemento key dentro de un registro del procesador sin necesidad de reescribirlo repetidamente en memoria intermedia.Reduce a la mitad las operaciones de almacenamiento (str) por desplazamiento comparado con los intercambios de dos vías.4.2 Código Ensamblador ARM64: insertion_sort.sCode snippet// ============================================================================
// Prototipo C: void insertion_sort(int *arr, int n);
// Parámetros:
//   X0: Puntero base del arreglo (arr)
//   X1: Longitud del arreglo (n)
// Registros de trabajo:
//   X2: Índice exterior i
//   W3: Valor clave (key = arr[i])
//   X4: Índice interior j
//   W5: Valor evaluado arr[j]
//   X6: Posición de desplazamiento (j + 1)
// ============================================================================

.global insertion_sort
.type insertion_sort, %function

insertion_sort:
    cmp x1, #1
    b.le .Linsert_exit           // Si n <= 1, retornar

    mov x2, #1                   // i = 1 (inicia en el segundo elemento)

.Lfor_i:
    ldr w3, [x0, x2, lsl #2]     // w3 = key (arr[i])
    sub x4, x2, #1               // x4 = j = i - 1

.Lwhile_j:
    cmp x4, #0
    b.lt .Linsert_key            // Si j < 0, alcanzamos el inicio; insertar

    ldr w5, [x0, x4, lsl #2]     // w5 = arr[j]
    cmp w5, w3
    b.le .Linsert_key            // Si arr[j] <= key, posición encontrada

    // Desplazamiento: arr[j+1] = arr[j]
    add x6, x4, #1               // x6 = j + 1
    str w5, [x0, x6, lsl #2]     // arr[j+1] = arr[j]

    sub x4, x4, #1               // j--
    b .Lwhile_j

.Linsert_key:
    add x6, x4, #1               // x6 = j + 1
    str w3, [x0, x6, lsl #2]     // arr[j+1] = key

    add x2, x2, #1               // i++
    cmp x2, x1
    b.lt .Lfor_i                 // Repetir mientras i < n

.Linsert_exit:
    ret
5. Comparativa Técnica y Análisis de RendimientoMétrica / DimensiónBubble Sort (Optimizado)Insertion SortComplejidad Temporal (Peor caso)$O(n^2)$$O(n^2)$Complejidad Temporal (Mejor caso)$O(n)$$O(n)$Complejidad Temporal (Promedio)$O(n^2)$$O(n^2)$Complejidad Espacial$O(1)$ auxiliar$O(1)$ auxiliarLecturas a Memoria (ldr)$2 \times \text{comparaciones}$$1 \times \text{comparaciones} + 1 \text{ por pasada}$Escrituras a Memoria (str)$2 \times \text{intercambios}$$1 \times \text{desplazamientos} + 1 \times \text{inserción}$Presión sobre Registros6 registros volátiles6 registros volátilesPreservación de PilaFunción hoja (leaf function), no requiere spFunción hoja (leaf function), no requiere spAnálisis Microarquitectónico:Acceso al subsistema de Caché L1D: Bubble Sort duplica la cantidad de escrituras en memoria en cada swap (arr[j] y arr[j+1]), forzando invalidaciones innecesarias en las líneas de caché. Insertion sort almacena key en el registro W3 y únicamente realiza una sola escritura str durante el desplazamiento de cada elemento.Penalización por saltos (Branch Misprediction): En Bubble Sort, la condición b.le .Lno_swap alterna con frecuencia en arreglos aleatorios, degradando el branch predictor. En Insertion Sort, el bucle interior tiende a romperse de manera más predecible si los datos presentan cierto nivel de pre-orden.6. Integración y Prueba en C (main.c)El siguiente programa permite compilar y contrastar ambas rutinas contra datos reales utilizando GCC o Clang en Linux ARM64 o macOS (Apple Silicon).C#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaración de prototipos ensamblador
extern void bubble_sort(int *arr, int n);
extern void insertion_sort(int *arr, int n);

void print_array(const char *label, const int *arr, int n) {
    printf("%s: [", label);
    for (int i = 0; i < n; i++) {
        printf("%d%s", arr[i], (i == n - 1) ? "" : ", ");
    }
    printf("]\n");
}

int main(void) {
    int data1[] = {64, 34, 25, 12, 22, 11, 90, -5, 0, 42};
    int data2[] = {64, 34, 25, 12, 22, 11, 90, -5, 0, 42};
    int n = sizeof(data1) / sizeof(data1[0]);

    printf("--- Pruebas de Ordenamiento en Ensamblador ARM64 ---\n\n");

    print_array("Original", data1, n);

    bubble_sort(data1, n);
    print_array("Bubble Sort   ", data1, n);

    insertion_sort(data2, n);
    print_array("Insertion Sort", data2, n);

    return 0;
}
Instrucciones de Compilación y EjecuciónBash# Ensamblado y enlazado con GCC
gcc -O2 -c bubble_sort.s -o bubble_sort.o
gcc -O2 -c insertion_sort.s -o insertion_sort.o
gcc -O2 main.c bubble_sort.o insertion_sort.o -o sort_runner

# Ejecución
./sort_runner
7. ConclusionesManejo de registros escalados: ARM64 cuenta con direccionamiento base más registro con desplazamiento arbitrario ([x0, xN, lsl #2]), lo que elimina la necesidad de calcular manualmente multiplicaciones de punteros con instrucciones adicionales (mul o lsl aisladas).Eficiencia de las funciones hoja: Dado que ninguno de los dos algoritmos realiza llamadas anidadas a otras subrutinas, no es obligatorio reservar espacio en la pila para el frame pointer (X29) ni para el link register (X30), reduciendo el prólogo y epílogo a una simple instrucción ret.Prevalencia de Inserción: A pesar de compartir la misma clase de complejidad asintótica cuadrática, Insertion Sort es consistentemente superior a Bubble Sort en sistemas embebidos y de propósito general basados en ARM64, debido a su menor tasa de escrituras a memoria y retención óptima de variables temporales en banco de registros.
