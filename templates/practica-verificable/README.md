# Plantilla: Práctica Verificable (ARM64)

Estructura estándar de toda práctica del curso a partir de 2026: el código se **valida
automáticamente** comparando su salida con la esperada, en tu propio entorno
(PC, VM, AWS Academy — nativo ARM64 o QEMU). La validación es local a propósito:
el objetivo es que tú veas y depures tus propios fallos.

```
P##-nombre/
├── README.md          ← enunciado + instrucciones (usa templates/README-practica.md)
├── ANEXO.md           ← declaración de IA obligatoria (ver AI_GUIDANCE.md)
├── Makefile           ← build / run / test (detecta ARM64 nativo o usa QEMU)
├── src/main.s         ← tu programa, con encabezado y conclusiones
└── tests/
    ├── expected.txt   ← salida esperada
    └── run_tests.sh   ← autograder mínimo
```

## Cómo trabajar

```bash
# En AWS Graviton / Raspberry Pi (ARM64 nativo) no necesitas nada extra.
# En x86_64 (laptop):
sudo apt-get install -y binutils-aarch64-linux-gnu qemu-user

make test    # ensambla, ejecuta y compara la salida
```

`make test` en verde **no es la calificación completa**: la rúbrica (`GRADING.md`) también
evalúa ABI/registros, estilo, documentación y tu declaración de IA. La evidencia de ejecución
(asciinema) sigue siendo obligatoria.

## Para el docente
- Cambia `tests/expected.txt` (y si aplica, argumentos en el Makefile) por variante de alumno.
- La verificación es responsabilidad del alumno en su entorno (no hay CI de prácticas):
  la evidencia asciinema de `make test` es la constancia de la corrida.
