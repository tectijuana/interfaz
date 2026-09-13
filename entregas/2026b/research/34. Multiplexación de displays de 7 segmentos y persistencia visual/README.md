![Tecnológico Nacional de México - Instituto Tecnológico de Tijuana](https://www.tijuana.tecnm.mx//wp-content/uploads/2022/03/TecNM-ITT-sgc-2018-color-scaled-e1646127126124.jpg)

### Proyecto de investigación --- Lenguajes de interfaz 2026 "B" --- Grupo B (17:00)
### Lista complementaria: 41 temas de investigación y rúbrica de 5 categorías
### TecNM Campus Tijuana --- Ingeniería en Sistemas Computacionales (SCC-1014)
### Agosto 2026
### Multiplexación de displays de 7 segmentos y persistencia visual
## Tania Lizeth Tavera Alanis
## Introducción

La multiplexación de displays de 7 segmentos es una técnica utilizada    en electrónica digital y sistemas embebidos para controlar varios displays utilizando una cantidad reducida de pines de un       microcontrolador. Esta técnica es muy común en proyectos con Arduino, microcontroladores y otros sistemas digitales donde se necesita       mostrar información numérica, como relojes, contadores, cronómetros, termómetros y marcadores.

Un display de 7 segmentos está compuesto por siete elementos    luminosos, normalmente LED, que permiten representar números del 0 al    9 mediante diferentes combinaciones. Los segmentos se identifican       generalmente con las letras **a, b, c, d, e, f y g**.

![Multiplexación de displays de 7 segmentos - cátodo común](https://controlautomaticoeducacion.com/wp-content/uploads/Anodo-Multiplex.png)

Cuando se utilizan varios displays, controlar cada uno de manera independiente requiere una gran cantidad de conexiones. La multiplexación permite solucionar este problema compartiendo las líneas de los segmentos y activando los displays uno por uno a gran velocidad.

## ¿Qué es un display de 7 segmentos?
Un display de 7 segmentos es un dispositivo formado por siete LED colocados de manera que pueden formar diferentes números.

## 2. ¿Qué es la multiplexación?

La multiplexación es una técnica que permite controlar varios dispositivos utilizando líneas compartidas.
En un display de varios dígitos, los segmentos correspondientes a las diferentes posiciones pueden conectarse en paralelo:

             a b c d e f g
             │ │ │ │ │ │ │
             │ │ │ │ │ │ │
             └─┴─┴─┴─┴─┴─┴──── Microcontrolador
                │
       ┌────────┼────────┐
       │        │        │
      D1       D2       D3 ... Dn
      
Cada dígito tiene además una línea de selección. El microcontrolador activa solamente un dígito a la vez, coloca en las líneas `a-g` el patrón correspondiente y después cambia al siguiente dígito.

Esta técnica reduce considerablemente el número de pines necesarios. Para un display de `N` dígitos con punto decimal, una implementación típica puede requerir aproximadamente `N + 8` líneas de control, en lugar de `8 × N`.

## Funcionamiento de la multiplexación
Supongamos que queremos mostrar:

2026

El microcontrolador realiza rápidamente esta secuencia:

```
D1 → 2
D2 → 0
D3 → 2
D4 → 6
```

Después vuelve a comenzar:

```
D1 → D2 → D3 → D4 → D1 → D2 → D3 → D4 → 

En realidad, solamente un dígito está siendo activado en cada instante:
Tiempo →

D1: ████
D2:     ████
D3:         ████
D4:             ████
```

Cuando termina el ciclo, vuelve inmediatamente al primer display.

Si el cambio es suficientemente rápido, el usuario no percibe fácilmente que los displays se están activando individualmente.

## Persistencia visual

La persistencia visual se utiliza habitualmente para explicar por qué una sucesión rápida de imágenes luminosas puede percibirse como una imagen continua. En el caso de los displays multiplexados, la rápida conmutación hace que los diferentes dígitos parezcan estar encendidos simultáneamente.

Por ejemplo, físicamente el microcontrolador puede realizar:

```
2 → 0 → 2 → 6 → 2 → 0 → 2 → 6 → 
```

pero el usuario observa:

```
┌─────┬─────┬─────┬─────┐
│  2  │  0  │  2  │  6  │
└─────┴─────┴─────┴─────┘
```

Por lo tanto, la multiplexación es el método electrónico y la percepción visual permite que el resultado parezca una visualización continua.

## Ciclo de multiplexación

Un ciclo básico puede representarse de la siguiente manera:

```
             INICIO
                │
                ▼
       Configurar segmentos
                │
                ▼
       Apagar todos los dígitos
                │
                ▼
       Seleccionar dígito 1
                │
                ▼
       Enviar patrón de segmentos
                │
                ▼
          Esperar unos ms
                │
                ▼
       Apagar dígito 1
                │
                ▼
       Seleccionar dígito 2
                │
                ▼
       Enviar patrón de segmentos
                │
                ▼
          Esperar unos ms
                │
                ▼
          Continuar...
                │
                ▼
       Regresar al dígito 1
       
```
 ## Conclusión

En conclusión, al realizar esta investigación pude comprender mejor cómo funciona la multiplexación de displays de 7 segmentos y la importancia que tiene la persistencia visual para su funcionamiento. Aprendí que, en lugar de mantener todos los displays encendidos al mismo tiempo, el microcontrolador activa cada uno durante un periodo muy pequeño y cambia rápidamente entre ellos. Gracias a esta velocidad, nuestros ojos perciben los diferentes dígitos como si estuvieran encendidos de manera continua.

También pude entender que esta técnica permite reducir la cantidad de pines y conexiones necesarios para controlar varios displays, por lo que resulta muy útil en proyectos con microcontroladores y sistemas embebidos. Sin embargo, es necesario controlar correctamente la frecuencia de actualización, el tiempo de activación y la corriente de los LED para evitar problemas como el parpadeo o diferencias de brillo.

## Fuentes de consulta:
[1] Universitat Politècnica de Catalunya, “Multiplexed display system for 7-segment digits,” _Digital Circuits and Systems_. [En línea]. Disponible en: . Consultado: 7 Sep. 2026.

[2] Brigham Young University, “Multi-Segment Display,” _ECEn 320: Fundamentals of Digital Systems_. [En línea]. Disponible en: . Consultado: 7 Sep. 2026.

[3] University of Toronto, Department of Electrical and Computer Engineering, “ECE241F - Digital Systems: More Complex Logic Design: 7-Segment Displays,” _Lab 3_. [En línea]. Disponible en: . Consultado: 7 Sep. 2026.
