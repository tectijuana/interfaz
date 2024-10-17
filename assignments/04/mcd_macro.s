 // Archivo: mcd_macro.s
     // Descripción: Implementación de la macro MCD para ARM64 en Ubuntu 24 LTS

     .macro gcd a, b
     1:                     
         cmp \a, \b          // Comparar a y b
         b.eq 2f             // Si a == b, saltar al final
         subgt \a, \a, \b    // Si a > b, restar b de a
         sublt \b, \b, \a    // Si a < b, restar a de b
         b 1b                // Volver a comparar
     2:
     .endm

     // Función en ensamblador que calcula el MCD
     .text
     .globl gcd_func
     .type gcd_func, %function
     gcd_func:
         // Argumentos en X0 y X1 (a y b)
         gcd x0, x1          // Ejecutar la macro gcd con X0 y X1
         mov x0, x1          // Mover el resultado a X0 para retornarlo
         ret                 // Retornar el valor en X0
