![418610058-6990d41d-7bde-425c-91cc-73c9eb7c3c0d](https://github.com/user-attachments/assets/163dabc3-436a-4a31-a416-4f25340a0de7)
 TECNOLÓGICO NACIONAL DE MÉXICO
 INSTITUTO TECNOLÓGICO DE TIJUANA
 
 SUBDIRECCIÓN ACADÉMICA
 DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN
 
 SEMESTRE:
 Enero - Junio 2025
 
 CARRERA:
 Ingeniería en Sistemas Computacionales
 
 MATERIA:
 
 Lenguajes de interfaz
 
 TÍTULO ACTIVIDAD:
 
 Suma de una serie aritmética almacenada en memoria.
 
 NOMBRE Y NÚMERO DE CONTROL:
 
 Contreras Hernandez Jonathan 22211539
 
 NOMBRE DEL MAESTRO (A):
         
 René Solis Reyes
 
 Codigo documentado
 
     clr Ra          ; Inicializamos acumulador a 0
     data Rb, 1      ; Número inicial
     data Rc, 11     ; Límite (11 para que llegue hasta 10)
     
     .inicio:
     push Rb         ; Guardamos el número actual en la pila
     add Ra, Rb      ; Sumamos el número actual al acumulador
     inc Rb          ; Incrementamos el número
     cmp Rb, Rc      ; Comparamos si Rb == 11
     jnz .inicio      ; Si no ha llegado al límite, seguimos sumando
 
     .fin:
     mov Rd, Ra      ; Pasamos el resultado al registro de salida         
 		
     hlt             ; Fin del programa
 
 Breve explicacion de la logica del programa
 
 Este programa escrito en lenguaje ensamblador para la Computadora de Troy realiza la suma de los números consecutivos del 1 al 10, almacenando el resultado en memoria y mostrándolo en la pantalla. Utiliza la pila para guardar los números de la serie y muestra el resultado final usando la instrucción de salida
 
 Lógica del Programa
 La lógica consiste en realizar las siguientes operaciones:
 
 INICIO
 
 Se limpia el acumulador Ra para asegurarse de que no contenga valores previos.
 Se asigna el valor inicial 1 al registro Rb para comenzar la serie.
 Se establece el límite 11 en Rc (ya que la comparación se realiza con valores estrictamente iguales).
 
 CICLO
 
 En cada iteración, se guarda el valor actual de Rb en la pila con la instrucción push Rb.
 El valor de Rb se suma al acumulador Ra con add Ra, Rb.
 Se incrementa Rb con inc Rb para avanzar al siguiente número.
 Se compara el valor de Rb con el límite Rc usando cmp Rb, Rc.
 Si Rb es menor que Rc, se repite el ciclo con jnz .inicio.
 
 ROMPE CONDICION
 
 Cuando la comparación indique que Rb = 11, el bucle termina.
 El valor final acumulado en Ra se copia a Rd con la instrucción mov Rd, Ra.
 Salida del Resultado:
 
 El valor almacenado en Rd se muestra en la pantalla, el programa se detiene con hlt.
 
 CAPTURAS DE PRUEBA DEL PROGRAMA
 
 ![image](https://github.com/user-attachments/assets/572cbc5b-bc5e-450b-ae00-9fa79414ab60)
                                                             
 ![image](https://github.com/user-attachments/assets/eb8ca770-5cba-492a-a275-a142c9b54da9)
 
