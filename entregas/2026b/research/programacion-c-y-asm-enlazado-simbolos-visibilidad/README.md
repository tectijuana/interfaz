# Programación C y ASM: Enlazado, nombres de símbolos y visibilidad

## Introducción

La programación en lenguaje C y ensamblador (ASM) permite combinar las ventajas de un lenguaje de alto nivel con el control directo que proporciona el lenguaje ensamblador sobre el hardware. Esta combinación es especialmente importante en sistemas embebidos y arquitecturas ARM, donde es necesario aprovechar de manera eficiente los recursos del procesador.

Cuando un programa utiliza código escrito tanto en C como en ASM, ambos archivos deben poder comunicarse correctamente. Para lograrlo intervienen varios conceptos importantes, entre ellos el **enlazado**, los **nombres de símbolos** y la **visibilidad de los símbolos**. Estos mecanismos permiten que una función escrita en ensamblador pueda ser llamada desde C, o que una función escrita en C pueda ser utilizada desde ensamblador.

En la arquitectura ARM, esta comunicación se apoya principalmente en el **Procedure Call Standard for the Arm Architecture (AAPCS)**, que establece reglas para que rutinas compiladas y ensambladas por separado puedan trabajar juntas. Estas reglas incluyen aspectos como el paso de parámetros, el uso de registros, el valor de retorno y la conservación del estado del procesador [1].

El objetivo de esta investigación es explicar cómo se realiza la comunicación entre C y ASM, cómo funciona el proceso de enlazado, qué función cumplen los nombres de símbolos y cómo se controla la visibilidad de funciones y variables dentro de un programa.

---

# Desarrollo técnico

## 1. Programación combinada entre C y ASM

El lenguaje C es ampliamente utilizado para desarrollar aplicaciones debido a que permite escribir programas de forma estructurada y relativamente independiente del hardware. Sin embargo, existen situaciones donde se necesita un mayor control sobre el procesador.

El lenguaje ensamblador permite trabajar directamente con instrucciones y registros específicos de la arquitectura. En ARM, por ejemplo, las instrucciones pueden operar directamente sobre registros como `R0`, `R1`, `R2` y `R3` en ARM de 32 bits, mientras que en AArch64 se utilizan registros como `X0` a `X30`.

Por esta razón, una aplicación puede tener una estructura similar a la siguiente:

```text
Programa
│
├── main.c
│   └── Función principal
│
├── funciones.s
│   └── Funciones en ensamblador
│
└── Librerías
```

El compilador procesa el código C y el ensamblador procesa el archivo ASM. Posteriormente, el enlazador combina los archivos objeto generados para producir un programa ejecutable.

La especificación AAPCS define precisamente cómo deben comunicarse las rutinas escritas por separado y establece un contrato entre la función que realiza una llamada y la función que la recibe [1].

---

## 2. Proceso de compilación y enlazado

Cuando se desarrolla un programa utilizando C y ASM, el código normalmente pasa por varias etapas:

```text
Código C (.c)
      │
      ▼
   Compilador
      │
      ▼
Archivo objeto (.o)
      │
      │
      ├──────────────┐
      │              │
      ▼              ▼
Código ASM (.s)   Librerías
      │
      ▼
  Ensamblador
      │
      ▼
Archivo objeto (.o)
      │
      └───────┬───────┘
              ▼
          Enlazador
              │
              ▼
      Programa ejecutable
```

### 2.1 Compilación

El compilador transforma el código escrito en C en código objeto. Durante este proceso, algunas funciones o variables pueden quedar representadas mediante símbolos que todavía no tienen una dirección definitiva.

Por ejemplo:

```c
extern int sumar(int a, int b);

int main(void)
{
    return sumar(5, 3);
}
```

El compilador sabe que existe una función llamada `sumar`, pero su implementación podría encontrarse en otro archivo.

---

### 2.2 Ensamblado

El archivo de ensamblador se transforma también en un archivo objeto.

Un ejemplo sencillo para ARM podría ser:

```asm
.global sumar
.type sumar, %function

sumar:
    add r0, r0, r1
    bx lr
```

La directiva:

```asm
.global sumar
```

hace que el símbolo `sumar` pueda ser utilizado desde otros módulos.

En este ejemplo, la función recibe los argumentos en registros y devuelve el resultado en `r0`, siguiendo las reglas de la convención de llamadas correspondiente.

---

### 2.3 Enlazado

El enlazador tiene la responsabilidad de unir los diferentes archivos objeto y resolver las referencias a símbolos.

Por ejemplo:

```text
main.c
  │
  │ llama a "sumar"
  ▼
main.o
  │
  │ referencia al símbolo sumar
  ▼
linker
  │
  │ busca la definición
  ▼
funciones.o
  │
  └── sumar
```

