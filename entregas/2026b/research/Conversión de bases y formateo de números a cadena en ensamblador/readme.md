# Conversión de bases y formateo de números a cadena en ensamblador

**Arquitecturas estudiadas:** ARM64 (AArch64), ARM32 y RISC-V  
**Tema:** Conversión de bases y formateo de números a cadena en lenguaje ensamblador

> **Nota del docente:** el tema asignado corresponde a la arquitectura del curso
> (ARM64/ARM32/RISC-V). Este documento está desarrollado íntegramente en x86/NASM,
> fuera del alcance de la materia. Se deja el título aclarado para quien consulte
> este material como referencia, para no inducir a error sobre la arquitectura
> tratada. Ver observaciones de revisión en el Pull Request.

### Nombre: Cab Piñon Isury Michelle 
### No.Control: 24210475
### Materia: Leguajes de interfaz 
### Hora: 17:00-18:00

## 1. Introducción

El lenguaje ensamblador trabaja de manera directa con los registros, la memoria y las instrucciones del procesador. A diferencia de los lenguajes de alto nivel, un número almacenado en un registro no es automáticamente una cadena de caracteres que pueda mostrarse en pantalla.

Por ejemplo, el valor decimal `123` puede estar almacenado internamente como un número binario. Para mostrarlo como texto, es necesario convertirlo en los caracteres `'1'`, `'2'` y `'3'`.

La **conversión de bases** y el **formateo de números a cadenas** son, por lo tanto, procedimientos fundamentales en programación ensamblador, especialmente para la entrada y salida de datos.

En arquitecturas x86, instrucciones como `DIV` e `IDIV` permiten realizar divisiones enteras y obtener simultáneamente un cociente y un residuo, operaciones que son esenciales para convertir números entre distintas bases. ([Intel][1])

---

## 2. ¿Qué es una base numérica?

Una base numérica determina la cantidad de símbolos utilizados para representar los números y el valor posicional de cada símbolo.

Las bases más utilizadas en programación son:

| Base | Nombre      | Dígitos utilizados | Ejemplo |
| ---: | ----------- | ------------------ | ------- |
|    2 | Binaria     | `0–1`              | `1010₂` |
|    8 | Octal       | `0–7`              | `12₈`   |
|   10 | Decimal     | `0–9`              | `10₁₀`  |
|   16 | Hexadecimal | `0–9`, `A–F`       | `A₁₆`   |

Por ejemplo, el número decimal `10` puede representarse como:

```text
Decimal:     10
Binario:   1010
Octal:       12
Hexadecimal:  A
```

Aunque las representaciones son diferentes, todas corresponden al mismo valor numérico.

---

# 3. Conversión de decimal a otra base

Uno de los métodos más utilizados para convertir un número decimal a otra base consiste en realizar **divisiones sucesivas entre la base de destino**.

En cada división:

1. Se divide el número entre la base.
2. Se obtiene el cociente.
3. Se obtiene el residuo.
4. El residuo corresponde a uno de los dígitos del resultado.
5. Se continúa dividiendo el cociente hasta que sea cero.
6. Los residuos se leen en orden inverso.

### Ejemplo: decimal `25` a binario

```text
25 / 2 = 12   residuo 1
12 / 2 = 6    residuo 0
 6 / 2 = 3    residuo 0
 3 / 2 = 1    residuo 1
 1 / 2 = 0    residuo 1
```

Leyendo los residuos de abajo hacia arriba:

```text
25₁₀ = 11001₂
```

Este procedimiento es particularmente importante en ensamblador porque `DIV` proporciona tanto el **cociente** como el **residuo**. En x86, por ejemplo, para una división de 32 bits, el dividendo utiliza `EDX:EAX`, el cociente queda en `EAX` y el residuo en `EDX`. ([Pdos][2])

---

# 4. Conversión decimal a hexadecimal

El mismo procedimiento puede utilizarse para convertir un número decimal a hexadecimal, pero ahora se divide entre `16`.

Por ejemplo:

```text
254 / 16 = 15   residuo 14
 15 / 16 = 0    residuo 15
```

Los valores `14` y `15` corresponden a:

```text
14 = E
15 = F
```

Por lo tanto:

```text
254₁₀ = FE₁₆
```

La correspondencia de los valores hexadecimales es:

| Valor | Carácter |
| ----: | :------: |
|     0 |    `0`   |
|     1 |    `1`   |
|     2 |    `2`   |
|   ... |    ...   |
|     9 |    `9`   |
|    10 |    `A`   |
|    11 |    `B`   |
|    12 |    `C`   |
|    13 |    `D`   |
|    14 |    `E`   |
|    15 |    `F`   |

---

# 5. Conversión de una base a otra

Existen diferentes métodos para convertir entre bases.

Una estrategia general consiste en:

