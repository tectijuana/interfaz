# <img width="1019" height="68" alt="cooltext502568207001702" src="https://github.com/user-attachments/assets/1339eabe-8a23-4c15-b1bb-0b869587f740" />

**Materia:** Lenguajes de Interfaz  
**Alumno:** Diaz Enciso Sergio  
**Fecha:** 16/02/26  
**Profesor:** RENE SOLIS REYES  

---

# 1. <img width="268" height="65" alt="cooltext502568239165779" src="https://github.com/user-attachments/assets/3c606cc5-760a-4559-9ecf-2eb47080c0d6" />

La arquitectura ARM es una de las más utilizadas en sistemas embebidos y dispositivos electrónicos actuales. Su diseño eficiente, bajo consumo energético y alto rendimiento la hacen ideal para aplicaciones donde la rapidez y la confiabilidad son esenciales.

En los sistemas en tiempo real, el procesador debe responder dentro de un tiempo límite específico. ARM cumple con estos requisitos gracias a su arquitectura optimizada y su eficiente manejo de interrupciones.

---

# 2. <img width="360" height="64" alt="cooltext502568269769948" src="https://github.com/user-attachments/assets/33235d32-4838-4ff1-928a-d69fd1fc9b75" />

## 2.1 <img width="358" height="62" alt="cooltext502568346592164" src="https://github.com/user-attachments/assets/69f2dd99-68b1-429a-9ca7-8096fe6a0f65" />

ARM es una arquitectura basada en el modelo RISC (Reduced Instruction Set Computer). Fue desarrollada por la empresa británica Arm Ltd., que diseña núcleos de procesamiento licenciados a distintos fabricantes.

Su principal ventaja es ofrecer alto rendimiento con bajo consumo energético, lo que la hace ideal para microcontroladores y sistemas críticos.

---

## 2.2 <img width="434" height="60" alt="cooltext502568465811384" src="https://github.com/user-attachments/assets/0b26c957-61a3-4e8c-9bec-78c725c81c34" />

Un sistema en tiempo real es aquel que debe responder a eventos dentro de un tiempo determinado. Si no cumple ese tiempo, puede producirse un fallo.

Existen tres tipos:

- Tiempo real duro  
- Tiempo real blando  
- Tiempo real firme  

---

# 3. <img width="631" height="62" alt="cooltext502568704203255" src="https://github.com/user-attachments/assets/203f9cee-e4d7-48de-bd3a-70fe9a8a02e9" />

## 3.1 <img width="240" height="60" alt="cooltext502568500892249" src="https://github.com/user-attachments/assets/37ffb899-ea4a-4634-804b-f885cd52fe2a" />

El modelo RISC utiliza instrucciones simples y de tamaño fijo, lo que permite:

- Mayor velocidad de ejecución  
- Menor consumo energético  
- Mayor previsibilidad  

Esto es fundamental en aplicaciones donde el tiempo de respuesta es crítico.

---

## 3.2 <img width="516" height="60" alt="cooltext502568519461470" src="https://github.com/user-attachments/assets/78db5c11-54c2-4581-9917-0ff4215b4308" />

Las principales familias son:

- Cortex-M: Microcontroladores y bajo consumo.  
- Cortex-R: Sistemas críticos en tiempo real.  
- Cortex-A: Sistemas operativos avanzados.  

Las series Cortex-M y Cortex-R son las más utilizadas en sistemas en tiempo real.

---

## 3.3 <img width="496" height="61" alt="cooltext502568532749389" src="https://github.com/user-attachments/assets/5ad9ef76-704a-4053-a349-0394c047788b" />

ARM incorpora el NVIC (Nested Vectored Interrupt Controller), que permite:

- Múltiples niveles de prioridad  
- Baja latencia  
- Respuesta rápida a eventos externos  

Esto garantiza un comportamiento determinista.

---

# 4. <img width="266" height="60" alt="cooltext502568680182675" src="https://github.com/user-attachments/assets/df9aa82a-8d0f-4b1f-b780-3f0c2b99f18f" />

La arquitectura ARM en sistemas en tiempo real se utiliza en:

- Sistemas automotrices  
- Equipos médicos  
- Robótica industrial  
- Dispositivos IoT  
- Sistemas aeroespaciales  

---

# 5. <img width="195" height="61" alt="cooltext502568666431183" src="https://github.com/user-attachments/assets/cd83c28f-b63b-41e7-9e9c-8bfcde0fea24" />

- Bajo consumo energético  
- Alta eficiencia  
- Buena gestión de interrupciones  
- Amplio ecosistema de desarrollo  

---

# 6. <img width="217" height="60" alt="cooltext502568653097259" src="https://github.com/user-attachments/assets/4cecc1e6-da6c-4cdc-b59e-f669ed4e2eb2" />

## 6.1 <img width="631" height="62" alt="cooltext502568553379138" src="https://github.com/user-attachments/assets/22cfee92-e6b4-4e6d-a814-ced9ffd13b19" />
```mermaid
flowchart TD
    A[Arquitectura ARM] --> B[Modelo RISC]
    A --> C[Manejo de Interrupciones]
    A --> D[Bajo Consumo Energético]

    C --> E[NVIC]
    C --> F[IRQ]
    C --> G[FIQ]

    E --> H[Prioridades]
    E --> I[Baja Latencia]

    D --> J[Sistemas Embebidos]
    J --> K[Tiempo Real]
```
## 6.2 <img width="657" height="65" alt="cooltext502568568612589" src="https://github.com/user-attachments/assets/d7fabd92-3248-4e2a-8352-ae6622df9416" />
```mermaid
flowchart TD
    A[Procesadores ARM] --> B[Cortex-M]
    A --> C[Cortex-R]
    A --> D[Cortex-A]

    B --> B1[Microcontroladores]
    C --> C1[Sistemas Críticos]
    D --> D1[Sistemas Operativos]
```
## 6.3 <img width="1000" height="60" alt="cooltext502568624634375" src="https://github.com/user-attachments/assets/2fe53071-911f-4bea-ad2f-c36182ace02a" />
```mermaid
sequenceDiagram
    participant Sensor
    participant CPU_ARM
    participant NVIC
    participant RTOS
    participant Actuador

    Sensor->>CPU_ARM: Evento
    CPU_ARM->>NVIC: Interrupción
    NVIC->>CPU_ARM: Prioriza
    CPU_ARM->>RTOS: Ejecuta Tarea
    RTOS->>Actuador: Respuesta
```



