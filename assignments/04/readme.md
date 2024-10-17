
![Cool Text - CSharp y ARM64 assembly 468401178312254](https://github.com/user-attachments/assets/92cb8abf-773d-4e7e-9466-f099d4f62a27)

# README: Cálculo del Máximo Común Divisor (MCD) utilizando Ensamblador ARM64 y C# 8 en Consola

## Descripción
Este proyecto tiene como objetivo guiar a los estudiantes en la implementación de una función en ensamblador ARM64 para calcular el Máximo Común Divisor (MCD) de dos números, invocada desde un programa escrito en C#. El proyecto está diseñado para ejecutarse en .NET Core, utilizando las capacidades de C# 8 y un entorno ARM64.

## Archivos del Proyecto

1. **mcd_macro.s**: Archivo que contiene el código ensamblador ARM64 para implementar la macro que calcula el MCD.
2. **Program.cs**: Archivo principal que contiene el código de la aplicación de consola en C# para invocar la función ensambladora y calcular el MCD.

## Objetivos de Aprendizaje

- Comprender la implementación de macros y funciones en ensamblador ARM64.
- Entender cómo integrar funciones en ensamblador dentro de un programa en C#.
- Practicar la compilación y el enlace de código ensamblador y C#.

## Instrucciones

1. **Instalación del Soporte de C# en Ubuntu 24 LTS en AWS**
   - Primero, actualice la lista de paquetes e instale los paquetes necesarios para agregar repositorios HTTPS:
     ```bash
     sudo apt update
     sudo apt install -y wget apt-transport-https software-properties-common
     ```
   - Importe la clave pública de Microsoft:
     ```bash
     wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
     sudo dpkg -i packages-microsoft-prod.deb
     ```
   - Instale el SDK de .NET 8:
     ```bash
     sudo apt update
     sudo apt install -y dotnet-sdk-8.0
     ```
   - Verifique la instalación:
     ```bash
     dotnet --version
     ```
   - Asegúrese de que la salida muestre la versión instalada de .NET SDK.

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

3. **Creación del Archivo C#**
   - Cree un archivo denominado `Program.cs` e incluya el siguiente código:
     
     ```csharp
     // Archivo: Program.cs
     // Descripción: Programa en C# que invoca una función ensambladora en ARM64 para calcular el MCD.

     using System;
     using System.Runtime.InteropServices;

     namespace MCDApp
     {
         class Program
         {
             [DllImport("libmcd_macro.so")]
             public static extern long gcd_func(long a, long b);

             static void Main(string[] args)
             {
                 long a, b;

                 // Capturar los valores de a y b desde el usuario
                 Console.Write("Ingrese el primer número (positivo): ");
                 while (!long.TryParse(Console.ReadLine(), out a) || a <= 0)
                 {
                     Console.WriteLine("Error: Debe ingresar un número positivo y mayor que cero.");
                     Console.Write("Ingrese el primer número (positivo): ");
                 }

                 Console.Write("Ingrese el segundo número (positivo): ");
                 while (!long.TryParse(Console.ReadLine(), out b) || b <= 0)
                 {
                     Console.WriteLine("Error: Debe ingresar un número positivo y mayor que cero.");
                     Console.Write("Ingrese el segundo número (positivo): ");
                 }

                 // Llamar a la función ensambladora que ejecuta la macro gcd
                 long result = gcd_func(a, b);

                 // Imprimir el resultado
                 Console.WriteLine($"El MCD de {a} y {b} es: {result}");
             }
         }
     }
     ```

4. **Compilación del Proyecto**
   - Abra una terminal y navegue al directorio donde están los archivos.
   - Compile el archivo ensamblador:
     ```bash
     as -o mcd_macro.o mcd_macro.s
     gcc -shared -o libmcd_macro.so mcd_macro.o
     ```
   - Compile el proyecto en C# utilizando el SDK de .NET Core:
     ```bash
     dotnet new console -o MCDApp
     mv Program.cs MCDApp/
     cd MCDApp
     dotnet run
     ```

5. **Ejecución del Programa**
   - Una vez que se haya compilado correctamente, ejecute el programa:
     ```bash
     dotnet run
     ```
   - Debería observar un resultado similar al siguiente:
     ```
     Ingrese el primer número (positivo): 6099
     Ingrese el segundo número (positivo): 2166
     El MCD de 6099 y 2166 es: 33
     ```

## Solución de Problemas
- Si encuentras errores durante la compilación, asegúrate de que tienes instalada la versión correcta del SDK de .NET Core y de las herramientas de compilación para ARM64.
- Asegúrate de que los valores ingresados sean números enteros positivos.

## Recursos Adicionales
- [Documentación oficial de .NET](https://learn.microsoft.com/dotnet/) para obtener más detalles sobre la sintaxis y las herramientas.
- [Documentación de C#](https://learn.microsoft.com/dotnet/csharp/) para comprender mejor el lenguaje C# y sus características.
- [Documentación de GNU Assembler](https://sourceware.org/binutils/docs/as/index.html) para aprender sobre ensamblador ARM64.

¡Buena suerte y disfruten aprendiendo ensamblador ARM64 y programación en C#!








