# Sentencias switch/case mediante tablas de saltos en ARM64

**Autor:** Joel Junior Canales Calderón
**Tema:** #8 — Grupo B (17:00)
**Curso:** Lenguajes de Interfaz (SCC-1014), 2026 "B"

## Introducción

En lenguajes de alto nivel como C, la sentencia `switch/case` permite seleccionar
entre múltiples rutas de ejecución según el valor de una variable. A simple vista
parece equivalente a una cadena de `if/else`, pero cuando el compilador detecta
que los valores de los `case` son consecutivos o casi consecutivos, puede generar
una **tabla de saltos** (*jump table*) en lugar de comparaciones secuenciales.
Esta investigación explica cómo se implementa ese mecanismo en ensamblador
ARM64 (AArch64), qué instrucciones intervienen y qué ventajas de rendimiento
ofrece frente al enfoque ingenuo de comparaciones encadenadas.

## Desarrollo técnico

Cuando un compilador como GCC o Clang traduce un `switch` con muchos casos
consecutivos, en lugar de generar N comparaciones (`cmp` + `beq`) evalúa el
valor una sola vez y lo usa como **índice** para saltar directamente a la
instrucción correspondiente. Esto convierte una búsqueda de complejidad O(n)
en una de complejidad O(1): sin importar cuántos `case` existan, el salto
tarda lo mismo.

El patrón típico en A64 (ARM64) sigue esta estructura:

1. **Validación de rango**: primero se compara el valor de entrada contra el
   límite superior de los casos válidos con `cmp` y una rama condicional
   (`bhi`, *branch if higher*) que desvía hacia el caso `default` si el valor
   está fuera de rango. Esto es indispensable porque la tabla de saltos solo
   cubre los valores explícitamente declarados.

2. **Cálculo de la dirección base**: se usa la instrucción `adr` para obtener
   la dirección relativa al contador de programa (PC) donde vive la tabla de
   saltos, que normalmente el compilador coloca cerca del código de la
   función (en la sección `.text`, después del cuerpo de la función).

3. **Lectura del desplazamiento**: con `ldrsw` (*Load Register Signed Word*)
   se lee de la tabla un desplazamiento de 32 bits con signo, indexado por el
   valor original desplazado (`uxtw #2`, es decir, tratado como índice de
   palabras de 4 bytes). El resultado se extiende a 64 bits en un registro
   como `x8`.

4. **Cálculo del destino final**: el desplazamiento leído se suma a una
   dirección ancla (normalmente obtenida también con `adr`) multiplicado por
   4 (`lsl #2`), ya que cada instrucción A64 ocupa 4 bytes. El resultado es
   la dirección exacta de la instrucción donde comienza el bloque de código
   de ese `case`.

5. **Salto indirecto**: finalmente, la instrucción `br` (*branch to register*)
   transfiere el control del programa a la dirección calculada.

Un ejemplo simplificado de este patrón, documentado en el blog técnico de
Microsoft sobre AArch64, luce así:

```asm
cmp   w19, #9          ; ¿está fuera del rango de casos?
bhi   do_default        ; si sí, ir al caso default
adr   x9, switch_table  ; dirección de la tabla de saltos
ldrsw x8, [x9, w19, uxtw #2]  ; leer desplazamiento con índice w19
add   x8, x9, x8, lsl #2      ; calcular dirección destino
br    x8                      ; saltar a esa dirección
```

Existen dos variantes de diseño para la tabla: una donde cada entrada es un
**puntero absoluto de código** (más simple de generar, pero ocupa 8 bytes por
entrada en direcciones de 64 bits) y otra donde cada entrada es un
**desplazamiento relativo** de 16, 32 bits (como en el ejemplo anterior), que
ocupa menos espacio y además genera código independiente de la posición
(PIC), reduciendo el número de reubicaciones que el enlazador debe resolver.
El compilador elige automáticamente cuál conviene según el rango y la
densidad de los valores de `case`.

Es importante notar que **no todos los `switch` generan tablas de salto**. Si
los valores de los casos están muy dispersos (por ejemplo, 3, 4000, 90000),
el costo en memoria de una tabla tan grande no compensa, y el compilador
recurre de nuevo a comparaciones encadenadas o a un árbol de decisiones
binario. Herramientas como Compiler Explorer (godbolt.org) permiten observar
en tiempo real qué estrategia elige GCC o Clang según cómo se escriban los
casos.

## Conclusiones

La implementación de `switch/case` mediante tablas de saltos en ARM64
demuestra cómo el compilador traduce una construcción de alto nivel en una
secuencia optimizada de instrucciones de bajo nivel que aprovechan el modo
de direccionamiento relativo al PC (`adr`), la carga indexada (`ldrsw`) y el
salto indirecto (`br`). Este mecanismo reduce la complejidad temporal de la
selección de casos de lineal a constante, a costa de un pequeño overhead de
memoria para almacenar la tabla. Comprender este patrón es útil no solo para
leer código generado por el compilador (por ejemplo, al depurar en `gdb`),
sino también para escribir manualmente rutinas eficientes en ensamblador
cuando se trabaja en sistemas embebidos con recursos limitados.

## Bibliografía

[1] ARM Limited, "A64 Instruction Set Architecture," *Arm Developer Documentation*,
2024. [Online]. Available: https://developer.arm.com/documentation/ddi0602/latest/

[2] R. Chen, "The AArch64 processor (aka arm64), part 23: Common patterns,"
*Microsoft DevBlogs — The Old New Thing*, Aug. 26, 2022. [Online]. Available:
https://devblogs.microsoft.com/oldnewthing/20220826-00/?p=107059

[3] P. Kivolowitz, "Switch and Jump Tables," *asm_book* (repositorio GitHub),
2023. [Online]. Available:
https://github.com/pkivolowitz/asm_book/blob/main/section_1/jump_tables/README.md

[4] ARM Limited, "Arm Instruction Set Reference Guide — A64 Data Transfer
Instructions," *Arm Developer Documentation*, 2023. [Online]. Available:
https://developer.arm.com/documentation/100076/0100/A64-Instruction-Set-Reference/A64-Data-Transfer-Instructions/LDRSW--literal-
