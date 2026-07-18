# Guía de Contribución

¡Gracias por tu interés en mejorar este curso!  
Este documento describe cómo proponer cambios y mantener un repositorio organizado.

> **¿Vienes a entregar una práctica del curso?** Ve directo a
> [Entrega de prácticas (estudiantes)](#entrega-de-prácticas-estudiantes) —
> las prácticas se entregan por **Gist + iDoceo Connect/Google Classroom**, no por PR
> (solo la investigación de la Unidad 1 va por PR a este repositorio).

## Entrega de prácticas (estudiantes)

Las prácticas **no se entregan en este repositorio**: cada alumno publica su trabajo en
su propia cuenta de GitHub como **Gist** y reporta la URL donde indique el docente
(**iDoceo Connect** — connect.idoceo.net — o **Google Classroom**). Tú eres el
responsable de tu contenido y de conservar tu evidencia.

Este repositorio es el **material del curso**: en Google Classroom el docente publica
los temas del día con enlaces a las unidades y prácticas de aquí, junto con otros
complementos; en la misma asignación de Classroom (o en iDoceo Connect) reportas la
URL de tu Gist.

Flujo de entrega de cada práctica:

1. Trabaja la práctica en tu entorno (PC, VM o AWS Academy) hasta que `make test` pase
   en verde — no hay CI que lo corra por ti; los errores y su depuración son parte de
   lo que se evalúa y de lo que aprendes.
2. Publica un **Gist** con la práctica completa: `src/main.s` (encabezado y
   conclusiones), `Makefile`, `tests/expected.txt`, `README.md` con tus respuestas de
   defensa, y `ANEXO.md` con tu declaración de IA.
3. Incluye la **evidencia**: enlace asciinema de la corrida de `make test` (o video/
   captura en prácticas de hardware, según el `rubrica.md` de la práctica).
4. Reporta la **URL del Gist** en iDoceo Connect o Google Classroom antes de la fecha
   límite. La revisión docente aplica la rúbrica de [`GRADING.md`](./GRADING.md).

**Excepción — Unidad 1**: la investigación de la U1 sí se entrega por **Pull Request a
este repositorio** (fork → rama → PR, como se describe abajo), porque el objetivo de esa
unidad es precisamente aprender a contribuir a un repositorio colaborativo. Esos PRs se
revisan con `REVIEW_RUBRIC.md` y al aprobarse se integran en `entregas/<ciclo>/research/`.

Lo que sigue en este documento aplica a los PRs: la investigación de U1 y las
**mejoras al material del curso** (correcciones, nuevas lecciones, erratas).

## Cómo contribuir
1. **Fork** del repositorio.
2. Crear una rama con un nombre descriptivo:  
   `git checkout -b mejora/U02-practica-ciclos-arm64`
3. Realizar los cambios siguiendo las normas de estilo.
4. Incluir documentación y ejemplos cuando sea necesario.
5. Abrir un **Pull Request** (PR) describiendo claramente el cambio.

## Estilo y organización
- **Unidades** → `units/U##-nombre/`  
- **Lecciones** → `L##-nombre/`  
- **Prácticas** → `P##-nombre/`  
- **Evaluaciones** → `E##-nombre/`  
- Nombres en **kebab-case** (minúsculas, con guiones).
- Markdown limpio, títulos con `#`, listas claras y ejemplos con bloque de código.

## Buenas prácticas
- Revisar ortografía y claridad del texto.
- Código ensamblador con encabezado del programador y conclusiones al final (ver `docs/estilo_codigo.md`).
- Verificar que los ejemplos ensamblan y corren (`make test` cuando la práctica lo incluya).
- Validar enlaces y formato antes de abrir el PR.

## Revisión de PRs
- Los PRs serán revisados por docentes y asistentes de curso.
- Se pueden solicitar cambios antes de aceptar.
- Una vez aprobado, se integrará a la rama principal.

---

Gracias por contribuir al crecimiento de este curso y ayudar a mantenerlo con estándares internacionales.
