
<img width="1223" height="903" alt="image" src="https://github.com/user-attachments/assets/a530b98b-7e30-4a74-9fb2-5b597e466ee7" />


# Bot 8 bit Proboard computer assembler

https://chatgpt.com/g/g-67e07c810214819189bad584c77bbf93-8-bit-troy-breadboard-assistant

---

# Emulador:

https://cpu.visualrealmsoftware.com/?utm_source=chatgpt.com

---

## 🧠 ¿Qué es el Troy's Breadboard Computer?

Es una **computadora educativa de 8 bits** diseñada por **Troy Schrapel**, que funciona sobre una arquitectura sencilla pero completamente funcional. Simula:

* Una **unidad central de procesamiento (CPU)** con registros, flags y ALU.
* Instrucciones básicas de ensamblador.
* Entrada/salida por LCD o display decimal.
* Control de flujo, memoria, pila, y aritmética básica.

💡 **Todo esto en un entorno visual simple**, ideal para entender cómo “piensa” una computadora desde cero.

---

## 🎯 ¿Por qué es buena introducción al ensamblador ARM?

| Troy 8-Bit                                  | ARM Assembly                                                                    |
| ------------------------------------------- | ------------------------------------------------------------------------------- |
| 8 registros simples (Ra, Rb, ...)           | 16+ registros (R0-R15) con propósitos definidos                                 |
| Instrucciones básicas (`add`, `sub`, `jmp`) | Instrucciones más complejas, pero similares en lógica (`ADD`, `SUB`, `B`, etc.) |
| Sin interrupciones ni MMU                   | Con manejo avanzado de memoria y periféricos                                    |
| Enfocado en didáctica                       | Enfocado en rendimiento y flexibilidad real                                     |

---

## 🔄 Conceptos que aprendes con Troy y aplicas en ARM:

* 🧮 **Registros y operaciones básicas** (`add`, `sub`, `mov`)
* 🔁 **Saltos condicionales y ciclos** (`jnz`, `jmp`)
* 📦 **Pila y llamadas a funciones** (`push`, `pop`, `call`, `ret`)
* ⚠️ **Manejo de banderas** (`Zero`, `Carry`, `Negative`) ← también existen en ARM
* 🧠 **Pensamiento de bajo nivel**: cómo una CPU realmente ejecuta instrucciones

---

## 🧩 Conclusión

✅ **Troy's 8-bit Computer** es como aprender a manejar una bicicleta antes de subirte a una moto de carreras como **ARM**.

Si dominas Troy:

* Entenderás mejor lo que hace un compilador.
* Podrás optimizar código en ARM.
* Tendrás una base sólida para microcontroladores y sistemas embebidos.

---

## 🧪 Práctica: Verificación de Números Primos

### 🎯 **Objetivo**:

Escribir un programa que determine si un número (entre 2 y 255) es primo. Si **es primo**, mostrará `1` en el display. Si **no es primo**, mostrará su **mayor divisor distinto de sí mismo** (es decir, su mayor factor).

---

### 🔧 **Fundamento Teórico**

Un número primo:

* Solo tiene **dos divisores**: 1 y él mismo.
* Ejemplo: 7 solo se puede dividir entre 1 y 7 sin residuo.

Estrategia:

* Dado un número `N`, lo dividiremos entre `N-1, N-2, ..., 2`.
* Si alguno de esos valores **divide exactamente**, **no es primo**.
* Si **ninguno** divide sin residuo, el número **es primo**.

---

### 📜 Código Ensamblador:

```asm
; Verifica si un número es primo
; Muestra 1 si lo es, o su mayor divisor si no lo es

NUM = 19              ; Cambia este valor por el número a verificar

start:
    data Rd, NUM      ; Guarda el número original en Rd (visible en display)
    mov Rb, Rd        ; Rb = número a dividir
    dec Rb            ; Comenzamos desde NUM - 1

.loop:
    data Ra, 1        ; Ra = 1
    cmp Rb            ; ¿Rb == 1?
    jz .isPrime       ; Si sí, es primo

    mov Rc, Rd        ; Rc = número original

.checkDivision:
    sub Rc, Rb        ; Rc -= Rb
    jz .notPrime      ; Si Rc == 0, encontró divisor → no primo
    jc .next          ; Si Rc < 0, no es divisor

    jmp .checkDivision

.next:
    dec Rb
    jmp .loop

.notPrime:
    mov Rd, Rb        ; Mostrar el divisor más grande
    hlt

.isPrime:
    mov Rd, 1         ; Mostrar 1 → es primo
    hlt

```

---

### 🔍 Explicación Paso a Paso:

| Instrucción    | Explicación                                                             |
| -------------- | ----------------------------------------------------------------------- |
| `data Rd, NUM` | Guarda el número en `Rd`, que está conectado al display.                |
| `dec Rb`       | Inicia el divisor en `NUM - 1`.                                         |
| `.loop`        | Comienza la verificación.                                               |
| `mov Rc, Rd`   | Copia el número original a `Rc` para hacer restas sucesivas.            |
| `sub Rc, Rb`   | Resta el divisor de Rc.                                                 |
| `jz .notPrime` | Si Rc llega a 0 exacto → es divisible → no es primo.                    |
| `jc .next`     | Si Rc es negativo → no es divisible, probar el siguiente.               |
| `mov Rd, Rb`   | Si se encuentra un divisor → se muestra como prueba de que no es primo. |
| `mov Rd, 1`    | Si llega hasta el 1 sin encontrar divisores → es primo.                 |

---

### 🧪 Ejercicios Propuestos:

1. Cambia `NUM = 19` por `NUM = 21`. ¿Qué se muestra?
2. Prueba con `NUM = 2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`. ¿Notas el patrón?
3. ¿Puedes modificar el programa para contar cuántos divisores tiene un número?

---

### 🎓 Conclusión:

✅ Esta práctica combina:

* Lógica de programación básica.
* Uso de ciclos, comparaciones y banderas.
* Aplicación matemática: teoría de números (primos).

Y te permite practicar cómo se **implementan algoritmos de alto nivel en ensamblador**, reforzando tu comprensión de bajo nivel.

---

```asm
; Mostrar "2+7=9" en pantalla LCD

ZERO = 48                ; ASCII de '0'
NUM1 = 2
NUM2 = 7
RESULT = NUM1 + NUM2     ; Resultado (9)

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

    ; Inicializa el LCD
    lcc #LCD_INITIALIZE
    lcc #DISPLAY_MODE
    lcc #LCD_CMD_CLEAR

start:
    clra

    ; Mostrar '2'
    data Rd, NUM1
    data Rb, ZERO
    add Rd
    lcd Rd

    ; Mostrar '+'
    data Rd, 43
    lcd Rd

    ; Mostrar '7'
    data Rd, NUM2
    data Rb, ZERO
    add Rd
    lcd Rd

    ; Mostrar '='
    data Rd, 61
    lcd Rd

    ; Mostrar '9'
    data Rd, RESULT
    data Rb, ZERO
    add Rd
    lcd Rd

    hlt

```

