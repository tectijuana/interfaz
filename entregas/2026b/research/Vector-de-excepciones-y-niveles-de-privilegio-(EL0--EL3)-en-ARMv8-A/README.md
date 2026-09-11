# Vector de Excepciones y Niveles de Privilegio (EL0–EL3) en ARMv8-A

Guía de referencia sobre el modelo de privilegios y el manejo de excepciones en la arquitectura **ARMv8-A**: los cuatro niveles de ejecución (*Exception Levels*, EL0–EL3), cómo y cuándo se transita entre ellos, y la estructura de la **tabla de vectores de excepción** que el procesador consulta cada vez que ocurre una excepción.

## Tabla de contenidos

- [1. Introducción](#1-introducción)
- [2. Niveles de privilegio (Exception Levels)](#2-niveles-de-privilegio-exception-levels)
  - [2.1 EL0 — Aplicación de usuario](#21-el0--aplicación-de-usuario)
  - [2.2 EL1 — Kernel del sistema operativo](#22-el1--kernel-del-sistema-operativo)
  - [2.3 EL2 — Hipervisor](#23-el2--hipervisor)
  - [2.4 EL3 — Monitor seguro / Firmware](#24-el3--monitor-seguro--firmware)
- [3. Estados de seguridad: Secure vs Non-secure](#3-estados-de-seguridad-secure-vs-non-secure)
- [4. Tipos de excepción](#4-tipos-de-excepción)
- [5. La tabla de vectores de excepción](#5-la-tabla-de-vectores-de-excepción)
  - [5.1 Registros base (VBAR_ELx)](#51-registros-base-vbar_elx)
  - [5.2 Las 16 entradas de la tabla](#52-las-16-entradas-de-la-tabla)
- [6. Ciclo de vida de una excepción](#6-ciclo-de-vida-de-una-excepción)
- [7. Registros clave por nivel](#7-registros-clave-por-nivel)
- [8. Reglas de transición entre niveles](#8-reglas-de-transición-entre-niveles)
- [9. Referencias](#9-referencias)

## 1. Introducción

ARMv8-A organiza la ejecución del software en **niveles de privilegio jerárquicos**, llamados *Exception Levels* (EL). Cuanto mayor es el número, mayor es el privilegio:

```
EL3  ─────────  Máximo privilegio (Secure Monitor / Firmware)
EL2  ─────────  Hipervisor
EL1  ─────────  Sistema operativo (kernel)
EL0  ─────────  Aplicaciones de usuario (mínimo privilegio)
```

El procesador cambia de nivel **únicamente a través de excepciones**: nunca se "salta" libremente de un EL a otro por código normal. Subir de nivel (EL0→EL1, EL1→EL2, etc.) ocurre al tomar una excepción; bajar de nivel ocurre al ejecutar la instrucción `ERET` (*Exception Return*).

## 2. Niveles de privilegio (Exception Levels)

### 2.1 EL0 — Aplicación de usuario

- Nivel de **menor privilegio**, donde corren los procesos de usuario.
- No puede acceder directamente a hardware, MMU, ni registros de control del sistema.
- Cualquier necesidad de servicio del sistema (I/O, memoria, etc.) se solicita mediante `SVC` (Supervisor Call), generando una excepción hacia EL1.

### 2.2 EL1 — Kernel del sistema operativo

- Nivel donde se ejecuta el **kernel** (Linux, un RTOS, etc.).
- Controla la MMU, tablas de páginas, interrupciones y planificación de procesos.
- Gestiona las excepciones que llegan desde EL0 (syscalls, fallos de página, etc.).
- Si existe un hipervisor, EL1 corre "virtualizado" bajo EL2.

### 2.3 EL2 — Hipervisor

- Nivel opcional, presente solo en sistemas con virtualización.
- Ejecuta el **hipervisor** (KVM, Xen, etc.), que gestiona múltiples máquinas virtuales, cada una con su propio SO en EL1/EL0.
- Puede interceptar y controlar el acceso de EL1 a ciertos recursos (traps de virtualización).
- Introduce registros propios como `HCR_EL2` (Hypervisor Configuration Register).

### 2.4 EL3 — Monitor seguro / Firmware

- Nivel de **máximo privilegio** en el sistema.
- Ejecuta el **Secure Monitor** (p. ej. ARM Trusted Firmware, `BL31`), que arbitra el cambio entre el mundo **Secure** y **Non-secure** (TrustZone).
- Suele ser el primer código que corre al encender el chip (junto con el bootloader) y configura el sistema antes de ceder control a EL2/EL1.
- Se accede típicamente mediante la instrucción `SMC` (Secure Monitor Call).

## 3. Estados de seguridad: Secure vs Non-secure

Independientemente del EL, ARMv8-A (con **TrustZone**) añade una dimensión ortogonal: el **estado de seguridad**.

| Estado | ELs disponibles | Uso típico |
|---|---|---|
| **Secure**     | S-EL0, S-EL1, EL3 | Trusted OS, gestión de claves, TEE (*Trusted Execution Environment*) |
| **Non-secure** | EL0, EL1, EL2     | SO normal, hipervisor, aplicaciones |

EL3 es el único nivel que puede moverse libremente entre ambos mundos, ya que actúa como árbitro entre ellos.

## 4. Tipos de excepción

| Tipo | Descripción | Causa típica |
|---|---|---|
| **Synchronous** | Ocurre como resultado directo de la instrucción en ejecución | `SVC`, `HVC`, `SMC`, fallo de página, instrucción no definida, acceso desalineado |
| **IRQ** | Interrupción normal (enmascarable) | Periféricos, temporizadores |
| **FIQ** | Interrupción rápida (enmascarable, mayor prioridad) | Eventos de baja latencia |
| **SError** | Error del sistema (asíncrono) | Errores de bus, fallos de ECC/paridad |

## 5. La tabla de vectores de excepción

Cada Exception Level que puede recibir excepciones (EL1, EL2, EL3) tiene su **propia tabla de vectores**, con un tamaño fijo de **2 KB (0x800 bytes)**, dividida en **16 entradas de 0x80 bytes** cada una.

### 5.1 Registros base (VBAR_ELx)

La dirección base de la tabla se define en el registro:

- `VBAR_EL1` — tabla de vectores para excepciones tomadas en EL1
- `VBAR_EL2` — tabla de vectores para excepciones tomadas en EL2
- `VBAR_EL3` — tabla de vectores para excepciones tomadas en EL3

> EL0 **no tiene** tabla de vectores propia: toda excepción originada en EL0 se maneja en el `VBAR_ELx` del nivel al que se sube (normalmente EL1).

### 5.2 Las 16 entradas de la tabla

La tabla se organiza en **4 grupos** (según el origen de la excepción) de **4 entradas** cada uno (según el tipo de excepción):

| Offset | Grupo (origen) | Sync | IRQ | FIQ | SError |
|---|---|---|---|---|---|
| `0x000`–`0x180` | **Current EL, con SP_EL0** (usando el stack pointer EL0) | `0x000` | `0x080` | `0x100` | `0x180` |
| `0x200`–`0x380` | **Current EL, con SP_ELx** (usando el stack pointer propio del nivel) | `0x200` | `0x280` | `0x300` | `0x380` |
| `0x400`–`0x580` | **Lower EL usando AArch64** | `0x400` | `0x480` | `0x500` | `0x580` |
| `0x600`–`0x780` | **Lower EL usando AArch32** | `0x600` | `0x680` | `0x700` | `0x780` |

Esquema visual (tabla en EL1, por ejemplo):

```
VBAR_EL1 + 0x000  ┌─────────────────────────────┐
                  │ Sync   (Current EL, SP0)     │
         + 0x080  │ IRQ    (Current EL, SP0)     │
         + 0x100  │ FIQ    (Current EL, SP0)     │
         + 0x180  │ SError (Current EL, SP0)     │
                  ├─────────────────────────────┤
         + 0x200  │ Sync   (Current EL, SPx)     │
         + 0x280  │ IRQ    (Current EL, SPx)     │
         + 0x300  │ FIQ    (Current EL, SPx)     │
         + 0x380  │ SError (Current EL, SPx)     │
                  ├─────────────────────────────┤
         + 0x400  │ Sync   (Lower EL, AArch64)   │
         + 0x480  │ IRQ    (Lower EL, AArch64)   │
         + 0x500  │ FIQ    (Lower EL, AArch64)   │
         + 0x580  │ SError (Lower EL, AArch64)   │
                  ├─────────────────────────────┤
         + 0x600  │ Sync   (Lower EL, AArch32)   │
         + 0x680  │ IRQ    (Lower EL, AArch32)   │
         + 0x700  │ FIQ    (Lower EL, AArch32)   │
         + 0x780  │ SError (Lower EL, AArch32)   │
                  └─────────────────────────────┘
```

**Notas:**
- "Current EL con SP0" solo aplica cuando el nivel actual estaba usando `SP_EL0` en vez de su propio stack pointer (poco común en la práctica del kernel).
- "Lower EL" cubre las excepciones que **suben** de nivel (p. ej. EL0→EL1 o EL1→EL2).
- Cada entrada de 0x80 bytes normalmente contiene un salto (`b`) hacia la rutina real de manejo, ya que 32 instrucciones no bastan para un *handler* completo.

## 6. Ciclo de vida de una excepción

1. Ocurre un evento (instrucción `SVC`/`HVC`/`SMC`, interrupción, fallo de memoria, etc.).
2. El procesador determina el **EL destino** (nunca se baja de nivel al tomar una excepción; como mínimo permanece en el mismo EL).
3. Se guarda el estado en los registros `ELR_ELx` (dirección de retorno) y `SPSR_ELx` (estado del procesador previo).
4. Se actualiza `ESR_ELx` con la causa exacta de la excepción (*Exception Syndrome*).
5. La CPU salta a la entrada correspondiente de la tabla en `VBAR_ELx`.
6. El software manejador (kernel, hipervisor o monitor) procesa la excepción.
7. Se ejecuta `ERET`, que restaura `PC` desde `ELR_ELx` y el estado desde `SPSR_ELx`, regresando al nivel y contexto original.

## 7. Registros clave por nivel

| Registro | Función |
|---|---|
| `ELR_EL1/EL2/EL3` | Dirección de retorno tras la excepción (*Exception Link Register*) |
| `SPSR_EL1/EL2/EL3` | Estado del procesador guardado (*Saved Program Status Register*) |
| `ESR_EL1/EL2/EL3` | Causa/síndrome de la excepción (*Exception Syndrome Register*) |
| `FAR_EL1/EL2/EL3` | Dirección de fallo, en excepciones de memoria (*Fault Address Register*) |
| `VBAR_EL1/EL2/EL3` | Dirección base de la tabla de vectores |
| `HCR_EL2` | Configuración del hipervisor (traps, virtualización) |
| `SCR_EL3` | Configuración de seguridad (Secure/Non-secure, ruteo de excepciones) |

## 8. Reglas de transición entre niveles

- **Subir de nivel:** siempre vía excepción (`SVC` → EL1, `HVC` → EL2, `SMC` → EL3, interrupciones, faults).
- **Bajar de nivel:** siempre vía `ERET`.
- Nunca se puede pasar por alto un nivel intermedio hacia arriba salvo configuración explícita de ruteo (p. ej. `SCR_EL3` puede forzar que ciertas excepciones de EL1 vayan directo a EL3).
- Cada nivel solo puede manejar excepciones de **su propio nivel o de niveles inferiores**; nunca de un nivel superior.

## 9. Referencias

- ARM® Architecture Reference Manual, *ARMv8, for ARMv8-A architecture profile* (ARM DDI 0487).
- ARM® *Learn the Architecture: AArch64 Exception Model* (developer.arm.com).
- ARM Trusted Firmware-A, documentación de diseño (BL1/BL2/BL31/BL33).

---

*Este documento es una referencia técnica de estudio, no sustituye al manual oficial de ARM para el desarrollo de software de producción.*
