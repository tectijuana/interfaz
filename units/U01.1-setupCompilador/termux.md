# Prompt: entorno de desarrollo ARM64 en Termux

Copia y pega el bloque de abajo en tu asistente de IA (Claude Code, etc.) que tenga acceso a tu Termux por SSH.

## Antes de empezar (lo haces tú, en el teléfono)

```sh
pkg update -y && pkg install -y openssh
passwd                       # define tu contraseña
sshd                         # inicia SSH en el puerto 8022
whoami                       # tu usuario (ej. u0_a123)
ifconfig | grep inet         # tu IP en la red WiFi
```

El teléfono y la computadora deben estar en la misma red. Autoriza la llave pública de tu computadora:

```sh
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo 'PEGA_AQUI_TU_LLAVE_PUBLICA' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

(La llave se ve con `cat ~/.ssh/id_ed25519.pub` en tu computadora. Si no tienes una: `ssh-keygen -t ed25519`.)

## Prompt

```
Eres experto en Termux. Tienes acceso SSH a mi dispositivo Android:
  ssh -p 8022 USUARIO@IP
Necesito el entorno de desarrollo para ensamblador ARM64 (AArch64) de mi curso. Instálalo y verifícalo.

REGLAS
- Termux usa `pkg` (no apt con sudo, no sudo). No existe /tmp: usa $TMPDIR.
- Conéctate con BatchMode (sin contraseña interactiva, usa mi llave).
- Antes de ejecutar cualquier script descargado de internet, descárgalo, léelo y muéstramelo.
- No me hagas preguntas innecesarias; si algo no existe en Termux, dime cuál es el equivalente.

PASOS
1. Actualiza: pkg update -y && pkg upgrade -y
2. Instala: clang lld binutils make cmake gdb lldb git gh curl wget python
   vim nano tmux screen htop tree file zip unzip jq figlet mc strace asciinema zsh
   Notas: `gcc`, `g++` y `cc` son alias de clang en Termux; `ld` es LLD; `as` viene en binutils;
   clang-format viene con clang; valgrind NO existe en Termux (omítelo e infórmamelo).
3. GEF (extensión de gdb): clónalo o descárgalo desde https://github.com/hugsy/gef y
   escribe en ~/.gdbinit con RUTA ABSOLUTA (gdb no expande "~"):
     source /data/data/com.termux/files/home/gef/gef.py
   Si ~/.gef.rc tiene formato viejo y da error "no section headers", respáldalo (.bak) y deja que GEF lo regenere.
4. Oh My Zsh: descarga https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh,
   muéstramelo, y ejecútalo con `sh install.sh --unattended`. No cambies mi shell por defecto.
5. Verifica con un "Hola mundo" en ARM64 (archivo hola.s) con este formato:
   - encabezado (programa, descripción, autor, plataforma, comandos),
   - un comentario con el equivalente de alto nivel en Python,
   - el código en ensamblador ARM64 usando syscalls write (64) y exit (93).
   IMPORTANTE: Termux solo ejecuta binarios PIE. Usa `adrp x1, mensaje` +
   `add x1, x1, :lo12:mensaje` (NO `ldr x1, =mensaje`) y enlaza con:
     as hola.s -o hola.o && ld -pie hola.o -o hola && ./hola
6. Entrégame una tabla con la versión de cada herramienta instalada
   (as, ld, gcc, gdb, lldb, make, cmake, git, python, vim, nano, tmux, zsh, asciinema)
   y qué quedó sin instalar y por qué.

DEPURACIÓN CON GDB/GEF
- `break _start` + `run` falla en binarios PIE ("Cannot insert breakpoint"). Usa `starti`
  y pon el breakpoint en una dirección absoluta cuando el linker ya mapeó el binario.
```

## Notas para el docente

- Probado en Termux, Android aarch64 (kernel 4.14), Python 3.13, clang/LLD 21.1.8, gdb 16.3, GEF.
- El script original `compilador.sh` es para Debian/AWS con `sudo apt`; este prompt es su equivalente adaptado a Termux.
- Diferencias frente al script original: sin `build-essential`, `python3-dev` ni `software-properties-common`; sin `valgrind` (no existe en Termux).
