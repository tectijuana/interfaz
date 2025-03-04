# CÓDIGO FUENTE DOCUMENTADO
    ;------------------------------------------------------------------------------------------------------------------------------
    ;                                            INSTITUTO TECNOLOGICO DE TIJUANA
    ;Nombre del Programa: Lea tres números de memoria y determine cuál es el mayor, mostrando el resultado en LED.
    ;Autor: Daniel Romero Bravo
    ;Fecha de Entrega: 03/03/2025
    ;Num. Control: 22211650
    ;Descripción: Este programa en ensamblador encuentra el número más alto entre tres valores predefinidos y lo muestra en el display.
    ;------------------------------------------------------------------------------------------------------------------------------
    
    ; Cargar los tres números en registros
    mva #43  ; Primer número en Ra
    mvb #23  ; Segundo número en Rb
    mvc #67  ; Tercer número en Rc

    ; Comparar Ra con Rb
    cmp Ra    ; Compara Ra con Rb
    jnn SIGUIENTE  ; Si Ra >= Rb, seguir comparando con Rc
    mva Rb    ; Si Rb es mayor, moverlo a Ra

    SIGUIENTE:
        mvb Rc    ; Mover Rc a Rb para la comparación
        cmp Ra    ; Comparar Ra con Rc (ahora en Rb)
        jnn FIN   ; Si Ra >= Rc, terminar
        mva Rc    ; Si Rc es mayor, moverlo a Ra

    FIN:
        mov Rd, Ra  ; Mostrar el número mayor en el display
        hlt         ; Finalizar el programa

# LOGICA Y FUNCIONAMIENTO
El algoritmo sigue una serie de comparaciones secuenciales para encontrar el valor más alto entre tres números cargados en los registros Ra, Rb y Rc.
- Se cargan tres números en los registros Ra, Rb y Rc.
- Se compara Ra con Rb. Si Rb es mayor, su valor se mueve a Ra.
-Luego, Ra se compara con Rc. Si Rc es mayor, su valor se mueve a Ra.
- Finalmente, el valor de Ra (el número mayor) se copia en Rd para mostrarlo en el display.

# DEMOSTRACIÓN

![image](https://github.com/user-attachments/assets/15e820dd-b340-4ccf-87ab-b343001ea5b0)

![image](https://github.com/user-attachments/assets/f7b4831e-f80d-4154-bdd7-211bc5e58d83)
