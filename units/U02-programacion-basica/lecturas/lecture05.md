### CAPÍTULO 4: **Instrucciones y Operaciones Lógicas en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Operaciones lógicas en ARM64](#operaciones-lógicas-en-arm64)
2. [Instrucciones de rotación y desplazamiento](#instrucciones-de-rotación-y-desplazamiento)
3. [Manipulación de bits](#manipulación-de-bits)
4. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Operaciones lógicas en ARM64

ARM64 soporta una serie de **operaciones lógicas** que permiten la manipulación de bits de manera eficiente. Estas instrucciones son fundamentales para tareas de bajo nivel como la programación de controladores de hardware, cifrado y optimización de algoritmos.

### Principales instrucciones lógicas:

1. **AND**: Realiza una conjunción bit a bit.
   ```assembly
   and x0, x1, x2  // x0 = x1 AND x2
   ```

2. **ORR**: Realiza una disyunción bit a bit (OR inclusivo).
   ```assembly
   orr x0, x1, x2  // x0 = x1 OR x2
   ```

3. **EOR**: Realiza una disyunción exclusiva (XOR).
   ```assembly
   eor x0, x1, x2  // x0 = x1 XOR x2
   ```

4. **BIC**: Borra bits específicos (AND con complemento).
   ```assembly
   bic x0, x1, x2  // x0 = x1 AND NOT x2
   ```

Estas operaciones son útiles cuando se necesita **modificar bits** específicos o realizar **comparaciones bit a bit** entre registros.

---

## Instrucciones de rotación y desplazamiento

Las **instrucciones de rotación y desplazamiento** permiten mover bits a la izquierda o derecha dentro de un registro. ARM64 incluye una variedad de estas instrucciones, que son esenciales para optimizar el procesamiento de datos a nivel binario.

### Principales instrucciones de desplazamiento:

1. **LSL (Logical Shift Left)**: Desplaza los bits a la izquierda, rellenando con ceros.
   ```assembly
   lsl x0, x1, #2  // Desplaza x1 dos posiciones a la izquierda y lo almacena en x0
   ```

2. **LSR (Logical Shift Right)**: Desplaza los bits a la derecha, rellenando con ceros.
   ```assembly
   lsr x0, x1, #2  // Desplaza x1 dos posiciones a la derecha y lo almacena en x0
   ```

3. **ASR (Arithmetic Shift Right)**: Desplaza los bits a la derecha, preservando el signo.
   ```assembly
   asr x0, x1, #2  // Desplaza x1 dos posiciones a la derecha, preservando el signo
   ```

4. **ROR (Rotate Right)**: Rota los bits hacia la derecha.
   ```assembly
   ror x0, x1, #3  // Rota x1 tres posiciones a la derecha
   ```

---

## Manipulación de bits

En ARM64, la manipulación de bits es fundamental para diversas operaciones de bajo nivel. Algunas tareas comunes incluyen establecer, borrar, o alternar bits en un registro específico.

### Instrucciones clave para la manipulación de bits:

1. **SET**: Para establecer un bit específico en 1, usamos la operación `OR`.
   ```assembly
   orr x0, x1, #0x1  // Establece el bit menos significativo de x1 en 1 y lo guarda en x0
   ```

2. **CLEAR**: Para borrar un bit específico, se usa `AND` con un valor enmascarado.
   ```assembly
   bic x0, x1, #0x1  // Borra el bit menos significativo de x1
   ```

3. **TOGGLE**: Para alternar un bit, se usa `EOR` (XOR).
   ```assembly
   eor x0, x1, #0x1  // Alterna el bit menos significativo de x1
   ```

---

## Ejercicios prácticos

### Ejercicio 1: Operación lógica combinada
Escribe un programa que realice una operación lógica combinada entre dos registros, realizando una `AND` seguida de un desplazamiento a la izquierda.

#### Pseudocódigo:
1. Carga dos valores en registros.
2. Realiza la operación `AND` entre los registros.
3. Desplaza el resultado a la izquierda.

#### Solución en ensamblador:
```assembly
.section .data
    result:     .word 0

.section .text
.global _start

_start:
    mov x0, #0xF0F0   // Carga el primer valor
    mov x1, #0x0FF0   // Carga el segundo valor

    and x2, x0, x1    // Realiza AND entre x0 y x1
    lsl x2, x2, #4    // Desplaza el resultado a la izquierda 4 bits

    ldr x3, =result   // Carga la dirección de 'result'
    str x2, [x3]      // Guarda el resultado en 'result'

    // Termina el programa
    mov x0, #93       // Syscall para salir
    svc #0
```

### Ejercicio 2: Rotación de bits
Escribe un programa que realice una rotación hacia la derecha de un registro.

#### Solución en ensamblador:
```assembly
.section .data
    result:     .word 0

.section .text
.global _start

_start:
    mov x0, #0xFF00   // Carga un valor en el registro

    ror x0, x0, #8    // Rota los bits de x0 8 posiciones a la derecha

    ldr x1, =result   // Carga la dirección de 'result'
    str x0, [x1]      // Guarda el resultado en 'result'

    // Termina el programa
    mov x0, #93       // Syscall para salir
    svc #0
```

---

En este capítulo, exploramos las **instrucciones lógicas**, las **operaciones de rotación y desplazamiento**, y la **manipulación de bits** en ARM64. Estas operaciones son esenciales para escribir código ensamblador optimizado, que maximice el uso eficiente del hardware, permitiendo un control detallado sobre las operaciones de bajo nivel.

