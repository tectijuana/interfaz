// ╔══════════════════════════════════════════════════════════╗
// ║  Programa : macros.s (P05 — Macros que fabrican funciones)║
// ║  Autor    : <Nombre Apellido> <No. de control>             ║
// ║  Curso    : Lenguajes de Interfaz SCC-1014                 ║
// ║  Fecha    : <AAAA-MM-DD>                                   ║
// ║  Descripción: Una macro GNU as genera tres funciones       ║
// ║  (suma, resta, mult) invocables desde C++ vía el ABI.      ║
// ╚══════════════════════════════════════════════════════════╝

// ABI AArch64: primer argumento en x0, segundo en x1, retorno en x0.
// La macro se expande al ensamblar: nm macros.o muestra las 3 funciones.

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
// - <diferencia entre esta macro y una función llamada con bl>
// - <qué muestra objdump -d macros.o respecto al texto de la macro>
