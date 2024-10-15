
![cooltext468348822700204](https://github.com/user-attachments/assets/e51da0b4-e0ad-418a-9d77-5b5a83ed27f3)



### 1. Código ensamblador con la macro del MCD en ARM64 (Raspbian OS)

Este archivo contiene la macro **gcd** (Maximo Comun Denominador) en ensamblador y se guardará como **mcd_macro.s**:

```asm
@ Archivo: mcd_macro.s
@ Descripción: Implementación de la macro MCD para ARM64 en Raspbian OS

.macro gcd a, b
gcd_\@:                    
    cmp \a, \b         @ Comparar a y b
    subgt \a, \a, \b   @ Si a > b, restar b de a
    sublt \b, \b, \a   @ Si a < b, restar a de b
    bne gcd_\@         @ Si no son iguales, continuar
.endm

@ Función en ensamblador que calcula el MCD
@ Se compilará y se llamará desde C
.text
.globl gcd_func
.type gcd_func, %function
gcd_func:
    @ Argumentos en X0 y X1
    @ X0 = a, X1 = b
    gcd x0, x1         @ Llamar a la macro gcd con los argumentos en X0 y X1
    ret                @ Retornar el resultado en X0
```

### 2. Código en C que llama a la macro ensamblador

El código C que invocará la macro de ensamblador y se guardará como **mcd.c**:

```c
// Archivo: mcd.c
// Descripción: Programa en C que llama a una macro ensamblador en ARM64 para calcular el MCD.

#include <stdio.h>

// Declaración de la función ensambladora
extern long gcd_func(long a, long b);

int main() {
    long a = 6099;
    long b = 2166;

    // Llamar a la función ensambladora que ejecuta la macro gcd
    long result = gcd_func(a, b);

    // Imprimir el resultado
    printf("El MCD de %ld y %ld es: %ld\n", a, b, result);

    return 0;
}
```

### 3. Proceso de compilación y enlace con dos archivos en **Raspbian OS**

Ahora, en tu **Raspberry Pi con Raspbian OS ARM64**, compilarás directamente con el compilador **GCC** que ya está disponible en el sistema operativo.

#### Pasos para compilar y ejecutar:

1. **Compilar el archivo ensamblador** (`mcd_macro.s`):

   Ejecuta el siguiente comando en tu Raspberry Pi para compilar el archivo ensamblador ARM64:

   ```bash
   gcc -c mcd_macro.s -o mcd_macro.o
   ```

   Este comando genera un archivo objeto (**`mcd_macro.o`**) a partir del código ensamblador.

2. **Compilar y enlazar el archivo C con el ensamblador**:

   Compila el archivo C y **enlaza ambos archivos** (el ensamblador y el C) para generar el ejecutable final:

   ```bash
   gcc mcd.c mcd_macro.o -o mcd
   ```

3. **Ejecutar el programa**:

   Una vez que el proceso de compilación termine, puedes ejecutar el programa:

   ```bash
   ./mcd
   ```

   Esto imprimirá el resultado del cálculo del MCD en la terminal.

### Explicación de los cambios:

1. **Ensamblador**: La macro **gcd** en el archivo ensamblador calcula el MCD de dos números utilizando los registros **X0** y **X1**, que son los registros estándar para pasar parámetros en ARM64.
   
2. **C**: El programa en **C** llama a la función ensambladora **gcd_func** y utiliza los números 6099 y 2166 para calcular el MCD. Luego imprime el resultado.

Si recuerda nuestro temario recomendo esta practica y logramos optimizar nuestro código entre ALTO y BAJO nivel
