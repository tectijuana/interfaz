# Generador de números pseudoaleatorios

## Código sin comentarios
```asm
section .data
    seed dd 12345678
    a dd 1664525
    c dd 1013904223
    m dd 4294967296
    newline db 10, 0
    count dd 20  ; Número de iteraciones

section .bss
    num resb 10

section .text
    global _start
    extern printf

_start:
    mov ecx, [count]  ; Cargar el contador de números a generar

generate_loop:
    mov eax, [seed]
    imul eax, [a]
    add eax, [c]
    mov [seed], eax
    call print_number
    loop generate_loop  ; Decrementa ecx y repite mientras no sea 0

    mov eax, 1
    xor ebx, ebx
    int 0x80

print_number:
    mov ecx, num + 9
    mov byte [ecx], 0
    dec ecx

convert_loop:
    mov edx, 0
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [ecx], dl
    dec ecx
    test eax, eax
    jnz convert_loop

    inc ecx
    mov eax, 4
    mov ebx, 1
    mov edx, num + 9
    sub edx, ecx
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret
```

## Código con comentarios
```asm
section .data
    seed dd 12345678          ; Semilla inicial
    a dd 1664525             ; Multiplicador
    c dd 1013904223          ; Incremento
    m dd 4294967296          ; Módulo (no se usa directamente en el código)
    newline db 10, 0         ; Caracter de nueva línea
    count dd 20              ; Número de iteraciones

section .bss
    num resb 10              ; Espacio reservado para el número convertido en string

section .text
    global _start
    extern printf

_start:
    mov ecx, [count]         ; Cargar el contador de números a generar

generate_loop:
    mov eax, [seed]          ; Cargar la semilla en eax
    imul eax, [a]            ; Multiplicar por el coeficiente 'a'
    add eax, [c]             ; Sumar el coeficiente 'c'
    mov [seed], eax          ; Guardar el nuevo valor de la semilla
    call print_number        ; Llamar a la función para imprimir el número
    loop generate_loop       ; Decrementa ecx y repite mientras no sea 0

    mov eax, 1               ; Llamada al sistema para salir del programa
    xor ebx, ebx
    int 0x80

print_number:
    mov ecx, num + 9         ; Apuntar al final del buffer
    mov byte [ecx], 0        ; Agregar terminador de cadena
    dec ecx

convert_loop:
    mov edx, 0               ; Limpiar edx para la división
    mov ebx, 10              ; Dividir por 10 para obtener el dígito menos significativo
    div ebx                  ; eax / 10, cociente en eax, residuo en edx
    add dl, '0'              ; Convertir residuo en carácter ASCII
    mov [ecx], dl            ; Almacenar el carácter en el buffer
    dec ecx                  ; Moverse hacia la izquierda en el buffer
    test eax, eax            ; Verificar si eax es 0
    jnz convert_loop         ; Si no es 0, continuar dividiendo

    inc ecx                  ; Ajustar el puntero al inicio del número
    mov eax, 4               ; Llamada al sistema para escribir en la salida estándar
    mov ebx, 1               ; Descriptor de archivo para stdout
    mov edx, num + 9
    sub edx, ecx             ; Calcular longitud de la cadena
    int 0x80

    mov eax, 4               ; Llamada al sistema para imprimir una nueva línea
    mov ebx, 1               ; Descriptor de archivo para stdout
    mov ecx, newline         ; Dirección del carácter de nueva línea
    mov edx, 1               ; Longitud de 1 byte
    int 0x80

    ret                      ; Retornar de la función
```

# Generador de números pseudoaleatorios con operaciones aritméticas

## Descripción
Este programa implementa un **Generador de números pseudoaleatorios** basado en el método congruencial lineal, utilizando operaciones aritméticas simples. Este algoritmo genera una secuencia de números que parecen aleatorios, pero que en realidad son determinísticos.

---

## ¿Cómo funciona?
El método congruencial lineal utiliza la siguiente fórmula matemática para generar números pseudoaleatorios:



Donde:
- **X(n)**: Valor actual (semilla).
- **a**: Constante multiplicativa.
- **c**: Constante aditiva.
- **m**: Módulo (limita el rango del número generado).

Cada número generado depende directamente del número anterior, lo que garantiza que la secuencia sea repetible si se utiliza la misma semilla.

---

## Explicación del código

1. **Inicialización de variables:**
   - La semilla inicial es **12345678**.
   - Las constantes **a**, **c** y **m** se utilizan para aplicar la fórmula congruencial.
   
2. **Generación del número:**
   - Se multiplica la semilla por la constante **a**.
   - Luego se suma la constante **c**.
   - El resultado se almacena nuevamente como la nueva semilla.

3. **Conversión a cadena:**
   - El número se convierte en una secuencia de dígitos ASCII para su impresión.
   - Se almacena en el búfer **num**.

4. **Impresión:**
   - Se imprime el número seguido de un salto de línea.

---

## Tabla de Variables

| Nombre | Descripción           | Valor           |
|--------|---------------------|---------------|
| `seed` | Semilla inicial     | 12345678      |
| `a`    | Constante multiplicativa | 1664525      |
| `c`    | Constante aditiva   | 1013904223    |
| `m`    | Módulo             | 4294967296    |

---

## ¿Por qué es pseudoaleatorio?
El algoritmo es **pseudoaleatorio** porque, aunque parece generar números al azar, siempre devuelve la misma secuencia si se usa la misma semilla inicial. Esto lo hace útil para simulaciones o pruebas donde se necesite reproducir los mismos resultados.

---

## Conclusión
Este programa es un ejemplo simple de cómo se pueden generar números pseudoaleatorios con operaciones aritméticas. Aunque no es adecuado para criptografía o aplicaciones de alta seguridad, sí sirve para simulaciones o pruebas básicas.