Si el enlazador encuentra la definición correspondiente, puede resolver la referencia y establecer la dirección correcta de la función.

Si no encuentra el símbolo, se produce un error de enlazado, por ejemplo:

```text
undefined reference to `sumar'
```

Esto significa que el programa hizo referencia a un símbolo que no pudo ser encontrado durante el proceso de enlace.

---

# 3. Nombres de símbolos

Un **símbolo** es un nombre utilizado para identificar elementos del programa, como funciones, variables o determinadas posiciones dentro del código.

Por ejemplo:

```c
int contador = 10;

void mostrar(void)
{
}
```

En este caso pueden existir símbolos asociados con:

```text
contador
mostrar
```

Estos nombres permiten que diferentes partes del programa hagan referencia a una misma función o variable.

En un programa que combina C y ASM, es especialmente importante que los nombres utilizados por ambos lenguajes sean compatibles.

---

## 3.1 Símbolos definidos y símbolos no definidos

Dentro de un archivo objeto pueden existir símbolos que ya tienen una definición y otros que representan referencias que todavía deben resolverse.

Por ejemplo:

```c
extern int sumar(int, int);

int main(void)
{
    return sumar(2, 3);
}
```

En `main.c`, `sumar` puede aparecer inicialmente como un símbolo que debe ser resuelto por el enlazador.

En cambio, en el archivo ASM:

```asm
.global sumar

sumar:
    add r0, r0, r1
    bx lr
```

se encuentra la definición de ese símbolo.

El enlazador relaciona ambas partes.

---

# 4. Compatibilidad de nombres entre C y ASM

Uno de los aspectos importantes de la programación mixta es que C y ASM deben utilizar nombres de símbolos compatibles.

En algunos sistemas y formatos de objeto, el compilador puede modificar la representación de los nombres de las funciones. Este proceso se conoce como **name mangling** o modificación del nombre.

En C normalmente los nombres de las funciones tienen una representación relativamente directa. Sin embargo, otros lenguajes, especialmente C++, pueden modificar los nombres para incluir información adicional.

Por ejemplo, en C++ una función podría tener un símbolo diferente al nombre que aparece en el código fuente debido a la información relacionada con tipos y sobrecarga.

Por esta razón, cuando se necesita utilizar una función escrita en C desde otro lenguaje o desde ensamblador, es importante conocer la convención utilizada por la plataforma.

ARM señala que las funciones con **C linkage** pueden utilizarse para implementar una función en un lenguaje y llamarla desde otro, evitando problemas relacionados con la modificación de nombres [3].

---

# 5. Convención de llamadas AAPCS

La **AAPCS (Procedure Call Standard for the Arm Architecture)** define las reglas necesarias para que diferentes funciones puedan comunicarse correctamente.

Estas reglas son fundamentales cuando se combina C con ensamblador.

Para ARM de 32 bits, una regla importante es que los primeros argumentos enteros o punteros se pasan mediante registros como:

```text
R0
R1
R2
R3
```

El valor de retorno normalmente se coloca en:

```text
R0
```

Por ejemplo, si desde C se realiza:

```c
resultado = sumar(5, 3);
```

la comunicación puede representarse conceptualmente como:

```text
R0 = 5
R1 = 3

       ↓
    función
     sumar
       ↓

R0 = 8
```

La documentación de ARM y material educativo basado en AAPCS describen el uso de `R0-R3` para parámetros y `R0` para valores de retorno en este contexto [1], [5].

En AArch64, la convención cambia porque utiliza los registros de propósito general de 64 bits. Los argumentos enteros y punteros se manejan principalmente mediante `X0-X7`, de acuerdo con AAPCS64 [2].

---

# 6. Ejemplo de C llamando a ASM

Un ejemplo sencillo puede dividirse en dos archivos.

### Archivo C: `main.c`

```c
#include <stdio.h>

extern int sumar(int a, int b);

int main(void)
{
    int resultado;

    resultado = sumar(5, 3);

    printf("Resultado: %d\n", resultado);

    return 0;
}
```

La palabra clave:

```c
extern
```

indica que la función está definida en otro lugar.

En este caso, la implementación estará en el archivo ensamblador.

---

### Archivo ASM: `sumar.s`

Para una representación ARM de 32 bits:

```asm
.global sumar
.type sumar, %function

sumar:
    add r0, r0, r1
    bx lr
```

La función recibe:

```text
r0 = primer argumento
r1 = segundo argumento
```

Después ejecuta:

```asm
add r0, r0, r1
```

que suma ambos valores y coloca el resultado en `r0`.

Finalmente:

```asm
bx lr
```

regresa a la función que realizó la llamada.

El funcionamiento general es:

```text
main()
   │
   │ sumar(5, 3)
   ▼
