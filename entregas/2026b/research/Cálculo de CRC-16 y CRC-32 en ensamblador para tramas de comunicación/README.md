+ **Autor:** Joshua Jonathan Lara Fernandez de Lara
+ **Tema:** #16
+ **Materia:** Lenguajes de Interfaz - (17:00-18:00) 
+ **Grupo:** SCC-1014 - "B"
+ **Fecha:** 11/ Septiembre /2026
+ **Titulo del tema:** Cálculo de CRC-16 y CRC-32 en ensamblador para tramas de comunicación
+ **Descripcion:** Investigacion de las tramas de comunicacion CRC-16 y CRC-32 en las tramas de comunicacion

# Cálculo de CRC-16 y CRC-32 en ensamblador para tramas de comunicación


## ¿Qué es el CRC?

El método CRC trata la información a enviar como si fueran expresiones polinómicas. Tanto el dispositivo que envía como el que recibe deben ponerse de acuerdo previamente en un polinomio divisor, conocido como polinomio generador. A la información original se le añade un código de verificación, que corresponde al residuo obtenido al dividir dicha información entre el polinomio generador.

Imagen del polinomio generador CRC-32:

![Polinomio calculador de CRC-32](https://thumb.wikimedia.org/wikipedia/commons/thumb/1/16/CRC-32.jpg/960px-CRC-32.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=thumbnail)

## ¿Cómo funciona?
El CRC se basa en el tratamiento de los datos que se transmitirán como polinomios. El emisor y el receptor acuerdan un polinomio divisor fijo, a menudo denominado polinomio generador. Los datos se aumentan con una suma de comprobación, que es el resto de la división polinómica de los datos originales por el polinomio del generador.

Del lado del emisor, se obtiene este código y se coloca al final de los datos antes de enviarlos. Del lado del receptor, se toma la información junto con el código recibido y se divide nuevamente entre el mismo polinomio. Si el resultado de esa división da como residuo cero, se asume que la información no tiene errores; si el residuo es distinto de cero, se identifica que existió un problema en la transmisión.

## Ventajas por las que se usa sobre otras opciones

- El CRC destaca por su capacidad para detectar fallos que modifiquen el orden de los bits dentro de un mensaje, algo fundamental en contextos donde conservar la secuencia correcta de bits resulta indispensable para leer bien la información.
- En los sistemas de comunicación reales, el ruido siempre está presente. El CRC resulta ser especialmente confiable para detectar este tipo de errores que el ruido provoca durante el envío de datos. Gracias a su carácter cíclico y a que se apoya en la división de polinomios, logra detectar con eficacia errores generados por interferencias o variaciones inesperadas en la señal.

## CRC-16 y CRC-32, ¿qué son?

**CRC-16:** Genera un valor de 16 bits (2 bytes). Se usa con frecuencia en redes industriales sencillas, sistemas de almacenamiento pequeños o protocolos como Modbus.

**CRC-32:** Genera un valor de 32 bits (4 bytes). Ofrece mayor seguridad contra errores y se emplea en redes de alta velocidad como Ethernet, así como en archivos comprimidos (ZIP, RAR) y formatos de imagen (PNG).

## ¿Qué es la trama de comunicación "Ethernet"?

En las redes tipo Ethernet, los equipos conectados se comunican mediante el envío de paquetes de información, llamados paquetes Ethernet. Durante este proceso de transmisión, la trama Ethernet cumple la función de establecer las normas necesarias para que el envío se complete correctamente.

Se puede decir que la información que circula por redes Ethernet viaja dentro de la trama, cuyo tamaño varía entre 64 y 1518 bytes, dependiendo de la cantidad de datos que contenga.

Cada trama Ethernet incluye datos de control, las direcciones tanto de origen como de destino, y un registro de la información transmitida.

## Ejemplo de codigo CRC-32 (assembly)
# CRC-32 bit a bit en ARM64 (AArch64)

Implementación del CRC-32 (IEEE 802.3) escrita directamente en ensamblador ARM64, usando el algoritmo **bit a bit** (sin tabla de lookup). Este es el método "clásico" del que se deriva la versión optimizada con tabla precomputada.

## Código

```asm
// crc32_bitwise_arm64.s
// CRC-32 (IEEE 802.3) calculado bit a bit, sin tabla de lookup.

    .section .text
    .global crc32_bitwise
    .type crc32_bitwise, %function
crc32_bitwise:
    mvn     w0, w0              

    movz    w5, #0x8320
    movk    w5, #0xedb8, lsl #16

    cbz     x2, .Ldone          

.Lbyte_loop:
    ldrb    w3, [x1], #1     
    eor     w0, w0, w3          
    mov     w4, #8              

.Lbit_loop:
    tst     w0, #1              
    lsr     w0, w0, #1         
    beq     .Lskip_xor
    eor     w0, w0, w5          
.Lskip_xor:
    subs    w4, w4, #1
    bne     .Lbit_loop

    subs    x2, x2, #1
    bne     .Lbyte_loop

.Ldone:
    mvn     w0, w0              
    ret
```

## Como funciona

- **Inicialización/finalización (`mvn w0, w0`)**
  Invierte todos los bits del CRC al inicio y al final (equivalente a `crc ^ 0xFFFFFFFF`). Es una convención estándar del CRC-32 para que los ceros al principio o al final del mensaje no queden "invisibles" en el resultado.

- **Carga del polinomio (`movz` / `movk`)**
  El valor `0xEDB88320` es el polinomio generador del CRC-32 en su forma reflejada (*bit-reversed*). No se puede meter directamente en una instrucción `EOR` como inmediato porque no cumple el formato de "máscara lógica" que exige ARM64, así que se construye en dos pasos:
  - `movz w5, #0x8320` carga los 16 bits bajos.
  - `movk w5, #0xedb8, lsl #16` inserta los 16 bits altos sin tocar los bajos.

- **Bucle externo (`.Lbyte_loop`)**
  Recorre el buffer byte por byte con `ldrb w3, [x1], #1` (carga un byte y avanza el puntero automáticamente), y lo combina con el CRC actual mediante XOR.

- **Bucle interno (`.Lbit_loop`)**
  Por cada byte, se repite 8 veces (una por cada bit):
  1. `tst w0, #1` — revisa si el bit menos significativo del CRC es 1, sin modificar el registro.
  2. `lsr w0, w0, #1` — desplaza el CRC un bit a la derecha.
  3. Si el bit revisado era 1, aplica `eor w0, w0, w5` (XOR con el polinomio). Si era 0, no hace nada (salta a `.Lskip_xor`).

- **Contadores y saltos**
  `w4` cuenta los 8 bits de cada byte; `x2` cuenta los bytes restantes del buffer. `subs` resta y actualiza flags en un solo paso, y `bne` repite el bucle correspondiente mientras el contador no llegue a cero.

## Conclusión

El CRC se considera como un mecanismo esencial para garantizar la integridad de los datos en cualquier trama de comunicación, gracias a su capacidad de detectar errores mediante operaciones matemáticas simples pero muy efectivas basadas en división polinomial, por lo que es la solucion mas empleada en el mundo digital cuando se trata de transmitir informacion de una punto a otro conectado en la misma red.

## Bibliografia

[1] EverpureData, "What is a Cyclic Redundancy Check (CRC) in Networking?," *EverpureData*, 2023. [En linea]. Disponible: https://www.everpuredata.com/la/knowledge/cyclic-redundancy-check.html. [Accedido: 10-sep-2026].

[2] Lenovo, "¿Qué es la comprobación de redundancia cíclica (CRC) y cómo funciona?," *Glosario Lenovo*. [En Linea]. Disponible: https://www.lenovo.com/mx/es/glosario/crc/. [Accedido: 10-sep-2026].

[3] GEYMA, "¿Qué es la trama Ethernet?: Tipos de Tramas Ethernet," *Blog GEYMA*, 28-may-2021. [En Linea]. Disponible: https://www.geyma.com/blog/trama-ethernet/. [Accedido: 11-sep-2026].

[4] R. Estrada-Marmolejo, "Puerto Serial – protocolo y su teoría," *HeTPro-Tutoriales*, 27-oct-2017. [En Linea]. Disponible: https://hetpro-store.com/TUTORIALES/puerto-serial/. [Accedido: 11-sep-2026].

[5] R. Dickson, "CRC-16 / CRC-32 Checksum Generator (Modbus)," *FIRGELLI Automations*, 24-feb-2026. [En Linea]. Disponible: https://www.firgelliauto.com/blogs/engineering-calculators/crc-16-crc-32-checksum-generator-modbus. [Accedido: 11-sep-2026].

[6] I. Vilums, "Fast CRC Algorithm," 1984. [En Linea]. Available: http://www.eastjesus.net/tech/tgi/Paper6_Fast_CRC_Algorithm_1984.pdf. [Accedido: 14-Sep-2026].

[7] Eseye, "CRC-32 code example," Eseye Documentation, 2024. [En Linea]. Available: https://docs.eseye.com/Content/SIMOnly/CRC32codeExample.htm. [Accedido: 14-Sep-2026].
