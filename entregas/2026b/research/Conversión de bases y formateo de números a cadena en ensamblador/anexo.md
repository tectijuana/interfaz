# Anexo: Bitácora de uso del LLM

## 1. Datos generales

**Tema de investigación:** Conversión de bases y formateo de números a cadena en ensamblador  
**Arquitecturas:** ARM64, ARM32 y RISC-V  
**Herramienta utilizada:** Modelo de lenguaje (LLM)  
**Archivo:** `anexo.md`

---

# 2. Prompts reales

## 2.1 Prompt utilizado para generar la investigación

El prompt utilizado para solicitar la generación de la investigación fue:

```text
Actúa como un experto en Arquitectura de Computadores, Lenguaje Ensamblador y Compiladores para la arquitectura ARM64.

Necesito que redactes una investigación completa en formato Markdown sobre el tema:

"Conversión de bases y formateo de números a cadena en ensamblador (ARM64/ARM32/RISC-V)"

El contenido debe explicar de manera académica y técnica el algoritmo de conversión de números enteros a diferentes bases y su posterior formateo como cadenas de caracteres.

La investigación debe incluir:

1. Introducción al problema.
2. Fundamentos matemáticos de la conversión de bases.
3. Algoritmo de división sucesiva.
4. Conversión a bases 2, 8, 10 y 16.
5. Conversión de residuos a caracteres ASCII.
6. Uso de tablas de caracteres para hexadecimal.
7. Manejo del orden inverso de los residuos.
8. Uso de pilas y buffers.
9. Manejo de números con signo.
10. Caso especial del cero.
11. Implementación y explicación en ARM64.
12. Instrucciones UDIV y MSUB.
13. Implementación conceptual en ARM32.
14. Implementación en RISC-V.
15. Diferencias entre RV32I/RV64I y la extensión M.
16. Uso de DIV, DIVU, REM y REMU en RISC-V.
17. Convenciones de llamada y registros utilizados.
18. Optimización mediante desplazamientos y máscaras para bases potencia de dos.
19. Comparación entre ARM64, ARM32 y RISC-V.
20. Ejemplos de código ensamblador.
21. Análisis de eficiencia y complejidad.
22. Conclusiones.
23. Bibliografía.

Incluye ejemplos prácticos y código ensamblador correctamente comentado. Diferencia claramente las instrucciones pertenecientes a cada ISA y evita mezclar instrucciones de ARM con RISC-V.

La investigación debe estar redactada en español, tener estructura académica y utilizar Markdown correctamente.
```

---

# 3. Resultados obtenidos

El modelo produjo una investigación centrada en el algoritmo de conversión de enteros a cadenas mediante divisiones sucesivas.

Los principales contenidos generados fueron:

- Explicación matemática de la división sucesiva.
- Obtención del cociente y residuo.
- Conversión de residuos a caracteres ASCII.
- Conversión a bases binarias, octales, decimales y hexadecimales.
- Uso de una tabla como:

```text
0123456789ABCDEF
```

- Explicación del problema del orden inverso de los residuos.
- Uso de pilas para invertir los residuos.
- Construcción de cadenas desde el final de un buffer.
- Manejo del valor cero.
- Manejo de números negativos.
- Consideración del valor mínimo de los enteros con signo.
- Explicación de instrucciones de ARM64.
- Ejemplo de una rutina `u64_to_dec`.
- Explicación conceptual de ARM32.
- Explicación de las instrucciones de división y resto de RISC-V.
- Diferenciación entre las extensiones base y la extensión `M`.
- Comparación entre ARM64, ARM32 y RISC-V.
- Optimización de conversiones para bases potencia de dos.
- Análisis general de eficiencia.
- Bibliografía técnica relacionada con ARM y RISC-V.

El resultado permitió obtener una estructura inicial que posteriormente puede revisarse y contrastarse con los manuales oficiales de las arquitecturas.

---

# 4. Reflexión crítica

## 4.1 Utilidad del LLM

El uso del modelo de lenguaje resultó útil principalmente para acelerar la etapa de organización de la investigación.

Una de las ventajas principales fue la posibilidad de obtener rápidamente una estructura ordenada que incluyera conceptos matemáticos, arquitectura de computadores, instrucciones de ensamblador, ejemplos y conclusiones.

El modelo permitió transformar el tema general:

```text
Conversión de bases y formateo de números a cadena
```

en diferentes subtemas:

```text
Algoritmo matemático
        ↓
División y módulo
        ↓
Obtención de residuos
        ↓
Conversión a ASCII
        ↓
Construcción de la cadena
        ↓
Implementación en ARM64
        ↓
Implementación en ARM32
        ↓
Implementación en RISC-V
        ↓
Comparación entre ISA
```

Esto redujo considerablemente el tiempo necesario para establecer el esquema inicial del documento.

También resultó útil para generar ejemplos de código y pseudocódigo que posteriormente podían ser revisados manualmente.

Sin embargo, la generación automática no debe considerarse equivalente a una verificación técnica. El LLM puede producir código sintácticamente plausible pero incorrecto para una arquitectura específica, o combinar información válida de diferentes variantes de una ISA.

