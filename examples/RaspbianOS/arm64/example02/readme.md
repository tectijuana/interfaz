┳┓                     ┓     
┃┃┏┓┏┳┓┏┓  ╋┓┏  ┏┓┏┓┏┳┓┣┓┏┓┏┓
┻┛┗┻┛┗┗┗   ┗┗┻  ┛┗┗┛┛┗┗┗┛┛ ┗ 



```assembly




/*=======================================================
 * Programa:     ask_name.s
 * Autor:        RENE SOLIS
 * Fecha:        14 de septiembre de 2024
 * Descripción:  Este programa en ensamblador ARM64 solicita
 *               el nombre del usuario y lo muestra en la consola 
 *               usando llamadas al sistema en Linux.
 * Compilación:  make
 *               make clean
 * Ejecución:    ./ask_name
 * Versión:      1.0
 * 
 * Código equivalente en C:
 * -----------------------------------------------------
 * #include <stdio.h>
 * int main() {
 *     char name[100];
 *     printf("Por favor, introduce tu nombre: ");
 *     fgets(name, sizeof(name), stdin);
 *     printf("Hola, %s", name);
 *     return 0;
 * }
 * -----------------------------------------------------
 =========================================================*/

.section .data
prompt:
    .asciz "Por favor, introduce tu nombre: "    // Mensaje de solicitud

greeting:
    .asciz "Hola, "                             // Mensaje de saludo

.section .bss
    .lcomm buffer, 100                          // Reserva 100 bytes para el nombre

.section .text
.global _start

_start:
    // Syscall para escribir el prompt en stdout
    mov x0, #1              // Descriptor de archivo 1: stdout
    ldr x1, =prompt         // Dirección del mensaje de solicitud
    mov x2, #32             // Longitud del mensaje de solicitud
    mov x8, #64             // Número de syscall para 'write'
    svc #0                  // Realizamos la llamada al sistema

    // Syscall para leer la entrada del usuario desde stdin
    mov x0, #0              // Descriptor de archivo 0: stdin
    ldr x1, =buffer         // Dirección del buffer para almacenar el nombre
    mov x2, #100            // Número máximo de bytes a leer
    mov x8, #63             // Número de syscall para 'read'
    svc #0                  // Realizamos la llamada al sistema
    mov x19, x0             // Guardamos el número de bytes leídos

    // Syscall para escribir el saludo "Hola, " en stdout
    mov x0, #1              // Descriptor de archivo 1: stdout
    ldr x1, =greeting       // Dirección del mensaje de saludo
    mov x2, #6              // Longitud del mensaje de saludo
    mov x8, #64             // Número de syscall para 'write'
    svc #0                  // Realizamos la llamada al sistema

    // Syscall para escribir el nombre del usuario en stdout
    mov x0, #1              // Descriptor de archivo 1: stdout
    ldr x1, =buffer         // Dirección del buffer con el nombre
    mov x2, x19             // Longitud de los datos leídos
    mov x8, #64             // Número de syscall para 'write'
    svc #0                  // Realizamos la llamada al sistema

    // Syscall para salir del programa
    mov x0, #0              // Código de estado 0: éxito
    mov x8, #93             // Número de syscall para 'exit'
    svc #0                  // Realizamos la llamada al sistema
```

### Makefile

A continuación, se incluye un `Makefile` que facilita la compilación y limpieza del proyecto.

```makefile
# Makefile para el programa ask_name en ensamblador ARM64

# Nombre del ejecutable
EXEC = ask_name

# Archivos fuente y objetos
SRC = ask_name.s
OBJ = $(SRC:.s=.o)

# Compilador y enlazador
AS = as
LD = ld

# Opciones de compilación
ASFLAGS = 
LDFLAGS = 

# Regla por defecto
all: $(EXEC)

# Regla para enlazar el ejecutable
$(EXEC): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

# Regla para ensamblar el código fuente
%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

# Regla para limpiar los archivos generados
clean:
	rm -f $(OBJ) $(EXEC)

.PHONY: all clean
```

### Instrucciones de Uso

1. **Guardar los Archivos:**

   - **Código Ensamblador:**
     
     Guarda el código ensamblador proporcionado anteriormente en un archivo llamado `ask_name.s`.
   
   - **Makefile:**
     
     Guarda el `Makefile` en el mismo directorio donde se encuentra `ask_name.s`.

2. **Compilar el Programa:**

   Abre una terminal en tu sistema Raspbian 64 bits, navega al directorio donde guardaste los archivos y ejecuta el siguiente comando:

   ```bash
   make
   ```

   Este comando ensamblará y enlazará el programa, generando un ejecutable llamado `ask_name`.

3. **Ejecutar el Programa:**

   Una vez compilado, ejecuta el programa con:

   ```bash
   ./ask_name
   ```

   El programa te pedirá que introduzcas tu nombre y luego lo mostrará en la consola.

4. **Limpiar Archivos Generados:**

   Si deseas eliminar los archivos objeto y el ejecutable generado, puedes usar:

   ```bash
   make clean
   ```

### Notas Adicionales

- **Longitudes de los Mensajes:**
  
  - El mensaje de solicitud `"Por favor, introduce tu nombre: "` tiene una longitud de **32 bytes**.
  - El mensaje de saludo `"Hola, "` tiene una longitud de **6 bytes**.

- **Buffer de Entrada:**
  
  - Se reserva un espacio de **100 bytes** para almacenar el nombre del usuario. Asegúrate de no exceder este límite al ingresar el nombre.

- **Manejo de la Entrada:**
  
  - El syscall `read` devuelve el número de bytes leídos, que se almacena en el registro `x19` para ser utilizado posteriormente al escribir el nombre de vuelta en la consola.

- **Syscalls Utilizados:**
  
  - `write` (syscall número **64**) para imprimir mensajes en la consola.
  - `read` (syscall número **63**) para leer la entrada del usuario.
  - `exit` (syscall número **93**) para finalizar el programa.

Este `Makefile` simplifica el proceso de compilación y mantenimiento del proyecto, permitiéndote compilar y limpiar fácilmente los archivos generados con simples comandos `make` y `make clean`.