```text
Base original
      ↓
Convertir a valor numérico
      ↓
Realizar divisiones sucesivas
      ↓
Base de destino
```

Por ejemplo, para convertir:

```text
101101₂
```

a decimal:

```text
101101₂ =
1(2⁵) + 0(2⁴) + 1(2³) + 1(2²) + 0(2¹) + 1(2⁰)

= 32 + 0 + 8 + 4 + 0 + 1

= 45
```

Por lo tanto:

```text
101101₂ = 45₁₀
```

Después, si se quisiera obtener hexadecimal:

```text
45 / 16 = 2   residuo 13
2 / 16  = 0   residuo 2
```

Como `13 = D`:

```text
45₁₀ = 2D₁₆
```

---

# 6. División en ensamblador

En x86 existen principalmente dos instrucciones para la división entera:

* `DIV`: división **sin signo**.
* `IDIV`: división **con signo**.

Intel documenta `DIV` como división de enteros sin signo y `IDIV` como división de enteros con signo. ([Intel][1])

Para una división de 32 bits mediante `DIV`:

```asm
xor edx, edx
div ebx
```

Conceptualmente:

```text
EDX:EAX / EBX

EAX = cociente
EDX = residuo
```

Por eso, antes de utilizar `DIV` con un valor de 32 bits en `EAX`, normalmente se prepara `EDX`:

```asm
xor edx, edx
```

De esta manera se establece el dividendo de 64 bits como:

```text
EDX:EAX
```

con la parte alta en cero.

---

# 7. ¿Qué significa formatear un número?

**Formatear un número** significa convertir su representación numérica interna en una representación textual.

Por ejemplo, supongamos que tenemos:

```text
EAX = 123
```

El procesador entiende ese valor como un número, pero para imprimirlo necesitamos obtener los caracteres:

```text
'1' '2' '3'
```

Es decir:

```text
Número → cadena de caracteres
```

La cadena resultante podría almacenarse en memoria como:

```text
31h 32h 33h
```

porque esos son los códigos ASCII de:

```text
'1' = 31h
'2' = 32h
'3' = 33h
```

NASM documenta que las cadenas de caracteres se representan mediante sus valores correspondientes y que los caracteres pueden almacenarse directamente en memoria. ([NASM][3])

---

# 8. Código ASCII

ASCII es un estándar utilizado para representar caracteres mediante valores numéricos.

Algunos caracteres importantes son:

| Carácter | ASCII decimal | ASCII hexadecimal |
| :------: | ------------: | ----------------: |
|    `0`   |            48 |             `30h` |
|    `1`   |            49 |             `31h` |
|    `2`   |            50 |             `32h` |
|    `3`   |            51 |             `33h` |
|    `4`   |            52 |             `34h` |
|    `5`   |            53 |             `35h` |
|    `6`   |            54 |             `36h` |
|    `7`   |            55 |             `37h` |
|    `8`   |            56 |             `38h` |
|    `9`   |            57 |             `39h` |
|    `A`   |            65 |             `41h` |
|    `B`   |            66 |             `42h` |
|    `F`   |            70 |             `46h` |

Por ello, para convertir un dígito numérico entre `0` y `9` a su representación ASCII, puede utilizarse:

```asm
add dl, '0'
```

Por ejemplo, si:

```text
DL = 5
```

después de:

```asm
add dl, '0'
```

se obtiene:

```text
DL = '5'
```

---

# 9. Algoritmo para convertir un número a cadena decimal

El algoritmo general es:

```text
1. Tomar el número.
2. Dividirlo entre 10.
3. Guardar el residuo.
4. Convertir el residuo a ASCII.
5. Repetir utilizando el cociente.
6. Continuar hasta que el cociente sea 0.
7. Invertir los caracteres obtenidos.
```

Por ejemplo, para:

```text
1234
```

tenemos:

```text
1234 / 10 = 123   residuo 4
 123 / 10 = 12    residuo 3
  12 / 10 = 1     residuo 2
   1 / 10 = 0     residuo 1
```

Los residuos se obtienen como:

```text
4 3 2 1
```

pero la representación correcta es:

```text
1234
```

Por eso es necesario **invertir el orden de los residuos**.

---

# 10. Ejemplo en ensamblador x86

Un ejemplo simplificado utilizando NASM podría ser:

```asm
section .bss
    buffer resb 16

section .text
    global _start

_start:
    mov eax, 1234
    mov ebx, 10

    mov edi, buffer + 15
    mov byte [edi], 0

convertir:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl

    test eax, eax
    jnz convertir
```

La parte fundamental es:

```asm
xor edx, edx
div ebx
```

que realiza la división.

Después:

```asm
add dl, '0'
```

convierte el residuo numérico en un carácter ASCII.

Finalmente:

```asm
dec edi
mov [edi], dl
```

almacena el carácter en el buffer.

