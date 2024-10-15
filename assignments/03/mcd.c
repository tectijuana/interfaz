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
