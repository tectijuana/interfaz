# Medición y optimización de latencia en interfaces de tiempo real

TELLEZ RUIZ MARIA REBECA
Ingeniería en Sistemas Computacionales
Lenguajes de Interfaz
Tema: Medición y optimización de latencia en interfaces de tiempo real

 Introducción

Cuando usamos una aplicación esperamos que responda después de realizar alguna acción. Por ejemplo, cuando presionamos un botón esperamos que suceda algo casi de inmediato. Si la aplicación tarda mucho en responder, podemos pensar que se trabó o que algo está funcionando mal. A este retraso se le conoce como latencia.

La latencia es importante en las interfaces de tiempo real porque en este tipo de sistemas el tiempo de respuesta tiene bastante importancia. No solamente se necesita que el programa entregue un resultado correcto, también se necesita que lo haga en el momento adecuado.

Este problema se puede presentar por diferentes razones. Puede ser por una operación que tarda demasiado, una consulta a una base de datos, una conexión lenta, demasiados procesos ejecutándose al mismo tiempo o incluso por la forma en que está programada la interfaz.

Por eso, para poder mejorar una aplicación primero es necesario medir cuánto tarda en responder y buscar qué parte está causando el problema. En este trabajo se explica qué es la latencia, cómo se puede medir, cuáles son algunas de sus causas y qué métodos existen para reducirla.

## ¿Qué es la latencia?

La latencia es básicamente el tiempo que pasa entre una acción y la respuesta del sistema.

Un ejemplo muy sencillo sería un botón de una aplicación. El usuario hace clic y después de un momento aparece el resultado. Ese tiempo entre el clic y la respuesta forma parte de la latencia que percibe el usuario.

El proceso podría verse de esta manera:

Usuario realiza una acción
          ↓
La interfaz recibe la acción
          ↓
El programa procesa la información
          ↓
Se obtiene el resultado
          ↓
La interfaz se actualiza
          ↓
El usuario ve la respuesta


Aunque algunas de estas operaciones pueden tardar muy poco, cuando se van acumulando pueden hacer que la aplicación se sienta lenta.

La latencia también puede aparecer cuando una aplicación se comunica con otro equipo. Por ejemplo, si una aplicación necesita pedir información a un servidor, la solicitud tiene que viajar por la red, ser procesada y después regresar con una respuesta.

## Interfaces de tiempo real

Las interfaces de tiempo real son importantes en aplicaciones donde la información necesita actualizarse o responder en un periodo determinado.

Un ejemplo puede ser una aplicación que recibe información de sensores. Si el sensor envía un dato y la interfaz tarda demasiado en mostrarlo, el usuario podría estar viendo información que ya no representa correctamente lo que está sucediendo.

También existen sistemas donde una respuesta tardía puede afectar el funcionamiento general. Por eso, en estos casos no solamente interesa que el resultado sea correcto, sino también cuándo se obtiene.

En una interfaz normal, unos segundos de espera pueden ser molestos. En un sistema que necesita respuestas rápidas, una demora puede ser un problema mucho más importante.

## Diferencia entre latencia y tiempo de respuesta

Los dos conceptos están relacionados, pero no necesariamente significan exactamente lo mismo.

La latencia puede referirse al retraso que existe entre dos eventos. El tiempo de respuesta puede representar todo el tiempo que tarda una solicitud desde que comienza hasta que el usuario recibe el resultado.

Por ejemplo:


Clic del usuario
      ↓
Solicitud
      ↓
Procesamiento
      ↓
Consulta de información
      ↓
Respuesta
      ↓
Actualización de pantalla


Si desde el clic hasta la actualización pasan 500 milisegundos, ese sería aproximadamente el tiempo que el usuario tuvo que esperar para obtener el resultado.

## ¿Por qué se debe medir?

Antes de intentar hacer más rápida una aplicación, primero se necesita saber qué parte está tardando.

