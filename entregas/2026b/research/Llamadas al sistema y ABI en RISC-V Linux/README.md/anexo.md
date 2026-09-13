### Prompts utilizados:

- información detallada sobre cómo se dividen los registros en RISC-V (cuáles se borran y cuáles se guardan al saltar de una función a otra), y cómo funciona exactamente el comando ecall para llamar al sistema operativo. También le pedí un código de ejemplo de "Hola Mundo" en ensamblador de 64 bits que usara los comandos para escribir en pantalla y cerrar el programa.

- Le pedí una tabla completa con los 32 registros de RISC-V, detallando para qué sirve cada uno en Linux y quién tiene la obligación de guardarlos.

### Herramientas utilizadas:

- Google Gemini

### Cambios y validación:

-El programa que me dio al principio venía con un error, ya que usaba el número 1 para mandar a escribir en pantalla (que es lo que se usa en otras arquitecturas como x86 o ARM). Lo investigué y lo cambié al estándar real de RISC-V en Linux, que usa el 64 para escribir en pantalla y el 93 para salir del programa.

- Para estar seguro de que el paso de datos y el manejo de la memoria (la pila) funcionaban bien, compilé el código y lo puse a correr usando un simulador llamado QEMU y las herramientas de compilación de RISC-V.

- Revisé renglón por renglón la tabla de registros que me dio la IA para asegurarme de que coincidiera perfectamente con el manual oficial de RISC-V.

### Reflexión personal:
- La IA facilitó la organización inicial de la tabla de la ABI y estructuró el código ensamblador de forma muy ordenada. Sin embargo, asignó erróneamente los números de llamadas al sistema de la arquitectura x86_64. Esto me enseñó que las convenciones de llamadas y los números de syscall cambian drásticamente entre arquitecturas de procesador, por lo que siempre es indispensable corroborar los datos contra los encabezados oficiales del kernel (asm/unistd.h).

### Fecha: 2026-09-18

### Plataforma utilizada: Ubuntu Linux (x86_64) con riscv64-linux-gnu-as, riscv64-linux-gnu-ld y emulación mediante QEMU (RV64).

### Bibliografias
D. A. Patterson y J. L. Hennessy, Estructura y diseño de computadores: La interfaz software/hardware (Edición RISC-V), 1.ª ed. en español. Reverté, 2019. [En línea]. Disponible en: https://www.reverte.com/libro/estructura-y-diseno-de-computadores-risc-v_102008/

Linux Kernel Organization, RISC-V Architecture Documentation, The Linux Kernel Archives, 2024. Accedido: 18 de septiembre de 2026. [En línea]. Disponible en: https://docs.kernel.org/arch/riscv/index.html

S. Scotws, RISC-V System Calls Reference and Examples, GitHub Repository. Accedido: 18 de septiembre de 2026. [En línea]. Disponible en: https://github.com/scotws/RISC-V-tests/blob/master/docs/riscv_howto_syscalls.md

P. Dabbelt, M. Clark, y A. Bradbury, RISC-V Assembly Programmer's Manual, RISC-V International. Accedido: 18 de septiembre de 2026. [En línea]. Disponible en: https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md
