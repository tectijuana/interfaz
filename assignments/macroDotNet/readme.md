
# **Guía Completa: Compilación e Instalación de Software para Ejecutar el Programa en AWS Ubuntu ARM64**

Este documento describe cómo configurar un entorno en Ubuntu ARM64 sobre AWS para compilar y ejecutar un programa en ensamblador ARM64 integrado con C#.

---

## **Requisitos Previos**
1. **Máquina Virtual**: Instancia de Ubuntu 22.04 LTS o posterior en AWS, con arquitectura ARM64.
2. **Acceso SSH**: Conexión a la instancia mediante SSH.
3. **Permisos de Superusuario**: Debe tener permisos de administrador (`sudo`).

---

## **Instalación de Software Necesario**

### Paso 1: Actualizar el Sistema
Ejecute los siguientes comandos para actualizar los paquetes existentes:
```bash
sudo apt update
sudo apt upgrade -y
```

### Paso 2: Instalar `gcc` y Herramientas de Desarrollo
Instale el compilador GCC para ensamblador ARM64 y las herramientas básicas de desarrollo:
```bash
sudo apt install -y gcc make build-essential
```

### Paso 3: Instalar `mono` para Soporte de C#
Mono es una herramienta para compilar y ejecutar programas en C#. Instale `mono-complete`:
```bash
sudo apt install -y mono-complete
```

Verifique la instalación ejecutando:
```bash
mono --version
```

### Paso 4: Instalar el Editor de Texto (Opcional)
Recomendado para editar código:
```bash
sudo apt install -y nano
```

---

## **Compilación del Código**

### Paso 1: Preparar la Macro en Ensamblador
Cree un archivo llamado `gcd.s` con el siguiente contenido:
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

Compile el archivo para generar la biblioteca compartida:
```bash
gcc -shared -o libgcd.so gcd.s
```

### Paso 2: Crear el Programa en C#
Cree un archivo llamado `Program.cs` con el siguiente contenido:
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

Compile el programa usando Mono:
```bash
mcs -out:Program.exe Program.cs
```

### Paso 3: Ejecutar el Programa
1. Asegúrese de que la biblioteca `libgcd.so` esté en el mismo directorio que `Program.exe`.
2. Ejecute el programa:
   ```bash
   mono Program.exe
   ```

---

## **Configuración Adicional (Opcional)**

### Asegurar la Biblioteca Compartida
Para que el programa encuentre la biblioteca sin estar en el mismo directorio, mueva `libgcd.so` a una ruta de biblioteca estándar y actualice el caché:
```bash
sudo cp libgcd.so /usr/lib/
sudo ldconfig
```

### Instalar un Depurador (Opcional)
Para depurar programas en ensamblador y C#, instale `gdb`:
```bash
sudo apt install -y gdb
```

---

## **Pruebas**
1. Ejecute el programa con diferentes entradas.
2. Ejemplo:
   ```plaintext
   Ingrese dos números para calcular el MCD:
   48
   18
   El MCD de 48 y 18 es: 6
   ```

3. Valide que el resultado sea correcto.

---

## **Preguntas Frecuentes**
### ¿Qué sucede si `libgcd.so` no se encuentra?
Asegúrese de que:
1. La biblioteca esté en el mismo directorio o en una ubicación estándar como `/usr/lib/`.
2. El archivo tenga permisos adecuados:
   ```bash
   chmod +x libgcd.so
   ```

---

¡Ahora su entorno está listo para compilar y ejecutar programas en ensamblador ARM64 y C#! 🎉
