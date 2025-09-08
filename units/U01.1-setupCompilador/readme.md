
### 📌 Explicación de las principales utilerías y su rol en el flujo de desarrollo ARM64:

1. **Compiladores y ensambladores**

   * `gcc`, `clang`: Permiten compilar código en C/C++ y generar **instrucciones ARM64**.
   * `binutils`: Incluye `as` (ensamblador) y `ld` (linker), piezas clave para convertir el código en binarios ejecutables.
     👉 *Motivación*: Aquí es donde tus instrucciones Assembly realmente se transforman en programas que corren en el procesador.

2. **Depuración y análisis**

   * `gdb` + **GEF** y `lldb`: Te dejan **detener la ejecución**, inspeccionar registros, memoria y stack frame.
   * `valgrind`: Detecta fugas de memoria.
   * `strace`: Te enseña qué **llamadas al sistema** hace tu programa.
     👉 *Motivación*: Estos son los “rayos X” y “microscopios” para mirar dentro de tu programa, vital para entender cómo se comporta tu Assembly en tiempo real.

3. **Construcción y organización de proyectos**

   * `make`, `cmake`: Sistemas de construcción que automatizan compilación de proyectos grandes.
     👉 *Motivación*: No pierdes tiempo re-compilando todo manualmente, el sistema lo hace por ti.

4. **Gestión de código y descargas**

   * `git`: Control de versiones, para colaborar y guardar tu progreso.
   * `curl`, `wget`: Descarga de recursos y librerías desde Internet.
     👉 *Motivación*: Aquí entras al mundo profesional: proyectos compartidos, open source y colaboración en equipo.

5. **Editores y entornos de trabajo**

   * `vim`, `nano`: Editores ligeros en consola.
   * `tmux`, `screen`: Permiten trabajar en múltiples sesiones a la vez.
     👉 *Motivación*: Aquí aprendes a ser eficiente como ingeniero, manejando multitarea en servidores remotos o en Raspberry Pi.

6. **Análisis del sistema**

   * `htop`: Monitoriza CPU y memoria en tiempo real.
   * `tree`: Muestra estructuras de carpetas.
   * `file`: Te dice qué tipo de ejecutable o archivo tienes.
     👉 *Motivación*: Te vuelves un “médico” del sistema: revisas signos vitales y estructura de tu código.

7. **Calidad y estética**

   * `clang-format`: Asegura código limpio y estandarizado.
   * `figlet`: Puro estilo, para mensajes ASCII gigantes en consola.
     👉 *Motivación*: Incluso en la terminal, la presentación importa 😎.

8. **Shell y productividad**

   * `zsh` + **Oh My Zsh**: Shell moderno con autocompletado y personalización.
     👉 *Motivación*: Hace tu experiencia más fluida y divertida al trabajar largas horas en consola.

---

### 🌍 Por qué es importante para un futuro ingeniero

Al final, trabajar en ARM64 no es solo **escribir Assembly**, sino **dominar un ecosistema completo** de herramientas que:

* Traducen tus ideas al lenguaje de la máquina.
* Te permiten ver y corregir errores de bajo nivel.
* Te enseñan cómo funciona un sistema operativo por dentro.
* Te entrenan para trabajar en ambientes reales (servidores, nubes, dispositivos embebidos, IoT).

👉 Así, un estudiante no solo aprende “a programar en ensamblador”, sino a **pensar como ingeniero de sistemas**, con visión de hardware, software y herramientas profesionales.

```bash
#!/bin/bash

###############################################################
# Script: Configuración rápida entorno desarrollo ARM64
# Propósito: Instala herramientas esenciales de desarrollo,
#            GEF y Oh My Zsh en sistemas ARM64 (Raspberry Pi).
# Autor: CHATGTP
# Fecha: 25 DE MARZO DEL 2025
###############################################################

# Anuncia visualmente inicio de la actualización usando figlet
#
#  Video acompañamiento: https://www.loom.com/share/e2e3345c83b34eb199c73a14cbef1623?sid=4322e54c-85e9-48a7-9f60-7ad4d414322b
#  Y como configurar el VSCode https://www.loom.com/share/08169eca9baf4a97bc0c8ed983bd10b9?sid=d2d3bb39-362d-47d7-a136-992da2921cb6
#    Solo que clientes macOS y Linux deben de poner permisos a la llave con $ chmod 400 llavesita.pem
# Corrida:
#    $ wget https://raw.githubusercontent.com/tectijuana/interfaz/refs/heads/main/Class-Sessions/u2/setup64.sh
#    $ chmod +x setup64.sh
#    $ ./setup64.sh


# =======================================================================
# 🚀 Instalación Herramientas ARM64 (AWS EC2 Debian)
# -----------------------------------------------------------------------
# Este script instala paquetes esenciales para desarrollo en ensamblador
# ARM64 y programación general.
# =======================================================================

# 🔄 Actualizamos primero el índice de paquetes disponibles
sudo apt-get update && sudo apt upgrade -y

# 📦 Instalamos las herramientas esenciales para desarrollo
sudo apt-get install -y \
  build-essential \
  gcc \
  g++ \
  binutils \
  gdb \
  lldb \
  cmake \
  git \
  curl \
  wget \
  clang \
  clang-format \
  valgrind \
  strace \
  vim \
  nano \
  tmux \
  screen \
  htop \
  tree \
  file \
  unzip \
  zip \
  asciinema \
  python3 \
  python3-pip \
  python3-dev \
  software-properties-common \
  jq \
  figlet \
  mc

# -----------------------------------------------------------------------
# 📌 Explicación de los paquetes instalados:
# -----------------------------------------------------------------------
# build-essential: Herramientas básicas (gcc, make, etc.).
# gcc y g++: Compiladores GNU para C y C++ (ARM64).
# binutils: Utilidades GNU (ensamblador 'as', linker 'ld').
# gdb y lldb: Depuradores (debuggers).
# cmake: Herramienta de compilación multiplataforma.
# git: Control de versiones para proyectos.
# curl y wget: Herramientas para descargas desde consola.
# clang y clang-format: Compilador LLVM y formateador de código.
# valgrind: Análisis avanzado de memoria.
# strace: Monitor de llamadas al sistema.
# vim y nano: Editores de texto.
# tmux y screen: Multiplexores de terminal.
# htop: Monitor del rendimiento del sistema.
# tree: Visualiza estructura de directorios.
# file: Identificación de tipos de archivo.
# unzip y zip: Herramientas para compresión.
# asciinema: Grabación de sesiones de terminal.
# python3, python3-pip, python3-dev: Entorno de desarrollo Python.
# software-properties-common: Manejo de repositorios adicionales.
# zsh: Shell avanzado alternativo a bash.
# jq: Procesamiento de JSON desde consola.
# figlet: Solo banners y avisos para el asciinema
# mc: midnight commandes es un file manager en consoka

echo "🎉 Instalando depurador extension GEF"

# Anuncia visualmente la instalación de GEF
figlet "Instalando GEF"

# Instalación automatizada de GEF (GDB Enhanced Features) desde repositorio oficial
bash -c "$(curl -fsSL https://gef.blah.cat/sh)"

# Anuncia visualmente la verificación de GEF
figlet "Verificando GEF"

# Verifica que GEF se instaló correctamente y muestra ayuda inicial
gdb -ex "gef help" -ex quit

echo "🎉 ¡Herramientas instaladas exitosamente!"

# Anuncia visualmente la instalación de Oh My Zsh
figlet "Instalando Oh My Zsh"

# Instalación automatizada de Oh My Zsh (framework para Zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
###############################################################
# Fin del script
###############################################################


```
