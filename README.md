

# Lenguajes de Interfaz 2.0 – Propuesta de Curso Moderno e Innovador

## Introducción y Contexto

El curso **Lenguajes de Interfaz 2.0** está diseñado como una renovación moderna de la asignatura tradicional "Lenguajes de Interfaz", integrando aprendizajes de los últimos cuatro años de experiencia docente. En un mundo donde las tendencias tecnológicas avanzan rápidamente, se enfoca en **tres pilares técnicos clave**:

* **Scripting en Shell (Bash)** – para la automatización y administración eficiente de sistemas en entornos Unix/Linux.
* **Programación en lenguaje ensamblador ARM (32 y 64 bits)** – dado el auge de arquitecturas ARM en dispositivos modernos, desde smartphones hasta las Macs con **Apple Silicon**.
* **Introducción al desarrollo sobre arquitectura RISC-V** – en respuesta a la creciente adopción de RISC-V en la industria y la academia.

**Justificación:** Grandes tendencias motivan esta actualización curricular. Apple ha migrado sus Macs a procesadores ARM propios (Apple M1/M2), logrando mayores niveles de rendimiento y eficiencia energética en sus equipos. Paralelamente, RISC-V – una arquitectura **abierta** y libre de licencias – está ganando terreno. Con el impulso de RISC-V alcanzando masa crítica, el mundo académico finalmente reconoció la demanda industrial y abrazó RISC-V como arquitectura para enseñar. Universidades líderes como **MIT** y **ETH Zurich** ya integran RISC-V en cursos y laboratorios, aprovechando su naturaleza abierta para desarrollar material educativo innovador. En este contexto, **TecNM Campus Tijuana** busca posicionarse a la vanguardia, ofreciendo un curso aspiracional al nivel de prácticas de Harvard o MIT, que prepare a estudiantes en estas tecnologías emergentes.

Este curso se impartirá en un **semestre corto de 3 meses**, con sesiones de **4 horas por semana** (aproximadamente 48 horas totales). Está dirigido a estudiantes de Ingeniería en Sistemas Computacionales de niveles mixtos (desde intermedio hasta avanzado), por lo que combina fundamentos con retos profundos, asegurando que cada estudiante pueda **aprender por descubrimiento** y escalar su conocimiento. Se adoptará una modalidad mixta: *laboratorios prácticos en la nube* y *prácticas con hardware físico*, emulando entornos profesionales reales.

## Objetivos de Aprendizaje

Al finalizar **Lenguajes de Interfaz 2.0**, el estudiante será capaz de:

* **Automatizar tareas en Linux** mediante scripts Bash, aplicando buenas prácticas de programación de *shell* para administrar sistemas y agilizar flujos de trabajo rutinarios.
* **Comprender la arquitectura ARM** de 32 y 64 bits, incluyendo su conjunto de instrucciones, modos de direccionamiento y manejo de registros, para desarrollar programas en ensamblador que interactúen eficientemente con el hardware.
* **Programar aplicaciones sencillas en ensamblador ARM** (tanto en entornos bare-metal como sobre sistemas operativos Linux), explotando características de ARMv7 (32-bit) y ARMv8-A (64-bit).
* **Explorar la arquitectura RISC-V**, entendiendo sus principios de diseño abiertos, y desarrollar código básico en ensamblador RISC-V utilizando simuladores o entornos de desarrollo especializados.
* **Integrar múltiples lenguajes de interfaz** (shell, ensamblador) en un proyecto, por ejemplo, automatizando la compilación/ejecución de código ensamblador con scripts, o interactuando con dispositivos de bajo nivel controlados con código assembler.
* **Utilizar herramientas modernas de desarrollo y colaboración**, incluyendo entornos de nube (VMs en AWS), repositorios GitHub para control de versiones, y documentación compartida, emulando prácticas profesionales de DevOps y desarrollo de software colaborativo.
* **Aplicar pensamiento crítico y autodidacta** apoyándose en recursos modernos (documentación open source, comunidades en línea, e incluso asistentes de IA como ChatGPT) para resolver problemas, con ética y efectividad.

## Duración, Estructura y Público

