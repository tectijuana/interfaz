```
╔═════════════════════════════════════════════════════════════════════════════╗
║                                                                             ║
║   🔥🔥🔥   B L E S S I N G   🔥🔥🔥                                      ║
║                                                                             ║
║   Asignatura : [Nombre de la asignatura aquí]                               ║
║   Alumno     : Blessing Osciel Vázquez González                             ║
║   Fecha      : 2025/09/24                                                   ║
║                                                                             ║
║   Grabación (Asciinema) : https://asciinema.org/a/UJvECJc2rfXFNM3jPR8TxynH9 ║
║                                                                             ║
╚═════════════════════════════════════════════════════════════════════════════╝ 

“Arde tu pasión por el código — bienvenido al fuego creativo”
```

# 🔢 Proyecto: Número parpadeante en display (🖥️ ARM Assembly)

**Descripción breve**  
Este programa simula un número “7” que parpadea en la consola como si fuera un display LED encendiéndose y apagándose.

---

## 🧠 ¿Qué hace el programa?

Este código en lenguaje ensamblador ARM64 realiza lo siguiente:

- Muestra el número 7 por consola (`msg_on`)
- Luego borra el número (`msg_off`)
- Espera entre cada operación (delay)
- Repite el ciclo 20 veces
- Al finalizar, el programa se cierra de forma limpia

---

## 🔍 Fragmento destacado

```asm
mov x4, #20         // 🧮 Contador de repeticiones
...
bl delay            // Espera
...
subs x4, x4, #1     // Resta y verifica
b.gt loop           // Repite si quedan repeticiones
```

---

## 💾 Código completo

```asm
.section .data
msg_on:     .asciz "7\\n"         // Mostrar número (simula LED encendido)
msg_off:    .asciz "\\r \\r"      // Borrar número (simula LED apagado)

.section .text
.global _start

_start:
    mov x4, #20                 // 🧮 Contador de repeticiones (20 veces)

loop:
    // Mostrar número
    mov x0, #1
    ldr x1, =msg_on
    mov x2, #2
    mov x8, #64
    svc #0

    bl delay

    // Borrar número
    mov x0, #1
    ldr x1, =msg_off
    mov x2, #3
    mov x8, #64
    svc #0

    bl delay

    subs x4, x4, #1             // Resta 1 al contador
    b.gt loop                   // Si x4 > 0, repetir

    // Salir del programa
    mov x8, #93                 // syscall: exit
    mov x0, #0                  // código de salida 0
    svc #0

// -------------------------
// Subrutina de retardo
// -------------------------
delay:
    mov x3, #0x3FFFFF           // Ajusta para controlar velocidad
delay_loop:
    subs x3, x3, #1
    b.ne delay_loop
    ret
```

---

📺 *“Serie: Llamas del Ensamblador - Capítulo 1: El parpadeo eterno”*
