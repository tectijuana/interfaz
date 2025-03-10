# Programa para listar números primos entre 1 y 100

Este programa está diseñado para ejecutarse en una CPU de 8 bits y tiene como objetivo listar todos los números primos entre 1 y 100, mostrándolos en un display conectado al registro `Rd`.

---

## Descripción del programa

El programa realiza lo siguiente:
1. Itera a través de los números del 2 al 100.
2. Para cada número, verifica si es primo utilizando un algoritmo básico de divisibilidad.
3. Si el número es primo, lo muestra en el display conectado al registro `Rd`.
4. El programa termina cuando se alcanza el número 100.

---

## Registros utilizados

- **Ra**: Registro de propósito general "A".
- **Rb**: Registro de propósito general "B". También se utiliza como segundo operando en operaciones aritméticas.
- **Rc**: Registro de propósito general "C". Se utiliza para almacenar el divisor actual en la verificación de primalidad.
- **Rd**: Registro de propósito general "D". Está conectado a un display decimal para mostrar los números primos.
- **Acc**: Acumulador. Almacena el resultado de las operaciones aritméticas y lógicas.

---

## Instrucciones clave

### Inicialización
- `clra`: Limpia todos los registros.
- `mva #2`: Inicializa `Ra` con el valor 2 (el primer número primo).
- `mov Rb, Ra`: Copia el valor de `Ra` a `Rb` para la verificación de primalidad.

### Bucle principal
- `cmp Rb, #MAX_NUM`: Compara el valor en `Rb` con 100.
- `jz end`: Si `Rb` es igual a 100, termina el programa.

### Verificación de primalidad
- `mvc #2`: Inicializa `Rc` con 2, el primer divisor a verificar.
- `cmp Rc, Rb`: Compara `Rc` con `Rb`.
- `jz is_prime`: Si `Rc` es igual a `Rb`, el número es primo.
- `mov Ra, Rb`: Copia `Rb` a `Ra` para la división.
- `sub Ra, Rc`: Resta `Rc` de `Ra` (simula una división).
- `tst Acc`: Verifica si el resto (en `Acc`) es 0.
- `jz not_prime`: Si el resto es 0, el número no es primo.
- `inc Rc`: Incrementa `Rc` para verificar el siguiente divisor.
- `jmp prime_check`: Repite la verificación.

### Mostrar números primos
- `mov Rd, Rb`: Muestra el número primo en el display conectado a `Rd`.
- `inc Rb`: Incrementa el número actual.
- `jmp main_loop`: Continúa con el siguiente número.

### Finalización
- `hlt`: Detiene la ejecución del programa.

---

## Constantes

- `MAX_NUM = 100`: Define el límite superior para la búsqueda de números primos.

---

## Flujo del programa

1. **Inicialización**:
   - Se limpian los registros y se inicializa el primer número a verificar (2).

2. **Bucle principal**:
   - Se verifica si el número actual (`Rb`) es menor o igual a 100.
   - Si es mayor a 100, el programa termina.

3. **Verificación de primalidad**:
   - Se verifica si el número es divisible por algún número menor que él.
   - Si no es divisible por ningún número, se considera primo.

4. **Mostrar números primos**:
   - Si el número es primo, se muestra en el display conectado a `Rd`.

5. **Finalización**:
   - El programa se detiene cuando se alcanza el número 100.

---

## Ejemplo de salida

El programa mostrará los siguientes números primos en el display:

---

## Notas adicionales

- **Display**: El programa asume que el registro `Rd` está conectado a un display decimal. Si el display requiere un formato diferente, es necesario ajustar el código.
- **Eficiencia**: El algoritmo de verificación de primalidad es básico y puede no ser eficiente para rangos más grandes de números.
- **Compatibilidad**: El código está diseñado para funcionar con el conjunto de instrucciones proporcionado. Si el ensamblador no soporta ciertas instrucciones, es necesario ajustar el código.

---

## Código completo

```assembly
MAX_NUM = 100

    clra               ; Limpiar todos los registros
    mva #2             ; Empezar con el número 2 (el primer número primo)
    mov Rb, Ra         ; Copiar el número actual a Rb para la verificación de primalidad

main_loop:
    cmp Rb, #MAX_NUM   ; Comparar Rb con 100
    jz end             ; Si Rb == 100, terminar el programa

    ; Verificación de primalidad
    mvc #2             ; Empezar a verificar divisibilidad desde 2
prime_check:
    cmp Rc, Rb         ; Comparar Rc con Rb
    jz is_prime        ; Si Rc == Rb, el número es primo

    mov Ra, Rb         ; Copiar Rb a Ra para la división
    sub Ra, Rc         ; Restar Rc de Ra (simular división)
    tst Acc            ; Verificar si el resto es 0
    jz not_prime       ; Si el resto es 0, no es primo

    inc Rc             ; Incrementar Rc para verificar el siguiente divisor
    jmp prime_check    ; Repetir la verificación

is_prime:
    ; Mostrar el número primo en el display
    mov Rd, Rb         ; Mostrar el número primo en el display (Rd)
    inc Rb             ; Incrementar el número actual
    jmp main_loop      ; Continuar con el siguiente número

not_prime:
    inc Rb             ; Incrementar el número actual
    jmp main_loop      ; Continuar con el siguiente número

end:
    hlt                ; Detener la ejecución
```
<img width="710" alt="Image" src="https://github.com/user-attachments/assets/23a96f2a-6e3e-4348-992b-f79ee51175cf" />
