# INSTITUTO TECNÓLOGICO DE TIJUANA
# Bucle infinito que puede ser detenido manualmente con una condición almacenada en memoria.

Este programa en ensamblador está diseñado para realizar una comparación entre un contador y un valor fijo que funcionará como punto de partida para una condición, tiene la capacidad de reiniciar
el contador al llegar a ese valor. También incluye una bandera para controlar la ejecución del bucle para detener el programa cuando la bandera se activa, asi se permite la intervención manual.

## Instrucciones en uso
| **Instrucción** | **Descripción** |
|------------------|-----------------|
| `mov`            | Mueve un valor de un registro o constante a otro registro, `mov Rc, stop_flag_value` mueve el valor de `stop_flag_value` al registro `Rc`. |
| `cmp`            | Compara dos valores (registros o constante) restándolos, pero no guarda el resultado. En este código se usa para la bandera, `cmp Rb, Ra` compara los valores de `Rb` y `Ra`. |
| `inc`            | Incrementa el valor de un registro en 1, `inc Ra` incrementa `Ra` por 1. |
| `jz`             | Salta a una etiqueta si el resultado de la comparación anterior fue cero (si el resultado de la comparación es igual), `jz .loop` salta a `.loop` si la comparación anterior fue igual. |
| `jmp`            | Salta a una etiqueta. `jmp .stop` hace que el programa salte al punto `.stop`. |
| `clra`           | Limpia el valor del registro `Ra`, dejándolo en 0. |
| `nop`            | No realiza ninguna operación; generalmente se usa para detener la ejecución o insertar un ciclo de espera. |

## Código del programa
A continuación se muestra el código documentado del programa.
```assembly
.data:
    mivalor = 100           ; Valor de comparación
    stop_flag_value = 1     ; Valor inicial de la bandera (0 = Continuar, 1 = Detener)
    data Rd, mivalor        ; Guardamos 100 en memoria
    data Rb, stop_flag_value ; Guardamos el valor de la bandera de parada en Rb
    data Rc, 0              ; Inicializamos Rc con 0 (para realizar la prueba manualmente)

.begin:
    clra                    ; Limpia todos los registros

; Verificación inicial de la bandera
    mov Rc, stop_flag_value ; Carga el valor de la bandera en Rc
    cmp Rc                   ; Compara el valor de Rc (la bandera)
    jz .loop                 ; Si la bandera es 0, continúa con el bucle
    jmp .stop                ; Si la bandera es 1, salta a .stop (detener)

.loop:
    inc Ra                   ; Incrementa Ra en 1

    mov Rb, mivalor          ; Carga el valor de mivalor (100) en Rb
    cmp Rb, Ra               ; Compara si Ra ha alcanzado 100
    jz .reset                ; Si Ra == 100, reinicia inmediatamente

    mov Rd, Ra               ; Mueve el valor de Ra al display después de la comparación
    jmp .loop                ; Repetir el bucle   

.reset:
    clra                     ; Reinicia Ra a 0
    mov Rd, Ra               ; Actualiza el display a 0 inmediatamente
    jmp .loop                ; Vuelve a iniciar el conteo

.stop:
    nop                      ; Detiene la ejecución, no hace nada más
```
🚀 Nevarez de la Cruz America Fernanda