* **Duración:** 12 semanas (3 meses), 4 horas semanales. Se sugiere dividir cada semana en 2 sesiones de 2 horas (o una sesión larga con breve receso) para equilibrar teoría y práctica.
* **Modalidad:** Clases presenciales o híbridas con apoyo de laboratorio en la nube. Las sesiones combinarán exposición magistral breve, talleres prácticos en laboratorio de cómputo y discusión de casos/prácticas.
* **Perfil de estudiantes:** Alumnos de Ingeniería en Sistemas (5º a 8º semestre). Se considera un grupo heterogéneo en nivel, por lo que se cubrirán fundamentos para nivel intermedio, seguidos de desafíos y extensiones para estudiantes avanzados. Se recomienda que los estudiantes tengan conocimientos previos de programación en C/C++ o Python y nociones básicas de arquitectura de computadoras (registros, memoria, sistema operativo básico).

## Contenidos y Unidades del Curso

El temario se organiza en **tres unidades principales**, alineadas con los pilares técnicos, más un proyecto integrador final. Cada unidad incluye contenido teórico, actividades prácticas y un mini-proyecto o desafío.

### Unidad 1: Scripting en Shell (Bash) – 3 semanas

**Temas principales:** Fundamentos del intérprete de comandos Bash; comandos esenciales de Linux; estructura de scripts (shebang, permisos); variables de entorno y locales; control de flujo (*if, for, while*); uso de tuberías y redirecciones; gestión de procesos (*jobs, background, signals*); funciones en Bash; *scripting* aplicado a automatización de tareas administrativas.

**Enfoque práctico:** Al ser la base para el trabajo posterior, se iniciará con hands-on en un servidor Linux Ubuntu 20.04/22.04 proporcionado vía **AWS Academy**. Cada estudiante contará con acceso a una instancia EC2 Ubuntu en la nube (o una VM local) donde podrá conectarse por SSH. Esto permite practicar en un entorno unificado y controlado (similar a cómo Harvard CS50 provee IDEs cloud a sus alumnos).

**Ejercicios y mini-proyectos:**

* Escribir scripts para tareas cotidianas: por ejemplo, un script de *backup* simple que archive cierto directorio, o un automatizador de análisis de logs.
* Desafío 1: **“Setup & Health Check”** – un script que instala paquetes, configura el entorno de desarrollo (por ejemplo, instalar toolchains de ARM y RISC-V), verifica versiones y configura alias útiles.
* Desafío 2: **“Monitor de Sistema”** – crear un script que reporte uso de CPU, memoria y espacio en disco, enviando alertas (ej. por correo o mensaje) si exceden umbrales.
* Introducción a herramientas modernas: uso básico de Git en la terminal (clonar un repo, hacer *commit & push* de un script al repositorio del curso en GitHub).

> **Recursos recomendados (Shell):**
>
> * Manual *online* de Bash (`man bash`) y guía TLDP "Advanced Bash Scripting".
> * Tutorial interactivo de Shell en **Codecademy** o **bashshell.net** (para refuerzo autodidacta).
> * Repositorio GitHub con ejemplos de scripts (se proporcionará un repo plantilla con ejemplos vistos en clase).
> * *Shell scripting* es una habilidad esencial que permite a los ingenieros automatizar tareas, agilizar procesos y administrar sistemas de forma eficiente – los ejercicios enfatizarán estas ventajas prácticas.

### Unidad 2: Programación en Ensamblador ARM (32 y 64 bits) – 5 semanas

**Temas principales:** Arquitectura ARM vs x86 (RISC vs CISC); modos de operación (ARMv7 de 32 bits, ARMv8-A de 64 bits); conjunto de registros (registro general, PC, SP, LR, etc.); instrucciones aritméticas, lógicas y de control de flujo en ARM; diferencias entre conjunto AArch32 y AArch64; sistema de memoria en ARM (endianness, alineamiento); llamadas a sistema en Linux ARM (uso de *syscalls*); ensamblado y ligadura de programas (uso de **GNU assembler (as)** y **ld** o la cadena *gcc*); depuración básica con GDB en ARM; optimizaciones y uso de instrucciones SIMD/neon (introductorio, si el tiempo lo permite).

