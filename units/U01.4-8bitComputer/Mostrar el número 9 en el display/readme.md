# Despliegue del número 9 en la terminal

**Nombre:** Rogelio Avilez Jr  
**Número de control:** 22210284  
**Materia:** Lenguajes de Interfaz  
**Fecha:** 2025/09/23  

---
## Introducción
En este ejercicio se implementa la visualización del número "9" en la terminal utilizando dos enfoques: un lenguaje de alto nivel (Python) y un lenguaje de bajo nivel (ASM64). El objetivo es comparar la simplicidad de Python con el control detallado del ensamblador sobre la salida en pantalla.  

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
print("9")   # imprime el número 9 en stdout
```
### 1.3 Ejecución
```
python3 mostrar9.py
```
Salida esperada: "9"

## 2. Código de bajo nivel (ASM64)
### 2.1 Creación del archivo
```
nano mostrar9.asm

```
### 2.2 Código ASM64
```
; --------------------------------------------------------
; Programa: mostrar9.asm
; Autor: Rogelio Avilez Jr
; Fecha: 2025-09-23
; Descripción: muestra el número 9 en pantalla
; --------------------------------------------------------

section .data
mensaje:    db '9', 0x0A        ; carácter '9' + salto de línea
len:        equ $ - mensaje

section .text
global _start

_start:
    ; --- write(1, mensaje, len) ---
    mov     rax, 1              ; syscall write
    mov     rdi, 1              ; fd = stdout
    lea     rsi, [rel mensaje]  ; dirección del buffer
    mov     rdx, len            ; longitud
    syscall

    ; --- exit(0) ---
    mov     rax, 60             ; syscall exit
    xor     rdi, rdi
    syscall

```
### 2.3 Ensamblado y ejecución
```
nasm -felf64 mostrar9.asm -o mostrar9.o
ld mostrar9.o -o mostrar9
./mostrar9
```
Salida esperada: "9"

## Conclusión
Se logró desplegar correctamente el número "9" en la terminal en ambos lenguajes. Python permite una solución rápida y concisa, mientras que ASM64 ofrece un control más directo sobre los recursos del sistema, evidenciando las diferencias entre programación de alto y bajo nivel.
