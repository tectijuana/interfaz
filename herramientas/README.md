# Herramientas del docente

Utilerías de apoyo para la operación del curso. **No son CI**: se corren manualmente
en la máquina del docente; la verificación de cada práctica sigue siendo
responsabilidad del alumno en su propio entorno.

## `recolecta-gists.sh` — asistente de calificación

Toma la lista de Gists reportados por los alumnos (en iDoceo Connect o Google
Classroom), los clona todos, corre `make test` en cada uno y resume el estado del
grupo para calificar con la rúbrica de `GRADING.md`.

### Uso

1. Exporta o arma un CSV con una línea por alumno (sin encabezado):

   ```csv
   22211539,Ana López,https://gist.github.com/ana-lopez/3f2a9c...
   22211540,Luis Pérez,https://gist.github.com/luisperez99/8b1d...
   22211541,Mario Ruiz,
   ```

   La URL vacía significa "no reportó". Las líneas que inician con `#` se ignoran.

2. Corre el recolector (después de la fecha límite):

   ```bash
   ./herramientas/recolecta-gists.sh lista.csv
   ```

3. Obtienes:
   - una tabla en pantalla: `make test` (✅/❌/⚠️ SKIP), si hay `ANEXO.md`, si hay
     evidencia asciinema, y avisos como "encabezado sin llenar";
   - `revision-<fecha>/<control>/` con el clon de cada Gist (útil para revisar código
     a detalle o comparar entregas entre sí);
   - `revision-<fecha>/_logs/<control>.log` con la salida completa de cada corrida;
   - `revision-<fecha>/resumen.csv` para importar a iDoceo.

Si un alumno corrige su Gist, vuelve a correr el script sobre la misma carpeta:
hace `git pull` de cada clon y actualiza el resumen (el historial de revisiones del
Gist queda como constancia de los cambios).

### Requisitos

`git` y `make`; para correr las prácticas en una máquina x86:
`binutils-aarch64-linux-gnu qemu-user` (ver `units/U01.2-Compilador-Docker-x86/`).
En ARM64 (Graviton, Raspberry Pi, Mac con contenedor ARM64) no se necesita nada extra.
