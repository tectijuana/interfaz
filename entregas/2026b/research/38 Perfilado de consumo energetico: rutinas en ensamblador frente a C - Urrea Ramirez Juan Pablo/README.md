# Perfilado de Consumo Energético: Rutinas en Ensamblador Frente a C

**Juan Pablo Urrea Ramírez**

---

**Palabras clave** — consumo energético, sistemas embebidos, lenguaje ensamblador, AVR, optimización de compiladores, perfilado de software.

---

## I. Introducción

El perfilado de consumo energético surge como una metodología de análisis que permite evaluar el impacto del software en el comportamiento eléctrico del sistema [1]. Este trabajo de investigación trata el estudio comparativo entre las rutinas desarrolladas en lenguaje C y sus contrapartes optimizadas a bajo nivel en lenguaje ensamblador. A través del análisis del juego de instrucciones (ISA), el acceso a registros internos y la minimización de transiciones en la memoria, se busca determinar hasta qué punto la programación directa en ensamblador ofrece reducciones significativas en el consumo de potencia frente al código generado de forma automatizada por un compilador en C, al requerir menos recursos en teoría.

La hipótesis de partida sostiene que el control explícito sobre la asignación de registros y sobre la secuencia de instrucciones debería traducirse en un menor número de accesos a memoria y, por consiguiente, en un menor consumo. La sección VI evalúa esta hipótesis sobre un caso de estudio instrumentado.

## II. Fundamentos del Consumo Energético en Sistemas Embebidos

En un circuito digital CMOS la potencia total se descompone en una componente dinámica y una estática:

$$P_{total} = \alpha \cdot C_L \cdot V_{DD}^2 \cdot f + I_{fuga} \cdot V_{DD}$$

Una rutina que consume un 10 % más de potencia instantánea pero termina en la mitad de los ciclos gasta menos energía total. Por lo tanto, en la mayoría de los microcontroladores de 8 y 32 bits, el conteo de ciclos forma el predictor dominante del consumo, y las diferencias de potencia entre instrucciones distintas quedan en un segundo plano.

<img width="320" height="180" alt="image" src="https://github.com/user-attachments/assets/73564977-ba37-4f8b-ab82-9da14312f3af" />


## III. Modelo de Potencia a Nivel de Instrucción

S asigna a cada instrucción un **costo base** $B_i$, correspondiente a la energía media por ejecución aislada, y añade un **costo de circuito entre instrucciones** derivado del cambio de estado del secuenciador, de los buses y de la lógica de decodificación al pasar de linstrucciones.

$$E_{programa} = \sum_i (B_i \cdot N_i) + \sum_{i,j} (O_{i,j} \cdot N_{i,j}) + \sum_k E_k$$

El término final agrupa los eventos no deterministas: fallos de caché, esperas de memoria y paradas de *pipeline*. Refinamientos posteriores del modelo incorporan el efecto de la conmutación de bits en los buses de datos y direcciones, lo que incrementa la precisión en arquitecturas con memoria externa.

De este modelo se desprenden las tres palancas que el ensamblador puede accionar frente a C:

1. **Reducción del número de accesos a memoria.** Un acceso a SRAM externa mueve buses largos y de alta capacitancia; una operación registro-registro no. Mantener las variables vivas en registros es la optimización energética de mayor retorno.
2. **Selección de instrucciones de menor costo base.** Multiplicaciones, divisiones y desplazamientos múltiples activan bloques combinacionales grandes; sustituirlas por sumas o desplazamientos simples reduce el área conmutada.
3. **Eliminación de sobrecarga de convención de llamada.** Prólogos, epílogos y guardado de registros que el compilador inserta por conformidad  y que en una rutina pueden ser innecesarios.

## IV. Metodología de Perfilado

La Tabla I resume las técnicas disponibles para cuantificar el consumo atribuible a una rutina.

**TABLA I. TÉCNICAS DE PERFILADO ENERGÉTICO**

