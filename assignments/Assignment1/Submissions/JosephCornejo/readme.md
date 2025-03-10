# Programa para invertir una cadena en Troy’s Breadboard Computer

## Codigo Fuente:

Autor: Joseph Cornejo Torres

Fecha: 03-03-25

Descripción: Este programa toma una cadena en memoria y la invierte, 
;              almacenando el resultado en otra ubicación.

.data:
STRING:  db 79, 76, 76, 69, 72, 255  ; "OLLEH" en ASCII con terminador 255
RESULT:  db 0, 0, 0, 0, 0, 255       ; Espacio para "HELLO"

.code:
main:
   ## assembly

    lod R0, STRING+4   ; Cargar 'H'
    
    sto RESULT         ; Guardar en la primera posición de RESULT

     lod R0, STRING+3   ; Cargar 'E'
    sto RESULT+1       ; Guardar en la segunda posición de RESULT
    
    lod R0, STRING+2   ; Cargar 'L'
    sto RESULT+2       ; Guardar en la tercera posición de RESULT

    lod R0, STRING+1   ; Cargar 'L'
    sto RESULT+3       ; Guardar en la cuarta posición de RESULT

    lod R0, STRING     ; Cargar 'O'
    sto RESULT+4       ; Guardar en la quinta posición de RESULT

    hlt               ; Terminar ejecución

    # Inversión de Cadenas en Troy’s Breadboard Computer

![image](https://github.com/user-attachments/assets/495a0afb-4a26-4248-bb61-ef6c5563e437)

    

## 📌 Descripción
Este programa ensambla y ejecuta en **Troy’s Breadboard Computer** para invertir una cadena almacenada en memoria.

## 🔹 Lógica del Programa
1. Se almacena la cadena `"OLLEH"` en memoria.
2. Se copian los caracteres manualmente en orden inverso en `RESULT`.
3. Se utiliza **`lod`** para cargar valores y **`sto`** para almacenarlos en la nueva ubicación.
4. El programa termina con **`hlt`**.

## 📜 Código Fuente
El código está en el archivo **`string_reverse.asm`**.

## 🎬 Demostración en el Emulador
1. **Cargar el código en Troy’s Breadboard Computer**.
2. **Presionar "Assemble"** para compilarlo.
3. **Presionar "Emulate"** y revisar la memoria:
   - **Entrada:** `"OLLEH"` → `79, 76, 76, 69, 72`
   - **Salida esperada:** `"HELLO"` → `72, 69, 76, 76, 79` (guardado en `RESULT`).

## 📥 Instalación y Uso
Para ejecutarlo:
```bash
git clone https://github.com/tectijuana/Class-Sessions.git
cd Class-Sessions/u1/8bitASM/string_reverse
