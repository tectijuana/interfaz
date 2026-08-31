---
title: "Proyecto de Investigación --- Lenguajes de Interfaz 2026 \"B\" --- Grupo B (17:00)"
subtitle: "Lista complementaria: 41 temas de investigación y rúbrica de 5 categorías"
author: "TecNM Campus Tijuana --- Ingeniería en Sistemas Computacionales (SCC-1014)"
date: "Agosto 2026"
lang: es
geometry: "a4paper,margin=2.4cm"
fontsize: 11pt
---

# Presentación

Esta es la **lista complementaria del Grupo B (17:00 h)** del curso Lenguajes de
Interfaz 2026 "B". Cada estudiante desarrollará **una investigación técnica
individual**, la publicará mediante el flujo **Fork --- Pull Request** y
documentará el uso de asistentes de IA (LLM).

Los 41 temas de esta lista fueron **revisados para no duplicarse ni chocar** con:

- `entregas/2025/research/` (~40 investigaciones históricas),
- `entregas/2026a/research/` (semestre anterior, ~70 carpetas), y
- `TEMAS-INVESTIGACION-2026B.md` (lista principal del semestre, 40 temas).

Todos los temas de este documento son **distintos** de los tres conjuntos
anteriores. No se admiten temas repetidos ni variantes menores de un tema ya
trabajado; el docente asigna o confirma el tema por Google Classroom.

## Entrega esperada

Carpeta personal dentro de `entregas/2026b/research/<nombre-del-tema>/` con:

- **`README.md`** --- título, introducción, desarrollo técnico (mínimo 500
  palabras), conclusiones y bibliografía en formato **IEEE**.
- **`anexo.md`** --- bitácora de uso de LLM: prompts reales, resultados obtenidos
  y reflexión crítica (¿ayudó?, ¿hubo sesgos o errores?). Obligatorio si se usó IA.
- *(Opcional)* código, diagramas, esquemas y PDF de papers de referencia.

## Reglas del flujo Fork --- Pull Request

- No cambiar la ruta indicada ni renombrar `README.md`.
- No modificar archivos ajenos ni el `README.md` de otras carpetas.
- Un Pull Request por estudiante, con commits claros y descriptivos.
- El PR que altere la estructura del repositorio se **rechaza** sin calificación.

\newpage

# Los 41 temas --- Grupo B (2026 "B")

## Representación de datos y aritmética a bajo nivel

1. Complemento a dos y detección de desbordamiento con las banderas NZCV en ARM
2. Aritmética de multiprecisión (128 bits) con `ADC`/`SBC` en AArch64
3. División entera y módulo sin instrucción de división: algoritmos en ensamblador
4. Conversión de bases y formateo de números a cadena en ensamblador
5. Operaciones de campos de bits con `BFI`, `UBFX` y `SBFX` en ARM64
6. Aritmética de punto fijo (Q15/Q31) para DSP en microcontroladores ARM
7. Tablas de búsqueda (LUT) frente a cálculo directo: compromiso memoria--tiempo

## Control de flujo y estructuras de datos

8. Sentencias `switch/case` mediante tablas de saltos en ARM64
9. Recursión en ensamblador: factorial y Fibonacci con manejo explícito de pila
10. Arreglos multidimensionales: cálculo de índices y recorrido en ensamblador
11. Estructuras (`struct`): desplazamientos de campo y empaquetado en ASM
12. Paso de estructuras grandes por referencia según AAPCS64

## Cadenas y algoritmos clásicos

13. Algoritmos de ordenamiento (burbuja e inserción) en ensamblador ARM64
14. Búsqueda binaria iterativa en ensamblador
15. Manipulación de texto UTF-8 a nivel de bytes
16. Cálculo de CRC-16 y CRC-32 en ensamblador para tramas de comunicación
17. Funciones hash sencillas (djb2, FNV-1a) implementadas en ASM

## Optimización y microarquitectura

18. Desenrollado de bucles (*loop unrolling*) manual y su efecto en el rendimiento
19. Predicción de saltos y su impacto en el código ensamblador de ARM
20. Instrucciones de precarga (`PRFM`) para ocultar la latencia de memoria
21. Conteo de ciclos con el contador de la PMU (`PMCCNTR`) en AArch64
22. Efecto de la caché L1/L2: recorrido de matrices por filas frente a columnas
23. Comparación del código generado por GCC con `-O0`, `-O2` y `-Os` para ARM

