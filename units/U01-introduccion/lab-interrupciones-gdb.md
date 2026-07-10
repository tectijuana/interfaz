# Lab guiado — Interrupciones y llamadas al sistema con GDB+GEF

**Unidad:** U1, subtemas 1.4 (interrupciones) y 1.5 (llamadas a servicios del sistema)
**Requisitos:** entorno ARM64 con `gdb` + GEF (ver `../U01.1-setupCompilador/`) y la práctica
P01 compilada (`practicas/P01-hola-arm64`).

## Idea central
En ARM64/Linux un programa de usuario no "llama funciones" del sistema operativo:
provoca una **excepción síncrona** con la instrucción `svc #0` (SuperVisor Call). El
procesador cambia a nivel privilegiado (EL0 → EL1), salta al **vector de excepciones**
del kernel, y éste atiende la petición indicada por `x8`. Las interrupciones de hardware
(IRQ) usan el mismo mecanismo de vectores, pero son **asíncronas**.

## Sesión paso a paso

```bash
cd practicas/P01-hola-arm64
make build
gdb ./prog
```

Dentro de GDB/GEF:

```gdb
break _start
run
si            # avanza instrucción por instrucción; observa el panel de registros
```

1. **Antes del `svc`**: detente en la línea `svc #0` y anota `x8` (¿64 = write?),
   `x0`, `x1`, `x2`. Ese es el "contrato" de la llamada: número de servicio + argumentos.
2. **Cruza la frontera**: ejecuta `si` sobre `svc #0`. ¿GDB te mostró el código del kernel?
   No — el usuario **no puede ver EL1**; solo observas que al regresar `x0` cambió
   (bytes escritos). Verifícalo con `p $x0`.
3. **Atrapa la syscall desde afuera**:
   ```gdb
   catch syscall write
   run
   ```
   GDB se detiene en la entrada Y en la salida de la syscall — estás viendo la
   interrupción de software como evento, no como instrucción.
4. **Strace, la vista completa** (fuera de GDB):
   ```bash
   strace ./prog
   ```
   Identifica `write(1, "Hola...", 20)` y `exit(0)`. Compara con tus anotaciones.
5. **Interrupciones de hardware** (asíncronas, para contrastar):
   ```bash
   cat /proc/interrupts | head -20
   ```
   Cada fila es una fuente IRQ que el kernel atiende con el mismo mecanismo de vectores.

## Entregable
Asciinema de la sesión + medio párrafo respondiendo:
- ¿Qué diferencia hay entre una excepción síncrona (`svc`) y una IRQ?
- ¿Por qué el número de syscall va en `x8` y no en `x0`? ¿Quién define ese contrato (ABI)?
- ¿Qué pasaría si `x8` lleva un número de syscall inexistente? Pruébalo y reporta `x0`.
