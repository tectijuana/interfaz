
# **MACRO: Implementación del Programa en Ensamblador ARM64 y C#**

---

## **Macro en Ensamblador ARM64**

### **Nombre del Archivo**
`gcd.s`

### **Descripción**
Este programa implementa la función de cálculo del Máximo Común Divisor (MCD) utilizando el algoritmo de Euclides en lenguaje ensamblador ARM64. La función se expone como una biblioteca compartida (`.so`) para ser utilizada por otros programas.

### **Funcionamiento**
1. **Comparación**: Los valores de los registros `x0` y `x1` son comparados.
2. **Decisión**:
   - Si ambos valores son iguales (`beq`), la función termina y el valor del MCD se retorna.
   - Si `x1 < x0`, los valores son intercambiados.
   - En otros casos, se resta `x1 - x0`.
3. **Recursión**: La función se llama a sí misma hasta que los valores sean iguales.
4. **Resultado**: El MCD se devuelve en el registro `x0`.

### **Código**

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

### **Registros Utilizados**
- `x0`: Almacena uno de los números iniciales y, posteriormente, el resultado (MCD).
- `x1`: Almacena el otro número inicial.

---

## **Programa en C#**

### **Nombre del Archivo**
`Program.cs`

### **Descripción**
Este programa permite al usuario ingresar dos números para calcular su MCD utilizando la función implementada en ensamblador ARM64. Se establece una comunicación con la macro ensambladora a través de interoperabilidad de C# con bibliotecas compartidas (`DllImport`).

### **Funcionamiento**
1. **Interacción con el Usuario**:
   - Solicita al usuario ingresar dos números enteros.
2. **Interoperabilidad**:
   - Llama a la función `gcd` implementada en ensamblador a través de la biblioteca `libgcd.so`.
3. **Cálculo del MCD**:
   - Utiliza la función `gcd` para realizar el cálculo.
4. **Salida**:
   - Muestra el resultado al usuario.

### **Código**

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

### **Detalles Técnicos**
- **Biblioteca Compartida**: 
  - `DllImport` enlaza la función ensambladora como un método externo.
  - La biblioteca compartida se compila previamente desde el ensamblador usando `gcc`.
- **Interacción del Usuario**:
  - `Console.ReadLine()` captura los números ingresados por el usuario.
  - `int.Parse()` convierte las entradas a enteros.
- **Resultado**:
  - Se imprime el MCD calculado.

---

## **Interacción entre los Programas**

### **Diagrama de Flujo**
1. **C#**:
   - Captura números desde la entrada estándar.
   - Llama a la biblioteca compartida `libgcd.so` a través de `DllImport`.
2. **Ensamblador**:
   - Realiza el cálculo del MCD usando el algoritmo de Euclides.
   - Retorna el resultado a `C#`.
3. **C#**:
   - Muestra el resultado al usuario.

---

## **Casos de Uso**

1. **Entrada Normal**:
   - Ejemplo:
     - Entrada: `48` y `18`.
     - Salida: `El MCD de 48 y 18 es: 6`.

2. **Validación**:
   - Se recomienda manejar errores en la entrada, como números negativos o valores no numéricos, en futuras versiones.

---

## **Extensiones Sugeridas**
1. Manejar entradas no válidas en C#.
2. Modificar la macro ensambladora para calcular valores negativos o cero.
3. Crear un bucle en el programa C# para realizar múltiples cálculos sin cerrar la aplicación.
