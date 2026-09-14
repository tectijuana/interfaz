
# Interfaz paralela tipo 8080/6800 para controladores de LCD

**Autor:** Rodríguez Peraza Carlos Eliab
**Curso:** Lenguajes de Interfaz
**Tema #28**

## Introducción

Casi cualquier controlador de LCD o TFT que se usa hoy en día, desde el
clásico display de caracteres 16x2 hasta las pantallas gráficas a color, sigue
anunciando en su datasheet que soporta interfaz "8080-series" o "6800-series".
Estos nombres no son un estándar nuevo ni inventado por los fabricantes de
displays, sino un homenaje directo a dos microprocesadores de mediados de los
años setenta: el Intel 8080 y el Motorola 6800. Ninguno de los dos chips
originales se sigue fabricando, pero la forma en que manejaban sus señales de
control se volvió tan popular que los fabricantes de controladores de LCD la
adoptaron como convención de facto, y esa convención sigue viva en circuitos
integrados modernos como el HD44780, el SSD1289 o el ILI9341. Este documento
explica en qué consiste cada uno de estos dos estilos de interfaz paralela,
cuáles son sus diferencias de señalización, y por qué los dos siguen
coexistiendo en el hardware de displays actuales.

## Desarrollo técnico

### 1. De dónde viene todo esto

A mediados de los años setenta, Intel y Motorola diseñaron sus
microprocesadores con formas distintas de controlar la comunicación con otros
componentes. El Intel 8080 usaba dos líneas de control separadas y activas en
bajo: `/RD` (read, lectura) y `/WR` (write, escritura), cada una generando su
propio pulso según la operación que se necesitara. El Motorola 6800, en
cambio, usaba una sola línea `R/W` que indica la dirección de la transferencia
(alto para lectura, bajo para escritura) más una línea extra de reloj llamada
`E` (Enable), que es la que en realidad dispara la transferencia de datos.
Esta diferencia de filosofía, dos señales de control independientes contra una
sola línea de dirección más un enable, es la raíz de todo lo que hoy se conoce
como interfaz tipo 8080 e interfaz tipo 6800.

### 2. Las señales que vas a encontrar en cada estilo

Aunque los controladores de LCD actuales ya no se conectan a un 8080 o a un
6800 de verdad, conservan el mismo patrón de señales para no romper la
compatibilidad con firmware que ya existe. En un controlador con interfaz
8080-series las señales típicas son: `CS` (chip select), `RS` o `D/C`
(selección de registro o dato), `WR` (escritura, activo en bajo), `RD`
(lectura, activo en bajo) y las líneas de datos `D0-D7` (o hasta `D17` en
interfaces de 18 bits para color). En un controlador con interfaz 6800-series
las señales cambian a `CS`, `RS`, `E` (el pulso de reloj que dispara la
transferencia) y `R/W` (una sola línea que indica la dirección), además de las
mismas líneas de datos.

### 3. El caso del HD44780

El controlador de LCD de caracteres más usado del mundo, el Hitachi HD44780U,
usa exactamente el estilo 6800. La documentación oficial del kernel de Linux
lo confirma: describe que este chip expone una interfaz tipo M6800, manejada
con las líneas `E` (enable), `RS` (register select) y `R/W`, en modo de 4 u 8
bits de datos. Con esto se entiende por qué, cuando conectas un LCD 16x2
típico a un microcontrolador, siempre terminas usando exactamente esas tres
señales de control (E, RS, R/W) además de las líneas de datos.

### 4. Cuando el controlador puede elegir

Los controladores gráficos más modernos, como el SSD1289 que se usa en TFTs a
color, no están amarrados a un solo estilo: se pueden configurar para operar
en modo 8080 o modo 6800 con pines de configuración de hardware. Según la nota
de aplicación de NXP para este controlador, basta con poner los pines
`PS[3:0]` en un valor distinto para elegir, por ejemplo, entre una interfaz
paralela de 16 bits en modo 6800 o en modo 8080. El resto de las líneas de
datos se queda igual, lo único que cambia es el protocolo de temporización de
las líneas de control.