**Enfoque práctico:** Aprovecharemos hardware accesible **ARM** para practicar ensamblador en contexto real. El laboratorio contará con microcomputadoras **Raspberry Pi Zero 2 W** (CPU Broadcom ARM Cortex-A53, 64-bit) que cada equipo de estudiantes puede usar. Alternativamente, se podrá usar emulación QEMU ARM dentro de las instancias Ubuntu de AWS si algún estudiante no tiene acceso físico al Pi.

Cada práctica involucrará escribir código ensamblador ARM, ensamblarlo con `as` o compilar con `gcc` (utilizando *inline assembly* o archivos `.s`), y probar su ejecución en el Pi (que correrá Raspberry Pi OS o Ubuntu Server ARM). Para ARM 32 bits, se explorará el *subset* Thumb o ARMv7 utilizando posiblemente un **Raspberry Pi Pico W** (microcontrolador ARM Cortex-M0+ de 32 bits) para una visión de bare-metal; en ese caso, se introducirá el uso de **ARM GNU toolchain** cruzada para compilar código que se flashee al microcontrolador.

**Ejercicios y mini-proyectos:**

* Practicar con rutinas sencillas: suma de números, manipulación de arreglos, implementación de algoritmos básicos (ej. factorial, Fibonacci) en ensamblador.
* Explorar la interacción con el sistema: una práctica consistirá en invocar llamadas al sistema Linux desde ensamblador (ejemplo: invocar `write()` para imprimir en consola, manejar archivos).
* **Proyecto intermedio:** *Rutinas de procesamiento de datos en ARM*: Los estudiantes implementarán en ensamblador una rutina de cálculo (por ejemplo, algoritmo de cifrado simple, o procesamiento de una imagen en formato RAW), y luego la integrarán con un script Bash que llame a esa rutina varias veces con distintos parámetros, midiendo tiempos. Esto unirá Unidad 1 y 2 (script + assembler).
* **Apple ARM Discussion:** Se dedicará una breve sesión a analizar la arquitectura **Apple M1/M2** como caso de estudio motivador. Aunque no programaremos directamente en M1, se explicará su base ARMv8, su uso de unificado de memoria, y cómo Apple logró rendimiento notable (multi-core, aceleradores). Se conecta así la teoría con un ejemplo de la industria real.

> **Recursos recomendados (ARM):**
>
> * Libro “**Introducción a Linux ARM Assembly**” (disponible en línea, ex. material de coursera o apuntes del instructor compilados).
> * Documentación oficial ARM: *ARMv7-M Reference* (para microcontroladores) y *ARM Cortex-A Series Programming*.
> * Tutoriales prácticos: Blog de Azeria sobre ARM Assembly (en inglés, muy didáctico para 32-bit) y documentación de Raspberry Pi (secciones de assembler y interfacing hardware).
> * Repositorio GitHub del curso con ejemplos de código ARM (incluyendo makefiles y scripts de compilación cruzada).
> * La **Raspberry Pi**, por su versatilidad y bajo costo, es una herramienta ideal para proyectos educativos. Se aprovechará para que los alumnos experimenten con *hardware* real, reforzando la motivación al ver sus programas controlando un dispositivo físico (ej. encender un LED con código en ensamblador).

### Unidad 3: Introducción a la Arquitectura y Desarrollo RISC-V – 2 semanas

**Temas principales:** Origen de RISC-V (diseño abierto desde UC Berkeley); filosofía RISC y modularidad de RISC-V (conjuntos base y extensiones); conjunto de registros RISC-V (RV32I y RV64I); instrucciones básicas de RISC-V y comparativa con ARM (similitudes y diferencias en la sintaxis de ensamblador); herramientas de desarrollo RISC-V (toolchain GCC RISC-V, simuladores como SPIKE, RVemu, o entornos educativos como RARS); casos de uso actuales de RISC-V (IoT, aceleradores, etc.).

**Enfoque práctico:** Al ser una introducción breve, se utilizarán principalmente **simuladores/Emuladores** en lugar de hardware físico (a menos que se cuente con placas RISC-V en laboratorio, e.g. SiFive Boards o Arduino RISC-V). Los estudiantes trabajarán en la instancia Ubuntu configurando el toolchain RISC-V (posiblemente usando un contenedor Docker ya preparado con todo el entorno). Alternativamente, se puede emplear un IDE *online* como RISC-V Venus o RARS para practicar instrucciones en un ambiente visual.

**Ejercicios:**

