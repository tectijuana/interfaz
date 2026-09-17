# Anexo — Bitácora de uso de LLM

**Tema:** Reloj de Tiempo Real (RTC): Mantenimiento de fecha y hora en sistemas embebidos (para la materia Lenguajes de Interfaz)  
**Autor:** Urrea Ramírez, Juan Pablo  

## Herramienta utilizada
* **Nombre:** Gemini (Google)

---

## Prompts utilizados y resultados obtenidos

### Prompt 1
> **Prompt real:** "Mi tema de investigacion es Reloj de Tiempo Real (RTC) Mantenimiento de fecha y hora en embebidos para la materia Leguajes de interfaz en ing en sistemas computacionales, ves esta una buena fuente¿ [enlace a TME]" y "[enlace a How2Electronics] ves esta una buena segunda fuente_"

* **Resultado obtenido:** La IA evaluó las páginas web proporcionadas, confirmando su validez para el marco teórico y práctico. Desglosó los puntos fuertes de cada una (arquitectura básica, uso del cristal de 32,768 kHz, protocolo I²C e implementación práctica con el PCF8563 y Arduino).
* **¿Lo usé tal cual o lo modifiqué?:** Utilicé la retroalimentación de la IA para justificar la elección de mis fuentes y para decidir cómo estructurar el marco teórico (usando TME para la teoría y How2Electronics para la práctica).

### Prompt 2
> **Prompt real:** Serie de prompts de traducción técnica, por ejemplo: "The real-time clock module is based on the NXP PCF8563T... traduccion", y peticiones de formato como: "convertir a formato github [imagen de tabla de componentes]".

* **Resultado obtenido:** La IA proporcionó traducciones adaptadas al español técnico de ingeniería (utilizando términos correctos como *chipset*, *protoboard*, *pines* y *librería*), y convirtió una imagen con la lista de materiales en una tabla con formato Markdown lista para GitHub.
* **¿Lo usé tal cual o lo modifiqué?:** Las tablas en Markdown las utilicé tal cual en mi documentación. Las traducciones las integré, pulí y uní dentro del desarrollo práctico de mi investigación.

---

## Reflexión crítica

* **¿La IA ayudó de verdad?** Sí, funcionó como un excelente asistente de validación, traductor técnico y generador de formato (Markdown). Me ahorró tiempo al estructurar tablas y al asegurar que los conceptos en inglés no perdieran su rigor técnico al pasarlos al español.
* **¿Hubo errores, imprecisiones o sesgos?** No, la IA respetó el contexto de ingeniería en sistemas y mantuvo el rigor técnico en las explicaciones del bus I²C y los componentes de hardware.
* **¿Qué verifiqué por mi cuenta?** Yo mismo busqué y seleccioné previamente los enlaces y las imágenes; mi labor fue verificar que el código original y las conexiones del Arduino con el módulo PCF8563 tuvieran sentido lógico antes de pedirle a la IA que me ayudara a documentarlas.
* **¿Qué parte es mía y cuál partió de la IA?** La búsqueda de información, la elección del enfoque (RTC y PCF8563) y la estructura del proyecto son mías. La IA aportó la adaptación del texto al español, el formato de las tablas y sugerencias de redacción para unir las ideas en la conclusión.

---

## Declaración
Confirmo que este anexo refleja el uso real que hice de herramientas de IA durante esta investigación, y que el análisis, la selección de fuentes y la redacción final del documento son producto de mi propio entendimiento del tema.
