---

### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "¿Cuáles son los apuntadores clave para el manejo de la pila en AArch64?"
  - "Proporciona un ejemplo de prólogo y epílogo en ensamblador ARM64 utilizando stp y ldp."
  - "¿Cómo citar en formato APA el artículo de Val Samaras sobre ARM64?"

- **Herramientas utilizadas**:
  - Gemini

- **Cambios y validación**:
  - Validé la nomenclatura de los registros (`SP`, `x29`/`FP`, `x30`/`LR`) y el requerimiento de alineación de 16 bytes consultando la documentación técnica de AArch64 y las referencias citadas.
  - Verifiqué que la sintaxis de las instrucciones `stp` y `ldp` fuera coherente con el estándar AAPCS64.

- **Reflexión personal**:
  La IA me ayudó a resumir y estructurar la explicación sobre el flujo de creación y destrucción de marcos de pila, lo que me permitió comprender claramente cómo se conecta el registro de enlace `x30` con el retorno de funciones sin depender de instrucciones implícitas como `push` o `pop`, pero no sentí que dependiera totalmente de la IA, la utilicé como una herramienta pero procuré verificar bien antes de poner las cosas.

- **Fecha**: 2026-09-05
- **Plataforma utilizada**: GitHub 
