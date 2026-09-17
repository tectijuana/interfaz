# Anexo — Bitácora de uso de LLM

**Tema:** Perfilado de consumo energético: rutinas en ensamblador frente a C (para la materia Lenguajes de Interfaz)  
**Autor:** Urrea Ramírez, Juan Pablo  

## Herramienta utilizada
* **Nombre:** Claude (Anthropic)

---

## Prompts utilizados y resultados obtenidos

### Prompt 1
> **Prompt real:** "Necesito entender por qué el ensamblador consumiría menos energía que C en un microcontrolador. ¿Cuál es el modelo teórico que explica el consumo de potencia a nivel de instrucción?"

* **Resultado obtenido:** La IA explicó el modelo de Tiwari, Malik y Wolfe (costo base por instrucción más costo de transición entre instrucciones), y la relación entre potencia dinámica, factor de conmutación y frecuencia en circuitos CMOS. Señaló que la energía total depende del número de ciclos, y que por eso el conteo de ciclos predice mejor el consumo.
* **¿Lo usé tal cual o lo modifiqué?:** Usé el modelo y las fórmulas como base teórica de la sección de fundamentos.

### Prompt 2
> **Prompt real:** "Dame un ejemplo de una rutina simple (suma de un arreglo) escrita en C y su equivalente en ensamblador

* **Resultado obtenido:** La IA generó el código en C y su versión en ensamblador, indicando qué registros usa la ABI de `avr-gcc` para pasar argumentos y retornar valores, y anotó el número de ciclos por instrucción según el manual del ISA de AVR.
* **¿Lo usé tal cual o lo modifiqué?:** El código en C lo usé tal cual porque es estándar. El código en ensamblador lo revisé instrucción por instrucción contra el manual de AVR para confirmar los ciclos indicados.

### Prompt 3
> **Prompt real:** "¿Cómo puedo medir de forma práctica el consumo de energía de estas dos rutinas en un Arduino UNO real, sin equipo de laboratorio sofisticado?"

* **Resultado obtenido:** La IA propuso un método híbrido: verificar el número de ciclos por desensamblado y, en paralelo, medir la corriente real con una resistencia de derivación.
* **¿Lo usé tal cual o lo modifiqué?:** Adopté el método, pero como no realicé la medición física en hardware real, dejé explícito en el documento que los valores de corriente y energía reportados son estimaciones de referencia a partir de datos típicos.

---

## Reflexión crítica

* **¿La IA ayudó de verdad?** Sí. Funcionó como apoyo para entender el modelo teórico de consumo energético a nivel de instrucción, para generar un par de rutinas comparables (C y ensamblador).
* **¿Hubo errores, imprecisiones o sesgos?** Un punto que tuve que corregir: la primera versión de los resultados presentaba cifras de energía (µJ) con apariencia de datos medidos, cuando en realidad eran estimaciones calculadas a partir de una corriente típica de datasheet. Fue necesario dejar esa distinción clara para no hacer pasar una estimación por un resultado experimental real.
* **¿Qué verifiqué por mi cuenta?** Verifiqué el conteo de ciclos de cada instrucción AVR contra el manual oficial del ISA.
* **¿Qué parte es mía y cuál partió de la IA?** La definición del caso de estudio, la decisión de comparar niveles de optimización del compilador (`-O0`, `-Os`, `-O2`) frente al ensamblador manual, y la verificación técnica de ciclos y ABI son mías. La IA aportó la explicación inicial del modelo teórico, el código base y la propuesta de metodología de medición.

---

## Declaración
Confirmo que este anexo refleja el uso real que hice de herramientas de IA durante esta investigación, y que el análisis, la verificación técnica y la redacción final del documento son producto de mi propio entendimiento del tema.
