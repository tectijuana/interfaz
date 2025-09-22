# SEP TecNM  
## INSTITUTO TECNOLÓGICO DE TIJUANA  
### DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN  
**Ingeniería en Sistemas Computacionales**  
**PORTAFOLIO DE EVIDENCIAS U1**  

---

## Lenguajes HDL emergentes: Chisel y SpinalHDL  

**LENGUAJES DE INTERFAZ SCC-1014**  
**UNIDAD POR EVALUAR: 1**  
**Presenta:** Serna Sauceda José Enrique [#23210667]  
**Docente:** René Solís Reyes  
**Tijuana, B.C. – 18 de septiembre de 2025**  

---

## Introducción  

El diseño digital actual enfrenta limitaciones con HDL tradicionales como Verilog y VHDL, especialmente en sistemas complejos
como SoC y aceleradores. Para atender estas demandas surgen **Chisel** y **SpinalHDL**, lenguajes embebidos en Scala que elevan
el nivel de abstracción sin perder control en el nivel RTL. Esta investigación analiza sus fundamentos, aplicaciones, ventajas
y limitaciones, con el fin de orientar su adopción en ámbitos académicos e industriales.  

---

## Marco teórico  

- **Lenguajes HDL y nivel RTL.** Los HDL permiten describir hardware digital a nivel de transferencia de registros (RTL), 
especificando tanto la lógica combinacional como secuencial.  

- **Lenguajes específicos de dominio embebidos (EDSL).** Tanto Chisel como SpinalHDL son *Embedded Domain-Specific 
Languages* (EDSL) implementados en Scala. Los programas escritos en Scala generan grafos de hardware que posteriormente
se traducen a HDL convencionales (Verilog o VHDL), asegurando compatibilidad con las herramientas de automatización de diseño electrónico (EDA).  

- **Chisel.** Introduce el concepto de generadores de hardware paramétricos, que permiten crear bloques reutilizables y altamente
configurables. Su flujo de trabajo incluye un lenguaje intermedio denominado **FIRRTL** (*Flexible Intermediate Representation for RTL*),
actualmente integrado en el proyecto **CIRCT/MLIR**, lo que facilita optimizaciones avanzadas. Ha sido clave en proyectos como *Rocket-Chip*, *BOOM* y *Chipyard*.  

- **SpinalHDL.** También embebido en Scala, busca reducir el *boilerplate* (código repetitivo), ofrecer tipos más expresivos
y proporcionar utilidades listas para usar, como buses de comunicación estándar (AXI, Wishbone) y estructuras de datos (streams, registros mapeados).
Su proyecto más emblemático es **VexRiscv**, un núcleo RISC-V altamente configurable.  

- **No son herramientas de síntesis de alto nivel (HLS).** A diferencia de enfoques como *C-to-HDL*, Chisel y SpinalHDL no abstraen
el RTL hacia un nivel algorítmico, sino que mantienen el control detallado del hardware, ofreciendo ventajas en parametrización y generación automática.  

---

## 4. Desarrollo  

### 4.1. Arquitectura y flujo de herramientas  

- **Chisel (Scala → FIRRTL → Verilog):**  
  El código en Scala se traduce a FIRRTL, el cual es optimizado por CIRCT antes de emitir Verilog. Ofrece soporte para verificación 
formal y simulación mediante entornos como *Chipyard*.  

- **SpinalHDL (Scala → Verilog/VHDL):**  
  Utiliza un AST propio y emite directamente Verilog o VHDL, sin necesidad de un IR intermedio. Destaca por sus librerías preconstruidas
para buses y flujos de datos, lo que reduce el trabajo manual.  

- **Herramientas comunes:**  
  Simulación (*Verilator, GHDL*), síntesis y *Place & Route* (*Vivado, Quartus*), y entornos de verificación (*cocotb, 
frameworks propios de Chisel/SpinalHDL*).  

---

### 4.2. Aplicaciones prácticas y casos actuales  

- **Chisel:** Base de *Chipyard* y *Rocket-Chip*, ampliamente usado en investigación académica e industrial.  
- **SpinalHDL:** Utilizado en *VexRiscv* y proyectos comunitarios como *LiteX*, con fuerte presencia en entornos educativos.  

---

### 4.3. Ventajas y desventajas  

**Chisel – Ventajas:**  
- Ecosistema robusto con soporte académico e industrial.  
- Integración con CIRCT y optimización avanzada.  
- Documentación extensa y material educativo consolidado.  

**Chisel – Desventajas:**  
- Curva de aprendizaje elevada debido a Scala y su *toolchain*.  
- Depuración a menudo realizada sobre el Verilog generado.  

**SpinalHDL – Ventajas:**  
- Menor cantidad de código repetitivo.  
- Emisión directa a Verilog y VHDL.  
- Amplias utilidades listas para uso inmediato.  

**SpinalHDL – Desventajas:**  
- Ecosistema académico e industrial menos consolidado.  
- Menor cantidad de material educativo formal.  

---

## 5. Estudio comparativo: Chisel vs. SpinalHDL  

| **Criterio**         | **Chisel**                                      | **SpinalHDL**                                  |
|----------------------|-------------------------------------------------|------------------------------------------------|
| Paradigma            | EDSL en Scala; IR FIRRTL → CIRCT/Verilog        | EDSL en Scala; AST propio → Verilog/VHDL       |
| Ecosistema           | Rocket-Chip, Chipyard, BOOM, FireSim            | VexRiscv, plantillas de bus, LiteX             |
| Interconexión        | Diplomacy + TileLink; soporte AXI vía *bridges* | Soporte nativo AXI/Wishbone/APB, *streams*     |
| Verificación         | ChiselTest, Verilator, soporte LTL              | Testbenches Scala, Verilator, cocotb           |
| Salida               | Verilog                                         | Verilog y VHDL                                 |
| Curva de aprendizaje | Media-alta                                      | Media                                          |
| Casos emblemáticos   | Rocket-Chip/Chipyard, Edge TPU                  | VexRiscv, SoC LiteX                            |
| Madurez              | Alta en academia e industria                    | Creciente en comunidad                         |  

---

## Conclusión  

El análisis comparativo de Chisel y SpinalHDL permitió comprender que ambos lenguajes representan un avance significativo
frente a los HDL clásicos al mejorar la productividad, la reutilización y la verificabilidad en el diseño digital. 
El proceso de investigación mostró que Chisel ofrece un ecosistema más maduro para proyectos de investigación avanzada, 
mientras que SpinalHDL destaca por su simplicidad y rapidez en el prototipado. De esta manera, se aprendió que la elección 
entre uno u otro no debe entenderse como excluyente, sino como una decisión estratégica según el contexto: en la docencia conviene 
introducir SpinalHDL para facilitar el aprendizaje inicial, mientras que en proyectos complejos resulta más ventajoso implementar Chisel. 
Esta reflexión evidencia la importancia de evaluar no solo las características técnicas, sino también el impacto pedagógico y 
práctico que tiene cada herramienta en la formación y en la industria.  




