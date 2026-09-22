## 1. Registro de Interacciones y Prompts Reales

### Sesión 1: Conceptos de arquitectura y matemáticas lógicas
* **Prompt ingresado:**  
  > "Actúa como un arquitecto de software de bajo nivel. Explica de forma rigurosa cómo procesa una ALU ARM la aritmética de complemento a dos. Detalla la diferencia técnica y matemática entre la bandera Carry (C) y la bandera oVerflow (V) dentro del registro APSR (NZCV). Usa ejemplos con valores hexadecimales de 32 bits donde ocurra un desbordamiento para ilustrar la compuerta XOR entre los acarreos del bit más significativo. Evita explicaciones superficiales."
* **Resultados obtenidos:**  
  El modelo proporcionó la fórmula matemática de la compuerta XOR ($C_{in\_MSB} \oplus C_{out\_MSB}$) que utiliza el silicio de la ALU para detectar desbordamientos con signo. También generó los dos escenarios lógicos donde falla el complemento a dos (positivo + positivo = negativo, y viceversa) con valores hexadecimales claros.

### Sesión 2: Código ensamblador condicional
* **Prompt ingresado:**  
  > "Genera un pequeño fragmento de código en ensamblador AArch64 puro que fuerce un desbordamiento aritmético de complemento a dos utilizando la instrucción ADDS en registros W de 32 bits. Incluye el manejo del flujo condicional utilizando la instrucción BVS (Branch if oVerflow Set). Documenta cada línea del código con comentarios precisos sobre qué banderas NZCV se ven afectadas."
* **Resultados obtenidos:**  
  El LLM entregó un bloque de código estructurado en AArch64, cargando el límite positivo (`0x7FFFFFFF`) y sumándole `1`. Los comentarios resultaron ser correctos respecto a la instrucción condicional necesaria para gestionar la falla aritmética.

---

## 2. Reflexión Crítica

* **¿Ayudó el LLM?**  
  Fue fundamental para articular de manera clara la diferencia sutil pero crítica entre el *Carry* (para aritmética sin signo) y el *Overflow* (para aritmética con signo). Traducir el diseño lógico del hardware a texto a veces es complicado, y el LLM entregó analogías y ecuaciones precisas.

* **¿Hubo sesgos o errores detectados?**  
  Sí, al momento de analizar la rutina de ensamblador sugerida, me di cuenta de que requería un procesador nativo ARM. Para poder compilar y validar que los registros NZCV realmente se actualizaban como dictaba la teoría, tuve que adaptar mi entorno de trabajo. Dado que mi computadora es una laptop con procesador Intel Core i7, el código AArch64 no se podía ejecutar directamente. Tuve que descargar e implementar un compilador cruzado (`aarch64-linux-gnu-gcc`) y usar QEMU para emular la arquitectura ARM en mi procesador x86_64, permitiéndome observar paso a paso los volcados de memoria y el estado virtualizado del registro APSR para asegurar que la información generada por la IA fuera verídica.