### 5. Dónde está la diferencia real al escribir un dato

La diferencia que de verdad importa entre los dos estilos está en cómo se
captura el dato. En el modo 8080, según describe DisplayModule en su
documentación técnica sobre esta interfaz, el controlador externo baja la
línea `WR` y luego la regresa a alto; es justo en ese flanco de subida de `WR`
cuando el controlador de LCD captura el dato de las líneas. En el modo 6800 es
distinto: es la línea `E` la que genera un pulso completo (de bajo a alto y de
vuelta a bajo) mientras `R/W` se queda fija indicando si es lectura o
escritura, y el dato se captura normalmente en el flanco de bajada de `E`.
Esta diferencia de qué señal dispara la captura y en qué flanco es la que
obliga a que el firmware de un microcontrolador se tenga que escribir distinto
según qué estilo soporte el controlador de LCD que se esté usando.

### 6. Por qué esto sigue vivo hoy

Suena raro que un estándar de señalización de hace casi 50 años siga
apareciendo en datasheets de 2020 para adelante, pero la razón es bastante
práctica: hay millones de líneas de firmware ya escrito (bootloaders, drivers
de sistemas embebidos, bibliotecas como U8g2 o las que usan microcontroladores
AVR o PIC) que ya saben comunicarse en modo 8080 o 6800. Si un fabricante
mantiene esa compatibilidad de señalización, puede vender su display nuevo
como reemplazo directo de un modelo viejo, y el desarrollador no tiene que
reescribir su controlador de software desde cero. Esto se ve confirmado en
datasheets que no tienen nada que ver entre sí: el HD44780U de Hitachi, el
SP9210 de DisplayFuture y el STE2004S de STMicroelectronics son de fabricantes
y épocas distintas, y aun así los tres siguen anunciando soporte para interfaz
6800-series y 8080-series como si fuera una característica normal de venta.

## Conclusiones

Al final, las interfaces 8080 y 6800 me parecen un buen ejemplo de que una
convención de ingeniería puede durar mucho más que el hardware que la creó.
Los dos microprocesadores originales ya ni se fabrican, pero su manera de
manejar la comunicación, ya sea con señales de lectura y escritura separadas o
con una línea de enable más una de dirección, se volvió el lenguaje que
prácticamente todo controlador de LCD sigue usando para hablar con un
microcontrolador, desde el humilde HD44780 hasta controladores gráficos a
color como el SSD1289. Entender la diferencia entre los dos estilos me parece
básico para cualquiera que quiera programar una pantalla a bajo nivel, porque
un error en la temporización, por ejemplo esperar un flanco de `WR` cuando en
realidad el controlador necesita un pulso de `E`, simplemente hace que el
display no responda, sin dar ninguna otra pista de qué salió mal.

## Bibliografía (formato IEEE)

[1] Hitachi Ltd., "HD44780U (LCD-II) Dot Matrix Liquid Crystal Display Controller/Driver," Datasheet ADE-207-272(Z), Rev. 0.0, Sep. 1999.

[2] The Linux Kernel Documentation, "DT bindings for the Hitachi HD44780 Character LCD Controller." [En línea]. Disponible: https://www.kernel.org/doc/Documentation/devicetree/bindings/auxdisplay/hit%2Chd44780.txt

[3] NXP Semiconductors, "Using Freescale eGUI with TWR-LCD on MCF51MM Family," Application Note AN4153, Rev. 0, Aug. 2010.

[4] DisplayModule, "The Interface of 8080." [En línea]. Disponible: https://www.displaymodule.com/blogs/knowledge/the-interface-of-8080

[5] STMicroelectronics, "STE2004S," Datasheet, Rev. 3, Jan. 2007. [En línea]. Disponible: https://www.st.com/resource/en/datasheet/ste2004s.pdf
