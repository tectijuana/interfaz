# Portar una rutina en ensamblador de ARM a RISC-V: guía práctica
- **Alumno:** Rosas Cruz Carlos Daniel
- **Numero de control:** 23212064

# Introduccion
## Guía práctica para portar rutinas de ensamblador: ARM64 (AArch64) a RISC-V (RV64I)

Esta guía ofrece una referencia técnica directa para desarrolladores de sistemas e ingenieros de firmware que necesiten migrar rutinas escritas en ensamblador desde la arquitectura **ARM64 (AArch64 / ARMv8-A)** hacia **RISC-V de 64 bits (RV64I base)**.

---

## 1. Mapeo de Registros

Mientras que ARM64 utiliza una convención rígida basada en números de registro (`X0`-`X30`), RISC-V utiliza nombres de la ABI (Application Binary Interface) que identifican explícitamente el propósito de cada registro (`a0`-`a7`, `t0`-`t6`, `s0`-`s11`).

### Tabla comparativa de registros de propósito general

| Rol / Uso | ARM64 (AArch64) | RISC-V (RV64I ABI) | Nombre Físico RISC-V | Preservación |
| :--- | :--- | :--- | :--- | :--- |
| **Registro Zero** | `XZR` / `WZR` | `zero` | `x0` | N/A (Constante `0`) |
| **Dirección de Retorno** | `X30` (`LR`) | `ra` | `x1` | Caller-saved |
| **Stack Pointer** | `SP` | `sp` | `x2` | Callee-saved |
| **Global Pointer** | N/A | `gp` | `x3` | No aplica / Global |
| **Thread Pointer** | `TPIDR_EL0` (Especial) | `tp` | `x4` | No aplica / Thread |
| **Temporales** | `X9` – `X15` | `t0` – `t2`<br>`t3` – `t6` | `x5` – `x7`<br>`x28` – `x31` | Caller-saved |
| **Frame Pointer** | `X29` (`FP`) | `s0` / `fp` | `x8` | Callee-saved |
| **Registros Guardados** | `X19` – `X28` | `s1`<br>`s2` – `s11` | `x9`<br>`x18` – `x27` | Callee-saved |
| **Argumentos / Retorno** | `X0` – `X7` | `a0` – `a7` | `x10` – `x17` | Caller-saved (`a0`-`a1` para retorno) |
| **Temporales Adicionales**| `X16`, `X17` (IP0, IP1) | Mapeados a `t0`-`t6` | N/A | Caller-saved |

### Equivalencias clave en la Convención de Llamadas
* **Paso de argumentos:** ARM64 usa `X0`–`X7` (8 registros). RISC-V usa `a0`–`a7` (`x10`–`x17`, 8 registros).
* **Valores de retorno:** ARM64 retorna en `X0` (y `X1` para 128 bits). RISC-V retorna en `a0` (y `a1` para estructuras de dos palabras).
* **Callee-saved (Guardados por el llamado):** En ARM64 son `X19`–`X28` más `FP` (`X29`). En RISC-V son `s0`–`s11` (`x8`–`x9`, `x18`–`x27`).
* **Caller-saved (Guardados por el llamador):** En ARM64 son `X0`–`X18`. En RISC-V son `a0`–`a7` y `t0`–`t6`.

---

## 2. Mapeo de Instrucciones Comunes

RISC-V es una arquitectura RISC pura extremadamente reducida (filosofía Load/Store estricta) en comparación con ARM64. En RISC-V no existen modismos de direccionamiento complejo integrados en las instrucciones aritméticas, ni flags implícitos de condición (`NZCV`).

### Tabla de equivalencia de instrucciones

