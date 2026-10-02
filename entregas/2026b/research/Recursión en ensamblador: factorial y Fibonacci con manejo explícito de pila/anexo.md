# ANEXO.md

### Asistencia de Inteligencia Artificial

- *Nivel de participación de IA*: 3 — Colaborativo extenso

La IA generó la mayor parte del borrador inicial de la investigación. Posteriormente, el contenido fue revisado, contrastado con los requisitos de la materia y adaptado para trabajar con la arquitectura objetivo.

- *Prompts utilizados*:
  - "Recursión en ensamblador: factorial y Fibonacci con manejo explícito de pila título, introducción, desarrollo técnico (mínimo 500 palabras), conclusiones y bibliografía en formato IEEE. hazlo paro solo copiar y pegar en git hub"
  - "¿Cómo se maneja la pila explícitamente en ARM64 (AArch64) dado que no existen instrucciones PUSH y POP como en x86?"

- *Herramientas utilizadas*:
  - ChatGPT

- *Cambios o mejoras realizadas tras usar pensamiento crítico*:
  - El primer borrador generado por la IA utilizaba x86-64, con registros como RAX y RDI e instrucciones PUSH y POP.
  - Debido a que el curso trabaja con ARM/AArch64, se identificó que ese primer resultado no correspondía directamente a la arquitectura objetivo.
  - Se solicitó una versión orientada a AArch64 y se revisó el manejo explícito de la pila.
  - Para el prólogo y epílogo de las funciones se consideró el uso de STP/LDP para preservar x29 (FP) y x30 (LR), además de mantener la alineación de la pila requerida por AAPCS64.
  - Se revisó la lógica recursiva para distinguir el caso base de las llamadas recursivas y para identificar qué valores deben conservarse entre llamadas.
  - No se considera válida una afirmación de funcionamiento en hardware real a menos que exista una prueba realizada y documentada por el estudiante.

- *Referencias oficiales o verificaciones adicionales consultadas*:
  - Arm, Procedure Call Standard for the Arm 64-bit Architecture (AAPCS64).
  - Arm, documentación de la arquitectura A64 sobre las instrucciones STP y LDP y el uso de la pila.
  - Las referencias bibliográficas incluidas en la investigación fueron revisadas para comprobar su correspondencia con el contenido.

- *Reflexión personal*:
  La IA fue utilizada como apoyo para obtener un borrador de la explicación y ejemplos de ensamblador. La revisión posterior fue necesaria porque la primera respuesta no estaba adaptada a la arquitectura utilizada en la materia. El proceso permitió identificar que una respuesta sintácticamente válida puede seguir siendo incorrecta para el contexto del curso si utiliza otra arquitectura, otra convención de llamadas o instrucciones que no existen en AArch64.

- *Explicación propia de una decisión técnica central* (obligatoria por declarar Nivel 3):

  
  >Se tomo la decision en este trabajo de utilizar las instrucciones STP y LPD para manejar la pila en AARCH64, esto resuelve el problema de que AARCH64 no maneja las instrucciones de PUSH y POP como en otras arquitecturas. STP almacena 2 registros consecutivos en la pila, a diferencia de LPD que solo los recupera posteriormente, esto nos resulta bastante util para preservar x29 y x30, que x29 se utiliza como fraim pronter y x30 contiene la direccion de retorno de la funcion. Para la Función recursiva de Fibonacci, la pila conserva informacion necesaria de cada llamada mientras se realizan otras >llamadas. Un ejemplo podria ser que el valor de n de una llamada puede mantenerse en la pila para recuperrlo despues se calcula una de la ramas recursivas. Entonces cada llamda puede mantener su propio contexto y continuar cuando se regrese a la funcion llamada.
  
 

- *Fecha*: 2026-09-21

- *Plataforma utilizada*: Revisión y elaboración del material con ChatGPT; la implementación debe indicar por separado el entorno de compilación/prueba realmente utilizado por la estudiante.
