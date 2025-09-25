```asm
//===============================================
// Autor: Carmona Valdez Juan
// Fecha: 2025-09-23
// Descripción: Simulación de rotación de bits en ARM64
// Ejemplo: rotar 0x12345678 a la derecha 8 bits
//===============================================


       .data
msg:    .asciz "Resultado: %X\n"


       .text
       .global main
       .extern printf


main:
       // Guardar x en un registro
       mov     w0, 0x12345678     // valor original (32 bits)


       // Rotar 8 bits a la derecha
       ror     w1, w0, #8         // w1 = (w0 >> 8) | (w0 << 24)


       // Llamar a printf("Resultado: %X\n", rot)
       adrp    x0, msg            // dirección base de msg
       add     x0, x0, :lo12:msg  // puntero a string
       mov     w1, w1             // argumento con el valor rotado
       bl      printf


       // return 0
       mov     w0, 0
       ret


## 🔹 Explicación paso a paso


- `mov w0, 0x12345678` → carga el valor inicial. 
- `ror w1, w0, #8` → rota a la derecha 8 bits en 32 bits. 
- `adrp/add` → obtiene la dirección de la cadena `msg`. 
- `mov w1, w1` → prepara el argumento de `printf`. 
- `bl printf` → imprime en pantalla. 


## 📌 Notas didácticas


- En **ARM64**, `ROR` funciona tanto con registros de **32 bits (w0–w30)** como de **64 bits (x0–x30)**. 
- Si tu ensamblador **no soporta `ROR` directamente**, se puede emular con:


```asm
   lsr w2, w0, #8
   lsl w3, w0, #24
   orr w1, w2, w3


# ARM64 Assembly: Emulación de ROR con LSR y LSL


```asm
       .data
msg:    .asciz "Resultado: %X\n"


       .text
       .global main
       .extern printf


main:
       // Guardar x en un registro
       mov     w0, 0x12345678     // valor original (32 bits)


       // Emular ROR 8 bits con LSR y LSL
       lsr     w2, w0, #8         // desplaza w0 8 bits a la derecha
       lsl     w3, w0, #24        // desplaza w0 24 bits a la izquierda
       orr     w1, w2, w3         // combina ambos resultados


       // Llamar a printf("Resultado: %X\n", rot)
       adrp    x0, msg            // dirección base de msg
       add     x0, x0, :lo12:msg  // puntero a string
       mov     w1, w1             // argumento con el valor rotado
       bl      printf


       // return 0
       mov     w0, 0
       ret


## 🔹 Explicación paso a paso


- `mov w0, 0x12345678` → carga el valor original. 
- `lsr w2, w0, #8` → desplaza 8 bits a la derecha. 
- `lsl w3, w0, #24` → desplaza 24 bits a la izquierda. 
- `orr w1, w2, w3` → combina ambos resultados, emulando ROR 8 bits. 
- `adrp/add` → obtiene la dirección de la cadena `msg`. 
- `mov w1, w1` → prepara el argumento de `printf`. 
- `bl printf` → imprime en pantalla. 
- `mov w0, 0` y `ret` → retorna 0. 


## 📌 Notas didácticas


- Esta técnica emula la instrucción `ROR` usando desplazamientos y OR. 
- Funciona para rotaciones a la derecha en 32 bits. 
- En **ARM64**, los registros `w0–w30` son de 32 bits y `x0–x30` de 64 bits.



