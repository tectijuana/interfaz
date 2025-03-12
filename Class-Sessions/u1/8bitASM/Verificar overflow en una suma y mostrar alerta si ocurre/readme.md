# Verificar overflow en una suma y mostrar alerta si ocurre

Este programa se ejecuta en la plataforma **Troy's Breadboard Computer (8 bits)**. Su función es sumar dos números y verificar si la operación produce un desbordamiento (overflow). En caso de que se detecte un overflow, se muestra un valor de error en el display.

---

## Código Fuente Documentado

```assembly
;------------------------------------------------
; Programa: Verificar overflow en una suma y mostrar alerta si ocurre
; Plataforma: Troy's Breadboard Computer (8 bits)
; Autor: [Jorge Alejandro Martinez Lopez]
;------------------------------------------------

    mva #127      ; Cargar 127 en Ra (valor máximo sin signo)
    mvb #1000        ; Cargar 5 en Rb (segundo operando)
    add Ra        ; Sumar Rb a Ra (Ra = Ra + Rb), FLAGS actualizados
    jo .overflow  ; Si ocurre overflow, saltar a la alerta

    ; Si no hay overflow, mostrar el resultado en Rd
    mov Rd, Ra    ; Mostrar resultado en display
    hlt           ; Terminar ejecución

.overflow:
    mva #255      ; Sobreescribir Ra con 255 (marcar error)
    mov Rd, Ra    ; Mostrar error en el display
    hlt           ; Detener ejecución
```

## Programa simulado
![image](https://github.com/user-attachments/assets/bdcb4e6f-40f0-4d1a-bae6-fc962a6f3d0f)

![image](https://github.com/user-attachments/assets/e35ffe8f-e444-4bd5-aa94-93908860ee5e)



## Lógica y Funcionamiento del programa

### Carga de Valores Iniciales
- **Se carga el valor `127` en el registro `Ra`**:  
  Representa el valor máximo sin signo permitido para la operación.
- **Se carga el valor `1000` en el registro `Rb`**:  
  Este valor será el segundo operando para la suma.

### Realización de la Suma
- **La instrucción `add Ra`**:  
  Suma el contenido de `Rb` al de `Ra`. Durante esta operación, se actualizan los indicadores (FLAGS) del procesador para detectar si se produce un desbordamiento (overflow).

### Verificación de Overflow
- **La instrucción `jo .overflow`**:  
  Evalúa el flag de overflow. Si se detecta que se produjo un overflow, la ejecución salta a la etiqueta `.overflow`.

### Manejo del Resultado sin Error
- En caso de que **no se produzca un overflow**:
  - El resultado de la suma se transfiere al registro `Rd` mediante la instrucción `mov Rd, Ra`, para que pueda mostrarse en el display.
  - La ejecución del programa se detiene con `hlt`.

### Manejo del Overflow
- **Si se detecta un overflow**:
  - Se carga el valor `255` en el registro `Ra` para indicar un error.
  - Este valor de error se mueve al registro `Rd` y se muestra en el display.
  - Finalmente, el programa se detiene con `hlt`.

## Conclusión

El programa es un ejemplo sencillo de cómo manejar operaciones aritméticas en sistemas de 8 bits, asegurando que se detecte y gestione correctamente un desbordamiento. La lógica implementada permite mostrar un valor de error (`255`) en caso de que se produzca un overflow, lo que facilita el diagnóstico en sistemas embebidos o de bajo nivel.