Por esta razón, el contenido generado se utilizó como punto de partida y no como única fuente de autoridad.

---

# 5. Detección de errores y sesgos

## 5.1 Posibles errores de sintaxis

Uno de los principales riesgos identificados fue asumir que un fragmento de ensamblador generado por el LLM necesariamente podía ensamblarse sin modificaciones.

El lenguaje ensamblador depende del ensamblador concreto utilizado.

Por ejemplo, una instrucción puede tener diferencias de sintaxis entre:

```text
GNU Assembler (GAS)
```

y otros ensambladores.

También pueden existir diferencias entre:

```text
sintaxis GNU
```

y:

```text
sintaxis de herramientas específicas del fabricante
```

Por esta razón, el código generado debe probarse realmente con el ensamblador correspondiente.

---

## 5.2 Alineación de memoria

Otro aspecto que requiere revisión es la alineación de memoria.

En ARM64, la convención AAPCS64 establece requisitos específicos de alineación de la pila. Una función que modifica `SP` debe respetar estas reglas, especialmente cuando realiza llamadas a otras funciones.

En cambio, almacenar un carácter individual mediante:

```asm
strb
```

no debe confundirse con las reglas de alineación aplicables a accesos de palabras o a la pila.

Por ello, durante la revisión debe diferenciarse entre:

```text
alineación del stack
```

y:

```text
alineación de accesos de memoria
```

No son exactamente el mismo concepto.

---

## 5.3 Confusión entre ISA

Uno de los errores más importantes que puede cometer un modelo de lenguaje es mezclar instrucciones pertenecientes a diferentes arquitecturas.

Por ejemplo:

```asm
UDIV
MSUB
STRB
```

corresponden a la sintaxis de ARM/AArch64 en el contexto utilizado.

Mientras que:

```asm
DIVU
REMU
SB
```

son instrucciones de RISC-V.

No sería correcto tomar un código ARM64 y asumir que puede ejecutarse directamente en RISC-V.

La revisión debe comprobar para cada fragmento:

```text
¿A qué ISA pertenece?
¿A qué variante pertenece?
¿Qué registros utiliza?
¿Qué sintaxis utiliza?
¿La instrucción está disponible en el perfil seleccionado?
```

---

# 6. Revisión del código ARM64

El ejemplo de ARM64 utiliza:

```asm
udiv x6, x0, x5
```

para obtener el cociente.

Posteriormente utiliza:

```asm
msub x7, x6, x5, x0
```

para calcular:

```text
x7 = x0 - (x6 * x5)
```

que corresponde al residuo cuando:

```text
x6 = x0 / x5
```

La lógica matemática es:

```text
residuo = N - cociente * base
```

También se utiliza:

```asm
strb w7, [x3]
```

para almacenar un byte en el buffer.

La rutina utiliza registros de 64 bits para el valor y mantiene el carácter en una vista de 32 bits antes de almacenarlo.

El código debe ser probado con el ensamblador y el enlazador correspondientes antes de considerarse una implementación completamente validada.

---

# 7. Revisión del código RISC-V

En RISC-V se utilizaron:

```asm
divu
remu
```

Estas instrucciones pertenecen a la extensión `M`.

Por lo tanto, una implementación que utilice:

```asm
divu
remu
```

no debe presentarse como una implementación exclusiva de:

```text
RV32I
```

o:

```text
RV64I
```

sin la extensión correspondiente.

La descripción correcta es que estas instrucciones están disponibles cuando el procesador implementa la extensión de multiplicación y división correspondiente.

Esta distinción es importante porque RISC-V utiliza una arquitectura modular.

---

# 8. Verificación de la información

La información técnica debe contrastarse con documentación oficial y fuentes académicas.

Para ARM64 se debe consultar principalmente:

```text
Arm Architecture Reference Manual for A-profile Architecture
```

y:

```text
Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64)
```

Para ARM32 se debe consultar la documentación correspondiente al perfil de ARM utilizado y:

```text
Procedure Call Standard for the Arm Architecture (AAPCS32)
```

Para RISC-V se debe consultar:

```text
The RISC-V Instruction Set Manual, Volume I: Unprivileged ISA
```

La finalidad de esta revisión es comprobar:

- Nombre de cada instrucción.
- Operandos permitidos.
- Tamaño de los registros.
- Semántica de la instrucción.
- Disponibilidad de la instrucción.
- Extensión requerida.
- Convención de llamada.
- Requisitos de alineación.
- Tratamiento de valores con signo y sin signo.

---

# 9. Verificación práctica

Además de consultar documentación, el código ensamblador puede comprobarse mediante herramientas de desarrollo.

Para ARM64 pueden utilizarse herramientas como:

```text
as
gcc
clang
objdump
```

Para RISC-V pueden utilizarse toolchains como:

```text
riscv64-unknown-elf-gcc
riscv64-unknown-elf-as
riscv64-unknown-elf-objdump
```

El proceso de verificación puede seguir:

