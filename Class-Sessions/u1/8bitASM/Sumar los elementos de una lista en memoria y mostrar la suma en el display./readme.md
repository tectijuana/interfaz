# Suma de Elementos en Memoria y Visualización en Display

## Código Fuente

```assembly
; ============================================================
; Programa:  Sumar los elementos de una lista en memoria y mostrar la suma en el display.
; Autor:     Fernando Andre Urrea Gonzalez
; Matrícula: C22211401
; Instituto: Instituto Tecnológico de Tijuana
; Fecha: 03/03/2025
; Ensamblador: Troy's Breadboard Computer ASM
; ============================================================

.start:
  mva #0      ; Inicializar Ra en 0 (acumulador de suma)
  mvc #0x90   ; Cargar dirección base de la lista en Rc
  mov Rd, 0   ; Establece la display en 0, tambien nos sirve como comparacion.

  ; Almacenar los números en memoria manualmente
  mvb #10     ; Se asigna Rb en 10
  sto Rc, Rb  ; Se guarda el valor de Rb en un registro de memoria de Rc
  inc Rc      ; Se aumenta la posicion de memoria de Rc

  mvb #20  
  sto Rc, Rb  
  inc Rc  

  mvb #50  
  sto Rc, Rb  
  inc Rc  

  mvb #100  
  sto Rc, Rb  
  inc Rc  

  mvb #0   ; El "0" Marca de fin de lista
  sto Rc, Rb  
  
  ; Reiniciar el puntero de lectura a 0x90
  mvc #0x90

.loop:
  lod Rb, Rc      ; Cargar el valor desde la memoria en Rb
  cmp Rd          ; Comparar con el marcador de fin de lista
  jnn .done       ; Si es 0, terminar la suma
  add Ra          ; Sumar Rb a Ra
  inc Rc          ; Mover al siguiente elemento de la lista
  jmp .loop       ; Repetir el proceso

.done:
  mov Rd, Ra      ; Mover el resultado final al registro de display
  hlt             ; Detener la ejecución
```

---

## Introducción
Este programa en ensamblador para el **Troy's Breadboard Computer** suma los elementos almacenados en una lista en memoria y muestra el resultado en el registro de display (**Rd**). Se implementa un mecanismo de recorrido de memoria para leer los valores, sumarlos y finalmente mostrar el resultado en pantalla.

## Lógica y Funcionamiento

El programa sigue los siguientes pasos:

### **1. Inicialización**
- **Ra** se inicializa en `0` para funcionar como acumulador de la suma.
- **Rc** se establece en `0x90`, la dirección de inicio de la lista en memoria.
- **Rd** se pone en `0`, funcionando como display y también como referencia para la comparación con la marca de fin de lista.

### **2. Almacenamiento de Datos en Memoria**
- Se almacenan manualmente los valores `10, 20, 50, 100` en memoria, incrementando **Rc** después de cada almacenamiento.
- Finalmente, se guarda un `0` como **marca de fin de lista**.

### **3. Reinicio del Puntero de Lectura**
- **Rc** se vuelve a establecer en `0x90` para iniciar la lectura desde el primer valor.

### **4. Bucle de Suma**
- Se carga el valor actual de memoria en **Rb** usando `lod Rb, Rc`.
- Se compara con **Rd** (`0`) para verificar si es el marcador de fin de lista.
- Si el valor es `0`, se salta a `.done` y termina la suma.
- Si no es `0`, el valor se suma a **Ra**.
- Se incrementa **Rc** para pasar al siguiente valor en la lista.
- Se repite el proceso hasta que se encuentre el `0`.

### **5. Mostrar el Resultado**
- Cuando se detecta el `0`, el programa mueve el resultado final de **Ra** a **Rd** para visualizarlo en el display.
- Se ejecuta `hlt` para finalizar la ejecución.

## Demostración
![Captura de pantalla 2025-03-03 202611](https://github.com/user-attachments/assets/4665c1db-cf80-412d-9989-f2d59f7f996a)
![Captura de pantalla 2025-03-03 203341](https://github.com/user-attachments/assets/d9085508-07a2-4543-bac4-2564eb6587c7)


