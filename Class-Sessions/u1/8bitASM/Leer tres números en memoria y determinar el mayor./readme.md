### Elaborado por : Meza Rodriguez Eduardo Manuel #21211997
### Codigo:

```
; Compare three numbers and determine the largest one

NUM1 = 135
NUM2 = 200
NUM3 = 180
ADDR   = 0
TERMINATOR = 255
ZERO = 48 ; ascii 0

DISPLAY_MODE = LCD_CMD_DISPLAY | LCD_CMD_DISPLAY_ON

lcc #LCD_INITIALIZE
lcc #DISPLAY_MODE
lcc #LCD_CMD_CLEAR

main:
    data SP, 255
    data Rd, NUM1
    data Ra, ADDR
    mov Rb, Rd
    data Rc, NUM2
    data Rf, NUM3

    ; Compare NUM1 with NUM2
    call compareNumbers

    ; After comparison, the largest number is in Rb
    call printResult

    .output:
        jmp .output

printResult:
    lcc #LCD_CMD_CLEAR
    data Ra, ADDR
    data Rb, TERMINATOR
    data Rd, NUM1

    .findEnd:
        lod Rc, Ra
        cmp Rb, Rc
        jz .startPrint
        inc Ra
        jmp .findEnd

    .startPrint:
        data Rc, ADDR

    .nextDigit:
        dec Ra
        lod Rd, Ra
        data Rb, ZERO
        add Rd
        lcd Rd
        mov Rb, Ra
        cmp Rb, Rc
        jz .return
        jmp .nextDigit

    .return:
        ret

compareNumbers:
    ; Compare NUM1 (Rd) and NUM2 (Rc), store the larger value in Rb
    cmp Rd, Rc
    jg .num1Greater
    mov Rb, Rc
    jmp .compareNext

.num1Greater:
    mov Rb, Rd

.compareNext:
    ; Compare the current larger number (Rb) with NUM3 (Rf)
    cmp Rb, Rf
    jg .doneComparison
    mov Rb, Rf

.doneComparison:
    ret
```

### Explicacion:

- Definición de los números: Se definen tres números: NUM1, NUM2 y NUM3.
- Comparación: Se compara el primer número (NUM1) con el segundo (NUM2). Si NUM1 es mayor, el mayor se guarda en Rb. Si no, NUM2 se guarda en Rb.
- Luego se compara el valor almacenado en Rb con el tercer número (NUM3). El número mayor se mantiene en Rb.
- Finalmente, se llama a printResult para mostrar el número mayor en el display.

 #### Este programa sigue el mismo esquema de comparación que el código original y adapta la lógica para trabajar con tres números en lugar de convertir binarios a decimales.

 ![image](https://github.com/user-attachments/assets/b1cd46dc-44d4-42c3-a233-08b17a554cde)
