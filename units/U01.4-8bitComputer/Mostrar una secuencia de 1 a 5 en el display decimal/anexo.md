### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "¿Cuáles serían los pasos de manera detallada para 'Mostrar una secuencia de 1 a 5 en el display decimal' en 8 bit assembly de Troy Breadboard Computer?"

- **Herramientas utilizadas**:
  - ChatGPT (GPT-5, asistente especializado en Troy’s Breadboard Computer)

- **Cambios y validación**:
  - La IA propuso una rutina básica con `inc Rd`, comparación contra un límite (`Rb = 6`) y un bucle de retardo con `dec Rc`.
  - Validé en el emulador de Troy’s Breadboard Computer que los valores `1 → 5` aparecen en el display decimal, con el retardo perceptible.
  - Confirmé que el retardo es necesario; sin él, el display cambia demasiado rápido y parece que no muestra nada.

- **Reflexión personal**:
  La explicación paso a paso me ayudó a comprender cómo el registro `Rd` está directamente ligado al display decimal. Además, el uso de un retardo artificial me hizo reflexionar sobre la diferencia entre la velocidad del procesador y la percepción humana. Aprendí que un programa sencillo puede volverse más didáctico si se controla la temporización. También reforcé mi comprensión de instrucciones clave como `cmp`, `jnz` y `hlt`.

- **Fecha**: 2025-09-22  
- **Plataforma objetivo**: Troy’s Breadboard Computer – 8-bit CPU educativa  
- **Evidencia de prueba**: captura del emulador mostrando la secuencia `1 → 2 → 3 → 4 → 5` en el display decimal
