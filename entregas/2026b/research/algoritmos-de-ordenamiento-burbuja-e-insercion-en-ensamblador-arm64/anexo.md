[anexo (1).md](https://github.com/user-attachments/files/32449625/anexo.1.md)
## 1. Declaración de uso

Sí utilicé un asistente de IA durante esta investigación. Lo empleé para:

- obtener material técnico de apoyo sobre AArch64 y la convención AAPCS64;
- generar un primer borrador del código ensamblador de ambos algoritmos, que después compilé, ejecuté y verifiqué;
- obtener una primera estructura del README (introducción, desarrollo, análisis crítico, conclusiones) que reescribí con mis propias palabras;
- obtener un borrador de bibliografía en formato IEEE, que verifiqué fuente por fuente.

No copié la redacción de la introducción, el análisis crítico ni las conclusiones tal cual me las entregó el modelo; las reescribí basándome en lo que entendí del material técnico.

---

## 2. Registro de prompts

### Prompt 1 — Solicitud de material técnico de apoyo

**Fecha:** 20 de septiembre de 2026

**Prompt real enviado:**

> Actúa como asesor técnico en arquitectura ARM64 (AArch64) y programación en ensamblador. Estoy cursando Lenguajes de Interfaz (SCC-1014) en el TecNM Campus Tijuana y mi tema de investigación es: "Algoritmos de ordenamiento (burbuja e inserción) en ensamblador ARM64". Necesito material técnico de apoyo, NO un texto final para copiar: yo voy a redactar el README.md con mis propias palabras.
>
> Pedí, en orden: (1) explicación conceptual de ambos algoritmos con invariantes, complejidad y estabilidad; (2) mapeo a AArch64 — registros, convención AAPCS64, direccionamiento de arreglos; (3) código ensamblador comentado de ambas funciones, llamables desde C, con banco de pruebas y comandos de compilación; (4) metodología de medición de rendimiento; (5) comparación contra el código generado por GCC con -O0, -O2 y -Os; (6) puntos de análisis crítico para argumentar mi propia postura; (7) referencias en formato IEEE, advirtiendo que no inventara datos bibliográficos.

**Resultado obtenido:**

El modelo entregó una explicación de ambos algoritmos con una tabla comparativa de complejidad y número de escrituras; una explicación de registros y AAPCS64 (por qué estas funciones no necesitan prólogo/epílogo al ser funciones hoja); el código de `bubble_sort` e `insertion_sort` en ensamblador AArch64 comentado línea por línea, usando instrucciones como `LDR`/`STR` con desplazamiento escalado, `CSEL` como alternativa sin saltos, y `TBNZ` para probar el bit de signo; un programa de prueba en C con medición de tiempo; una comparación honesta contra GCC `-O2` (reconociendo que el ensamblador manual rara vez le gana); puntos de análisis crítico sobre vectorización NEON y el uso de estos algoritmos en sistemas embebidos; y diez referencias en formato IEEE.

**Qué hice con él:**

Copié el código ensamblador y el programa en C a archivos `sorts.s` y `main.c`. Los compilé y ejecuté siguiendo los comandos indicados. Usé la explicación técnica como base para escribir el desarrollo del README con mis propias palabras, y reescribí por completo la introducción, el análisis crítico y las conclusiones. Dejé la tabla de mediciones vacía en el borrador y la llené después con mis propios resultados.

---

## 3. Verificación de lo generado

| Elemento | ¿Verificado? | Cómo |
|---|---|---|
| `bubble_sort` en ASM | Sí | Compilado con `gcc`/`as` y ejecutado; salida ordenada correctamente en los tres casos de prueba (aleatorio, ordenado, inverso) |
| `insertion_sort` en ASM | Sí | Compilado y ejecutado; validado que produce el mismo resultado que `bubble_sort` sobre las mismas entradas |
| Comportamiento de `TBNZ x4, #63` | Sí | Contrastado con el Arm Architecture Reference Manual [1] |
| Semántica de `CSEL` | Sí | Contrastada con el manual [1] y confirmada al ejecutar el fragmento por separado |
| Complejidades y conteos de escrituras | Sí | Contrastados con Cormen et al. [4] |
| Referencias bibliográficas | Sí | Verificadas una por una: título, edición, año y disponibilidad |

---

## 4. Errores, sesgos y limitaciones detectados

- **Confianza sin medir:** el modelo describe con seguridad el comportamiento esperado ("inserción debería ser más rápida en datos aleatorios"), pero esas cifras no valen nada hasta que yo las mido. Todos los números de la tabla de rendimiento del README son mediciones propias, no las del modelo.
- **Sesgo hacia sobrevalorar el ensamblador manual:** la primera inclinación del material era presentar el código a mano como una mejora de rendimiento. Tuve que pedir explícitamente una comparación honesta contra GCC `-O2`, y la respuesta final reconoce que, para este problema, el ensamblador manual casi nunca le gana al compilador optimizado. Sin ese señalamiento, el README habría exagerado el beneficio.
- **Límite de QEMU:** el material advierte correctamente que, al probar bajo emulación (si no se cuenta con hardware ARM64), los tiempos no reflejan caché ni predicción de saltos reales. Lo tomé en cuenta al interpretar mis propios resultados.
- **Referencias:** ninguna resultó inexistente, pero confirmé cada una por separado en vez de asumir que estaban bien: es un punto donde los LLM pueden inventar datos con facilidad.

---

## 5. Reflexión final

Usar el LLM sí me ayudó a avanzar más rápido, sobre todo para entender cómo funciona el direccionamiento de arreglos y la convención de llamadas en ARM64, cosas que no tenía tan claras. Pero no fue "pedir y copiar": tuve que compilar el código, correrlo, y en algunos casos corregir cosas para que funcionara como se esperaba.

Lo que más aprendí fue precisamente al verificar: comparar lo que el modelo decía contra el manual de Arm y contra lo que realmente pasaba al ejecutar el código me hizo entender mejor el tema que si solo hubiera leído la respuesta sin más. Si hubiera entregado la primera respuesta tal cual, sin revisar ni probar nada, seguro se me hubiera ido algún error de registros o de condición, y tampoco habría aprendido tanto.

Para el futuro la usaría igual: como punto de partida para investigar y como apoyo para entender conceptos, pero siempre verificando y escribiendo las conclusiones con mis propias palabras.
