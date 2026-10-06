Paso de estructuras grandes por referencia según AAPCS64
Introducción

La arquitectura AArch64, utilizada por los procesadores de 64 bits de Arm, establece una convención estándar para realizar llamadas entre funciones mediante el AAPCS64 (Procedure Call Standard for the Arm 64-bit Architecture). Esta especificación forma parte de la ABI (Application Binary Interface) de Arm y define las reglas necesarias para que diferentes funciones, compiladores y lenguajes puedan comunicarse correctamente a nivel binario.

Entre los aspectos más importantes definidos por AAPCS64 se encuentra la forma en que se pasan los parámetros a las funciones y cómo se devuelven los resultados. Esto es especialmente importante cuando se utilizan estructuras o tipos compuestos de gran tamaño. Una estructura puede contener varios datos y ocupar una cantidad considerable de memoria, por lo que intentar pasar todos sus elementos directamente mediante registros podría ser poco eficiente.

AAPCS64 establece reglas específicas para clasificar los tipos compuestos según sus características y tamaño. En el caso general, cuando una estructura tiene un tamaño superior a 16 bytes, no se pasa completamente mediante registros. En su lugar, el llamador realiza una copia de la estructura en memoria y pasa un puntero hacia esa copia. Este mecanismo se conoce como paso indirecto.

Es importante aclarar que este mecanismo no significa necesariamente que el lenguaje de programación esté realizando un paso por referencia. Por ejemplo, una estructura declarada como parámetro por valor en C continúa teniendo semántica de paso por valor. La convención AAPCS64 simplemente utiliza un puntero internamente para transportar de forma eficiente una estructura que no resulta conveniente colocar directamente en los registros.

El objetivo de esta investigación es explicar cómo funciona el paso de estructuras grandes según AAPCS64, cuáles son las reglas utilizadas, qué registros intervienen y cómo se relaciona este mecanismo con el paso de argumentos y el retorno de resultados.

Desarrollo técnico

AAPCS64 define diferentes reglas para el tratamiento de los tipos utilizados como argumentos de una función. Los tipos fundamentales, como enteros, punteros y determinados tipos de punto flotante, pueden ser colocados directamente en registros. Sin embargo, las estructuras, uniones y arrays se consideran tipos compuestos y requieren un tratamiento especial.

Por ejemplo, puede definirse la siguiente estructura en lenguaje C:

struct Datos {
long a;
long b;
long c;
long d;
};

En un entorno AArch64 que utiliza el modelo de datos LP64, un tipo long normalmente ocupa 8 bytes. Por lo tanto, la estructura anterior ocupa 32 bytes, suponiendo que no existan requisitos adicionales de alineación.

Como 32 bytes son más que el límite de 16 bytes establecido para el tratamiento directo de un tipo compuesto ordinario, AAPCS64 determina que esta estructura debe pasarse indirectamente. El llamador crea una copia de la estructura en memoria y utiliza un puntero hacia esa copia como argumento de la función.

Por ejemplo:

void procesar(struct Datos datos);

Desde el punto de vista del lenguaje, datos sigue siendo una estructura pasada por valor. Sin embargo, a nivel de la ABI, el mecanismo utilizado puede entenderse conceptualmente como:

void procesar(struct Datos *datos);

La diferencia es que esta transformación es realizada por el compilador y no por el programador. El programador continúa utilizando la declaración original y el compilador se encarga de cumplir las reglas de AAPCS64.

El límite de 16 bytes es una de las reglas más importantes para comprender este comportamiento. Cuando un Composite Type tiene un tamaño superior a 16 bytes, la especificación AAPCS64 establece que debe realizarse una copia en memoria asignada por el llamador y que el argumento debe sustituirse por un puntero a esa copia.

Por ejemplo, considérese:

struct Grande {
uint64_t a;
uint64_t b;
uint64_t c;
};

Cada elemento uint64_t ocupa 8 bytes, por lo que:

8 + 8 + 8 = 24 bytes

Como 24 bytes es mayor que 16 bytes, la estructura se pasa indirectamente.

Conceptualmente, cuando se realiza una llamada como:

procesar(grande);

el compilador puede generar un comportamiento equivalente a:

procesar(&copia_de_grande);

La dirección de esta copia se coloca en un registro de propósito general destinado a transportar los argumentos. En AArch64, los registros x0 a x7 se utilizan normalmente para pasar argumentos enteros, punteros y determinados tipos relacionados.

