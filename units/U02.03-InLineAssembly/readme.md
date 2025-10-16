
<img width="606" height="91" alt="image" src="https://github.com/user-attachments/assets/57c78856-a51a-4be4-b623-f21a739c0fcb" />


## 🧩 ¿Qué es *Inline Assembly*?

El **Inline Assembly** (o **ensamblador incrustado**) es una técnica que permite **mezclar código de bajo nivel en lenguaje ensamblador dentro de un programa escrito en un lenguaje de alto nivel**, como C, C++, o en nuestro caso, **MicroPython**.

En otras palabras:

> Permite insertar **instrucciones del procesador (CPU)** directamente dentro del código Python, para tener un **control más preciso del hardware**.

---

## ⚙️ ¿Por qué usar Inline Assembly?

1. **Velocidad:**
   El ensamblador se ejecuta directamente en el CPU, sin interpretación. Es ideal cuando necesitas operaciones muy rápidas.

2. **Control del hardware:**
   Puedes acceder a registros del microcontrolador, puertos de entrada/salida o periféricos sin depender de librerías.

3. **Aprendizaje de arquitectura:**
   Enseña cómo funciona internamente el procesador ARM Cortex-M4 del Micro:bit v2.

---

## 💻 Cómo se usa en MicroPython (Micro:bit v2)

MicroPython permite usar **ensamblador ARM (modo Thumb)** con el decorador especial:

```python
@micropython.asm_thumb
def funcion(r0, r1):
    # Código ensamblador ARM
    add(r0, r0, r1)
```

### Significado:

* `@micropython.asm_thumb` → indica que la función siguiente usará **instrucciones ARM Thumb** (conjunto reducido de instrucciones del ARM Cortex-M4).
* `r0`, `r1`, `r2`, etc. → son **registros del procesador** que almacenan datos temporales o parámetros.
* Las instrucciones (`add`, `mov`, `sub`, etc.) son las **operaciones básicas del CPU**.

---

## 🔬 Ejemplo simple:

```python
from microbit import *

@micropython.asm_thumb
def suma(r0, r1):
    add(r0, r0, r1)  # Suma r0 + r1, guarda resultado en r0

while True:
    resultado = suma(5, 7)
    display.scroll(str(resultado))
```

Este programa:

* Envía los números `5` y `7` al ensamblador.
* Suma los valores dentro del procesador ARM.
* Devuelve el resultado a Python y lo muestra en pantalla.

---

## 🧠 En resumen:

| Concepto              | Significado                                                                   |
| --------------------- | ----------------------------------------------------------------------------- |
| **Inline Assembly**   | Ensamblador incrustado dentro de un lenguaje de alto nivel.                   |
| **Ventaja principal** | Velocidad y control directo del hardware.                                     |
| **Usado en**          | C, C++, Rust, y también MicroPython (modo Thumb).                             |
| **En Micro:bit v2**   | Se usa con `@micropython.asm_thumb` para acceder al procesador ARM Cortex-M4. |


---

### 🧩 Prompt para estudiantes

> Quiero crear un programa para **Micro:bit v2** usando **MicroPython** que incluya **código ensamblador ARM32 incrustado**.
> Por favor:
>
> 1. Muéstrame cómo usar el decorador `@micropython.asm_thumb` para integrar instrucciones ARM dentro del código Python.
> 2. Usa ejemplos compatibles con el **procesador ARM Cortex-M4** del Micro:bit v2 (nRF52833).
> 3. Incluye un **encabezado profesional de programador** con:
>
>    * Nombre del autor
>    * Fecha
>    * Dispositivo
>    * Lenguaje
>    * Descripción del programa
> 4. Explica con comentarios en español qué hace cada instrucción del ensamblador.
> 5. Muestra un ejemplo funcional, como:
>
>    * Sumar dos números en ensamblador ARM
>    * O hacer parpadear un LED usando ensamblador
> 6. El resultado debe ser **compatible con Micro:bit v2** y **ejecutable en el editor de MicroPython**.

---

### 🧠 Ejemplo de cómo lo usarían tus alumnos:

> **Prompt del estudiante:**
>
> “Genera un programa para Micro:bit v2 con MicroPython y ensamblador ARM32 incrustado que sume dos números.
> Incluye encabezado con autor, descripción y comentarios en español que expliquen cada instrucción.
> Usa el decorador `@micropython.asm_thumb` para hacerlo compatible con el procesador Cortex-M4 del Micro:bit v2.”

---

```python
# ==========================================================
#  Proyecto: Ejemplo de ensamblador ARM32 incrustado en MicroPython
#  Dispositivo: BBC Micro:bit v2 (nRF52833, ARM Cortex-M4)
#  Lenguaje: MicroPython con código ensamblador incrustado (Thumb)
#  Autor: IoTeacher
#  Fecha: Octubre 2025
#  Descripción:
#      Este programa demuestra cómo integrar instrucciones
#      ensamblador ARM dentro de MicroPython en un Micro:bit v2.
#      El ejemplo realiza la suma de dos números usando registros
#      ARM y muestra el resultado en la pantalla LED.
# ==========================================================

from microbit import *

# ----------------------------------------------------------
# Función ensamblador: suma dos números enteros (ARM Thumb)
# Parámetros:
#   r0 -> primer operando
#   r1 -> segundo operando
# Retorna:
#   r0 -> resultado (r0 + r1)
# ----------------------------------------------------------
@micropython.asm_thumb
def suma(r0, r1):
    add(r0, r0, r1)   # r0 = r0 + r1
    # El resultado se devuelve automáticamente en r0

# ----------------------------------------------------------
# Programa principal
# ----------------------------------------------------------
while True:
    a = 5
    b = 7
    resultado = suma(a, b)

    display.scroll(str(resultado))
    sleep(1000)

```


<img width="873" height="477" alt="image" src="https://github.com/user-attachments/assets/f4439b1b-7b6a-49d2-adb7-8d07bd17b0a2" />
