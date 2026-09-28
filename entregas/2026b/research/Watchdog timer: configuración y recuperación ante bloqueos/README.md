# **Watchdog timer: Configuración y Recuperación Ante Bloqueos**
## Introducción
En esta investigación hablaremos de un elemento de los microcontroladores llamada Watchdog Timer, abreviado como WTD en esta investigación. Su función será desarrollada mas adelanta con ejemplos y casos de uso, tanto de un procesador especifico como de sus registros y casos de recuperación.
## Desarrollo Técnico
### Papel del Watchdog Timer en los sistemas embebidos
Los sistemas embebidos están hechos para realizar tareas especificas durante un periodo prolongado de tiempo sin detenerse, a menudo realizando procesos y operaciones de procesador de forma continúa. Para conocer el papel y relevancia del WDT hay que pensar en el caso más común; donde un microcontrolador esta trabajando por horas, días, semanas o años en casos excepcionales, en estos casos especiales hay que tomar en cuenta la forma que tiene el procesador de trabajar, si nos damos cuenta en la forma que trabaja ensamblador y es la forma principal de la programación (Recordemos que el lenguaje de alto nivel y bajo nivel de todas formas sigue pasando por un proceso de compilación donde se tiene que traducir a lenguaje máquina el proceso trabajado) su forma de asignar memoria es directamente escribiendo sobre la memoria de la computadora para realizar sus procesos, por ende, en dado caso que haya un problema de procesamiento la memoria no va a ser asignada correctamente. En ese punto es donde exactamente entra el WTD en un problema de procesamiento donde por agotamiento, por causas físicas o por un agente externo (recordemos que ondas electromagnéticas, y hasta electrones y elementos fundamentales de la naturaleza de escala de plank pueden alterar resultados computables) el WTD recibirá una señal y en base a eso se hará una acción en el procesador, ya sea reiniciar u otra cosa deseada por el programador.

### Reloj, frecuencia y temporización
Para comprender el WTD es necesario comprender primero el tema de temporización digital. Los temporizadores en un microcontrolador necesitan de una referencia para determinar el paso del tiempo. Generalmente se da por cuantos ciclos ocurren por un segundo y se mide en hertz. 
Por lo tanto, si un contador recibe un pulso cada ciclo del reloj, el incremento del contador representa aproximadamente un microsegundo. Este principio permite transformar una actividad eléctrica en una medida temporal para determinar cuando debe producirse una acción.
En un microcontrolador, el temporizador puede prevenir de fuentes diferentes, ya sea divisores, multiplexores, osciladores independientes o generadores de ticks, dando un ejemplo puntual de Raspberry Pi, con el procesador RP2040, su watchdog obtiene clk_tick a partir de clk_ref. El fabricante indica que clk_ref puede configurarse ideal
### Flujo de funcionamiento del Watchdog Timer

**Fuente de reloj**  
↓  
**Frecuencia de referencia**  
↓  
**División de frecuencia**  
↓  
**Tick temporal**  
↓  
**Contador del WDT**  
↓  
**Timeout**  
↓  
**Acción de recuperación**

### Reset  y mecanismo de recupración
Siguiendo con el ejemplo del RP2040, el software se puede dar cuenta del reinicio por watchdog incorpora el registro REASON, que registra información sobre la causa del último reset. Cuenta con los bits FORCE y TIMER; el datasheet especifica que ambos permanecen en cero en el caso de un reset de hardware normal.
El diagnóstico posterior al reset puede ser incluso más importante que el propio reinicio en aplicaciones donde los fallos necesitan trazabilidad. Si un sistema se reinicia automáticamente pero nunca conserva información de que el watchdog fue el origen, un desarrollador puede interpretar erróneamente el reinicio como un problema eléctrico o una desconexión de energía.
En el RP2040 se disponen de ocho registros SCRATCH, cada uno de 32 bits. El boot ROM puede registrar durante el arranque. La importancia conceptual está en que el watchdog no tiene por qué limitarse a detectar un bloqueo y reiniciar. Puede formar parte de un sistema más amplio de detección, recuperación y diagnóstico.

## Conclusiones

En conclusión, podemos decir que el WDT es un elemento sumamente importante para la computación, programación y sobretodo crear sistemas controlados, de alta confiabilidad en microcontroladores, es decir, es una pieza que permite llegar a garantizar ciertos comportamientos ante fallas.
 
## Bibliografía

M. Alharbi _et al._, “Enhancing Reliability in Embedded Systems Hardware: A Literature Survey,” _IEEE Access_, vol. 13, pp. 17285–17302, Jan. 2025, doi: 10.1109/ACCESS.2025.3534138.

Texas Instruments, _Monitor System With External Programmable Watchdog Timer With Low-Cost MSP430 MCU_, Application Brief SLAA987, Feb. 2021.

Raspberry Pi Ltd., _RP2040 Datasheet: A microcontroller by Raspberry Pi_, build version dated Feb. 20, 2025, sections 4.7, 2.13 and 2.14.

Microchip Technology Inc., “AVR Device Watchdog Timer (WDT),” _Microchip Developer Help_, Nov. 9, 2023.

 Raspberry Pi Ltd., _Pico C/C++ SDK Documentation: Hardware APIs_, Pico SDK documentation, release 2.3.1.

Raspberry Pi Ltd., _RP2040 Datasheet_, Sec. 2.11, “Power Control,” including SLEEP and DORMANT states.

Microchip Technology Inc., “AVR Low Power Sleep Modes,” _Microchip Developer Help_, Nov. 9, 2023.

Microchip Technology Inc., “Windowed Watchdog Timer,” _Microchip Online Documentation_, device documentation for WWDT operation.

Y. Wang _et al._, “An Efficient Checkpoint and Recovery Mechanism for Real-Time Embedded Systems,” in _Proc. IEEE Int. Conf. Parallel and Distributed Processing with Applications, Ubiquitous Computing and Communications, Big Data and Cloud Computing, Social Computing and Sustainable Computing_, Melbourne, Australia, Dec. 2018, doi: 10.1109/BDCloud.2018.00123.
