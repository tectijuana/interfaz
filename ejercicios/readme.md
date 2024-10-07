

#  Asciinema de programa 1

> Lunes: Depositar su compilacion, corrida, depuracion  GEF del programa en ASCIINEMA para IDOCEO


```assembly

// ChatGTP 4o - Fecha: 2024-10-07
// Programa en ARM64 Assembly para RaspbianOS
// Grabar esta corrida en el asciinema.org, con sus generales de estudiante, seguido de la compilación, ejecución, depuración en GEF, recuerde vincular su asciinema a su correo, evitando sea borrado en 7 días.

.data
    prompt:    .asciz "Ingrese su nombre: "  // Mensaje que se mostrará al usuario para solicitar su nombre
    buffer:    .space 100                    // Espacio reservado para almacenar el nombre ingresado por el usuario (máximo 100 caracteres)

.text
    .global _start

_start:
    // Desplegar el mensaje "Ingrese su nombre: "
    ldr x0, =1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =prompt             // Cargar en x1 la dirección del mensaje "prompt" para mostrarlo
    mov x2, #18                 // Cargar en x2 la longitud del mensaje (18 caracteres)
    mov x8, #64                 // Cargar en x8 el número de syscall para 'write' (64), que escribe en la salida estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Leer el nombre del usuario
    ldr x0, =0                  // Cargar en x0 el descriptor de archivo 0 (STDIN), que es la entrada estándar
    ldr x1, =buffer             // Cargar en x1 la dirección del buffer donde se almacenará el nombre ingresado
    mov x2, #100                // Cargar en x2 la longitud máxima a leer (100 caracteres)
    mov x8, #63                 // Cargar en x8 el número de syscall para 'read' (63), que lee de la entrada estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Desplegar el nombre ingresado
    ldr x0, =1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =buffer             // Cargar en x1 la dirección del buffer que contiene el nombre ingresado
    mov x2, #100                // Cargar en x2 la longitud máxima a desplegar (100 caracteres)
    mov x8, #64                 // Cargar en x8 el número de syscall para 'write' (64), que escribe en la salida estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Terminar el programa
    mov x8, #93                 // Cargar en x8 el número de syscall para 'exit' (93), que termina el programa
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

```

---

# Programa 2

```assembly

// ChatGTP 4o - Fecha: 2024-10-07
// Programa en ARM64 Assembly para RaspbianOS
// Grabar esta corrida en el asciinema.org, con sus generales de estudiante, seguido de la compilación, ejecución, depuración en GEF, recuerde vincular su asciinema a su correo, evitando sea borrado en 7 días.

.data
    prompt:    .asciz "Ingrese su nombre: "         // Mensaje que se mostrará al usuario para solicitar su nombre
    length_msg: .asciz "Su nombre tiene: "         // Mensaje que mostrará la longitud del nombre
    num_msg: .asciz " letras\n"                   // Mensaje que muestra la palabra "letras" y salto de línea
    buffer:    .space 100                            // Espacio reservado para almacenar el nombre ingresado por el usuario (máximo 100 caracteres)
    num_buffer: .space 10                            // Espacio reservado para almacenar la longitud convertida a cadena

.text
    .global _start

_start:
    // Desplegar el mensaje "Ingrese su nombre: "
    ldr x0, =1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =prompt             // Cargar en x1 la dirección del mensaje "prompt" para mostrarlo
    mov x2, #18                 // Cargar en x2 la longitud del mensaje (18 caracteres)
    mov x8, #64                 // Cargar en x8 el número de syscall para 'write' (64), que escribe en la salida estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Leer el nombre del usuario
    ldr x0, =0                  // Cargar en x0 el descriptor de archivo 0 (STDIN), que es la entrada estándar
    ldr x1, =buffer             // Cargar en x1 la dirección del buffer donde se almacenará el nombre ingresado
    mov x2, #100                // Cargar en x2 la longitud máxima a leer (100 caracteres)
    mov x8, #63                 // Cargar en x8 el número de syscall para 'read' (63), que lee de la entrada estándar
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Calcular la longitud del nombre ingresado
    mov x5, #0                  // Inicializar contador de longitud en x5
    ldr x6, =buffer             // Cargar la dirección del buffer en x6

count_loop:
    ldrb w7, [x6, x5]           // Leer un byte del buffer
    cmp w7, #10                 // Comparar con el carácter de nueva línea (ASCII 10)
    beq end_count               // Si es nueva línea, terminar el conteo
    cmp w7, #0                  // Comparar con el carácter nulo (fin de cadena)
    beq end_count               // Si es carácter nulo, terminar el conteo
    add x5, x5, #1              // Incrementar el contador de longitud
    b count_loop                // Repetir el ciclo

end_count:
    // Desplegar el mensaje con la longitud del nombre
    mov x0, #1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =length_msg         // Cargar en x1 la dirección del mensaje "length_msg"
    mov x2, #18                 // Cargar en x2 la longitud del mensaje
    mov x8, #64                 // syscall write para desplegar "Su nombre tiene: "
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Convertir la longitud a cadena
    mov x7, x5                  // Copiar la longitud a x7 para su conversión
    ldr x1, =num_buffer         // Cargar la dirección del buffer numérico en x1
    bl itoa                     // Llamar a la función itoa para convertir el número a cadena

    // Desplegar la longitud convertida
    mov x0, #1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =num_buffer         // Cargar en x1 la dirección del buffer con la longitud convertida
    mov x2, #10                 // Máximo 10 caracteres para la longitud convertida
    mov x8, #64                 // syscall write para desplegar la longitud
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Desplegar el mensaje " letras\n"
    mov x0, #1                  // Cargar en x0 el descriptor de archivo 1 (STDOUT), que es la salida estándar
    ldr x1, =num_msg            // Cargar en x1 la dirección del mensaje "num_msg"
    mov x2, #8                  // Cargar en x2 la longitud del mensaje " letras\n"
    mov x8, #64                 // syscall write para desplegar el mensaje
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

    // Terminar el programa
    mov x8, #93                 // Cargar en x8 el número de syscall para 'exit' (93), que termina el programa
    svc #0                      // Llamar al sistema operativo para ejecutar la syscall

// Función para convertir un número a cadena (itoa)
itoa:
    // Convertir el número en x7 a una cadena en el buffer en x1
    mov x2, x1                  // Guardar la dirección del buffer en x2
    mov w3, #10                 // Divisor (base 10)
    mov w4, #0                  // Inicializar contador de dígitos

itoa_loop:
    udiv w5, w7, w3             // Dividir el número entre 10
    msub w6, w5, w3, w7         // Obtener el residuo (w7 % 10)
    add w6, w6, #48             // Convertir el residuo a carácter ASCII
    strb w6, [x2], #1           // Almacenar el carácter en el buffer y avanzar la posición
    mov w7, w5                  // Actualizar el valor de w7 con el cociente
    add w4, w4, #1              // Incrementar el contador de dígitos
    cmp w7, #0                  // Si el cociente es 0, terminar
    bne itoa_loop               // Repetir el ciclo mientras w7 no sea 0

    // Finalizar la cadena con un carácter nulo
    mov w6, #0                  // Carácter nulo
    strb w6, [x2]               // Almacenar el carácter nulo en el buffer

    ret                         // Regresar de la función

```
