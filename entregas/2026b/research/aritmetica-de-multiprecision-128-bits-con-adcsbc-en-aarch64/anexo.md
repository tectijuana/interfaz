### Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "Dame informacion sobre el tema de 'Aritmética de multiprecisión (128 bits) con ADC/SBC en AArch64' de preferencia con fuentes de google academico"
  - "Dame mas aplicaciones en donde se utilize"
  - "Explica mejor esta informacion ya que no me quedo muy claro, si puedes usa ejemplos mas sencillos y faciles de entender"
  - "Te paso el documento con la información que tome y resumí, quiero que me ayudes a pasarla a un formato de readme.md también agrega las bibliografías en formato IEEE por favor"

- **Herramientas utilizadas**:
  - Claude (Anthropic) con búsqueda web integrada

- **Cambios y validación**:
  - La IA citó inicialmente varias fuentes irrelevantes (patentes de ADC analógico-digital, papers de conversores de señal) mezcladas con los resultados de arquitectura de procesadores por la ambigüedad del término "ADC"; descarté esas fuentes y me quedé solo con las de AArch64/ensamblador.
  - Verifiqué manualmente la semántica de ADC/SBC (Rd = Rn + Rm + carry) contra el Arm Architecture Reference Manual oficial antes de aceptarla como correcta, no solo contra lo que dijo la IA.
  - Confirmé los datos de autoría del paper académico citado (SIDH on ARM) contra el PDF original del IACR, ya que el resumen inicial de búsqueda no traía los nombres completos de los autores.
  - Revisé que los ejemplos de código ADDS/ADC en pares de registros (X1:X0)/(X3:X2) coincidieran con la convención que ya tenía en mi documento original antes de integrarlos al README.

- **Reflexión personal**:
  La IA fue útil para encontrar fuentes académicas y para explicar el concepto con la analogía de la suma a mano, pero noté que al buscar "ADC" en la web mezclaba resultados de dos campos completamente distintos (arquitectura de procesadores vs. conversores analógico-digitales), así que tuve que revisar con cuidado cuáles fuentes realmente aplicaban a mi tema antes de usarlas en la bibliografía.

- **Fecha**: 2026-09-11
- **Plataforma utilizada**: Claude (interfaz web/app de Claude.ai)
