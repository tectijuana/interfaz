# ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
# │ ｡･:*:･ﾟ★ ✧  ~ ANIME KAWAII ~ ✧ ★ ﾟ･:*:･｡                     │
# │                                                                │
# │   🫧 Asignatura: Lenguajes de Interfaz — TECNM Campus ITT       │
# │   👤 Autor: [HERRERA MIRANDA MARVIN JAVIER 23210602]                                         │
# │   📅 Fecha: 2025/09/24                                          │
# │                                                                │
# │   📝 Descripción: Programa simple para Raspberry Pi Pico W que  │
# │   enciende un LED cuando se pulsa un botón (modo educativo).    │
# │                                                                │
# │   🔗 Simulación Wokwi: https://wokwi.com/projects/raspberry-pico-w-led-button-kawaii
# │                                                                │
# │   🎀 Tema: Anime Kawaii — colores pastel, iconos adorables y    │
# │   microcontrolador con ojos brillantes.                         │
# │                                                                │
# │   ✨ Serie: "Circuitos Chibi" — Pequeñas aventuras electrónicas  │
# ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯
# 
#   (づ｡◕‿‿◕｡)づ   ✿･ﾟ: *✧ ¡CÓDIGO CON CORAZÓN! ✧* :･ﾟ✿
#
# ------------------ INSTRUCCIONES RÁPIDAS -------------------------
# Conecta un LED (con resistencia) al GPIO indicado y un botón a GND.
# Ejecuta el script en tu Pico W (o simúlalo en Wokwi) y diviértete 💖
#
# -----------------------------------------------------------------


#
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

<img width="933" height="748" alt="image" src="https://github.com/user-attachments/assets/2f84c398-b32c-4b2a-a693-ad44be30eee3" />
<img width="939" height="729" alt="image" src="https://github.com/user-attachments/assets/d4aa30f7-fb74-4185-a7bb-28f5bade8746" />
<img width="939" height="720" alt="image" src="https://github.com/user-attachments/assets/776bdf6c-3551-460d-ae44-ce98b263819c" />
