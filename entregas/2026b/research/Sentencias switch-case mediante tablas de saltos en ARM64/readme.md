# Sentencias `switch/case` mediante tablas de saltos en ARM64 (AArch64)

## 1. Introducción

La sentencia `switch/case` es una estructura de control utilizada en lenguajes de programación como C y C++ para seleccionar una ruta de ejecución a partir del valor de una expresión. Aunque su representación en el código fuente es sencilla, su implementación a nivel de máquina puede variar considerablemente dependiendo del compilador, la arquitectura del procesador y las características de los casos evaluados.

Una estrategia de implementación consiste en transformar la sentencia `switch` en una secuencia de comparaciones condicionales, equivalente a una estructura de `if-else`. En este enfoque, el procesador compara el valor de entrada con diferentes constantes hasta encontrar una coincidencia o alcanzar el caso predeterminado. Aunque esta solución resulta adecuada para pocos casos o valores dispersos, el número de comparaciones puede aumentar conforme crece la cantidad de alternativas.

Como alternativa, los compiladores pueden utilizar una **tabla de saltos (*jump table*)**, que almacena direcciones o desplazamientos hacia los bloques de código asociados a cada caso. En lugar de realizar una comparación individual para cada alternativa, el programa calcula un índice a partir del valor de entrada, consulta la tabla y transfiere directamente el control al bloque correspondiente.

En ARM64, también denominada AArch64, esta optimización es especialmente interesante debido a las instrucciones de carga de memoria, cálculo de direcciones y transferencia indirecta de control disponibles en su conjunto de instrucciones. Instrucciones como `ADRP`, `ADD`, `LDRSW` y `BR` permiten construir una secuencia eficiente para localizar una tabla, recuperar el desplazamiento correspondiente y ejecutar el caso seleccionado.

El propósito de esta investigación es explicar el mecanismo de las tablas de saltos en AArch64, analizar su traducción desde C hacia ensamblador y examinar los factores que influyen en su rendimiento y selección por parte del compilador.

---

## 2. Desarrollo técnico

### 2.1. Fundamento teórico de las tablas de saltos

Una tabla de saltos es una estructura de datos utilizada para implementar transferencias de control a múltiples destinos. En una sentencia `switch`, cada entrada representa un caso o una posición dentro del rango de valores considerado por el compilador.

Cuando el compilador determina que una tabla de saltos es conveniente, transforma la expresión de selección en un índice. Si los valores de los casos son consecutivos, el índice puede obtenerse mediante una resta respecto al valor mínimo del rango.

Por ejemplo, para los casos `case 0`, `case 1`, `case 2`, `case 3` y `case 4`, el valor de entrada puede utilizarse directamente como índice. Sin embargo, si los casos comienzan en 10, el compilador podría calcular `índice = valor - 10`.

La implementación normalmente requiere tres operaciones principales:

1. **Validación del índice:** verificar que el valor de entrada pertenece al rango contemplado por la tabla.
2. **Consulta de la tabla:** cargar el desplazamiento o dirección correspondiente al caso seleccionado.
3. **Transferencia de control:** utilizar el resultado de la consulta para saltar al bloque de instrucciones asociado.

En AArch64, la tabla puede contener direcciones absolutas, pero una implementación frecuente utiliza desplazamientos relativos a una dirección base. Esta alternativa reduce el tamaño de cada entrada y puede facilitar la generación de código independiente de la posición (*Position Independent Code*, PIC).

Por ejemplo, si cada entrada almacena un desplazamiento de 32 bits, una tabla de ocho casos ocupa 32 bytes, sin considerar alineación adicional. Si se almacenaran direcciones de 64 bits, las mismas ocho entradas ocuparían 64 bytes.

Es importante señalar que la tabla no contiene necesariamente el código de cada caso. Habitualmente contiene referencias a etiquetas que identifican los bloques de instrucciones dentro de la función.

### 2.2. Instrucciones ARM64 involucradas

Las siguientes instrucciones son relevantes para la implementación de tablas de saltos en AArch64:

