+ **Autor:** Joshua Jonathan Lara Fernandez de Lara
+ **Tema:** #16
+ **Materia:** Lenguajes de Interfaz - (17:00-18:00) 
+ **Grupo:** SCC-1014 - "B"
+ **Fecha:** 11/ Septiembre /2026
+ **Titulo del tema:** Cálculo de CRC-16 y CRC-32 en ensamblador para tramas de comunicación
+ **Descripcion:** Investigacion de las tramas de comunicacion CRC-16 y CRC-32 en las tramas de comunicacion

# Cálculo de CRC-16 y CRC-32 en ensamblador para tramas de comunicación


## ¿Qué es el CRC?

CRC es un algoritmo que se utiliza para detectar errores en la transmisión de datos. Este algoritmo genera una suma de comprobación, un valor de tamaño fijo derivado de los datos que se están transmitiendo. 

Dicha suma de comprobación se agrega a los datos y se envía junto con ellos. Cuando los datos llegan al receptor, este realiza el mismo algoritmo CRC y compara la suma de comprobación calculada con la recibida. Si coinciden, los datos se han transmitido correctamente. Si no, indica que ocurrieron errores durante la transmisión.

![CRC 16 / CRC 32 Checksum Generator (Modbus) Technical Diagram](https://cdn.shopify.com/s/files/1/0615/2193/articles/crc-16-crc-32-checksum-generator-modbus-diagram.png?v=1772188272)

## ¿Cómo funciona?

El CRC se basa en el tratamiento de los datos que se transmitirán como polinomios. El emisor y el receptor acuerdan un polinomio divisor fijo, a menudo denominado polinomio generador. Los datos se aumentan con una suma de comprobación, que es el resto de la división polinómica de los datos originales por el polinomio del generador.

Al final del remitente, se calcula la suma de comprobación de CRC y se anexa a los datos antes de la transmisión. Al final del receptor, los datos recibidos junto con la suma de comprobación se dividen por el mismo polinomio generador. Si el resto es cero, se supone que los datos están libres de errores; de lo contrario, se detecta un error.

## Ventajas por las que se usa sobre otras opciones

- El CRC es particularmente eficaz para detectar errores que podrían alterar el orden de los bits en un mensaje. Esto es muy importante en situaciones en las que mantener la secuencia exacta de bits es esencial para interpretar los datos correctamente.
- Una de las ventajas clave del CRC es su sencillez en la implementación, especialmente en el hardware binario. El algoritmo implica operaciones directas en bit, lo que lo hace eficiente para la verificación de errores basada en hardware.
- En los canales de comunicación del mundo real, el ruido es un compañero inevitable. El CRC es particularmente robusto en la detección de errores comunes introducidos por el ruido durante la transmisión de datos. Su naturaleza cíclica y su dependencia de la división polinomial le permiten identificar de manera eficaz los errores causados por fluctuaciones aleatorias o alteraciones en la señal.

## CRC-16 y CRC-32, ¿qué son?

**CRC-16:** Genera un valor de 16 bits (2 bytes). Se usa con frecuencia en redes industriales sencillas, sistemas de almacenamiento pequeños o protocolos como Modbus.

**CRC-32:** Genera un valor de 32 bits (4 bytes). Ofrece mayor seguridad contra errores y se emplea en redes de alta velocidad como Ethernet, así como en archivos comprimidos (ZIP, RAR) y formatos de imagen (PNG).

## ¿Qué es la trama de comunicación "Ethernet"?

Dentro de las redes Ethernet, los dispositivos conectados entre sí se intercambian paquetes de datos, denominados a su vez paquetes Ethernet. Cuando se produce dicha transmisión de datos, la trama Ethernet es la responsable de la configuración de las reglas de transmisión para conseguir el éxito en la misma.

Podríamos decir que los datos enviados dentro de redes Ethernet se transportan a través de la trama, la cual tiene un tamaño de entre 64 y 1518 bytes, en función del tamaño de los datos que transporte.

Las tramas Ethernet tienen información de control sobre los datos, información sobre las direcciones de origen y destino de los envíos y un registro de los datos enviados.

![Trama de comunicación serial con 1 bit de inicio, 8 bits de datos, 1 bit de parada a 9600 BAUD](https://hetpro-store.com/TUTORIALES/wp-content/uploads/2017/10/Distintas-Tramas-protocolo-Serial.jpg)



Para implementar CRC-16 y CRC-32 en Assembly (Ensamblador) para tramas de comunicación, el enfoque más eficiente y utilizado en sistemas embebidos o de comunicaciones es el método por tabla de búsqueda (Lookup Table). Calcularlo bit a bit es muy lento, mientras que con una tabla precalculada se procesa un byte completo a la vez.

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
