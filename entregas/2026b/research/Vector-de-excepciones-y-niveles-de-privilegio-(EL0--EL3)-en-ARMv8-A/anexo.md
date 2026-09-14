# Asistencia de Inteligencia Artificial

* Prompts utilizados:
   * "Explica los Exception Levels de ARMv8-A (EL0-EL3) y en qué se diferencian de los estados Secure/Non-secure de TrustZone."
   * "¿Cómo está organizada la tabla de vectores de excepción en AArch64? Detalla los 4 grupos de 4 entradas y sus offsets dentro de los 0x800 bytes."
   * "¿Qué diferencia hay entre VBAR_EL1, VBAR_EL2 y VBAR_EL3, y por qué EL0 no tiene su propia tabla de vectores?"

* Herramientas utilizadas:
   * Claude
   * ChatGPT

* Cambios y validación:
   * La IA sugirió inicialmente que EL0 cuenta con su propio registro `VBAR_EL0`; corregí el texto porque EL0 no tiene tabla de vectores propia, sino que toda excepción originada ahí se maneja en el `VBAR_ELx` del nivel al que se sube.
   * Verifiqué los offsets y el tamaño de la tabla de vectores (16 entradas de 0x80 bytes = 0x800 bytes totales, agrupadas en 4 bloques de 4) contra el *Arm Architecture Reference Manual* (ARM DDI 0487) en lugar de dejarlos tal como los redactó la IA.
   * Confirmé la lista completa de registros por nivel (`ELR_ELx`, `SPSR_ELx`, `ESR_ELx`, `FAR_ELx`, `VBAR_ELx`, `HCR_EL2`, `SCR_EL3`) y sus nombres exactos contra la documentación oficial de Arm Developer ("Learn the architecture: AArch64 exception model"), corrigiendo un par de nombres que la IA había abreviado de forma incorrecta.

* Reflexión personal: La IA fue útil para organizar la jerarquía de niveles de privilegio y el ciclo de vida de una excepción de manera didáctica, pero en más de una ocasión generalizó detalles (como la existencia de una tabla de vectores en EL0) que no son correctos según el manual de arquitectura. Esto reforzó la importancia de contrastar cada afirmación técnica —especialmente registros, offsets y reglas de transición entre niveles— contra las fuentes oficiales de Arm antes de darlas por válidas.

* Fecha: 2026-09-12
* Plataforma utilizada: Documentación oficial de Arm Developer y Arm Architecture Reference Manual (ARM DDI 0487) como referencia de verificación
