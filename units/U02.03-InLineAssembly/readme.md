


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
