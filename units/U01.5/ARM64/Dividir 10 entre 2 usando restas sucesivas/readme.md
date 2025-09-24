# ────────────────────────────────
#   ☠️  CODEX OBSCURUM  🔮
# ────────────────────────────────
# 📚 Asignatura: Lenguajes de Interfaz - TECNM Campus ITT
# 👤 Autor: Angulo Marentes Angel Gabriel
# 📅 Fecha: 2025/09/23
# 📝 Descripción: Un programa para dividir 10 entre 2 usando restas sucesivas
# ✨ "Quien domine el código, abrirá portales prohibidos." ✨

# Dividir 10 entre 2 usando restas sucesivas (En alto nivel Python)
```text
dividendo = 10
divisor = 2
cociente = 0

while dividendo >= divisor:
    dividendo -= divisor
    cociente += 1

print("Cociente:", cociente, "Residuo:", dividendo)

Salida:
Cociente: 5 Residuo: 0
```

# Dividir 10 entre 2 usando restas sucesivas (En ARM64)
1) Crear el archivo de ensamblador
```text
nano div10entre2.s
```
Dentro de Nano pegue el siguiente codigo
```text
//=========================================================
// Programa: div10entre2.s
// Autor: Angulo Marentes Angel Gabriel
// Descripción: Divide 10 entre 2 usando restas sucesivas
//=========================================================
//
// Solución en C (equivalente):
// int dividendo = 10, divisor = 2, cociente = 0;
// while (dividendo >= divisor) {
//     dividendo -= divisor;
//     cociente++;
// }
// return cociente;
//
//=========================================================

        .global _start
        .text

_start:
        mov     x0, #10        // x0 = dividendo = 10
        mov     x1, #2         // x1 = divisor   = 2
        mov     x2, #0         // x2 = cociente  = 0

bucle:
        cmp     x0, x1         // ¿dividendo >= divisor?
        blt     fin            // si no, salir
        sub     x0, x0, x1     // dividendo -= divisor
        add     x2, x2, #1     // cociente++
        b       bucle

fin:
        // x2 = cociente, x0 = residuo
        mov     x8, #93        // syscall: exit
        mov     x0, x2         // devolver cociente como exit code
        svc     #0
```
2) Ensamblar y enlazar (fuera de nano)
```text
sudo apt update
sudo apt install build-essential binutils -y
```
Ahora compile paso por paso:
```text
as -o div10entre2.o div10entre2.s   # ensamblar
ld -o div10entre2 div10entre2.o     # enlazar
```
3) Ejecucion de mi programa
```text
./div10entre2
echo $?
```
Nos mostrará 5 (porque 10 ÷ 2 = 5)

# Prueba de los comandos 
<img width="830" height="152" alt="image" src="https://github.com/user-attachments/assets/a7905000-6361-4596-bbba-305c02ce59d9" />
<img width="948" height="537" alt="image" src="https://github.com/user-attachments/assets/987f285a-f74b-4532-9d5b-896ef4e28227" />





