# Verilog

**Verilog** es una combinación de las palabras *"verificación"* y *"lógica"*, estandarizado como **IEEE 1364**, es un **lenguaje de descripción de hardware (HDL)** utilizado para modelar sistemas electrónicos.  

Se utiliza con mayor frecuencia en el diseño y la verificación de **circuitos digitales**, con el mayor nivel de abstracción en el **nivel de transferencia de registros (RTL)**. También se utiliza en la verificación de circuitos analógicos y de señal mixta, así como en el diseño de **circuitos genéticos**.

Los **lenguajes descriptivos de hardware** permiten diseñar, en forma abstracta, complejos sistemas digitales que luego de ser simulados podrán ser implementados en dispositivos programables como **FPGA** (arrays de puertas programables por el campo) o **CPLD** (dispositivos lógicos programables complejos). Esto se logra describiendo el sistema digital mediante código HDL.

Verilog es uno de los estándares HDL disponibles en la industria para el diseño de hardware. Este lenguaje nos permite la descripción del diseño a diferentes niveles, denominados **niveles de abstracción**, tales como:

- **Nivel de puerta**  
- **Nivel de transferencia de registro o nivel RTL**  
- **Nivel de comportamiento (Behavioral level)**  

---

## Jerarquía de módulos

Un **diseño Verilog** consta de una **jerarquía de módulos**.  
Los módulos encapsulan la jerarquía del diseño y se comunican entre sí mediante un conjunto de puertos de **entrada, salida y bidireccionales** declarados.

Internamente, un módulo puede contener cualquier combinación de lo siguiente:

- Declaraciones de red/variable (`wire`, `reg`, `integer`, etc.)  
- Bloques de instrucciones **concurrentes** y **secuenciales**  
- Instancias de otros módulos (subjerarquías)  

Las instrucciones secuenciales se colocan dentro de un bloque `begin/end` y se ejecutan en orden secuencial dentro del bloque. Sin embargo, los propios bloques se ejecutan concurrentemente, lo que convierte a **Verilog en un lenguaje de flujo de datos**.

---

## Objetivos de Verilog

- **Diseño de hardware**: Construye sistemas electrónicos con especificaciones lógicas y temporales.  
- **Simulación**: Permite evaluar sistemas electrónicos antes de su implementación.  
- **Síntesis**: Puede transformar algorítmicamente el código fuente en una descripción lógicamente equivalente que conste únicamente de primitivas lógicas elementales (*AND, OR, NOT, biestables*, etc.).  

---

## Conclusión

**Verilog** es una potente herramienta de diseño estandarizado para sistemas electrónicos complejos que permite su **simulación** y **síntesis**.

---

## Bibliografía

[1] L. Silva, "Uso de Verilog," Universidad Técnica Federico Santa María, [PDF]. [Online]. Available: http://ramos.elo.utfsm.cl/~elo212/docs/lsilva-ap5.pdf. [Accessed: Sep. 18, 2025].

[2] Contributors to Wikimedia projects, "Verilog," Wikipedia, Aug. 27, 2025. [Online]. Available: https://en-m-wikipedia-org.translate.goog/wiki/Verilog?_x_tr_sl=en&_x_tr_tl=es&_x_tr_hl=es&_x_tr_pto=tc. [Accessed: Sep. 18, 2025].

[3] "Tutorial Verilog," [Online]. Available: https://marceluda.github.io/rp_dummy/EEOF2018/Verilog_Tutorial_v1.pdf. [Accessed: Sep. 18, 2025].
 