* Ensamblar y correr un programa "Hola Mundo" en RISC-V (usando llamadas al sistema de Linux RISC-V si se usa emulador Unix, o en entorno simulado minimalista).
* Adaptar una rutina ya hecha en ARM (ej. suma de arreglo) a RISC-V, resaltando las diferencias mínimas en código.
* Analizar por qué RISC-V es interesante: experimentar con la extensión pseudo-instrucciones, comentar la sencillez del conjunto base.
* Investigación breve (actividad grupal): Cada equipo investiga un caso real de RISC-V en la industria o en proyectos open-source (por ejemplo, el microcontrolador ESP32-C3, los chips de NVIDIA, etc.) y lo expone brevemente, para conectar con la relevancia práctica.

**Reflexión final Unidad 3:** Se enfatiza que RISC-V está ganando fuerte adopción. *“Con el momentum de RISC-V, la academia ha adoptado RISC-V como la arquitectura a enseñar”*; de hecho, universidades de élite (MIT, ETH Zurich, Univ. Bolonia, etc.) ya han migrado sus cursos de arquitectura hacia RISC-V. Nuestros estudiantes obtendrán así una familiaridad temprana con esta tecnología emergente, haciéndolos competitivos a futuro.

> **Recursos recomendados (RISC-V):**
>
> * **The RISC-V Reader** (Patterson & Waterman) – libro introductorio a la ISA RISC-V.
> * **Computer Organization and Design RISC-V Edition** – capítulos selectos sobre ensamblador RISC-V.
> * Tutoriales en línea de RISC-V (ej: *RISC-V Green Card* – tarjeta de referencia rápida de instrucciones).
> * Simulador **RARS (RISC-V)** para prácticas tipo laboratorio de arquitectura.
> * Repositorio del curso con ejemplos RISC-V (incluyendo un makefile para compilar y correr en Spike emulator).

### Proyecto Integrador Final – 2 semanas

En las últimas dos semanas, los estudiantes desarrollarán un **proyecto integrador** que combine los pilares aprendidos. Este proyecto debe ser desafiante pero alcanzable, fomentando la creatividad y aplicación integral de conocimientos. Algunas propuestas de proyecto integrador:

* **“Mini Sistema Embebido”**: Desarrollar una aplicación para Raspberry Pi Pico (microcontrolador) en ensamblador que lea datos de un sensor (por ejemplo, temperatura) y los envíe a la Raspberry Pi Zero vía puerto serial. En la Pi Zero, un script Bash recibe esos datos y los guarda en log o incluso los envía a un servicio web. Este proyecto conecta ensamblador bare-metal (Pico) con scripting en un entorno Linux (Pi Zero).
* **“Analyzador de Performance ARM vs RISC-V”**: Implementar un algoritmo (ej. multiplicación de matrices pequeñas o encriptación XOR) tanto en ensamblador ARM como en ensamblador RISC-V. Automatizar la ejecución comparativa con un script Bash (posiblemente usando QEMU para RISC-V) para medir tiempos y comparar rendimiento. Los estudiantes documentan resultados y discuten diferencias arquitectónicas que puedan influir.
* **“Shell extendido con Assembly”**: Crear comandos personalizados para Bash escritos en ensamblador. Por ejemplo, escribir una rutina en ensamblador ARM que calcula estadísticas de un archivo (conteo de líneas, palabras) más rápido que usando utilidades estándar, y llamarla desde Bash como un comando propio. Esto implicaría manejar paso de argumentos del shell al programa en ensamblador y retorno de resultados.

**Entrega y documentación:** El proyecto se desarrollará en equipos de 2-3 integrantes. Deberán utilizar un repositorio en **GitHub** para el código, aprovechando *issues* y *Wiki/README* para documentar el proceso. Toda la documentación (objetivos, diseño, instrucciones de uso) debe centralizarse en el repo, siguiendo buenas prácticas de proyectos de código abierto. Esto no solo facilita el seguimiento por parte del docente, sino que entrena a los alumnos en colaboración real usando control de versiones.

Cada proyecto contará con una **rúbrica de evaluación** clara (ver siguiente sección), y los estudiantes presentarán una demo al final (presentación de \~15 minutos, estilo *lightning talk* + demo técnica).

