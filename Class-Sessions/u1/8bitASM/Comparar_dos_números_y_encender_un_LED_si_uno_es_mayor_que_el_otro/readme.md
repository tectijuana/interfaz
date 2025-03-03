![image](https://github.com/user-attachments/assets/5df2554b-9929-4c19-9f0c-5abbfd2c6268)

# TECNOLÓGICO NACIONAL DE MÉXICO INSTITUTO TECNOLÓGICO DE TIJUANA
## Subdirección académica departamento de sistemas y computación

**Semestre:** Enero - Junio


**Carrera:** Sistemas computacionales
**Materia:** Lenguajes de interfaz SCC-1014
**Titulo:** Introduccion en Markdown
 
**Unidad:** 1


**Alumno:** 
-Luis Manuel Ramón Hernández 22211639
   
**Docente:**
  Rene Solis Reyes



# Comparar dos números y encender un LED si uno es mayor que el otro.

La práctica compara dos números almacenados en los registros Ra y Rb. Luego, muestra el número mayor en la pantalla LCD del emulador.

**Código del programa**

assembly
```assembly

; Programa para comparar dos números y encender un LED si uno es mayor que el otro

; Definimos los números a comparar (puedes cambiar estos valores)
NUM1 = 5
NUM2 = 3

; Cargamos los números en los registros
mva #NUM1    ; Carga NUM1 en Ra
mvb #NUM2    ; Carga NUM2 en Rb

; Comparamos NUM1 con NUM2
sub Rb       ; Ra = Ra - Rb

; Si Ra > 0, entonces NUM1 > NUM2
jnz .encender_led

; Si llegamos aquí, NUM1 <= NUM2, así que apagamos el LED
mva #0
mvd Ra       ; Mueve 0 a Rd (LED apagado)
jmp .fin

.encender_led:
mva #1
mvd Ra       ; Mueve 1 a Rd (LED encendido)

.fin:
; Fin del programa

```

**Pasos:**

* Cargar los números: Se cargan los dos números que se van a comparar en los registros Ra y Rb.
* Comparar los números: Se utiliza la instrucción cmp para comparar los valores de Ra y Rb.
* Mostrar el número mayor:
Si Ra > Rb, se mueve el valor de Ra al registro Rd, que está conectado a la pantalla LCD.
Si Ra <= Rb, se mueve el valor de Rb al registro Rd.
* Detener el programa: La instrucción hlt detiene la ejecución del programa.


**Captura del emulador**
![Captura de pantalla (28)](https://github.com/user-attachments/assets/c58a6a88-6685-4dad-813c-fbfb4843b5aa)