Si el puntero corresponde al primer argumento, una representación simplificada podría ser:

// x0 contiene la dirección de la copia
bl procesar

La función llamada puede utilizar el puntero contenido en x0 para acceder a los diferentes miembros de la estructura. Por ejemplo, si la estructura tiene tres valores de 64 bits, conceptualmente podría realizarse:

ldr x1, [x0]
ldr x2, [x0, #8]
ldr x3, [x0, #16]

La primera instrucción obtiene el primer miembro, la segunda obtiene el segundo y la tercera obtiene el tercero.

Sin embargo, es importante señalar que este ejemplo representa una explicación conceptual del mecanismo. El código real generado por un compilador puede ser diferente debido a las optimizaciones, la asignación de registros, la eliminación de copias y otras transformaciones realizadas durante la compilación.

La utilización de una copia en memoria es fundamental para mantener la semántica de paso por valor. Por ejemplo:

struct Grande {
uint64_t a;
uint64_t b;
uint64_t c;
};

void modificar(struct Grande datos) {
datos.a = 100;
}

Aunque AAPCS64 utilice un puntero para transportar la estructura, la función no debería modificar directamente el objeto original del llamador como ocurriría con un puntero explícito. La estructura recibida representa una copia del valor original. Por esta razón, modificar datos.a afecta al parámetro recibido y no necesariamente a la estructura original.

Esto permite diferenciar claramente entre paso por valor en el lenguaje y paso indirecto en la ABI. La primera expresión describe la semántica que observa el programador, mientras que la segunda describe la forma en que la información se transporta físicamente entre las funciones.

No todas las estructuras se pasan mediante un puntero. Una estructura pequeña puede ser colocada directamente en registros si cumple las condiciones establecidas por AAPCS64. Por ejemplo:

struct Pequeña {
uint64_t a;
uint64_t b;
};

Esta estructura ocupa 16 bytes. Bajo las condiciones apropiadas, sus datos pueden ser colocados directamente en registros como x0 y x1.

Conceptualmente:

x0 = a
x1 = b

De esta manera, no es necesario crear un puntero hacia una copia en memoria simplemente para transportar la estructura.

Además, AAPCS64 contempla excepciones relacionadas con los denominados HFA (Homogeneous Floating-point Aggregates) y HVA (Homogeneous Vector Aggregates). Estos son tipos compuestos formados por elementos homogéneos de punto flotante o vectores. Debido a sus características, pueden utilizar registros SIMD y de punto flotante para el paso de argumentos y resultados.

Por esta razón, no es correcto afirmar que cualquier estructura de más de 16 bytes siempre se pasa mediante un puntero sin considerar el resto de las reglas de clasificación. El procedimiento de clasificación de AAPCS64 debe aplicarse teniendo en cuenta las características específicas del tipo.

Otro aspecto importante es el uso de la pila. Cuando los argumentos no pueden ser colocados en los registros disponibles, AAPCS64 utiliza la memoria asociada con los argumentos en la pila. La especificación utiliza el concepto de NSAA (Next Stacked Argument Address), que permite determinar la siguiente dirección disponible para colocar un argumento en la memoria de la pila.

La alineación de los datos también es importante. Las estructuras pueden requerir una determinada alineación debido a sus miembros. AAPCS64 establece reglas que deben respetarse para garantizar que los datos sean correctamente accesibles y que diferentes funciones puedan interoperar de manera segura.

El paso indirecto también tiene una gran importancia cuando una función devuelve una estructura grande. Supongamos que se tiene:

struct Grande crear(void);

Si la estructura es demasiado grande para devolverse directamente mediante registros, el llamador reserva previamente un espacio de memoria donde se almacenará el resultado. La dirección de esta memoria se proporciona a la función llamada mediante el registro x8.

El registro x8 recibe un tratamiento especial en AAPCS64 y se utiliza como registro de ubicación del resultado indirecto.

Conceptualmente, el proceso puede representarse de la siguiente manera:

Memoria reservada por el llamador:

+--------------------------+
| |
| Resultado |
| 32 bytes |
| |
+--------------------------+

El llamador proporciona la dirección de esta zona mediante x8 y posteriormente realiza la llamada:

mov x8, direccion_resultado
bl crear

La función crear escribe el resultado directamente en la dirección indicada.

Este mecanismo permite devolver estructuras grandes sin necesidad de utilizar una gran cantidad de registros. En lugar de intentar transportar todos los bytes del resultado a través de los registros de retorno, la función escribe directamente en el espacio de memoria que fue preparado por el llamador.

Los argumentos grandes y los resultados grandes utilizan mecanismos relacionados, pero no idénticos. Para un argumento grande, el llamador proporciona una copia de la estructura y pasa un puntero hacia ella como parte de los argumentos normales. Para un resultado grande, el llamador reserva el espacio donde se almacenará el resultado y proporciona su dirección mediante x8.

Comprender estas reglas es especialmente importante para programadores que trabajan con ensamblador AArch64, compiladores, sistemas operativos y comunicación entre lenguajes. Por ejemplo, si una función en ensamblador debe ser llamada desde un programa escrito en C, el programador debe conocer AAPCS64 para saber dónde encontrará los argumentos y dónde debe escribir los resultados.

Si se desconoce esta convención, una función en ensamblador podría intentar leer una estructura grande desde los registros x0, x1, x2 y x3, cuando en realidad la ABI puede haber proporcionado solamente un puntero hacia una copia de la estructura. Esto provocaría resultados incorrectos o incluso errores de acceso a memoria.

Por lo tanto, AAPCS64 funciona como un contrato entre el código que realiza la llamada y el código que recibe la llamada. Ambas partes deben seguir las mismas reglas para que la comunicación sea correcta.

En resumen, una estructura grande no se transporta necesariamente copiando cada uno de sus miembros en registros. AAPCS64 permite que el compilador utilice memoria y punteros para manejar eficientemente estos objetos. Esta estrategia reduce la presión sobre los registros y permite trabajar con estructuras que pueden ocupar decenas, cientos o incluso más bytes.

Conclusiones

El AAPCS64 establece un conjunto de reglas fundamentales para garantizar la compatibilidad binaria entre funciones ejecutadas en sistemas AArch64. Una de las reglas más importantes para el manejo de tipos compuestos establece que, en el caso general, una estructura cuyo tamaño sea superior a 16 bytes se copia en memoria y se pasa indirectamente mediante un puntero.

Este mecanismo permite evitar el uso excesivo de registros y proporciona una forma eficiente de transportar estructuras grandes entre funciones. Sin embargo, debe distinguirse entre el paso indirecto utilizado por la ABI y el paso por referencia definido por un lenguaje de programación. Una estructura declarada como parámetro por valor mantiene su semántica de valor, aunque internamente se utilice una dirección de memoria para transportarla.

Las estructuras pequeñas pueden utilizar registros de propósito general, mientras que determinados tipos especiales, como los HFA y HVA, pueden utilizar registros de punto flotante y SIMD. Por lo tanto, la clasificación completa del tipo es necesaria antes de determinar cómo se realizará la llamada.

Para el retorno de estructuras grandes, AAPCS64 utiliza otro mecanismo indirecto. El llamador reserva espacio en memoria y proporciona su dirección mediante el registro x8, permitiendo que la función llamada escriba directamente el resultado en dicha ubicación.

En conclusión, conocer el funcionamiento del paso indirecto de estructuras grandes resulta esencial para comprender el funcionamiento interno de las llamadas a funciones en AArch64. También es fundamental para trabajar con lenguaje ensamblador, compiladores y programación de bajo nivel, ya que permite comprender exactamente cómo se comunican dos funciones a nivel binario.

Bibliografía

[1] Arm Ltd., “Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64),” Arm Architecture Procedure Call Standard, versión 2025Q4, Jan. 23, 2026. [En línea]. Disponible: https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst

[2] Arm Ltd., “Application Binary Interface for the Arm Architecture (ABI-AA),” Arm Ltd., 2026. [En línea]. Disponible: https://github.com/ARM-software/abi-aa

[3] Arm Ltd., “ELF for the Arm 64-bit Architecture (AAELF64),” Arm Architecture ABI, versión 2025Q4, Jan. 23, 2026. [En línea]. Disponible: https://github.com/ARM-software/abi-aa/blob/main/aaelf64/aaelf64.rst

[4] Arm Ltd., “C++ ABI for the Arm 64-bit Architecture,” Arm Architecture ABI, versión 2025Q4, Jan. 23, 2026. [En línea]. Disponible: https://github.com/ARM-software/abi-aa/blob/main/cppabi64/cppabi64.rst

[5] Arm Ltd., “ABI for the Arm Architecture: Releases,” Arm Ltd., 2026. [En línea]. Disponible: https://github.com/ARM-software/abi-aa/releases
