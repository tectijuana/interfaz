using System;
using System.Runtime.InteropServices;

class Program
{
    [DllImport("gcd", EntryPoint = "gcd")]
    public static extern int Gcd(int a, int b);

    static void Main(string[] args)
    {
        Console.WriteLine("Ingrese dos números para calcular el MCD:");
        int a = int.Parse(Console.ReadLine());
        int b = int.Parse(Console.ReadLine());
        int resultado = Gcd(a, b);
        Console.WriteLine($"El MCD de {a} y {b} es: {resultado}");
    }
}
