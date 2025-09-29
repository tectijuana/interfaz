; Detectar overflow en la suma 200 + 100
; Mostrará el resultado de la suma en Rd
; y saltará a la etiqueta .overflow si hubo desbordamiento

start:
    data Ra, 100     ; Cargar 100 en Ra
    data Rb, 50     ; Cargar 50 en Rb
    add Ra           ; Ra = Ra + Rb → 200 + 100 = 44 (con overflow)
    mov Rd, Ra       ; Mostrar resultado en Rd

    ; Verificar si hubo overflow
    jo .overflow     ; Si O = 1, hubo desbordamiento
    jmp .noOverflow  ; Si no, continuar normal

.overflow:
    data Rd, 255     ; Mostrar 255 como indicador de overflow
    hlt

.noOverflow:
    data Rd, 0       ; Mostrar 0 como indicador de "sin overflow"
    hlt
