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
