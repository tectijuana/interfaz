# Guía de Contribución

¡Gracias por tu interés en mejorar este curso!  
Este documento describe cómo proponer cambios y mantener un repositorio organizado.

> **¿Vienes a entregar una práctica del curso?** Ve directo a
> [Entrega de prácticas (estudiantes)](#entrega-de-prácticas-estudiantes) —
> las entregas **no** se hacen en este repositorio.

## Entrega de prácticas (estudiantes)

Las prácticas se entregan por **Pull Request al repositorio de entregas del semestre**
(uno por ciclo, p. ej. `tectijuana/interfaz-entregas-2026b` — el enlace exacto se publica
en la primera semana de clase). Este repositorio (`interfaz`) es solo material del curso;
un PR con una entrega aquí será cerrado con la indicación de moverlo.

Flujo de entrega:

1. **Fork** del repositorio de entregas del semestre.
2. Crea tu carpeta siguiendo la convención:
   `<numero-de-control>/P##-nombre/` (p. ej. `22211539/P01-hola-arm64/`).
3. Copia dentro la estructura completa de la práctica (desde `practicas/P##-*/` de este
   repo): `src/`, `Makefile`, `tests/`, `README.md` con tus respuestas de defensa y el
   enlace asciinema, y `ANEXO.md` con tu declaración de IA.
4. Verifica localmente que `make test` pasa (nativo ARM64 o QEMU).
5. Abre el PR con título `P## — <Nombre Apellido> <numero-de-control>`; una rama por
   práctica (`p01-entrega`, `p02-entrega`, …).
6. El CI del repo de entregas corre `make test` sobre tu carpeta. La revisión docente
   aplica la rúbrica de [`GRADING.md`](./GRADING.md); atiende los comentarios en el mismo
   PR. Una vez calificado, el PR se mergea y queda como constancia de tu entrega.

Lo que sigue en este documento aplica a **mejoras al material del curso**
(correcciones, nuevas lecciones, erratas), no a entregas.

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
