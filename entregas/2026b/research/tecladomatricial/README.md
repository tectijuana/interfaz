# Tema: Interfaz de teclado matricial y antirrebote (debounce) por software

**Alumno:** Axel José Mejía Salinas  
**Número de control:** 24210504  

## 1. Introducción
Los teclados son una excelente manera de permitir que los usuarios interactúen con sus proyectos. Se pueden usar para navegar por los menús, introducir contraseñas o controlar los juegos y robots.

Un teclado matricial permite la conexión de múltiples botones utilizando un menor número de pines en un sistema. Debido a la naturaleza mecánica de los interruptores, se requiere procesar las señales para evitar lecturas erróneas.


## 2. Principio de funcionamiento del Teclado Matricial
Las _teclas_ de un teclado están organizadas en filas y columnas. Existen múltiples teclados con diferente número de teclas, siendo los más habituales las configuraciones de **3×3**, **3×4** y **4×4**.

Este tipo de teclados están constituidos por 3 membranas superpuestas, dos membranas con material conductor y una en medio no conductora, para separarlas. En condiciones normales, el interruptor se encuentra abierto, pero al presionar la tecla, la membrana superior e inferior entran en contacto permitiendo la circulación de la corriente.
![Diagrama de escaneo 1](https://eloctavobit.com/imagenes/2023/06/647b8edf4dbb5.webp)
Los pulsadores están distribuidos en _filas_ y _columnas_. Para detectar la pulsación de una tecla tendremos que conocer la posición **(X, Y)**. Por ejemplo, la tecla del número 5 corresponde a la fila 2 y columna 2, por lo que se encuentra en la posición **(2,2)**.

### 2.1 Algoritmo de detección e identificación a bajo nivel
El algoritmo de escaneo consiste en un **ciclo iterativo**. A nivel de registros (como se implementa comúnmente en lenguaje ensamblador para microcontroladores PIC), el programa de control se divide en dos partes: una subrutina de "detección" (que detecta que se oprimió una tecla) y una subrutina de "identificación" (que determina cuál fue).

El proceso se realiza de la siguiente manera:
* Se programa un puerto, asignando la mitad de las señales como salidas y la otra mitad como entradas.
* La técnica consiste en escribir en los bits del puerto en forma secuencial un "CERO" lógico en las columnas y leer cada vez el estado de los renglones.
* Cuando una tecla es oprimida, la lectura en alguno de los renglones será también un "CERO".
* El código de 8 bits obtenido de esta lectura se convierte en el código ASCII de la tecla oprimida mediante el uso de una tabla de equivalencias.

#### 2.1.1 Ejemplo práctico de escaneo (Puerto B)
Tomando como referencia un diagrama típico de conexión hacia el **Puerto B** de un microcontrolador (por ejemplo, un PIC 16F88), los 8 pines se distribuyen de la siguiente manera:
* **Salidas (Columnas Y):** El pin `RB0` se conecta a `Y1`, `RB1` a `Y2`, `RB2` a `Y3` y `RB3` a `Y4`.
![Diagrama de conexion puerto B](https://www.puntoflotante.net/clip_image726.gif)

**Escenario: El usuario presiona la tecla "0" (Intersección X1, Y1):**
> 1. El microcontrolador, en su ciclo de escaneo, envía un `0` lógico a la primera columna (`Y1`) y un `1` al resto de las columnas. Por lo tanto, el estado de los 4 bits más bajos del puerto (RB3...RB0) será `1110`.
>  2. El sistema procede a leer los 4 bits más altos (RB7...RB4) correspondientes a los renglones. Debido a la configuración de resistencias *pull-up*, los renglones normalmente leen un `1`.
>  3. Como la tecla **"0"** está presionada, el circuito se cierra entre `Y1` y `X1`. El `0` lógico fluye hacia el renglón `X1`, causando que el pin `RB4` lea un `0`.
>  4. El estado de los 4 bits altos leídos será entonces `1110`.
>  5. Al concatenar la lectura completa del puerto B (RB7...RB0), el microcontrolador obtiene el byte `11101110`, lo que equivale al valor hexadecimal **0xEE**.
>  6. Finalmente, el software busca este valor `0xEE` en su tabla de traducción (*Look-up Table*) y lo identifica exitosamente como la tecla **"0"**.

#### 2.1.2 Implementación del escaneo en código ensamblador
Para ilustrar el proceso descrito anteriormente, a continuación se presenta un fragmento funcional en lenguaje ensamblador para un microcontrolador PIC (ej. PIC16F88). Este código traduce el algoritmo iterativo de escaneo utilizando manipulación directa de registros.

```assembly
; Fragmento de barrido y detección de teclado matricial

; 1. Inicialización de puertos (Resumen)
    MOVLW   H'F0'       ; RB0..RB3=Salidas (Columnas), RB4..RB7=Entradas (Renglones)
    MOVWF   TRISB
    BCF     OPTION_REG,7 ; Activa resistencias de Pull-up en puerto B

; 2. Ciclo principal de barrido
vuelta1:
    movlw   H'EF'       ; Carga 11101111 (Coloca un 0 lógico en la primera columna)
    movwf   I
    movlw   D'4'
    movwf   J           ; Inicializa contador para recorrer las 4 columnas

vuelta2:
    rrf     I,f         ; Rota los bits a la derecha (desplaza el 0 a la siguiente columna)
    movfw   I
    movwf   PORTB       ; Escribe el patrón de salida en el puerto B
    call    delay       ; Retardo breve para estabilización eléctrica

; 3. Lectura y detección de tecla
    movfw   PORTB       ; Lee el estado actual del puerto B (Renglones)
    iorlw   H'0F'       ; Aplica máscara OR para evaluar únicamente los bits RB4...RB7
    movwf   K           ; Guarda la lectura
    comf    K,f         ; Invierte los bits lógicos
    btfss   STATUS,2    ; Verifica la bandera Z (Zero). Si la lectura indica presión...
    goto    teclazo     ; ...salta a la rutina de identificación de tecla
    
    decfsz  J,f         ; Si no hay presión, decrementa el contador de columnas
    goto    vuelta2     ; Repite el proceso para la siguiente columna
    goto    vuelta1     ; Si ya recorrió las 4 columnas, reinicia el barrido general

; 4. Rutina de identificación (teclazo)
teclazo:
    ; [Aquí el sistema procesa el código renglón/columna contenido en PORTB 
    ; y cruza la información para obtener el carácter o número presionado]
### 2.2 Requisitos de hardware
_Para realizar la lectura de un teclado matricial e implementar la técnica de antirrebote (debounce) por software, el programa o firmware debe gestionar los siguientes elementos:_

**Configuración de puertos de E/S:** Asignar un grupo de pines como salidas digitales (para las columnas) y otro grupo como entradas digitales (para las filas). 

**Habilitación de resistencias de pulso:** Activar las resistencias internas de *pull-up* o *pull-down* en los pines definidos como entradas para evitar estados flotantes o lecturas erráticas producidas por ruido eléctrico.

**Manejo de tiempos o temporización:** Implementar rutinas de retardo (por ejemplo, `delay_ms(20)`) o contadores mediante interrupciones por *Timer* para pausar la ejecución durante el tiempo de estabilización de los contactos mecánicos. 

**Operaciones a nivel de bits (Bitwise operations):** Emplear máscaras lógicas (AND, OR) y desplazamientos para aislar e interpretar el estado de un pin específico dentro del registro del puerto.  

**Tabla de traducción (Look-up Table):** Definir una matriz bidimensional en código que asocie la intersección de una fila y una columna con su carácter ASCII o valor hexadecimal correspondiente.
```

## 3. El fenómeno del rebote
Los contactos metálicos de un pulsador no cierran de forma instantánea. Generan múltiples transiciones rápidas antes de estabilizarse mecánicamente.

Los teclados de matriz deben gestionar los rebotes de las teclas, es decir, los contactos momentáneos que pueden producirse al pulsar o soltar una tecla. Estos rebotes pueden provocar detecciones múltiples erróneas de la pulsación de una sola tecla. 

Para evitarlo, se emplean técnicas de eliminación de rebotes. Éstas pueden incluir filtros de hardware o temporizadores de software que no tienen en cuenta las señales transitorias y garantizan que sólo se registren las pulsaciones estables e intencionadas.

### 4 Debounce
Un debounce _(o desparasitado)_ en un teclado matricial es una técnica por software o hardware que elimina las lecturas falsas causadas por el rebote mecánico de las láminas metálicas de las teclas al presionarlas o soltarlas.

Su función es garantizar que una sola pulsación física se registre como un único evento de tecla y no como múltiples tomas consecutivas.

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
            ++counter; 
    } 
    else 
    { 
        if (counter > -thres_steady) 
            --counter;
    }

    switch (state) 
    { 
        case 0: // steady-state lo
            if (counter >= -thres_transient_abs) 
            { 
                // => transient lo-hi 
                counter = 0; 
                state = 1; 
                return true; 
            } 
            else
            { 
                return false;
            } 

        case 1: // transient lo-hi 
            switch (counter)
            { 
                case +thres_steady: 
                    // => steady-state hi 
                    state = 2;
                    return false;

                case -thres_steady:
                    // => steady-state lo 
                    state = 0;
                    return true;

                default: 
                    return false;
            }
            // ... [cases 2 and 3 omitted] ... 
    }
}
```
## 5. Conclusiones
La implementación de una interfaz de teclado matricial optimiza de forma sustancial el uso de puertos I/O en un microcontrolador, permitiendo la lectura de múltiples entradas mediante técnicas de escaneo y multiplexación. Sin embargo, la naturaleza mecánica de los contactos exige un tratamiento riguroso de las señales transitorias para garantizar una operación confiable.

El uso de algoritmos de antirrebote  por software demuestra ser una solución eficiente y económica al sustituir filtros de hardware externos. En conclusión, la correcta integración entre el escaneo matricial y un algoritmo de filtrado no bloqueante es fundamental para desarrollar sistemas embebidos en tiempo real robustos, eficientes y de alta respuesta.


## 6. Referencias

* El octavo, B. (2020, noviembre 13). *Teclados matriciales*. El Octavo Bit. https://eloctavobit.com/modulos-sensores/teclados-matriciales

* Rubén. (2013, julio 26). *Teclado Matricial con PIC*. Geek Factory. https://www.geekfactory.mx/tutoriales-pic/teclado-matricial-con-pic/

* summivox. (2016, junio 3). *Keyboard matrix scanning and debouncing*. Frog in the Well. https://summivox.wordpress.com/2016/06/03/keyboard-matrix-scanning-and-debouncing/

* Punto Flotante S.A. (s.f.). *Conexión de un teclado matricial hexadecimal con microcontroladores PIC 16F84, 16F628, 16F88, 18F2550*. Recuperado el 14 de septiembre de 2026, de https://www.puntoflotante.net/PROY_TECL.htm
