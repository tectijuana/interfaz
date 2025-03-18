![logos](https://github.com/user-attachments/assets/6990d41d-7bde-425c-91cc-73c9eb7c3c0d)
**TECNOLÓGICO NACIONAL DE MÉXICO**  
*INSTITUTO TECNOLÓGICO DE TIJUANA*

**SUBDIRECCIÓN ACADÉMICA**  
*DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN*

**CARRERA:**  
Ingeniería en Sistemas Computacionales

**MATERIA:**  
Lenguajes de interfaz

**NOMBRE DEL PROFESOR:**  
René Solis Reyes

**NOMBRE Y NÚMERO DE CONTROL:**  
Juarez Castelan Jose - 22211589 

**SEMESTRE:**  
Enero - Junio 2025

----------------------------------------------------------------------------------

# 🖥️ **Código Fuente: Multiplicación por Sumas Sucesivas con Valores en Memoria**

### 📜 **Descripción General**
Este código implementa la multiplicación de dos números utilizando el método de **sumas sucesivas** en un entorno de emulador de una computadora de 8 bits. El proceso se realiza mediante registros y valores almacenados en memoria, y se repite un ciclo hasta alcanzar el número de sumas necesarias para obtener el resultado.

### 👨‍💻 **Código Fuente**

```assembly
; ===============================================
; Multiplicación por sumas sucesivas con valores en memoria
; Troy's 8-bit computer - Emulator
; Código realizado por Juarez Castelan Jose (22211589)
; ===============================================

; Datos de entrada
data Rb, 3          ; Número multiplicando (por ejemplo, 3)
sto Rb, 0x10        ; Se almacena multiplicando en memoria (dirección 0x10)

data Rc, 4          ; Número multiplicador (por ejemplo, 4)
sto Rc, 0x11        ; Se almacena multiplicador en memoria (dirección 0x11)

data Ra, 0          ; Variable para guardar el resultado de la multiplicación (acumulador)
data Rd, 0          ; Variable para contar las sumas realizadas (contador)

; Inicio de la multiplicación (sumas sucesivas)
.loop:
    lod Rd, 0x10    ; Carga el número multiplicando desde memoria (dirección 0x10)
    add Ra          ; Suma el número multiplicando al acumulador Ra
    inc Rd          ; Incrementa el contador Rd (lleva cuenta de las sumas realizadas)
    
    lod Rc, 0x11    ; Carga el número multiplicador desde memoria (dirección 0x11)
    cmp Rd          ; Compara el contador Rd con el multiplicador Rc
    jnz .loop       ; Si el contador (Rd) es menor que el multiplicador (Rc), repite el proceso

; Finaliza y muestra el resultado de la multiplicación
mvd Ra             ; Muestra el resultado final en pantalla, que está almacenado en el acumulador Ra
jmp .end           ; Bucle infinito para mantener el resultado en pantalla

.end:
    jmp .end       ; Salto infinito para mantener la ejecución en el programa
```

---

### 📚 **Informe Explicativo**

#### 🎯 **Objetivo del Código:**
El objetivo de este código es realizar una **multiplicación** entre dos números utilizando el método de **sumas sucesivas**. Los números a multiplicar se almacenan en memoria y el resultado se calcula sumando el primer número tantas veces como indique el segundo número.

#### 🧠 **Explicación de la Lógica:**

1. **Datos de Entrada:**
   - **Multiplicando (`Rb`)**: Número que se multiplicará (Ej. 3).
   - **Multiplicador (`Rc`)**: Número que indica cuántas veces se sumará el multiplicando (Ej. 4).
   - **Resultado (`Ra`)**: Variable acumuladora para almacenar el resultado de la multiplicación.
   - **Contador (`Rd`)**: Lleva la cuenta de las sumas realizadas (inicia en 0).

2. **Proceso de Multiplicación:**
   - El ciclo comienza con la etiqueta `.loop`, donde se repite el siguiente proceso mientras el contador (`Rd`) sea menor que el multiplicador (`Rc`).
   - En cada iteración:
     1. **Carga el multiplicando** (`Rb`) desde memoria.
     2. **Suma el multiplicando** al acumulador `Ra`.
     3. **Incrementa el contador** (`Rd`) para llevar cuenta de las sumas.
     4. **Carga el multiplicador** (`Rc`) desde memoria.
     5. **Compara el contador** con el multiplicador. Si `Rd` es menor que `Rc`, el ciclo continúa repitiendo la suma.

3. **Finalización:**
   - El ciclo termina cuando el contador (`Rd`) alcanza el valor del multiplicador (`Rc`), es decir, cuando se han realizado todas las sumas necesarias.
   - El resultado se encuentra en el acumulador (`Ra`) y se muestra en pantalla utilizando la instrucción `mvd Ra`.
![image](https://github.com/user-attachments/assets/52c04bad-75b3-48e2-9832-bf50bc33ed6b)

4. **Mantener Ejecución:**
   - El programa entra en un bucle infinito al final (`jmp .end`) para mantener el resultado visible en pantalla.

![image](https://github.com/user-attachments/assets/1b70d0eb-32a3-4d6e-ab1e-881c2bbf818f)

#### 📊 **Conclusión:**
Este programa implementa una multiplicación utilizando el método de **sumas sucesivas** de una manera simple y eficiente en un entorno de ensamblador. El código realiza la multiplicación sumando el número multiplicando tantas veces como lo indique el multiplicador. Este tipo de algoritmos son fundamentales para entender cómo las computadoras pueden realizar operaciones aritméticas sin utilizar multiplicadores hardware complejos.

---
