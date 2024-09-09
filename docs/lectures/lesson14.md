### CAPÍTULO 13: **Virtualización y Control de Hipervisores en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a la virtualización en ARM64](#introducción-a-la-virtualización-en-arm64)
2. [Modos de ejecución y el nivel EL2 (Hypervisor)](#modos-de-ejecución-y-el-nivel-el2-hypervisor)
3. [Hipervisor y manejo de máquinas virtuales](#hipervisor-y-manejo-de-máquinas-virtuales)
4. [Configuración del entorno de virtualización](#configuración-del-entorno-de-virtualización)
5. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a la virtualización en ARM64

La **virtualización** permite ejecutar múltiples sistemas operativos sobre una misma plataforma de hardware, cada uno de ellos en su propio entorno aislado, llamado **máquina virtual**. En ARM64, la virtualización es compatible a nivel de hardware, lo que permite a un **hipervisor** controlar y gestionar varias máquinas virtuales, asignando recursos como la CPU, memoria y dispositivos de E/S.

En el **Raspberry Pi 5**, la virtualización es una característica poderosa que permite experimentar con diferentes sistemas operativos y arquitecturas, ofreciendo un entorno flexible para el desarrollo y la simulación de sistemas embebidos y servicios en la nube.

---

## Modos de ejecución y el nivel EL2 (Hypervisor)

En ARM64, la arquitectura define varios **niveles de ejecución**, cada uno con diferentes privilegios y acceso a los recursos del sistema. Para la virtualización, ARM64 introduce el nivel de ejecución **EL2**, conocido como **modo Hypervisor**. El hipervisor en EL2 tiene control sobre las máquinas virtuales que se ejecutan en EL1 (nivel de sistema operativo) y puede gestionar recursos como la memoria, la CPU y los dispositivos de E/S.

### Modos de ejecución relacionados con la virtualización:

1. **EL0 (User mode)**: Modo de ejecución para aplicaciones de usuario en una máquina virtual.
2. **EL1 (Kernel mode)**: Modo de ejecución del sistema operativo dentro de la máquina virtual.
3. **EL2 (Hypervisor mode)**: Nivel de ejecución del hipervisor, con control total sobre las máquinas virtuales.
4. **EL3 (Secure monitor mode)**: Modo de supervisión segura, utilizado para gestionar funciones de seguridad y TrustZone, pero no directamente relacionado con la virtualización.

### Transiciones entre niveles:

El hipervisor en EL2 puede crear, destruir y gestionar máquinas virtuales que se ejecutan en EL1, mientras que cada máquina virtual tiene acceso a sus propias aplicaciones en EL0.

---

## Hipervisor y manejo de máquinas virtuales

Un **hipervisor** es un software que corre en **EL2** y que administra las máquinas virtuales en un sistema. Controla el acceso al hardware físico y distribuye los recursos del sistema entre las máquinas virtuales, asegurando que cada una opere de manera independiente y segura.

### Tipos de hipervisores:

1. **Hipervisor tipo 1**:
   - Corre directamente sobre el hardware físico, sin un sistema operativo subyacente.
   - Proporciona alto rendimiento y un control más directo de los recursos.
   - Ejemplo: KVM (Kernel-based Virtual Machine) en ARM64.

2. **Hipervisor tipo 2**:
   - Corre sobre un sistema operativo huésped y proporciona virtualización a nivel de software.
   - Es más fácil de implementar pero tiene más sobrecarga debido a la capa adicional.
   - Ejemplo: QEMU con soporte de virtualización.

### Funciones del hipervisor:

1. **Asignación de recursos**: El hipervisor controla cuántos núcleos de CPU, cuánta memoria y qué dispositivos de E/S puede utilizar cada máquina virtual.
2. **Aislamiento**: Garantiza que cada máquina virtual esté aislada de las demás, impidiendo el acceso no autorizado a los recursos.
3. **Control de acceso a hardware**: Administra el acceso a dispositivos físicos, como puertos de E/S, memoria y dispositivos de red.

### Ejemplo básico de hipervisor en ARM64:

El siguiente ejemplo muestra cómo se puede configurar un entorno básico de hipervisor en ARM64 utilizando EL2.

```assembly
.section .text
.global _start

_start:
    // Entrar en modo EL2 (Hypervisor)
    mov x0, #0x3C5        // Cargar un valor para el ELR (Exception Link Register)
    msr ELR_EL2, x0       // Establecer el valor del ELR en EL2

    // Inicializar el hipervisor
    mov x0, #0x1          // Habilitar hipervisor
    msr HCR_EL2, x0       // Establecer el Hypervisor Configuration Register

    // Saltar al sistema operativo de la máquina virtual en EL1
    eret                  // Regresar al EL1 para iniciar la máquina virtual
```

Este código básico configura el modo **EL2** y habilita la ejecución del hipervisor, que puede controlar una máquina virtual en **EL1**.

---

## Configuración del entorno de virtualización

Para habilitar la virtualización en el **Raspberry Pi 5**, es necesario realizar varios pasos de configuración, tanto a nivel de hardware como de software. Esto incluye habilitar el soporte de **KVM** (si se utiliza Linux) o la instalación de un hipervisor como **QEMU**.

### Pasos para configurar un entorno de virtualización:

1. **Habilitar KVM**:
   - Si utilizas Linux en el Raspberry Pi 5, puedes habilitar el soporte de KVM para aprovechar las capacidades de virtualización de ARM64. KVM (Kernel-based Virtual Machine) permite crear y gestionar máquinas virtuales desde el kernel de Linux.
   
   ```bash
   sudo modprobe kvm    # Cargar el módulo de KVM
   ```

2. **Instalar QEMU**:
   - **QEMU** es un emulador y hipervisor de código abierto que permite ejecutar sistemas operativos completos dentro de máquinas virtuales. Para instalar QEMU en un Raspberry Pi 5:
   
   ```bash
   sudo apt-get install qemu qemu-kvm
   ```

3. **Crear una máquina virtual**:
   - Una vez que KVM y QEMU están configurados, puedes crear y ejecutar una máquina virtual con un sistema operativo específico (como una distribución de Linux o Android).

   ```bash
   qemu-system-aarch64 -m 2048 -cpu cortex-a53 -machine virt -enable-kvm -nographic -kernel path_to_kernel -append "console=ttyAMA0"
   ```

4. **Administración de máquinas virtuales**:
   - Utiliza herramientas como **virsh** o interfaces gráficas como **virt-manager** para gestionar las máquinas virtuales de manera más fácil.

---

## Ejercicios prácticos

### Ejercicio 1: Configuración básica de un hipervisor

Escribe un programa en ensamblador que configure el hipervisor en **EL2** y luego salte al modo **EL1** para ejecutar un sistema operativo en una máquina virtual.

#### Solución en ensamblador:

```assembly
.section .text
.global _start

_start:
    // Configurar EL2 (Hypervisor mode)
    mov x0, #0x3C5        // Cargar el valor del ELR (Exception Link Register)
    msr ELR_EL2, x0       // Establecer el valor del ELR en EL2

    // Inicializar el hipervisor
    mov x0, #0x1          // Habilitar el modo hipervisor
    msr HCR_EL2, x0       // Configurar el Hypervisor Configuration Register

    // Saltar al sistema operativo en EL1 (máquina virtual)
    eret                  // Regresar al EL1 para iniciar la máquina virtual
```

### Ejercicio 2: Configuración de KVM en Raspberry Pi 5

Instala KVM y QEMU en un Raspberry Pi 5, luego crea y ejecuta una máquina virtual con una distribución de Linux ligera. Comprueba que KVM esté habilitado y que la máquina virtual esté utilizando la virtualización por hardware.

#### Instrucciones:

1. Habilita el soporte de KVM en tu kernel de Linux:
   
   ```bash
   sudo modprobe kvm
   ```

2. Instala QEMU:

   ```bash
   sudo apt-get install qemu qemu-kvm
   ```

3. Crea una máquina virtual:

   ```bash
   qemu-system-aarch64 -m 2048 -cpu cortex-a53 -machine virt -enable-kvm -nographic -kernel path_to_kernel -append "console=ttyAMA0"
   ```

4. Verifica que KVM esté habilitado usando el siguiente comando:

   ```bash
   kvm-ok
   ```

---

## Resumen

En este capítulo, exploramos las capacidades de **virtualización** en ARM64 y cómo configurar un **hipervisor** para manejar múltiples máquinas virtuales. Estas herramientas son esenciales para aprovechar al máximo el hardware del **Raspberry Pi 5**, permitiendo ejecutar diversos sistemas operativos de forma aislada en un único dispositivo.
