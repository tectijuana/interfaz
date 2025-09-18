| **Nombre**        | **Número de control** | **Fecha**       |
|-------------------|-----------------------|-----------------|
| Osciel G          | 23210678             | 17/09/2025       |

# Desarrollo de firmware seguro para IoT con ARM TrustZone
# Desarrollo de firmware seguro para IoT con ARM TrustZone

## Introducción
El Internet de las Cosas (IoT) mete millones de microcontroladores a internet—sensores, cerraduras, medidores, wearables—y cada uno puede convertirse en puerta de entrada si el firmware no está blindado. **ARM TrustZone para ARMv8-M** ofrece aislamiento por hardware entre un mundo **Seguro (S)** y otro **No Seguro (NS)**, de modo que el código crítico (claves, crypto, attestation, almacenamiento protegido) viva en un entorno separado y con fronteras bien definidas. El resultado: una base para implementar **arranque verificado**, **servicios de seguridad estandarizados (PSA APIs)** y **actualizaciones seguras** a lo largo de la vida del dispositivo. :contentReference[oaicite:0]{index=0}

---


### 1) Aislamiento por hardware con TrustZone-M
En Cortex-M con ARMv8-M, TrustZone separa ejecución y memoria en **Secure** y **Non-Secure**. La **Security Attribution Unit (SAU)** asigna atributos de seguridad a rangos de memoria y periféricos; algunos SoC añaden una **Implementation-Defined Attribution Unit (IDAU)** para granularidad adicional conforme al mapeo físico. Las interrupciones, vectores y hasta SysTick pueden tener bancos/atributos independientes, lo que reduce superficies de ataque y asegura que sólo el mundo S acceda a secretos y periféricos sensibles. :contentReference[oaicite:1]{index=1}

El cruce entre mundos se hace a través de *gateways* llamados **Non-Secure Callable (NSC)**: funciones “veneer” minimalistas que exponen únicamente lo necesario. Así, aunque la app NS se vea comprometida, el atacante sigue topándose con el muro del hardware y con la capa de control del mundo S. :contentReference[oaicite:2]{index=2}

### 2) PSA Certified y Trusted Firmware-M (TF-M)
**Platform Security Architecture (PSA)** estandariza amenazas, requisitos y **APIs** de seguridad (Crypto, Secure Storage, Attestation, Firmware Update). Sobre esa base, **Trusted Firmware-M (TF-M)** implementa el **Secure Processing Environment (SPE)**: corre en el mundo S, segmenta servicios en **particiones seguras** y usa un **Secure Partition Manager (SPM)** para aislarlas y gestionar la comunicación **PSA IPC** con la app NS. Para el desarrollador, esto significa usar llamadas PSA (por ejemplo, `psa_crypto_xxx()`, `psa_ps_xxx()`) en vez de reinvertar ruedas propietarias. :contentReference[oaicite:3]{index=3}

La documentación de TF-M describe cómo **agregar nuevas particiones seguras** (manifiestos, permisos, modelos IPC o SFN) y cómo integrar servicios listos: **PSA Crypto**, **Internal Trusted Storage (ITS)**, **Protected Storage (PS)**, **Initial Attestation**, **Firmware Update**, etc. Varios RTOS (como **Zephyr**) ya integran TF-M y han seguido rutas de certificación PSA, lo cual acelera proyectos y da trazabilidad a auditorías. :contentReference[oaicite:4]{index=4}

### 3) Arranque verificado (secure/verified boot)
La cadena de confianza típica: (1) **Root of Trust (RoT)** en ROM o eFuses valida el siguiente eslabón; (2) **MCUboot** verifica firmas de las imágenes de **TF-M (S)** y de la **aplicación (NS)** antes de ceder control; (3) TF-M levanta el SPM, habilita particiones y expone APIs PSA. MCUboot soporta *slots* A/B, *image swap* y **protección anti-rollback** mediante un **security counter** asociado a la imagen, almacenado en NVM confiable; esto evita que un atacante “rebaje” firmware a una versión vulnerable. :contentReference[oaicite:5]{index=5}

Buenas prácticas aquí incluyen: separar llaves para firmar **S** y **NS** (políticas distintas, revocación independiente), proteger la clave privada del firmante (HSM en servidor de build), usar **compilación reproducible** y sellar metadatos (versionado, hash, *TLV protected*). Documentación de vendors y de TF-M amplía detalles de *rollback* y *image_ok* flags según flujo de *swap*. :contentReference[oaicite:6]{index=6}

### 4) Actualizaciones seguras en campo (OTA) con SUIT
En IoT, **parchear es sobrevivir**. Para lograrlo de forma interoperable, el IETF definió **SUIT** (**Software Updates for Internet of Things**): un **modelo de manifiesto** y una **arquitectura** para describir qué instalar, dónde, cómo verificar, qué requisitos debe cumplir el dispositivo y qué políticas seguir (por ejemplo, *rollback prevention*). Adoptar SUIT estandariza metadatos y firmas en lugar de esquemas ad-hoc frágiles. :contentReference[oaicite:7]{index=7}

