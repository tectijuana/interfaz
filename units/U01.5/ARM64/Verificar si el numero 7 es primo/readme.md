/**********************************************************************
* 🥷✨⚡  NINJA SENTAI CODE RANGERS - PROGRAMA DE PODER ⚡✨🥷
* ⛩️🔥 「守るためにコードする」🔥⛩️ (Programar para Proteger)
*
* 📚 Asignatura : Lenguajes de Interfaz en TECNM Campus ITT
* 👤 Autor      : Diaz Chavelas Angel Abraham
* 📅 Fecha      : 2025/09/23
* 📝 Propósito  : Verificar si el número 7 es primo.
* No.Co         : 22211553
*
* ╭──────────────────────────────────────────────────────────╮
* │   🟥 Red Ranger   - Fuerza del algoritmo                 │
* │   🟦 Blue Ranger  - Lógica implacable                    │
* │   🟩 Green Ranger - Flujo inquebrantable                 │
* │   🟨 Yellow Ranger- Bucle infinito de valor              │
* │   🟪 Pink Ranger  - GUI y presentación                   │
* ╰──────────────────────────────────────────────────────────╯
*
* ⚔️  "¡Unidos en código, invencibles en batalla!" ⚔️
*        >>> SAGA: Digital Sentai - Defensores del Bit <<<
**********************************************************************/

# Captura del Assembly
<img width="999" height="917" alt="image" src="https://github.com/user-attachments/assets/6920f76e-f573-4b7f-9b81-7440707fc2a2" />

# Codigo
```text
🚀 Ensamblador ARM64 para Raspberry Pi OS
.global _start

.section .data
msgPrimo:    .asciz "7 es primo\n"
msgNoPrimo:  .asciz "7 no es primo\n"

.section .text
_start:
    // Guardamos el número 7 en x0
    mov     x0, #7          // n = 7
    mov     x1, #2          // i = 2
    mov     x2, #1          // esPrimo = 1 (true)

loop:
    cmp     x1, x0          // ¿i < n?
    bge     endLoop         // si i >= n -> salir del bucle

    udiv    x3, x0, x1      // x3 = n / i (división entera)
    msub    x4, x3, x1, x0  // x4 = n - (x3 * i) -> resto
    cbz     x4, notPrime    // si resto == 0, no es primo

    add     x1, x1, #1      // i++
    b       loop

notPrime:
    mov     x2, #0          // esPrimo = 0

endLoop:
    cmp     x2, #1
    beq     printPrime

    // imprime "no es primo"
    ldr     x0, =msgNoPrimo
    bl      print
    b       exit

printPrime:
    ldr     x0, =msgPrimo
    bl      print
    b       exit

// 📢 Rutina para imprimir cadenas
print:
    mov     x8, #64         // syscall write
    mov     x1, x0          // dirección del mensaje
    mov     x2, #12         // longitud aproximada
    mov     x0, #1          // stdout
    svc     0
    ret

exit:
    mov     x8, #93         // syscall exit
    mov     x0, #0
    svc     0
```
# Resultado
<img width="1157" height="645" alt="image" src="https://github.com/user-attachments/assets/6f4e27f7-f04b-4250-a95e-ae8ddafb12c1" />

# Codigo en alto nivel (Python)
```text
def es_primo(n: int) -> bool:
    """Función que verifica si un número es primo."""
    if n <= 1:
        return False
    for i in range(2, n):
        if n % i == 0:  # Si hay divisor exacto, no es primo
            return False
    return True

# Programa principal
numero = 7
if es_primo(numero):
    print(f"{numero} es primo")
else:
    print(f"{numero} no es primo")
```