R0 = 5
R1 = 3
   │
   ▼
sumar()
   │
   │ R0 = R0 + R1
   ▼
R0 = 8
   │
   ▼
regresa a main()
```

---

# 7. Visibilidad de símbolos

La **visibilidad** determina desde qué partes del programa puede ser utilizado un símbolo.

Esto es importante porque no todas las funciones o variables necesitan estar disponibles para otros módulos.

Existen diferentes niveles de visibilidad dependiendo del formato de objeto y de la herramienta utilizada.

En sistemas basados en ELF, GCC reconoce diferentes tipos de visibilidad, entre ellos:

* `default`
* `hidden`
* `protected`
* `internal`

GCC indica que la visibilidad `default` corresponde normalmente a símbolos visibles desde otros módulos, mientras que `hidden` evita que el símbolo pueda ser referenciado directamente desde fuera del objeto compartido [4].

---

## 7.1 Visibilidad `default`

La visibilidad `default` permite que un símbolo sea visible normalmente para otros módulos.

Por ejemplo:

```c
void saludar(void)
{
    printf("Hola\n");
}
```

La función puede ser utilizada desde otro archivo cuando está correctamente declarada y enlazada.

En ensamblador puede utilizarse una directiva como:

```asm
.global saludar
```

para hacer que el símbolo esté disponible externamente.

---

## 7.2 Visibilidad `hidden`

La visibilidad `hidden` restringe el acceso directo al símbolo desde otros módulos.

Por ejemplo, en GCC:

```c
__attribute__((visibility("hidden")))
void funcionInterna(void)
{
}
```

Esta característica puede ser útil cuando una función solamente debe utilizarse internamente dentro de una biblioteca o módulo.

GCC señala que utilizar correctamente la visibilidad de símbolos puede ayudar a evitar conflictos de nombres y mejorar determinados aspectos del enlazado y de las bibliotecas compartidas [4].

---

# 8. Símbolos locales y globales

Otra diferencia importante es entre símbolos **locales** y **globales**.

Un símbolo global puede ser utilizado por otros módulos cuando las condiciones de visibilidad y enlace lo permiten.

Por otro lado, un símbolo local está destinado al módulo donde fue definido.

Conceptualmente:

```text
Archivo A
│
├── funcion_publica     → visible
│
└── funcion_interna     → local
```

Mientras otro archivo podría utilizar:

```text
funcion_publica
```

no necesariamente podrá utilizar directamente:

```text
funcion_interna
```

Esta separación ayuda a organizar programas grandes y a evitar que funciones internas interfieran con otros módulos.

---

# 9. Diferencia entre enlazado y visibilidad

Aunque ambos conceptos están relacionados, no significan lo mismo.

### Enlazado

El enlazado se encarga de **resolver las referencias entre diferentes archivos objeto**.

Por ejemplo:

```text
main.o
  │
  └── necesita "sumar"
           │
           ▼
       funciones.o
           │
           └── contiene "sumar"
```

### Visibilidad

La visibilidad determina **si un símbolo puede ser utilizado desde determinados módulos o bibliotecas**.

Por lo tanto:

```text
Enlazado
    ↓
¿Dónde está el símbolo?

Visibilidad
    ↓
¿Quién puede utilizar el símbolo?
```

Ambos conceptos deben configurarse correctamente para que un programa formado por C y ASM funcione de manera adecuada.

---

# 10. Importancia de la visibilidad en bibliotecas

La visibilidad es especialmente importante cuando se crean bibliotecas compartidas.

Una biblioteca puede contener muchas funciones internas, pero solamente algunas necesitan formar parte de su interfaz pública.

Por ejemplo:

```text
Biblioteca
│
├── calcular()
├── validar()
├── procesar()
│
├── funcion_interna1()
└── funcion_interna2()
```

Podría ser conveniente que solamente:

```text
calcular()
validar()
procesar()
```

fueran visibles externamente.

Las funciones internas podrían mantenerse ocultas.

Esto reduce la posibilidad de conflictos de símbolos y permite definir una interfaz más clara entre la biblioteca y los programas que la utilizan.

GCC documenta que establecer adecuadamente la visibilidad puede reducir conflictos de símbolos y mejorar el proceso de enlace de objetos compartidos [4].

---

# 11. Relación entre símbolos y enlazador

El enlazador utiliza información de los archivos objeto para determinar qué símbolos existen y dónde se encuentran.

Una representación simplificada sería:

```text
                 TABLA DE SÍMBOLOS

        main.o                    sumar.o
   ┌────────────────┐        ┌────────────────┐
   │ main           │        │ sumar          │
   │ sumar (extern) │        │ global         │
   └────────────────┘        └────────────────┘
             │                       │
             └──────────┬────────────┘
                        ▼
                     LINKER
                        │
                        ▼
                  ejecutable
