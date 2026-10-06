<img width="1896" height="913" alt="ARM Virtual Hardware" src="https://github.com/user-attachments/assets/b4cb684e-e2c1-4249-9b81-ea054e35e36d" />

# ARM Virtual Hardware (AVH) en Corellium

## 1. Introducción

**Arm Virtual Hardware (AVH)** es una plataforma en la nube que permite diseñar, ejecutar, probar y depurar software para dispositivos con procesadores **Arm** sin necesidad de hardware físico. Es especialmente útil en sistemas embebidos, IoT (Internet de las Cosas) e inteligencia artificial (IA), porque acelera el ciclo de desarrollo y reduce costos.

Como **Arm Developer**, Arm ofrece una prueba **gratuita por 30 días** de esta virtualización, proporcionada por **Corellium**.

### Objetivos de esta lección

- Comprender qué es AVH y qué papel tiene Corellium.
- Conocer sus características, ventajas y aplicaciones.
- Crear una cuenta y levantar tu primer dispositivo virtual.

---

## 2. ¿Qué es Corellium?

**Corellium** es una plataforma de virtualización avanzada para dispositivos Arm. Permite ejecutar sistemas operativos completos (iOS, Android, Linux) y firmware embebido sobre hardware Arm virtual.

- **Virtualización ARM-on-ARM:** no emula con lentitud; usa su hipervisor propietario **CHARM™**, con alta velocidad y fidelidad.
- **Dispositivos completos:** no solo virtualiza la CPU, también periféricos, buses, sensores y subsistemas, por lo que ejecuta el mismo software que correría en hardware físico.
- **Flexibilidad:** se puede usar en la nube o en instalaciones privadas, con escalabilidad para múltiples máquinas virtuales Arm.

**Casos de uso:** desarrollo temprano de software, investigación de seguridad, pruebas de IoT y validación de sistemas embebidos y móviles.

### Corellium frente a AVH

| | Corellium | Arm Virtual Hardware (AVH) |
|---|---|---|
| **Enfoque** | Seguridad, análisis profundo y virtualización de dispositivos completos | Modelo funcional para IoT y CI/CD |

---

## 3. ¿Qué es Arm Virtual Hardware?

AVH ejecuta software sobre modelos virtuales de procesadores **Arm Cortex** y otros núcleos de la arquitectura Arm. Está pensado para acelerar el desarrollo y la validación, eliminando la necesidad de placas de desarrollo durante las primeras etapas del proyecto.

### Características principales

| Característica | Descripción |
|---|---|
| **Simulación en la nube** | Se ejecuta en servicios como **Amazon Web Services (AWS)**; da acceso remoto y facilita la colaboración entre equipos distribuidos. |
| **Múltiples arquitecturas** | **Cortex-M** (embebidos e IoT), **Cortex-A** (móviles y cómputo de alto rendimiento) y **Neoverse** (servidores y nube). |
| **Desarrollo sin hardware** | Permite depurar y probar el software en un entorno virtual antes de pasarlo a hardware real. |
| **Integración con herramientas** | Compatible con **Keil MDK**, **Arm Development Studio** y herramientas de código abierto; se integra con flujos **DevOps** y CI/CD. |
| **Alta fidelidad** | Reproduce el comportamiento del hardware real e incluye modelos de sensores y periféricos. |

### Beneficios

| Beneficio | Descripción |
|---|---|
| **Menor costo** | No se compra hardware físico en la fase inicial. |
| **Mayor velocidad** | Se desarrolla software antes de que el hardware esté disponible. |
| **Flexibilidad** | Se prueban múltiples configuraciones sin cambiar de hardware. |
| **Escalabilidad** | Se accede desde cualquier lugar y se ejecutan varias instancias en paralelo. |

### Aplicaciones

1. **Firmware para IoT:** probar el software con sensores y hardware embebido simulados antes de fabricarlos.
2. **IA y ML en el borde (Edge):** simular redes neuronales en hardware embebido antes de implementarlas en dispositivos físicos.
3. **Seguridad en software embebido:** realizar pruebas de seguridad antes de desplegar en dispositivos sensibles.
4. **DevOps y CI/CD:** automatizar pruebas en entornos virtuales antes de desplegar en hardware real.

---

## 4. Práctica: crea tu cuenta y tu primer dispositivo

### Paso 1. Crear la cuenta de Arm

1. Entra a [account.arm.com](https://account.arm.com) y crea tu cuenta.
2. Valida tu cuenta con el enlace que llega a tu correo electrónico.

### Paso 2. Acceder a AVH

1. Entra a [avh.corellium.com](https://avh.corellium.com).
2. Inicia sesión con la opción **ARM ACCOUNT**.

### Paso 3. Elegir la plataforma de simulación

- Selecciona el modelo de procesador (**Cortex-M**, **Cortex-A**, **Neoverse**, etc.).
- Configura el entorno según los requisitos de tu software.

### Paso 4. Integrar con tus herramientas

- Conecta con entornos como **Keil MDK** o **Arm Development Studio**.
- Opcional: configura **GitHub Actions**, **Jenkins** u otra herramienta de CI/CD.

### Paso 5. Ejecutar y probar

- Compila y ejecuta tu código en el entorno virtual.
- Usa las herramientas de depuración para analizar su comportamiento.

![Captura de pantalla de AVH](https://github.com/user-attachments/assets/7afb8e65-a73e-4ccf-9dea-cd35f11636cc)

---

## 5. Demostración

- **Video:** <https://www.loom.com/share/55e1cd12cd3a4e21aa19460ac48da509?sid=986b1d4b-3e74-4c49-bf7f-e72a3fb362cb>
- **Procedimiento oficial:** <https://support.avh.corellium.com/getting-started/creating-your-first-device>

### Preguntas para reflexión

1. ¿Cómo impacta AVH en el desarrollo de software para dispositivos embebidos?
2. ¿Cuáles son las principales ventajas de usar un entorno de simulación en lugar de hardware físico?
3. ¿Cómo podría integrarse AVH en una estrategia de desarrollo basada en DevOps?

---

## Evaluación (iDoceo)

<img width="589" alt="Rúbrica de trabajo de investigación y demostrativo" src="https://github.com/user-attachments/assets/73c333dc-dcc2-407c-ab39-1070f00b7143" />

## Recursos adicionales

- [Sitio oficial de Arm](https://www.arm.com)
- [Arm Virtual Hardware en Corellium](https://avh.corellium.com)
- [AWS Marketplace](https://aws.amazon.com/marketplace)
