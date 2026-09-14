### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "Realiza una investigacion de este tema: Algoritmos de ordenamiento (burbuja e inserción) en ensamblador ARM64"
  - "¿Cómo implementar el direccionamiento base más desplazamiento escalado (`[Xn, Xm, LSL #2]`) en AArch64 para recorrer arreglos de enteros de 32 bits?"
  - "Escribe un arnés de prueba en C con `extern` para enlazar y verificar funciones de ordenamiento en ensamblador ARM64."

- **Herramientas utilizadas**:
  - Gemini
  - GCC (GNU Compiler Collection para AArch64)

- **Cambios y validación**:
  - La IA inicialmente sugería usar registros completos de 64 bits (`Xn`) para los datos del arreglo; ajusté la lógica para manipular los valores con registros de 32 bits (`Wn`) preservando los registros `X` únicamente para índices y punteros de memoria.
  - Verifiqué que en el algoritmo de inserción el desplazamiento a la izquierda por 2 posiciones (`LSL #2`) calculara exactamente los múltiplos de 4 bytes correspondientes a `sizeof(int)`.
  - Compilé las rutinas con `gcc -O2` y validé la correcta ejecución tanto con arreglos desordenados como con casos límite (arreglos de tamaño 0, 1 y con valores negativos).

- **Reflexión personal**:
  La IA facilitó la estructuración de las bifurcaciones y etiquetas de control de flujo (`B.LE`, `B.GE`), pero requirió atención al detalle en la distinción entre operandos de 32 y 64 bits para evitar accesos desalineados o lecturas corruptas de memoria en el pipeline de ARM64.

- **Fecha**: 2026-09-07
- **Plataforma utilizada**: Linux ARM64 (Ubuntu / entorno de pruebas QEMU AArch64)
