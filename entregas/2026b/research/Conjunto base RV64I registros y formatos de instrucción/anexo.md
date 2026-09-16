### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "¿Cómo está estructurado el archivo de registros de propósito general en la arquitectura base RV64I y cuál es la convención ABI (Application Binary Interface) para cada registro?"
  - "¿Por qué el registro x0 está cableado a cero por hardware y cómo se aprovecha esto para simplificar el conjunto de instrucciones (por ejemplo, pseudo-instrucciones como MOV)?"
  - "¿Cuáles son los 6 formatos principales de instrucción (R, I, S, B, U, J) en RV64I y cómo distribuyen los campos dentro de los 32 bits?"
  - "¿Por qué la organización de los bits de valor inmediato en los formatos de salto (B y J) parece desordenada?"

- **Herramientas utilizadas**:
  - Gemini

- **Cambios y validación**:
  - Validé la lista de registros callee-saved y temporales contrastando la respuesta de la IA con la tabla de convenciones de llamadas oficial del manual de RISC-V.
  - Eliminé explicaciones excesivamente largas sobre arquitecturas externas (como ARM o x86) que la IA incluyó al principio para comparar, manteniendo el enfoque estrictamente en RV64I.

- **Reflexión personal**:
  En temas de arquitectura de computadoras, la IA tiende a simplificar el porqué de ciertas decisiones de diseño (como el desorden de los bits en los saltos). Esto me enseñó a utilizar el *Instruction Set Manual* oficial como árbitro final, especialmente al validar la distribución exacta de los campos de bits, ya que el más mínimo error invalida la decodificación.

- **Fecha de asistencia de la IA**: del 11-09-2026 al 12-09-2026
- **Plataforma utilizada:** GitHub
