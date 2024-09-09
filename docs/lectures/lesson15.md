### CAPÍTULO 14: **Optimización de Sistemas Multinúcleo en ARM64 (Raspberry Pi 5)**

---

## Contenidos
1. [Introducción a los sistemas multinúcleo en ARM64](#introducción-a-los-sistemas-multinúcleo-en-arm64)
2. [Programación multinúcleo en ARM64](#programación-multinúcleo-en-arm64)
3. [Sincronización y comunicación entre núcleos](#sincronización-y-comunicación-entre-núcleos)
4. [Balanceo de carga y paralelismo](#balanceo-de-carga-y-paralelismo)
5. [Herramientas para depuración y monitoreo](#herramientas-para-depuración-y-monitoreo)
6. [Ejercicios prácticos](#ejercicios-prácticos)

---

## Introducción a los sistemas multinúcleo en ARM64

El **Raspberry Pi 5** incorpora un procesador multinúcleo basado en la arquitectura ARM64, lo que permite ejecutar múltiples procesos en paralelo y aumentar significativamente el rendimiento del sistema. Un **sistema multinúcleo** tiene varios núcleos de procesamiento independientes, lo que facilita la ejecución simultánea de múltiples tareas.

En ARM64, cada núcleo tiene su propio conjunto de registros y puede ejecutar su propio flujo de instrucciones de forma independiente. Aprovechar estos múltiples núcleos a través de técnicas de programación paralela es esencial para maximizar el rendimiento en sistemas embebidos.

### Características clave de los sistemas multinúcleo en ARM64:

1. **Procesamiento paralelo**: Los sistemas multinúcleo permiten ejecutar múltiples procesos o hilos de manera simultánea.
2. **Independencia de núcleos**: Cada núcleo puede ejecutar instrucciones de manera independiente, aunque se pueden sincronizar para compartir tareas.
3. **Escalabilidad**: El rendimiento del sistema puede escalar mejorando la distribución de tareas entre los núcleos.

---

## Programación multinúcleo en ARM64

La **programación multinúcleo** implica distribuir tareas o procesos entre varios núcleos para mejorar el rendimiento. En ARM64, el sistema operativo o el programador pueden decidir cómo asignar las tareas a los núcleos disponibles.

### Métodos comunes de programación multinúcleo:

1. **Hilos (Threads)**:
   - Utilizar **hilos** permite que un programa divida su trabajo en múltiples subprocesos que pueden ejecutarse simultáneamente en diferentes núcleos.
   
2. **Procesos paralelos**:
   - Ejecutar varios **procesos** independientes en diferentes núcleos permite que cada uno utilice un núcleo completo sin interferir con los demás.

3. **MPI (Message Passing Interface)**:
   - Es un enfoque común para sistemas embebidos y de alto rendimiento que facilita la comunicación entre núcleos o incluso entre diferentes máquinas.

### Ejemplo de inicio de núcleos adicionales en ARM64:

El siguiente ejemplo en ensamblador muestra cómo inicializar un segundo núcleo en ARM64 y asignarle una tarea específica.

```assembly
.section .text
.global _start

_start:
    // Inicializar el núcleo secundario (núcleo 1)
    ldr x0, =0xC4000020        // Dirección del registro de encendido del núcleo
    mov x1, #0x1               // Encender el núcleo 1
    str x1, [x0]               // Activar el núcleo 1

    // Saltar a la tarea principal del núcleo 0
    b main_task0

main_task0:
    // Tarea para el núcleo 0
    // ...
    b main_task0               // Bucle infinito para el núcleo 0

main_task1:
    // Tarea para el núcleo 1
    // ...
    b main_task1               // Bucle infinito para el núcleo 1
```

Este código enciende el segundo núcleo y lo asigna a una tarea independiente, mientras que el primer núcleo sigue con su tarea principal.

---

## Sincronización y comunicación entre núcleos

En los sistemas multinúcleo, la **sincronización** y la **comunicación entre núcleos** son esenciales para coordinar el trabajo y evitar conflictos al acceder a recursos compartidos, como la memoria o dispositivos de E/S.

### Técnicas de sincronización:

1. **Spinlocks**:
   - Un mecanismo de bloqueo que permite que un núcleo "gire" (busy-wait) hasta que otro núcleo libere un recurso.
   
2. **Mutexes (Mutual Exclusion)**:
   - Los **mutexes** permiten que un núcleo bloquee un recurso hasta que termine de usarlo, asegurando que ningún otro núcleo acceda simultáneamente a ese recurso.

3. **Barriers**:
   - Las **barreras** garantizan que todos los núcleos alcancen un cierto punto de ejecución antes de continuar, asegurando que todos los núcleos estén sincronizados en ciertas tareas.

4. **Mensajería**:
   - El uso de colas de mensajes o buffers compartidos entre núcleos permite la comunicación eficiente sin interferir con la ejecución de otros núcleos.

### Ejemplo de uso de spinlock para sincronización entre núcleos:

```assembly
.section .data
    lock: .word 0            // Spinlock inicializado a 0 (disponible)

.section .text
.global _start

_start:
    // Intentar adquirir el lock
acquire_lock:
    ldr x0, =lock            // Cargar la dirección del lock
    ldxr w1, [x0]            // Leer el valor del lock (exclusivo)
    cbnz w1, acquire_lock    // Si está bloqueado, seguir intentando

    // Bloquear el lock
    mov w1, #1               // Valor de lock activo
    stxr w2, w1, [x0]        // Intentar escribir el valor del lock
    cbnz w2, acquire_lock    // Si falla, seguir intentando

    // Sección crítica: realizar tarea sincronizada
    // ...

    // Liberar el lock
    mov w1, #0               // Valor de lock libre
    str w1, [x0]             // Escribir el valor para liberar el lock

    // Fin del programa
    b .
```

Este ejemplo muestra cómo implementar un **spinlock** para sincronizar el acceso a un recurso entre múltiples núcleos.

---

## Balanceo de carga y paralelismo

El **balanceo de carga** es una técnica para distribuir el trabajo de manera equitativa entre todos los núcleos disponibles. En ARM64, el balanceo de carga eficiente puede maximizar el rendimiento y reducir el tiempo de ejecución al asegurarse de que todos los núcleos estén trabajando de manera óptima.

### Técnicas para el balanceo de carga:

1. **Asignación estática**:
   - El programador distribuye las tareas manualmente entre los núcleos, dividiendo las tareas antes de la ejecución.
   
2. **Asignación dinámica**:
   - El sistema operativo o el software distribuye las tareas a medida que se ejecutan, reasignando trabajos según sea necesario para evitar que algunos núcleos estén inactivos.

### Ejemplo de paralelismo:

En el siguiente ejemplo, un bucle grande se divide en fragmentos más pequeños, y cada núcleo ejecuta una parte del trabajo en paralelo.

```assembly
.section .data
    result: .word 0           // Resultado compartido entre núcleos
    work: .word 1000          // Número de trabajos

.section .text
.global _start

_start:
    // Cada núcleo realiza parte del trabajo
    ldr x0, =work             // Cargar el trabajo restante
    ldr x1, =result           // Cargar el resultado compartido

work_loop:
    subs x0, x0, #1           // Decrementar el trabajo
    b.le finish               // Si no queda trabajo, terminar
    add x1, x1, #1            // Incrementar el resultado
    b work_loop               // Repetir el trabajo

finish:
    b finish
```

---

## Herramientas para depuración y monitoreo

Depurar y monitorear sistemas multinúcleo puede ser complicado, ya que los errores pueden ser difíciles de reproducir debido a la naturaleza paralela de la ejecución. Sin embargo, hay varias herramientas que facilitan la depuración y monitoreo en entornos multinúcleo:

1. **GDB Multihilo**:
   - **GDB** permite depurar programas en sistemas multinúcleo y multihilo. Puedes utilizar **breakpoints** y monitorear el estado de cada hilo o núcleo.
   
   ```bash
   gdb -tui ./programa
   ```

2. **Perf**:
   - **Perf** es una herramienta de monitoreo de rendimiento que te permite medir el uso de la CPU, el tiempo de ejecución y la carga en cada núcleo.
   
   ```bash
   perf stat -e cycles -C 0-3 ./programa
   ```

3. **Ftrace**:
   - **Ftrace** permite rastrear la ejecución de funciones en el kernel, lo que es útil para monitorear el comportamiento de múltiples núcleos en sistemas Linux.

---

## Ejercicios prácticos

### Ejercicio 1: Uso de spinlocks para sincronización

Escribe un programa que use un **spinlock** para que dos núcleos trabajen sobre un recurso compartido (un contador) sin que ambos accedan a la vez.

#### Solución en ensamblador:

```assembly
.section .data
    counter: .word 

0         // Recurso compartido
    lock: .word 0            // Spinlock

.section .text
.global _start

_start:
    // Adquirir el lock
acquire_lock:
    ldr x0, =lock
    ldxr w1, [x0]
    cbnz w1, acquire_lock
    mov w1, #1
    stxr w2, w1, [x0]
    cbnz w2, acquire_lock

    // Incrementar el contador
    ldr x1, =counter
    ldr w2, [x1]
    add w2, w2, #1
    str w2, [x1]

    // Liberar el lock
    mov w1, #0
    str w1, [x0]

    // Fin del programa
    b .
```

### Ejercicio 2: Distribuir tareas entre núcleos

Escribe un programa que divida un gran trabajo entre dos núcleos de manera equitativa y permita que cada uno ejecute su parte del trabajo.

---

## Resumen

En este capítulo, exploramos las técnicas para optimizar y gestionar sistemas **multinúcleo** en ARM64. Aprendimos cómo asignar tareas a múltiples núcleos, cómo sincronizar el trabajo entre ellos y cómo depurar y monitorear su comportamiento, todo en el contexto del **Raspberry Pi 5**.
