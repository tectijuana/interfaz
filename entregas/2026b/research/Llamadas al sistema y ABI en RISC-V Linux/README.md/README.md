# Llamadas al sistema y ABI en RISC-V Linux
## Introducción
Cuando trabajas programando muy cerca del hardware (a bajo nivel), es súper importante entender cómo se comunican tus programas con el sistema operativo. En la arquitectura RISC-V, esta "frontera" se maneja principalmente con dos cosas: la ABI (que es básicamente el reglamento de cómo se usan los componentes internos) y las llamadas al sistema o syscalls. Saber exactamente cómo se pasan los datos, qué partes de la memoria se deben cuidar al saltar de una función a otra y qué comando hace que el sistema operativo tome el control, es clave si quieres escribir un código en ensamblador que no falle o si te toca revisar errores directo en el corazón del sistema (el kernel). Lo chido de RISC-V, a diferencia de lo que pasa con x86 o ARM, es que nació como un proyecto abierto y modular, pero su reglamento para Linux está tan bien estandarizado que asegura que tus programas funcionen igual de bien tanto en sistemas de 32 como de 64 bits.

## La Interfaz de Binario de Aplicación (ABI) en RISC-V
La ABI de RISC-V define la convención de llamadas (calling convention), la distribución de los registros del procesador y la gestión de la pila (stack). El conjunto de instrucciones base (RV32I/RV64I) cuenta con 32 registros de propósito general (del x0 al x31), a los cuales la ABI asigna nombres nemónicos según su función.

Los registros se dividen principalmente en dos categorías:

- Caller-saved (Preservados por el llamante): El valor original del registro puede ser sobrescrito por la función llamada. Si el llamante necesita el valor después de la llamada, debe guardarlo en la pila antes de ejecutar call/jalr.

- Callee-saved (Preservados por el llamado): La función invocada debe garantizar que, al retornar, estos registros contengan los mismos valores que tenían antes de la llamada. Si los usa, debe respaldarlos en la pila y restaurarlos antes de ejecutar ret.

## Clasificación de Registros según la ABI
En la siguiente tabla se detalla el uso estandarizado de los 32 registros en la ABI de RISC-V para Linux:

| Registro | Nombre ABI | Uso | Preservado por |
| :--- | :--- | :--- | :--- |
| x0 | zero | Constantemente 0 (Hardware) | N/A |
| x1 | ra | Dirección de retorno (Return Address) | Caller |
| x2 | sp | Puntero de pila (Stack Pointer) | Callee |
| x3 | gp | Puntero global (Global Pointer) | N/A |
| x4 | tp | Puntero de hilo (Thread Pointer) | N/A |
| x5 - x7 | t0 - t2 | Registros temporales | Caller |
| x8 | s0 / fp | Registro guardado 0 / Puntero de marco (Frame Pointer) | Callee |
| x9 | s1 | Registro guardado 1 | Callee |
| x10 - x11 | a0 - a1 | Argumentos de función / Valores de retorno | Caller |
| x12 - x17 | a2 - a7 | Argumentos de función | Caller |
| x18 - x27 | s2 - s11 | Registros guardados | Callee |
| x28 - x31 | t3 - t6 | Registros temporales | Caller |

## Ejemplo Práctico: Programa "Hola Mundo" en Ensamblador RISC-V (RV64)
El siguiente código fuente en GNU Assembler (as) realiza la escritura de una cadena en la salida estándar (stdout) y finaliza la ejecución de forma limpia usando las llamadas al sistema sys_write (64) y sys_exit (93).

### Programa: hola.s
### Compilación: riscv64-linux-gnu-as hola.s -o hola.o
### Enlace:      riscv64-linux-gnu-ld hola.o -o hola

.section .rodata
msg:
    .string "Hola mundo desde RISC-V Linux!\n"
    len = . - msg

.section .text
.globl _start

_start:
    sys_write(int fd, const char *buf, size_t count) 
    li a7, 64          # Syscall number: sys_write (64 en RISC-V Linux)
    li a0, 1           # Argumento 1 (a0): fd = 1 (stdout)
    la a1, msg         # Argumento 2 (a1): buf = dirección de 'msg'
    li a2, len         # Argumento 3 (a2): count = longitud de la cadena
    ecall              # Invocar al kernel

## Análisis
La verdad es que se nota una gran diferencia. x86_64 viene arrastrando un montón de equipaje del pasado con un montón de instrucciones superenredadas y varias formas de hacer lo mismo, como cuando te confundes entre usar syscall o int 0x80. En cambio, el reglamento (la ABI) de RISC-V destaca por ser ultrasencillo, limpio y directo al grano. Al revisar su diseño, te das cuenta de que está pensado fríamente para que el chip trabaje lo menos posible:Los mismos registros para todo: Usa el mismo grupito de cajones (los registros de a0 a a7) tanto para pasarle datos a una función normal como para hacer una llamada al sistema. Esto es genial porque el compilador no tiene que estar moviendo datos de un lado a otro a cada rato con la instrucción mv.Una sola orden para cambiar de modo: En lugar de tener mil comandos diferentes como en otras arquitecturas, aquí solo usas ecall. Esto unifica el salto entre el modo de usuario normal y el modo de administrador (Supervisor), lo que hace la vida mucho más fácil a quienes diseñan procesadores abiertos.

Los desafíos :No todo es perfecto. RISC-V no tiene un comando único para cargar una dirección de memoria completa de 64 bits de un solo golpe. Por eso, el código en ensamblador casi siempre se ve obligado a usar parejas de instrucciones (como auipc con addi, o la ayuda de la). Esto significa que, como programadores, nos toca entender muy bien cómo se va armando el código binario.

## Conclusiones
En resumen, la ABI de RISC-V para Linux logra un balance perfecto: hace que los programas normales corran rapidísimo y, al mismo tiempo, cuida la seguridad cuando el código tiene que saltar a la parte protegida del sistema (el kernel). El hecho de que siempre se usen los registros de a0 a a7 para los datos y una sola orden como ecall hace que todo este flujo a bajo nivel sea predecible, limpio y súper eficiente. Para cualquiera de nosotros que quiera dedicarse en serio a la ingeniería de software, ya sea para crear compiladores, arreglar errores directo en el kernel o programar chips en sistemas embebidos, dominar estas reglas no es opcional: es un requisito obligatorio.

