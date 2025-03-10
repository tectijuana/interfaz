Madrid Lugo Victor Manuel 22211602
# CÓDIGO FUENTE
```
; Madrid Lugo Victor Manuel 22211602
#addr 0x00
.start: 
; Cargar los números desde la memoria a los registros

lod Ra, 0x01  ; Cargar primer número en Ra

lod Rb, 0x02  ; Cargar segundo número en Rb

add Ra        ; Sumar Rb a Ra (Ra = Ra + Rb)

lod Rb, 0x03  ; Cargar tercer número en Rb

add Ra        ; Sumar Rb a Ra (Ra = Ra + Rb)
  
lod Rb, 0x04  ; Cargar cuarto número en Rb

add Ra        ; Sumar Rb a Ra (Ra = Ra + Rb)
  
lod Rb, 0x05  ; Cargar quinto número en Rb

add Ra        ; Sumar Rb a Ra (Ra = Ra + Rb)
  
sto Ra, 0x06  ; Almacenar resultado acumulado en la dirección de memoria 0x06
  
hlt           ; Detener la ejecución
```
# FUNCIONAMIENTO Y LÓGICA DEL CÓDIGO
Este programa de ensamblador tiene como objetivo sumar acumulativa de cinco números almacenados en direcciones de memoria consecutivas y almacenar el resultado en
una ubicación específica. El programa comienza en la dirección 0x00 con la etiqueta .start:. Primero, carga el primer número desde la dirección 0x01 al registro Ra. 
Luego, carga el segundo número desde 0x02 al registro Rb y lo suma al registro Ra. Este proceso se repite para el tercer, cuarto y quinto número, cargando cada uno
desde las direcciones 0x03, 0x04 y 0x05 respectivamente, y sumándolos al registro Ra. Finalmente, el resultado acumulado en Ra se almacena en la dirección de memoria
0x06. El programa termina con el comando hlt, que detiene la ejecución. En resumen, este programa carga cinco números desde la memoria, los suma en el registro Ra y 
almacena el resultado final en una dirección de memoria específica.

## TABLA DE INSTRUCCIONES

| Instrucción         | Descripción                                                                         |
|---------------------|-------------------------------------------------------------------------------------|
| `lod Ra, 0x01`      | Cargar el primer número desde la dirección de memoria 0x01 al registro Ra.          |
| `lod Rb, 0x02`      | Cargar el segundo número desde la dirección de memoria 0x02 al registro Rb.         |
| `add Ra`            | Sumar el contenido de Rb a Ra (Ra = Ra + Rb).                                       |
| `lod Rb, 0x03`      | Cargar el tercer número desde la dirección de memoria 0x03 al registro Rb.          |
| `add Ra`            | Sumar el contenido de Rb a Ra (Ra = Ra + Rb).                                       |
| `lod Rb, 0x04`      | Cargar el cuarto número desde la dirección de memoria 0x04 al registro Rb.          |
| `add Ra`            | Sumar el contenido de Rb a Ra (Ra = Ra + Rb).                                       |
| `lod Rb, 0x05`      | Cargar el quinto número desde la dirección de memoria 0x05 al registro Rb.          |
| `add Ra`            | Sumar el contenido de Rb a Ra (Ra = Ra + Rb).                                       |
| `sto Ra, 0x06`      | Almacenar el resultado acumulado en el registro Ra en la dirección 0x06.            |
| `hlt`               | Detener la ejecución del programa.                                                  |

# COMANDOS Y OPERADORES

| Comando | Descripción |
|---------|-------------|
| `lod`   | Cargar un valor desde la memoria a un registro. |
| `add`   | Sumar el valor de un registro al acumulador (Ra). |
| `sto`   | Almacenar el valor del acumulador (Ra) en la memoria. |
| `hlt`   | Detener la ejecución del programa. |

| Operando | Descripción |
|----------|-------------|
| `Ra`     | Registro acumulador, donde se almacenan y suman los valores. |
| `Rb`     | Registro auxiliar para cargar valores desde la memoria antes de sumarlos al acumulador (Ra). |
| `0x01`   | Dirección de memoria de la cual se carga el primer número. |
| `0x02`   | Dirección de memoria de la cual se carga el segundo número. |
| `0x03`   | Dirección de memoria de la cual se carga el tercer número. |
| `0x04`   | Dirección de memoria de la cual se carga el cuarto número. |
| `0x05`   | Dirección de memoria de la cual se carga el quinto número. |
| `0x06`   | Dirección de memoria donde se almacena el resultado final. |

# EVIDENCIA
![evidencia](https://github.com/user-attachments/assets/3aa6920e-ab3e-47e9-9a15-37295568612c)
