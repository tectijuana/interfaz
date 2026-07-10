# 🐳 Entorno ARM64 con Docker en laptops x86 — con el asistente de IA de Docker

**Unidad:** U1 — setup alternativo (hermana de Termux y iPhone+VPN)
**Para quién:** estudiantes con laptop Intel/AMD que no usarán AWS todavía.
**Doble objetivo:** montar el toolchain ARM64 del curso en un contenedor, y aprender
a trabajar con **Ask Gordon** (`docker ai`), el agente de IA integrado en Docker
Desktop — aplicando el pensamiento crítico de `AI_GUIDANCE.md`.

## 1. El mapa de subcomandos de Docker

Docker organiza su CLI en grupos: `docker <comando> <subcomando> [opciones]`.

| Grupo | Qué administra |
|---|---|
| `docker container` | Contenedores (run, stop, logs, exec…) |
| `docker image` | Imágenes (build, pull, push, tag…) |
| `docker compose` | Aplicaciones multi-contenedor |
| `docker volume` / `docker network` | Datos persistentes / redes |
| `docker buildx` / `docker builder` | Builds extendidos y **multi-plataforma** (¡clave para ARM64!) |
| `docker system` | Limpieza de disco, info global |
| `docker inspect` | Detalle de cualquier objeto |
| `docker init` | Genera archivos Docker de arranque para un proyecto |
| `docker context` | Contra qué daemon trabajas (local, remoto, nube) |
| `docker debug` | Shell de diagnóstico dentro de cualquier imagen/contenedor |
| `docker scout` | Análisis de vulnerabilidades de imágenes |
| `docker manifest` | Listas de manifiesto multi-arquitectura |
| `docker desktop` / `docker extension` / `docker plugin` | El escritorio y sus extensiones |
| `docker mcp` | Servidores MCP (herramientas para agentes de IA) |
| `docker model` / `docker offload` | Correr modelos LLM locales / delegar a la nube |
| **`docker ai`** | **Ask Gordon: el agente de IA del CLI** |

Explóralo tú mismo: `docker --help` y `docker <grupo> --help`.

## 2. Dos formas de tener ARM64 en tu laptop x86

1. **Toolchain cruzado + QEMU usuario** (el `Dockerfile` de esta carpeta):
   compilas con `aarch64-linux-gnu-as/gcc` y ejecutas con `qemu-aarch64`.
   Es lo que usa el CI del curso.
2. **Plataforma emulada completa**: `docker run --platform linux/arm64 debian` —
   el contenedor entero *es* ARM64 (Docker Desktop trae binfmt/QEMU integrado).
   Necesaria para P06 (Python ARM64 nativo).

## 3. Práctica guiada con Ask Gordon

> Regla del juego (de `AI_GUIDANCE.md`): cada respuesta del agente se **verifica
> ejecutándola**, y en tu ANEXO registras dónde acertó y dónde alucinó.

1. **Sondeo**: pregunta al agente
   `docker ai "¿Qué hace docker init y qué archivos genera?"`
   Verifica con `docker init --help`. ¿Coincidió?
2. **Construcción**: con el `Dockerfile` de esta carpeta:
   ```bash
   docker build -t interfaz-arm64 .
   docker run --rm -it -v $PWD:/work -w /work interfaz-arm64
   ```
   Dentro del contenedor, clona el repo del curso y corre `make test` en
   `practicas/P01-hola-arm64`. **Esa es tu evidencia principal.**
3. **Interrogatorio técnico**: pídele al agente que te explique tu propia imagen:
   `docker ai "¿Por qué mi imagen interfaz-arm64 puede ejecutar binarios ARM64 si mi CPU es x86?"`
   Contrasta su respuesta con `file prog` (dentro del contenedor) y con lo que
   sabes de QEMU. Anota aciertos y errores.
4. **Misión con verificación**: pide al agente una tarea completa, por ejemplo:
   `docker ai "Dame el comando para correr un contenedor debian ARM64 nativo, montando mi carpeta actual, y comprobar la arquitectura"`
   Ejecuta lo que te dé. Si falla, corrígelo tú y documenta la diferencia.
5. **Limpieza consciente**: pregunta
   `docker ai "¿Cuánto disco está usando Docker y cómo lo limpio sin borrar mi imagen interfaz-arm64?"`
   y ejecuta la limpieza **solo después** de entender cada comando (`docker system df` primero).

## 4. Entregables
- Asciinema: build de la imagen + `make test` de P01 dentro del contenedor.
- Tabla de las 4 consultas al agente: pregunta → respuesta resumida → ¿verificada? → ¿acertó?
- `ANEXO.md` con la reflexión: ¿en qué se parece Ask Gordon a usar Claude Code o
  ChatGPT? ¿Qué ventaja tiene que el agente *vea* tu entorno Docker real?

## Preguntas de defensa
- ¿Qué diferencia hay entre el enfoque 1 (toolchain cruzado) y el 2 (`--platform linux/arm64`)? ¿Cuándo necesitas cada uno?
- ¿`docker ai` ejecuta comandos por ti o solo sugiere? ¿Qué implicaciones tiene?
- ¿Qué es binfmt_misc y qué papel juega cuando corres un binario ARM64 en x86?
- ¿Por qué el volumen `-v $PWD:/work` hace que tu código sobreviva al contenedor?
