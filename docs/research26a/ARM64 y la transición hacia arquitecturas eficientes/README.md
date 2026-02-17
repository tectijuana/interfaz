# ARM64 y la transición hacia arquitecturas eficientes

**Autor:** Aguilar Saavedra Oliver 23211899  
**Materia:** Lenguajes de Interfaz - TECNM Campus ITT  
**Grupo:** 26b4pm  
**Fecha:** 16/02/2026  

**Descripción:** Investigación sobre ARM64 y transición global hacia arquitecturas eficientes


## 1. Introducción

Durante décadas, la arquitectura x86 (Intel/AMD) dominó servidores y computadoras personales. ARM, por su parte, se limitaba a dispositivos móviles por su bajo consumo. Desde 2020, con la llegada de los chips M1 de Apple, ARM demostró que podía competir en rendimiento y superar en eficiencia energética. Actualmente, grandes proveedores de nube (AWS, Google, Microsoft) están adoptando ARM64 para reducir costos operativos y consumo eléctrico.

## 2. Diferencias técnicas básicas

| Arquitectura | Filosofía | Instrucciones | Consumo |
|--------------|-----------|---------------|---------|
| **x86 (CISC)** | Instrucciones complejas que ejecutan múltiples operaciones | Mayor tamaño, menor densidad | Más alto |
| **ARM (RISC)** | Instrucciones simples, una operación por instrucción | Menor tamaño, mayor densidad | Más bajo |

La simplicidad de ARM permite diseñar chips con más núcleos y mejor rendimiento por vatio.

## 3. Datos clave de la transición

- **AWS Lambda (2025)**: Funciones en ARM64 ejecutan código Rust hasta **5 veces más rápido** que en x86. Reducción del **13-24%** en tiempos de arranque. Costo **30% menor**.
- **Google**: Migró **30,000 aplicaciones internas** a ARM. Desarrolló herramienta de IA (CogniPort) para automatizar conversiones.
- **Eficiencia energética**: Servidores ARM consumen hasta **60% menos electricidad** para cargas equivalentes según pruebas de Google.

## 4. Estado del ecosistema

- **Sistemas operativos**: Linux soporta ARM como ciudadano de primera clase.
- **Contenedores**: Docker y Kubernetes funcionan sin problemas.
- **Lenguajes de programación**: Go, Java, Python, Rust compilan nativamente.
- **Hardware disponible**: Servidores con hasta **192 núcleos** (AmpereOne, Supermicro).

## 5. Ventajas y limitaciones

**Ventajas:**
- Menor costo por instancia en nube (20-40% más barato)
- Mayor densidad de núcleos por vatio
- Ideal para microservicios, escalado horizontal, inferencia de IA

**Limitaciones:**
- Software legacy puede requerir adaptación
- Menor rendimiento en cargas muy específicas de cómputo pesado (ciertos HPC)

## 6. Conclusión

ARM64 no reemplazará completamente a x86, pero se consolida como alternativa principal en centros de datos y cloud. La decisión entre ambas arquitecturas dependerá del tipo de carga: aplicaciones nuevas y escalables se benefician de ARM; sistemas heredados o cómputo extremadamente especializado pueden permanecer en x86.

## Referencias

- Udinmwen, E. (2025). *Arm64 dominates AWS Lambda in 2025*. TechRadar.
- Boston Limited. (2025). *Unboxing the Ampere-Powered ARS-211M-NR*.
- Neary, D. (2025). *Accelerating Enterprise IT*. Ampere Computing.
- Neary, D. (2025). *Why and How to Choose Arm64*. DevConf.US.
- Udinmwen, E. (2025). *Google is undertaking a mass migration to Arm*. TechRadar.
