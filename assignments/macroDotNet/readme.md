```markdown
# **Práctica: Implementación de un Programa en Ensamblador ARM64 y su Integración con C#**

## **Objetivo**
Aprender a desarrollar una macro en lenguaje ensamblador ARM64 para calcular el MCD (Máximo Común Divisor) y vincularla a un programa en C# utilizando la interoperabilidad entre lenguajes.

---

## **Requisitos**
- Entorno Linux con soporte para ARM64.
- Compiladores necesarios:
  - `gcc` para ensamblador.
  - `dotnet` o `mono` para C#.
- Editor de texto (Nano, VS Code, o cualquier otro de su preferencia).
- Conocimientos básicos de ensamblador y C#.

---

## **Instrucciones**

### Paso 1: Crear la Macro en Ensamblador

1. Cree un archivo llamado `gcd.s`.
2. Escriba el siguiente código ensamblador en ARM64:

   ```assembly
   // Casildo Rubalcava Aaron 22212222
   // Programa en assembly que es la llamada para el programa principal

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

3. Guarde el archivo.

---

### Paso 2: Compilar el Código Ensamblador

1. Compile el archivo ensamblador para generar una biblioteca compartida (`.so`):

   ```bash
   gcc -shared -o libgcd.so gcd.s
   ```

---

### Paso 3: Crear el Programa en C#

1. Cree un archivo llamado `Program.cs`.
2. Escriba el siguiente código en C#:

   ```csharp
   // Casildo Rubalcava Aaron 222122222
   // Este programa calcula el MCD en un par de números ingresados por el usuario
   // Referenciamos al archivo gcd.s

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

3. Guarde el archivo.

---

### Paso 4: Compilar y Ejecutar el Programa en C#

1. Compile el programa usando `mcs` (Mono):

   ```bash
   mcs -out:Program.exe Program.cs
   ```

2. Ejecute el programa:

   ```bash
   mono Program.exe
   ```

---

## **Pruebas**

1. Ingrese dos números enteros para calcular el MCD.
2. Verifique que el resultado sea correcto.
3. Ejemplo de ejecución:
   ```plaintext
   Ingrese dos números para calcular el MCD:
   48
   18
   El MCD de 48 y 18 es: 6
   ```

---

## **Preguntas para Reflexión**
1. ¿Cómo interactúan el ensamblador y el programa en C# a través de la biblioteca compartida?
2. ¿Qué sucede si los números ingresados son negativos? ¿Cómo podría manejar este caso en ensamblador?

---

## **Extensión de la Práctica**

1. Modifique la macro en ensamblador para manejar casos especiales como valores negativos o ceros.
2. Añada un bucle en C# para permitir cálculos repetidos sin cerrar el programa.

---

```
