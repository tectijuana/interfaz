# ARM y Arquitecturas Orientadas a Inteligencia Artificial

**Autor:** *Mendoza Moreno Isaac Paul*  

**Materia:** *Lenguajes de Interfaz*  

**Última actualización:** 21 de Mayo 2026

---

## Tabla de contenidos

1. [Introducción](#1-introducción)  
2. [¿Qué es ARM y cómo funciona su modelo de negocio?](#2-qué-es-arm-y-cómo-funciona-su-modelo-de-negocio)  
3. [De ARMv8 a ARMv9: la arquitectura se adapta a la IA](#3-de-armv8-a-armv9-la-arquitectura-se-adapta-a-la-ia)  
4. [Extensiones de aceleración: SVE2, SME y SME2](#4-extensiones-de-aceleración-sve2-sme-y-sme2)  
5. [La NPU: acelerador dedicado para cargas de IA](#5-la-npu-acelerador-dedicado-para-cargas-de-ia)  
6. [Chips emblemáticos basados en ARM para IA](#6-chips-emblemáticos-basados-en-arm-para-ia)  
7. [ARM frente a x86 y RISC-V en cargas de IA](#7-arm-frente-a-x86-y-risc-v-en-cargas-de-ia)  
8. [Casos de uso por segmento](#8-casos-de-uso-por-segmento)  
9. [Tendencias y perspectiva a futuro](#9-tendencias-y-perspectiva-a-futuro)  
10. [Conclusión](#10-conclusión)  
11. [Referencias bibliográficas](#11-referencias-bibliográficas)

---
# Tabla Resumen de la Investigación

| Tema | Descripción | Tecnologías Relacionadas |
|---|---|---|
| Arquitectura ARM | Arquitectura RISC eficiente y de bajo consumo | ARMv8, ARMv9 |
| Modelo de negocio ARM | Licenciamiento de diseños a otras empresas | Apple, Qualcomm, NVIDIA |
| Extensiones IA | Mejoras para acelerar inteligencia artificial | SVE2, SME, SME2 |
| Hardware especializado | Integración de componentes para tareas específicas | GPU, NPU, DSP |
| NPUs | Aceleradores dedicados para redes neuronales | Ethos-U85 |
| Chips destacados | Procesadores ARM modernos orientados a IA | Apple M4, Snapdragon X Elite |
| ARM vs x86 | ARM ofrece mejor eficiencia energética | Graviton 4, Xeon |
| ARM vs RISC-V | ARM tiene ecosistema más maduro | IoT, Edge AI |
| Aplicaciones | Uso en móviles, nube, IoT y PCs | Copilot+, Apple Intelligence |
| Tendencias futuras | IA local y chips modulares | Chiplets, IA generativa |

---

# Diagrama General de la Investigación

```text
                    ┌──────────────────────┐
                    │   Arquitectura ARM   │
                    └──────────┬───────────┘
                               │
                ┌──────────────┴──────────────┐
                │                             │
        ┌───────▼────────┐          ┌────────▼────────┐
        │ Arquitectura   │          │ Hardware        │
        │ RISC           │          │ Especializado   │
        └───────┬────────┘          └────────┬────────┘
                │                             │
        ┌───────▼────────┐      ┌────────────▼────────────┐
        │ Bajo consumo   │      │ GPU │ NPU │ DSP │ SME2 │
        │ energético     │      └────────────┬────────────┘
        └───────┬────────┘                   │
                │                   ┌────────▼────────┐
                │                   │ Aceleración IA │
                │                   └────────┬────────┘
                │                            │
      ┌─────────▼─────────┐        ┌────────▼─────────┐
      │ Chips ARM Modernos│        │ Aplicaciones IA │
      └─────────┬─────────┘        └────────┬────────┘
                │                            │
   ┌────────────▼────────────┐    ┌─────────▼─────────┐
   │ Apple M4 / Snapdragon X │    │ IoT │ Cloud │ PCs │
   │ AWS Graviton │ Jetson   │    │ Smartphones │ Edge│
   └─────────────────────────┘    └───────────────────┘
```
---
## 1. Introducción

Durante décadas, la conversación sobre procesadores para inteligencia artificial giró casi exclusivamente en torno a GPUs y unidades especializadas de alto consumo energético. Sin embargo, los últimos años han mostrado un giro visible, la arquitectura ARM se ha convertido en uno de los pilares del cómputo de IA, tanto en dispositivos de bolsillo como en servidores de nube a gran escala.

Esto no ocurrió de un día para otro. Fue el resultado de decisiones arquitectónicas acumuladas a lo largo de varias generaciones de hardware, combinadas con una estrategia de licenciamiento que permitió a docenas de empresas construir chips con identidad propia sobre la misma base. 

Este artículo revisa los fundamentos técnicos de ARM, las extensiones que la han preparado para IA, los chips más relevantes del ecosistema y los segmentos donde esta arquitectura compite o domina.

---

## 2. ¿Qué es ARM y cómo funciona su modelo de negocio?

ARM (*Advanced RISC Machines*) no fabrica chips. Diseña arquitecturas de conjunto de instrucciones (ISA, por sus siglas en inglés) y las licencia a fabricantes de semiconductores. Empresas como Apple, Qualcomm, Samsung, NVIDIA y Google pagan por ese derecho y construyen sus propios procesadores sobre esa base, añadiendo sus propios núcleos, NPUs, controladores de memoria y otros bloques. 

Consecuencias directas para el ecosistema de IA:

- **Diversidad de implementaciones.** Cada licenciatario puede optimizar el chip para su caso de uso. Apple prioriza latencia de inferencia; AWS Graviton prioriza throughput a bajo costo energético; Qualcomm prioriza rendimiento en tareas de visión por computadora en dispositivos móviles.
- **Compatibilidad binaria.** A pesar de esas diferencias, el código compilado para ARMv9 corre en cualquier implementación que respete la ISA, lo que reduce la fragmentación para desarrolladores de software y frameworks de ML.

El modelo RISC (*Reduced Instruction Set Computer*) en el que se basa ARM ejecuta instrucciones simples en un solo ciclo de reloj, lo que permite pipelines más profundos, menor consumo energético y mayor densidad de cómputo por vatio comparado con arquitecturas CISC como x86.

---

## 3. De ARMv8 a ARMv9: la arquitectura se adapta a la IA

ARM no esperó a que la IA fuera tendencia para comenzar a modificar su arquitectura. Los cambios vienen de hace más de veinte años, pero se aceleraron notoriamente con ARMv8 y ARMv9.

### ARMv8 y la base para ML

ARMv8 introdujo varias capacidades que hoy son estándar en cargas de ML:

- Instrucciones **dot product** para productos punto acelerados por hardware.
- Multiplicaciones matriciales dentro de registros vectoriales.
- Soporte para el formato numérico **BFloat16**, que reduce el tamaño de los modelos de IA sin pérdida significativa de precisión.
- Extensión **NEON**: registros vectoriales que operan sobre múltiples elementos simultáneamente, útiles para inferencia de redes convolucionales.

### ARMv9: seguridad, rendimiento y IA como ciudadanos de primera clase

ARMv9.0-A incorporó SVE2 (*Scalable Vector Extension 2*) para DSPs, medios y vectorización general. ARMv9.2-A introdujo SME (*Scalable Matrix Extension*) y ARMv9.3-A trajo SME2, el paso más ambicioso hasta la fecha en materia de aceleración de IA directamente en el CPU.

---

## 4. Extensiones de aceleración: SVE2, SME y SME2

### SVE2

SVE2 extiende NEON con registros vectoriales de longitud variable (de 128 a 2048 bits según la implementación). Esto permite que el mismo código saque provecho del ancho de registro disponible en el hardware sin recompilación. Benchmarks internos de ARM muestran mejoras del 10% en decodificación HDR y 20% en procesamiento de imagen usando SVE2 en CPUs Cortex-A de última generación.

### SME y SME2

SME (*Scalable Matrix Extension*) introdujo el concepto de *tile storage*: un conjunto de registros matriciales que permiten operar sobre bloques completos de matrices sin mover datos repetidamente entre memoria y registros escalares. SME2 refinó ese modelo con soporte explícito para precisiones cuantizadas (INT4, INT8) y operaciones de producto externo críticas para transformers.

Ejecutando operaciones matriciales directamente en el CPU con SME2, se obtienen hasta 6x más velocidad de inferencia para modelos de lenguaje grande y 3x de mejora en procesamiento de voz e imagen, sin requerir NPUs separados ni recursos en la nube.

El modelo Gemma 3 de Google, con SME2 habilitado en hardware compatible, puede iniciar el resumen de texto de una página en menos de un segundo usando un solo núcleo CPU, con una aceleración de hasta 6x respecto al mismo hardware sin SME2.

---

## 5. La NPU: acelerador dedicado para cargas de IA

Una NPU (*Neural Processing Unit*) es un bloque de silicio diseñado específicamente para operaciones matriciales y de convolución, las operaciones más frecuentes en redes neuronales. Su ventaja frente al CPU o GPU es la relación TOPS/vatio: ejecuta más operaciones de inferencia por unidad de energía consumida.

ARM ofrece su propia familia de NPUs bajo la marca **Ethos**. La más reciente, la **Ethos-U85**, representa el punto más alto de esa línea para aplicaciones edge:

- Cuatro veces más rendimiento y 20% mayor eficiencia energética que la generación anterior.
- Arquitectura escalable: de 128 a 2048 unidades MAC, equivalente a 4 TOPS a 1 GHz.
- Compatibilidad con TensorFlow Lite, PyTorch, Transformer Networks y CNNs.
- Más de 20 socios industriales licencian esta tecnología, entre ellos Alif e Infineon.

Sin embargo, dado que no hay estandarización entre las múltiples implementaciones de NPU en el mercado, muchos desarrolladores terminan ignorándolas y corriendo sus modelos en CPU y GPU. ARM lo resolvió al mejorar SME2 en el CPU para quien no quiera lidiar con NPUs propietarias, y ofrecer la Ethos como opción a quienes sí las necesiten.

### ¿Cuántos TOPS se necesitan realmente?

| Tarea | TOPS mínimos recomendados |
|---|---|
| Asistente de voz local (modelos pequeños) | 10–15 TOPS |
| Copilot+ PC / Windows AI Features | 40 TOPS |
| Inferencia LLM 7B en tiempo real | 60–80 TOPS |
| Generación de imagen local | 80+ TOPS |

---

## 6. Chips emblemáticos basados en ARM para IA

### Apple M4 / M5 (Apple Silicon)

Apple fue el primer fabricante de consumo masivo en adoptar SME2, integrándolo en el M4 a finales de 2024. El M4 ofrece 38 TOPS a través de su Neural Engine de 16 núcleos. En benchmarks de Geekbench 6 AI, el Neural Engine del M4 superó al NPU del Snapdragon X Elite por un factor de 2x–3x en pruebas INT8 y FP16, lo que sugiere que la NPU de Apple tiene menor overhead y mejor utilización a pesar de tener menos TOPS en papel.

El M5 (octubre 2025) mejoró el Neural Engine con 3.5x más rendimiento de IA sobre el M4, aunque en benchmarks NPU sintéticos el Snapdragon X2 Elite Extreme lo supera con 88,615 puntos frente al resultado del M5.

![alt text](https://cdn.mos.cms.futurecdn.net/dPLxAZUb4JzeGvPd5UTwiW.jpg)

### AWS Graviton 4 (Neoverse V2)

Diseñado para cargas de inferencia a escala en servidores, el Graviton 4 usa núcleos Neoverse V2 con soporte para SVE. Con KleidiAI y `torch.compile`, PyTorch puede obtener hasta 2x mejor rendimiento en modo Eager en este hardware, y los kernels INT4/INT8 mejoran la inferencia hasta 18x en modelos como Llama y Gemma.

### NVIDIA Jetson (ARM + GPU dedicada)

Jetson es la plataforma de NVIDIA para edge AI de alto rendimiento. Combina núcleos ARM Cortex con GPUs Ampere/Orin, orientada a robótica, vehículos autónomos y visión industrial. No compite directamente con los chips mencionados arriba, sino que cubre un nicho donde la latencia de GPU es indispensable y el consumo no es el principal limitante.


### Qualcomm Snapdragon X Elite / X2 Elite Extreme

El Snapdragon X Elite introdujo el CPU Oryon (derivado de la adquisición de Nuvia) y el NPU Hexagon con 45 TOPS. Su sucesor, el **Snapdragon X2 Elite Extreme**, eleva esa cifra a 80 TOPS y en AI Computer Vision (Procyon) alcanzó 4,151 puntos, frente a 2,121 del Apple M4.

La competencia entre estos dos chips es el principal indicador del estado del arte en laptops ARM para IA a mediados de 2025.

 ![alt text](https://www.zonamovilidad.es/fotos/2/qualcomm-snapdragon-x2-elite.jpg)
---

## 7. ARM frente a x86 y RISC-V en cargas de IA

### ARM vs x86

La diferencia más relevante para IA no es el rendimiento bruto sino la eficiencia energética. Un servidor con procesadores ARM Graviton 4 en AWS puede ejecutar la misma carga de inferencia que uno con Xeon a una fracción del costo energético. En laptops, la brecha es visible en la autonomía de batería durante tareas de IA local.

x86 mantiene ventaja en compatibilidad con software heredado y en ecosistemas como CUDA, aunque esa ventaja se estrecha con cada generación de herramientas ARM.

### ARM vs RISC-V

RISC-V es una ISA abierta y libre de regalías, lo que la hace atractiva para investigación y chips embebidos de nicho. Sin embargo, su ecosistema de software, herramientas de compilación y soporte de frameworks de ML es considerablemente más limitado que el de ARM. Para IA de producción, ARM sigue siendo la opción más madura, aunque RISC-V avanza rápidamente en el segmento IoT y microcontroladores.

---

## 8. Casos de uso por segmento

El cambio a ARM abre nuevos caminos de diseño: arquitecturas heterogéneas CPU+GPU+NPU para embedded AI más eficiente, inteligencia actualizable por software sin rediseño de hardware, y nuevos form factors como dispositivos fanless o ruggerizados, habilitados por la eficiencia térmica de la arquitectura.

### Edge AI e IoT

La plataforma Corstone-320 de ARM, que combina el Cortex-M85, el ISP Mali-C55 y la NPU Ethos-U85, procesa voz, audio y video en tiempo real para aplicaciones de automatización industrial y cámaras inteligentes.

### Mobile (smartphones y tablets)

Chips como el Apple A18, Snapdragon 8 Elite y Exynos 2500 integran NPUs diseñadas para inferencia de LLMs pequeños, reconocimiento de escena, traducción offline y modelos de audio. Apple Intelligence corre completamente on-device en dispositivos con M-series y A18+.

### Laptops y PCs

Los Copilot+ PCs de Microsoft requieren un mínimo de 40 TOPS de NPU. Actualmente los chips ARM (Snapdragon X y Apple M-series) son los únicos que superan esa marca con buena autonomía de batería.

### Cloud y data centers

AWS, Google y Microsoft ya ofrecen instancias con ARM para inferencia. El costo por inferencia en instancias Graviton puede ser entre 20–40% menor que en sus equivalentes x86 para modelos como BERT o Whisper.

---

## 9. Tendencias y perspectiva a futuro

### Estandarización del ecosistema NPU

La fragmentación actual del ecosistema NPU es un problema reconocido. ARM está trabajando en estándares que permitan a los desarrolladores aprovechar NPUs de distintos fabricantes sin reescribir código. Sin esa estandarización, la mayoría seguirá usando CPU y GPU por defecto.

### Chiplets y modularidad

ARM contribuyó su especificación *Foundation Chiplet System Architecture* (FCSA) al Open Compute Project (OCP), lo que abre la puerta a diseños modulares donde los bloques de cómputo de IA se integran como chiplets intercambiables.

### La apuesta por el 50% del mercado PC

El CEO de ARM, Rene Haas, declaró el objetivo de capturar la mitad del mercado de PCs con Windows para 2029. La publicación de ARM PC Base System Architecture 1.0 es el primer paso formal en esa dirección.

### IA generativa en el borde

El desplazamiento de cargas de IA generativa desde la nube hacia el dispositivo es la tendencia más activa del momento. SME2 y las NPUs de última generación hacen viable correr modelos de 3B–7B parámetros en laptops y teléfonos sin conexión a internet, con implicaciones directas para privacidad, latencia y costo.

---

## 10. Conclusión

ARM no es la arquitectura más poderosa en términos absolutos. Los mejores resultados en entrenamiento de modelos grandes siguen ocurriendo en clusters de GPUs NVIDIA, y probablemente eso no cambie pronto. Pero el entrenamiento es solo una parte del ciclo de vida de un modelo, y ARM lleva años ganando terreno en inferencia, que es donde el software de IA toca al usuario final.

Lo interesante del caso ARM es que su avance no dependió de un producto estrella sino de una acumulación de decisiones técnicas que tardaron años en volverse visibles; BFloat16 en ARMv8, SVE2 en ARMv9, SME2 en ARMv9.3, KleidiAI como capa de software. Ninguna de esas piezas por sí sola explica por qué hoy un teléfono puede correr un modelo de lenguaje sin conexión, todas juntas, sí.

Para quienes estudiamos ISC o ITICS, esto tiene una implicación práctica concreta, el hardware que van a programar en los próximos años no va a ser x86 en todos los contextos. Entender cómo una ISA toma decisiones sobre registros, precisión numérica y extensiones matriciales no es teoría de arquitecturas desconectada de la realidad, es la base para entender por qué un modelo corre bien en un dispositivo y mal en otro, por qué ciertos frameworks tienen flags específicos para ARM, y por qué el consumo energético se ha vuelto un criterio de diseño tan importante como la velocidad bruta.

---

## 11. Referencias bibliográficas

1. Hennessy, J. L. & Patterson, D. A. (2019). *Computer Architecture: A Quantitative Approach* (6th ed.). Morgan Kaufmann.

2. ARM Ltd. (2024). *Scalable Matrix Extension (SME) for Armv9 Architecture Enables AI Innovation on the Arm CPU*. ARM Newsroom. https://newsroom.arm.com/blog/scalable-matrix-extension

3. ARM Ltd. (2024). *Beyond the Newsroom: 10 Latest Innovations from Arm in September 2024*. ARM Newsroom. https://newsroom.arm.com/blog/10-innovations-from-arm-in-september-2024

4. ARM Ltd. (2025). *SME2 – AI Acceleration with Armv9 CPUs*. ARM Developer Documentation. https://www.arm.com/technologies/sme2

5. ARM Community. (2025). *One year of Arm KleidiAI in XNNPack*. ARM Developer Blog. https://developer.arm.com/community/arm-community-blogs/b/ai-blog/posts/arm-kleidiai-in-xnnpack

6. VentureBeat. (2024). *Arm infuses AI into internet of things chips for edge applications*. https://venturebeat.com/ai/arm-infuses-ai-into-internet-of-things-chips-for-edge-applications

7. The Register. (2025). *Arm bets on CPU-based AI with Lumex chips for smartphones*. https://www.theregister.com/2025/09/10/arm_goes_allin_for_ai/

8. ts2.tech. (2025). *AI Titans Clash: Snapdragon X Elite vs Apple M4 vs Exynos 2500*. https://ts2.tech/en/ai-titans-clash-snapdragon-x-elite-vs-apple-m4-vs-exynos-2500-which-chip-leads-the-ai-revolution/

9. Tom's Guide. (2025). *Apple M5 vs Snapdragon X2 Elite Extreme benchmarks*. https://www.tomsguide.com/computing/cpus/apple-m5-vs-snapdragon-x2-elite-extreme-benchmarks-the-early-verdict-is-in-and-its-a-surprise

10. Windows Central. (2025). *Snapdragon X2 Elite Extreme vs. Apple M4*. https://www.windowscentral.com/hardware/qualcomm/snapdragon-x2-elite-extreme-vs-apple-m4-pro-max

11. ARM Newsroom. (2024). *How Arm improved PyTorch inference performance using Kleidi technology*. https://newsroom.arm.com/blog/10-innovations-from-arm-in-september-2024

12. Edge AI and Vision Alliance. (2025). *The architecture shift powering next-gen industrial AI*. https://www.edge-ai-vision.com/2025/12/the-architecture-shift-powering-next-gen-industrial-ai/

13. Computerworld. (2025). *In the age of AI, what is a PC? Arm has its answer*. https://www.computerworld.com/article/3610877/microsoft-rolls-out-new-features-for-copilot-pcs-after-arm-releases-ai-pc-specs.html

14. ARM Newsroom. (2025). *What Arm Unlocked 2025 revealed about the future of AI computing*. https://newsroom.arm.com/blog/arm-unlocked-2025

15. Zonamovilidad.es. (2025). *Snapdragon X2 Elite Extreme, la nueva apuesta de Qualcomm para llevar la IA y el rendimiento al PC con Windows*. https://www.zonamovilidad.es/snapdragon-x2-elite-extreme-nueva-apuesta-qualcomm-llevar-ia-rendimiento-pc-windows

16. Bonifield, S. & Chaney, S. (2024). *Apple is gearing up for M4 Mac launch — here's a look at the release windows and all the new chips*. Laptop Mag. https://www.laptopmag.com/laptops/macbooks/apple-is-gearing-up-for-m4-mac-launch-heres-a-look-at-the-release-window-and-all-the-new-chips