Si un programa parece lento, se podría pensar que el problema está en la base de datos, pero después de hacer mediciones se puede descubrir que el problema realmente está en otra parte.

Por eso es mejor seguir un proceso:


Medir
  ↓
Analizar
  ↓
Encontrar el problema
  ↓
Optimizar
  ↓
Medir nuevamente


De esta forma se puede comprobar si el cambio realmente funcionó.

También es importante hacer varias pruebas. Una sola prueba no siempre representa el comportamiento normal de un programa porque la computadora puede estar realizando otras tareas al mismo tiempo.

## ¿Cómo se puede medir la latencia?

Una manera sencilla de medir el tiempo de una operación es registrar el momento en que comienza y el momento en que termina.

Por ejemplo:


inicio = tiempo actual

realizar operación

fin = tiempo actual

latencia = fin - inicio

Si una operación comienza en 1000 milisegundos y termina en 1150 milisegundos:


1150 - 1000 = 150 ms

La operación tardó 150 milisegundos.

En un programa real se pueden utilizar funciones de medición de tiempo proporcionadas por el lenguaje de programación. Lo importante es medir exactamente la parte que se quiere analizar.

## Ejemplo de varias mediciones

Supongamos que tenemos un botón que realiza una consulta y queremos saber cuánto tarda.

Podemos realizar varias pruebas:

| Prueba | Tiempo |
| 1      | 120 ms |
| 2      | 118 ms |
| 3      | 125 ms |
| 4      | 121 ms |
| 5      | 240 ms |
| 6      | 119 ms |
| 7      | 123 ms |
| 8      | 117 ms |
| 9      | 122 ms |
| 10     | 120 ms |

La mayoría de los resultados están cerca de 120 milisegundos, pero la prueba 5 tardó 240 milisegundos.

Esto puede indicar que en esa ejecución ocurrió algo diferente. Por ejemplo, otro proceso pudo estar utilizando recursos de la computadora o pudo existir alguna espera durante la operación.

Por eso no es buena idea revisar solamente un resultado. Es mejor realizar varias pruebas y comparar los datos.

Algunos valores que se pueden obtener son:

* Tiempo mínimo.
* Tiempo máximo.
* Promedio.
* Mediana.
* Percentiles.
* Variación entre las pruebas.

## Principales causas de latencia

La latencia puede tener diferentes causas dependiendo de cómo esté construida la aplicación.

### Procesamiento

Una función que realiza demasiados cálculos puede tardar más tiempo de lo necesario. Si existen operaciones que no son necesarias, eliminarlas puede ayudar a mejorar el rendimiento.

### Memoria

El uso de memoria también puede influir. Una aplicación que maneja demasiada información al mismo tiempo puede consumir muchos recursos y afectar su funcionamiento.

### Red

Las aplicaciones que necesitan Internet o comunicarse con un servidor pueden tener retrasos debido a la conexión.

Por ejemplo, si una aplicación necesita enviar una solicitud al servidor y esperar la respuesta, el usuario tendrá que esperar todo ese proceso.

### Bases de datos

Las consultas a bases de datos pueden tardar cuando se maneja una gran cantidad de información o cuando la consulta no está bien optimizada.

Esto puede notarse especialmente cuando una interfaz necesita consultar datos cada vez que el usuario realiza una acción.

### Almacenamiento

Leer y guardar información también requiere tiempo. Si una aplicación realiza muchas operaciones de lectura y escritura, esto puede afectar el tiempo de respuesta.

### Bloqueos

Un bloqueo ocurre cuando una tarea tiene que esperar a que otra termine para poder continuar. Si esto ocurre dentro de una interfaz, puede provocar que el usuario sienta que el programa se congeló.

### Actualización de la interfaz

También se puede producir retraso cuando la interfaz realiza demasiadas actualizaciones al mismo tiempo.

