# Tema: Desensamblaje y análisis de binarios ARM y RISC-V con `objdump` y Ghidra

**Nombre:** Ledesma Valenzuela Renata Nicté
**Número de control:** 24210499

## 1. Introducción

El desensamblaje es el proceso de transformar las instrucciones codificadas de un programa compilado en una representación en lenguaje ensamblador legible para el ser humano. En arquitecturas **RISC** como **ARM (ARM32/AArch64)** y **RISC-V**, esta técnica es importante para la ingeniería inversa, la depuración de *firmware*, el análisis de software y la auditoría de seguridad.

Los binarios, que normalmente se encuentran en formatos como **ELF** en sistemas basados en Unix y Linux, contienen código máquina y datos, pero no necesariamente conservan el código fuente original.

Herramientas de línea de comandos como **`objdump`**, perteneciente a GNU Binutils, permiten realizar una inspección rápida de las secciones y del código máquina de un binario. Por otra parte, herramientas como **Ghidra** proporcionan un entorno interactivo que permite analizar funciones, referencias, símbolos y flujo de control, además de generar una representación en pseudocódigo mediante su *Decompiler*.

---

## 2. Principio de funcionamiento en ARM y RISC-V

Los binarios contienen instrucciones codificadas de acuerdo con la arquitectura para la que fueron compilados. La longitud y codificación de estas instrucciones dependen de la ISA utilizada y de las extensiones habilitadas.

Los desensambladores deben identificar correctamente la arquitectura y el modo de ejecución del binario para interpretar los bytes como instrucciones válidas.

### ARM32

ARM32 utiliza 16 registros visibles de propósito general, denominados normalmente `R0` a `R15`. Algunos tienen funciones convencionales específicas: `R13` se utiliza como `SP` (Stack Pointer), `R14` como `LR` (Link Register) y `R15` como `PC` (Program Counter).

