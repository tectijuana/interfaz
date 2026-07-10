# P04 — Operaciones básicas sobre archivos de disco

**Unidad:** U2 — Programación básica (subtema 2.16)
**Objetivo:** crear, escribir, cerrar, reabrir y leer un archivo usando solo syscalls
(`openat`, `write`, `close`, `read`), manejando descriptores de archivo y errores.

## Cómo funciona
El programa hace el ciclo completo de vida de un archivo:

```
openat(O_CREAT|O_WRONLY|O_TRUNC) → write → close → openat(O_RDONLY) → read → close → write(stdout)
```

Lo que ves en pantalla **viene del disco**, no del `.data`: se escribió a `datos.txt`
y se leyó de vuelta. Si cualquier `openat` falla (fd negativo, detectado con
`tbnz x0, #63`), imprime `Error de archivo` y sale con código 1.

```bash
make test     # valida el viaje completo de ida y vuelta
cat datos.txt # el archivo queda en disco para inspección
make clean    # borra binario y datos.txt
```

## Enunciado
1. Ejecuta `make test` y verifica con `strace ./prog` la secuencia de syscalls.
2. **Tu variante**: cambia el mensaje para incluir tu nombre y número de control,
   y el nombre del archivo a `registro-<control>.txt` (ajusta expected y clean).
3. Modo bitácora: quita `O_TRUNC` y agrega `O_APPEND` (0x400). Corre el programa 3 veces
   y explica el contenido resultante del archivo en tus conclusiones.
4. Provoca un error real (p. ej. ruta `/root/x.txt` sin permisos) y demuestra con
   asciinema que tu manejo de error funciona.

## Preguntas de defensa
- ¿Qué es un descriptor de archivo? ¿Por qué el fd se guarda en `x19` y no se deja en `x0`?
- ¿Por qué en AArch64 no existe la syscall `open` clásica y se usa `openat`? ¿Qué es `AT_FDCWD`?
- ¿Qué garantiza `O_TRUNC` en `make test`? ¿Qué saldría mal sin él?
- ¿Cómo sabe el programa cuántos bytes imprimir en el paso final?
