# Prompts utilizados con LLMs

Para la realización de este trabajo utilicé los siguientes prompts:

---

### [dame un prompt para una investigación de un tema]  
**Prompt sugerido:**  
*"Realiza una investigación completa sobre [TEMA], que incluya los siguientes apartados:  
- Portada con título, autor, institución y fecha.  
- Índice con la organización del documento.  
- Introducción, explicando la importancia del tema y los objetivos de la investigación.  
- Planteamiento del problema: contexto, justificación y relevancia.  
- Marco teórico: definiciones, conceptos clave, antecedentes históricos, teorías o enfoques principales relacionados con el tema.  
- Desarrollo: análisis detallado, aplicaciones prácticas, ejemplos actuales, ventajas y desventajas.  
- Estudio comparativo (si aplica): comparaciones entre distintos enfoques, metodologías o casos de uso.  
- Metodología: explicar cómo se obtuvo la información (revisión bibliográfica, casos prácticos, encuestas, etc.).  
- Resultados y discusión: hallazgos relevantes y su análisis.  
- Conclusiones y recomendaciones: aprendizajes principales, propuestas de mejora, perspectivas a futuro."*  

---

# Resultados obtenidos

**Lenguajes HDL emergentes: Chisel y SpinalHDL**  

**Autor:** Serna Sauceda José Enrique  
**Institución:** Instituto Tecnológico de Tijuana (Campus Tomás Aquino)  
**Fecha:** 17 de septiembre de 2025  

---

## Índice
- Introducción  
- Planteamiento del problema  
- Marco teórico  
- Desarrollo  
  - 4.1. Arquitectura y flujo de herramientas  
  - 4.2. Aplicaciones prácticas y casos actuales  
  - 4.3. Ventajas y desventajas  
- Estudio comparativo: Chisel vs. SpinalHDL  
- Metodología  
- Resultados y discusión  
- Conclusiones y recomendaciones  

---

## 1. Introducción

El diseño digital contemporáneo exige mayor productividad, reutilización y verificabilidad que las ofrecidas por HDL tradicionales (Verilog/VHDL) cuando los sistemas crecen en complejidad (SoC, aceleradores y plataformas RISC-V). En este contexto emergen Chisel y SpinalHDL, lenguajes embebidos en Scala que elevan el nivel de abstracción sin perder control sobre el RTL.  

Esta investigación presenta una visión integral de ambos enfoques: fundamentos, ecosistema, casos reales, ventajas, limitaciones y una comparación práctica para orientar decisiones de adopción en entornos académicos e industriales.  

**Objetivos:**  
- Explicar qué son Chisel y SpinalHDL y por qué surgen.  
- Describir su arquitectura de compilación, ecosistema y flujos de trabajo.  
- Analizar aplicaciones reales y evaluar pros/contras.  
- Desarrollar un estudio comparativo que apoye la selección tecnológica.  
- Formular recomendaciones para cursos, investigación y proyectos de ingeniería.  

---

## 2. Planteamiento del problema

- **Contexto.** La complejidad de los SoC modernos requiere generadores de hardware paramétricos, bibliotecas reutilizables y flujos integrados de verificación. Con HDL clásicos, el cableado repetitivo, la configuración de buses y la variación de parámetros se vuelven costosos y propensos a errores.  

- **Problema.** ¿Qué lenguaje HDL emergente —Chisel o SpinalHDL— ofrece mejor equilibrio entre productividad, portabilidad (emisión a Verilog/VHDL), ecosistema, verificabilidad y curva de aprendizaje para proyectos académicos y prototipos industriales?  

- **Justificación y relevancia.** Entender estas alternativas permite reducir tiempo de desarrollo, mejorar mantenibilidad y acelerar la transferencia tecnológica (del aula al laboratorio/industria) en dominios como RISC-V, IA en el borde y FPGA.  

---

## 3. Marco teórico

- **HDL y RTL.** Un Hardware Description Language especifica hardware a nivel de Transferencia de Registros (RTL).  
- **Lenguajes embebidos (EDSL).** Chisel y SpinalHDL son DSL embebidos en Scala: se escriben programas Scala que construyen grafos de hardware. La salida final es Verilog (y en SpinalHDL también VHDL), compatible con herramientas EDA.  
- **Chisel.** Propone el concepto de construcción de hardware mediante generadores paramétricos y un IR intermedio (FIRRTL). La cadena moderna integra el compilador CIRCT/MLIR para optimizar y emitir Verilog. El ecosistema incluye frameworks como Rocket-Chip/Chipyard, BOOM y bibliotecas de verificación.  
- **SpinalHDL.** También embebido en Scala; enfatiza reducción de boilerplate, tipos expresivos y utilidades listas para uso (streams, buses, registros mapeados). Emite Verilog/VHDL directamente y ha impulsado proyectos como VexRiscv (núcleo RISC-V altamente configurable).  
- **No es HLS.** Ambos lenguajes no son síntesis de alto nivel: el diseñador sigue definiendo RTL explícito; la ganancia está en abstracciones, parámetros y generación.  

---

## 4. Desarrollo

