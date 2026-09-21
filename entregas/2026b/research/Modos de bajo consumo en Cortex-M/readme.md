# Modos de bajo consumo en Cortex-M: Sleep, Stop y Standby

## Introducción

En esta investigación revisaremos los modos de bajo consumo del microcontrolador STM32 (núcleo ARM Cortex-M3): el modo Sleep, Stop y Standby.

Se revisará la funcionalidad de cada uno, sus características y cómo se ejecutan.

## Qué hace el modo Sleep

El modo Sleep es el primero de todos los modos de bajo consumo: la reducción de consumo en este caso no es excesiva, pero a cambio tenemos todos los periféricos funcionando. Únicamente deja de ejecutar instrucciones la CPU.

De este modo, nos puede interesar desactivar los relojes de los periféricos que no queremos usar mientras duerme, para así ahorrar aún más consumo.

Para salir del modo Sleep se puede configurar para esperar una interrupción (WFI: *Wait for Interrupt*) o esperar a un evento (WFE: *Wait for Event*).

## Qué hace el modo Stop

El modo Stop es el siguiente modo de bajo consumo; en este ya podemos obtener consumos tan bajos como decenas de microamperios. En este caso, ya no tenemos disponible ningún periférico, así que no podemos, por ejemplo, despertar con una interrupción UART. Sin embargo, los registros guardarán el valor que tenían antes de entrar al modo Stop, es decir, si una GPIO la teníamos a valor ALTO, seguirá en ese valor.

Para volver del modo Stop, podemos usar, igual que en el caso del Sleep, una interrupción. En este caso, el código es prácticamente similar; solo cambia una línea.

## Qué hace el modo Standby

El modo Standby es el modo más agresivo para reducir el consumo de potencia del STM32. En este modo nuestro microcontrolador reduce su consumo al mínimo, así como su funcionalidad. En este modo no tenemos acceso a las interrupciones externas (EXTI), la CPU y todos los relojes están apagados. Los datos que tuviéramos en la RAM y el estado de los registros los hemos perdido. De hecho, cuando «despertemos» del modo Standby, el microcontrolador se va a reiniciar y va a empezar desde el principio, reconfigurando todo.

En el modo Standby solo podemos activar: el IWDG (*Independent Watchdog*), el RTC (*Real-Time Clock*), el oscilador RC interno (LSI) y el oscilador de 32.768 kHz externo. Dado que no tenemos nada del microcontrolador funcionando, despertarlo no es tan sencillo. No podemos esperar a interrupciones en pines o periféricos (UART/DMA …); en este caso solo tenemos las siguientes opciones para despertarlo:

* Reset externo: es decir, interactuar con el pin NRST.
* Un reset del IWDG.
* Un flanco de subida en el pin WKUP (*WakeUp pin*).
* O una alarma del RTC.

## Conclusión

Como pudimos ver, hay varios modos de bajo consumo, todos con funciones y características diferentes. A forma de resumen, tenemos que:

* **Modo Sleep:** Es el primer modo de bajo consumo; en este modo se desactiva el reloj de la CPU, sin embargo, todos los periféricos siguen funcionando.
* **Modo Stop:** El siguiente modo de bajo consumo, en el cual se apagan todos los relojes, tanto los del dominio 1.8 V como los relojes HSI y HSE. Esto significa que los periféricos están apagados y no se puede interactuar con ellos desde el exterior. Sin embargo, se mantiene la alimentación del dominio 1.8 V (significa que el valor de los registros se mantiene durante el modo Stop).
* **Modo Standby:** El de menor consumo; en este modo se apaga prácticamente todo y cuando se recupera de este modo es como si se reiniciara el microcontrolador y empezara desde el principio (no sigue desde donde lo dejaste).

## Referencias

Laboratorio Gluon. (s. f.). *Cómo usar los modos bajo consumo en STM32 Blue Pill.*

https://www.laboratoriogluon.com/como-usar-los-modos-bajo-consumo-en-stm32-bluepill/