| Instrucción | Función                                                                                                                                                       |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ADRP`      | Calcula una dirección relativa a la página de 4 KiB de una etiqueta, permitiendo acceder a datos o código dentro de un rango amplio.                          |
| `ADD`       | Realiza sumas entre registros o incorpora un desplazamiento inmediato. Puede utilizarse para ajustar el índice o completar una dirección.                     |
| `LDR`       | Carga un dato desde memoria. En tablas de saltos, puede recuperar una entrada o un desplazamiento.                                                            |
| `LDRSW`     | Carga un entero de 32 bits desde memoria y lo extiende con signo a 64 bits. Es útil cuando las entradas de la tabla son desplazamientos relativos de 32 bits. |
| `BR`        | Transfiere el control a la dirección contenida en un registro, sin establecer una dirección de retorno como lo haría `BLR`.                                   |
| `CMP`       | Compara dos operandos, actualizando las banderas del registro de estado.                                                                                      |
| `B.HI`      | Salta si la condición de comparación sin signo es “mayor que”. Puede emplearse para descartar índices fuera del rango.                                        |
| `SUB`       | Resta valores; puede normalizar el índice cuando los casos comienzan en un valor distinto de cero.                                                            |

Una secuencia común utiliza `ADRP` y `ADD` para formar la dirección base de la tabla. Después, `LDRSW` recupera el desplazamiento asociado al índice. La instrucción `ADD` suma ese desplazamiento a la dirección base de los destinos, y `BR` transfiere la ejecución al bloque seleccionado.

El uso de desplazamientos relativos requiere que la tabla y las etiquetas se interpreten con respecto a la misma base definida por el compilador. Por ello, el código ensamblador debe analizarse junto con las directivas y etiquetas que describen la tabla.

### 2.3. Ejemplo práctico en lenguaje C

El siguiente programa contiene una sentencia `switch` con cinco casos consecutivos y una alternativa predeterminada:

```c
// example.c
#include <stdio.h>

int seleccionar(int opcion) {
    switch (opcion) {
        case 0: return 100;
        case 1: return 200;
        case 2: return 300;
        case 3: return 400;
        case 4: return 500;
        default: return -1;
    }
}

int main(void) {
    printf("%d\n", seleccionar(3));
    return 0;
}
```

En este ejemplo, los casos son consecutivos y cubren un rango pequeño. Por ello, el compilador podría considerar una tabla de saltos como estrategia de implementación.

No obstante, debido a que cada caso retorna una constante, un compilador optimizador también podría sustituir la estructura por una tabla de datos, una secuencia de comparaciones o una combinación de operaciones aritméticas y condicionales. La traducción concreta depende del compilador y de sus opciones de optimización.

### 2.4. Traducción ilustrativa a ensamblador ARM64

El siguiente fragmento representa una **implementación ilustrativa de una tabla de saltos en AArch64**, utilizando desplazamientos relativos de 32 bits. No debe interpretarse como una salida garantizada de GCC o Clang para el ejemplo anterior.

```asm
// example.s
// Sintaxis GNU AArch64.
// Fragmento ilustrativo de una tabla de saltos.

