# Aritmética de multiprecisión (128 bits) con ADC/SBC en AArch64

## Introducción

En la arquitectura AArch64 (ARMv8), los registros de propósito general (X0 a X30) tienen una capacidad nativa de 64 bits. Para procesar números más grandes, como enteros de 128 bits (aritmética de multiprecisión), los operandos se dividen en pares de registros y las operaciones se encadenan mediante la bandera de acarreo (*Carry flag*, C) del registro de estado de condición [1].

## Desarrollo técnico

La arquitectura AArch64 no tiene registros de 128 bits para enteros de propósito general (los X0-X30 son de 64 bits), así que para representar y operar sobre valores de 128 bits se usa un par de registros de 64 bits (uno para la mitad baja, otro para la alta) junto con las instrucciones que manejan el *carry flag* (acarreo) [1], [2].

### La analogía de la suma a mano

Imagina que sumas dos números grandes en papel, columna por columna:

```
  7 4 8
+ 6 5 9
-------
```

Sumas la columna de la derecha (unidades): 8 + 9 = 17. Escribes el 7, y te "llevas 1" a la siguiente columna. Ese "1 que te llevas" es exactamente lo que en el procesador se llama *Carry flag* (bandera de acarreo).

Luego sumas la siguiente columna e incluyes ese acarreo: 4 + 5 + 1 = 10. Escribes el 0, te llevas 1 otra vez.

Finalmente: 7 + 6 + 1 = 14.

Resultado: **1 4 0 7**.

Eso es exactamente lo que hace el procesador, pero en vez de columnas de un dígito, usa "columnas" de 64 bits.

## Traduciendo esto a AArch64

### Suma de 128 bits (Adición)

Para sumar dos números de 128 bits, la operación se divide en una suma para la mitad inferior (que establece el acarreo) y una suma para la mitad superior (que consume el acarreo) [3].

- **ADDS (Add and Set Flags):** Suma las partes bajas de 64 bits y actualiza la bandera C si el resultado desborda la capacidad del registro.
- **ADC (Add with Carry):** Suma las partes altas junto con el valor residual de la bandera C.

Supongamos que el Operando A está almacenado en el par de registros (X1:X0) (donde X1 contiene los 64 bits más significativos y X0 los menos significativos) y el Operando B en (X3:X2). El resultado se almacenará en (X5:X4):

```asm
ADDS X4, X0, X2   ; Suma las partes bajas (X0 + X2) y actualiza la bandera C
ADC  X5, X1, X3   ; Suma las partes altas (X1 + X3) más el valor de C
```

### Resta de 128 bits (Sustracción)

La resta en AArch64 utiliza un concepto de **préstamo invertido** (*inverted borrow*). Al restar, la bandera C se establece en 1 si *no* se requirió un préstamo (es decir, el minuendo es mayor o igual al sustraendo). Si ocurre un préstamo, C pasa a ser 0 [1], [3].

- **SUBS (Subtract and Set Flags):** Resta las partes bajas y actualiza la bandera C.
- **SBC (Subtract with Carry):** Resta las partes altas considerando el estado de la bandera C.

Usando la misma estructura de registros para una operación (X1:X0) − (X3:X2):

```asm
SUBS X4, X0, X2   ; Resta las partes bajas (X0 - X2) y actualiza la bandera C
SBC  X5, X1, X3   ; Resta las partes altas (X1 - X3) integrando el préstamo invertido
```

## Aplicaciones

- **Criptografía avanzada:** Los algoritmos como la Criptografía de Curva Elíptica (ECC) o RSA dependen críticamente de enteros de 256 a 4096 bits. ADC y SBC permiten que las librerías matemáticas de precisión arbitraria evalúen estos datos encadenando secuencias más largas [4], [6].
- **Optimización de máquinas virtuales:** Las propuestas de aceleración para WebAssembly (como *wide-arithmetic*) destacan a la arquitectura AArch64 frente a otras por su capacidad de compilar sumas de 128 bits de manera extremadamente eficiente, ya que el diseño acoplado de ADDS/ADC evita el coste de mover los registros de estado a los registros de propósito general [5].
- **Bibliotecas BigNum:** Bibliotecas como GMP en C aprovechan directamente estas instrucciones en su código en ensamblador base para reemplazar costosas llamadas a funciones genéricas (como `__multi3` o llamadas a emulación en software), cerrando significativamente la brecha de rendimiento entre el cálculo estándar de 64 bits y la alta precisión [6].

## Conclusión

Aunque los procesadores AArch64 están diseñados para trabajar con bloques de 64 bits, estos son capaces de procesar números incluso más grandes dividiendo el trabajo, y así poder hacer operaciones matemáticas enormes sin perder velocidad.

## Referencias

[1] Arm Limited, "Arm Architecture Reference Manual for A-profile architecture," *Arm Developer*, 2026. [Online]. Available: https://developer.arm.com/documentation/ddi0487/mb/-Part-C-The-AArch64-Instruction-Set/-Chapter-C6-A64-Base-Instruction-Descriptions/-C6-1-About-the-A64-base-instructions/-C6-1-4-Condition-flags-and-related-instructions

[2] R. Chen, "The AArch64 processor (aka arm64), part 4: Addition and subtraction," *Microsoft DevBlogs — The Old New Thing*, Jul. 29, 2022. [Online]. Available: https://devblogs.microsoft.com/oldnewthing/20220729-00/?p=106915

[3] H. Oakley, "Code in ARM Assembly: Integer arithmetic," *The Eclectic Light Company*, Jul. 13, 2021. [Online]. Available: https://eclecticlight.co/2021/07/13/code-in-arm-assembly-integer-arithmetic/

[4] H. Seo, Z. Liu, P. Longa, and Z. Hu, "SIDH on ARM: Faster Modular Multiplications for Faster Post-Quantum Supersingular Isogeny Key Exchange," *IACR Transactions on Cryptographic Hardware and Embedded Systems*, vol. 2018, no. 3, pp. 1–20, 2018, doi: 10.13154/tches.v2018.i3.1-20.

[5] WebAssembly Community Group, "Wide Arithmetic Proposal — Overview," *GitHub repository WebAssembly/wide-arithmetic*. [Online]. Available: https://github.com/WebAssembly/wide-arithmetic/blob/main/proposals/wide-arithmetic/Overview.md

[6] The GNU Project, "GMP: The GNU Multiple Precision Arithmetic Library," 2018. [Online]. Available: https://gmplib.org/
