# Anexo: bitácora real de asistencia de IA

## Asistencia de Inteligencia Artificial

- **Estudiante:** Ricardo Araoz Sierra; usuario de GitHub `RicardoAraoz`.
- **Fecha:** 19 de septiembre de 2026, zona America/Tijuana.
- **Herramienta de IA:** Codex, aplicación de escritorio de OpenAI. No se utilizó ChatGPT Work ni un entorno Cloud en esta ejecución.
- **Herramientas de apoyo:** conector GitHub, GitHub CLI, Git, búsqueda web, navegador integrado controlado mediante Computer, terminal, Python 3, Apple Clang 21.0.0 y LLVM objdump de Xcode.
- **Plataforma:** macOS 26.6.2, ARM64 nativo. QEMU, Docker y `aarch64-linux-gnu-gcc` no se encontraron en PATH.

Codex preparó el texto y el ejemplo, consultó documentación y ejecutó las comprobaciones descritas. No se atribuyen al estudiante revisiones manuales, pruebas, comprensión ni experiencias que todavía no haya comunicado. El estudiante añadió su reflexión al archivo y revisó la respuesta sobre la diferencia entre los métodos tras recibir observaciones técnicas de Codex.

## Prompts e instrucciones reales

El usuario proporcionó un prompt maestro extenso para realizar la investigación del Tema 3. Se conservan a continuación extractos literales relevantes, no una transcripción íntegra:

> “Quiero que realices de principio a fin mi entrega de investigación para la materia Lenguajes de Interfaz SCC-1014 utilizando tus capacidades de Work, Cloud Browser/Computer y el plugin/conector de GitHub.”

> “No copies investigaciones de otros alumnos.”

> “No reutilices texto de investigaciones históricas salvo para identificar temas ya trabajados o comprobar colisiones.”

> “Incluye una implementación educativa en ensamblador AArch64 que NO utilice las instrucciones:
>
> UDIV
>
> SDIV”

> “No inventes datos de rendimiento.”

> “No digas que algo fue verificado manualmente por mí si no ocurrió.”

> “No inventes una reflexión personal mía.”

> “NO continúes con commit, push ni Pull Request hasta que yo responda con mi reflexión.”

Durante la planificación, el usuario seleccionó “Ricardo Araoz Sierra (Recommended)” para el encabezado. Posteriormente solicitó “PLEASE IMPLEMENT THIS PLAN:” y adjuntó el plan completo acordado. Entre sus instrucciones figuró:

> “Ensamblar y ejecutar en ARM64 nativo con un programa temporal de prueba; documentar cualquier adaptación necesaria entre macOS y GNU/Linux.”

Las decisiones de comprobación descritas abajo fueron elaboradas por Codex a partir del plan. No hubo conversaciones con otros modelos ni revisión por agentes independientes.

## Actividades y resultados

