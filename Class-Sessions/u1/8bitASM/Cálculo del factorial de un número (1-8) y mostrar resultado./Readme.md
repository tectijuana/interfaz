# Cálculo de Factorial en Ensamblador

## Código

```assembly
;=========================================================
; Autor: Jorge Luis Castro Alvarado 22211533
; Fecha: 5/3/2025
; Descripción: Cálculo del factorial de un número (1-8) y mostrar resultado.
;=========================================================

.begin:
    data Rd, 1     ; Inicializa Rd con 1, almacenará el resultado del factorial
    data Ra, 0     ; Inicializa Ra con 0, actuará como contador
    push Ra        ; Guarda el valor actual de Ra en la pila
    inc Ra         ; Incrementa Ra (Ra = 1)

.next:
    pop Rc         ; Extrae el valor de la pila a Rc
    inc Rc         ; Incrementa Rc (siguiente número a multiplicar)
    push Rc        ; Guarda el nuevo valor en la pila
    mov Rd, Ra     ; Rd toma el valor de Ra (factor actual)
    mov Rb, Ra     ; Rb también toma el valor de Ra (factor a multiplicar)

.mul:
    add Ra         ; Suma Ra a sí mismo (multiplicación iterativa)
    jc .end        ; Si hay un desbordamiento, salta a .end
    dec Rc         ; Decrementa Rc (contador de iteraciones)
    jz .next       ; Si Rc llega a cero, pasa a la siguiente iteración
    jmp .mul       ; Salta de nuevo a la multiplicación

.end:
    pop Rc         ; Restaura Rc desde la pila
    jmp .begin     ; Reinicia el cálculo
```
# Explicación
Cálculo del factorial de un número (1-8) y mostrar resultado. En este caso, solo llega hasta la factorial de 5 (120) debido a que los siguientes resultados sobrepasan los 8bits
## 1. Inicialización
Se establecen los registros base:
- **Rd = 1** → Guardará el resultado del factorial.
- **Ra = 0** → Actúa como contador.

Se empuja **Ra** a la pila y se incrementa para iniciar el cálculo.

## 2. Bucle Principal (`.next`)
- Se extrae **Rc** desde la pila y se incrementa para preparar la multiplicación.
- Se copia **Ra** en **Rd** y **Rb** para realizar la operación.

## 3. Bucle de Multiplicación (`.mul`)
- Se usa sumas iterativas para simular la multiplicación.
- `add Ra` acumula el producto.
- `dec Rc` disminuye el contador y si llega a 0, se avanza al siguiente número.

## 4. Condiciones de Salida
- **Desbordamiento** (`jc .end`): Si se detecta un error de capacidad, el programa termina.
- **Terminación del ciclo** (`jz .next`): Cuando **Rc == 0**, pasa a la siguiente iteración.
- **Reinicio** (`jmp .begin`): Reinicia el cálculo desde el inicio.

## Demostración:
![Captura de pantalla 2025-03-05 220009](https://github.com/user-attachments/assets/7c2fb05c-6dd5-467a-93d2-b84a21c9bbe5)

![Captura de pantalla 2025-03-05 220300](https://github.com/user-attachments/assets/bbb522d7-9de3-4570-bc51-8ca37f1ef1ed)
