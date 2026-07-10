// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : ops.s (P06 — Biblioteca ASM para Python)      ║
// ║  Autor    : <Nombre Apellido> <No. de control>             ║
// ║  Curso    : Lenguajes de Interfaz SCC-1014                 ║
// ║  Fecha    : <AAAA-MM-DD>                                   ║
// ║  Descripción: Las mismas funciones de P05, ahora como      ║
// ║  biblioteca compartida (libops.so) que Python carga.       ║
// ╚══════════════════════════════════════════════════════════╝

.macro  defop nombre, instr
        .global \nombre
        .type   \nombre, %function
\nombre:
        \instr  x0, x0, x1
        ret
.endm

        .text
        defop   suma,  add
        defop   resta, sub
        defop   mult,  mul

// Conclusiones/Observaciones:
// - <qué papel juega el ABI para que Python pueda llamar esto>