## Metodología de Enseñanza y Recursos

El curso adopta metodologías activas y apoyos tecnológicos inspirados en instituciones de clase mundial:

* **Aprendizaje basado en proyectos:** Como se indicó, un proyecto integrador y proyectos intermedios en cada unidad fomentan que el estudiante aplique conocimientos de forma integrada y contextual. Esto sigue el modelo de cursos como MIT 6.xxx donde proyectos prácticos consolidan teoría.
* **Laboratorios en la nube:** Siguiendo la tendencia de cursos como Harvard CS50 (que provee entornos estandarizados en la nube para todos sus alumnos), en Lenguajes de Interfaz 2.0 los estudiantes utilizarán instancias *cloud* (AWS Academy) para disponer de un Linux uniforme. Esto evita problemas de configuración local y permite que cada alumno experimente en un **Ubuntu Server remoto vía SSH**, replicando un ambiente profesional de servidor.
* **Laboratorio físico moderno:** Complementariamente, el curso propone un laboratorio con microcomputadoras Raspberry Pi. La **Raspberry Pi Zero 2 W** provee una experiencia de Linux completo en ARM, y la **Raspberry Pi Pico W** acerca al mundo de los microcontroladores. Ambas permiten a estudiantes la emoción de programar hardware real. Según disponibilidad, se organizarán prácticas en parejas o tríos, rotando hardware si es limitado. *Nota:* La versatilidad y bajo costo de estos dispositivos los hace ideales para la educación, permitiendo que con una modesta inversión el laboratorio cuente con múltiples equipos trabajando en paralelo.
* **Documentación y GitHub:** Todo el material del curso (enunciados de prácticas, códigos de ejemplo, rúbricas, lecturas recomendadas) estará centralizado en un repositorio GitHub de la clase. Además, cada estudiante (o equipo) gestionará sus entregas mediante repositorios personales (p. ej., usando **GitHub Classroom** para distribuir y recoger actividades). GitHub no solo facilita la entrega, sino que entrena en control de versiones y colaboración distribuida – una habilidad clave en la industria.
* **Aspiración y creatividad:** Se motivará a los estudiantes a ver más allá del currículo mínimo. Charlas breves sobre tendencias (p.ej., *soft* talk sobre cómo Apple diseña sus chips ARM, o cómo RISC-V puede cambiar la industria) se intercalarán para inspirar. Los estudiantes tendrán espacios para investigar y compartir (por ejemplo, exposiciones cortas sobre temas asignados, como mencionar algún uso real de Bash scripting en DevOps, o un proyecto open-source relevante en RISC-V).
* **Recursos abiertos:** Siguiendo la filosofía de aprendizaje abierto de Harvard/MIT, se proporcionará una lista de recursos abiertos: manuales gratuitos, documentación oficial, foros, y se incentivará a los alumnos a utilizarlos. Por ejemplo, en lugar de un libro de texto cerrado, se usarán manuales en línea y referencias técnicas accesibles libremente.

## Uso de ChatGPT-5 como Asistente Didáctico

Un componente innovador será la incorporación responsable de herramientas de IA generativa (como ChatGPT 4.5) en el proceso de aprendizaje:

* **Asistente de codificación y duda:** Los estudiantes podrán apoyarse en ChatGPT para resolver dudas conceptuales, buscar explicaciones de código assembler o Bash, u obtener pistas cuando se atasquen en un problema. Por ejemplo, pueden pedir *"¿Cómo funciona este fragmento de código ARM?"* y recibir aclaraciones instantáneas. En la Universidad Brown (EE.UU.), se experimentó con un asistente virtual llamado *GPTA* (basado en ChatGPT) configurado para responder preguntas conceptuales con ejemplos de código pero sin dar soluciones completas a tareas. Inspirados en ello, se recomendará a los alumnos usar ChatGPT de forma ética: **sí** para entender conceptos o generar ejemplos adicionales, **no** para simplemente obtener la respuesta a las tareas.
* **Prácticas autónomas:** Se guiará a los estudiantes en el uso de ChatGPT para generar ejercicios adicionales. Por ejemplo, tras cubrir Bash, un alumno curioso puede pedir *"Genera 5 ejercicios de práctica de Bash scripting con dificultad creciente"* y obtener material para reforzar su habilidad. Del mismo modo, pueden solicitar *feedback* sobre su pseudocódigo o enfoques de solución. ChatGPT puede actuar como un tutor 24/7, disponible cuando el docente no lo esté.
* **Verificación y pensamiento crítico:** Se enfatizará la importancia de **verificar** la información dada por la IA. Los estudiantes aprenderán a no confiar ciegamente: por ejemplo, si ChatGPT sugiere un código, deberán probarlo y entenderlo. Esta es una oportunidad para desarrollar criterio y habilidades de debugging. Incluso, se puede asignar una breve actividad donde el alumno formule una pregunta a ChatGPT sobre un tema del curso y luego evalúe la calidad de la respuesta, discutiendo en clase cualquier error u omisión que la IA haya tenido.
* **Guía de uso:** Como parte del curso, se proveerán lineamientos de prompts efectivos para programadores (cómo pedir ayuda de forma concreta, cómo solicitar explicación de errores, etc.). También se tocará el aspecto ético: por ejemplo, no publicar en foros las preguntas de los exámenes/pruebas para que la IA las resuelva, respeto a la honestidad académica, etc.

