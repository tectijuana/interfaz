# Conversión de un Número Binario a Decimal con Visualización en LCD 🖥️➡️🔢

## Este proyecto convierte un número binario de 8 bits en su equivalente decimal y muestra el resultado en una pantalla LCD. A continuación, se presenta el código fuente documentado, seguido de una explicación detallada de su lógica y funcionamiento.

---

## Código Fuente 📜

```assembly
; Convert an 8-bit binary number into decimal digits
; and output digits to the display

NUMBER = 135          ; Número binario de 8 bits a convertir
ADDR   = 0            ; Dirección de memoria inicial para almacenar los dígitos
TERMINATOR = 255      ; Carácter terminador para indicar el fin de la cadena
ZERO = 48             ; Valor ASCII del carácter '0'

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON  ; Modo de visualización del LCD

lcc #LCD_INITIALIZE   ; Inicializar el LCD
lcc #DISPLAY_MODE     ; Configurar el modo de visualización
lcc #LCD_CMD_CLEAR    ; Limpiar la pantalla del LCD

main:
    data SP, 255      ; Inicializar el puntero de pila
    data Rd, NUMBER   ; Cargar el número a convertir en el registro Rd
    data Ra, ADDR     ; Cargar la dirección de memoria inicial en el registro Ra
    mov Rb, Rd        ; Copiar el número al registro Rb

    call toDec8       ; Llamar a la función para convertir el número a decimal
    
    .output:
        call printResult  ; Llamar a la función para imprimir el resultado en el LCD
        jmp .output       ; Bucle infinito para mantener la visualización

printResult:
    lcc #LCD_CMD_CLEAR    ; Limpiar la pantalla del LCD
    data Ra, ADDR        ; Cargar la dirección de memoria inicial en el registro Ra
    data Rb, TERMINATOR  ; Cargar el terminador en el registro Rb
    data Rd, NUMBER      ; Cargar el número en el registro Rd
    
    .findEnd:
        lod Rc, Ra       ; Cargar el valor en la dirección de memoria Ra en el registro Rc
        cmp Rb, Rc       ; Comparar con el terminador
        jz .startPrint   ; Si es igual, comenzar a imprimir
        inc Ra           ; Incrementar la dirección de memoria
        jmp .findEnd     ; Repetir hasta encontrar el terminador

    .startPrint:
        data Rc, ADDR    ; Cargar la dirección de memoria inicial en el registro Rc
    
    .nextDigit:
        dec Ra           ; Decrementar la dirección de memoria
        lod Rd, Ra       ; Cargar el valor en la dirección de memoria Ra en el registro Rd
        data Rb, ZERO    ; Cargar el valor ASCII de '0' en el registro Rb
        add Rd           ; Sumar el valor ASCII de '0' al dígito
        lcd Rd           ; Mostrar el dígito en el LCD
        mov Rb, Ra       ; Copiar la dirección de memoria actual al registro Rb
        cmp Rb, Rc       ; Comparar con la dirección de memoria inicial
        jz .return       ; Si es igual, retornar
        jmp .nextDigit   ; Repetir para el siguiente dígito
    
    .return:
        ret              ; Retornar de la función


; function toDec - binary to decimal
;  Rb: number
;  Ra: memory address to store result. 0xff delimited
toDec8:
    push Ra             ; Guardar el valor de Ra en la pila
    push Rb             ; Guardar el valor de Rb en la pila
    
    .nextDigit:
        pop Ra          ; Obtener el número restante
        data Rb, 10     ; Cargar el divisor 10 en el registro Rb
        call div8       ; Llamar a la función de división
        pop Rb         ; Obtener la dirección de memoria para almacenar el resultado
        sto Rb, Ra      ; Almacenar el resto en la dirección de memoria
        inc Rb          ; Incrementar la dirección de memoria
        push Rb         ; Guardar la siguiente dirección de memoria en la pila
        tst Rc          ; Verificar si el cociente es cero
        jz .return      ; Si es cero, retornar
        push Rc         ; Guardar el cociente en la pila
        jmp .nextDigit  ; Repetir para el siguiente dígito

    .return:
        pop Rb          ; Obtener la dirección de memoria final
        data Ra, TERMINATOR  ; Agregar el terminador
        sto Rb, Ra      ; Almacenar el terminador en la dirección de memoria
        ret             ; Retornar de la función


.printStr:
    mov Rc, Ra          ; Copiar la dirección de memoria inicial al registro Rc
    .nextChar:
        lod Ra, Rc      ; Cargar el carácter en la dirección de memoria Rc en el registro Ra
        tst Ra          ; Verificar si el carácter es cero (fin de cadena)
        jz .done        ; Si es cero, terminar
        lcd Ra          ; Mostrar el carácter en el LCD
        inc Rc          ; Incrementar la dirección de memoria
        jmp .nextChar   ; Repetir para el siguiente carácter
    .done:
        ret             ; Retornar de la función


; function div8 - divide two 8-bit integers
;  Ra: dividend
;  Rb: divisor
; returns:
;  Rc: result
;  Ra: remainder
div8:
    data Rc, 0x00       ; Inicializar el resultado a cero
    
    .step:
        cmp Rb, Ra      ; Comparar el divisor con el dividendo
        jz .add         ; Si son iguales, sumar al resultado
        jc .return      ; Si el divisor es mayor, retornar
        
    .add:
        inc Rc          ; Incrementar el resultado
        sub Ra          ; Restar el divisor del dividendo
        jnz .step       ; Repetir si el dividendo no es cero

    .return:
        ret             ; Retornar de la función
```

