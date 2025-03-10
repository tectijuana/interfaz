; Programa que utiliza la pila para almacenar y recuperar valores con PUSH y POP
    
    
    data Ra, 5      ; Valor 1 para almacenar en la pila
    data Rb, 10     ; Valor 2 para almacenar en la pila
    ; Almacenar valores en la pila (PUSH)
    push Ra         ; Guarda el valor de Ra (5) en la pila
    push Rb         ; Guarda el valor de Rb (10) en la pila
    ; Recuperar valores de la pila (POP)
    pop Rb          ; Recupera el siguiente valor de la pila (10) y lo guarda en Rb
    pop Ra          ; Recupera el siguiente valor de la pila (5) y lo guarda en Ra
    ; Mostrar los valores recuperados en pantalla
    mvd Ra          ; Muestra el valor de Ra (5) en pantalla
    mvd Rb          ; Muestra el valor de Rb (10) en pantalla
    end:  jmp .end        ; Bucle infinito para terminar el programa






 EXPLICACION   
  Inicialización de valores:

Se cargan los valores 5, 10 y 15 en los registros Ra, Rb y Rc, respectivamente.

Uso de PUSH:

push Ra: Guarda el valor de Ra (5) en la pila.

push Rb: Guarda el valor de Rb (10) en la pila.

push Rc: Guarda el valor de Rc (15) en la pila.

Uso de POP:

pop Rc: Recupera el último valor de la pila (15) y lo guarda en Rc.

pop Rb: Recupera el siguiente valor de la pila (10) y lo guarda en Rb.

pop Ra: Recupera el siguiente valor de la pila (5) y lo guarda en Ra.

Mostrar valores en pantalla:

mvd Ra: Muestra el valor de Ra (5) en pantalla.

mvd Rb: Muestra el valor de Rb (10) en pantalla.

mvd Rc: Muestra el valor de Rc (15) en pantalla.

Fin del programa:

jmp .end: Entra en un bucle infinito para terminar el programa.


![image](https://github.com/user-attachments/assets/f060f39f-0e01-407b-800e-dd3bee0ec09f)
![image](https://github.com/user-attachments/assets/978c5c1b-2f6e-489b-bd45-004db4560c5d)

