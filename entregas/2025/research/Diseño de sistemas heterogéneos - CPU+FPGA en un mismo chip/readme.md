# ⚡ Diseño de Sistemas Heterogéneos: CPU + FPGA en un mismo chip 🖥️🔧

---

## Autor

**Nombre: Kain Alejandro Novelo Astorga** 

**Matricula: 22211623** 

## 🚀 Introducción
En la actualidad, la **computación heterogénea** se ha convertido en un enfoque clave para mejorar el rendimiento, la flexibilidad y la eficiencia energética de los sistemas modernos.  
Un **sistema heterogéneo CPU+FPGA** integra en un mismo chip un procesador tradicional (**CPU**) junto a una **FPGA (Field-Programmable Gate Array)**, combinando lo mejor de dos mundos:

- 🧠 **CPU** → Versátil, buena para tareas generales, control y ejecución secuencial.  
- 🔀 **FPGA** → Reconfigurable, paralelismo masivo, baja latencia y optimización para tareas específicas.  

---

## ⚙️ ¿Qué es un sistema CPU+FPGA?
Un chip **heterogéneo** combina **procesamiento programable (CPU)** y **aceleración configurable (FPGA)**.  
Estos sistemas permiten **reconfigurar el hardware según la aplicación**, algo imposible en arquitecturas puramente CPU o GPU.

📌 Ejemplo de integración:
- CPU maneja el sistema operativo, tareas de control y comunicación.  
- FPGA acelera operaciones críticas como procesamiento de señales, criptografía o inteligencia artificial.  

---

## 🌟 Ventajas principales
✅ **Rendimiento optimizado** → La FPGA acelera cálculos paralelos mientras la CPU maneja la lógica secuencial.  
✅ **Flexibilidad** → La FPGA puede reprogramarse para diferentes aplicaciones sin cambiar el hardware.  
✅ **Eficiencia energética** → Un diseño especializado en FPGA consume menos energía que hacerlo todo en CPU/GPU.  
✅ **Escalabilidad** → Adaptable a entornos desde dispositivos embebidos hasta centros de datos.  

---

## 🔍 Desafíos del diseño CPU+FPGA
⚠️ **Complejidad de programación** → Se requiere manejar tanto software (CPU) como hardware (FPGA).  
⚠️ **Costos de desarrollo** → Las herramientas de síntesis y validación de hardware suelen ser costosas y requieren experiencia.  
⚠️ **Latencia de comunicación** → El intercambio de datos entre CPU y FPGA puede convertirse en un cuello de botella.  
⚠️ **Portabilidad limitada** → Los diseños para una FPGA específica no siempre son fáciles de migrar a otras.  

---

## 🛠️ Herramientas y tecnologías
Algunas plataformas y frameworks usados en sistemas CPU+FPGA:  

- 🔹 **Xilinx Zynq UltraScale+** → SoC que integra ARM Cortex-A53 con FPGA programable.  
- 🔹 **Intel (Altera) SoC FPGA** → Combinación de ARM Cortex-A9 con FPGA de Intel.  
- 🔹 **OpenCL para FPGA** → Permite escribir kernels de aceleración en un lenguaje de alto nivel.  
- 🔹 **Vitis (Xilinx)** → Herramienta de desarrollo unificado para software y hardware.  

---

## 💡 Aplicaciones prácticas
Los sistemas CPU+FPGA se aplican en áreas críticas donde la velocidad y eficiencia son esenciales:

- 🤖 **Inteligencia Artificial** → Aceleración de redes neuronales.  
- 📡 **Telecomunicaciones** → Procesamiento de señales 5G.  
- 🔒 **Ciberseguridad** → Cifrado y descifrado en tiempo real.  
- 🩺 **Medicina** → Análisis de imágenes médicas en alta resolución.  
- 🚗 **Automotriz** → Procesamiento de sensores en vehículos autónomos.  

---

## 📊 Comparación rápida: CPU vs FPGA
| Característica | CPU 🧠 | FPGA 🔀 |
|----------------|--------|---------|
| Flexibilidad   | Alta (software) | Muy alta (reconfigurable) |
| Rendimiento    | Bueno en tareas secuenciales | Excelente en paralelismo |
| Consumo        | Moderado | Bajo en tareas específicas |
| Facilidad de uso | Alta | Media-baja (requiere HDL o HLS) |

---

## 🎯 Conclusión
El diseño de sistemas heterogéneos **CPU+FPGA en un mismo chip** ofrece una combinación poderosa de **versatilidad, rendimiento y eficiencia energética**.  
Aunque presenta **desafíos en programación y desarrollo**, sus aplicaciones en **IA, telecomunicaciones, seguridad y automoción** demuestran que es una tecnología con gran proyección hacia el futuro de la computación.  

🚀 En resumen: ¡la unión de CPU + FPGA es un paso clave hacia la **computación personalizada y de alto rendimiento**! 🔥  

---

## 📚 Referencias
[1] Xilinx, “Zynq UltraScale+ MPSoC Technical Reference Manual,” *Xilinx Documentation*, 2020. [En línea]. Disponible: https://www.xilinx.com.  

[2] Intel, “SoC FPGA Overview,” *Intel Programmable Solutions Group*, 2021. [En línea]. Disponible: https://www.intel.com.  

[3] K. Vipin and S. A. Fahmy, “FPGA Dynamic and Partial Reconfiguration: A Survey of Architectures, Methods, and Applications,” *ACM Computing Surveys*, vol. 51, no. 4, pp. 1–39, 2018.  

[4] H. K. H. So, A. M. Khan, and W. Luk, “Domain-Specific FPGA-Based System-on-Chip for Real-Time Biomedical Applications,” *IEEE Transactions on Very Large Scale Integration (VLSI) Systems*, vol. 24, no. 7, pp. 2371–2381, Jul. 2016.  

[5] P. Sedcole and P. Y. K. Cheung, “Parametric Yield Modeling and Simulations of FPGA Circuits Considering Within-Die Process Variations,” *ACM Transactions on Reconfigurable Technology and Systems*, vol. 1, no. 2, pp. 1–26, 2008.  

[6] S. Mittal, “A Survey of Techniques for FPGA Virtualization,” *ACM Computing Surveys*, vol. 50, no. 6, pp. 1–37, Dec. 2017.  
