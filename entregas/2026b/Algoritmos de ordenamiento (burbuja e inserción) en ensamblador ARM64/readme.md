# Algoritmos de Ordenamiento en Ensamblador ARM64 (AArch64): Burbuja e Inserción

---

## 1. Fundamentos de la Arquitectura ARM64 Relevantes

El desarrollo de algoritmos de bajo nivel en AArch64 depende del aprovechamiento de su modelo de ejecución y convenciones de llamada (*ABI*):

* **Registros de Propósito General:**
* **`X0` – `X7`:** Paso de parámetros de entrada y retorno de resultados. Para manipular arreglos, por estándar `X0` recibe el puntero base (`int *arr`) y `X1` el tamaño total (`int64_t n`).
* **Vistas de Registro (`Wn` vs `Xn`):** Un entero estándar con signo de 32 bits (`int32_t`) se carga y opera sobre la mitad inferior del registro (`Wn`), mientras que punteros, direcciones efectivas e índices de tamaño completo emplean el registro de 64 bits (`Xn`).


* **Modos de Direccionamiento Indexados:**
* La instrucción `LDR Wd, [Xn, Xm, LSL #2]` calcula la dirección en un solo ciclo: multiplica el índice contenido en `Xm` por 4 (desplazamiento lógico de 2 bits a la izquierda, equivalente al tamaño en bytes de un `int32_t`) y lo suma a la dirección base `Xn`.


* **Control de Flujo:**
* `CMP` evalúa la resta aritmética sin almacenar el resultado, actualizando las banderas de condición del registro `NZCV` (Negative, Zero, Carry, oVerflow).
* `B.<cond>` realiza saltos condicionales (`B.GT`, `B.LE`, `B.GE`, `B.LT`, etc.).
* `RET` realiza el retorno de subrutina cargando la dirección del *Link Register* (`X30`/`LR`).



---

## 2. Ordenamiento Burbuja (Bubble Sort)

El algoritmo recorre secuencialmente el arreglo comparando pares de elementos continuos (`arr[j]` y `arr[j+1]`) e intercambiándolos si se encuentran fuera de orden. Al término de cada iteración exterior, el elemento más grande queda asentado en su posición final.

### Código en C de Referencia

```c
void bubble_sort(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

```

### Implementación en Ensamblador ARM64 (`bubble_sort.s`)

```assembly
// Firma en C: void bubble_sort(int *arr, int64_t n);
// Parámetros:
//   X0: Puntero base del arreglo (int*)
//   X1: Cantidad de elementos n (int64_t)

.global bubble_sort
.text
.align 2

bubble_sort:
    CMP     X1, #1
    BLE     .L_bubble_exit         // Si n <= 1, el arreglo ya está ordenado

    MOV     X2, #0                 // X2 = i (índice bucle exterior)

.L_outer_loop:
    SUB     X3, X1, #1             // X3 = n - 1
    CMP     X2, X3
    BGE     .L_bubble_exit         // Terminar si i >= n - 1

    MOV     X4, #0                 // X4 = j (índice bucle interior)

.L_inner_loop:
    SUB     X5, X3, X2             // X5 = (n - 1) - i (límite del bucle interior)
    CMP     X4, X5
    BGE     .L_inner_next          // Si j >= (n - 1 - i), pasar al siguiente i

    // Cargar arr[j] en W6 y arr[j + 1] en W7
    LDR     W6, [X0, X4, LSL #2]   // W6 = arr[j]
    ADD     X8, X4, #1             // X8 = j + 1
    LDR     W7, [X0, X8, LSL #2]   // W7 = arr[j + 1]

    CMP     W6, W7
    BLE     .L_no_swap             // Si arr[j] <= arr[j + 1], no intercambiar

    // Intercambio en memoria (Swap)
    STR     W7, [X0, X4, LSL #2]   // arr[j] = W7
    STR     W6, [X0, X8, LSL #2]   // arr[j + 1] = W6

.L_no_swap:
    ADD     X4, X4, #1             // j++
    B       .L_inner_loop

.L_inner_next:
    ADD     X2, X2, #1             // i++
    B       .L_outer_loop

.L_bubble_exit:
    RET

```

---

## 3. Ordenamiento por Inserción (Insertion Sort)

Divide conceptualmente el arreglo en una sección ordenada y otra por ordenar. En cada paso toma el primer elemento no clasificado (`key`), busca de forma descendente su posición correcta desplazando los elementos mayores hacia la derecha e inserta el valor en la brecha resultante.

### Código en C de Referencia

```c
void insertion_sort(int *arr, int n) {
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}

```

### Implementación en Ensamblador ARM64 (`insertion_sort.s`)