---

## Lógica y Funcionamiento 🧠⚙️

### 1. **Inicialización y Configuración**
   - **NUMBER**: Se define el número binario de 8 bits que se desea convertir a decimal. En este caso, el número es `135`.
   - **ADDR**: Se define la dirección de memoria inicial donde se almacenarán los dígitos decimales.
   - **TERMINATOR**: Se define un carácter terminador (`255`) para indicar el fin de la cadena de dígitos.
   - **ZERO**: Se define el valor ASCII del carácter `'0'` para facilitar la conversión de dígitos a su representación en ASCII.
   - **DISPLAY_MODE**: Se configura el modo de visualización del LCD.

### 2. **Conversión de Binario a Decimal**
   - **toDec8**: Esta función convierte el número binario en dígitos decimales. Utiliza la división por 10 para obtener cada dígito y lo almacena en memoria. El proceso se repite hasta que el cociente sea cero.
   - **div8**: Esta función realiza la división de dos números de 8 bits y devuelve el cociente y el resto.

### 3. **Visualización en LCD**
   - **printResult**: Esta función recorre los dígitos almacenados en memoria, los convierte a su representación ASCII y los muestra en el LCD. La función busca el terminador para saber cuándo ha llegado al final de la cadena de dígitos.
   - **.nextDigit**: Este bucle recorre los dígitos desde el último almacenado hasta el primero, convirtiéndolos a ASCII y mostrándolos en el LCD.

### 4. **Bucle Principal**
   - **main**: El programa principal inicializa los registros y llama a las funciones necesarias para realizar la conversión y la visualización. Luego, entra en un bucle infinito para mantener la visualización en el LCD.

### 5. **Funciones Auxiliares**
   - **.printStr**: Esta función imprime una cadena de caracteres en el LCD. Recorre la cadena hasta encontrar el carácter terminador.

### Resumen 📝
El programa toma un número binario de 8 bits, lo convierte a su equivalente decimal, almacena los dígitos en memoria y los muestra en una pantalla LCD. La conversión se realiza mediante divisiones sucesivas por 10, y la visualización se gestiona mediante un bucle que recorre los dígitos almacenados y los muestra en el LCD. Este código es un ejemplo claro de cómo manipular números y realizar operaciones de E/S en un entorno de bajo nivel.

---

## Demostración 🖥️🔍

![Captura de pantalla 2025-03-05 152140](https://github.com/user-attachments/assets/0a3c54eb-66a8-45e7-a324-1677fb0f219c)
![Captura de pantalla 2025-03-05 152212](https://github.com/user-attachments/assets/f4529202-1338-4167-9658-495dd47feb03)