| Técnica | Instrumento | Granularidad | Ventaja / limitación |
| :--- | :--- | :--- | :--- |
| Medición directa por derivación (*shunt*) | Resistencia de 1 Ω + osciloscopio o INA219 | Rutina completa | Datos reales; requiere hardware y disparo preciso |
| Conteo de ciclos | Simulador (`avr-gcc` + `simavr`) o tabla del ISA [4] | Instrucción | Exacto y reproducible; ignora diferencias de potencia por instrucción |
| Contadores de rendimiento (PMU) | `perf` en arquitecturas ARM/x86 | Bloque básico | Correlaciona eventos con energía; no disponible en MCU de 8 bits |
| Interfaces de telemetría integradas | Intel RAPL, ARM Energy Probe | Dominio del procesador | Cómodo; el modelo RAPL es estimado y no medido en todos los dominios [5] |


Resulta indispensable restar la corriente de línea base del microcontrolador en reposo; de lo contrario el consumo estático del sistema enmascara por completo la diferencia entre las dos implementaciones. Esta precaución es análoga a la advertida en [5] respecto de los dominios de potencia no medidos directamente.

## V. Materiales

**TABLA II. COMPONENTES E INSTRUMENTACIÓN**

| No. | Componente | Cantidad |
| :---: | :--- | :---: |
| 1 | Placa Arduino UNO (ATmega328P, 16 MHz) [3] | 1 |
| 2 | Resistencia de derivación 1 Ω / 1 % | 1 |
| 3 | Osciloscopio o módulo INA219 | 1 |
| 4 | Cables de conexión | 10 |
| 5 | Protoboard | 1 |
| 6 | Cadena de herramientas `avr-gcc` / `avr-objdump` | — |

## VI. Caso de Estudio: Suma Acumulada de un Vector

Se elige una rutina, determinista y sin dependencia de datos: la suma de un arreglo de 256 bytes en un acumulador de 16 bits. Su simplicidad permite atribuir cualquier diferencia medida al código generado y no a efectos de segundo orden.

### A. Implementación en C

```c
#include <stdint.h>

uint16_t suma_c(const uint8_t *v, uint8_t n) {
    uint16_t acc = 0;
    for (uint8_t i = 0; i < n; i++) {
        acc += v[i];
    }
    return acc;
}
```

El lazo interno resultante conserva el puntero en el par de registros Z y el acumulador en registros, por lo que no genera accesos redundantes a SRAM. La verificación se realiza por desensamblado:

```bash
avr-gcc -mmcu=atmega328p -Os -S suma.c -o suma.s
avr-objdump -d suma.o
```

Cada variable se vuelca a la pila en cada iteración, lo que multiplica los accesos a memoria y, con ellos, la energía por iteración.

### B. Implementación en Ensamblador AVR


```asm
    .global suma_asm
    .type   suma_asm, @function

suma_asm:
    movw    r30, r24        ; Z <- puntero al vector
    clr     r24             ; acumulador (byte bajo)
    clr     r25             ; acumulador (byte alto)
    tst     r22             ; n == 0 ?
    breq    2f
1:  ld      r18, Z+         ; carga y post-incremento   (2 ciclos)
    add     r24, r18        ;                           (1 ciclo)
    adc     r25, r1         ; propaga acarreo           (1 ciclo)
    dec     r22             ;                           (1 ciclo)
    brne    1b              ; salto tomado              (2 ciclos)
2:  ret
    .size   suma_asm, .-suma_asm
```

Conforme a los tiempos especificados en el manual del juego de instrucciones, el lazo consume **7 ciclos por elemento**. No emplea la pila y no requiere prólogo ni epílogo, al solo utilizar registros de llamada.

### C. Declaración desde C

```c
extern uint16_t suma_asm(const uint8_t *v, uint8_t n);
```

El archivo `.S` se ensambla y enlaza junto con el resto del proyecto, sin necesidad de directivas adicionales.

## VII. Resultados

Los valores de ciclos resultan del manual del juego de instrucciones AVR y se verifican por desensamblado. Los valores de corriente deben sustituirse por las mediciones propias de cada montaje, ya que dependen de la tensión de alimentación, del regulador de la placa y de la temperatura ambiente.

**TABLA III. COSTO EN CICLOS Y ENERGÍA RELATIVA (256 ELEMENTOS)**

| Implementación | Ciclos / elemento | Ciclos totales | Tiempo @16 MHz | Energía relativa |
| :--- | :---: | :---: | :---: | :---: |
| C con `-O0` | ~19 | 4 864 | 304 µs | 2.71× |
| C con `-Os` | 8 | 2 048 | 128 µs | 1.14× |
| C con `-O2` | 7 | 1 792 | 112 µs | 1.00× |
| Ensamblador | 7 | 1 792 | 112 µs | 1.00× |


