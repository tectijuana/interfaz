# Tema: Interfaz de teclado matricial y antirrebote (debounce) por software

**Alumno:** Axel José Mejía Salinas  
**Número de control:** 24210504  

## 1. Introducción
Los teclados son una excelente manera de permitir que los usuarios interactúen con sus proyectos. Se pueden usar para navegar por los menús, introducir contraseñas o controlar los juegos y robots.

Un teclado matricial permite la conexión de múltiples botones utilizando un menor número de pines en un sistema. Debido a la naturaleza mecánica de los interruptores, se requiere procesar las señales para evitar lecturas erróneas.


## 2. Principio de funcionamiento del Teclado Matricial
Las _teclas_ de un teclado están organizadas en filas y columnas. Existen múltiples teclados con diferente número de teclas, siendo los más habituales las configuraciones de **3×3**, **3×4** y **4×4**.

Este tipo de teclados están constituidos por 3 membranas superpuestas, dos membranas con material conductor y una en medio no conductora, para separarlas. En condiciones normales, el interruptor se encuentra abierto, pero al presionar la tecla, la membrana superior e inferior entran en contacto permitiendo la circulación de la corriente.
![Diagrama de escaneo](https://eloctavobit.com/imagenes/2023/06/647b8edf4dbb5.webp)
Los pulsadores están distribuidos en _filas_ y _columnas_. Para detectar la pulsación de una tecla tendremos que conocer la posición **(X, Y)**. Por ejemplo, la tecla del número 5 corresponde a la fila 2 y columna 2, por lo que se encuentra en la posición **(2,2)**.


### 2.1 Algoritmo de escaneo
El algoritmo de escaneo consiste en un **ciclo iterativo**. Configuras las columnas de la matriz como pines de salida y las filas como pines de entrada. El programa enciende (envía voltaje) a la primera columna, y luego revisa todas las filas para ver si alguna recibe señal. Si detecta voltaje en una fila específica, el programa cruza la coordenada de esa fila con la columna que está actualmente encendida para determinar qué tecla exacta cerró el circuito. Luego, apaga esa columna, enciende la siguiente, y repite el proceso a alta velocidad.

### 2.2 Requisitos de hardware
_Para realizar la lectura de un teclado matricial e implementar la técnica de antirrebote (debounce) por software, el programa o firmware debe gestionar los siguientes elementos:_

**Configuración de puertos de E/S:** Asignar un grupo de pines como salidas digitales (para las columnas) y otro grupo como entradas digitales (para las filas). 

**Habilitación de resistencias de pulso:** Activar las resistencias internas de *pull-up* o *pull-down* en los pines definidos como entradas para evitar estados flotantes o lecturas erráticas producidas por ruido eléctrico.

**Manejo de tiempos o temporización:** Implementar rutinas de retardo (por ejemplo, `delay_ms(20)`) o contadores mediante interrupciones por *Timer* para pausar la ejecución durante el tiempo de estabilización de los contactos mecánicos. 
**Operaciones a nivel de bits (Bitwise operations):** Emplear máscaras lógicas (AND, OR) y desplazamientos para aislar e interpretar el estado de un pin específico dentro del registro del puerto.  

**Tabla de traducción (Look-up Table):** Definir una matriz bidimensional en código que asocie la intersección de una fila y una columna con su carácter ASCII o valor hexadecimal correspondiente.

## 3. El fenómeno del rebote
Los contactos metálicos de un pulsador no cierran de forma instantánea. Generan múltiples transiciones rápidas antes de estabilizarse mecánicamente.

Los teclados de matriz deben gestionar los rebotes de las teclas, es decir, los contactos momentáneos que pueden producirse al pulsar o soltar una tecla. Estos rebotes pueden provocar detecciones múltiples erróneas de la pulsación de una sola tecla. 

Para evitarlo, se emplean técnicas de eliminación de rebotes. Éstas pueden incluir filtros de hardware o temporizadores de software que no tienen en cuenta las señales transitorias y garantizan que sólo se registren las pulsaciones estables e intencionadas.


### 4.1 Método por retardo (Delay)
Consiste en detectar un cambio de estado, aplicar una pausa temporal (ej. 10 a 50 ms) y realizar una segunda verificación.

Una de las aproximaciones más comunes es realizar verificaciones consecutivas **(Consecutive Runs)**(, donde el sistema toma decisiones contando múltiples lecturas consecutivas de ceros o unos lógicos. La idea central es esperar a que el rebote de los contactos desaparezca por completo para asegurar que el interruptor se encuentra en un estado estacionario y no en un transitorio. Aunque este método garantiza que la señal se ha estabilizado, su principal desventaja es el tiempo de retraso que introduce; si bien es aceptable para la escritura estándar, resulta ineficiente en aplicaciones que exigen tiempos de respuesta en tiempo real. 

Otra variante de este enfoque consiste en detectar la primera transición lógica y validar el cambio inmediatamente **((Quick Draw)**, tras lo cual se introduce un retardo de bloqueo. Durante este periodo, el sistema ignora cualquier lectura posterior de la tecla, omitiendo las oscilaciones causadas por el rebote. Aunque minimiza el retraso, es extremadamente susceptible a interferencias electromagnéticas (EMI) y a lecturas erróneas por el desgaste mecánico de los contactos.

### 4.2 Método por máquina de estados
Evita detener el flujo del programa principal, empleando temporizadores o contadores para verificar la estabilidad de la señal a lo largo de varios ciclos.

Para lograr un compromiso óptimo entre la latencia y la robustez, se implementa un enfoque híbrido basado en una máquina de estados finitos simétrica acoplada a un integrador discreto (contador). Este algoritmo clasifica la señal en dos tipos de estados: estacionarios **(steady-state)** y transitorios **(transient)**.

El sistema opera bajo los siguientes cuatro estados discretos:
*   **Estado 0:** Estado estacionario bajo (tecla liberada).
*   **Estado 1:** Transición de bajo a alto.
*   **Estado 2:** Estado estacionario alto (tecla presionada).
*   **Estado 3:** Transición de alto a bajo.

**Lógica del algoritmo:**
Se establece un contador con límites de saturación entre un valor mínimo (`-s`) y un máximo (`+s`). Partiendo del Estado 0 (contador saturado en `-s`), el sistema acumula lecturas positivas. La transición se detecta cuando el contador supera un umbral definido por `-s + t` (donde `t` es el número de lecturas para confirmar un transitorio). Al confirmarse, el estado cambia a alto y el contador se reinicia a 0, manteniéndose en espera de alcanzar los límites `+s` (confirmando el Estado 2 definitivo) o regresando a `-s` (descartando la lectura como falsa alarma). Esta técnica permite ajustar los parámetros `s` y `t` para adaptar el algoritmo a las características físicas de cualquier interruptor mecánico sin detener el procesamiento general del microcontrolador.

A continuación, se presenta la estructura base del algoritmo de la máquina de estados:
```cpp 
// run debouncing algorithm for one timestep 
// return: whether output has changed 
bool update(bool input) 
{
 if (input) 
 { 
 if (counter < +thres_steady) 
 ++counter; } 
 else { 
 if (counter > -thres_steady) 
 --counter;
  } switch (state) 
  { 
  case 0:
   // steady-state lo if (counter >= -thres_transient_abs) 
   { 
   // => transient lo-hi counter = 0; 
   state = 1; return true; 
   } else
    { 
   return false;
    } 
   case 1:
    // transient lo-hi switch (counter)
     { 
     case +thres_steady: 
     // => steady-state hi state = 2;
      return false;
       case -thres_steady:
        // => steady-state lo state = 0;
         return true;
          default: 
          return false;
           }
            // ... [cases 2 and 3 omitted] ... } 

```
## 5. Conclusiones
La implementación práctica de la interfaz permitió comprobar el funcionamiento del circuito y relacionar la lógica digital con una respuesta física tangible. El uso de la fuente de 5V y el protoboard garantizó una alimentación estable, mientras que las herramientas de medición fueron clave para verificar los niveles lógicos y el acondicionamiento del circuito mediante elementos pasivos.


## 6. Referencias

* El octavo, B. (2020, noviembre 13). *Teclados matriciales*. El Octavo Bit. https://eloctavobit.com/modulos-sensores/teclados-matriciales

* Rubén. (2013, julio 26). *Teclado Matricial con PIC*. Geek Factory. https://www.geekfactory.mx/tutoriales-pic/teclado-matricial-con-pic/

* summivox. (2016, junio 3). *Keyboard matrix scanning and debouncing*. Frog in the Well. https://summivox.wordpress.com/2016/06/03/keyboard-matrix-scanning-and-debouncing/

* (S/f). Studocu.com. Recuperado el 13 de septiembre de 2026, de https://www.studocu.com/pe/document/universidad-nacional-del-callao/sistemas-digitales/sistemas-digitales-92g-laboratorio-05-teclado-matricial-y-componentes/132846470?sid=%24device%3Acdc15366-0f4c-449d-982e-4edf867b8f6e1789266471