seleccionar:
    cmp     w0, #4
    b.hi    .Ldefault       // Índice fuera del rango [0, 4]

    adrp    x1, .LJTI0      // Página de la tabla
    add     x1, x1, :lo12:.LJTI0

    ldrsw   x2, [x1, w0, uxtw #2]
                            // Carga offset de 32 bits con signo
                            // índice * 4

    add     x1, x1, x2      // Dirección destino = base + offset
    br      x1              // Salto indirecto al caso

.Lcase0:
    mov     w0, #100
    ret

.Lcase1:
    mov     w0, #200
    ret

.Lcase2:
    mov     w0, #300
    ret

.Lcase3:
    mov     w0, #400
    ret

.Lcase4:
    mov     w0, #500
    ret

.Ldefault:
    mov     w0, #-1
    ret

    .p2align 2
.LJTI0:
    .word   .Lcase0 - .LJTI0
    .word   .Lcase1 - .LJTI0
    .word   .Lcase2 - .LJTI0
    .word   .Lcase3 - .LJTI0
    .word   .Lcase4 - .LJTI0
```

#### Interpretación del código

La instrucción `CMP` compara el argumento recibido en `w0` con el límite superior de la tabla. La condición `B.HI` permite desviar la ejecución al caso predeterminado cuando el valor es mayor que cuatro bajo una interpretación sin signo. Esto también descarta valores negativos representados en complemento a dos.

Posteriormente, `ADRP` y `ADD` construyen la dirección de la tabla `.LJTI0`. La instrucción `LDRSW` utiliza el índice de `w0`, escalado por cuatro bytes, para recuperar la entrada correspondiente. El desplazamiento se extiende con signo a 64 bits.

La instrucción `ADD` suma el desplazamiento recuperado a la dirección base de la tabla. Finalmente, `BR` transfiere el control a la etiqueta del caso seleccionado.

Las directivas `.word` almacenan los desplazamientos relativos de cada etiqueta. Por ejemplo, la primera entrada representa la diferencia entre `.Lcase0` y `.LJTI0`.

Este ejemplo presupone una tabla válida con cinco entradas y una distribución de casos que permite indexarla directamente. En una implementación real, el ensamblador, el enlazador y el compilador pueden utilizar otras formas de direccionamiento o disposición de las secciones.

### 2.5. Generación y verificación del ensamblador

Para observar una traducción real del código C, se puede utilizar un compilador cruzado para AArch64. Por ejemplo, con GCC:

```bash
aarch64-linux-gnu-gcc -O2 -S example.c -o example.s
```

La opción `-O2` habilita optimizaciones, pero no garantiza que el compilador genere una tabla de saltos. Si se desea examinar el código máquina de un ejecutable:

```bash
aarch64-linux-gnu-gcc -O2 example.c -o example
aarch64-linux-gnu-objdump -d example
```

La inspección del resultado permite determinar si se generó una tabla de saltos, una tabla de datos, comparaciones condicionales u otra transformación.

### 2.6. Análisis de rendimiento

El rendimiento de una tabla de saltos depende de varios factores: el número de casos, la densidad del rango, el comportamiento del predictor de saltos, la jerarquía de memoria y las optimizaciones del compilador.

En una secuencia de comparaciones, el tiempo de ejecución puede aumentar si el caso buscado aparece después de varias comparaciones. En cambio, una tabla de saltos permite seleccionar el destino mediante un índice y un acceso a memoria, evitando una cadena extensa de decisiones condicionales.

Sin embargo, una tabla de saltos no garantiza una ejecución más rápida en todas las situaciones. El acceso a la tabla puede provocar una carga adicional de memoria, y la instrucción `BR` introduce una transferencia indirecta de control cuyo destino debe ser predicho por el procesador.

Los procesadores AArch64 modernos pueden incorporar mecanismos de predicción de saltos indirectos, pero su efectividad depende del patrón de destinos. Si el programa selecciona repetidamente los mismos casos, el predictor puede aprender ese comportamiento. Si los destinos cambian de forma irregular, la predicción puede resultar menos efectiva.

La localidad también es importante. Una tabla pequeña que permanece en la caché de datos puede consultarse con un costo reducido. Una tabla grande o dispersa puede incrementar la presión sobre la caché y el ancho de banda de memoria.

### 2.7. ¿Cuándo utiliza el compilador una tabla de saltos?

Los compiladores suelen evaluar la conveniencia de una tabla de saltos mediante criterios como:

* **Densidad de casos:** una cantidad elevada de valores consecutivos favorece el uso de tablas.
* **Amplitud del rango:** un conjunto de pocos casos dispersos dentro de un rango muy amplio puede producir una tabla excesivamente grande.
* **Cantidad de alternativas:** las tablas suelen resultar más atractivas cuando existe un número suficiente de casos.
* **Tamaño del código:** una secuencia de comparaciones puede ocupar menos espacio que una tabla cuando hay pocas alternativas.
* **Costos estimados:** el compilador utiliza modelos heurísticos para estimar el equilibrio entre instrucciones, accesos a memoria y transferencias de control.
* **Posibilidades de simplificación:** si los casos devuelven constantes o comparten operaciones, el compilador puede transformar la sentencia en una expresión aritmética, una tabla de datos u otra representación.

Por ejemplo, un `switch` con casos `1`, `2`, `3`, `4` y `5` presenta una distribución compacta. En cambio, uno con casos `1`, `1000`, `5000` y `9000` puede resultar poco apropiado para una tabla indexada directamente debido al espacio desperdiciado.

En consecuencia, la tabla de saltos constituye una optimización dependiente del contexto, no una traducción obligatoria de toda sentencia `switch`.

---

## 3. Conclusiones

Las tablas de saltos representan una técnica importante para implementar estructuras de selección múltiple en arquitecturas ARM64. Su principal ventaja consiste en sustituir cadenas potencialmente extensas de comparaciones por una consulta indexada y una transferencia indirecta de control.

En AArch64, instrucciones como `ADRP`, `ADD`, `LDRSW` y `BR` permiten construir implementaciones compactas mediante desplazamientos relativos. Este mecanismo puede reducir el número de decisiones condicionales y favorecer el rendimiento cuando existe una distribución densa de casos.

Sin embargo, la optimización no es universal. Los costos de acceso a memoria, la predicción de saltos indirectos, la amplitud del rango y las transformaciones del compilador pueden hacer preferible una estrategia alternativa.

Por tanto, comprender las tablas de saltos requiere relacionar el lenguaje C, las decisiones del compilador, el conjunto de instrucciones AArch64 y el comportamiento del hardware. La inspección del ensamblador generado y la medición en condiciones controladas son necesarias para evaluar el beneficio real de esta optimización.

---

## 4. Bibliografía

[1] Arm Ltd., *Arm Architecture Reference Manual for A-profile Architecture*, documentación técnica de referencia para la arquitectura AArch64. [En línea]. Disponible en: https://developer.arm.com/documentation/ddi0487/latest

[2] Arm Ltd., *A64 Instruction Set Architecture*. [En línea]. Disponible en: https://developer.arm.com/documentation

[3] Free Software Foundation, “Options That Control Optimization,” *Using the GNU Compiler Collection (GCC)*. [En línea]. Disponible en: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html

[4] LLVM Project, “LLVM Language Reference Manual.” [En línea]. Disponible en: https://llvm.org/docs/LangRef.html

[5] Arm Ltd., *Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64)*. [En línea]. Disponible en: https://github.com/ARM-software/abi-aa

