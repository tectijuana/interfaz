# Pruebas unitarias de código ensamblador con Unity y Ceedling

## Introducción

Las pruebas unitarias en lenguaje ensamblador son el proceso de verificar de manera aislada que las instrucciones más pequeñas e indivisibles de un programa, como funciones, subrutinas o macros, funcionen exactamente como se espera.

A diferencia de los lenguajes de alto nivel, donde las pruebas normalmente verifican la lógica de negocio y estructuras de datos, en ensamblador las pruebas pueden enfocarse en aspectos relacionados directamente con el funcionamiento del procesador, como los registros, las banderas de estado (*flags*), la memoria y las convenciones de llamada.

Las pruebas unitarias de código ensamblador presentan algunas características particulares:

* **Control de registros y banderas:** dependiendo de la arquitectura, una prueba puede verificar no solamente el resultado de una subrutina, sino también si se modificaron correctamente determinados registros o banderas como Zero, Carry u Overflow.
* **Control de memoria:** se puede comprobar que una rutina lea o escriba los valores correctos en las posiciones de memoria esperadas.
* **Ausencia de tipos de alto nivel:** el ensamblador trabaja directamente con registros, valores, direcciones y operaciones definidas por la arquitectura. Por ello, una prueba debe considerar correctamente aspectos como valores con signo, sin signo, máscaras de bits y punteros.
* **Aislamiento:** una subrutina puede probarse proporcionando determinados valores de entrada y comprobando posteriormente el estado o resultado producido.
* **Dependencia de la arquitectura:** la forma de preparar los registros, comprobar las banderas y realizar llamadas depende del procesador y del ensamblador utilizado.

Para facilitar este proceso pueden utilizarse herramientas como **Unity** y **Ceedling**. Unity proporciona las funciones necesarias para realizar las comprobaciones de las pruebas, mientras que Ceedling permite organizar, compilar y ejecutar automáticamente el proyecto de pruebas, incluyendo código en ensamblador cuando se configura adecuadamente.

## Desarrollo técnico

### 1. Unity

Unity es un framework de pruebas unitarias desarrollado por Throw The Switch para programas escritos en C. Su objetivo principal es proporcionar una forma sencilla de ejecutar funciones de prueba y comprobar que los resultados obtenidos sean los esperados.

Unity utiliza diferentes **aserciones** (*assertions*) para comparar resultados. Algunas de las más utilizadas son:

| Aserción                  | Función                                    |
| ------------------------- | ------------------------------------------ |
| `TEST_ASSERT_TRUE()`      | Comprueba que una condición sea verdadera. |
| `TEST_ASSERT_FALSE()`     | Comprueba que una condición sea falsa.     |
| `TEST_ASSERT_EQUAL()`     | Compara dos valores.                       |
| `TEST_ASSERT_EQUAL_INT()` | Compara dos valores enteros.               |
| `TEST_ASSERT_NOT_EQUAL()` | Comprueba que dos valores sean diferentes. |
| `TEST_ASSERT_NULL()`      | Comprueba que un puntero sea `NULL`.       |
| `TEST_ASSERT_NOT_NULL()`  | Comprueba que un puntero no sea `NULL`.    |

Por ejemplo, si una función escrita en ensamblador debe sumar dos números y devolver el resultado, Unity puede comprobar que el valor retornado sea el esperado:

```c
TEST_ASSERT_EQUAL_INT(12, suma_asm(5, 7));
```

En este caso, la prueba espera que la función `suma_asm` devuelva `12`.

### 2. Estructura de una prueba con Unity

Una prueba unitaria con Unity normalmente utiliza tres elementos principales:

* `setUp()`: se ejecuta antes de cada prueba y permite preparar el entorno.
* `tearDown()`: se ejecuta después de cada prueba y permite realizar tareas de limpieza.
* Funciones `test_...`: contienen las pruebas que se van a ejecutar.

Un ejemplo básico es:

```c
#include "unity.h"

void setUp(void)
{
}

void tearDown(void)
{
}

void test_suma_deberia_funcionar(void)
{
    int resultado = 5 + 7;

    TEST_ASSERT_EQUAL_INT(12, resultado);
}
```

El objetivo de la función `test_suma_deberia_funcionar()` es comprobar que la operación produzca el resultado esperado.

### 3. Ejecución de las pruebas con Unity