---

# 11. ¿Por qué se almacenan los dígitos al revés?

Esto ocurre debido al algoritmo de divisiones sucesivas.

Para el número:

```text
1234
```

la primera división obtiene:

```text
4
```

La siguiente:

```text
3
```

Después:

```text
2
```

y finalmente:

```text
1
```

Por lo tanto, los caracteres aparecen inicialmente como:

```text
4321
```

Para obtener:

```text
1234
```

existen dos estrategias principales.

### Estrategia A: utilizar una pila

Los dígitos pueden introducirse en la pila:

```text
push '4'
push '3'
push '2'
push '1'
```

y posteriormente extraerse en orden inverso.

### Estrategia B: escribir desde el final del buffer

También puede colocarse un puntero al final de un buffer y retroceder:

```asm
dec edi
mov [edi], dl
```

Esta estrategia permite que los caracteres terminen directamente en el orden correcto.

---

# 12. Conversión de números hexadecimales a cadenas

Para hexadecimal, el procedimiento es prácticamente igual, pero se utiliza la base `16`.

```asm
mov ebx, 16

convertir_hex:
    xor edx, edx
    div ebx
```

El residuo estará entre:

```text
0 y 15
```

Para los valores de `0` a `9`:

```asm
add dl, '0'
```

Para los valores de `10` a `15`, se deben utilizar:

```text
A B C D E F
```

Una forma de hacerlo es:

```asm
cmp dl, 9
jbe digito

add dl, 'A' - 10
jmp guardar

digito:
add dl, '0'
```

De esta manera:

```text
0  → '0'
1  → '1'
...
9  → '9'
10 → 'A'
11 → 'B'
12 → 'C'
13 → 'D'
14 → 'E'
15 → 'F'
```

---

# 13. Ejemplo de conversión hexadecimal

Supongamos:

```text
EAX = 254
```

y:

```asm
mov ebx, 16
```

La primera división produce:

```text
254 / 16 = 15
residuo = 14
```

El residuo `14` se convierte en:

```text
'E'
```

Después:

```text
15 / 16 = 0
residuo = 15
```

El `15` se convierte en:

```text
'F'
```

Los caracteres se obtienen inicialmente:

```text
E F
```

pero debido al orden de extracción, el resultado final debe organizarse como:

```text
FE
```

Por lo tanto:

```text
254₁₀ = FE₁₆
```

---

# 14. Conversión de binario a cadena

Para convertir un número a una cadena binaria, se puede dividir sucesivamente entre `2`.

Otra posibilidad, particularmente natural para binario, consiste en utilizar desplazamientos y operaciones bit a bit.

Por ejemplo:

```asm
shr eax, 1
```

desplaza los bits de `EAX` una posición a la derecha.

También se puede utilizar:

```asm
and eax, 1
```

para obtener el bit menos significativo.

Por ejemplo:

```text
1011₂
```

El último bit se obtiene mediante:

```text
1011 AND 0001 = 1
```

Después se desplaza:

```text
1011 >> 1 = 0101
```

y se repite el procedimiento.

---

# 15. Comparación de métodos

| Conversión  | Operación principal     | Base |
| ----------- | ----------------------- | ---: |
| Decimal     | División                |   10 |
| Binario     | División/desplazamiento |    2 |
| Octal       | División                |    8 |
| Hexadecimal | División                |   16 |

El método de división sucesiva tiene una ventaja importante: **es general**. Cambiando el divisor, puede utilizarse para diferentes bases.

```text
divisor = 2  → binario
divisor = 8  → octal
divisor = 10 → decimal
divisor = 16 → hexadecimal
```

---

# 16. Números con signo

Los números positivos pueden convertirse directamente utilizando `DIV`.

Sin embargo, los números negativos requieren un tratamiento adicional.

Por ejemplo:

```text
-123
```

Una estrategia consiste en:

1. Comprobar si el número es negativo.
2. Guardar el signo.
3. Obtener el valor absoluto.
4. Convertir el valor absoluto a caracteres.
5. Colocar `'-'` delante de la cadena.

Conceptualmente:

```text
-123
 ↓
signo = '-'
 ↓
123
 ↓
"123"
 ↓
"-123"
```

En x86, `IDIV` está destinado a la división con signo, mientras que `DIV` realiza división sin signo. ([Intel][1])

---

# 17. Consideraciones sobre el buffer

Al convertir un número a una cadena es necesario reservar suficiente espacio en memoria.

Por ejemplo:

```asm
buffer resb 16
```

reserva 16 bytes.

Además de los caracteres numéricos, puede ser necesario reservar espacio para:

* El signo `-`.
* El terminador `0`, si se utiliza una cadena terminada en cero.
* Otros caracteres como espacios o saltos de línea.

La cantidad necesaria depende del tamaño del número y del formato utilizado.

