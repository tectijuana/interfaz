# Asistencia de Inteligencia Artificial

- **Prompts utilizados**:
  - "De acuerdo a la información sobre este tema 'Aritmética de punto fijo (Q15/Q31) para DSP en microcontroladores ARM' ayudame para que tenga una estructura mas organizada y coherente. También que la información que te doy no sea redundante."

  - Ayudame a entender el tema de forma más clara, ya que hay puntos como MAC y acumuladores y escalado que aún no logro entender bien. 

- **Herramientas utilizadas**:
  - ChatGPT

- **Cambios y validación**:
  - Revisé la definición de los formatos Q15 y Q31 y contrasté los valores utilizados con la documentación oficial de Arm CMSIS-DSP.
  - Se verificó que `q15_t` corresponde a una representación fraccionaria de 16 bits en formato 1.15 y `q31_t` a una representación de 32 bits en formato 1.31.
  - Se contrastó el comportamiento de saturación, los formatos intermedios 2.30 y 2.62 y el uso de acumuladores en filtros FIR con la documentación de CMSIS-DSP.
  - Los ejemplos numéricos de conversión y multiplicación fueron recalculados para comprobar que los desplazamientos de 15 y 31 bits producen nuevamente valores Q15 y Q31.
  - No se realizó todavía una validación sobre hardware ARM real. Por lo tanto, no se presentan resultados de rendimiento o cantidad de ciclos como si hubieran sido medidos experimentalmente.

- **Reflexión personal**:
  La inteligencia artificial me ayudó principalmente a organizar el tema y comprender cómo se relacionan la representación binaria, los desplazamientos, la saturación y los acumuladores con las operaciones DSP. Un punto importante fue entender que utilizar Q31 no significa automáticamente obtener una implementación mejor, ya que aunque proporciona más precisión también requiere mayor memoria y un manejo cuidadoso de los acumuladores para evitar desbordamientos. También comprobé que no es conveniente aceptar directamente los resultados generados por una IA, especialmente cuando se trabaja con detalles de arquitectura o formatos numéricos. Por esa razón, los datos principales fueron comparados con la documentación oficial de Arm y CMSIS-DSP.

- **Fecha**: 2026-09-05

- **Plataforma utilizada**:
  - Investigación documental mediante ChatGPT y documentación oficial de Arm CMSIS-DSP.
  - No se utilizó una plataforma ARM física o emulada para realizar mediciones experimentales en esta etapa.