El objetivo es preparar a los estudiantes para un mundo donde la colaboración con inteligencias artificiales será parte natural del desarrollo de software. Bien utilizada, una IA puede ser un *coach* personal que potencie el aprendizaje; mal usada, puede inhibir el desarrollo de pensamiento propio. Se les educará para lo primero.

## Evaluación y Rúbricas

La evaluación será continua e integral, alineada con el modelo por competencias y usando **rúbricas** claras (administradas mediante la plataforma *iDoceo* del docente para transparencia). La siguiente tabla resume la distribución sugerida de calificaciones:

| **Componentes de Evaluación**                 | **Descripción**                                                                                                                                                                                                                               | **Ponderación** |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------: |
| **Tareas y Prácticas de Laboratorio**         | Ejercicios prácticos de cada unidad (scripts, programas en asm). Se evalúa funcionalidad, calidad de código y reporte breve. *Rubrica:* cumple requerimientos, uso correcto de instrucciones, estilo/comentarios, reflexión de resultados.    |             40% |
| **Proyecto Integrador Final**                 | Desarrollo en equipo del proyecto integrador. Incluye código, documentación en GitHub y presentación. *Rúbrica:* solución técnica (correctitud, complejidad, innovación) 50%, documentación y repositorio 30%, presentación/demostración 20%. |             25% |
| **Exámenes o Quizzes** (2 mid-terms opcional) | Evaluaciones escritas o prácticas cortas al final de Unidad 1 y 2 para comprobar comprensión (ej. analizar un código en ensamblador y describir qué hace, escribir un fragmento de script). Estas pueden ser en formato práctico.             |             20% |
| **Participación y trabajo en clase**          | Incluye asistencia, participación en debates, miniexposiciones (p.ej., presentación de caso RISC-V), y uso adecuado de herramientas (Git commits regulares, interacción con GPT según lo permitido, etc.).                                    |             15% |

*Nota:* Se puede ajustar la ponderación según las políticas de la institución. Si no se desean exámenes formales, ese 20% puede redistribuirse a prácticas/proyecto. La clave es incentivar la práctica constante sobre la memorización.

**Rúbricas de Evaluación:** Cada entrega vendrá acompañada de una rúbrica detallada en iDoceo. Por ejemplo, para un *script Bash*, criterios como *"Funcionalidad completa (el script cumple todos los requerimientos)"*, *"Manejo de errores (valida entradas, maneja casos excepcionales)"*, *"Buenas prácticas (estructura clara, comentarios, uso de funciones si aplica)"*, *"Originalidad o optimización (solución eficiente o creativa)"*. Cada criterio se calificará en niveles (Excelente, Satisfactorio, Necesita Mejora, Deficiente) con descripciones concretas. Estas rúbricas se entregarán al alumno junto con la tarea, para que sepa exactamente qué se espera. La retroalimentación será proporcionada vía la plataforma y GitHub (por ejemplo, comentando directamente en el código en pull requests, simulando un código revisado en la vida real).

Este esquema de evaluación busca no solo calificar, sino **retroalimentar para el aprendizaje**. Al usar rúbricas, el estudiante identifica en qué área puede mejorar (quizá su código funciona pero carece de comentarios, etc.), cerrando el ciclo de mejora continua.

