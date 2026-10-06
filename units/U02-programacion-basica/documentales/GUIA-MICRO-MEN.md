<img width="753" height="428" alt="image" src="https://github.com/user-attachments/assets/d850a158-db95-432b-bfb4-96ae244f1257" />


# Guía para ver la película — *Micro Men* (2009)

- **Curso:** Lenguajes de Interfaz (SCC-1014) · **Unidad 2:** Programación básica en ARM
- **Video:** https://www.youtube.com/watch?v=XH5L-iTIbP8 · **Audio/subtítulos:** inglés
- **Formato:** drama-documental de la BBC sobre la rivalidad entre Sinclair Research y Acorn Computers en la Gran Bretaña de inicios de los 80.

## Por qué verlo en este curso

El procesador que programamos en este curso nació en la empresa que aparece en la película. Acorn necesitaba un chip para su siguiente computadora, no encontró uno que le convenciera y terminó diseñando el suyo: el **ARM** (*Acorn RISC Machine*). Esta guía te ayuda a conectar lo que ves con lo que ya escribes en ensamblador.

> La película es una dramatización: diálogos, orden de eventos y personalidades están novelados. Úsala como contexto histórico, no como fuente técnica. Para los datos duros, verifica en las lecturas del curso.

## Antes de verla (10 min)

- Repasa qué significa **RISC** vs **CISC** (lectura de arquitectura de la U1/U2).
- Recuerda qué es un **registro**, un **ciclo de instrucción** y por qué un conjunto de instrucciones pequeño y regular simplifica el hardware.
- Ten a la mano tu `P01-hola-arm64`: lo vas a comparar con lo que se discute.

## Vocabulario clave (inglés → español)

| Término | Significado en contexto |
|---|---|
| *kit* | Computadora en piezas para armar; el origen del mercado hobbista |
| *6502* | Procesador de 8 bits usado en las máquinas de Acorn (y en Apple II, Commodore PET) |
| *Z80* | Procesador de 8 bits usado en las máquinas de Sinclair |
| *assembler* | Ensamblador; en las computadoras de la época venía incluido o se cargaba aparte |
| *BASIC* | Lenguaje de alto nivel residente en ROM, la "interfaz" de usuario de entonces |
| *ROM / RAM* | Memoria de solo lectura (sistema, BASIC) / memoria de trabajo |
| *clone / compatible* | Máquina que imita a otra para correr su software |

## Qué observar, por segmentos

Los tiempos son aproximados; ajusta según tu reproducción.

### 1. Los inicios: kits y filosofía de producto
- ¿Qué problema resuelve un *kit* para quien lo arma? ¿Qué aprende que un usuario de producto terminado no?
- Compara la actitud "elegancia ante todo" con la de "que funcione y se pueda ampliar". ¿Cuál se parece más a cómo escribes código en ensamblador?

### 2. Los 8 bits: 6502 y Z80
- Fíjate cómo las decisiones de **costo** (menos chips, menos memoria) determinan el diseño del software.
- Anota cuánta memoria tenían las máquinas que se mencionan. Calcula cuántos de tus `.s` de práctica cabrían.

### 3. El contrato con la BBC y la presión de tiempo
- Identifica qué se sacrificó para cumplir una fecha (herramientas, pruebas, diseño).
- Relaciónalo con tu propia experiencia: ¿qué pasa con tu práctica cuando no corres `make test` hasta la víspera?

### 4. La guerra de ventas y las ideas "baratas pero con truco"
- Observa los compromisos de hardware para abaratar (teclado, memoria, pantalla). Cada recorte exige más trabajo del programador.
- Piensa: ¿qué recorte equivalente existe en un microcontrolador como el RP2350 del Pico 2W?

### 5. El salto: diseñar su propio procesador
- Atiende a **por qué** deciden diseñar un chip y **cómo** lo hacen con un equipo muy pequeño.
- Este es el segmento central para el curso. Anota las razones técnicas que se mencionan (acceso a memoria, manejo de interrupciones, simplicidad del diseño).

## Conexión con ARM64 (lo que ya sabes)

| Idea en la historia | Dónde la ves en tu código |
|---|---|
| Conjunto de instrucciones pequeño y regular | Instrucciones de 32 bits de largo fijo en AArch64 |
| Trabajar sobre registros, memoria solo con carga/almacenamiento | `ldr` / `str` son las únicas que tocan memoria; `add`, `mov`, etc. operan sobre registros |
| Procesador sencillo, bajo consumo | Por eso ARM domina móviles, Raspberry Pi y Graviton |
| Del ARM de 32 bits al de 64 bits | AArch32 (ARM32) → AArch64 (`x0`–`x30`, `sp`, `xzr`) |

