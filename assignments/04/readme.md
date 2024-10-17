
![Cool Text - CSharp y ARM64 assembly 468401178312254](https://github.com/user-attachments/assets/92cb8abf-773d-4e7e-9466-f099d4f62a27)

# README: Cálculo del Máximo Común Divisor (MCD) utilizando C# 8 en Consola

## Descripción
Este proyecto tiene como objetivo guiar a los estudiantes en la implementación de una función en C# para calcular el Máximo Común Divisor (MCD) de dos números utilizando una aplicación de consola. El proyecto está diseñado para ejecutarse en .NET Core, utilizando las capacidades de C# 8.

## Archivos del Proyecto

1. **Program.cs**: Archivo principal que contiene el código de la aplicación de consola para calcular el MCD.

## Objetivos de Aprendizaje

- Comprender la implementación de algoritmos matemáticos en C#.
- Entender cómo trabajar con aplicaciones de consola en .NET Core.
- Practicar la validación de entradas de usuario y el manejo de errores.

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

2. **Creación del Archivo**
   - Cree un archivo denominado `Program.cs` e incluya el siguiente código:
     
     ```csharp
     // Archivo: Program.cs
     // Descripción: Programa en C# que calcula el Máximo Común Divisor (MCD) de dos números.

     using System;

     namespace MCDApp
     {
         class Program
         {
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

                 // Calcular el MCD usando el método Euclides
                 long result = Gcd(a, b);

                 // Imprimir el resultado
                 Console.WriteLine($"El MCD de {a} y {b} es: {result}");
             }

             // Método para calcular el MCD utilizando el algoritmo de Euclides
             static long Gcd(long a, long b)
             {
                 while (b != 0)
                 {
                     long temp = b;
                     b = a % b;
                     a = temp;
                 }
                 return a;
             }
         }
     }
     ```

3. **Compilación del Proyecto**
   - Abra una terminal y navegue al directorio donde está el archivo `Program.cs`.
   - Compile el proyecto utilizando el SDK de .NET Core:
     ```bash
     dotnet new console -o MCDApp
     mv Program.cs MCDApp/
     cd MCDApp
     dotnet run
     ```

4. **Ejecución del Programa**
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

- 

## Solución de Problemas
- Si encuentras errores durante la compilación, asegúrate de que tienes instalada la versión correcta del SDK de .NET Core.
- Asegúrate de que los valores ingresados sean números enteros positivos.

## Recursos Adicionales
- [Documentación oficial de .NET](https://learn.microsoft.com/dotnet/) para obtener más detalles sobre la sintaxis y las herramientas.
- [Documentación de C#](https://learn.microsoft.com/dotnet/csharp/) para comprender mejor el lenguaje C# y sus características.