| Etapa | Acción realizada y evidencia |
|---|---|
| Reglas | Lectura de la lista del Grupo B, `AI_GUIDANCE.md`, `CONTRIBUTING.md`, `REVIEW_RUBRIC.md`, `POLICIES.md`, estilo de código y plantilla de PR. |
| Colisiones | Consulta de `main`, carpeta 2026B, nueve PR abiertos y búsquedas de PR en todos los estados por “division” y “división”. El PR de título genérico #321 trata algoritmos de ordenamiento. No se identificó una entrega equivalente del Tema 3 en 2026B. |
| Antecedente histórico | Se identificó [“Dividir 10 entre 2 usando restas”](https://github.com/tectijuana/interfaz/tree/main/entregas/2025/research/Dividir%2010%20entre%202%20usando%20restas), de José Enrique Serna Sauceda: ejercicio fijo de un simulador de 8 bits. Se inspeccionó para delimitar la posible colisión; no se reutilizó texto ni código. La entrega actual estudia algoritmos generales y residuo unsigned AArch64 de 64 bits. |
| GitHub | El conector identificó la cuenta. La consulta de repositorios no encontró forks públicos; se creó [RicardoAraoz/interfaz](https://github.com/RicardoAraoz/interfaz) mediante GitHub CLI. |
| Rama | Se clonó el fork y se creó localmente `investigacion/division-entera-modulo` desde `upstream/main`, commit `44e9ada8efdb472eb3a57cc5b3c138fb973a9542`, coincidente con el fork. |
| Investigación | Consulta de siete referencias identificadas en el README; redacción asistida en español y análisis del invariante, límites y diferencias signed/unsigned. |
| Implementación | Rutina independiente, con alineación protegida, dos salidas en registros y caso divisor cero. La fuente no contiene llamadas a bibliotecas. |
| Validación | 165,998 casos ejecutados en ARM64 nativo, cero fallos; comprobación textual y desensamblado sin instrucciones de división. |

## Cambios, verificaciones y límites

Se evitó el diseño incorrecto de duplicar el divisor hasta que se desbordara: la condición `D <= n>>1` se aplica antes del desplazamiento. Se documentó que la salida `UINT64_MAX` no identifica por sí sola un error, porque también puede ser un cociente válido.

Los enlaces antiguos de las instrucciones de Arm fallaron en la consulta web. El navegador permitió seguir el índice oficial hasta las páginas actuales “UDIV (quotient)” y “SDIV (quotient)”, versión 2026-06. No se tomó la redirección al índice como evidencia de haber leído una instrucción. Se comprobaron su descripción y pseudocódigo. No fue necesario iniciar sesión.

El acceso inicial a GitHub desde la terminal falló por conectividad restringida. La consulta autorizada con acceso de red funcionó. El conector se utilizó para leer archivos y buscar PR; GitHub CLI permitió consultar listados completos y crear el fork.

La misma fuente se ensambló para macOS y para ELF AArch64; los símbolos con y sin guion bajo permiten enlazarla sin cambiar el algoritmo. Los objetos contienen las mismas 25 instrucciones, 100 bytes. Esto verifica la traducción a código máquina, pero no equivale a ejecutar Linux ni a validar GNU `as`.

Las pruebas usaron división de C únicamente como oráculo externo; no implementa ni sustituye la rutina ensamblador. Se comprobaron también `r<d` y `n=d*q+r` con un producto de 128 bits. No hubo benchmark, ejecución AWS, prueba QEMU, comprobación exhaustiva de todo el dominio ni validación signed. La preservación de registros se revisó en la fuente y el desensamblado, sin un ensayo dinámico independiente del ABI.

### Verificación de referencias

| Referencia del README | Resultado |
|---|---|
| [1], [2]: Arm DDI 0602 | Páginas oficiales leídas en el navegador, versión y semántica comprobadas. |
| [3]: Ryan Robucci, UMBC | Autor, título y explicación de división restauradora/condicional comprobados; sin fecha de publicación atribuida. |
| [4]: AAPCS64 | Documento oficial de Arm, versión 2025Q4, fecha de emisión 2026; registros y retorno consultados. |
| [5]: GCC Internals | Rutinas de división y de cociente/residuo verificadas en documentación oficial. |
| [6]: GNU Binutils | Página oficial de directivas AArch64 disponible y consultada. |
| [7]: WG14 N1570 | Borrador de C de 2011, sección 6.5.5: truncamiento y cociente no representable comprobados. |

No se inventaron DOI, ediciones ni años. Las entradas sin fecha identificable usan “s. f.” y fecha real de consulta.

## Evidencia de las pruebas locales

La implementación y el programa de prueba se conservaron localmente y no se incluyen en el PR, conforme a la preferencia posterior del estudiante y al carácter opcional del código en la lista del Grupo B. Los resultados siguientes corresponden a la ejecución anterior a ese ajuste. Esta entrega documental no contiene todos los archivos necesarios para reproducir las pruebas.

Se utilizó Apple Clang 21.0.0 con `-Wall -Wextra -Werror -O2` para enlazar la rutina y el programa de prueba. Se generaron objetos Mach-O y ELF AArch64 y se inspeccionaron con LLVM objdump. El binario nativo terminó con código de salida cero. La semilla de las 100,000 parejas pseudoaleatorias fue `0x10142026B`; también se probaron los diez casos solicitados, 196 combinaciones de límites, 65,536 pares pequeños y 256 casos de potencias de dos.

### Salida real

```text
23 / 5 -> q=4 r=3 PASS
100 / 10 -> q=10 r=0 PASS
7 / 9 -> q=0 r=7 PASS
0 / 5 -> q=0 r=0 PASS
1 / 1 -> q=1 r=0 PASS
5 / 1 -> q=5 r=0 PASS
5 / 5 -> q=1 r=0 PASS
1 / 2 -> q=0 r=1 PASS
18446744073709551615 / 1 -> q=18446744073709551615 r=0 PASS
23 / 0 -> q=18446744073709551615 r=23 PASS
TOTAL: 165998 casos PASS; 0 fallos. Semilla: 0x10142026B
```

### Comprobación automática de instrucciones

Un script Python eliminó comentarios `//` y `/* ... */`, descartó etiquetas y directivas y examinó los mnemónicos. Después analizó ambos desensamblados, rechazó `udiv`, `sdiv`, `bl` y `blr`, y comparó las palabras de código máquina. Resultado real:

```text
Texto: 25 instrucciones; UDIV/SDIV = 0
division-linux.o: 25 instrucciones; UDIV/SDIV/BL/BLR = 0
division-macos.o: 25 instrucciones; UDIV/SDIV/BL/BLR = 0
Codigo maquina ELF/Mach-O: identico (100 bytes)
```

## Reflexión personal del estudiante

1. **¿Qué aprendí sobre dividir sin una instrucción de división?**

   Aprendí que la división entera permite repartir una cantidad en grupos completos y conservar lo que sobra. Esto sirve para la representación binaria, los controles de flujo y la aritmética. Logré ver su funcionamiento en AArch64.

2. **¿Qué diferencia comprendí entre restas sucesivas y división binaria?**

   Estudiando el tema, entendí que la diferencia clave está en su eficiencia: las restas sucesivas funcionan como un bucle que resta el divisor una y otra vez, por lo que tardan más cuanto mayor es el resultado, volviéndose muy lentas para números grandes. En cambio, la división binaria procesa la operación bit por bit mediante desplazamientos, y esto lo hace justamente como lo resuelven las computadoras por dentro.

3. **¿Qué parte del algoritmo me costó más comprender?**

   Los resultados en la prueba de ejecución de ARM64 me hicieron perder bastante la lógica del método de división binaria mediante desplazamientos y restas.

4. **¿Qué afirmación o propuesta de la IA necesité verificar?**

   Necesité verificar los datos de la implementación con el ejemplo en ARM64 y comparé si los resultados que obtuvo eran reales. La información que me dio en la investigación la había investigado anteriormente en otras fuentes y es correcta.

5. **¿Qué utilidad encuentro en estudiar el problema en ensamblador?**

   Encuentro bastantes utilidades, ya que es importante conocer los niveles bajos de programación para poder conectar el hardware con el software. Conocer este nivel es muy importante si queremos hacer proyectos con hardware, porque permite comprender el lenguaje máquina de las computadoras. Enfocándome en la investigación, encuentro utilidad en comparar las restas sucesivas con la división binaria y estudiar una rutina educativa AArch64.

## Cierre de la revisión

El estudiante añadió las cinco respuestas de reflexión y solicitó revisar si el código era obligatorio. Se verificó en la lista del Grupo B que es opcional y se preparó una entrega de dos documentos. Codex corrigió ortografía y puntuación sin añadir experiencias. El estudiante reformuló la respuesta 2 y eliminó la afirmación de rendimiento constante después de recibir una observación técnica.

**Precisión técnica de Codex, separada de la reflexión:** la referencia del estudiante al funcionamiento interno de las computadoras se entiende como una aproximación conceptual. No todos los procesadores implementan exactamente el algoritmo estudiado; la rutina local tiene pasos y saltos dependientes de los operandos, con trabajo acotado por el ancho de palabra.

Tras recibir la reflexión se volvió a consultar main y los PR abiertos, sin encontrar otra entrega del Tema 3 en 2026B. Esta bitácora registra la preparación y validación anteriores al commit; el commit y el PR dejan constancia del flujo de publicación posterior en GitHub.
