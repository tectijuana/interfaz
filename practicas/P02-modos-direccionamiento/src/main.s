// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : main.s (P02 — Modos de direccionamiento)      ║
// ║  Autor    : <Nombre Apellido> <No. de control>             ║
// ║  Curso    : Lenguajes de Interfaz SCC-1014                 ║
// ║  Fecha    : <AAAA-MM-DD>                                   ║
// ║  Descripción: Demuestra 5 modos de direccionamiento de     ║
// ║  AArch64 imprimiendo un carácter por cada modo.            ║
// ╚══════════════════════════════════════════════════════════╝
//
// Datos: "ABCDE".  Cada línea de salida demuestra un modo:
//   @  ← inmediato        (el dato viene en la instrucción)
//   A  ← post-indexado    (lee [x4] y DESPUÉS avanza x4 en 1)
//   B  ← registro base    (lee [x4]; x4 quedó apuntando a 'B')
//   D  ← base + despl.    (lee [x4 + 2] sin modificar x4)
//   E  ← pre-indexado     (AVANZA x4 en 3 y después lee [x4])

        .section .data
datos:  .ascii  "ABCDE"
buf:    .byte   0            // carácter a imprimir
        .byte   10           // '\n'

        .section .text
        .global _start

_start:
        // 1) Inmediato: el operando '@' está codificado en la instrucción
        mov     w2, #'@'
        bl      print_char

        // 2) Post-indexado: lee el byte en [x4] y LUEGO x4 += 1
        ldr     x4, =datos           // (carga literal: dirección de datos)
        ldrb    w2, [x4], #1         // lee 'A'; x4 → 'B'
        bl      print_char

        // 3) Registro base: lee el byte al que apunta x4
        ldrb    w2, [x4]             // lee 'B'; x4 no cambia
        bl      print_char

        // 4) Base + desplazamiento: lee [x4 + 2] sin tocar x4
        ldrb    w2, [x4, #2]         // lee 'D'
        bl      print_char

        // 5) Pre-indexado: x4 += 3 y DESPUÉS lee [x4]
        ldrb    w2, [x4, #3]!        // x4 → 'E'; lee 'E'
        bl      print_char

        // exit(0)
        mov     x8, #93
        mov     x0, #0
        svc     #0

// ------------------------------------------------------------
// print_char: imprime el carácter en w2 seguido de '\n'
// (usa buf en .data; leaf function, no toca x4)
// ------------------------------------------------------------
print_char:
        ldr     x1, =buf
        strb    w2, [x1]
        mov     x8, #64              // write
        mov     x0, #1               // stdout
        mov     x2, #2               // carácter + '\n'
        svc     #0
        ret

// Conclusiones/Observaciones:
// - <explica con tus palabras la diferencia entre pre y post indexado>
// - <qué valor final queda en x4 y por qué>
