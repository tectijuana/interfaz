# Anexo: Declaración de uso de IA

## Herramienta utilizada

- **Claude** (Anthropic), usado como asistente de redacción y para generar y validar los ejemplos de código en ensamblador.

## Prompts utilizados

1. "Ayúdame creando una investigación técnica individual del tema 'Arreglos multidimensionales: Cálculo de índices y recorrido en ensamblador', es para un trabajo universitario."
2. "No quiero un archivo, solo que sea para copiar y pegar (lo agregaré a un archivo README.md en GitHub)."
3. Le compartí el enlace de un trabajo ya aprobado del repositorio del curso y pedí que el formato quedara igual (estructura de encabezados, estilo de bibliografía en IEEE).
4. "¿Lo puedes hacer para solo copiar y pegar una sola vez?" (para resolver el problema de los bloques de código anidados al copiar todo el documento junto).
5. Pedí una descripción breve del PR en primera persona para el formulario de entrega, y luego pedí que fuera "un poco más breve".
6. "El ejemplo de ensamblador usa sintaxis y registros de x86 (`ecx`, `edx`, `esi`), pero el curso trabaja con ARM64/RISC-V. Debes reescribirlo con la arquitectura del curso" — esta corrección la hice después de que mi profesor señaló el error en la revisión del PR.

## Cambios y mejoras hechos tras revisión crítica

- **Error de arquitectura detectado por el profesor:** la primera versión de los ejemplos de código usaba sintaxis y registros de x86 (`ecx`, `edx`, `esi`, modo de direccionamiento SIB), lo cual no corresponde a la arquitectura vista en el curso (ARM64/RISC-V). Verifiqué el modo de direccionamiento correcto de AArch64 (registro-offset con escalado `LSL`) contra documentación oficial de Arm antes de aceptar la reescritura, y confirmé que la sintaxis (`LDR w0, [x3, x5, LSL #2]`, uso de `w`/`x` para 32/64 bits, `B.GE` en vez de `jge`) fuera consistente con AArch64 real y no una mezcla inventada.
- Revisé que la fórmula de cálculo de offset (`i × C + j`) fuera independiente de la arquitectura, ya que es un concepto matemático y no debía cambiar entre versiones; solo se corrigió la traducción a instrucciones.
- Ajusté el formato del documento (encabezados, orden de secciones, estilo de bibliografía IEEE) para que coincidiera con el de un trabajo ya aprobado del repositorio, en vez de usar una estructura genérica de reporte académico.
- Acorté la descripción del PR que la IA generó inicialmente porque resultaba demasiado larga para el formulario de entrega.

## Referencias adicionales consultadas (fuera de las citadas en el README)

- Documentación de direccionamiento de Arm (A64 Instruction Set Architecture) para confirmar la sintaxis exacta de `LDR`/`STR` con registro-offset escalado.
- Artículos independientes sobre AArch64 (Think In Geek, guías de registros w/x) para contrastar que la explicación de la IA sobre `LSL` como multiplicación por potencias de dos fuera correcta y no solo plausible.

## Reflexión personal

El error más importante que encontré fue que la IA, por defecto, generó los ejemplos en x86 en lugar de la arquitectura del curso — un recordatorio de que hay que revisar con cuidado que el código generado corresponda realmente al contexto pedido y no solo a lo "más común" en ejemplos genéricos de internet. Aprendí que el concepto de cálculo de índices (`offset = i×C + j`) es el mismo sin importar la arquitectura, pero que la forma de aprovecharlo a nivel de hardware cambia bastante: en x86 se usa el modo SIB con instrucciones como `imul`, mientras que en ARM64 el mismo resultado se logra con `LDR` y un desplazamiento `LSL` dentro de la misma instrucción de carga. Esto me ayudó a entender mejor por qué es importante distinguir entre la lógica matemática de un algoritmo y su implementación específica en una arquitectura de procesador.
