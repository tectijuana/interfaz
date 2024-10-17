
![cooltext468348822700204](https://github.com/user-attachments/assets/e51da0b4-e0ad-418a-9d77-5b5a83ed27f3)


![mermaid-diagram-2024-10-15-151516](https://github.com/user-attachments/assets/63a02782-cd06-40db-824e-920e2a00e6af)



# README: Cálculo del Máximo Común Divisor (MCD) utilizando Ensamblador ARM64 y C

## Descripción
Este proyecto tiene como objetivo guiar a los estudiantes en la implementación de una función en lenguaje ensamblador para calcular el Máximo Común Divisor (MCD) de dos números, invocada desde un programa escrito en C. Para la ejecución del proyecto, se utilizará un entorno basado en Ubuntu 24 LTS sobre arquitectura ARM64 o en su Pi5 remota de la aula.lazarocardenas.edu.mx

Debe entregar el ASCIINEMA.ORG vinculado a su cuenta en iDoceo.

Instalar FIGLET command para anunciar el proceso donde se encuentre:
     ```bash
        $ sudo apt install figlet
        $ filget "Programa 1 por Rene Solis"
        ...
        ...
    ```
## Archivos del Proyecto

1. **mcd_macro.s**: Archivo que contiene el código ensamblador ARM64 que implementa la macro para calcular el MCD.
2. **mcd.c**: Archivo en C que invoca la función ensambladora para calcular el MCD de dos números y muestra el resultado.

## Objetivos de Aprendizaje

- Comprender el funcionamiento de macros y funciones en lenguaje ensamblador ARM64.
- Entender cómo integrar funciones en ensamblador dentro de un programa en C.
- Practicar la compilación y el enlace de código ensamblador y C.

## Instrucciones

1. **Creación de Archivos**
   - Cree un archivo denominado `mcd_macro.s` e incluya el siguiente código ensamblador:
     
     ```asm
     // Archivo: mcd_macro.s
     // Descripción: Implementación de la macro MCD para ARM64 en Ubuntu 24 LTS

     .macro gcd a, b
     1:                     
         cmp \a, \b          // Comparar a y b
         b.eq 2f             // Si a == b, saltar al final
         subgt \a, \a, \b    // Si a > b, restar b de a
         sublt \b, \b, \a    // Si a < b, restar a de b
         b 1b                // Volver a comparar
     2:
     .endm

     // Función en ensamblador que calcula el MCD
     .text
     .globl gcd_func
     .type gcd_func, %function
     gcd_func:
         // Argumentos en X0 y X1 (a y b)
         gcd x0, x1          // Ejecutar la macro gcd con X0 y X1
         mov x0, x1          // Mover el resultado a X0 para retornarlo
         ret                 // Retornar el valor en X0
     ```

   - Cree un archivo denominado `mcd.c` e incluya el siguiente código:
     
     ```c
     // Archivo: mcd.c
     // Descripción: Programa en C que invoca una macro ensambladora en ARM64 para calcular el MCD.

     #include <stdio.h>

     // Declaración de la función ensambladora
     extern long gcd_func(long a, long b);

     int main() {
         long a, b;

         // Capturar los valores de a y b desde el usuario
         printf("Ingrese el primer número (positivo): ");
         scanf("%ld", &a);
         printf("Ingrese el segundo número (positivo): ");
         scanf("%ld", &b);

         // Validar que los números sean positivos
         if (a <= 0 || b <= 0) {
             printf("Error: Ambos números deben ser positivos y mayores que cero.\n");
             return 1;
         }

         // Llamar a la función ensambladora que ejecuta la macro gcd
         long result = gcd_func(a, b);

         // Imprimir el resultado
         printf("El MCD de %ld y %ld es: %ld\n", a, b, result);

         return 0;
     }
     ```

2. **Compilación del Proyecto**
   - Abra una terminal y navegue al directorio donde están los archivos.
   - Compile el archivo ensamblador:
     ```bash
     as -o mcd_macro.o mcd_macro.s
     ```
   - Compile y enlace el programa C con el ensamblador:
     ```bash
     gcc -o mcd_program mcd.c mcd_macro.o
     ```

3. **Ejecución del Programa**
   - Una vez que se haya compilado correctamente, ejecute el programa:
     ```bash
     ./mcd_program
     ```
   - Debería observar un resultado similar al siguiente:
     ```
     Ingrese el primer número (positivo): 6099
     Ingrese el segundo número (positivo): 2166
     El MCD de 6099 y 2166 es: 33
     ```

## Preguntas para Reflexionar
- ¿Qué sucede si los valores de `a` y `b` son negativos?
- ¿Cómo podrías modificar el código para manejar casos en los que `a` o `b` sean cero?
- ¿Cómo se comunicarían diferentes tipos de datos entre C y ensamblador en ARM64?

## Solución de Problemas
- Si encuentras errores durante la compilación, verifica que los comentarios estén escritos con `//` en lugar de `@`, ya que la sintaxis de ensamblador ARM64 en Ubuntu 24 LTS no acepta `@` para comentarios.
- Asegúrate de estar utilizando un entorno ARM64, ya que este código está diseñado específicamente para esa arquitectura.

## Recursos Adicionales
- [Documentación oficial de GNU Assembler](https://sourceware.org/binutils/docs/as/index.html) para obtener más detalles sobre la sintaxis.
- [Documentación de ARM](https://developer.arm.com/documentation) para comprender mejor las instrucciones y la arquitectura ARM64.

¡Buena suerte y disfruten aprendiendo ensamblador ARM64!

