
![Microcontroladores Microchip SAM L10 y L11 de 32 bit con seguridad a nivel  de chip y tecnología Arm TrustZone® - Revista Electrónica Convertronic -  Noticias y Actualidad Electrónica](https://convertronic.net/images/stories/CONVERTRONIC161/microcontrolador-32-bit-SAM-L10-11-w.jpg)

# ARM TrustZone: seguridad integrada en hardware

## Resumen de la Tecnología de Aislamiento
La tecnología ARM TrustZone constituye una solución de seguridad a nivel de silicio que particiona los recursos de un sistema en chip en dos estados de ejecución: el Mundo Normal (Normal World) para el software de propósito general y el Mundo Seguro (Secure World) para procesos críticos. A través de este aislamiento, se crea un Entorno de Ejecución de Confianza (TEE) que protege activos sensibles, como datos biométricos y claves criptográficas, frente a ataques que puedan comprometer el sistema operativo principal (Rich OS).

---

## Paradigma de Seguridad: El Enclave Basado en Hardware
En el panorama actual de ciberseguridad, depender exclusivamente del software es un riesgo elevado. Un kernel de Android o Linux posee millones de líneas de código, lo que aumenta la superficie de ataque. TrustZone justifica su implementación bajo los siguientes pilares:

* **Dualidad Virtual del Procesador:** Permite que un solo núcleo físico actúe como dos procesadores virtuales, optimizando costos y consumo energético.
* **Raíz de Confianza Inmutable (Root of Trust):** Establece una jerarquía donde el hardware es el que dicta los permisos de acceso. Ni siquiera un usuario con privilegios de *root* en el Mundo Normal puede "espiar" la memoria del Mundo Seguro.

![Normal and secured worlds ©Arm | Download Scientific Diagram](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRD22TnUopXJzasLzcwyscdvBHbr033spiiqA&s)

---

## Anatomía del Aislamiento: El Bit NS y el Bus de Datos
A diferencia de otros métodos de seguridad, TrustZone no es un procesador físico independiente, sino un cambio en el estado del hardware.



### La Señalización en el Bus AMBA AXI
El corazón de esta arquitectura es el bit **NS (Non-Secure)**, una señal adicional integrada en el bus de sistema.
* **NS = 1 (Estado No Seguro):** El procesador tiene acceso limitado. Cualquier intento de acceder a direcciones de memoria protegidas es bloqueado por el hardware.
* **NS = 0 (Estado Seguro):** El procesador tiene visibilidad total del sistema, incluyendo periféricos y memoria sensible.
![Attacking TrustZone on devices lacking memory protection | Journal of  Computer Virology and Hacking Techniques | Springer Nature Link](https://media.springernature.com/lw1200/springer-static/image/art%3A10.1007%2Fs11416-021-00413-y/MediaObjects/11416_2021_413_Fig4_HTML.png)

### Matriz de Componentes Críticos de Hardware
| Componente | Siglas | Función Técnica de Bajo Nivel |
| :--- | :--- | :--- |
| **Address Space Controller** | TZASC | Controla el acceso a la RAM, particionándola en regiones seguras e inseguras a nivel de controlador de memoria. |
| **Protection Controller** | TZPC | Configura la seguridad de los periféricos (teclado, sensor de huella, DRM) mediante señales de control. |
| **Secure Monitor** | EL3 | El software de más alto privilegio (firmware) que gestiona la conmutación de contexto. |
| **Interrupt Controller** | GIC | Gestiona qué interrupciones son enviadas al Mundo Seguro y cuáles al Normal para evitar "secuestro" de eventos. |

---

## Niveles de Excepción y Jerarquía de Privilegios
Para evitar interferencias, ARM define niveles de excepción (Exception Levels) que separan las responsabilidades de ejecución. El aislamiento se mantiene incluso si un mundo intenta "saltar" al otro.



### Comparativa de Entornos de Software
| Característica | Mundo Normal (Rich Execution Environment) | Mundo Seguro (Trusted Execution Environment) |
| :--- | :--- | :--- |
| **Sistema Operativo** | Android, Linux, iOS, Windows. | OP-TEE, QSEE, SierraTEE. |
| **Aplicaciones** | Apps de usuario, Servicios de red. | Trusted Apps (TAs), Servicios de Cifrado. |
| **Memoria RAM** | Visible y accesible para el usuario. | Invisible para el Mundo Normal (Hardware Hidden). |
| **Acceso a Hardware** | Periféricos estándar (Pantalla, Wi-Fi). | Periféricos sensibles (Crypto-engine, Huella). |

---

## Análisis de Flujo: Ejecución de una Operación Crítica
Para demostrar la eficacia del sistema, se presenta el flujo de trabajo durante una **autenticación biométrica**:

1.  **Petición:** Una app en Android solicita la huella del usuario.
2.  **Transición (SMC):** El Kernel emite una instrucción `SMC` (*Secure Monitor Call*).
3.  **Gestión del Monitor:** El procesador entra en el nivel **EL3**, salva los registros del Mundo Normal y cambia el bit NS a 0.
4.  **Aislamiento en Ejecución:** El **Trusted OS** toma el control. El hardware (TZPC) permite que el sensor de huella solo hable con el Mundo Seguro. El Mundo Normal queda "congelado" y sin acceso.
5.  **Finalización:** Se valida la huella, se limpia la memoria volátil para evitar fugas y el Monitor devuelve un "Éxito/Fallo" al Mundo Normal, restaurando su estado.

---

## Diferencias de Implementación por Perfil de Procesador
No todos los procesadores ARM implementan TrustZone de la misma manera. Dependiendo del uso del dispositivo (móvil vs. industrial), la arquitectura varía:

### TrustZone en Perfiles Cortex-A vs Cortex-M
| Característica | Cortex-A (Smartphones/Tablets) | Cortex-M (IoT/Microcontroladores) |
| :--- | :--- | :--- |
| **Mecanismo** | Basado en estados (Mundo Normal/Seguro). | Basado en mapa de memoria (Memory-mapped). |
| **Cambio de Estado** | Requiere software (Secure Monitor/SMC). | Cambio instantáneo por hardware (Llamada a función directa). |
| **Complejidad** | Alta (Soporta Sistemas Operativos completos). | Baja (Optimizado para tiempo real y bajo consumo). |
| **Latencia** | Mayor (Debido al cambio de contexto del Monitor). | Mínima (Casi despreciable). |

---

## Vectores de Ataque y Límites de la Seguridad
A pesar de su robustez, TrustZone ha sido objeto de investigaciones para encontrar vulnerabilidades. Los ataques más avanzados incluyen:

* **Side-Channel Attacks:** Ataques que analizan el consumo de energía o el tiempo de respuesta de la caché para deducir claves criptográficas.
* **SMC Fuzzing:** Enviar llamadas malformadas al Secure Monitor para intentar causar un desbordamiento de búfer en el nivel EL3.
* **Rowhammer:** Explotar fugas eléctricas en la memoria RAM para alterar bits en la zona segura desde la zona insegura mediante martilleo de filas.

---

## Fuentes de Información y Bibliografía

- Arm Ltd. (2023). *Arm® Architecture Reference Manual Armv8, for Armv8-A architecture profile*. Arm Limited. https://developer.arm.com/documentation/ddi0487/latest  
- Arm Ltd. (2022). *Arm Security Technology – Building a Secure System using TrustZone Technology*. Arm Limited. https://developer.arm.com/documentation/den0013/latest  
- Pinto, S., & Santos, N. (2019). Demystifying Arm TrustZone: A comprehensive survey. *ACM Computing Surveys, 51*(6), 1–36. https://doi.org/10.1145/3291047  
- Cerdeira, D., Santos, N., Pinto, S., & Vieira, M. (2020). SoK: Understanding the reliability of Arm TrustZone-based trusted execution environments. In *Proceedings of the IEEE Symposium on Security and Privacy (SP)* (pp. 141–159). IEEE. https://doi.org/10.1109/SP40000.2020.00014  
- GlobalPlatform. (2018). *TEE Client API Specification v1.0*. GlobalPlatform. https://globalplatform.org/specs-library/tee-client-api-specification/  
