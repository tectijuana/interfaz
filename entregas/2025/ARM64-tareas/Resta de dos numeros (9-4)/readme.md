# Práctica: Restar dos números (9 - 4) en AWS ARM64

Este proyecto realiza una resta simple de dos números (`9 - 4`) utilizando un programa en C y se ejecuta directamente desde la terminal de una instancia AWS ARM64 (`t4g.micro`).  

Se explica paso a paso cómo compilar y ejecutar el programa desde cero.

---

## Contenido de la carpeta `./interfaz`

Después de recrear la carpeta, los archivos mínimos que vamos a tener son:

- `resta.c` → Código fuente en C.
- `makefile` → Archivo de compilación para simplificar la compilación y ejecución.
- `resta` → Ejecutable generado (no se incluye en el repositorio, se crea al compilar).

---

## Pasos de implementación

### 1. Crear la carpeta de trabajo

Desde la terminal de la instancia:

```bash
mkdir ~/interfaz
cd ~/interfaz
```

### 2. Crear el archivo `resta.c`

```bash
nano resta.c
```

Escribe el siguiente código en C:

```c
#include <stdio.h>

int main() {
    int a = 9;
    int b = 4;
    int resultado = a - b;
    printf("Resultado: %d\n", resultado);
    return 0;
}
```

Guardar y salir: `Ctrl+O` → `Enter` → `Ctrl+X`

### 3. Crear un makefile

```bash
nano makefile
```

Agregar el siguiente contenido:

```makefile
CC = gcc
CFLAGS = -g -O0
TARGET = resta

all: $(TARGET)

$(TARGET): resta.c
	$(CC) $(CFLAGS) -o $(TARGET) resta.c

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
```

Guardar y salir: `Ctrl+O` → `Enter` → `Ctrl+X`

### 4. Compilar el programa

Desde la terminal, estando en la carpeta `./interfaz`:

```bash
make
```

Esto generará el ejecutable `resta`.

### 5. Ejecutar el programa

```bash
./resta
```

**Salida esperada:**

```
Resultado: 5
```

### 6. Ejecutar todo en un solo paso

También se puede compilar y ejecutar en un solo comando usando la regla `run` del makefile:

```bash
make run
```

---

## Estructura final del proyecto

```
interfaz/
├── resta.c
├── makefile
└── resta (generado después de compilar)
```