| Categoría | Operación | ARM64 (AArch64) | RISC-V (RV64I) | Notas sobre la traducción |
| :--- | :--- | :--- | :--- | :--- |
| **Movimiento** | Copiar registro | `mov x1, x2` | `mv a1, a2` | Pseudo-instrucción: `addi a1, a2, 0` |
| | Cargar Inmediato | `mov x1, #42` | `li a1, 42` | Pseudo-instrucción (`addi` o `lui`+`addi`) |
| **Aritmética** | Suma | `add x1, x2, x3` | `add a1, a2, a3` | Idéntico comportamiento |
| | Suma con Inmediato | `add x1, x2, #10` | `addi a1, a2, 10` | Inmediato firmado de 12-bit en RISC-V |
| | Resta | `sub x1, x2, x3` | `sub a1, a2, a3` | Idéntico comportamiento |
| **Lógica** | AND / OR / XOR | `and/orr/eor x1, x2, x3` | `and/or/xor a1, a2, a3` | Mapeo directo |
| | Desplazamientos | `lsl/lsr/asr x1, x2, #2` | `slli/srli/srai a1, a2, 2` | Lógico izq/der y Aritmético der |
| **Carga Memoria** | Cargar Word (32b) | `ldr w1, [x2]` | `lw a1, 0(a2)` | `lw` extiende el signo a 64 bits |
| | Cargar Double (64b)| `ldr x1, [x2]` | `ld a1, 0(a2)` | Carga directa de 64 bits |
| **Almacenamiento**| Guardar Word (32b) | `str w1, [x2]` | `sw a1, 0(a2)` | Guarda los 32 bits inferiores |
| | Guardar Double (64b)| `str x1, [x2]` | `sd a1, 0(a2)` | Guarda los 64 bits completos |
| **Saltos** | Salto incondicional | `b label` | `j label` | Pseudo-instrucción: `jal zero, label` |
| | Llamada a función | `bl function` | `call function` | Pseudo-instrucción: `jal ra, function` |
| | Retorno de función | `ret` | `ret` | Pseudo-instrucción: `jalr zero, 0(ra)` |
| **Control Flujo** | Salto si igual | `cmp x1, x2` <br> `b.eq label` | `beq a1, a2, label` | RISC-V evalúa registros directamente |
| | Salto si no igual | `cmp x1, x2` <br> `b.ne label` | `bne a1, a2, label` | Sin registro de flags intermediarios |
| | Salto si menor que | `cmp x1, x2` <br> `b.lt label` | `blt a1, a2, label` | Comparación con signo (`bltu` para sin signo) |

### El Registro Cero: ARM64 (`XZR`) vs. RISC-V (`x0 / zero`)
* **ARM64 (`XZR` / `WZR`):** Es un registro pseudo-físico. Leer de `XZR` entrega el valor `0`. Escribir en `XZR` descarta el resultado (útil para generar flags en instrucciones como `subs xzr, x1, x2`).
* **RISC-V (`x0` / `zero`):** Es el registro hardware `x0` cableado a cero lógico permanentemente. Las escrituras en `x0` se ignoran silenciosamente.
* **Uso pragmático en RISC-V:** `x0` es la base del ensamblador RISC-V. Muchas instrucciones fundamentales son pseudo-instrucciones que usan `x0`:
  * `nop` $\rightarrow$ `addi x0, x0, 0`
  * `mv a0, a1` $\rightarrow$ `addi a0, a1, 0`
  * `j label` $\rightarrow$ `jal x0, label`

---

## 3. Manejo de Memoria y Modos de Direccionamiento

ARM64 destaca por sus potentes modos de direccionamiento que realizan cálculo de direcciones e incrementos en una sola instrucción. **RISC-V no soporta ningún modo de direccionamiento autoincrementable o escalado.**

### Modos de direccionamiento en ARM64 vs. RISC-V

1. **Base + Desplazamiento Directo:**
   * ARM64: `ldr x0, [x1, #16]`
   * RISC-V: `ld a0, 16(a1)` *(Único modo soportado nativamente en RV64I)*

2. **Pre-incremento (Pre-indexed):**
   * ARM64: `ldr x0, [x1, #16]!` *(Suma 16 a `x1` y luego carga la memoria desde la nueva dirección)*.
   * RISC-V: Requiere 2 instrucciones explícitas.
     ```assembly
     addi a1, a1, 16    # Actualiza el puntero primero
     ld   a0, 0(a1)     # Carga desde la nueva dirección
     ```

3. **Post-incremento (Post-indexed):**
   * ARM64: `ldr x0, [x1], #16` *(Carga desde `x1` y luego suma 16 a `x1`)*.
   * RISC-V: Requiere 2 instrucciones explícitas.
     ```assembly
     ld   a0, 0(a1)     # Carga desde la dirección actual
     addi a1, a1, 16    # Incrementa el puntero
     ```

