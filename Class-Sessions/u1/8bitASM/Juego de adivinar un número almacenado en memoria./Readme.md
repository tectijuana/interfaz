![Image](https://github.com/user-attachments/assets/b957d4cb-c4d1-4f7c-80b8-689c78598335)
# 📚 Instituto Tecnológico de Tijuana  

## 🎓 Carrera  
**Ingeniería en Sistemas Computacionales**  

## 📖 Materia  
**Lenguajes e Interfaz**  

## 👨‍🏫 Profesor  
**René Solís Reyes**  

# Documentación del Código: Juego de Adivinanza

Este código es una implementación en ensamblador de un sencillo juego de adivinanza, donde el jugador debe adivinar un número secreto almacenado en la memoria. El programa proporciona retroalimentación al jugador sobre si la adivinanza es correcta, demasiado baja o demasiado alta.

## Descripción del Código

### Constantes

Se definen varias direcciones de memoria para almacenar valores relevantes del juego:

- **`SECRET_NUMBER_ADDR`**: Dirección de memoria para almacenar el número secreto.
- **`GUESS_ADDR`**: Dirección de memoria para almacenar la adivinanza del jugador.
- **`SUCCESS_FLAG`**: Dirección de memoria que almacena una bandera de éxito (1 si la adivinanza es correcta, 0 si es incorrecta).

### Inicialización

- Se carga un valor inmediato de 42 (el número secreto) en el registro `Ra` y luego se guarda en la memoria en la dirección de `SECRET_NUMBER_ADDR`.

### Bucle Principal del Juego

1. **Ingreso de la Adivinanza:**
   - El jugador ingresa su adivinanza, que se simula en este caso con un valor fijo (0). Este valor se guarda en `GUESS_ADDR`.

2. **Comparación:**
   - Se carga el número secreto de la memoria en el registro `Rb`.
   - Se compara la adivinanza del jugador (`Ra`) con el número secreto (`Rb`) utilizando la instrucción `cmp`.

3. **Condiciones:**
   - **Adivinanza correcta**: Si la adivinanza es igual al número secreto (`cmp Ra, Rb` con resultado cero), se establece la bandera de éxito (`SUCCESS_FLAG = 1`).
   - **Adivinanza demasiado baja**: Si la adivinanza es menor que el número secreto, se indica que la adivinanza es demasiado baja.
   - **Adivinanza demasiado alta**: Si la adivinanza es mayor que el número secreto, se indica que la adivinanza es demasiado alta.

### Flujo del Juego

El flujo básico del juego está determinado por los siguientes saltos condicionales:

- **Si la adivinanza es correcta**:
  - Se establece el `SUCCESS_FLAG` en 1 y el juego termina.

- **Si la adivinanza es demasiado baja**:
  - Se indica que la adivinanza es baja y el juego vuelve a pedir otra adivinanza.

- **Si la adivinanza es demasiado alta**:
  - Se indica que la adivinanza es alta y el juego vuelve a pedir otra adivinanza.

### Fin del Juego

Cuando el jugador adivina el número correctamente, se muestra un mensaje de éxito (simulado con un valor en `Rd`), y el programa se detiene con la instrucción `hlt`.

---

## Código Explicado

### Inicialización

```assembly
; Inicialización del número secreto
JAIR ISAAC PEREZ RICARDEZ 21212024
mva #42                ; Cargar el valor inmediato 42 en Ra
sto Ra, SECRET_NUMBER_ADDR  ; Almacenar Ra en la dirección de memoria SECRET_NUMBER_ADDR

.game_loop:
  ; Simulamos la entrada del jugador
  mva #0                ; Cargar el valor 0 en Ra (simulando la adivinanza)
  sto Ra, GUESS_ADDR    ; Almacenar Ra en la dirección de memoria GUESS_ADDR

  ; Cargar el número secreto en Rb
  lod Rb, SECRET_NUMBER_ADDR

cmp Ra, Rb             ; Comparar la adivinanza (Ra) con el número secreto (Rb)

; Si es correcta
jz .correct_guess

; Si es demasiado baja
jn .too_low

; Si es demasiado alta
jmp .too_high

.correct_guess:
  mva #1                ; Cargar 1 en Ra
  sto Ra, SUCCESS_FLAG  ; Almacenar 1 en SUCCESS_FLAG (indica éxito)
  jmp .end_game

.too_low:
  mvd #1                ; Indicar "Demasiado bajo" (valor 1 en Rd)
  jmp .game_loop        ; Volver al inicio del bucle para una nueva adivinanza

.too_high:
  mvd #2                ; Indicar "Demasiado alto" (valor 2 en Rd)
  jmp .game_loop        ; Volver al inicio del bucle para una nueva adivinanza

.end_game:
  mvd #3                ; Indicar "Adivinanza correcta" (valor 3 en Rd)
  hlt                   ; Detener el programa
;
```
![Image](https://github.com/user-attachments/assets/89eb898e-4a0c-4247-94af-f090935ca65f)
