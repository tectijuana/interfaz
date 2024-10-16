.global gcd
.text
gcd:
    cmp x1, x0         // Compara a x1 con x0
    beq end            // Si son iguales, salta a fin
    blt swap           // Si x1 < x0, intercambia
    sub x1, x1, x0     // x1 = x1 - x0
    b gcd              // Llama recursivamente a gcd
swap:
    mov x0, x1         // Intercambia valores
    mov x1, x0
    sub x0, x0, x1     // x0 = x0 - x1
    b gcd              // Llama recursivamente a gcd
end:
    ret                 // Retorna