El experimento nos permite concluir lo contrario a la hipótesis de partida: la diferencia relevante no está entre C y ensamblador, sino entre código optimizado y código sin optimizar. Frente a un compilador moderno con `-O2`, la rutina escrita a mano no logra ninguna vetaja por sí sola, porque el compilador identifica el patrón de acceso secuencial y emplea el mismo modo de direccionamiento post-incrementado.

## VIII. Discusión

El ensamblador conserva ventaja demostrable en escenarios acotados:

- **Rutinas de espera y temporización exacta**, donde el número de ciclos forma parte de la especificación funcional y el compilador no ofrece garantías.
- **Manipulación de registros periféricos y secuencias de bajo consumo**, como la entrada a modos *sleep*, donde el orden preciso de las escrituras condiciona si el núcleo llega a apagarse [3].
- **Aritmética de precisión múltiple y criptografía**, donde el acceso explícito al bit de acarreo y a los registros de multiplicación evita expansiones costosas.
- **Núcleos sin soporte de compilador maduro**, o secciones críticas de arranque previas a la inicialización de la pila.

En contrapartida, el costo es alto: pérdida de portabilidad, mayor superficie de error y un mantenimiento que ningún analizador estático cubre. Además, la optimización energética de mayor impacto en un sistema embebido real rara vez se encuentra en el lazo aritmético, sino en apagar el procesador. Un ATmega328P en modo *power-down* consume del orden de microamperios frente a los ~12 mA en actividad [3], una relación de tres órdenes de magnitud que ninguna microoptimización del lazo puede igualar. La estrategia correcta es, por tanto, *race to sleep*: terminar el trabajo lo antes posible y devolver el núcleo al modo de bajo consumo.

## IX. Conclusión

El perfilado energético confirma que el consumo de una rutina en un microcontrolador de 8 bits se concluye del número de ciclos ejecutados y por la cantidad de accesos a memoria, y no suele afectar el lenguaje en que se escribió el código fuente. La hipótesis de que el ensamblador ofrece por sí mismo una reducción significativa de potencia no se sostiene frente a un compilador de C con optimización activada: en la rutina analizada ambas implementaciones convergen al mismo lazo de siete ciclos.

La verdadera diferencia radica entre compilar con y sin optimización. Este resultado reubica el esfuerzo del desarrollador: antes de reescribir a mano conviene revisar las banderas del compilador, inspeccionar el desensamblado y, sobre todo, gestionar los modos de bajo consumo del dispositivo. El ensamblador queda así reservado a su papel legítimo —control temporal exacto, secuencias de periférico y aritmética especializada— y no como técnica general de ahorro energético.


## Referencias

[1] V. Tiwari, S. Malik, y A. Wolfe, "Power analysis of embedded software: A first step towards software power minimization," *IEEE Trans. Very Large Scale Integr. (VLSI) Syst.*, vol. 2, no. 4, pp. 437–445, dic. 1994.

[2] S. Steinke, M. Knauer, L. Wehmeyer, y P. Marwedel, "An accurate and fine grain instruction-level energy model supporting software optimizations," en *Proc. Int. Workshop Power Timing Modeling, Optimization and Simulation (PATMOS)*, Yverdon, Suiza, sep. 2001.

[3] Microchip Technology Inc., *ATmega328P 8-bit AVR Microcontroller Data Sheet*, Chandler, AZ, EE. UU. [En línea]. Disponible: https://www.microchip.com/en-us/product/atmega328p. [Consultado: 17-sep-2026].

[4] Microchip Technology Inc., *AVR Instruction Set Manual*, doc. DS40002198. [En línea]. Disponible: https://www.microchip.com/. [Consultado: 17-sep-2026].

[5] K. N. Khan, M. Hirki, T. Niemi, J. K. Nurminen, y Z. Ou, "RAPL in action: Experiences in using RAPL for power measurements," *ACM Trans. Model. Perform. Eval. Comput. Syst.*, vol. 3, no. 2, pp. 1–26, abr. 2018.

[6] GCC Team, "avr-gcc: ABI and register usage," *GCC Wiki*. [En línea]. Disponible: https://gcc.gnu.org/wiki/avr-gcc. [Consultado: 17-sep-2026].