---

# 18. Errores comunes

### 18.1 No limpiar `EDX`

Antes de una división de 32 bits sin signo:

```asm
xor edx, edx
div ebx
```

Si `EDX` contiene un valor inesperado, el dividendo `EDX:EAX` también será diferente del esperado.

---

### 18.2 Olvidar que `DIV` produce un residuo

Después de:

```asm
div ebx
```

no solamente se obtiene el cociente.

También se obtiene el residuo:

```text
EAX = cociente
EDX = residuo
```

Este residuo es precisamente el dígito que necesitamos para la conversión de bases. ([Pdos][2])

---

### 18.3 Confundir un número con un carácter

No es lo mismo:

```text
5
```

que:

```text
'5'
```

El primero representa un valor numérico; el segundo representa un carácter.

En ASCII:

```text
5    → valor numérico 5
'5'  → ASCII 53 decimal
```

Por eso se utiliza:

```asm
add dl, '0'
```

para transformar el valor `5` en el carácter `'5'`.

---

### 18.4 No invertir los residuos

Las divisiones sucesivas producen los dígitos desde el menos significativo hacia el más significativo.

Por ejemplo:

```text
123 → 3 → 2 → 1
```

Por lo tanto, es necesario invertirlos o escribirlos desde el final del buffer.

---

# 19. Aplicaciones

La conversión de bases y el formateo de números son utilizados en diferentes situaciones:

* Impresión de números en consola.
* Desarrollo de sistemas operativos.
* Programación de microcontroladores.
* Depuración de programas.
* Visualización de registros del procesador.
* Conversión de direcciones y valores hexadecimales.
* Comunicación entre sistemas.
* Desarrollo de rutinas de entrada y salida.
* Implementación de funciones similares a `printf`.
* Conversión de datos numéricos a formatos legibles.

---

# 20. Conclusión

La conversión de bases en ensamblador consiste principalmente en transformar una representación numérica en otra utilizando operaciones aritméticas apropiadas. Uno de los procedimientos fundamentales es la **división sucesiva**, donde el residuo de cada división representa uno de los dígitos de la nueva base.

En arquitecturas x86, la instrucción `DIV` resulta especialmente importante porque proporciona tanto el **cociente** como el **residuo**, mientras que `IDIV` permite realizar la misma operación con números con signo. ([Intel][1])

Por otra parte, el formateo de números a cadenas requiere convertir cada dígito numérico en su correspondiente carácter, normalmente mediante ASCII. Por ejemplo:

```text
Valor numérico 5
       ↓
   + '0'
       ↓
Carácter '5'
```

En términos generales, el proceso puede resumirse como:

```text
       NÚMERO
          │
          ▼
   ┌───────────────┐
   │ División por  │
   │ la base       │
   └───────┬───────┘
           │
           ▼
        Residuo
           │
           ▼
     Convertir a
        ASCII
           │
           ▼
      Guardar dígito
           │
           ▼
     ¿Cociente = 0?
       │          │
      NO         SÍ
       │          │
       └────┐     ▼
            │   CADENA
            │
            └── repetir
```

Así, una operación que en un lenguaje de alto nivel puede parecer sencilla, como convertir `1234` en `"1234"`, requiere en ensamblador controlar explícitamente las divisiones, los residuos, los registros, la memoria y la representación ASCII.

---

## Referencias

1. Intel Corporation. *Intel® 64 and IA-32 Architectures Software Developer's Manual*. Documentación oficial de arquitectura e instrucciones x86. ([Intel][4])
2. Intel Corporation. *Instruction Set Reference — DIV/IDIV*. Referencia de las instrucciones de división de enteros. ([Intel][1])
3. NASM. *The Netwide Assembler Manual*. Documentación sobre constantes y cadenas de caracteres. ([NASM][3])
4. MIT. *80386 Programmer's Reference Manual — DIV/IDIV*. Referencia histórica de las instrucciones de división x86. ([Pdos][2])

> **Nota:** El ejemplo de código utiliza sintaxis **NASM para x86 de 32 bits** y se centra en el algoritmo de conversión; las rutinas concretas para imprimir la cadena dependen del sistema operativo y del entorno de ejecución.

[1]: https://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-vol-2a-manual.pdf?utm_source=chatgpt.com "Intel® 64 and IA-32 Architectures Software Developer’s Manual Volume 2A: Instruction Set Reference, A-L"
[2]: https://pdos.lcs.mit.edu/6.828/2018/readings/i386/DIV.htm?utm_source=chatgpt.com "80386 Programmer's Reference Manual -- Opcode DIV"
[3]: https://www.nasm.us/doc/nasm03.html?utm_source=chatgpt.com "NASM - The Netwide Assembler"
[4]: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html?utm_source=chatgpt.com "Manuals for Intel® 64 and IA-32 Architectures"
