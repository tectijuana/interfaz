Nombre: Jovel Cuen Mario Alejandro  
Numero de Control: 24212672   
Clase: Lenguajes de Interfaz "B" 17:00 pm
#

# Manipulación de texto UTF-8 a nivel de bytes

![Imagen](https://linube.com/blog/wp-content/uploads/utf-8.jpg)

## ¿Qué es UTF-8?
> “UTF-8” es la abreviatura de “8-bit UnicodeTransformation Format” y designa a la codificación de caracteres más extendida en la World Wide Web. El estándar internacional Unicode incluye tanto signos lingüísticos como elementos textuales de casi todos los idiomas, para el procesamiento electrónico de datos. Por ello, los códigos UTF-8 desempeñan para Unicode un papel fundamental.
>

## ¿Qué es un Byte?
> Un byte es una unidad fundamental de almacenamiento de datos en la informática. Compuesto por 8 bits, un byte puede almacenar un carácter, una cifra o una instrucción, posicionándose como el pilar esencial para que las computadoras almacenen y procesen información.
>

## ¿Como funciona la manipulación de UTF-8 a nivel de bytes?
La codificación UTF-8 sorprende por la compatibilidad retrógrada con ASCII y, por otro, por una estructura capaz de auto sincronizarse que les facilita a los desarrolladores la tarea de atisbar fuentes de error retrospectivamente UTF utiliza sólo 1 byte para todos los caracteres ASCII y el número total de cadenas de bits puede identificarse en las primeras cifras del número binario. Dado que el código ASCII sólo comprende 7 bits, el código es 0. El 0 completa el espacio de memoria hasta llegar a un byte entero y señaliza el inicio de una cadena sin cadenas sucesivas. El nombre “UTF-8” se expresa, por ejemplo, como número binario con la codificación UTF-8 de la siguiente manera:

| Carácter | U | T | F | - | 8 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| UTF-8, binario | 01010101 | 01010100 | 01000110 | 00101101 | 00111000 |
| Punto de Unicode, hexadecimal | U+0055 | U+0054 | U+0046 | U+002D | U+0028 |

La codificación UTF-8 asigna una única cadena de bits a los caracteres ASCII como los empleados en la tabla. Los siguientes caracteres y símbolos dentro de Unicode tienen de dos a cuatro cadenas de 8 bits. La primera cadena recibe el nombre de byte de inicio y las cadenas siguientes son bytes sucesivos. Los bytes de inicio con bytes sucesivos siempre empiezan por 11 y los bytes sucesivos por 10. Si se busca un determinado punto en el código manualmente, puede reconocerse el principio de un carácter codificado con los marcadores 0 y 11. El primer carácter multibyte imprimible es el signo de exclamación invertido:

| Carácter | i |
| :--- | :--- | 
| UTF-8, binario | 11000010 10100001 |
| Punto de Unicode, hexadecimal | U+00A1 |

La codificación de prefijos evita que se codifique un carácter adicional en una cadena de bytes. Si una secuencia de bytes comienza a mitad de un documento, el ordenador seguirá mostrando los caracteres legibles, ya que no visualiza los caracteres incompletos. Si desde el principio buscas un carácter, la limitación de 4 bytes hará que no sea necesario que retrocedas en ningún punto más de tres cadenas de bytes para localizar el byte de inicio:

* 110xxxxx representa 2 bytes
* 1110xxxx representa 3 bytes
* 11110xxx representa 4 bytes

En Unicode, el valor del byte asignado se corresponde con el número del carácter, lo que permite un orden léxico, aunque hay algunas brechas. El rango de Unicode comprendido entre U+007F y U+009F comprende números de control no asignados. Así, el estándar UTF-8 no asigna caracteres imprimibles, sino solo comandos.

Como ya se ha señalado, la codificación UTF-8 puede, en teoría, enlazar cadenas de hasta 8 bytes. Sin embargo, Unicode requiere una longitud de máximo 4 bytes. Esto tiene, por un lado, como consecuencia que las cadenas de bytes con 5 bytes o más no suelen ser válidas. Por otro, esta limitación es reflejo del afán de crear un código lo más compacto (con bajo consumo de memoria) y estructurado posible. Así, una norma fundamental al emplear UTF-8 es que siempre debe utilizarse la codificación más corta posible.

Sin embargo, para algunos caracteres existen múltiples codificaciones equivalentes. Por ejemplo, la letra ä se codifica con 2 bytes: 11000011 10100100. Teóricamente, es posible combinar los puntos de código para la letra “a” (01100001) y el signo diacrítico “ ” (11001100 10001000) para representar “ä”: 01100001 11001100 10001000. Aquí se utiliza la llamada forma de normalización Unicode NFD, en la que los caracteres se descomponen de manera canónica. Ambas codificaciones mostradas conducen al mismo resultado (es decir, “ä”) y, por lo tanto, son canónicamente equivalentes*.

Hay algunos rangos de valores de Unicode sin definir para UTF-8, pues estos se utilizan para los sustitutos de UTF-16. El cuadro siguiente muestra los bytes de UTF-8 permitidos según el grupo Internet Engineering Task Force (IETF).

| Rango de valores de UTF-8 | - | Significado |
|---|---|---|
| **Notación decimal** | **Notación binaria** | - |
| 0 - 127 | 00000000 - 01111111 | 1 byte; correponde a caracteres a ASCII |
| 128 - 191 | 10000000 - 10111111 | Byte en segundo y cuarto lugar |
|  192 - 193 | 11000000 - 11000001 | No válido: cadenas de bytes muy larga (2 byte) para los carateres del rango 0 - 127 |
| 194 - 244 | 11000010 - 11011111 | Byte de inicio para secuencias con 2 bytes |
|           | 11100000 - 11101111 | Byte de inicio para secuencias con 3 bytes |
|           | 11110000 - 11110100 | Byte de inicio para secuencias con 4 bytes |
| 245 - 255 | 11110101 - 11110111 | No válido: Byte de inicio para secuencias de 4 bytes fuera del rango de Unicode |
|           | 11111000 - 11111011 | No válido: Byte de inicio para secuencias de 5 bytes |
|           | 11111100 - 11111101 | No válido: Byte de inicio para secuencias de 6 bytes |
|           | 11111110 - 11111111 | No válido: No definido, reservado para UTF-16 |

# Conclusión
Como conclusión se puede tomar que UTF- 8 es una forma importante de representar y manejar textos en computadora por que permite trabajar con caracteres de distintos idiomas utilizando una cantidad variable de bytes. Al conocer cómo se organizan los bytes de inicio y sus sucesivos es posible entender cómo una computadora puede lograr entender y interpretar correctamente un carácter. 

## Bibliografia 

[1] IONOS Digital Guide, “UTF-8: codificación para una comunicación digital global,” 20 de noviembre de 2025. Disponible en: https://www.ionos.mx/digitalguide/paginas-web/creacion-de-paginas-web/utf-8-codificacion-para-una-comunicacion-digital-global/

[2] Arsys, “¿Qué es UTF-8 y qué ventajas tiene?,”. Disponible en: https://www.arsys.es/blog/utf8.

[3] IONOS Digital Guide, “¿Qué es un byte? Te explicamos la cantidad más pequeña de datos,”. Disponible en: https://www.ionos.mx/digitalguide/paginas-web/desarrollo-web/que-es-un-byte/
