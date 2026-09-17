# Convención de llamada AAPCS64: paso de parámetros y valores de retorno

**Autor:** Joel Junior Canales Calderón
**Tema:** #8 
**Curso:** Lenguajes de Interfaz (SCC-1014), 2026 "A"

## Introducción

Cuando dos funciones escritas en distintos lenguajes, compiladas por distintos
compiladores o incluso escritas por distintas personas necesitan comunicarse
entre sí, debe existir un "contrato" común que defina cómo se pasan los
parámetros, dónde se coloca el valor de retorno y qué registros debe
preservar cada función. En la arquitectura ARM de 64 bits (AArch64), ese
contrato se llama **AAPCS64** (*ARM Architecture Procedure Call Standard for
the 64-bit Architecture*), parte de la especificación ABI (*Application
Binary Interface*) publicada oficialmente por ARM. Esta investigación explica
las reglas centrales de AAPCS64 para el paso de parámetros y la devolución de
valores, ilustradas con el uso concreto de los registros involucrados.

## Desarrollo técnico

AAPCS64 define 31 registros de propósito general de 64 bits, llamados `X0`
a `X30` (o sus mitades de 32 bits `W0`-`W30`), además del puntero de pila
`SP`. De estos, los primeros ocho —`X0` a `X7`— cumplen un rol especial: son
los **registros de argumento**, usados tanto para pasar parámetros a una
función como para devolver resultados.

**Paso de parámetros enteros y punteros.** Cuando se llama a una función, los
primeros ocho argumentos de tipo entero o puntero se colocan, en orden, en
`X0` hasta `X7`. Si el argumento es menor que el registro completo (por
ejemplo, un `char` o un `short`), ocupa los bits bajos y los bits altos
quedan sin definir. Si la función necesita más de ocho argumentos enteros,
los adicionales se colocan en la pila, en orden inverso, respetando los
requisitos de alineación de cada tipo.

**Paso de parámetros de punto flotante.** Los valores de tipo `float` y
`double` no compiten por los mismos registros que los enteros: usan un banco
independiente de ocho registros vectoriales, `V0` a `V7`. Esto significa que
una función como `f(int a, double b, int c)` puede recibir `a` en `X0`, `b`
en `V0` y `c` en `X1` simultáneamente, ya que cada tipo de dato avanza su
propio contador de registros disponibles.

**Estructuras y agregados.** Si un parámetro es una estructura (`struct`)
pequeña, de 16 bytes o menos, se empaqueta directamente en uno o dos
registros enteros. Si la estructura es mayor a 16 bytes, en su lugar se pasa
**por dirección**: el llamador reserva espacio en su propia pila, copia ahí
la estructura, y lo que realmente viaja en el registro es un puntero a esa
copia. Existe una excepción relevante: si la estructura está compuesta
enteramente por campos `float` o enteramente por `double` (un tipo
"homogéneo" de punto flotante), cada campo se coloca en un registro `V`
distinto en lugar de empaquetarse como entero.

**Valores de retorno.** El resultado de una función se devuelve típicamente
en `X0` (o en el par `X0`/`X1` si el valor ocupa 128 bits, como un entero de
doble palabra). Para resultados en punto flotante, se usa `V0` de la misma
manera. El caso especial ocurre con estructuras grandes (mayores a 16
bytes): en lugar de intentar devolverlas por registro, el llamador reserva
espacio para el resultado y pasa un puntero oculto a ese espacio en el
registro `X8` (conocido como *Indirect Result Location Register*), y es
responsabilidad de la función llamada escribir el resultado directamente ahí.

**Preservación de registros.** AAPCS64 también clasifica los registros según
quién debe preservar su valor a través de una llamada: `X19` a `X28` son
*callee-saved* (si una función los usa, debe guardarlos al inicio y
restaurarlos antes de retornar), mientras que `X9` a `X15` son *caller-saved*
o de uso libre dentro de una función, sin garantía de que sobrevivan a una
llamada. Adicionalmente, `X29` funciona como puntero de marco (*frame
pointer*), `X30` guarda la dirección de retorno (*link register*), y la pila
debe mantenerse siempre alineada a 16 bytes en cualquier punto donde ocurra
una llamada a función, sin excepción.

Este conjunto de reglas es lo que permite, por ejemplo, que una función
escrita en ensamblador ARM64 pueda ser llamada directamente desde C, o que
una biblioteca compartida (`.so`) compilada con GCC funcione correctamente
al ser invocada por un binario compilado con Clang: ambos compiladores
generan código que respeta exactamente el mismo contrato de registros.

## Conclusiones

La convención de llamada AAPCS64 es el mecanismo que hace posible la
interoperabilidad binaria en el ecosistema ARM de 64 bits: define de forma
precisa qué registro recibe cada parámetro según su tipo (`X0`-`X7` para
enteros y punteros, `V0`-`V7` para punto flotante), cómo se manejan los casos
límite (estructuras grandes pasadas por dirección, resultados grandes
devueltos mediante el registro oculto `X8`), y qué registros debe cuidar cada
función a lo largo de una llamada. Comprender esta convención es esencial no
solo para escribir código ensamblador que interactúe correctamente con
funciones en C, sino también para depurar programas a bajo nivel, analizar
código binario en ingeniería inversa, y entender por qué el compilador genera
ciertas instrucciones de preámbulo y epílogo en cada función.

## Bibliografía

[1] ARM Limited, "Procedure Call Standard for the Arm 64-bit Architecture
(AAPCS64)," *abi-aa repository*, GitHub, 2024. [Online]. Available:
https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst

[2] R. Chen, "The AArch64 processor (aka arm64), part 20: The classic
calling convention," *Microsoft DevBlogs — The Old New Thing*, Aug. 23, 2022.
[Online]. Available: https://devblogs.microsoft.com/oldnewthing/20220823-00/?p=107041

[3] T. Cici, "AArch64 Procedure Call Standard (AAPCS64): ABI, Calling
Conventions & Machine Registers," *Medium*, Jul. 25, 2024. [Online].
Available: https://medium.com/@tunacici7/aarch64-procedure-call-standard-aapcs64-abi-calling-conventions-machine-registers-a2c762540278

[4] W. Zafar, "ARM Assembly Part 6: Stack, Subroutines & AAPCS," *ARM
Assembly Mastery Series*, Feb. 19, 2026. [Online]. Available:
https://www.wasilzafar.com/pages/series/arm-assembly/arm-assembly-06-stack-subroutines.html