En ARM32 existen diferentes conjuntos de instrucciones. El conjunto ARM, también denominado A32, utiliza instrucciones de 32 bits, mientras que Thumb utiliza instrucciones de 16 bits y Thumb-2 permite instrucciones de 16 y 32 bits. Por esta razón, durante el análisis es importante determinar correctamente si una región de código se ejecuta en ARM o Thumb.
![ARM ORGANIZATION – REGISTER BANK | letsembed](https://letsembed.wordpress.com/wp-content/uploads/2013/12/arm7-register-organization.jpg)
### ARM64 (AArch64)

AArch64 utiliza 31 registros generales de propósito general de 64 bits, denominados `X0` a `X30`. Estos registros también pueden utilizarse como registros de 32 bits mediante sus nombres `W0` a `W30`.

Además, determinados registros tienen funciones convencionales dentro de la arquitectura y de las convenciones de llamada. Por ejemplo, `X30` se utiliza habitualmente como registro de enlace para almacenar la dirección de retorno de una función.

### RISC-V

RISC-V utiliza, en sus variantes generales RV32I y RV64I, un conjunto de 32 registros enteros denominados `x0` a `x31`. El registro `x0` está conectado permanentemente al valor cero, mientras que los demás registros pueden utilizarse según las instrucciones y las convenciones de llamada.

A diferencia de ARM, las instrucciones de salto condicional de RISC-V realizan directamente comparaciones entre registros, por ejemplo mediante `BEQ` o `BNE`, en lugar de depender de un registro tradicional de banderas para almacenar el resultado de una comparación.

![RISC-V Instruction Sets](https://devopedia.org/images/article/110/3808.1535301636.png)
---

## 2.1 Análisis avanzado con `objdump`

`objdump` forma parte de **GNU Binutils** y permite examinar diferentes componentes de archivos objeto y ejecutables. Entre sus funciones se encuentra el desensamblaje de las secciones que contienen código máquina.

La opción `-d` permite desensamblar las secciones que contienen código ejecutable:

```bash
objdump -d <binario>
```

También es posible utilizar opciones específicas mediante `-M` para controlar determinados aspectos de la representación del ensamblador.

### Para arquitecturas ARM

En binarios ARM32 que utilizan Thumb, es importante identificar correctamente el modo Thumb antes de interpretar las instrucciones. `objdump` proporciona opciones específicas del backend ARM para controlar aspectos del desensamblado.

Por ejemplo:

```bash
objdump -d -M thumb <binario>
```

puede utilizarse para solicitar el desensamblado en modo Thumb cuando el formato y la arquitectura del archivo lo permiten.

Otra opción es:

```bash
objdump -d -M reg-names-raw <binario>
```

que permite utilizar nombres numéricos de registros, como `r13` y `r15`, en lugar de sus nombres convencionales `sp` y `pc`.

También existe:

```bash
objdump -d -M reg-names-std <binario>
```

que utiliza los nombres de registros establecidos por la convención estándar de la arquitectura.

En AArch64, `objdump` también permite controlar determinados aspectos de la representación de las instrucciones mediante opciones de desensamblado.

### Para arquitecturas RISC-V

En RISC-V, una opción útil es:

```bash
objdump -d -M numeric <binario>
```

que muestra los registros utilizando sus nombres numéricos, como `x2`, en lugar de nombres de registros asociados a la ABI, como `sp`.

También puede utilizarse:

```bash
objdump -d -M no-aliases <binario>
```

para solicitar una representación que evite determinados alias o pseudoinstrucciones del ensamblador y muestre instrucciones de la ISA base cuando existe una representación equivalente.

Es importante distinguir los **alias del ensamblador** de las **instrucciones comprimidas** de la extensión RISC-V C. Una instrucción comprimida, como `c.addi16sp`, pertenece a una extensión específica de la ISA y no es simplemente un alias de una instrucción convencional.

En determinadas versiones de GNU Binutils también pueden utilizarse opciones relacionadas con la especificación de privilegios de RISC-V para controlar la interpretación de determinados registros CSR, cuando esto es necesario para el análisis del binario.

---

## 2.2 Requisitos de entorno e integración con Ghidra

Mientras que `objdump` es especialmente útil para realizar inspecciones rápidas desde la línea de comandos y automatizar tareas mediante *scripts*, **Ghidra** proporciona un entorno interactivo para analizar el binario.

Entre sus componentes principales se encuentran:

### Listing Window

La ventana de *Listing* muestra las instrucciones desensambladas, direcciones, bytes y otra información asociada al programa. En arquitecturas ARM permite distinguir entre los diferentes modos de instrucciones cuando el análisis proporciona suficiente información para hacerlo.

### Decompiler Window

El *Decompiler* de Ghidra intenta reconstruir una representación de alto nivel similar al lenguaje C a partir de las instrucciones de bajo nivel.

Por ejemplo, un conjunto de instrucciones que realice una comparación y un salto condicional puede aparecer en el descompilador como una estructura:

```c
if (valor == 30) {
    ...
}
```

Esto facilita la comprensión del flujo de control sin tener que analizar individualmente cada instrucción.

Sin embargo, el pseudocódigo generado por Ghidra no representa necesariamente el código fuente original. Es una reconstrucción basada en el código máquina y puede variar dependiendo de la arquitectura, compilador, optimizaciones y símbolos disponibles.

### Symbol Tree

El *Symbol Tree* permite navegar por símbolos, funciones, etiquetas y otros elementos identificados durante el análisis.

En determinados ejecutables pueden aparecer símbolos o puntos de entrada como `_start`. También pueden encontrarse instrucciones específicas de la arquitectura, como `SVC` en ARM, que pueden utilizarse para solicitar servicios al sistema operativo o al entorno de ejecución.

---

## 3. Optimización del compilador y flujo de control

La optimización realizada por el compilador puede transformar las estructuras originales del código fuente. Como consecuencia, bucles, condicionales y otras estructuras pueden ser menos evidentes durante el análisis del ensamblador.

Por esta razón, el analista debe estudiar las relaciones entre instrucciones, registros, accesos a memoria y saltos para reconstruir el flujo lógico del programa.

### 3.1 Análisis de saltos y flujo de control en ensamblador

Un bloque condicional simple, como sumar dos registros, comparar el resultado y decidir si continuar o saltar a otra parte del programa, puede representarse de la siguiente manera.

### Estructura típica en ARM

```asm
ADD R2, R0, R1      // R2 = R0 + R1
CMP R2, #30         // Compara R2 con 30
BEQ done            // Salta a 'done' si R2 == 30
```

La instrucción `ADD` realiza la suma de `R0` y `R1` y almacena el resultado en `R2`. Posteriormente, `CMP` realiza una comparación y actualiza las banderas de condición. Finalmente, `BEQ` utiliza el resultado de la comparación para realizar el salto cuando los valores son iguales.

### Estructura equivalente en RISC-V

```asm
add x2, x0, x1      # x2 = x0 + x1
li x3, 30           # Carga el valor 30 en x3
beq x2, x3, done    # Salta si x2 == x3
```

En este caso, `BEQ` compara directamente los registros `x2` y `x3`. No es necesario utilizar un registro de estado equivalente a las banderas de condición de ARM.

Cabe señalar que `li` es una **pseudoinstrucción** del ensamblador RISC-V. Dependiendo del valor que se quiera cargar, el ensamblador puede traducirla a una o varias instrucciones reales de la ISA.

---

## 3.2 Descompilación de rutinas con Ghidra

El análisis de ensamblador mediante `objdump` requiere que el analista interprete manualmente las relaciones entre registros, memoria y saltos. Ghidra facilita este proceso mediante su ventana **Decompiler**, que intenta reconstruir una representación de alto nivel del programa.

Por ejemplo, una rutina de validación de contraseña podría contener en ensamblador múltiples instrucciones de carga, comparación, acceso a memoria y saltos condicionales. El descompilador puede presentar una representación similar a:

```c
undefined4 main(int param_1, char **param_2)
{
  char local_20[16];

  printf("Enter password: ");
  scanf("%15s", local_20);

  if (strcmp(local_20, "secret123") == 0) {
    puts("Access granted!");
  }
  else {
    puts("Access denied!");
  }

  return 0;
}
```

Este código debe considerarse un **ejemplo ilustrativo de una posible salida del Decompiler**. La salida real de Ghidra depende del binario analizado, la arquitectura, el compilador utilizado, el nivel de optimización, los símbolos disponibles y otra información presente en el ejecutable.

El objetivo del Decompiler no es recuperar literalmente el código fuente original, sino proporcionar una representación de alto nivel que facilite el análisis de la lógica del programa.

---

## 4. Conclusiones

El desensamblaje constituye una herramienta fundamental para estudiar programas cuando no se dispone de su código fuente. En arquitecturas ARM y RISC-V, el análisis requiere comprender la organización de los registros, la codificación de las instrucciones, las convenciones de llamada y las características específicas de cada ISA.

`objdump` permite realizar una inspección rápida y automatizable del código máquina, además de proporcionar diferentes opciones para adaptar la representación del desensamblado a la arquitectura analizada. Por otro lado, Ghidra proporciona herramientas interactivas que facilitan la identificación de funciones, referencias, símbolos y estructuras de control, además de generar una representación de alto nivel mediante su Decompiler.

Por ello, dominar tanto las instrucciones de ARM y RISC-V como las herramientas de análisis resulta fundamental para realizar procesos de ingeniería inversa, depuración, análisis de *firmware* y auditoría de software con mayor rigor técnico.

---

## 5. Referencias

[1] National Security Agency, *Ghidra Software Reverse Engineering Framework*, GitHub repository. [Online]. Available: https://github.com/NationalSecurityAgency/ghidra

[2] Free Software Foundation, *GNU Binutils — objdump documentation*. [Online]. Available: https://sourceware.org/binutils/docs/binutils/objdump.html

[3] RISC-V International, *The RISC-V Instruction Set Manual*. [Online]. Available: https://docs.riscv.org/reference/isa/

[4] Arm, *Arm Architecture Reference Manuals and Learn the Architecture documentation*. [Online]. Available: https://developer.arm.com/documentation

[5] M. Aerabi, “ARM Binary Analysis - Part 5,” *Medium*, 2024. [Online]. Available: https://medium.com/@mohamad.aerabi/arm-binary-analysis-part5-312e68bed6c7

[6] Feabhas, “Disassembling a Cortex-M Raw Binary File with Ghidra,” *Feabhas Technical Blog*, Dec. 2022. [Online]. Available: https://blog.feabhas.com/2022/12/disassembling-a-cortex-m-raw-binary-file-with-ghidra/
