
# Efecto de la Caché L1/L2: Recorrido de Matrices por Filas frente a Columnas

## 1. Introducción
En la arquitectura de computadoras moderna, existe una brecha significativa entre la velocidad de procesamiento de la CPU y la velocidad de acceso a la memoria principal (DRAM), fenómeno conocido como la *Memory Wall*. Para mitigar este cuello de botella, los procesadores emplean una jerarquía de memoria caché (L1, L2, L3) rápida pero de menor capacidad. 

El rendimiento de la ejecución de algoritmos numéricos depende fuertemente de los patrones de acceso a la memoria. Este documento analiza cómo el orden de recorrido de una matriz bidimensional (por filas versus por columnas) impacta en la eficiencia de la caché L1/L2 debido a los principios de **localidad espacial y temporal**, la estructura de las líneas de caché y los mecanismos de prebusqueda de hardware (*hardware prefetching*).

---

## 2. Fundamentos de Arquitectura de Memoria y Caché

### Jerarquía y Organización de la Caché
Las memorias caché operan bajo el principio de transferencia por bloques de datos denominados **Líneas de Caché** (*Cache Lines*), los cuales típicamente tienen un tamaño de 64 bytes. 

* **Caché L1:** Es la más rápida, integrada directamente en el núcleo del procesador, con tiempos de acceso de 1 a 5 ciclos de reloj y capacidades habituales entre 32 KB y 64 KB por núcleo.
* **Caché L2:** Ligeramente más lenta que la L1 (10 a 20 ciclos de reloj), con tamaños de 256 KB a 1 MB por núcleo.
* **Memoria Principal (DRAM):** Acceso significativamente más lento (100 a 300 ciclos de reloj).

### Principios de Localidad
1. **Localidad Temporal:** Si un dato es accedido, es probable que vuelva a ser accedido en un futuro cercano.
2. **Localidad Espacial:** Si un dato en la dirección $X$ es accedido, es altamente probable que los datos en direcciones adyacentes ($X + 1$, $X + 2$) sean accedidos pronto.

---

## 3. Disposición en Memoria y Patrones de Recorrido

En lenguajes de bajo nivel como C o C++, las matrices bidimensionales se almacenan en un espacio contiguo de memoria lineal siguiendo el orden **Row-Major** (orden por filas).

Dado un arreglo `int A[N][M]`, el elemento `A[i][j]` se ubica en la dirección física:

$$\text{Dirección} = \text{Base} + (i \times M + j) \times \text{sizeof(int)}$$

### A. Recorrido por Filas (*Row-Major Order*)
En un recorrido por filas, los elementos adyacentes en el bucle interno (`A[i][j]` y `A[i][j+1]`) son adyacentes en la memoria.

```c
// Recorrido Eficiente por Filas
for (int i = 0; i < N; i++) {
    for (int j = 0; j < M; j++) {
        sum += A[i][j];
    }
}
```
* **Comportamiento de la Caché:**  
  Al acceder a `A[i][0]`, se produce un *Cache Miss* (fallo de caché). El procesador carga la línea completa de 64 bytes (16 enteros de 4 bytes). Los siguientes 15 accesos (`A[i][1]` a `A[i][15]`) resultan en *Cache Hits* (aciertos). La tasa teórica de fallos para este caso es de solo $\frac{1}{16} \approx 6.25\%$.

### B. Recorrido por Columnas (*Column-Major Order*)

En un recorrido por columnas, el bucle interno itera sobre el primer índice (`A[i][j]` a `A[i+1][j]`).

```c
// Recorrido Ineficiente por Columnas
for (int j = 0; j < M; j++) {
    for (int i = 0; i < N; i++) {
        sum += A[i][j];
    }
}
```
---
* **Comportamiento de la Caché:**  
  Cada acceso salta $M \times \text{sizeof(int)}$ bytes. Si $M$ es suficientemente grande, el siguiente elemento estará fuera de la línea de caché cargada. Esto provoca un *Cache Miss* en casi cada iteración ($100\%$ de fallos) y causa *Cache Thrashing*, desalojando líneas que aún podrían ser útiles.

---
## 4. Análisis Comparativo de Rendimiento

A continuación se resume la diferencia entre ambos enfoques para una matriz de $4096 \times 4096$ enteros de 32 bits ($64\text{ MB}$ totales, superando la capacidad de L1 y L2):

| Métrica / Parámetro | Recorrido por Filas (Row-Major) | Recorrido por Columnas (Column-Major) |
| :--- | :--- | :--- |
| **Patrón de Acceso** | Secuencial (Contiguo) | Zancada (*Stride*) de $M \times 4$ bytes |
| **Aprovechamiento de Línea de Caché** | $100\%$ (16/16 enteros usados) | $\approx 6.25\%$ (1/16 enteros usados) |
| **Tasa de L1 Data Misses** | Baja ($\approx 6.25\%$) | Extremadamente alta ($\approx 100\%$) |
| **Uso de Hardware Prefetcher** | Muy efectivo (patrón predecible) | Ineficaz o con tasa de aciertos nula |
| **Tiempo de Ejecución Relativo** | $1.0\times$ (Línea base rápida) | $5.0\times$ a $10.0\times$ más lento |

---
## 5. Discusión Crítica e Impacto Práctico

La diferencia de rendimiento no es únicamente un concepto teórico; impacta directamente en la optimización de código en áreas como procesamiento de imágenes, redes neuronales y computación científica.

1. **Optimización del Compilador:** Aunque los compiladores modernos como GCC (`-O3`) realizan *Loop Interchanging* (intercambio de bucles) cuando pueden verificar que no hay dependencias de datos, en algoritmos complejos o punteros con alias no pueden asumir estos cambios, dejando la responsabilidad al desarrollador.
2. **Estrategias de Mitigación (Tiling / Blocking):** Cuando el acceso por columnas o no contiguo es inevitable (como en la transposición de matrices o multiplicación GEMM), se implementa la técnica de *Tiling* (bloqueo), dividiendo la matriz en submatrices pequeñas que quepan completamente en la caché L1/L2 para maximizar la reutilización.

---

## 6. Conclusiones

El diseño del código debe respetar la arquitectura del hardware subyacente. El recorrido por filas explota al máximo la localidad espacial y la capacidad de las líneas de caché L1/L2, reduciendo los tiempos muertos por espera de memoria. Comprender estos mecanismos permite escribir código con un rendimiento significativamente superior sin necesidad de cambiar de hardware.

---

## 7. Referencias

[1] J. L. Hennessy and D. A. Patterson, *Computer Architecture: A Quantitative Approach*, 6th ed. Cambridge, MA, USA: Morgan Kaufmann, 2017.  
[2] U. Drepper, "What Every Programmer Should Know About Memory," Red Hat, Inc., Tech. Rep., 2007. [En línea]. Disponible en: https://akkadia.org/drepper/cpumemory.pdf  
[3] R. Bryant and D. O'Hallaron, *Computer Systems: A Programmer's Perspective*, 3rd ed. Boston, MA, USA: Pearson, 2015.  
[4] Intel Corporation, "Intel® 64 and IA-32 Architectures Optimization Reference Manual," Order No. 248966-046, Apr. 2023.





