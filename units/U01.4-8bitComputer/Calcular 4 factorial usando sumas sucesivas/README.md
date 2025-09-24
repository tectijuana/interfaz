#### Alumno: Estephania Esqueda Cardenas / No. Control. 22211557

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

```; Factorial de 4 usando sumas sucesivas
; Resultado esperado = 24

start:
    clra             ; Limpia registros
    data Ra, 1       ; Resultado inicial = 1
    data Rb, 2       ; Multiplicar por 2
    call multiply

    data Rb, 3       ; Multiplicar por 3
    call multiply

    data Rb, 4       ; Multiplicar por 4
    call multiply

    mov Rd, Ra       ; Mostrar resultado en display
    hlt              ; Fin del programa

; -------------------------------
; Subrutina multiply: Ra = Ra * Rb
; Usa sumas sucesivas
; Entrada: Ra = valor acumulado, Rb = multiplicador
; -------------------------------
multiply:
    mov Rc, Ra       ; Guardar valor original
    mov Rd, Rb       ; Usar Rd como contador (copiamos Rb aquí)
    data Ra, 0       ; Reiniciar acumulador

.loop:
    mov Rb, Rc       ; Cargar valor original en Rb
    add Ra           ; Ra = Ra + Rb
    dec Rd           ; Decrementar contador
    jnz .loop        ; Repetir hasta que contador llegue a 0
    ret

```
<img width="1343" height="675" alt="image" src="https://github.com/user-attachments/assets/0f1fc7f0-3e56-4974-8a9b-d79f1eabc939" />
<img width="1260" height="669" alt="image" src="https://github.com/user-attachments/assets/98361393-b05f-4ba6-bcdc-631edf3a373c" />

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

