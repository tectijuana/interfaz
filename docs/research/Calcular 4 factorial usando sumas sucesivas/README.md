#### Nombre: Estephania Esqueda Cárdenas No. Control. 22211557
# Práctica. Calcular 4 factorial usando sumas sucesivas

# Cálculo de 4 Factorial usando Sumas Sucesivas

## Introducción

El cálculo de factoriales es una operación matemática fundamental que aparece en múltiples áreas de las matemáticas, la estadística, la computación y la ingeniería. El factorial de un número entero positivo $n$, denotado como $n!$, se define como el producto de todos los enteros positivos desde 1 hasta $n$. Por ejemplo, $4! = 4 \times 3 \times 2 \times 1 = 24$. En la práctica computacional, este cálculo se realiza de manera directa mediante multiplicaciones. Sin embargo, en este proyecto se explora un enfoque alternativo: calcular el factorial de un número utilizando únicamente **sumas sucesivas** implementadas en lenguaje ensamblador.

Este enfoque no solo permite comprender a profundidad cómo se descomponen operaciones complejas en operaciones aritméticas más básicas, sino que también fortalece la comprensión del funcionamiento de bajo nivel de la computadora. Además, brinda una experiencia educativa significativa en el manejo del lenguaje ensamblador y el uso de registros, saltos condicionales y ciclos.

## Desarrollo Técnico

Para calcular $4!$ se requiere efectuar las operaciones:

$4! = 4 \times 3 \times 2 \times 1 = 24$

Dado que solo se permite el uso de sumas sucesivas, debemos descomponer cada multiplicación en una secuencia de sumas. Por ejemplo:

* $3 \times 2 = 2 + 2 + 2 = 6$
* $4 \times 6 = 6 + 6 + 6 + 6 = 24$

De esta manera, el algoritmo general será:

1. Inicializar un acumulador con el valor 1.
2. Iterar desde 2 hasta 4, multiplicando el acumulador por cada valor usando sumas sucesivas.
3. Al finalizar, el acumulador contendrá el valor de $4!$.

### Implementación en Ensamblador

A continuación se presenta un ejemplo de código en ensamblador (x86, sintaxis NASM) que calcula $4!$ mediante sumas sucesivas:

```asm
section .data
    resultado db 0

section .bss
    temp resb 1

section .text
    global _start

_start:
    mov eax, 1          ; acumulador = 1
    mov ebx, 2          ; contador desde 2

ciclo_externo:
    cmp ebx, 5          ; ¿llegamos a 5? (fin)
    je fin

    mov ecx, eax        ; ecx = acumulador actual
    mov edx, 0          ; edx = resultado parcial
    mov esi, ebx        ; multiplicador actual

ciclo_interno:
    cmp esi, 0
    je guardar
    add edx, ecx        ; suma sucesiva
    dec esi
    jmp ciclo_interno

guardar:
    mov eax, edx        ; actualizar acumulador
    inc ebx             ; siguiente número
    jmp ciclo_externo

fin:
    mov [resultado], al ; guardar en memoria el resultado final (24)

    ; Finalizar programa
    mov eax, 60         ; syscall: exit
    xor edi, edi        ; código de salida 0
    syscall
```

Este programa implementa dos ciclos:

* **Ciclo externo**: controla el rango de multiplicadores (de 2 a 4).
* **Ciclo interno**: implementa la multiplicación como suma sucesiva.

El resultado final, 24, se guarda en la variable `resultado` en memoria.

### Explicación Detallada del Código

* **Registros utilizados**:

  * `EAX`: Acumulador principal, donde se almacia el resultado parcial.
  * `EBX`: Contador de iteración, representa el número por el que se multiplica.
  * `ECX`: Copia del valor del acumulador para realizar sumas sucesivas.
  * `EDX`: Resultado parcial de la multiplicación.
  * `ESI`: Controla el número de sumas a realizar.
 
  <img width="1240" height="470" alt="image" src="https://github.com/user-attachments/assets/8f49aecc-e239-4803-87c7-66204398d308" />


* **Ciclo interno**: simula la multiplicación como una serie de sumas repetidas.

* **Ciclo externo**: avanza por cada número hasta 4, actualizando el acumulador.

Este enfoque, aunque poco eficiente comparado con el uso de multiplicaciones directas, es un excelente ejercicio de programación de bajo nivel.

## Conclusiones

El cálculo de factoriales mediante sumas sucesivas en lenguaje ensamblador permite comprender cómo operaciones de alto nivel pueden descomponerse en operaciones básicas. Si bien este método no es eficiente en términos de rendimiento, resulta pedagógicamente valioso para el entendimiento de la arquitectura del computador y la lógica de programación en bajo nivel.

Implementar este procedimiento refuerza el manejo de registros, ciclos y operaciones aritméticas elementales en ensamblador. Además, este proyecto evidencia la importancia de abstraer operaciones complejas a nivel de hardware, donde la multiplicación en realidad puede implementarse como un conjunto de sumas y desplazamientos.

En conclusión, este trabajo logra mostrar el potencial del lenguaje ensamblador como herramienta de aprendizaje y como base para la comprensión profunda de la computación.

## Bibliografía

* Tanenbaum, A. S., & Austin, T. (2012). *Structured Computer Organization*. Pearson.
* Bryant, R., & O’Hallaron, D. (2015). *Computer Systems: A Programmer's Perspective*. Pearson.
* NASM Documentation. (2023). *The Netwide Assembler*. Recuperado de: [https://www.nasm.us/doc/](https://www.nasm.us/doc/)
* Stallings, W. (2018). *Computer Organization and Architecture: Designing for Performance*. Pearson.
