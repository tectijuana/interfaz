
# Tipos de Datos y Sentencias de Alto Nivel en ARM64 (Raspberry Pi 5)

## Contenidos
1. [Modos de direccionamiento en ARM64](#modos-de-direccionamiento-en-arm64)
2. [Tipos de datos](#tipos-de-datos)
3. [Instrucciones de salto](#instrucciones-de-salto)
4. [Estructuras de control de alto nivel](#estructuras-de-control-de-alto-nivel)
5. [Compilación a ensamblador](#compilación-a-ensamblador)
6. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Modos de direccionamiento en ARM64

ARM64 ofrece una variedad de **modos de direccionamiento**, que permiten acceder a la memoria de manera eficiente. Estos modos son fundamentales cuando se trabaja con grandes estructuras de datos o se realiza manipulación directa de memoria.

### Principales modos de direccionamiento en ARM64:

1. **Direccionamiento inmediato**:
   - El valor es parte de la instrucción.
   ```assembly
   mov x0, #10   // Carga el valor inmediato 10 en el registro x0
   ```

2. **Direccionamiento directo**:
   - La dirección de la memoria es directamente accesible.
   ```assembly
   ldr x1, =variable   // Carga la dirección de la variable en el registro x1
   ```

3. **Direccionamiento indirecto**:
   - Se accede a una dirección almacenada en un registro.
   ```assembly
   ldr x2, [x1]   // Carga el valor almacenado en la dirección apuntada por x1 en x2
   ```

4. **Direccionamiento con desplazamiento**:
   - Se puede acceder a posiciones relativas a una dirección base.
   ```assembly
   ldr x3, [x1, #4]   // Carga el valor en la dirección x1 + 4
   ```

---

## Tipos de datos

En ARM64, se trabaja principalmente con los siguientes tipos de datos, almacenados en diferentes tamaños y en posiciones de memoria específicas:

### Tipos principales:

- **Byte**: 8 bits.
- **Halfword**: 16 bits.
- **Word**: 32 bits.
- **Doubleword**: 64 bits (utilizado en ARM64).

#### Ejemplo:
```assembly
.data
    var_byte:     .byte 0x12
    var_half:     .hword 0x1234
    var_word:     .word 0x12345678
    var_dword:    .dword 0x123456789ABCDEF0
```

Cada tipo tiene su representación en la memoria, y ARM64 permite operar directamente con estos tipos de datos, lo que es fundamental para optimizar el uso de la memoria en aplicaciones de alto rendimiento.

---

## Instrucciones de salto

Las **instrucciones de salto** son esenciales para controlar el flujo de ejecución del programa. Permiten realizar bifurcaciones condicionales y saltos incondicionales.

### Principales instrucciones de salto:

1. **B**: Salto incondicional.
   ```assembly
   b etiqueta   // Salta a la instrucción en 'etiqueta'
   ```

2. **BL**: Salto con enlace (llamada a subrutina).
   ```assembly
   bl subrutina  // Salta a la subrutina y guarda la dirección de retorno en LR
   ```

3. **Condicionales**: Saltos según el resultado de una instrucción previa (por ejemplo, una comparación).
   ```assembly
   b.eq etiqueta  // Salta a 'etiqueta' si la comparación anterior dio como resultado "igual"
   b.ne etiqueta  // Salta a 'etiqueta' si el resultado fue "diferente"
   ```

> **Nota**: ARM64 incluye una variedad de sufijos condicionales como `eq` (igual), `ne` (no igual), `lt` (menor que), `gt` (mayor que), etc.


## Estructuras de control de alto nivel

Las **estructuras de control** permiten la ejecución secuencial, condicional y repetitiva de código en ensamblador. En ARM64, se pueden implementar usando instrucciones de salto.

### Estructuras básicas:

1. **If-Else**:
   
```assembly
   cmp x0, #10        // Compara el valor en x0 con 10
   b.eq es_igual      // Si es igual, salta a la etiqueta 'es_igual'
   // Bloque de código para "else"
   b fin_condicion
es_igual:
   // Bloque de código para "if"
fin_condicion:
```

2. **While** (bucle condicional):
```assembly
   bucle:
   cmp x1, #0        // Compara x1 con 0
   b.eq fin_bucle    // Si x1 es 0, salta al final del bucle
   sub x1, x1, #1    // Decrementa x1
   b bucle           // Repite el bucle
fin_bucle:
```

3. **For** (bucle controlado por contador):
```assembly
   mov x2, #10      // Inicializa el contador a 10
bucle_for:
   cmp x2, #0       // Compara el contador con 0
   b.eq fin_for     // Si llega a 0, finaliza el bucle
   sub x2, x2, #1   // Decrementa el contador
   b bucle_for      // Repite el bucle
fin_for:
```

---

## Compilación a ensamblador

Para compilar un programa en ARM64 ensamblador en la **Raspberry Pi 5**, utilizamos el siguiente flujo de trabajo:

1. **Escribe tu código ensamblador** en un archivo `.s`.
2. **Assemble**: Usa el comando `as` para ensamblar el archivo y generar un archivo objeto.
   ```bash
   as -o programa.o programa.s
   ```

3. **Link**: Usa el comando `ld` para enlazar el archivo objeto y crear un ejecutable.
   ```bash
   ld -o programa programa.o
   ```

4. **Ejecuta el programa**:
   ```bash
   ./programa
   ```

---

## Ejercicios prácticos

### Ejercicio 1: Suma de elementos de un vector
Escribe un programa en ensamblador ARM64 que sume todos los elementos de un vector de enteros.

#### Pseudocódigo:
1. Inicializa un vector de enteros en memoria.
2. Recorre el vector sumando cada elemento.
3. Almacena el resultado en una variable.

#### Solución en ensamblador:
```assembly
.section .data
    vector:     .word 1, 2, 3, 4, 5
    result:     .word 0

.section .text
.global _start

_start:
    mov x0, #5            // Tamaño del vector
    ldr x1, =vector       // Dirección del vector
    mov x2, #0            // Acumulador de la suma

bucle:
    ldr x3, [x1], #4      // Carga el siguiente elemento del vector
    add x2, x2, x3        // Suma el elemento al acumulador
    sub x0, x0, #1        // Decrementa el tamaño del vector
    cbnz x0, bucle        // Si no es 0, repite el bucle

    ldr x4, =result       // Dirección del resultado
    str x2, [x4]          // Almacena la suma en 'result'

    // Termina el programa
    mov x0, #93           // Syscall para salir
    svc #0
```

### Ejercicio 2: Multiplicación de dos números
Escribe un programa que multiplique dos números enteros y almacene el resultado en una variable.

---

### Conclusión

En este capítulo, hemos explorado los **modos de direccionamiento**, los **tipos de datos** y las **instrucciones de control de flujo** en ARM64 utilizando la Raspberry Pi 5. Comprender estos conceptos es fundamental para escribir programas optimizados y eficientes a bajo nivel, maximizando el rendimiento del hardware disponible.

