### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "¿Qué registros debe preservar una función en el ABI de AArch64 y por qué x19–x28 son callee-saved?"
  - "Explica la diferencia entre `ldr x1, =msg` y `adr x1, msg` en GNU as."

- **Herramientas utilizadas**:
  - ChatGPT
  - Gemini

- **Cambios y validación**:
  - El ejemplo generado usaba `mov x2, longitud` con una etiqueta inválida; lo corregí a `mov x2, #len`.
  - Verifiqué la salida con `make test` en QEMU y después en la instancia Graviton.
  - Confirmé los números de syscall contra la tabla oficial de Linux AArch64, no contra lo que dijo la IA.

- **Reflexión personal**:
  La IA me ayudó a entender la convención de llamadas, pero inventó un número de syscall. Esto reforzó mi hábito de validar contra la documentación oficial y con `strace`.

- **Fecha**: 2026-09-13
- **Plataforma utilizada**: GitHub 