Una aplicación con muchos elementos visuales o procesos ejecutándose en el mismo momento puede perder fluidez.

## Técnicas para reducir la latencia

Existen diferentes formas de intentar reducir la latencia.

### Eliminar operaciones innecesarias

Una de las opciones más sencillas es revisar el código y eliminar procesos que realmente no sean necesarios.

Si una aplicación hace diez operaciones cuando solamente necesita hacer cinco, reducirlas puede ayudar a disminuir el tiempo de respuesta.

### Mejorar los algoritmos

La forma en que se resuelve un problema también afecta el rendimiento.

Un algoritmo que necesita realizar muchas operaciones puede tardar más que otro que resuelve el mismo problema de una manera más eficiente.

Por eso, cuando existe un problema de rendimiento, también es importante revisar los algoritmos utilizados.

### Usar caché

La caché permite guardar temporalmente información que se utiliza con frecuencia.

Por ejemplo, si una aplicación necesita consultar el mismo dato muchas veces, podría guardar temporalmente ese dato para no tener que obtenerlo nuevamente.

Esto puede reducir algunas operaciones y mejorar el tiempo de respuesta.

### Procesamiento asíncrono

Otra opción es utilizar procesos asíncronos para operaciones que pueden tardar.

Por ejemplo, si una aplicación necesita consultar información de Internet, no necesariamente tiene que bloquear toda la interfaz mientras espera la respuesta.

De esta manera el usuario puede seguir viendo la interfaz mientras la operación continúa en segundo plano.

### Reducir solicitudes de red

Si una aplicación realiza demasiadas solicitudes a un servidor, se puede revisar si algunas de ellas pueden evitarse o combinarse.

También puede ser conveniente enviar solamente la información que realmente se necesita.

### Optimizar consultas

En aplicaciones que utilizan bases de datos es importante revisar las consultas que se realizan.

Una consulta que busca información innecesaria puede tardar más que una consulta que solamente obtiene los datos necesarios.

## Latencia que percibe el usuario

No toda la latencia se siente de la misma manera.

Si una aplicación tarda muy poco en responder, probablemente el usuario ni siquiera lo note. En cambio, si una acción tarda varios segundos, es posible que la persona piense que la aplicación dejó de funcionar.

Cuando una operación necesita tiempo, se pueden utilizar elementos que indiquen que el proceso sigue funcionando.

Algunos ejemplos son:

* Indicadores de carga.
* Barras de progreso.
* Mensajes como "Cargando".
* Animaciones.
* Mostrar el estado de una operación.

Estos elementos no hacen que la operación sea más rápida, pero ayudan a que el usuario entienda qué está pasando.

Por ejemplo, no es lo mismo ver una pantalla que parece congelada que ver un mensaje que diga "Cargando información...".

## Ejemplo de optimización

Supongamos que tenemos una aplicación que consulta información de una base de datos.

Primero realizamos algunas pruebas:

| Prueba |  Antes |
| 1      | 620 ms |
| 2      | 650 ms |
| 3      | 630 ms |
| 4      | 680 ms |
| 5      | 640 ms |

Después revisamos la consulta y hacemos algunos cambios para obtener solamente la información que necesitamos.

Volvemos a realizar las pruebas:

| Prueba | Después |
| 1      |  420 ms |
| 2      |  410 ms |
| 3      |  430 ms |
| 4      |  415 ms |
| 5      |  425 ms |

En este ejemplo se puede observar que el tiempo disminuyó.

Lo importante es que no solamente se está diciendo que la aplicación es más rápida. Tenemos datos que permiten comparar cómo funcionaba antes y cómo funciona después.

## Sistemas de tiempo real y tiempos máximos

En un sistema de tiempo real puede ser importante conocer no solamente el promedio de las mediciones, sino también cuánto puede tardar una operación en el peor caso.

Por ejemplo, imaginemos que una aplicación normalmente responde en 50 milisegundos, pero algunas veces tarda varios segundos.