```assembly
// Firma en C: void insertion_sort(int *arr, int64_t n);
// Parámetros:
//   X0: Puntero base del arreglo (int*)
//   X1: Cantidad de elementos n (int64_t)

.global insertion_sort
.text
.align 2

insertion_sort:
    CMP     X1, #1
    BLE     .L_insert_exit         // Si n <= 1, no requiere procesamiento

    MOV     X2, #1                 // X2 = i (inicia en el segundo elemento, índice 1)

.L_ins_outer_loop:
    CMP     X2, X1
    BGE     .L_insert_exit         // Terminar si i >= n

    // Cargar clave: key = arr[i]
    LDR     W3, [X0, X2, LSL #2]   // W3 = key
    
    // Inicializar j = i - 1
    SUB     X4, X2, #1             // X4 = j

.L_ins_while_loop:
    // Condición 1: j >= 0
    CMP     X4, #0
    BLT     .L_ins_place_key

    // Cargar arr[j]
    LDR     W5, [X0, X4, LSL #2]   // W5 = arr[j]

    // Condición 2: arr[j] > key
    CMP     W5, W3
    BLE     .L_ins_place_key

    // Desplazar elemento: arr[j + 1] = arr[j]
    ADD     X6, X4, #1             // X6 = j + 1
    STR     W5, [X0, X6, LSL #2]

    SUB     X4, X4, #1             // j--
    B       .L_ins_while_loop

.L_ins_place_key:
    // Insertar la clave en su lugar: arr[j + 1] = key
    ADD     X6, X4, #1             // X6 = j + 1
    STR     W3, [X0, X6, LSL #2]

    ADD     X2, X2, #1             // i++
    B       .L_ins_outer_loop

.L_insert_exit:
    RET

```

---

## 4. Análisis Comparativo y Consideraciones Microarquitectónicas

| Propiedad | Bubble Sort | Insertion Sort |
| --- | --- | --- |
| **Complejidad Temporal (Mejor caso)** | $O(n^2)$ *(o $O(n)$ si se incluye flag de cambio)* | $O(n)$ *(datos ya ordenados)* |
| **Complejidad Temporal (Peor caso)** | $O(n^2)$ | $O(n^2)$ |
| **Complejidad Espacial** | $O(1)$ | $O(1)$ |
| **Operaciones `STR` por Iteración** | 2 escrituras por cada inversión | 1 escritura por desplazamiento + 1 para la clave |
| **Uso de Registros de Propósito General** | 8 (`X0-X5`, `W6`, `W7`, `X8`) | 7 (`X0-X4`, `W3`, `W5`, `X6`) |
| **Estabilidad** | Estable | Estable |

### Impacto en el Hardware ARM64

* **Caché y Ancho de Banda de Memoria:** Insertion Sort es notablemente superior en microarquitecturas modernas (Neoverse, Cortex-A o Apple Silicon) debido al patrón de accesos a memoria. Mientras que Bubble Sort satura la cola de almacenamiento (*Store Buffer*) ejecutando dos instrucciones `STR` continuas por cada intercambio, Insertion Sort únicamente escribe una vez por elemento desplazado y retiene la clave de comparación en un registro de alta velocidad (`W3`) hasta ubicar la celda de destino.
* **Predicción de Saltos (*Branch Prediction*):** En arreglos parcialmente ordenados, el bucle `while` de Insertion Sort aprovecha el *Branch Target Buffer* (BTB) terminando de inmediato sin evaluar todas las parejas restantes, reduciendo fallos en el *pipeline* del procesador.

---

## 5. Arnés de Prueba y Compilación (C + ARM64)

### Programa de Verificación (`main.c`)

```c
#include <stdio.h>
#include <stdint.h>

extern void bubble_sort(int *arr, int64_t n);
extern void insertion_sort(int *arr, int64_t n);

void imprimir_arreglo(const char *titulo, int *arr, int64_t n) {
    printf("%s: [", titulo);
    for (int64_t i = 0; i < n; i++) {
        printf("%d%s", arr[i], (i == n - 1) ? "" : ", ");
    }
    printf("]\n");
}

int main(void) {
    int datos_bubble[] = {64, 34, 25, 12, 22, 11, 90, -5};
    int64_t n_bubble = sizeof(datos_bubble) / sizeof(datos_bubble[0]);

    int datos_insert[] = {45, -2, 10, 89, 0, 23, 7, -15};
    int64_t n_insert = sizeof(datos_insert) / sizeof(datos_insert[0]);

    printf("--- Verificación de Algoritmos en ARM64 ---\n");

    imprimir_arreglo("Burbuja (Original)", datos_bubble, n_bubble);
    bubble_sort(datos_bubble, n_bubble);
    imprimir_arreglo("Burbuja (Ordenado)", datos_bubble, n_bubble);

    printf("\n");

    imprimir_arreglo("Inserción (Original)", datos_insert, n_insert);
    insertion_sort(datos_insert, n_insert);
    imprimir_arreglo("Inserción (Ordenado)", datos_insert, n_insert);

    return 0;
}

```

### Comandos de Compilación y Ejecución

Para compilar y enlazar en una máquina con Linux/ARM64 (o macOS en terminal con Clang):

```bash
# Compilar los archivos en ensamblador y el ejecutable principal con GCC
gcc -O2 -c bubble_sort.s -o bubble_sort.o
gcc -O2 -c insertion_sort.s -o insertion_sort.o
gcc -O2 main.c bubble_sort.o insertion_sort.o -o test_sorting

# Ejecutar el binario
./test_sorting

```

En caso de trabajar mediante compilación cruzada desde una arquitectura x86_64:

```bash
aarch64-linux-gnu-gcc -static main.c bubble_sort.s insertion_sort.s -o test_sorting
qemu-aarch64 ./test_sorting

```
