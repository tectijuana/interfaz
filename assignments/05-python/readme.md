# README: Cálculo del Máximo Común Divisor (MCD) utilizando Ensamblador ARM64 y Python

## Descripción
Este proyecto tiene como objetivo guiar a los estudiantes en la implementación de una función en ensamblador ARM64 para calcular el Máximo Común Divisor (MCD) de dos números, invocada desde un programa escrito en Python. El proyecto está diseñado para ejecutarse en Ubuntu 24 LTS sobre arquitectura ARM64.

## Archivos del Proyecto

1. **mcd_macro.s**: Archivo que contiene el código ensamblador ARM64 para implementar la macro que calcula el MCD.
2. **mcd.py**: Archivo principal que contiene el código en Python para invocar la función ensambladora y calcular el MCD.

## Objetivos de Aprendizaje

- Comprender la implementación de macros y funciones en ensamblador ARM64.
- Entender cómo integrar funciones en ensamblador dentro de un programa en Python.
- Practicar la compilación y el enlace de código ensamblador y Python.

## Instrucciones

1. **Instalación del Soporte de Python y Herramientas en Ubuntu 24 LTS en AWS**
   - Primero, actualice la lista de paquetes e instale los paquetes necesarios:
     ```bash
     sudo apt update
     sudo apt install -y wget build-essential python3 python3-pip
     ```
   - Instale las bibliotecas necesarias para interactuar con código compilado desde Python:
     ```bash
     pip install cffi
     ```

2. **Creación del Archivo Ensamblador**
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

3. **Creación del Archivo Python**
   - Cree un archivo denominado `mcd.py` e incluya el siguiente código:
     
     ```python
     # Archivo: mcd.py
     # Descripción: Programa en Python que invoca una función ensambladora en ARM64 para calcular el MCD.

     import ctypes
     import os

     # Cargar la biblioteca compartida generada a partir del ensamblador
     lib = ctypes.CDLL(os.path.abspath("./libmcd_macro.so"))

     # Definir los tipos de argumentos y el tipo de retorno de la función ensambladora
     lib.gcd_func.argtypes = [ctypes.c_long, ctypes.c_long]
     lib.gcd_func.restype = ctypes.c_long

     def main():
         try:
             # Capturar los valores de a y b desde el usuario
             a = int(input("Ingrese el primer número (positivo): "))
             b = int(input("Ingrese el segundo número (positivo): "))

             # Validar que los números sean positivos
             if a <= 0 or b <= 0:
                 print("Error: Ambos números deben ser positivos y mayores que cero.")
                 return

             # Llamar a la función ensambladora que ejecuta la macro gcd
             result = lib.gcd_func(a, b)

             # Imprimir el resultado
             print(f"El MCD de {a} y {b} es: {result}")
         except ValueError:
             print("Error: Debe ingresar un número entero válido.")

     if __name__ == "__main__":
         main()
     ```

4. **Compilación del Proyecto**
   - Abra una terminal y navegue al directorio donde están los archivos.
   - Compile el archivo ensamblador:
     ```bash
     as -o mcd_macro.o mcd_macro.s
     gcc -shared -o libmcd_macro.so mcd_macro.o
     ```

5. **Ejecución del Programa**
   - Una vez que se haya compilado correctamente, ejecute el programa en Python:
     ```bash
     python3 mcd.py
     ```
   - Debería observar un resultado similar al siguiente:
     ```
     Ingrese el primer número (positivo): 6099
     Ingrese el segundo número (positivo): 2166
     El MCD de 6099 y 2166 es: 33
     ```

## Solución de Problemas
- Si encuentras errores durante la compilación, asegúrate de que tienes instaladas las herramientas de compilación necesarias para ARM64.
- Asegúrate de que los valores ingresados sean números enteros positivos.

## Recursos Adicionales
- [Documentación oficial de Python](https://docs.python.org/3/) para obtener más detalles sobre la sintaxis y las herramientas.
- [Documentación de GNU Assembler](https://sourceware.org/binutils/docs/as/index.html) para aprender sobre ensamblador ARM64.
- [Documentación de CFFI](https://cffi.readthedocs.io/en/latest/) para aprender a interactuar con bibliotecas compartidas en Python.



