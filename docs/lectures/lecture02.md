 **ARM64 Assembly Hello World** 

```assembly
/*=======================================================
* Programa:     hello_world.s
* Autor:        RENE SOLIS
* Fecha:        09 de septiembre de 2024
* Descripción:  Este programa en ensamblador ARM64 imprime
*               el mensaje "Hello, World!" en la consola 
*               usando llamadas al sistema en Linux.
* Compilación:  as -o hello_world.o hello_world.s
*               ld -o hello_world hello_world.o
* Ejecución:    ./hello_world
* Versión:      1.0
* 
* Código equivalente en C:
* -----------------------------------------------------
* #include <stdio.h>
* int main() {
*     printf("Hello, World!\n");
*     return 0;
* }
* -----------------------------------------------------
=========================================================*/

.section .data
msg:
    .asciz "Hello, World!\n"    // Definimos el mensaje a imprimir

.section .text
.global _start

_start:
    // Syscall para escribir en stdout
    mov x0, #1              // El descriptor de archivo 1 es stdout (salida estándar)
    ldr x1, =msg            // Cargamos la dirección del mensaje a imprimir
    mov x2, #13             // Longitud del mensaje (13 caracteres, incluyendo el salto de línea)
    mov x8, #64             // Número de syscall para 'write' (64 en ARM64)
    svc #0                  // Realizamos la llamada al sistema

    // Syscall para salir del programa
    mov x0, #0              // Código de estado 0 (indica éxito)
    mov x8, #93             // Número de syscall para 'exit' (93 en ARM64)
    svc #0                  // Realizamos la llamada al sistema
```

### Explicación de los comentarios y el encabezado:
- **Encabezado profesional**: Incluye el nombre del autor, fecha, descripción del programa, cómo compilarlo, cómo ejecutarlo, y el número de versión.
- **Comentarios en español**: Explican cada línea del programa para que sea claro cómo funcionan las llamadas al sistema (`syscalls`).

### Pasos para compilar y ejecutar:

1. **Assemble**:
   ```bash
   as -o hello_world.o hello_world.s
   ```

2. **Link**:
   ```bash
   ld -o hello_world hello_world.o
   ```

3. **Run**:
   ```bash
   ./hello_world
   ```
-----
### ¿Qué es un Makefile y por qué es importante para los estudiantes de sistemas?

Un **Makefile** es un archivo de texto que contiene reglas e instrucciones para automatizar la compilación y construcción de proyectos en programación. Utiliza el comando `make` para ejecutar una serie de acciones, como compilar código fuente, enlazar archivos y generar ejecutables.

#### Importancia para los estudiantes de sistemas:
1. **Automatización**: Los estudiantes pueden automatizar tareas repetitivas, como la compilación de múltiples archivos, ahorrando tiempo y reduciendo errores.
2. **Organización**: Facilita la estructuración de proyectos grandes, definiendo qué archivos dependen de otros y cómo se deben construir.
3. **Reproducibilidad**: Permite que cualquier persona pueda compilar un proyecto con un simple comando `make`, garantizando que el proceso sea siempre el mismo.
4. **Escalabilidad**: Es una herramienta esencial para trabajar en proyectos grandes o en equipo, donde se deben manejar múltiples dependencias de manera eficiente.

Aprender a usar Makefiles es fundamental para gestionar el flujo de trabajo en proyectos de software, especialmente en sistemas complejos.

-----


### **Makefile**

```makefile
#=======================================================
# Makefile para compilar y enlazar el programa en ensamblador
# Autor:        RENE SOLIS
# Fecha:        09 de septiembre de 2024
# Descripción:  Este Makefile automatiza el proceso de ensamblado 
#               y enlazado de un programa en ensamblador ARM64.
#               También incluye una opción para limpiar archivos
#               generados por la compilación.
# Versión:      1.0
#=======================================================

# Nombre del archivo de salida (binario)
TARGET = hello_world

# Archivo fuente en ensamblador
SRC = hello_world.s

# Archivo objeto generado por el ensamblador
OBJ = hello_world.o

# Comandos de ensamblado y enlazado
AS = as                  # Ensamblador de GNU
LD = ld                  # Enlazador de GNU

# Opciones de ensamblado
ASFLAGS = -o $(OBJ)      # Especifica el archivo objeto de salida

# Opciones de enlazado
LDFLAGS = -o $(TARGET)   # Especifica el archivo ejecutable de salida

# Reglas principales
#-------------------------------------------------------

# Regla principal: compila y enlaza el programa
# Esta es la regla por defecto que se ejecuta cuando se llama 'make'
all: $(TARGET)

# Regla para ensamblar el código fuente en ensamblador
# Aquí utilizamos 'as' para convertir el archivo .s en un archivo objeto (.o)
$(OBJ): $(SRC)
	@echo "Ensamblando el archivo fuente $(SRC) ..."
	$(AS) $(ASFLAGS) $(SRC)

# Regla para enlazar el archivo objeto y generar el ejecutable
# Utilizamos 'ld' para generar el binario a partir del archivo objeto
$(TARGET): $(OBJ)
	@echo "Enlazando el archivo objeto $(OBJ) para crear el ejecutable $(TARGET) ..."
	$(LD) $(LDFLAGS) $(OBJ)

# Regla para limpiar los archivos generados (archivos intermedios y binarios)
# La regla 'clean' se utiliza para eliminar los archivos .o y el ejecutable
clean:
	@echo "Eliminando archivos generados ..."
	rm -f $(OBJ) $(TARGET)

#-------------------------------------------------------
# Fin del Makefile
#=======================================================
```

### Explicación detallada:

1. **TARGET**: Es el nombre del archivo ejecutable que queremos generar (`hello_world`).
2. **SRC**: Es el archivo fuente de ensamblador (`hello_world.s`).
3. **OBJ**: Es el archivo objeto generado durante el proceso de ensamblado (`hello_world.o`).
4. **AS** y **LD**: Son los comandos para ensamblar (`as`) y enlazar (`ld`).
5. **ASFLAGS**: Opciones de ensamblado, donde se especifica el archivo objeto de salida.
6. **LDFLAGS**: Opciones de enlazado, donde se especifica el archivo ejecutable de salida.
7. **all**: La regla principal que ejecuta todo el proceso (ensamblado y enlazado).
8. **clean**: Regla para eliminar los archivos generados, como los objetos y ejecutables. Esto es útil para empezar desde cero.

### ¿Cómo usar este Makefile?

1. **Para compilar y enlazar el programa**:
   ```bash
   make
   ```

2. **Para limpiar los archivos generados**:
   ```bash
   make clean
   ```

This Makefile simplifies the process of compiling and linking your assembly code and provides detailed comments in Spanish to explain each step. Let me know if you need any further adjustments!
