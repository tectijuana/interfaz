

 
# Subrutinas y Paso de Parámetros en ARM64 (Raspberry Pi 5)

## Contenidos
1. [La Pila y las Instrucciones ldm y stm](#la-pila-y-las-instrucciones-ldm-y-stm)
2. [Convención de llamadas AAPCS](#convención-de-llamadas-aapcs)
3. [Funciones en ensamblador llamadas desde C](#funciones-en-ensamblador-llamadas-desde-c)
4. [Funciones en ensamblador llamadas desde ensamblador](#funciones-en-ensamblador-llamadas-desde-ensamblador)
5. [Funciones recursivas](#funciones-recursivas)
6. [Funciones con muchos parámetros de entrada](#funciones-con-muchos-parámetros-de-entrada)
7. [Ejercicios prácticos](#ejercicios-prácticos)

---

## La Pila y las Instrucciones ldm y stm

En ARM64, la **pila** (stack) es una estructura de datos que se utiliza para almacenar temporalmente datos, como los valores de los registros durante una subrutina o los parámetros de una función.

### La pila se maneja con dos instrucciones principales:
1. **`ldm`** (Load Multiple): Carga múltiples registros desde la memoria.
2. **`stm`** (Store Multiple): Guarda múltiples registros en la memoria.

### Ejemplo:
```assembly
// Guardar registros en la pila
stmdb sp!, {x0, x1, x2, x3}   // Guarda x0, x1, x2, x3 en la pila (decrementa el puntero de pila)

// Recuperar registros de la pila
ldmia sp!, {x0, x1, x2, x3}   // Carga x0, x1, x2, x3 desde la pila (incrementa el puntero de pila)
```

En ARM64, el puntero de pila (`sp`) es siempre manejado en decrementos de 16 bytes, lo que permite un uso más eficiente de la memoria.

---

## Convención de llamadas AAPCS

La **AAPCS** (ARM Architecture Procedure Call Standard) define cómo deben manejarse las llamadas a subrutinas en ARM64. Esto incluye reglas para el uso de los registros y cómo se deben pasar los parámetros y devolver valores.

### Principales reglas de AAPCS:
1. **Registros de propósito general** (`x0` - `x7`): Se utilizan para pasar hasta 8 parámetros a una función.
2. **Registros de retorno** (`x0`, `x1`): Se utilizan para devolver hasta dos valores desde una función.
3. **Registros temporales** (`x9` - `x15`): Pueden ser usados dentro de funciones sin necesidad de preservarlos.
4. **Registros callee-saved** (`x19` - `x30`): Si una función modifica estos registros, debe restaurar su valor original antes de retornar.

### Ejemplo de paso de parámetros:
```assembly
.global mi_funcion

mi_funcion:
    // Supongamos que x0 y x1 contienen los parámetros de entrada
    add x2, x0, x1    // Sumar los dos parámetros
    mov x0, x2        // Guardar el resultado en x0 (valor de retorno)
    ret               // Retornar a la función que hizo la llamada
```

En este ejemplo, `mi_funcion` recibe dos parámetros en `x0` y `x1`, los suma y retorna el resultado en `x0`.

---

## Funciones en ensamblador llamadas desde C

Cuando se llama a una función escrita en ensamblador desde un programa en C, el compilador sigue las mismas reglas de la convención AAPCS para pasar parámetros y obtener el valor de retorno.

### Ejemplo en C:
```c
#include <stdio.h>

extern int suma(int a, int b);  // Declaración de la función ensamblador

int main() {
    int resultado = suma(5, 7);
    printf("Resultado: %d\n", resultado);
    return 0;
}
```

### Código en ensamblador (suma.s):
```assembly
.global suma

suma:
    add x0, x0, x1    // Sumar los parámetros (a en x0, b en x1)
    ret               // Retornar el resultado en x0
```

### Compilación y enlace:
Para compilar este programa, debes ensamblar el código en ensamblador y luego enlazarlo con el código en C:

```bash
as -o suma.o suma.s
gcc -o programa main.c suma.o
```

---

## Funciones en ensamblador llamadas desde ensamblador

Una función en ensamblador puede llamar a otra función utilizando las mismas convenciones de paso de parámetros y retorno de valores. La instrucción principal para llamar a funciones es **`bl`** (Branch with Link), que guarda la dirección de retorno en el registro **LR** (Link Register).

### Ejemplo:
```assembly
.global funcion_principal

funcion_principal:
    mov x0, #5        // Primer parámetro
    mov x1, #10       // Segundo parámetro
    bl suma           // Llamar a la función suma
    // El resultado de la suma está ahora en x0
    ret

suma:
    add x0, x0, x1    // Sumar los parámetros
    ret
```

---

## Funciones recursivas

Las **funciones recursivas** son aquellas que se llaman a sí mismas. En ARM64, es fundamental usar la pila para almacenar los registros y los valores de retorno intermedios.

### Ejemplo: Factorial recursivo
```assembly
.global factorial

factorial:
    cmp x0, #1        // Comparar si x0 (n) es igual a 1
    b.le fin_recursion // Si n <= 1, terminar la recursión
    sub x0, x0, #1    // n = n - 1
    bl factorial      // Llamada recursiva
    mul x0, x0, x1    // Multiplicar el resultado por n
    ret

fin_recursion:
    mov x0, #1        // Retornar 1 si n <= 1
    ret
```

---

## Funciones con muchos parámetros de entrada

Cuando una función recibe más de 8 parámetros (los que caben en los registros `x0` a `x7`), los parámetros adicionales se pasan a través de la pila.

### Ejemplo:
```assembly
.global funcion_muchos_parametros

funcion_muchos_parametros:
    // x0 - x7 contienen los primeros 8 parámetros
    // Los parámetros adicionales están en la pila
    ldr x8, [sp, #0]    // Cargar el noveno parámetro desde la pila
    ldr x9, [sp, #8]    // Cargar el décimo parámetro desde la pila
    // Resto de la función
    ret
```

Para acceder a los parámetros en la pila, se utiliza la instrucción `ldr` con un desplazamiento desde el puntero de pila (`sp`).

---

## Ejercicios prácticos

### Ejercicio 1: Suma de N números

Escribe una subrutina en ensamblador que reciba un valor `N` y retorne la suma de los números del 1 al `N` utilizando recursión.

#### Pseudocódigo:
1. Si `N` es menor o igual a 1, retorna `N`.
2. Si no, llama a la subrutina recursivamente con `N-1` y suma el valor de `N`.

### Ejercicio 2: Potencia de un número

Escribe una subrutina que calcule la potencia de un número `a^b` utilizando multiplicaciones sucesivas.

#### Pseudocódigo:
1. Si `b == 0`, retorna 1.
2. Si no, multiplica `a` por la potencia de `a^(b-1)`.

### Ejercicio 3: Llamadas a funciones en C

Implementa una función en C que calcule el máximo de tres números y usa una función en ensamblador para realizar la comparación de los números.

---

### Conclusión

En este capítulo, hemos explorado el manejo de **subrutinas** y el **paso de parámetros** en ARM64, así como la interacción entre **C y ensamblador**. Comprender cómo se gestionan los registros, la pila y las convenciones de llamada es crucial para escribir código eficiente y modular en ensamblador, especialmente en sistemas avanzados como la **Raspberry Pi 5**.
```
