```plaintext
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⡿⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⢀⣠⣤⣤⣤⣀⣀⠈⠋⠉⣁⣠⣤⣤⣤⣀⡀⠀⠀
          ⠀⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀
          ⣠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
          ⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣀
          ⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁
          ⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀
          ⠀⠀⠀⠈⠙⢿⣿⣿⣿⠿⠟⠛⠻⠿⣿⣿⣿⡿⠋⠀⠀⠀


# ╔════════════════════════════════════════════════════════════════════╗
# ║  TERMINAL ELEGANCE – CODIFICANDO DESDE UN DISPOSITIVO APPLE      ║
# ╚════════════════════════════════════════════════════════════════════╝
# 📘 Asignatura: Lenguajes de Interfaz en TECNM Campus ITT
# 👤 Autor(a): Axel Tron-X
# 📅 Fecha: 2025/09/15
# 🍏 Dispositivo: iPad Pro M2 / macOS Terminal – Apple Ecosystem Ready
# 🧾 Descripción: Script funcional desarrollado para correr en 
#    terminales compatibles con Apple Silicon y entorno UNIX.
# 🌐 Simulación Wokwi: https://wokwi.com/projects/apple-shell-runner
#
# ╭────────────────────────────────────────────────────────────╮
# │  INITIATING APPLE SHELL... ✔️                            │
# │ Terminal limpia. Código limpio. Ecosistema perfecto.      │
# │ Estás dentro del flujo: think different, code different.  │
# ╰────────────────────────────────────────────────────────────╯
#
# 🍎 LEMA: “Elegancia en el código. Precisión en la ejecución.”
# 🎬 SAGA: “iCODE: LA INTERFAZ DE LOS GEEKS”

```
# 📘 Práctica: Acceso Remoto a EC2 ARM64 con Tailscale para compilar en Iphone por las restricciones del fabricante.


## 🎯 Objetivo
- Levantar una instancia **EC2 ARM64 Ubuntu** en **AWS Academy**.  
- Instalar **Tailscale** usando el correo personal de **Gmail** (no institucional).  
- Conectarse desde un **celular** (para este caso iPhone) a la VM mediante **red privada Tailscale**.  
- Probar compilación de un programa **ARM64 assembly**.
- Grabar en LOOM.com (el demo solo da 5 minutos) del logro final mostrando fecha y hora, y modificacion del enecabezado del programa

---

## 🔹 Parte 1 – Crear instancia EC2 Ubuntu ARM64 en AWS Academy (si ya esta lista una usarla)
1. Entra a [AWS Academy Learner Lab](https://awsacademy.instructure.com/).  
2. Abre la **AWS Management Console**.  
3. Ve a **EC2 → Launch Instance**.  
4. Configura:
   - **Name**: `arm64-lab`
   - **AMI**: `Ubuntu Server 24.04 LTS (ARM64)`  
   - **Instance type**: `t4g.micro` (gratis elegible).
   - **Key pair**: crea una nueva o usa existente (descarga `.pem` si es nueva).  
   - **Security Group**: habilita **SSH (22)**.  
5. Lanza la instancia y espera a que arranque.
6. Copia la **IP pública** (la usaremos solo para la primera conexión).  

---

## 🔹 Parte 2 – Conectarse por Web Console de AWS
1. En la consola de EC2 → selecciona tu instancia.  
2. Click en **Connect → EC2 Instance Connect (Web console)**.  
3. Ya estás en tu Ubuntu ARM64 vía navegador.

---

## 🔹 Parte 3 – Instalar Tailscale en Ubuntu
En la terminal del EC2:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up

```
- Se abrirá un link de autorización → cópialo y ábrelo en tu navegador.
- Inicia sesión con tu Gmail personal (no uses el institucional).
- Ahora tu EC2 estará en tu red privada Tailscale.

Verfica:
```bash
tailscale ip -4
# Activando el servicio de SSH remoto por Tailscale y no por AWS
sudo tailscale up --ssh --accept-routes
```
Te dará algo tipo 100.x.y.z → esa será la IP privada, te pedirá autorización.

🔹 Parte 4 – Instalar Tailscale en tu Celular
- Descarga Tailscale en Android/iOS desde la tienda.
- Inicia sesión con tu Gmail.
- Ahora verás tu nodo arm64-lab en la app.

Activa la conexión.
- Ya puedes conectarte desde cualquier lugar usando la IP 100.x.y.z.

🔹 Parte 5 – Probar SSH desde el Celular
En iPhone ( iSH / Termius):

```bash
ssh ubuntu@100.x.y.z
```
🔹 Parte 6 – Preparar el entorno ARM64 Assembly
En tu EC2 instala lo básico con la practica de COMPILADOR EN AWS:
   https://github.com/tectijuana/interfaz/tree/main/units/U01.1-setupCompilador

🔹 Parte 7 – Probar un programa en ensamblador
Utiliza editor desde como _$ nano_ u otro que le agrade:
  
Ejemplo hola.s:

```asm
// hola.s - ARM64 Assembly
// Versión C (comentada):
// #include <stdio.h>
// int main() { printf("Hola mundo\n"); return 0; }

.global _start

.section .data
msg:    .asciz "Hola mundo\n"

.section .text
_start:
    // write(1, msg, len)
    mov x8, 64          // syscall: write
    mov x0, 1           // fd = stdout
    ldr x1, =msg        // buffer
    mov x2, 11          // length
    svc 0

    // exit(0)
    mov x8, 93          // syscall: exit
    mov x0, 0
    svc 0
```
Compilar en EC2 (usando Tailscale VPN)

```bash
as -o hola.o hola.s
ld -o hola hola.o
./hola
```

Debe imprimir:
```bash
Hola mundo
```

✅ Con esto, el estudiante:
- Levantó un EC2 ARM64.
- Instaló Tailscale con Gmail.
- Entró a su nodo desde su celular por red privada.
- Compiló su primer programa ARM64 en ensamblador desde su Iphone.