## Interfaces serie y buses

24. Configuración de un UART a nivel de registros: *baud rate*, trama y paridad
25. Búfer circular (*ring buffer*) para recepción serie por interrupción
26. Protocolo Modbus RTU sobre RS-485 en sistemas embebidos
27. Bus SPI en modo esclavo: temporización, doble búfer y manejo de `CS`
28. Interfaz paralela tipo 8080/6800 para controladores de LCD
29. Protocolo I2S para audio digital en microcontroladores ARM

## Entrada/salida y periféricos

30. GPIO *bare-metal* en RP2350: registros SIO, PADS e IO_BANK0
31. Generación de tonos y melodías con PWM en un zumbador piezoeléctrico
32. Lectura de *encoders* rotativos en cuadratura por interrupción
33. Control de motores paso a paso: secuencias de fase y *microstepping*
34. Multiplexación de displays de 7 segmentos y persistencia visual
35. Matriz de LEDs y técnica de barrido (*Charlieplexing*)

## Temporización, relojes y energía

36. *Watchdog timer*: configuración y recuperación ante bloqueos
37. Modos de bajo consumo (*sleep*/*stop*/*standby*) en Cortex-M
38. Reloj de tiempo real (RTC): mantenimiento de fecha y hora en embebidos
39. `SysTick` como base de tiempo para un planificador cooperativo

## Depuración y observabilidad

40. *Semihosting* de ARM para E/S durante la depuración sin periféricos
41. Trazado en tiempo real con SWO/ITM en Cortex-M

\newpage

# Rúbrica de evaluación --- 5 categorías (100 puntos)

| # | Categoría | Pts | Qué se evalúa |
|:-:|:----------|:---:|:--------------|
| 1 | **Rigor técnico y profundidad** | 30 | Comprensión correcta y profunda del tema; exactitud de los conceptos; fuentes actualizadas y pertinentes; desarrollo técnico de al menos 500 palabras con datos, comparativas o ejemplos verificables. |
| 2 | **Estructura y claridad del `README.md`** | 20 | Uso correcto de Markdown; organización lógica (introducción, desarrollo, conclusiones); redacción profesional y ortografía sin faltas graves. |
| 3 | **Originalidad y análisis crítico** | 20 | Síntesis y redacción propias; el texto no es una copia de la salida de un LLM; hay interpretación, comparación y postura argumentada del estudiante. |
| 4 | **Uso del repositorio y flujo Fork --- Pull Request** | 15 | Ruta y nombre de carpeta correctos; `README.md` sin renombrar; no se tocan archivos ajenos; commits claros; un solo PR bien descrito. |
| 5 | **Bitácora de IA (`anexo.md`) y bibliografía IEEE** | 15 | `anexo.md` con prompts reales, resultados y reflexión honesta sobre el uso de IA; bibliografía con fuentes confiables (IEEE, libros, papers, sitios oficiales) y formato IEEE correcto. |

## Escala de desempeño por categoría

| Nivel | Porcentaje de la categoría | Descripción |
|:------|:--------------------------:|:------------|
| Excelente | 90--100 % | Cumple todos los criterios con evidencia sólida y sin observaciones. |
| Satisfactorio | 75--89 % | Cumple lo esencial con observaciones menores. |
| Suficiente | 60--74 % | Cumple parcialmente; faltan elementos o hay imprecisiones. |
| Insuficiente | 0--59 % | No cumple el criterio mínimo o hay copia sin análisis. |

## Penalizaciones

- **Tema duplicado** (ya existe en `2025/research/`, `2026a/research/` o en la
  lista principal `TEMAS-INVESTIGACION-2026B.md`): se devuelve el PR sin calificar
  hasta reasignar tema.
- **Alteración de la estructura del repositorio** o de archivos ajenos: PR
  rechazado (categoría 4 en 0).
- **Uso de IA no declarado** detectado: categorías 3 y 5 en 0 y reporte de
  integridad académica según `AI_GUIDANCE.md`.
- **Entrega tardía**: según `POLICIES.md`.

---

*Documento complementario para el curso Lenguajes de Interfaz (SCC-1014), semestre
2026 "B", Grupo B (17:00 h). Lista principal: `TEMAS-INVESTIGACION-2026B.md`.
Referencias del curso: `SYLLABUS.md`, `GRADING.md`, `AI_GUIDANCE.md`.*
