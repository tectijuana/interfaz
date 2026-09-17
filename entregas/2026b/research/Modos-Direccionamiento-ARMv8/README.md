# Modos de direccionamiento en ARMv8-A: acceso pre y post-indexado y su uso eficiente

La arquitectura ARMv8-A utiliza un modelo de memoria de carga y almacenamiento (Load/Store), lo que significa que las operaciones de procesamiento de datos (ALU) solo ocurren en los registros internos, y se requieren instrucciones específicas (`LDR`, `STR`) para interactuar con la memoria principal. Para calcular las direcciones de memoria de manera eficiente, ARMv8-A emplea varios modos de direccionamiento, destacando el **pre-indexado** y el **post-indexado** por su capacidad para actualizar automáticamente los registros base en un solo ciclo (técnica conocida como *writeback*).

## Direccionamiento Pre-indexado

En este modo, el desplazamiento (*offset*) se suma al registro base **antes** de acceder a la memoria. Una vez calculada la nueva dirección, se realiza el acceso a memoria y el registro base se actualiza de forma permanente con este nuevo valor. Se identifica visualmente por el uso del símbolo de exclamación (`!`) al final de la instrucción.

* **Sintaxis general:** `LDR Xt, [Xn, #offset]!`
* **Ejemplo práctico:** `STR W0, [X1, #4]!` (Guarda el contenido de 32 bits de `W0` en la dirección apuntada por `X1 + 4`, y actualiza `X1`).

**Funcionamiento paso a paso en hardware:**
1. **Cálculo:** Nueva Dirección = `Xn` + `offset`
2. **Writeback:** Actualizar registro base (`Xn` = Nueva Dirección)
3. **Acceso:** Cargar/Almacenar dato desde la Nueva Dirección hacia `Xt`

## Direccionamiento Post-indexado

En este modo, el acceso a la memoria se realiza utilizando el valor original (inalterado) del registro base. **Después** de realizar el acceso (carga o almacenamiento), el desplazamiento se suma al registro base, actualizándolo de forma permanente para la siguiente instrucción.

* **Sintaxis general:** `LDR Xt, [Xn], #offset`
* **Ejemplo práctico:** `LDR X2, [X3], #8` (Carga 64 bits desde la dirección en `X3` hacia `X2`, y al terminar, suma 8 a `X3`).

**Funcionamiento paso a paso en hardware:**
1. **Acceso:** Cargar/Almacenar dato desde la dirección contenida actualmente en `Xn` hacia `Xt`
2. **Cálculo:** Nueva Dirección = `Xn` + `offset`
3. **Writeback:** Actualizar registro base (`Xn` = Nueva Dirección)

## Uso eficiente en programación

Estos modos con actualización automática del registro base son fundamentales para optimizar el rendimiento y reducir el tamaño del binario (*code size*):

* **Recorrido de Arreglos (Iteraciones):** El post-indexado es ideal para recorrer arrays secuencialmente dentro de un bucle. Permite leer el elemento actual y avanzar el puntero a la siguiente posición en una sola instrucción, eliminando la necesidad de despachar una instrucción `ADD` aritmética por separado.
* **Operaciones de Pila (Stack):** El pre-indexado es el estándar para apilar datos (*Push*), ya que primero ajusta el puntero de la pila (`SP`) para reservar el espacio en memoria y luego guarda el dato. Por su parte, el post-indexado se utiliza para desapilar (*Pop*), leyendo primero el dato superior y luego restaurando el puntero a su posición anterior.

## Conclusión

El direccionamiento pre-indexado y post-indexado trascienden la simple conveniencia sintáctica para convertirse en mecanismos de hardware esenciales que reducen el tamaño del binario y optimizan el ciclo de ejecución. Al delegar la actualización aritmética de los punteros directamente a la Unidad de Generación de Direcciones (AGU) durante la misma instrucción de acceso a memoria, el procesador libera ciclos de reloj y registros de propósito general. Esto minimiza el número total de instrucciones despachadas y reduce el embotellamiento en el *pipeline*, consolidando la eficiencia y el alto rendimiento que caracterizan a los sistemas AArch64.

## Bibliografía

[1] ARM Limited, *ARM Architecture Reference Manual ARMv8, for ARMv8-A architecture profile*, Cambridge, Reino Unido: ARM, 2021.

[2] L. D. Pyeatt y W. Ughetta, *ARM 64-Bit Assembly Language*, 1.ª ed., Cambridge, MA, EE. UU.: Newnes, 2019.

[3] A. Sloss, D. Symes y C. Wright, *ARM System Developer's Guide: Designing and Optimizing System Software*, San Francisco, CA, EE. UU.: Morgan Kaufmann, 2004.
