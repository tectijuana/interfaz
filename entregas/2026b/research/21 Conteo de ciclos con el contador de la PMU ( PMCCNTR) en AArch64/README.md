Optimización y microarquitectura
Conteo de ciclos con el contador de la PMU ( PMCCNTR) en AArch64
1. Introducción y Fundamentos de la PMU
La Unidad de Monitoreo de Rendimiento (PMU) es una característica fundamental, aunque opcional, dentro de la arquitectura ARMv8-A. A nivel de hardware, permite a los desarrolladores acceder a una visibilidad sin precedentes del estado interno de los procesadores obteniendo métricas sobre los ciclos de reloj ejecutados, las instrucciones completadas, la predicción de saltos (branches), y los aciertos o fallos en memoria caché.
Es fundamental distinguir la PMU de la AMU (Activity Monitors Unit). Mientras que la AMU (introducida de manera más robusta en revisiones como ARMv8.4) proporciona contadores de solo lectura, persistentes y diseñados para el monitoreo de energía y frecuencias (telemetría a nivel de sistema operativo), la PMU está pensada para la extracción forense y profunda de métricas microarquitectónicas para ajustar la eficiencia del software.
2. Profundidad técnica del Registro PMCCNTR_EL0
En la arquitectura de 64 bits (AArch64), el núcleo del conteo de ciclos recae sobre el registro del sistema PMCCNTR_EL0 (Performance Monitors Cycle Counter).
Comportamiento del contador: Es un registro de 64 bits diseñado para mantener el conteo de ciclos del procesador.
Configuración de Escalado (Prescaling): No siempre cuenta cada ciclo individualmente. Dependiendo de los valores configurados en el registro principal de control PMCR_EL0 (específicamente sus bits de configuración D y LC), PMCCNTR puede ajustarse para incrementar en cada ciclo de reloj del procesador o escalar para incrementar solo una vez cada 64 ciclos de reloj.
Gestión de Energía: Una particularidad importante al optimizar microarquitectura es el estado del procesador. Según las especificaciones de ARM, si el procesador detiene sus relojes a causa de instrucciones como WFI (Wait For Interrupt) o WFE (Wait For Event), la continuidad del incremento en PMCCNTR pasa a tener un comportamiento catalogado como arquitectónicamente impredecible (CONSTRAINED UNPREDICTABLE).
3. La Barrera del Espacio de Usuario y Permisos (EL0)
A diferencia de arquitecturas antiguas, la familia ARMv8-A permite de manera nativa que el código en espacio de usuario (Nivel de Excepción EL0) pueda leer los contadores de la PMU. Sin embargo, por defecto y por seguridad, esto está bloqueado.
Para que un programa escrito en C++ o ensamblador pueda acceder a este registro en Linux, se deben cumplir pasos estrictos:
Un módulo del kernel debe ejecutarse previamente con privilegios superiores para sobreescribir el registro de control PMUSERENR_EL0 y permitir explícitamente el acceso desde el modo usuario.
Posteriormente, se deben activar los eventos o los contadores deseados alterando el registro PMCNTENSET_EL0 para iniciar la contabilización de ciclos.
4. Metodologías de Extracción de Datos
Existen dos rutas críticas para el perfilado de software en Linux:
A. Acceso Directo por Ensamblador (Baja Latencia)
Este método involucra usar código en línea para leer directamente de los registros de hardware y resulta crítico para medir porciones muy pequeñas de algoritmos donde una llamada al sistema arruinaría las métricas.
Se utiliza la instrucción clásica: asm volatile("mrs %0, pmccntr_el0" : "=r" (r)); para cargar el valor de los ciclos actuales.
La importancia del "Out-of-Order Execution": Debido a que los procesadores ARM modernos ejecutan instrucciones fuera de orden temporal para mejorar la velocidad, leer un contador directamente puede resultar en datos irreales si instrucciones previas no han terminado. Por eso se recomienda utilizar una Barrera de Sincronización de Instrucciones antes de configurar eventos del PMU y antes de leer el contador. Esto fuerza al pipeline del procesador a limpiar o completar las instrucciones pendientes antes de entregar el registro de tiempo.
B. Infraestructura API perf_event_open (Confiabilidad y Seguridad)
Para aplicaciones donde la seguridad, interoperabilidad del kernel y estabilidad son la máxima prioridad, se opta por no utilizar ensamblador puro ni crear módulos del kernel.
Consiste en usar las rutinas del sistema a través de un file descriptor utilizando la macro de abstracción syscall(__NR_perf_event_open, ...).
Al declarar configuraciones estructuradas bajo atributos como PERF_TYPE_HARDWARE y PERF_COUNT_HW_CPU_CYCLES, el kernel gestiona el acceso. Esta es la misma capa de abstracción empleada por herramientas potentes de Linux como perf y OProfile. 
En Windows, plataformas como el Windows Performance Toolkit implementan abstracciones conceptualmente equivalentes mediante perfiles del sistema para rastrear tasas CPI y desajustes de rama usando estos mismos fundamentos.
5. El Riesgo de los Entornos de Emulación
Al investigar fallas comunes reportadas en el conteo de ciclos de AArch64, se destaca un error generalizado: Intentar realizar la optimización de PMU dentro de un emulador como QEMU.

**Bibliografía**

[1] ARM Limited, "PMCCNTR_EL0, Performance Monitors Cycle Counter," *ARM Architecture Reference Manual*, dic. 2024. [En línea]. Disponible en: https://support.arm.com/documentation/ddi0601/2024-12/External-Registers/PMCCNTR-EL0--Performance-Monitors-Cycle-Counter.

[2] Linux Kernel Documentation, "Activity Monitors Unit (AMU)," *kernel.org*. [En línea]. Disponible en: https://docs.kernel.org/arch/arm64/amu.html.

[3] Z. Sun, "How to Use Performance Monitor Unit (PMU) of 64-bit ARMv8-A in Linux," *zhiyisun.github.io*, mar. 2016. [En línea]. Disponible en: https://zhiyisun.github.io/2016/03/02/How-to-Use-Performance-Monitor-Unit-(PMU)-of-64-bit-ARMv8-A-in-Linux.html.

[4] Microsoft, "Recording PMU Events," *Windows Hardware Developer*, [En línea]. Disponible en: https://learn.microsoft.com/es-es/windows-hardware/test/wpt/recording-pmu-events.

[5] Stack Overflow, "How do I use hardware performance counters in AArch64 assembly?," *stackoverflow.com*, abr. 2017. [En línea]. Disponible en: https://stackoverflow.com/questions/43564391/how-do-i-use-hardware-performance-counters-in-aarch64-assembly.
QEMU opera bajo un modelo netamente funcional y rápido de traducción binaria orientada a nano-segundos, y no provee una infraestructura real de eventos PMU ni un modelo de tubería (pipeline) de microarquitectura preciso.
En entornos emulados como QEMU, las ejecuciones ocurren de manera secuencial abstracta y el conteo de "ciclos" devuelto a menudo es el resultado de escalar divisiones arbitrarias del tiempo del sistema huésped.
Por lo tanto, la optimización profunda del IPC (Instrucciones Por Ciclo) o los aciertos a memoria caché solo es ejecutada sobre silicio físico o empleando simuladores comerciales dedicados de microarquitectura orientados a ciclos.