Unity también permite crear un programa que ejecute las pruebas de forma automática.

Un ejemplo simplificado es:

```c
#include "unity.h"

void test_suma_deberia_funcionar(void);

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_suma_deberia_funcionar);

    return UNITY_END();
}
```

El proceso general es:

```text
Inicio
   |
   v
UNITY_BEGIN()
   |
   v
RUN_TEST()
   |
   v
Ejecutar prueba
   |
   v
Realizar aserciones
   |
   v
UNITY_END()
   |
   v
Resultado de las pruebas
```

De esta manera, Unity puede indicar si una prueba fue exitosa o si alguna de las condiciones esperadas no se cumplió.

### 4. ¿Qué es Ceedling?

Ceedling es una herramienta de automatización para proyectos de pruebas en C. Está diseñada para trabajar junto con Unity y otras herramientas del ecosistema de Throw The Switch.

Mientras Unity se encarga principalmente de proporcionar las funciones para realizar las comprobaciones, Ceedling automatiza diferentes tareas relacionadas con el proyecto, como:

* Organización de archivos.
* Compilación del código.
* Construcción del ejecutable de pruebas.
* Ejecución de las pruebas.
* Generación de resultados.
* Integración de archivos adicionales necesarios para las pruebas.

La relación puede representarse de la siguiente manera:

```text
                 CEEDLING
                    |
       +------------+------------+
       |                         |
       v                         v
    UNITY                  Código fuente
       |                  C / Ensamblador
       |                         |
       +------------+------------+
                    |
                    v
             Ejecutable de pruebas
                    |
                    v
              Resultado final
```

### 5. Ceedling y código ensamblador

Aunque Ceedling está orientado principalmente a proyectos escritos en C, también puede trabajar con código ensamblador cuando el proyecto se configura para utilizarlo.

Esto resulta útil cuando una función está implementada en ensamblador, pero se desea probarla desde un archivo de prueba escrito en C.

Por ejemplo, se puede tener:

```text
Proyecto
│
├── src/
│   ├── suma.s
│   └── suma.h
│
├── test/
│   └── test_suma.c
│
└── project.yml
```

En este caso:

* `suma.s` contiene la implementación en ensamblador.
* `suma.h` declara la función para que pueda ser utilizada desde C.
* `test_suma.c` contiene las pruebas unitarias.
* `project.yml` contiene la configuración de Ceedling.

### 6. `TEST_SOURCE_FILE()`

Ceedling permite indicar explícitamente que determinado archivo fuente debe incluirse en el ejecutable de una prueba mediante `TEST_SOURCE_FILE()`.

Esto puede ser especialmente útil cuando se trabaja con código ensamblador que debe formar parte de una prueba específica.

Por ejemplo:

```c
TEST_SOURCE_FILE("suma.s")
```

La finalidad es indicar que el archivo `suma.s` debe formar parte de la construcción correspondiente a la prueba.

El flujo puede visualizarse así:

```text
test_suma.c
     |
     | llama a
     v
suma_asm()
     |
     | implementada en
     v
suma.s
     |
     v
Resultado
     |
     v
Unity verifica el resultado
```

### 7. Configuración de Ceedling para ensamblador

Para permitir que Ceedling utilice archivos ensamblador durante la construcción de las pruebas, es necesario habilitar el soporte correspondiente en `project.yml`.

Una configuración puede incluir:

```yaml
:test_build:
  :use_assembly: TRUE
```

La opción `:use_assembly` permite que Ceedling prepare la construcción considerando archivos de ensamblador.

La configuración exacta puede variar dependiendo de la arquitectura, compilador y ensamblador utilizados. Por ejemplo, un proyecto que utiliza GNU Assembly para x86-64 no necesariamente tendrá la misma configuración que uno destinado a ARM o a un microcontrolador.

### 8. Ejemplo práctico

Para mostrar la relación entre ensamblador, C, Unity y Ceedling, se puede utilizar una función sencilla que sume dos números.

En este ejemplo se utiliza **x86-64 con sintaxis GNU Assembly**.

#### Código ensamblador

Archivo:

```text
src/suma.s
```

Contenido:

```asm
.global suma_asm
.text

suma_asm:
    mov %rdi, %rax
    add %rsi, %rax
    ret
```

La función recibe dos valores enteros mediante los registros utilizados por la convención de llamada de x86-64 y coloca el resultado en `RAX`.