## Cronograma Tentativo del Curso

A continuación se presenta un posible cronograma semanal, integrando los temas, actividades prácticas y entregables principales:

| **Semana** | **Temas / Contenido**                                                                                                                                                                          | **Laboratorio / Actividades**                                                                                                                                                                          | **Entregables (fin de semana)**                                                                                                                                  |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1**      | **Introducción al curso**. Importancia de Bash y ASM en la actualidad. Configuración entorno (Ubuntu AWS, GitHub). **Linux básico**: comandos, estructura de directorios, permisos.            | - Acceso a instancias AWS, configuración de SSH.<br>- Práctica guiada: comandos básicos, navegación en Shell.                                                                                          | *Checklist* de entorno listo (SSH funcionando, repositorio Git creado).                                                                                          |
| **2**      | **Shell scripting I**: Variables, operadores, estructuras de control en Bash.                                                                                                                  | - Escribir primer script (Hola Mundo, variables, condicional).<br>- Mini-lab: script que pide nombre y saluda con formato.                                                                             | Tarea 1: Script básico interactivo (validación de entradas).                                                                                                     |
| **3**      | **Shell scripting II**: Loops, funciones, tuberías y redirecciones. Introducción a scripting para administración (grep, cron, etc.).                                                           | - Lab: escribir un script que procese un archivo de texto (contar palabras, filtrar líneas).<br>- Uso de tuberías con grep/awk en scripts.                                                             | Tarea 2: Script de análisis de logs (lee archivo y extrae info).                                                                                                 |
| **4**      | **Introducción a ARM**: Arquitectura RISC vs CISC, registros ARM, conjunto de instrucciones básico (ARM32). Ensamblador vs lenguaje máquina.                                                   | - Taller: “Hello World” en ARM assembly (32-bit) usando QEMU o Raspberry Pi; mostrar en pantalla usando syscall write.                                                                                 | Ejercicio en clase (no calificado): Código ASM simple comentado.                                                                                                 |
| **5**      | **ARM Ensamblador I (32-bit)**: Instrucciones aritméticas y de datos, manejo de memoria (cargar/almacenar), modos de direccionamiento. Subrutinas (BL, manejo de LR/PC).                       | - Lab: implementar suma de un arreglo en ASM (ARM32) en Raspberry Pi Pico o emulador.<br>- Usar GDB para depurar registro por registro.                                                                | Tarea 3: Funciones en ASM (ej: calcular Fibonacci iterativo en ARM32).                                                                                           |
| **6**      | **ARM Ensamblador II (64-bit)**: Introducción a ARMv8-A (AArch64). Diferencias en registros (x0-x30) y en instrucciones. Llamadas al sistema en 64-bit.                                        | - Lab: repetir ejercicio de suma de arreglo pero en ARM64 (Raspberry Pi Zero 2 con Raspbian 64-bit).<br>- Explorar neon (SIMD) brevemente con un ejemplo simple.                                       | **Proyecto intermedio** (entrega semana 8 anunciada): Planteamiento del proyecto integrador parte 1 (e.g., especificar qué rutina ASM + script Bash integrarán). |
| **7**      | **Interfacing ASM-Bash**: Comunicación entre un programa en ensamblador y un script Bash. Uso de archivos o pipes para intercambiar datos.                                                     | - Lab integrador: invocar un programa ASM desde Bash (ej: Bash ejecuta binario .out, captura su salida, la procesa).<br>- Ajustes al proyecto: sesiones de asesoría por equipos.                       | Quiz 1 (teórico-práctico) unidades 1-2. *(Ejecutado en clase)*                                                                                                   |
| **8**      | **Introducción a RISC-V**: Historia y principios. Registros RV32, instrucciones básicas (ADD, SUB, LW, SW, BEQ, etc.).                                                                         | - Lab: “Hola Mundo” en RISC-V usando simulador (Venus o Spike + proxy kernel).<br>- Comparar código RISC-V vs ARM para misma tarea simple.                                                             | Entrega proyecto intermedio: Código parcial y documentación inicial (por GitHub).                                                                                |
| **9**      | **RISC-V Ensamblador**: Estructura de un programa RISC-V completo (segmentos .text, .data), llamadas al sistema en RISC-V Linux.                                                               | - Lab: implementar en RISC-V un algoritmo sencillo ya visto en ARM (ej: factorial) y verificar salida en simulador.<br>- Discusión: ecosistema RISC-V actual.                                          | Tarea 4: Ejercicios RISC-V (resolver 2-3 problemas cortos en asm RISC-V).                                                                                        |
| **10**     | **Tópicos avanzados/integradores**: Optimización básica de asm, uso de C/ASM en conjunto (mencionar inline assembly). Tendencias: CPUs ARM vs RISC-V a futuro, caso Apple Silicon (discusión). | - Taller creativo: los equipos trabajan en su proyecto integrador con supervisión del docente (resolución de dudas).<br>- Simulacro de presentación: cada equipo ensaya explicar su proyecto en 5 min. | Quiz 2 (Unidad 3 & avanzados) – puede ser evaluación de código RISC-V o preguntas cortas. *(Opcional según evaluación escogida)*                                 |
| **11**     | **Presentaciones Proyecto Final (parte 1)**: mitad de equipos presentan su proyecto integrador (demos en vivo, Q\&A). Retroalimentación.                                                       | - Presentaciones de \~15 min por equipo con demostración en vivo (conectar Pi al proyector, etc.). Los no-presentantes evalúan a sus compañeros (peer review guiado).                                  | Entrega final de código y documentación del proyecto en GitHub (fecha límite al final de Semana 11 o inicio de 12).                                              |
| **12**     | **Presentaciones Proyecto Final (parte 2)**: segunda mitad de equipos. Cierre y conclusiones. Futuras ediciones (feedback).                                                                    | - Ronda final de presentaciones.<br>- Discusión colectiva: ¿qué fue lo más difícil? ¿qué aprenderían después? Importancia de aprendizaje continuo (lifelong learning).                                 | Cierre del curso. Encuesta de retroalimentación del curso por estudiantes.                                                                                       |

