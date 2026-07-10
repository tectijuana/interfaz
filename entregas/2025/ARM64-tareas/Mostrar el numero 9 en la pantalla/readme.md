# Despliegue del número 9 en la terminal

**Nombre:** Rogelio Avilez Jr  
**Número de control:** 22210284  
**Materia:** Idiomas de Interfaz  
**Fecha:** 2025/09/23  
---
## Introducción
En este ejercicio se implementa la visualización del número "9" en la terminal utilizando dos enfoques: un lenguaje de alto nivel (Python) y un lenguaje de bajo nivel (ARM64). El objetivo es comparar la simplicidad de Python con el control detallado del ensamblador sobre la salida en pantalla.  

## Objetivo
Demostrar cómo se puede mostrar un número en la terminal utilizando tanto un lenguaje de alto nivel como un lenguaje de bajo nivel, comprendiendo las diferencias en su ejecución y manejo de recursos del sistema.  

## 1. Código de alto nivel (Python)

### 1.1 Creación del archivo
```
bash nano mostrar9.py
```
### 1.2 Código Python
```
# --------------------------------------------------------
# Programa: mostrar9.py
# Autor: Rogelio Avilez Jr
# Descripción: muestra el número 9 en pantalla
# --------------------------------------------------------
print("9") # imprime el número 9 en stdout
```
### 1.3 Ejecución
```
python3 mostrar9.py
```
Salida esperada: "9"

## 2. Código de bajo nivel (ARM64)
### 2.1 Creación del archivo
```
nano mostrar9.asm
```
### 2.2 Código ARM64
```
        .sección .datos
mensaje:
        .ascii "9\n"
        .sección .texto
        .global_start
_comenzar:
        movimiento x0, 1
        adrp x1, mensaje
        suma x1, x1, :lo12:mensaje
        movimiento x2, 2
        mov x8, 64
        servicio 0
        movimiento x0, 0
        película x8, 93
        servicio 0
```
### 2.3 Ensamblado y ejecución
```
sudo apt install qemu-user
qemu-aarch64
./mostrar9
```
Salida esperada: "9"

### Vídeo de asciinema: https://asciinema.org/a/0P9znKsA78oi1PN8Ube3gevkL

## Conclusión
Se logró implementar correctamente el número "9" en la terminal en ambos lenguajes. Python permite una solución rápida y concisa, mientras que ARM64 ofrece un control más directo sobre los recursos del sistema, evidenciando las diferencias entre programación de alto y bajo nivel.
