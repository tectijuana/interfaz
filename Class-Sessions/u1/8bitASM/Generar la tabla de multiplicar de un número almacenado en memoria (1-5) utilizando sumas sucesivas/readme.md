# Garcia Guerrero Cesar Ricardo - 22211567

# Ejercicio: Generar la tabla de multiplicar de un número almacenado en memoria (1-5) utilizando sumas sucesivas

# Codigo fuente documentado
```
; Cesar Ricardo Garcia Guerrero - 22211567
; Generar la tabla de multiplicar de un número 
; almacenado en memoria (1-5) utilizando sumas sucesivas.

.begin:
    clra            ; Limpiar todos los registros
    lod Ra, 0x10    ; Cargar número base desde la memoria ( entre 1 y 5)
    data Rb, 1      ; Inicializar contador en 1 (multiplicador)
    data Rc, 10     ; Límite de la multiplicacion (10)
    data Rd, 0x20   ; Dirección de memoria donde se almacenarán los resultados

.loop:
    data Acc, 0     ; Iniciar acumulador para la suma 
    data Ra, 0x10   ; Recargar número base desde memoria
    mov Rb, Rc      ; Guardar el valor del multiplicador en Rb

.mul:
    add Acc         ; Sumar el número base al acumulador
    dec Rb          ; Decrementar el multiplicador
    jz .store       ; Si llega a 0, almacenar resultado y seguir con el siguiente número
    jmp .mul        ; Seguir sumando

.store:
    sto Rd, Acc     ; Almacenar resultado en memoria
    inc Rd          ; Mover al siguiente espacio en memoria
    dec Rc          ; Restar contador del multiplicador
    jz .end         ; Si se multiplicó por 10, finalizar
    jmp .loop       ; Repetir para el siguiente multiplicador

.end:
    hlt             ; Detener ejecución
```

# Explicacion del funcionamiento
El programa genera la tabla de multiplicar de un número almacenado en 0x10 mediante sumas sucesivas. Primero, inicializa los registros y carga el número base en Ra. Luego, en el bucle principal (.loop), recorre los multiplicadores del 1 al 10, sumando Ra en Acc hasta completar la multiplicación. Una vez obtenido el resultado, lo almacena en Rd y avanza a la siguiente dirección (inc Rd). El proceso continúa hasta que Rc llega a cero, momento en el que el programa se detiene.


# Tabla de instrucciones
| Instrucción    | Descripción                                                                      |
|----------------|----------------------------------------------------------------------------------|
| `clra`         | Limpia todos los registros.                                                      |
| `lod Ra, 0x10` | Carga en el registro `Ra` el valor almacenado en la dirección de memoria `0x10`. |
| `data Rb, 1`   | Inicializa `Rb` con el valor `1` (contador del multiplicador).                   |
| `data Rc, 10`  | Inicializa `Rc` con el valor `10` (límite del multiplicador).                    |
| `data Rd, 0x20`| Define la dirección base `0x20` para almacenar los resultados.                   |
| `data Acc, 0`  | Inicializa el acumulador (`Acc`) en `0`.                                         |
| `mov Rb, Rc`   | Copia el valor de `Rc` en `Rb`.                                                  |
| `add Acc`      | Suma el valor de `Rb` al acumulador (`Acc`).                                     |
| `dec Rb`       | Decrementa el valor de `Rb`.                                                     |
| `jz .store`    | Salta a la etiqueta `.store` si `Rb` es cero.                                    |
| `jmp .mul`     | Salta a la etiqueta `.mul` para continuar la multiplicación.                     |
| `sto Rd, Acc`  | Almacena el valor del acumulador (`Acc`) en la dirección de memoria `Rd`.        |
| `inc Rd`       | Incrementa el valor de `Rd` para apuntar a la siguiente dirección de memoria.    |
| `dec Rc`       | Decrementa el valor de `Rc`.                                                     |
| `jz .end`      | Salta a `.end` si `Rc` es cero (termina el programa).                            |
| `jmp .loop`    | Salta a `.loop` para calcular la siguiente multiplicación.                       |
| `hlt`          | Detiene la ejecución del programa.                                               |

# Evidencia

![Evidencia](https://github.com/user-attachments/assets/23634bcd-3fdc-4dbb-8c5a-8b3a98f55f9e)