Aunque el promedio pueda parecer bueno, esas demoras pueden representar un problema si el sistema necesita responder de forma constante.

Por esta razón se pueden revisar aspectos como:

* Tiempo promedio.
* Tiempo máximo.
* Variación.
* Frecuencia de retrasos.
* Uso de CPU.
* Uso de memoria.
* Prioridad de las tareas.

## Rendimiento y uso de recursos

Una optimización no siempre consiste en reducir el tiempo sin importar lo demás.

A veces una técnica puede hacer que una operación sea más rápida, pero utilizar más memoria o CPU.

Por ejemplo, guardar muchos datos en caché puede reducir algunas consultas, pero también aumenta el uso de memoria.

Por eso es necesario buscar un equilibrio entre:

Velocidad
   +
Memoria
   +
CPU
   +
Red
   +
Almacenamiento


La mejor opción depende de las necesidades de cada aplicación.

## Proceso para optimizar una interfaz

Un proceso sencillo para trabajar con la latencia puede ser:

1. Identificar la acción que parece lenta.
2. Medir cuánto tarda.
3. Realizar varias pruebas.
4. Revisar los resultados.
5. Buscar la causa del retraso.
6. Aplicar un cambio.
7. Volver a realizar las pruebas.
8. Comparar los resultados.
9. Mantener el cambio si realmente produjo una mejora.

Este proceso ayuda a evitar cambiar partes del programa sin saber si realmente son responsables del problema.

## Análisis personal

Considero que la latencia es un tema importante porque muchas veces como usuarios solamente pensamos que una aplicación es lenta, pero no sabemos exactamente por qué.

Al investigar el tema entendí que existen diferentes partes que pueden generar un retraso. No necesariamente significa que el programa esté mal hecho. Puede ser una consulta, la red, la cantidad de información que se procesa o la forma en que se actualiza la interfaz.

También me parece importante realizar varias mediciones. Si solamente se mide una vez, puede ocurrir que ese resultado sea diferente al comportamiento normal de la aplicación.

Otro punto que me pareció interesante es que mejorar la experiencia del usuario no siempre significa reducir la latencia. Si una operación necesita tiempo, mostrar un indicador de carga puede hacer que el usuario entienda que el programa sigue funcionando.

Por lo tanto, considero que la mejor forma de trabajar con este problema es primero medir, después encontrar la causa y finalmente realizar una optimización. Después se deben repetir las pruebas para comprobar si realmente hubo una mejora.

## Conclusión

La latencia es el retraso que existe entre una acción y la respuesta de un sistema. En las interfaces de tiempo real es un aspecto importante porque el sistema necesita responder de manera rápida y, en algunos casos, dentro de ciertos límites de tiempo.

Existen diferentes causas de latencia, como el procesamiento, la memoria, las conexiones de red, las bases de datos, el almacenamiento, los bloqueos y las actualizaciones de la interfaz.

Para reducirla existen diferentes técnicas, como mejorar los algoritmos, eliminar operaciones innecesarias, utilizar caché, realizar operaciones de manera asíncrona y optimizar las consultas o comunicaciones.

Lo más importante es no realizar cambios solamente porque una aplicación parece lenta. Primero se deben realizar mediciones para conocer dónde está el problema. Después se puede aplicar una solución y volver a medir para comprobar el resultado.

En conclusión, medir y optimizar la latencia ayuda a crear interfaces que no solamente funcionan correctamente, sino que también responden de una forma más fluida para el usuario.

## Bibliografía

* Mozilla Developer Network (MDN). Documentación sobre rendimiento y latencia en aplicaciones web.
* Microsoft Learn. Documentación sobre medición y rendimiento de aplicaciones.
* Microsoft Learn. Documentación sobre diagnóstico y optimización del rendimiento.
* IEEE Xplore. Publicaciones relacionadas con sistemas de tiempo real y rendimiento.