4. **Direccionamiento Escalado (Register Offset / Shifted Register):**
   * ARM64: `ldr x0, [x1, x2, lsl #3]` *(Dirección = `x1 + (x2 * 8)`)*.
   * RISC-V: Debe calcularse la dirección en un registro temporal primero.
     ```assembly
     slli t0, a2, 3     # t0 = index * 8
     add  t0, a1, t0    # t0 = base + offset
     ld   a0, 0(t0)     # Carga de la dirección calculada
     ```

---

## 4. Convención de Llamadas (Calling Conventions) y Pila

### Alineación del Stack Pointer (SP)
* **ARM64:** Exige estricta alineación de `SP` a **16 bytes** (128 bits) en cualquier acceso a memoria usando `SP`. Intentar usar una alineación de 8 bytes provocará una excepción de desalineación de hardware (`Alignment Fault`).
* **RISC-V (RV64I ABI):** Exige también alineación de `sp` a **16 bytes** al momento de realizar la llamada a una función (`call`). Sin embargo, internamente dentro del prólogo/epílogo se asignan bloques múltiples de 16 bytes.

### Estructura del Prólogo y Epílogo

En ARM64 es común usar instrucciones de carga/almacenamiento por pares (`stp` / `ldp`). RISC-V carece de instrucciones para pares de registros, por lo que las operaciones de la pila se realizan registro por registro (`sd` / `ld`).

#### Estructura ARM64:
```assembly
// Prólogo ARM64
stp     x29, x30, [sp, #-32]!  // Reserva 32 bytes en SP y guarda FP (x29) y LR (x30)
mov     x29, sp                // Establece Frame Pointer
stp     x19, x20, [sp, #16]    // Guarda registros callee-saved

// ... Cuerpo de la función ...

// Epílogo ARM64
ldp     x19, x20, [sp, #16]    // Restaura registros callee-saved
ldp     x29, x30, [sp], #32    // Restaura FP, LR y libera 32 bytes de pila
ret                            // Retorna usando LR (x30)
```
### Ejemplo Práctico de Portabilidad (Paso a Paso)
# Ejemplo Práctico de Portabilidad: ARM64 a RISC-V (RV64I)

A continuación se presenta el proceso paso a paso para portar una función real de producción que busca el **valor máximo** dentro de un arreglo de enteros firmados de 32 bits (`int32_t`).

---

## 1. Definición de la Función en C

Para mantener el contexto del problema, la función tiene la siguiente firma en C:

```c
#include <stdint.h>
#include <stddef.h>

int32_t find_max_int32(const int32_t *array, size_t count);
```
### Implementación Original en ARM64
```c
.global find_max_int32
.type find_max_int32, %function

find_max_int32:
    // Entradas: X0 = array, X1 = count
    ldr     w2, [x0], #4        // w2 = max_val = array[0]; x0 += 4
    subs    x1, x1, #1          // count--; actualiza flags NZCV
    b.eq    .Ldone              // Si count == 0, termina inmediatamente

.Lloop:
    ldr     w3, [x0], #4        // w3 = array[i]; x0 += 4
    cmp     w3, w2              // Compara array[i] con max_val
    csel    w2, w3, w2, gt      // Si w3 > w2 (signed), w2 = w3

    subs    x1, x1, #1          // count--
    b.ne    .Lloop              // Si count != 0, continúa el bucle

.Ldone:
    sxtw    x0, w2              // Extiende el signo de 32 bits (w2) a 64 bits (x0)
    ret
```
### Implementación Traducida en RISC-V (RV64I)
```c
.global find_max_int32
.type find_max_int32, @function

find_max_int32:
    # Entradas: a0 = array, a1 = count
    lw      t0, 0(a0)           # t0 (max_val) = array[0] (lw extiende el signo a 64 bits)
    addi    a0, a0, 4           # array++ (Avanza 4 bytes manualmente)
    addi    a1, a1, -1          # count--
    beqz    a1, .Ldone          # Si count == 0, salta al final

.Lloop:
    lw      t1, 0(a0)           # t1 = array[i]
    addi    a0, a0, 4           # array++ (Avanza 4 bytes)

    # Reemplazo de CSEL mediante bifurcación explícita
    ble     t1, t0, .Lskip_max  # Si t1 <= t0 (con signo), salta la actualización
    mv      t0, t1              # t0 = t1 (Nuevo máximo)

.Lskip_max:
    addi    a1, a1, -1          # count--
    bnez    a1, .Lloop          # Si count != 0, continúa el bucle

.Ldone:
    mv      a0, t0              # Coloca el resultado en a0 para el retorno
    ret
```



