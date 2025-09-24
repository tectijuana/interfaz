### Ulises Hernandez Bojorquez - 23210598 - Rother22
---
# Contador 0–9 en bucle (Troy’s Breadboard Computer)

Implementación de un contador que muestra **0 → 9** y reinicia a **0** en un bucle infinito usando el **assembler del Troy’s Breadboard Computer** (CPU didáctica de 8 bits).

---
![Gift](https://github.com/user-attachments/assets/0b4facdc-ffb5-4e8b-b63b-41e771bd4ea5)

---

## Objetivo

* Mostrar en la salida/display los números del **0 al 9**.
* Al llegar a **10**, reiniciar el contador a **0** y repetir.

---

## Plataforma e ISA

* **Arquitectura:** CPU educativa de **8 bits** (emulador “Troy’s Breadboard Computer”).
* **Registros usados:**

  * `Ra` — contador (acumulador).
  * `Rd` — salida/display.
  * `Rb` — constante **−10** (0xF6, complemento a dos).
  * `Rc` — temporal para restaurar `Ra`.
* **Instrucciones empleadas:** `clra`, `mov`, `inc`, `data`, `add`, `jz`, `jmp`.
  *(No existe `cmp`/`sub` inmediato; la comparación se simula sumando el negativo).*

---

## Idea del algoritmo

1. **Inicializar** `Ra = 0`.
2. **Mostrar** `Ra` en display (`mov Rd, Ra`).
3. **Incrementar** `Ra` (`inc Ra`).
4. **Detectar fin de ciclo (== 10)**:

   * Guardar copia en `Rc`.
   * Cargar `Rb = 0xF6` (−10).
   * `add Ra, Rb` ⇒ equivalente a `Ra = Ra − 10`.
   * Si el resultado es **0**, `Z=1` ⇒ `jz .reset` (reinicia).
   * Si no, **restaurar** `Ra` desde `Rc` y seguir.
5. **Repetir** con `jmp .loop`.

---

## Código

```asm
; Contador decimal 0..9 y reinicio en bucle
; Usa Ra como contador y Rd como salida/display.

.begin:
    clra               ; Ra = 0

.loop:
    mov Rd, Ra         ; mostrar Ra en el display
    inc Ra             ; Ra = Ra + 1

    ; --- ¿Ra == 10? ---
    mov Rc, Ra         ; guarda copia por si NO es 10
    data Rb, 0xF6      ; 0xF6 = -10 (complemento a dos)
    add Ra, Rb         ; Ra = Ra - 10
    jz  .reset         ; si fue 10 -> quedó en 0 => reinicia
    mov Ra, Rc         ; si NO fue 10, restaura valor original
    jmp .loop

.reset:
    clra               ; Ra = 0
    jmp .loop
```

---

## Funcionamiento esperado

El display/LEDs muestran:

```
0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, ...
```

La velocidad depende del **clock** del emulador (modo *Step* o reloj continuo).

---

## Cómo ejecutar en el emulador

1. Abrir la pestaña **Assembler** del emulador **Troy’s Breadboard Computer**.
2. Pegar el código anterior.
3. Click en **Assemble** → **Emulate**.
4. Iniciar el **clock** o usar **Step** para observar el conteo.

---

## Créditos

* Programa y documentación para el **assembler del Troy’s Breadboard Computer** (CPU educativa en protoboard).
