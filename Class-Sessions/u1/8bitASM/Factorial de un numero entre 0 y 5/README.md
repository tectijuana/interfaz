
## 1. Descripción General

El código tiene como propósitoCalcular el factorial de numero entre 0 y 5. En este caso trabajaremos con el numero 3. Este programa esta hecho en el simulador "Troy's Breadboard Computer.
## 2. Código

A continuación, se presenta el código fuente:

````
; FACTORIAL (Cálculo de solo un número entre 0 y 5)
; Número a calcular el factorial se coloca en Ra (Ejemplo: 3)

.begin:
    data Ra, 3         ; Número cuyo factorial se calculará (cambia este valor entre 0 y 5)
    data Rd, 1         ; Inicializa el resultado en 1 (Ra! = 1 por defecto)
    
    clr Rc             ; Rc se usará como contador para el ciclo (iniciado en 0)
    
.factorial_loop:
    cmp Ra             ; Compara Ra con 0
    jz .end            ; Si Ra es 0, termina el ciclo
    
    add Rd             ; Multiplica el resultado (Rd) por Ra
    dec Ra             ; Decrementa Ra
    jmp .factorial_loop ; Repite el ciclo

.end:
    hlt                ; Detiene la ejecución
````

![image](https://github.com/user-attachments/assets/981e804d-58f5-402c-acf1-9a5373017b1f)
