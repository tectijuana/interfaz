# Anexo — Bitácora de uso de LLM

## 1. Uso de inteligencia artificial

Para realizar esta investigación se utilizó un modelo de lenguaje (LLM) como herramienta de apoyo para comprender los conceptos relacionados con las funciones hash sencillas, obtener ejemplos y revisar la estructura del trabajo.

La inteligencia artificial se utilizó como apoyo durante la investigación, pero la información obtenida fue revisada y modificada para mejorar su comprensión y corregir posibles errores.

---

## 2. Prompts utilizados

### Prompt 1

> “Ayudame a entender un poco mas acerca de "Funciones hash sencillas, descripcion de lo que es y algunos ejemplos que pueda utilizar"”

**Resultado obtenido:**

El LLM proporcionó una explicación general sobre las funciones hash, describiéndolas como algoritmos que reciben una entrada y generan un valor de tamaño fijo. También se proporcionaron ejemplos sencillos para comprender su funcionamiento y se explicó que diferentes entradas pueden producir el mismo resultado, lo que se conoce como una colisión.

La información obtenida sirvió como base para comprender el concepto antes de profundizar en funciones hash específicas como djb2 y FNV-1a.

---

### Prompt 2

> “Necesito una explicación detallada de los algoritmos (djb2, FNV-1a) implementadas en ASM y algunos ejemplos visibles”

**Resultado obtenido:**

El LLM amplió la explicación hacia las funciones djb2 y FNV-1a, incluyendo su funcionamiento, las operaciones utilizadas por cada algoritmo y una comparación entre ambos.

También se explicó cómo las operaciones de los algoritmos pueden relacionarse con instrucciones de lenguaje ensamblador ARM, tomando en cuenta el entorno utilizado para la materia.

---

## 3. Corrección de errores

Durante la revisión se prestó especial atención a las diferencias entre los algoritmos djb2 y FNV-1a, debido a que ambos son funciones hash no criptográficas pero utilizan operaciones diferentes.

En el caso de djb2 se revisó que la operación utilizada correspondiera a:

```text
hash = hash * 33 + byte
```

También se comprobó que la multiplicación por 33 puede representarse mediante un desplazamiento y una suma:

```text
hash = (hash << 5) + hash + byte
```

Esto permitió relacionar la operación con instrucciones de desplazamiento y suma en ARM.

Para FNV-1a se revisó que el orden de las operaciones fuera correcto. El algoritmo primero realiza un XOR entre el hash y el byte de entrada y posteriormente realiza la multiplicación:

```text
hash = hash XOR byte
hash = hash * FNV_prime
```

También se revisaron las constantes utilizadas para la versión de 32 bits:

```text
Offset basis = 2166136261
FNV prime = 16777619
```

Esta revisión fue importante porque FNV-1 y FNV-1a tienen un orden diferente en sus operaciones.

---

## 4. Reflexión crítica

El uso del LLM fue útil principalmente para comprender un concepto que inicialmente podía resultar confuso, ya que las funciones hash pueden parecer similares a mecanismos de cifrado aunque tengan objetivos diferentes.

Una de las ventajas fue poder solicitar una explicación sencilla antes de entrar en detalles como djb2, FNV-1a y su implementación en lenguaje ensamblador. Esto permitió relacionar conceptos básicos, como entrada, salida y colisiones, con operaciones de más bajo nivel.

Sin embargo, también se identificó que las respuestas generadas por un LLM pueden contener errores o generalizaciones. En especial, cuando se trabaja con lenguaje ensamblador, una explicación puede utilizar instrucciones que no necesariamente sean compatibles con todas las arquitecturas ARM. Adicionalmente se investigo en varios sitios web donde se encontraron ejemplos similares y con ayuda del modelo LLM se logró entender mejor este tema. 

Por este motivo, fue necesario revisar la arquitectura utilizada y comprobar que las instrucciones propuestas fueran adecuadas para el entorno de trabajo. También fue necesario verificar las constantes y el orden de las operaciones de los algoritmos para evitar confundir djb2 con alguna de sus variantes o FNV-1 con FNV-1a.

Otro punto importante fue comprobar que las funciones hash estudiadas son **no criptográficas**. Esto significa que no deben utilizarse como mecanismos de protección para contraseñas o información sensible.

En conclusión, el LLM funcionó como una herramienta de apoyo para investigar, organizar y comprender el tema, pero fue necesario revisar críticamente la información obtenida y comprobar que los conceptos y ejemplos utilizados fueran coherentes.

---

## 5. Validación

Los conceptos relacionados con djb2 y FNV-1a fueron revisados utilizando documentación técnica y referencias relacionadas con las implementaciones de estas funciones hash.

Se verificaron especialmente:

* El valor inicial utilizado por djb2.
* La operación `hash * 33 + byte`.
* La transformación de la multiplicación por 33 mediante desplazamiento y suma.
* El valor inicial de FNV-1a de 32 bits.
* La constante `16777619`.
* El orden XOR → multiplicación utilizado por FNV-1a.
* La diferencia entre FNV-1 y FNV-1a.
* Las instrucciones ARM utilizadas para representar las operaciones de los algoritmos.

También se revisó que los ejemplos de lenguaje ensamblador correspondieran al enfoque de ARM utilizado en la investigación y que no se presentara pseudocódigo como si fuera una implementación real en ASM.

La IA se utilizó como apoyo durante el proceso, pero la revisión y comprensión final del contenido fueron responsabilidad del estudiante.
