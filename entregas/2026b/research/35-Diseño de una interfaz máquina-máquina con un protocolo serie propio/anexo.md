# Anexo — Bitácora de uso de LLM

## 1. Uso de inteligencia artificial

Para realizar esta investigación sobre el "Diseño de una interfaz máquina-máquina con un protocolo serie propio" se utilizó un modelo de lenguaje (LLM) como herramienta de apoyo para estructurar el trabajo, comprender los conceptos teóricos relacionados con la comunicación serie (UART, framing, detección de errores), obtener referencias bibliográficas y dar formato al documento. 

La inteligencia artificial se utilizó como apoyo durante la mayoria del proceso principalmente para entender los conceptos clave del tema

---
*Herramientas*
*-Claude*
*-Gemini*

## 2. Prompts utilizados

### Prompt 1

> "Necesito desarrollar el siguiente tema para una investigación en la materia de lenguajes de interfaz, acerca de: Diseño de una interfaz máquina-máquina con un protocolo serie propio. Necesito que me sugieras una estructura para la investigación de nivel universitario, y fuentes que pueda consultar para entender el tema"

**Resultado obtenido:**

El LLM propuso una estructura general de investigación (introducción, marco teórico, diseño del protocolo, implementación y pruebas, conclusiones, referencias) y sugirió fuentes de consulta, entre ellas el libro *Serial Port Complete* de Jan Axelson, un artículo de INCIBE-CERT sobre el protocolo serie, un caso aplicado documentado por CIATEQ, y la especificación de Modbus RTU como protocolo de referencia para comparar.

---

### Prompt 2

> "Explícame el tema completo de manera detallada"

**Resultado obtenido:**

El LLM desarrolló una explicación extensa cubriendo qué es una interfaz M2M, la diferencia entre comunicación serie y paralela, el funcionamiento del UART, las estrategias de framing (delimitadores, longitud fija y longitud variable), los mecanismos de detección de errores (paridad, checksum, CRC) y el diseño concreto de una trama con su respectiva máquina de estados, incluyendo un primer ejemplo de código en Python.

---


### Prompt 3

> "Explicame como puedo crear un protocolo de serie m2m paso a paso "

**Resultado obtenido:**

El LLM dio el paso a paso de como crear un protocolo serie propiom, desde los requerimentos a tener encuenta, hasta la implementacion teorica 

---

## 3. Corrección de errores

Durante la revisión del contenido generado por el LLM se identificaron y corrigieron los siguientes puntos:

- **Elección de CRC sobre checksum simple:** se verificó que la recomendación del LLM de usar CRC-16 en lugar de un checksum de suma simple fuera correcta, confirmando que el CRC detecta errores en ráfaga (varios bits consecutivos alterados) que un checksum simple podría no detectar.
- **Formato del documento:** se revisó y corrigió el uso de guiones largos (—) en el texto, reemplazándolos por comas o paréntesis según el contexto, para ajustar la redacción al estilo solicitado.
- **Estructura de las secciones 3.1 y 3.2:** se detectó que la sección de requisitos del sistema quedaba planteada solo como preguntas sin resolver, lo cual no justificaba directamente el diseño de la trama propuesto después; se corrigió respondiendo explícitamente cada pregunta antes de continuar con el diseño.
- **Correccion en algunos conceptos** : se detecto que el LLM daba algunos conceptos con errores de acuerdo a las diversas documentaciones consultada.

---

## 4. Reflexión Personal

El uso del LLM fue útil principalmente para organizar la investigación desde cero: partir de una estructura clara, desarrollar cada sección de forma progresiva y mantener coherencia entre el marco teórico y el diseño propuesto en la sección 3, ya que las decisiones de diseño (campos de la trama, uso de CRC-16, framing por longitud variable) se justificaron explícitamente a partir de lo explicado en el marco teórico.

Una de las ventajas fue poder pedir explicaciones progresivas, primero un panorama general del tema y las fuentes disponibles, después profundizar en cada subtema, y finalmente bajar la teoría a un prototipo de código funcional que permitiera demostrar en la práctica que el diseño propuesto (framing + CRC) efectivamente detecta errores de transmisión.

Por este motivo, fue necesario revisar cada sección generada contra las fuentes citadas, ejecutar y depurar el código propuesto antes de aceptarlo como válido, y decidir de forma consciente qué partes de la investigación mantener (la teoría y el diseño del protocolo) y cuáles dejar fuera del documento final (la implementación detallada), en lugar de aceptar la estructura inicial sin cuestionarla.

En conclusión, el LLM funcionó como una herramienta de apoyo para investigar, estructurar, redactar y depurar código a lo largo de todo el trabajo, pero fue necesario revisar críticamente la información obtenida, probar el código generado y ajustar tanto el contenido como la estructura del documento final según las necesidades reales de la investigación.

---

