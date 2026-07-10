# ============================================================
#     ███╗   ██╗███████╗████████╗███████╗██╗     ██╗██╗  ██╗
#     ████╗  ██║██╔════╝╚══██╔══╝██╔════╝██║     ██║██║ ██╔╝
#     ██╔██╗ ██║█████╗     ██║   █████╗  ██║     ██║█████╔╝ 
#     ██║╚██╗██║██╔══╝     ██║   ██╔══╝  ██║     ██║██╔═██╗ 
#     ██║ ╚████║███████╗   ██║   ███████╗███████╗██║██║  ██╗
#     ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝╚══════╝╚═╝╚═╝  ╚═╝
#
# 🎬 NETFLIX CODE ORIGINALS: "Simular una pila empujando y sacando 3 valores"
#
# 📚 Asignatura: Lenguajes de Interfaz - TECNM Campus ITT
# ✍️ Autor: [HERRERA MIRANDA MARVIN JAVIER]
# 📅 Fecha: 2025/09/24
# 📝 Descripción: Programa en 8bit Simulador
#    Simular una pila empujando y sacando 3 valores.
# 🔗 Simulación Wokwi: https://wokwi.com/projects/arm64-netflix
#
# ============================================================
# 🌟 Próximamente en tu terminal:
#     *Temporada 1, Episodio 1: "El Retorno del 8"*  
# ============================================================

```asm
; PRACTICA: Simulación de pila con 3 valores
;
; Empuja tres valores a la pila y luego los extrae
; Mostrando en el display cada valor en orden inverso

start:
    clra
    data SP, 0xFF      ; inicializamos el puntero de pila al final de memoria (255)

    ; --- Empujar valores ---
    data Ra, 10        ; primer valor
    push Ra

    data Ra, 20        ; segundo valor
    push Ra

    data Ra, 30        ; tercer valor
    push Ra

    ; --- Extraer valores (LIFO) ---
    pop Rd             ; debería mostrar 30
    pop Rd             ; debería mostrar 20
    pop Rd             ; debería mostrar 10

end:
    hlt                ; detener ejecución
```
<img width="1213" height="931" alt="image" src="https://github.com/user-attachments/assets/468f6ae2-de43-4ab8-a8c2-6e3464298820" />
<img width="1202" height="896" alt="image" src="https://github.com/user-attachments/assets/93cc2546-d292-4b34-b980-e7e40de35b1d" />
<img width="1230" height="907" alt="image" src="https://github.com/user-attachments/assets/148fed86-1612-4383-8994-8d748e64ab7c" />