```

Si existe una referencia a un símbolo externo, el enlazador busca una definición compatible.

Si no encuentra dicha definición, el proceso falla.

Por eso errores como:

```text
undefined reference
```

son comunes cuando se intenta combinar C y ASM y existe un problema con el nombre del símbolo, el archivo objeto o la visibilidad.

---

# 12. Importancia de utilizar correctamente AAPCS

No basta con que el enlazador encuentre una función. El código C y ASM también deben utilizar una convención de llamadas compatible.

Por ejemplo, si C espera que el primer argumento esté en `R0` y el segundo en `R1`, pero el código ASM busca los argumentos en otros registros, la función recibirá valores incorrectos.

De manera similar, si una función modifica registros que debería preservar, puede provocar errores en otras partes del programa.

Por esta razón, AAPCS funciona como un contrato entre las funciones.

La documentación oficial de ARM establece que las rutinas escritas, compiladas o ensambladas por separado deben seguir las reglas correspondientes de la convención de llamadas para poder trabajar juntas correctamente [1].

---

# 13. Ejemplo conceptual completo

Consideremos el siguiente programa:

### C

```c
extern int multiplicar(int a, int b);

int main(void)
{
    int resultado;

    resultado = multiplicar(4, 5);

    return resultado;
}
```

### ASM

```asm
.global multiplicar
.type multiplicar, %function

multiplicar:
    mul r0, r0, r1
    bx lr
```

El proceso puede representarse así:

```text
1. C declara "multiplicar"
              │
              ▼
2. El compilador genera una referencia
              │
              ▼
3. ASM define "multiplicar"
              │
              ▼
4. El ensamblador genera el archivo objeto
              │
              ▼
5. El enlazador encuentra el símbolo
              │
              ▼
6. Se conecta la llamada con la función
              │
              ▼
7. El programa puede ejecutarse
```

Cuando `main()` llama a `multiplicar(4,5)`:

```text
R0 = 4
R1 = 5
      │
      ▼
multiplicar
      │
      ▼
R0 = 4 × 5
      │
      ▼
R0 = 20
      │
      ▼
regreso a main()
```

Este ejemplo demuestra cómo C y ASM pueden trabajar juntos siempre que compartan correctamente los nombres de los símbolos, la visibilidad y la convención de llamadas.

---

# Conclusión

La programación combinada entre C y ensamblador permite aprovechar las características de ambos lenguajes. C facilita la creación de programas estructurados y de mayor nivel, mientras que ASM permite trabajar de una manera más cercana al procesador y controlar directamente instrucciones y registros.

Para que ambos lenguajes puedan comunicarse correctamente es necesario comprender el proceso de **enlazado**, ya que es el encargado de conectar las referencias de los diferentes archivos objeto. También es necesario comprender los **nombres de símbolos**, debido a que estos identifican funciones y variables dentro de los módulos del programa.

La **visibilidad de símbolos** es otro elemento importante, ya que permite controlar qué funciones y variables pueden ser utilizadas desde otros módulos. Esto resulta especialmente útil en bibliotecas y proyectos grandes, donde es necesario diferenciar entre una interfaz pública y las funciones internas.

En arquitecturas ARM, la AAPCS establece las reglas necesarias para que funciones escritas en diferentes módulos y lenguajes puedan comunicarse. Entre estas reglas se encuentran el uso de determinados registros para pasar parámetros y devolver resultados, así como las reglas que deben respetarse al realizar llamadas entre funciones [1].

En conclusión, el enlazado, los nombres de símbolos y la visibilidad forman una parte fundamental de la programación mixta entre C y ASM. Comprender estos conceptos permite desarrollar programas ARM más organizados y facilita la integración entre código de alto nivel y código de bajo nivel.

---

# Referencias

[1] Arm Ltd., “Procedure Call Standard for the Arm Architecture (AAPCS32),” *Arm Architecture ABI*, 2026. [En línea]. Disponible en: https://github.com/ARM-software/abi-aa/blob/main/aapcs32/aapcs32.rst

[2] Arm Ltd., “Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64),” *Arm Architecture ABI*, 2026. [En línea]. Disponible en: https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst

[3] Arm Ltd., “ARM Compiler Software Development Guide,” *Arm Documentation*. [En línea]. Disponible en: https://documentation-service.arm.com/

[4] Free Software Foundation, “Code Gen Options — GCC,” *Using the GNU Compiler Collection*. [En línea]. Disponible en: https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html

[5] J. Valvano, “Linking C to Assembly,” *Introduction to Embedded Systems*, The University of Texas at Austin. [En línea]. Disponible en: https://users.ece.utexas.edu/~valvano/mspm0/ebook/Ch6_LocalVariables.htm