Conceptualmente:

```text
Entrada 1 ──> RDI
Entrada 2 ──> RSI

       RDI + RSI
           |
           v
          RAX
           |
           v
        RET
```

#### Archivo de cabecera

Archivo:

```text
src/suma.h
```

Contenido:

```c
#ifndef SUMA_H
#define SUMA_H

int suma_asm(int a, int b);

#endif
```

El archivo de cabecera permite que el código en C conozca la existencia de la función implementada en ensamblador.

#### Prueba unitaria

Archivo:

```text
test/test_suma.c
```

Contenido:

```c
#include "unity.h"
#include "suma.h"

void setUp(void)
{
}

void tearDown(void)
{
}

void test_suma_asm_deberia_sumar_dos_numeros(void)
{
    int resultado = suma_asm(5, 7);

    TEST_ASSERT_EQUAL_INT(12, resultado);
}

void test_suma_asm_deberia_sumar_cero(void)
{
    int resultado = suma_asm(10, 0);

    TEST_ASSERT_EQUAL_INT(10, resultado);
}
```

En la primera prueba se verifica:

```text
5 + 7 = 12
```

Por lo tanto:

```c
TEST_ASSERT_EQUAL_INT(12, resultado);
```

comprueba que el resultado obtenido sea `12`.

En la segunda prueba se verifica:

```text
10 + 0 = 10
```

### 9. Inclusión del archivo ensamblador en la prueba

Cuando es necesario indicar que el archivo ensamblador debe formar parte de la prueba, puede utilizarse:

```c
TEST_SOURCE_FILE("suma.s")
```

Esto permite relacionar el archivo de prueba con el código ensamblador que se desea probar.

La estructura del proyecto puede quedar de la siguiente manera:

```text
proyecto/
│
├── project.yml
│
├── src/
│   ├── suma.s
│   └── suma.h
│
└── test/
    └── test_suma.c
```

### 10. Configuración del proyecto

Dentro de `project.yml` se puede habilitar el uso de ensamblador:

```yaml
:test_build:
  :use_assembly: TRUE
```

A partir de esta configuración, Ceedling puede incorporar los archivos ensamblador necesarios durante la construcción del ejecutable de pruebas.

El proceso general sería:

```text
                project.yml
                     |
                     v
                 Ceedling
                     |
          +----------+----------+
          |                     |
          v                     v
     test_suma.c             suma.s
          |                     |
          +----------+----------+
                     |
                     v
                Compilación
                     |
                     v
          Ejecutable de prueba
                     |
                     v
                  Unity
                     |
                     v
          Comparación de resultados
                     |
              +------+------+
              |             |
              v             v
            PASS          FAIL
```

### 11. ¿Qué comprueba realmente una prueba de ensamblador?

Una prueba unitaria de una función en ensamblador puede comprobar diferentes aspectos, dependiendo de la arquitectura y del objetivo de la función.

Por ejemplo:

#### Resultado

Se puede comprobar que una operación produzca el valor correcto:

```c
TEST_ASSERT_EQUAL_INT(12, suma_asm(5, 7));
```

#### Valores límite

También se pueden probar valores como:

```text
0
1
-1
Máximo valor permitido
Mínimo valor permitido
```

Esto permite detectar errores que solamente aparecen con determinados valores.

#### Registros

En funciones donde es importante conservar determinados registros, puede ser necesario utilizar código auxiliar o *wrappers* que permitan hacer observable el estado de los registros antes y después de ejecutar la rutina.

Esto es importante porque Unity trabaja principalmente desde C y no puede inspeccionar automáticamente cualquier registro interno del procesador.

#### Banderas

De manera similar, si la rutina debe modificar determinadas banderas como Zero, Carry u Overflow, es necesario utilizar mecanismos específicos de la arquitectura para capturar y comprobar su estado.

Por ejemplo, una rutina puede establecer una bandera después de una operación aritmética y un código auxiliar puede convertir ese estado en un valor que Unity pueda comprobar.

Por lo tanto:

```text
Código ensamblador
       |
       v
Estado del procesador
       |
       v
Wrapper / función auxiliar
       |
       v
Valor observable en C
       |
       v
Unity
       |
       v
ASSERT
```

### 12. Ventajas de utilizar pruebas unitarias en ensamblador

