# **Complemento a dos y detección de desbordamiento con las banderas NZCV en ARM**.

## 1. Introducción

En la arquitectura de computadoras, la representación de números con signo y la evaluación de resultados aritméticos son pilares del funcionamiento de la Unidad Aritmético Lógica (ALU). La familia de procesadores ARM, ampliamente utilizada en sistemas embebidos y dispositivos móviles, maneja la aritmética de enteros con signo mediante la notación de complemento a dos. 

A diferencia de las arquitecturas de alto nivel que abstraen los errores matemáticos mediante excepciones de software, a bajo nivel el estado de las operaciones recae íntegramente en el Registro de Estado del Programa de Aplicación (APSR). Este documento profundiza en la mecánica del complemento a dos y el papel crítico de las banderas condicionales **NZCV** (Negative, Zero, Carry, oVerflow) en la detección de desbordamientos y control de flujo en lenguaje ensamblador ARM (AArch32/AArch64).

---

## 2. Desarrollo Técnico

### 2.1 Representación en Complemento a Dos

El complemento a dos es el método matemático estándar para representar enteros con signo en hardware. Su ventaja principal es que permite que la ALU realice operaciones de suma y resta utilizando exactamente el mismo circuito digital, sin importar si los operandos son positivos o negativos. 

Para un número binario de $N$ bits, el valor se calcula asignando un peso negativo al Bit Más Significativo (MSB):
$$\text{Valor} = -b_{N-1}2^{N-1} + \sum_{i=0}^{N-2} b_i 2^i$$

Para obtener el complemento a dos de un número, se invierten todos sus bits (complemento a uno) y se le suma 1. Por ejemplo, en 8 bits:
* $+5_{10} = 00000101_2$
* Inversión: $11111010_2$
* Suma de 1: $11111011_2 = -5_{10}$

### 2.2 Las Banderas NZCV en el Registro APSR

En ARM, las operaciones aritméticas que llevan el sufijo `S` (como `ADDS`, `SUBS`, `CMP`) actualizan los cuatro bits más significativos del registro de estado (APSR):

1. **N (Negative):** Se establece en 1 si el resultado de la operación es negativo. Directamente copia el MSB del resultado.
2. **Z (Zero):** Se establece en 1 si el resultado de la operación es exactamente cero.
3. **C (Carry):** Se activa si ocurre un acarreo (carry-out) del MSB durante una suma, o si **no** ocurre un préstamo (borrow) durante una resta. Es crucial para evaluar números *sin signo* (unsigned).
4. **V (oVerflow):** Se establece en 1 si ocurre un desbordamiento aritmético en la representación de complemento a dos. Es el indicador definitivo para evaluar operaciones *con signo* (signed).

### 2.3 Diferenciación Crítica: Acarreo (C) vs. Desbordamiento (V)

El error más común en la programación a bajo nivel es confundir la bandera `C` con la bandera `V`. 
* La bandera **Carry (C)** indica que el resultado excedió la capacidad del registro considerando los datos como *enteros sin signo*.
* La bandera **Overflow (V)** indica que el resultado excedió la capacidad considerando los datos como *enteros con signo*. 

Matemáticamente, la ALU de ARM activa la bandera `V` si el acarreo de entrada al MSB es distinto al acarreo de salida del MSB. A nivel lógico:
$$V = C_{in\_MSB} \oplus C_{out\_MSB}$$

Esto sucede en solo dos escenarios de suma de complemento a dos:
1. Positivo + Positivo = Negativo (Ej: $0x7FFFFFFF + 0x00000001 = 0x80000000$)
2. Negativo + Negativo = Positivo (Ej: $0x80000000 + 0xFFFFFFFF = 0x7FFFFFFF$)

### 2.4 Control de Flujo y Ensamblador ARM

Las banderas NZCV permiten a las instrucciones de salto condicional (`B`) dirigir el flujo del programa. A continuación, se ilustra un fragmento de código ensamblador AArch64 que demuestra la detección de desbordamiento:

```assembly
    .global _start
_start:
    /* Cargar el valor máximo positivo en 32 bits (0x7FFFFFFF) */
    MOV W0, #0xFFFF
    MOVK W0, #0x7FFF, LSL #16 

    /* Cargar un 1 para provocar el desbordamiento */
    MOV W1, #1

    /* ADDS suma W0 y W1, y actualiza las banderas NZCV */
    ADDS W2, W0, W1

    /* Salto condicional evaluando la bandera V */
    BVS manejo_desbordamiento  /* Branch if oVerflow Set */
    B fin_normal

manejo_desbordamiento:
    /* Rutina para manejar el error aritmético (V=1, N=1, C=0, Z=0) */
    MOV W8, #0 
    /* ... código de manejo de error ... */

fin_normal:
    MOV X8, #93 /* syscall exit */
    SVC #0
```

## 3. Conclusiones

La abstracción de los tipos de datos en lenguajes como C o Python oculta el comportamiento real del hardware al ejecutar operaciones matemáticas. Comprender el complemento a dos y el registro APSR en ARM es indispensable para escribir código seguro y eficiente en sistemas embebidos, donde los desbordamientos aritméticos inadvertidos (como los enteros que envuelven su valor al sobrepasar el límite lógico) pueden resultar en fallas catastróficas de control. El uso correcto de las banderas `N`, `Z`, `C`, y `V` separa conceptualmente el estado físico del procesador de la interpretación lógica que el programador le da a los datos, permitiendo un control de flujo exacto y predecible a bajo nivel.

## 4. Referencias Bibliográficas

[1] ARM Limited, _ARM Architecture Reference Manual ARMv8, for ARMv8-A architecture profile_, Cambridge, Reino Unido: ARM Limited, 2021.

[2] D. Patterson y J. Hennessy, _Computer Organization and Design ARM Edition: The Hardware Software Interface_, 1.ª ed. Cambridge, MA, EE. UU.: Morgan Kaufmann, 2016, pp. 176–183.

[3] J. Yiu, _The Definitive Guide to ARM Cortex-M3 and Cortex-M4 Processors_, 3.ª ed. Oxford, Reino Unido: Newnes, 2013.

[4] B. B. Brey, _The Intel Microprocessors: 8086/8088, 80186/80188, 80286, 80386, 80486, Pentium, Pentium Pro Processor, Pentium II, Pentium III, Pentium 4, and Core2 with 64-bit Extensions_, 8.ª ed. Upper Saddle River, NJ, EE. UU.: Pearson Prentice Hall, 2009.