```text
Código generado
      ↓
Revisión manual
      ↓
Consulta del manual de ISA
      ↓
Ensamblado
      ↓
Corrección de errores
      ↓
Ejecución
      ↓
Comparación del resultado
```

Para probar una conversión decimal pueden utilizarse valores conocidos:

```text
0
1
9
10
15
16
99
1234
4294967295
```

También deben probarse casos límite.

---

# 10. Casos de prueba recomendados

## Caso 1: cero

Entrada:

```text
0
```

Salida esperada:

```text
"0"
```

---

## Caso 2: número de un dígito

Entrada:

```text
5
```

Salida:

```text
"5"
```

---

## Caso 3: número decimal

Entrada:

```text
1234
```

Salida:

```text
"1234"
```

---

## Caso 4: hexadecimal

Entrada:

```text
255
```

Salida:

```text
"FF"
```

---

## Caso 5: binario

Entrada:

```text
13
```

Salida:

```text
"1101"
```

---

## Caso 6: octal

Entrada:

```text
64
```

Salida:

```text
"100"
```

---

## Caso 7: valor máximo de 32 bits sin signo

Entrada:

```text
4294967295
```

Salida decimal:

```text
"4294967295"
```

---

## Caso 8: valor máximo de 64 bits sin signo

Entrada:

```text
18446744073709551615
```

Salida:

```text
"18446744073709551615"
```

Este caso es particularmente útil para comprobar el tamaño del buffer.

---

# 11. Limitaciones del uso del LLM

El modelo de lenguaje presenta varias limitaciones que deben considerarse durante una investigación de arquitectura de computadores.

### 11.1 No garantiza compilación

Que una instrucción parezca correcta no significa necesariamente que el ensamblador seleccionado la acepte.

### 11.2 Puede mezclar variantes

Una respuesta puede combinar información de:

```text
ARM32
ARM64
Thumb
AArch64
RISC-V RV32
RISC-V RV64
```

Por ello, cada fragmento debe asociarse explícitamente con una arquitectura.

### 11.3 Puede omitir restricciones de ABI

Una función puede ser matemáticamente correcta pero no respetar una convención de llamada.

### 11.4 Puede simplificar demasiado los casos extremos

El manejo de:

```text
INT_MIN
```

es un ejemplo donde una explicación aparentemente sencilla puede producir errores.

### 11.5 Puede utilizar documentación desactualizada

Las arquitecturas evolucionan y las herramientas también cambian. Por ello, las especificaciones oficiales deben tener prioridad.

---

# 12. Sesgos identificados

El modelo puede presentar una tendencia a utilizar como referencia el caso más común.

Por ejemplo, puede asumir que:

```text
RISC-V = RV64 + extensión M
```

cuando en realidad RISC-V es una familia modular y la presencia de una extensión debe verificarse.

También puede presentar ARM64 como si todas las implementaciones fueran idénticas, cuando las características disponibles y el entorno de ejecución pueden depender del procesador y del sistema.

Por esta razón, una investigación técnica debe distinguir entre:

```text
arquitectura
```

```text
perfil
```

```text
extensión
```

```text
microarquitectura
```

y:

```text
ensamblador utilizado
```

---

# 13. Evaluación final del uso del LLM

El LLM fue especialmente útil para:

- Organizar la investigación.
- Generar una estructura inicial.
- Explicar conceptos matemáticos.
- Crear pseudocódigo.
- Proponer ejemplos.
- Identificar temas relacionados.
- Comparar arquitecturas.
- Generar una primera versión de código.
- Facilitar la redacción de conclusiones.

Sin embargo, la herramienta no sustituye:

- Los manuales oficiales.
- La documentación de la ABI.
- La documentación del ensamblador.
- Las pruebas de compilación.
- Las pruebas de ejecución.
- La revisión humana.

Por ello, el LLM se utilizó como una herramienta de apoyo para la investigación y redacción, mientras que la información técnica debe verificarse mediante documentación oficial.

---

# 14. Conclusión de la bitácora

El uso de un modelo de lenguaje permitió acelerar significativamente la organización y redacción de la investigación sobre conversión de bases y formateo de números a cadena.

La principal utilidad estuvo en transformar un tema amplio en una serie de conceptos relacionados:

```text
bases numéricas
        ↓
división sucesiva
        ↓
cociente y residuo
        ↓
ASCII
        ↓
buffers
        ↓
registros
        ↓
instrucciones de ISA
        ↓
ARM64 / ARM32 / RISC-V
```

No obstante, el análisis también permitió identificar que el código generado automáticamente puede contener errores de sintaxis, asumir instrucciones no disponibles, omitir restricciones de ABI o confundir instrucciones entre diferentes arquitecturas.

Por ello, el resultado generado por el LLM fue tratado como un borrador técnico que necesitaba revisión.

La verificación mediante manuales de referencia y pruebas prácticas constituye una etapa indispensable antes de considerar correcto un código de ensamblador.

En conclusión, el LLM fue una herramienta útil para acelerar la investigación, estructurar información y generar material inicial, pero la validación técnica final debe realizarse mediante documentación oficial, herramientas de ensamblado y pruebas controladas.