Las pruebas unitarias permiten detectar errores de manera temprana y comprobar el comportamiento de rutinas individuales antes de integrarlas con el resto del programa.

Entre sus ventajas se encuentran:

* Detectar errores en operaciones aritméticas.
* Comprobar valores de retorno.
* Verificar casos límite.
* Detectar errores en acceso a memoria.
* Comprobar determinadas convenciones de llamada.
* Facilitar la detección de regresiones.
* Automatizar la ejecución de las pruebas.
* Permitir repetir las mismas pruebas después de modificar el código.
* Integrar código ensamblador dentro de un flujo automatizado de pruebas.

### 13. Limitaciones

Las pruebas unitarias de ensamblador también presentan algunas dificultades.

La primera es la **dependencia de la arquitectura**. Una rutina escrita para x86-64 no utiliza necesariamente los mismos registros, instrucciones o convenciones de llamada que una rutina para ARM, AVR, MIPS u otra arquitectura.

También puede ser necesario utilizar código auxiliar cuando se desean comprobar aspectos internos del procesador, como registros o banderas.

Otra dificultad es la interacción con hardware real. Si una rutina depende directamente de periféricos, registros de hardware, interrupciones o dispositivos externos, una prueba ejecutada en una computadora puede no representar completamente el comportamiento del sistema físico.

Por este motivo, dependiendo del proyecto, pueden combinarse pruebas unitarias con pruebas de integración y pruebas realizadas directamente sobre el hardware.

### 14. Relación entre las herramientas

| Elemento             | Función                                                            |
| -------------------- | ------------------------------------------------------------------ |
| Código ensamblador   | Implementa la rutina que se desea probar.                          |
| C                    | Puede utilizarse como interfaz y para escribir las pruebas.        |
| Unity                | Proporciona las aserciones y el sistema de pruebas.                |
| Ceedling             | Automatiza la compilación, organización y ejecución.               |
| `project.yml`        | Define la configuración del proyecto Ceedling.                     |
| `TEST_SOURCE_FILE()` | Permite incluir explícitamente archivos fuente en una prueba.      |
| `:use_assembly`      | Habilita el uso de ensamblador durante la construcción de pruebas. |

### 15. Importancia de las pruebas unitarias en código ensamblador

El código ensamblador suele utilizarse en situaciones donde se necesita un control muy específico del procesador, como sistemas embebidos, controladores, rutinas de bajo nivel y determinadas operaciones optimizadas.

Debido a que pequeños errores pueden modificar registros, direcciones de memoria o resultados de operaciones, probar las rutinas de manera aislada puede ayudar a encontrar errores antes de que afecten al programa completo.

El uso conjunto de Unity y Ceedling permite integrar estas pruebas dentro de un proceso automatizado. Unity se encarga de comprobar los resultados mediante aserciones, mientras que Ceedling facilita la construcción y ejecución de las pruebas.

### Conclusión

Las pruebas unitarias de código ensamblador permiten verificar el comportamiento de funciones y subrutinas de bajo nivel de manera aislada. Aunque las pruebas pueden realizarse directamente sobre valores de entrada y salida, también pueden ser necesarias técnicas adicionales para comprobar registros, banderas y otros estados internos del procesador.

Unity proporciona las herramientas necesarias para escribir las comprobaciones de las pruebas, mientras que Ceedling automatiza la construcción y ejecución del proyecto. Mediante configuraciones como `:use_assembly` y mecanismos como `TEST_SOURCE_FILE()`, es posible integrar código ensamblador dentro de un flujo de pruebas automatizado.

De esta forma, una función escrita en ensamblador puede probarse desde un entorno organizado y repetible, facilitando la detección de errores y permitiendo comprobar que las modificaciones posteriores no alteren el comportamiento esperado de las rutinas.

## Referencias

1. Throw The Switch. **Unity — Unit Testing for C**.
   https://www.throwtheswitch.org/unity

2. Throw The Switch. **Unity Getting Started Guide**.
   https://github.com/ThrowTheSwitch/Unity/blob/master/docs/UnityGettingStartedGuide.md

3. Throw The Switch. **Ceedling — Test Build Directives**.
   https://docs.throwtheswitch.org/latest/reference/build-directives/

4. Throw The Switch. **Ceedling — Configuration Reference**.
   https://throwtheswitch.github.io/Ceedling/latest/configuration/reference/