### 4.1. Arquitectura y flujo de herramientas
- **Chisel (Scala → FIRRTL → Verilog):**  
  - El código Scala (Chisel) elabora un grafo RTL → FIRRTL → CIRCT (firtool) → Verilog.  
  - Soporta propiedades de verificación (p. ej., LTL), Probes y Layers en versiones recientes.  
  - Se integra de forma natural con Chipyard (simulación con Verilator, FireSim/FPGA, tape-out con Hammer).  

- **SpinalHDL (Scala → Verilog/VHDL):**  
  - Elabora AST propio y emite Verilog/VHDL sin requerir un IR público.  
  - Proporciona utilidades de alto nivel (Streams, Bundles, AXI, Wishbone, registros mapeados) que reducen el cableado manual.  

- **Herramientas comunes:**  
  - Simulación: Verilator, GHDL, simuladores de proveedor (Xcelium, Questa).  
  - Síntesis/Place&Route: Vivado/Versal, Quartus, Intel/AMD.  
  - Pruebas: ChiselTest/ChiselSim, cocotb, frameworks propios de SpinalHDL.  

---

### 4.2. Aplicaciones prácticas y casos actuales
- **Chisel:** base de Rocket-Chip y Chipyard (SoC RISC-V parametrizables); usado en proyectos académicos e industriales.  
- **SpinalHDL:** VexRiscv (núcleo RISC-V con arquitectura de plugins), SoC ligeros (LiteX), diseños educativos y de comunidad.  

---

### 4.3. Ventajas y desventajas

**Chisel – Ventajas:**  
- Ecosistema maduro con Chipyard/Rocket-Chip y bibliotecas de interconexión.  
- Integración a CIRCT con optimización y nuevas features.  
- Amplio material educativo.  

**Chisel – Desventajas:**  
- Curva de aprendizaje de Scala y del stack (SBT, FIRRTL/CIRCT).  
- Depuración a veces en el nivel Verilog generado.  

**SpinalHDL – Ventajas:**  
- Menos boilerplate; utilidades listas para buses y streams.  
- Emite Verilog/VHDL directamente; fácil adopción.  
- VexRiscv como referencia potente y configurable.  

**SpinalHDL – Desventajas:**  
- Ecosistema académico/industrial menor que Chisel.  
- Menos material formalizado en universidades.  

---

## 5. Estudio comparativo: Chisel vs. SpinalHDL

| Criterio             | Chisel                                               | SpinalHDL                                      |
|----------------------|------------------------------------------------------|------------------------------------------------|
| Paradigma            | EDSL en Scala; generadores; IR FIRRTL → CIRCT/Verilog| EDSL en Scala; AST propio → Verilog/VHDL       |
| Ecosistema           | Rocket-Chip, Chipyard, BOOM, FireSim, Diplomacy      | VexRiscv, plantillas de bus, ejemplos          |
| Interconexión        | Diplomacy + TileLink, soporte AXI via bridges        | Soporte nativo AXI/Wishbone/APB, streams       |
| Verificación         | ChiselTest/ChiselSim, soporte LTL, Verilator         | Testbenches Scala, Verilator, cocotb           |
| Salida               | Verilog (CIRCT/firtool)                              | Verilog y VHDL                                 |
| Curva de aprendizaje | Media-alta                                           | Media                                          |
| Casos emblemáticos   | Rocket-Chip/Chipyard, Edge TPU                       | VexRiscv, SoC LiteX                            |
| Madurez              | Muy alta en academia e industria                     | Alta en comunidad; creciente adopción          |

---

## 6. Metodología
- Revisión bibliográfica de documentación oficial.  
- Análisis de proyectos emblemáticos (Rocket-Chip/Chipyard, VexRiscv).  
- Consulta de notas técnicas, tutoriales y reportes.  
- Fuentes secundarias (blogs técnicos, charlas públicas).  

---

## 7. Resultados y discusión
- **Productividad:** Ambos elevan la productividad frente a HDL clásicos.  
- **Verificabilidad:** Chisel aprovecha CIRCT con nuevas features; SpinalHDL mantiene testbenches efectivos.  
- **Portabilidad:** SpinalHDL genera Verilog/VHDL; Chisel produce Verilog portable.  
- **Ecosistema:** Chisel + Chipyard para investigación avanzada; SpinalHDL + VexRiscv para prototipos rápidos.  
- **Curva de aprendizaje:** SpinalHDL es más directo; Chisel requiere mayor preparación.  

---

## 8. Conclusiones y recomendaciones
- Ambos lenguajes son viables y complementarios.  
- **Cursos universitarios:** iniciar con SpinalHDL y progresar a Chisel.  
- **Proyectos RISC-V:**  
  - Prototipado rápido: SpinalHDL + VexRiscv.  
  - Investigación avanzada: Chisel + Chipyard.  
- **Buenas prácticas:** versionar toolchains, usar pruebas automatizadas, documentar parámetros.  
- **Perspectivas futuras:** integración formal, bibliotecas de IP ampliadas, sinergias con flujos abiertos CIRCT/MLIR.  