En la práctica: el backend genera un **manifiesto SUIT** firmado que referencia artefactos (imágenes S/NS, *delta updates*, recursos), el bootloader/actualizador verifica firma y *preconditions*, y sólo entonces conmuta imágenes (idealmente con *failsafe* A/B). Integrar **PSA Firmware Update API** sobre TF-M ayuda a mantener coherencia de APIs entre dispositivos y a encajar con auditorías PSA. :contentReference[oaicite:8]{index=8}

### 5) Diseño seguro, ciclo de vida y hardening
Además del hardware y las APIs, el proyecto necesita disciplina de ingeniería:

- **Modelado de amenazas** específico del producto (qué atacantes, qué activos: claves, credenciales, telemetría).  
- **Mínimo privilegio**: la app NS no debería nunca tocar secretos; las particiones S deben ser **lo más pequeñas posible**.  
- **Gestión de claves**: inyectar o derivar claves de dispositivo en fabricación, protegerlas con zonas seguras/NVM confiable.  
- **Seguridad de la cadena de suministro**: firmas en el repositorio, revisiones, SBOM, verificación de dependencias.  
- **Telemetría y attestation**: usar **PSA Initial Attestation** para que el backend verifique identidad/estado antes de habilitar servicios.  
- **Pruebas y certificación**: pasar *compliance tests* de **PSA APIs** (Crypto/Storage/Attestation) y, si aplica, obtener **PSA Certified** para nivelar con requisitos de clientes/mercados. :contentReference[oaicite:9]{index=9}

**Arquitectura de referencia resumida**  
RoT (ROM) → MCUboot (verifica S/NS) → TF-M (SPM + particiones PSA) → App NS (usa PSA IPC) → SUIT para OTA con A/B y anti-rollback. Resultado: cadena de confianza de extremo a extremo, mínima exposición y actualizaciones confiables. :contentReference[oaicite:10]{index=10}

---

## Conclusiones
ARM TrustZone-M no es un “parche”, es la **base**: traza una frontera de hardware y te obliga a separar responsabilidades. Sobre ese cimiento, **TF-M** y las **PSA APIs** dan servicios seguros listos y auditables; **MCUboot** amarra integridad desde el arranque; **SUIT** estandariza el *lifecycle* de actualizaciones. Si a eso le sumas gobierno de claves, mínimo privilegio y pruebas de conformidad, obtienes firmware IoT **defendible** a lo largo de los años. ¿El costo? Un poco más de diseño y *tooling*. ¿El beneficio? Menos brechas, menor riesgo regulatorio y un producto que puedes mirar a los ojos cuando lleguen los pentesters. :contentReference[oaicite:11]{index=11}

---

## Bibliografía (IEEE)
[1] Arm Developer, “Attribution units (SAU and IDAU),” *Arm Developer Documentation*, acceso: Sep. 17, 2025. :contentReference[oaicite:12]{index=12}  
[2] TrustedFirmware.org, “Trusted Firmware-M Technical Overview (Q1-2023),” *Whitepaper/Slides*, 2023. Acceso: Sep. 17, 2025. :contentReference[oaicite:13]{index=13}  
[3] TrustedFirmware-M Docs, “Secure Partition Manager (SPM),” *Design Documentation*, acceso: Sep. 17, 2025. :contentReference[oaicite:14]{index=14}  
[4] PSA Certified, “API Certification for IoT Security,” *Webpage*, acceso: Sep. 17, 2025. :contentReference[oaicite:15]{index=15}  
[5] PSA Certified, “PSA Certified APIs Step-by-Step Compliance Guide v2.0,” *PDF*, 2023. Acceso: Sep. 17, 2025. :contentReference[oaicite:16]{index=16}  
[6] MCUboot Project, “Design of the MCUboot Bootloader,” *Docs*, acceso: Sep. 17, 2025. :contentReference[oaicite:17]{index=17}  
[7] NXP MCUXpresso, “MCUboot Design (Rollback Protection, Security Counter),” *Docs*, acceso: Sep. 17, 2025. :contentReference[oaicite:18]{index=18}  
[8] IETF, “RFC 9019: A Firmware Update Architecture for IoT Devices,” 2021. Acceso: Sep. 17, 2025. :contentReference[oaicite:19]{index=19}  
[9] IETF, “RFC 9124: A Manifest Information Model for Firmware Updates in IoT,” 2022. Acceso: Sep. 17, 2025. :contentReference[oaicite:20]{index=20}  
[10] Keil, “Using TrustZone on Armv8-M,” *Application Note APNT_291*, acceso: Sep. 17, 2025. :contentReference[oaicite:21]{index=21}

