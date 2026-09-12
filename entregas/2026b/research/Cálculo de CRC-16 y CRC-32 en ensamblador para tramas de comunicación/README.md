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

![CRC 16 / CRC 32 Checksum Generator (Modbus) Technical Diagram](https://cdn.shopify.com/s/files/1/0615/2193/articles/crc-16-crc-32-checksum-generator-modbus-diagram.png?v=1772188272)

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

![Trama de comunicación serial con 1 bit de inicio, 8 bits de datos, 1 bit de parada a 9600 BAUD](https://hetpro-store.com/TUTORIALES/wp-content/uploads/2017/10/Distintas-Tramas-protocolo-Serial.jpg)

### Ejemplo de código CRC-16 (Python)

```python
def calcular_crc16(datos: bytes) -> int:
    crc = 0xFFFF
    for b in datos:
        crc ^= b
        for _ in range(8):
            if (crc & 0x0001):
                crc = (crc >> 1) ^ 0xA001
            else:
                crc = crc >> 1
    return crc

# Ejemplo de uso:
mensaje = b"\x05\x06\x05\x02\x00\x01"
resultado = calcular_crc16(mensaje)
print(f"CRC-16: {resultado:04X}")  # Salida esperada: E882
```

### Ejemplo de código CRC-32 (Python)

```python
import zlib

datos = b"Hola, mundo!"

# Calcula el CRC-32 y asegura valor sin signo (unsigned)
crc_valor = zlib.crc32(datos) & 0xFFFFFFFF
print(f"CRC-32 en hexadecimal: {crc_valor:08X}")
```

## Conclusión

El CRC se considera como un mecanismo esencial para garantizar la integridad de los datos en cualquier trama de comunicación, gracias a su capacidad de detectar errores mediante operaciones matemáticas simples pero muy efectivas basadas en división polinomial, por lo que es la solucion mas empleada en el mundo digital cuando se trata de transmitir informacion de una punto a otro conectado en la misma red.

## Bibliografia

[1] EverpureData, "What is a Cyclic Redundancy Check (CRC) in Networking?," *EverpureData*, 2023. [En linea]. Disponible: https://www.everpuredata.com/la/knowledge/cyclic-redundancy-check.html. [Accedido: 10-sep-2026].

[2] Lenovo, "¿Qué es la comprobación de redundancia cíclica (CRC) y cómo funciona?," *Glosario Lenovo*. [En Linea]. Disponible: https://www.lenovo.com/mx/es/glosario/crc/. [Accedido: 10-sep-2026].

[3] GEYMA, "¿Qué es la trama Ethernet?: Tipos de Tramas Ethernet," *Blog GEYMA*, 28-may-2021. [En Linea]. Disponible: https://www.geyma.com/blog/trama-ethernet/. [Accedido: 11-sep-2026].

[4] R. Estrada-Marmolejo, "Puerto Serial – protocolo y su teoría," *HeTPro-Tutoriales*, 27-oct-2017. [En Linea]. Disponible: https://hetpro-store.com/TUTORIALES/puerto-serial/. [Accedido: 11-sep-2026].

[5] R. Dickson, "CRC-16 / CRC-32 Checksum Generator (Modbus)," *FIRGELLI Automations*, 24-feb-2026. [En Linea]. Disponible: https://www.firgelliauto.com/blogs/engineering-calculators/crc-16-crc-32-checksum-generator-modbus. [Accedido: 11-sep-2026].
