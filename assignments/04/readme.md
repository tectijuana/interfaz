
![Cool Text - CSharp y ARM64 assembly 468401178312254](https://github.com/user-attachments/assets/92cb8abf-773d-4e7e-9466-f099d4f62a27)

# Guion de Trabajo Personal (GTP): Integración de C# y ARM64 Assembly en Ubuntu 22 LTS

## Objetivo
El estudiante será capaz de:
1. Instalar C# 8 en Ubuntu 22 LTS.
2. Crear una macro en ARM64 assembly que implemente el algoritmo de mínimo común divisor (MCD).
3. Llamar a la rutina en assembly desde un programa en C#.

## Materiales Necesarios
- Ubuntu 22 LTS
- Terminal de Ubuntu
- Editor de texto (por ejemplo, Visual Studio Code)
- Conexión a Internet

## Paso 1: Instalación de C# 8 en Ubuntu 22 LTS
1. **Abrir la terminal**.
2. **Actualizar el sistema**:
   ```bash
   sudo apt update
   sudo apt upgrade
   ```
3. **Instalar los paquetes necesarios**:
   ```bash
   sudo apt install -y dotnet-sdk-8.0
   ```
4. **Verificar la instalación**:
   ```bash
   dotnet --version
   ```
   Deberías ver la versión 8.0 o superior.

## Paso 2: Crear la Macro en ARM64 Assembly
1. **Abrir un editor de texto y crear un archivo llamado `gcd.s`**.
2. **Escribir el código en ARM64 assembly para el algoritmo de MCD**:
   ```assembly
   .global gcd
   .text
   gcd:
       cmp x1, x0         // Compara a x1 con x0
       beq end            // Si son iguales, salta a fin
       blt swap           // Si x1 < x0, intercambia
       sub x1, x1, x0     // x1 = x1 - x0
       b gcd              // Llama recursivamente a gcd
   swap:
       mov x0, x1         // Intercambia valores
       mov x1, x0
       sub x0, x0, x1     // x0 = x0 - x1
       b gcd              // Llama recursivamente a gcd
   end:
       ret                 // Retorna
   ```

3. **Guardar y compilar el código**:
   ```bash
   as -o gcd.o gcd.s
   ld -o gcd gcd.o
   ```

## Paso 3: Llamar a la Macro desde C#
1. **Crear un nuevo proyecto de C#**:
   ```bash
   dotnet new console -n GcdExample
   cd GcdExample
   ```

2. **Modificar el archivo `Program.cs`** para incluir la llamada a la función en assembly:
```csharp
using System;
using System.Runtime.InteropServices;

class Program
{
    [DllImport("libgcd.so", EntryPoint = "gcd")]
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
```

3. **Compilar el programa**:
   ```bash
   dotnet build
   ```

4. **Ejecutar el programa**:
   ```bash
   dotnet run
   ```

## Rubrica de Evaluación
1. **Asciinema (50%)**: Grabación de la compilación y ejecución de la macro ARM64 desde C# consola. Debe incluir el nombre en "figlet".
2. **Comentarios y Encabezados (25%)**: Ambos códigos fuente deben tener comentarios claros y encabezados informativos.
3. **GIST (25%)**: El GIST del trabajo elaborado debe ser depositado en IDOCEO en la fecha indicada.

## Ejemplo de Uso
1. Compila y ejecuta el programa.
2. Ingresa dos números, por ejemplo, `48` y `18`.
3. El programa debería devolver `6`, que es el MCD de `48` y `18`.


