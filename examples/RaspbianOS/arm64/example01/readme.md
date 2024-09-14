```assembly
/*=======================================================
 * Programa:     hello_world.s
 * Autor:        RENE SOLIS
 * Fecha:        14 de septiembre de 2024
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
    mov x2, #14             // Longitud del mensaje (14 caracteres, incluyendo el salto de línea)
    mov x8, #64             // Número de syscall para 'write' (64 en ARM64)
    svc #0                  // Realizamos la llamada al sistema

    // Syscall para salir del programa
    mov x0, #0              // Código de estado 0 (indica éxito)
    mov x8, #93             // Número de syscall para 'exit' (93 en ARM64)
    svc #0                  // Realizamos la llamada al sistema
```

---

## Makefile

A continuación, se proporciona un **Makefile** que automatiza el proceso de ensamblado, enlazado, ejecución, depuración con GDB y subida del código fuente a GitHub para el programa `hello_world`. Este Makefile está diseñado para ser utilizado en un entorno Raspbian 64 bits con arquitectura ARM64.

```makefile
# Makefile para el programa hello_world en ARM64

# Variables
ASM = as
LD = ld
GDB = gdb
TARGET = hello_world
OBJECT = hello_world.o
SOURCE = hello_world.s

# Repositorio GitHub (configura tu propio repositorio)
GIT_REPO = https://github.com/tu_usuario/tu_repositorio.git

.PHONY: all build run debug clean upload help

# Objetivo por defecto: construir el programa
all: build

# Compilar y enlazar el programa
build: $(OBJECT)
	$(LD) -o $(TARGET) $(OBJECT)

$(OBJECT): $(SOURCE)
	$(ASM) -o $(OBJECT) $(SOURCE)

# Ejecutar el programa
run: build
	@echo "Ejecutando el programa..."
	./$(TARGET)

# Depurar el programa con GDB
debug: build
	@echo "Iniciando GDB..."
	$(GDB) ./$(TARGET)

# Limpiar archivos generados
clean:
	@echo "Limpiando archivos generados..."
	rm -f $(OBJECT) $(TARGET)

# Subir el código fuente a GitHub
upload: 
	@echo "Subiendo el código a GitHub..."
	@git add .
	@read -p "Ingrese el mensaje del commit: " msg; \
	git commit -m "$$msg"
	@git push $(GIT_REPO) main

# Información de ayuda
help:
	@echo
	@echo "Makefile para hello_world.s"
	@echo
	@echo "Uso: make [objetivo]"
	@echo
	@echo "Objetivos disponibles:"
	@echo "  all      - Construir el programa (predeterminado)"
	@echo "  build    - Ensamblar y enlazar el programa"
	@echo "  run      - Ejecutar el programa"
	@echo "  debug    - Depurar el programa con GDB"
	@echo "  clean    - Eliminar archivos generados"
	@echo "  upload   - Subir el código fuente a GitHub"
	@echo "  help     - Mostrar esta ayuda"
```

---

## Instrucciones para Utilizar el Makefile

### 1. Guardar los Archivos

- **Guardar el Código Ensamblador:**

  Guarda el código ensamblador proporcionado anteriormente en un archivo llamado `hello_world.s`.

- **Guardar el Makefile:**

  Guarda el contenido del Makefile en un archivo llamado `Makefile` en el mismo directorio donde se encuentra `hello_world.s`.

### 2. Configurar el Repositorio GitHub

Antes de utilizar el objetivo `upload`, asegúrate de tener un repositorio GitHub configurado y de haber clonado el repositorio en tu máquina. Si aún no lo has hecho, sigue estos pasos:

1. **Crear un Repositorio en GitHub:**

   - Ve a [GitHub](https://github.com/) y crea un nuevo repositorio.
   - Copia la URL del repositorio, que se verá algo así: `https://github.com/tu_usuario/tu_repositorio.git`.

2. **Inicializar Git en tu Proyecto Local:**

   Abre una terminal en el directorio de tu proyecto y ejecuta:

   ```bash
   git init
   git remote add origin https://github.com/tu_usuario/tu_repositorio.git
   git add .
   git commit -m "Primer commit"
   git push -u origin main
   ```

   Asegúrate de reemplazar `https://github.com/tu_usuario/tu_repositorio.git` con la URL de tu propio repositorio.

### 3. Compilar el Programa

Para ensamblar y enlazar el programa, simplemente ejecuta:

```bash
make
```

O alternativamente:

```bash
make build
```

### 4. Ejecutar el Programa

Después de compilar, puedes ejecutar el programa con:

```bash
make run
```

Deberías ver en la consola:

```
Hello, World!
```

### 5. Depurar el Programa con GDB

Para depurar el programa utilizando GDB, utiliza:

```bash
make debug
```

Esto iniciará GDB con el ejecutable `hello_world`, permitiéndote establecer puntos de interrupción, inspeccionar registros y más.

### 6. Limpiar Archivos Generados

Para eliminar los archivos objeto y el ejecutable generados, ejecuta:

```bash
make clean
```

### 7. Subir el Código Fuente a GitHub

Para agregar, commitear y subir los cambios al repositorio de GitHub, utiliza:

```bash
make upload
```

Este objetivo realizará los siguientes pasos:

1. **Agregar todos los cambios al staging area:**

   ```bash
   git add .
   ```

2. **Solicitar un mensaje de commit al usuario:**

   El Makefile pedirá que ingreses un mensaje descriptivo para el commit.

3. **Commit y Push al Repositorio Remoto:**

   ```bash
   git commit -m "Mensaje del commit"
   git push https://github.com/tu_usuario/tu_repositorio.git main
   ```

   Asegúrate de que la variable `GIT_REPO` en el Makefile esté configurada con la URL correcta de tu repositorio.

### 8. Ver Ayuda

Para ver una lista de todos los objetivos disponibles y su descripción, ejecuta:

```bash
make help
```

---

## Notas Adicionales

- **Permisos de Ejecución:**

  Asegúrate de que el archivo ejecutable tenga permisos de ejecución. Si encuentras problemas, puedes otorgarlos manualmente:

  ```bash
  chmod +x hello_world
  ```

- **Configuración de GDB:**

  Si es la primera vez que usas GDB, puedes necesitar instalarlo:

  ```bash
  sudo apt-get update
  sudo apt-get install gdb
  ```

- **Gestión de Git:**

  - Asegúrate de haber configurado tu nombre de usuario y correo electrónico en Git:

    ```bash
    git config --global user.name "Tu Nombre"
    git config --global user.email "tu_email@example.com"
    ```

  - Si utilizas autenticación por token en GitHub, considera configurar un **Personal Access Token** y usarlo en lugar de tu contraseña al hacer push.

- **Extensibilidad del Makefile:**

  Este Makefile es básico y puede ser extendido para incluir más funcionalidades, como pruebas automatizadas, generación de documentación, etc.

---

Este conjunto de herramientas técnicas, incluyendo el **Makefile**, facilita la gestión y el desarrollo del programa en ensamblador ARM64, permitiendo una compilación eficiente, depuración, ejecución y gestión de versiones a través de GitHub.