> **Aclaración:** el curso trabaja AArch64. El primer ARM era de 32 bits y con otro modelo de registros; no confundas ambos al comparar.

## Preguntas mientras ves la película (anota respuestas breves)

1. ¿Qué dos filosofías de empresa chocan, y cuál terminó influyendo más en la computación actual?
2. ¿Por qué el éxito comercial de una máquina no siempre implica la mejor ingeniería?
3. ¿Qué papel juega el lenguaje ensamblador en las máquinas de esa época?
4. ¿Qué limitación de hardware te sorprendió más?
5. ¿Qué decisión de diseño de ARM (según la película) sigue vigente en lo que programas hoy?

## Preguntas de defensa (responder en el `ANEXO` o en clase)

1. Explica con tus palabras por qué un diseño RISC facilita construir un procesador con pocos recursos.
2. Da un ejemplo de tu propio código ARM64 donde se note la separación "operar en registros / acceder a memoria".
3. ¿Qué ventaja y qué desventaja tiene que una instrucción mida siempre 4 bytes?
4. Si tuvieras que explicar el origen de ARM a un compañero en 60 segundos, ¿qué dirías?
5. Menciona un dato de la película que **no** creerías sin verificar, y cómo lo comprobarías.

## Actividad sugerida (individual, entrega por Gist)

Escribe una reflexión de **300–400 palabras** con:
- Un hecho histórico de la película que verificaste en una fuente externa (cítala).
- Una conexión concreta entre la película y una práctica del curso.
- Tu declaración de uso de IA, siguiendo `AI_GUIDANCE.md`, de haber intervenido (excepto gramática) honestidad se agradece.

## Rúbrica (100 puntos)

| Criterio | Excelente | Bueno | Suficiente | Insuficiente |
|---|---|---|---|---|
| **Preguntas mientras ves la película** (20) | **20** · Responde las 5 con precisión y detalle propio del video | **16** · Responde las 5; alguna es general o imprecisa | **12** · Responde 3–4, o respuestas superficiales | **0–8** · Responde 2 o menos, o no se basan en el video |
| **Hecho verificado en fuente externa** (25) | **25** · Contrasta un hecho con fuente confiable citada y señala qué es dramatización | **20** · Hecho verificado con fuente citada, sin distinguir la dramatización | **15** · Hecho verificado pero fuente débil o sin cita completa | **0–10** · Sin verificación, o fuente inexistente o no confiable |
| **Conexión con una práctica del curso** (25) | **25** · Relaciona la película con código o concepto concreto (p. ej. `ldr`/`str`, RISC, 4 bytes por instrucción) y lo explica | **20** · Conexión concreta pero explicación parcial | **15** · Conexión genérica, sin ejemplo de código ni práctica | **0–10** · No hay conexión, o es incorrecta |
| **Redacción y formato de entrega** (15) | **15** · 300–400 palabras, claro, sin errores relevantes, Gist plano accesible | **12** · Cumple extensión y entrega con errores menores | **9** · Fuera de rango de palabras o con problemas de claridad o de acceso al Gist | **0–6** · No se puede leer o no se entregó por Gist |
| **Declaración de uso de IA** (15) | **15** · Completa según `AI_GUIDANCE.md`: herramienta, uso y qué verificó | **12** · Presente, con detalles faltantes | **9** · Mención vaga | **0** · Ausente |

**Nota:** la reflexión debe ser personal; el contenido copiado o generado sin verificación se califica en *Insuficiente* en el criterio correspondiente.

## Actividad opcional: simulación "Eres técnico en Acorn"

Después de ver la película, puedes vivir el drama desde adentro: una simulación de rol con IA en la que eres técnico junior en Acorn y resuelves 5 misiones (placa Atom que no arranca, bug en la matriz del teclado en 6502, recorte de BOM, demo ante la BBC y el diseño del ARM1).

- **Prompt y guion:** [`EresTecnicoSimuladoACORN.md`](EresTecnicoSimuladoACORN.md) (instrucciones de uso incluidas; se pega en un chat de ChatGPT).
- **Antes de empezar:** verás mejor las referencias si ya viste el video; el guion de la simulación se basa en los subtítulos en español.
- **Cierre:** al terminar, guarda el enlace del chat; puedes usarlo como evidencia en tu declaración de uso de IA (`AI_GUIDANCE.md`).
- Los datos de hardware de las misiones son didácticos; verifica los hechos históricos como en la actividad principal.

## Para ampliar

- Lecturas del curso en `units/U02-programacion-basica/lecturas/`.
- `docs/lecturas-avanzadas/` para temas de arquitectura más profundos.
- Busca en fuentes primarias (entrevistas y charlas de los diseñadores del ARM) y compara con la versión dramatizada.