*(El cronograma es flexible y puede ajustarse según el ritmo del grupo; por ejemplo, algunas semanas se puede dedicar más tiempo a Bash si es muy nuevo para todos, o extender ARM una semana más si se profundiza en neon SIMD.)*

## Conclusión: Visión y Preparación para el Futuro

**Lenguajes de Interfaz 2.0** representa una propuesta educativa de vanguardia que busca **unificar teoría y práctica**, inspirar a los estudiantes con relevancia real y prepararlos para un entorno tecnológico en rápida evolución. Al adoptar prácticas de instituciones líderes (proyectos abiertos, uso intensivo de herramientas colaborativas, experimentación con hardware moderno y tendencias actuales), el curso se vuelve aspiracional: no solo enseña "lo de siempre", sino que apunta a **formar ingenieros versátiles, autónomos y actualizados**.

El énfasis en ARM y RISC-V coloca a los estudiantes en sintonía con la industria contemporánea – desde el desarrollo móvil hasta la próxima generación de IoT y computación de alto rendimiento. La incorporación del *cloud lab* y el uso de IA generativa responsablemente proveen experiencias acordes al siglo XXI, ampliando las posibilidades de aprendizaje más allá del aula tradicional.

En suma, esta propuesta brinda a TecNM Campus Tijuana la oportunidad de liderar en la enseñanza de lenguajes de bajo nivel e interfaz hombre-máquina, fomentando en sus alumnos las habilidades y mentalidad que les permitirán no solo adaptarse, sino **impulsar** las próximas innovaciones tecnológicas. ¡Bienvenidos al futuro con Lenguajes de Interfaz 2.0! 🚀

**Referencias y Apoyos:** Todas las fuentes y materiales mencionados (artículos, tutoriales, documentación) estarán accesibles desde el repositorio del curso. Por ejemplo, la transición histórica de Apple a ARM, el auge de RISC-V en la academia, el uso de asistentes virtuales en educación, las iniciativas de GitHub Education, y las razones para usar Raspberry Pi en educación, entre otros, servirán como lecturas complementarias para enriquecer la comprensión y motivación de los estudiantes. Cada unidad del curso conectará con estos contextos para que el alumno no solo aprenda *qué* hacer, sino *por qué* es relevante en el panorama tecnológico actual.
