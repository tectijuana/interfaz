# Investigación: Protocolos de Comunicación en Tiempo Real – CAN y LIN

**Nombre:** Rogelio Avilez Jr  
**Número de control:** 22210284  
**Tema:** Protocolos de Comunicación en Tiempo Real: CAN y LIN
**Profesor:** René Solis
**Materia:** Lengauje de interfaz

---

## 1. Introducción

Un protocolo es básicamente un conjunto de reglas que permite que diferentes dispositivos electrónicos se entiendan entre sí. Es como si todos hablaran el mismo idioma. En lugar de cables individuales para cada función (como pasaba antes), ahora los sistemas se conectan a un mismo cable (un bus de datos) y se comunican mediante estos protocolos.

### c) ¿Por qué CAN y LIN?  
CAN y LIN son dos de los protocolos más usados en la industria automotriz. Ambos cumplen con distintas funciones: **CAN** es como la autopista rápida para los mensajes importantes y urgentes, mientras que **LIN** es como una calle secundaria para cosas menos urgentes y más simples. Cada uno tiene su lugar y se usan juntos para hacer que todo funcione de forma eficiente.

---

## 2. Protocolo CAN (Controller Area Network)

### a) ¿Qué es el CAN y para qué sirve?  
El protocolo CAN fue creado por Bosch para que los dispositivos electrónicos dentro de un auto pudieran comunicarse sin necesidad de una computadora central. Permite que varios dispositivos (llamados “nodos”) compartan un solo canal de comunicación, enviando y recibiendo datos de forma ordenada y rápida.

### b) ¿Cómo funciona CAN?  
En lugar de que un dispositivo tenga que esperar a que otro termine para enviar su información, todos los dispositivos están conectados a un mismo cable y pueden intentar enviar mensajes cuando lo necesiten. Si dos intentan hablar al mismo tiempo, el sistema detecta cuál mensaje es más importante (por una especie de prioridad) y deja que ese pase primero. Así se evitan colisiones o pérdidas de datos.

---

## 3. Protocolo LIN (Local Interconnect Network)

### a) ¿Qué es LIN y cuál es su objetivo?  
LIN fue creado como una solución más sencilla y barata que CAN. Está pensado para controlar funciones que no son tan críticas y que no necesitan una comunicación tan rápida. Su objetivo es reducir costos sin sacrificar funcionalidad básica.

### b) ¿Cómo se comunica un sistema con LIN?  
En LIN siempre hay un “jefe” (maestro) que manda y varios “ayudantes” (esclavos) que responden. El maestro inicia la conversación preguntando algo o pidiendo datos, y solo entonces uno de los esclavos puede responder. No se interrumpen entre sí, lo que lo hace muy ordenado, aunque más lento.

---

## 4. Tabla comparativa entre CAN y LIN

| Característica       | CAN                      | LIN                          |
|----------------------|--------------------------|------------------------------|
| Velocidad            | Hasta 1 Mbps (CAN), 8 Mbps (CAN FD) | Hasta 20 kbps     |
| Arquitectura         | Multimaestro             | Maestro/esclavo              |
| Complejidad          | Alta                     | Baja                         |
| Detección de errores | Muy robusta              | Básica                       |
| Cantidad de nodos    | Hasta 32 o más           | Hasta 16 esclavos por maestro|
| Aplicaciones         | Sistemas críticos        | Funciones auxiliares         |


---

## 6. Conclusión

CAN y LIN son dos protocolos que trabajan en equipo dentro de sistemas modernos, especialmente en autos. CAN es rápido, seguro y poderoso, mientras que LIN es simple, barato y práctico. Cada uno tiene su función específica y se complementan entre sí para que todo funcione de forma fluida, eficiente y segura. Entender cómo se comunican los dispositivos en tiempo real no solo ayuda a diseñar mejores sistemas, sino también a repararlos, mejorarlos o incluso innovar sobre ellos en el futuro.

---
## Referencias

[1] R. Bosch GmbH, *CAN Specification Version 2.0*, Stuttgart, Germany, 1991. [Online]. Available: https://www.bosch-semiconductors.com/media/ip_modules/pdf_2/can2spec.pdf

[2] SAE International, *J2602: Local Interconnect Network (LIN) - Serial Network Protocol*, SAE Standard, 2002. [Online]. Available: https://www.sae.org/standards/content/j2602_200211/

[3] K. Popp, "Introduction to CAN and LIN Protocols," *Embedded Systems Conference*, 2016. [Online]. Available: https://www.embedded.com/introduction-to-can-and-lin-protocols/

[4] H. Kopetz, *Real-Time Systems: Design Principles for Distributed Embedded Applications*, 2nd ed. Springer, 2011.

[5] M. Burns and A. Wellings, *Real-Time Systems and Programming Languages*, 4th ed. Addison-Wesley, 2009.
