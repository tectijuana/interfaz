# 🏰 FANTASY RPG: RUNE SHIFT
**Asignatura:** Lenguajes de Interfaz - TECNM Campus ITT  
**Autor:** Javier Lopez Prudencio  
**Fecha:** 2025/09/25

## Descripción
Simulación de rotación de bits en un registro: desplaza las runas (bits)
para proteger el reino lógico y observar efectos visuales.

## Propósito
Visualizar y analizar operaciones de rotación (ROL/ROR) sobre registros,
incluyendo indicadores (LED) para estados de alarma o patrones especiales.

---

> 🌟 "Gira las runas. Revela el patrón. Forja tu código."  
> **Serie:** Crónicas del Código — *El Giro del Registro*


## Código original comentado (línea a línea)

```asm
    .data
msg:    .asciz "Resultado: 0x12345678 rotado: 0x78123456\n"

    .text
    .global _start

_start:
    // -----------------------------
    // 1. Preparar mensaje
    // -----------------------------
    ldr x1, =msg          // x1 <- dirección del comienzo de la cadena 'msg'
    mov x0, #1           // x0 <- file descriptor 1 (stdout)
    mov x2, 43           // x2 <- longitud del mensaje en bytes (AQUI HAY UN DETALLE, ver explicación)
    mov x8, #64          // x8 <- número de syscall: 64 = write (en Linux aarch64)
    svc 0                // invoca la syscall (es equivalente a 'syscall' en otras arquitecturas)

    // -----------------------------
    // 2. Salir del programa
    // -----------------------------
    mov x0, #0           // x0 <- código de salida 0
    mov x8, #93          // x8 <- número de syscall: 93 = exit (en Linux aarch64)
    svc 0                // invoca la syscall exit
```

---

## Explicación detallada

* `.data` / `.text`: secciones del binario. `.data` contiene datos estáticos (la cadena), `.text` contiene código ejecutable.
* `msg: .asciz "..."`: define una cadena ASCII terminada en `\0`. La `\n` dentro de la cadena es un salto de línea.
* `ldr x1, =msg`: pseudo-instrucción que el ensamblador traduce a la forma apropiada para cargar la **dirección** de `msg` en el registro `x1`. En AArch64, esto suele expandirse a `adrp` + `add` si la dirección está lejos.
* Registros usados para las syscalls en Linux AArch64:

  * `x8` contiene el número de syscall.
  * `x0`, `x1`, `x2`, ... contienen argumentos de la syscall.
  * Para `write` (syscall 64):

    * `x0` = file descriptor (1 = stdout)
    * `x1` = puntero al buffer
    * `x2` = longitud en bytes
  * Para `exit` (syscall 93):

    * `x0` = exit code
* `svc 0`: provoca la entrada en modo supervisor para ejecutar la syscall.

---

## Problema detectado: longitud del mensaje

En el código original la instrucción `mov x2, 43` pretende establecer la longitud del mensaje a 43 bytes, pero la cadena real:

```
"Resultado: 0x12345678 rotado: 0x78123456\n"
```

tiene **41 bytes** (incluyendo el `\n`, pero sin contar el terminador nulo `\0` que `.asciz` coloca al final). Usar una longitud incorrecta puede provocar que la syscall `write` lea bytes basura o muestre menos/mas caracteres de los esperados.

---

## Formas recomendadas para fijar la longitud (robusto)

1. Calcular la longitud en tiempo de ensamblado usando el ensamblador:

```asm
    .data
msg:    .asciz "Resultado: 0x12345678 rotado: 0x78123456\n"
msg_len = . - msg
```

y luego en el código:

```asm
    ldr x1, =msg
    ldr x2, =msg_len
```

Nota: algunos ensambladores no permiten `ldr x2, =msg_len` con un inmediato grande; otra opción es usar una pseudo-instrucción como `mov x2, #<valor>` si el valor cabe.

2. Poner la longitud explícita corregida (simple) si conoces el tamaño:

```asm
    mov x2, #41
```

---

## Versión corregida y recomendada (compacta)

```asm
    .data
msg:    .asciz "Resultado: 0x12345678 rotado: 0x78123456\n"
msg_len = . - msg

    .text
    .global _start

_start:
    // preparar argumentos para write
    ldr x1, =msg          // puntero al buffer
    mov x0, #1            // stdout
    mov x2, #41           // longitud correcta en bytes (alternativa: cargar msg_len)
    mov x8, #64           // syscall write
    svc 0

    // exit
    mov x0, #0            // exit code 0
    mov x8, #93           // syscall exit
    svc 0
```

> Observación: si prefieres que el ensamblador calcule `msg_len` y lo cargue automáticamente en `x2`, podrías usar macros o soluciones específicas del ensamblador (por ejemplo, `.equ` o `ldr` con la etiqueta de tamaño). Si vas a compilar para sistemas donde las direcciones pueden ser grandes (p. ej. PIE), usa `adrp`/`add` generadas por `ldr x1, =msg` y similar.

---

## Comentarios finales

* Este programa solo imprime un texto estático; no realiza la rotación real de 0x12345678 en tiempo de ejecución. El texto muestra un ejemplo de rotación (0x12345678 rotado a 0x78123456), pero la operación numérica no se realiza en el código proporcionado.
* Si quieres que el programa calcule la rotación en un registro y la imprima (por ejemplo, convertir el valor a hexadecimal y escribirlo), eso requiere implementar una rutina de conversión de entero a ASCII o enlazar con `printf` (lo cual complica el ejemplo al requerir la ABI y llamadas a librerías). Puedo ayudarte a:

  * Crear la versión que calcule la rotación en registros y la deje en `x0/x1` (sin imprimir), o
  * Crear una versión que convierta el resultado a ASCII y lo escriba por `write`, o
  * Hacer una versión que use `printf` (requiere enlazar con libc).

¿Cuál de estas opciones prefieres? Si quieres, te genero el código ensamblador completo listo para compilar con `gcc`/`as`.
