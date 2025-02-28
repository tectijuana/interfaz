# TECNOLÓGICO NACIONAL DE MÉXICO INSTITUTO TECNOLÓGICO DE TIJUANA
## Subdirección académica departamento de sistemas y computación

**Semestre:** Enero - Junio

**Carrera:** Sistemas computacionales

**Grupo:** SC6C

**Materia:** Lenguajes de interfaz SCC-1014

**Titulo:** Ordenamiento de 3 numeros con metodo burbuja
 
**Unidad:** 1

**Alumno:** 
 - Roldan Castro Luis Alberto

**Docente:**
  Rene Solis Reyes


## Codigo de ensamblador

### Ordenamiento de 3 numeros metodo burbuja

```assembly
; Definimos las direcciones de memoria donde se almacenarán los números
NUM1 = 0x10      ; Dirección de memoria para el primer número
NUM2 = 0x11      ; Dirección de memoria para el segundo número
NUM3 = 0x12      ; Dirección de memoria para el tercer número

start:
    clra          ; Limpia el acumulador

    ; Almacenar los valores iniciales en memoria
    mov Ra, 50    ; Primer número
    sto Ra, NUM1  ; Guardamos el primer número en NUM1

    mov Ra, 30    ; Segundo número
    sto Ra, NUM2  ; Guardamos el segundo número en NUM2

    mov Ra, 40    ; Tercer número
    sto Ra, NUM3  ; Guardamos el tercer número en NUM3

    ; Cargar los números de memoria en los registros
    lod Ra, NUM1  ; Cargar el primer número en Ra
    lod Rb, NUM2  ; Cargar el segundo número en Rb
    lod Rc, NUM3  ; Cargar el tercer número en Rc

    ; Comparar Ra con Rb
    cmp Ra, Rb    ; Compara Ra con Rb
    jnc skip1     ; Si Ra ≤ Rb, saltar el intercambio
    mov Rd, Ra    ; Guardar Ra en Rd (temporal)
    mov Ra, Rb    ; Mover Rb a Ra
    mov Rb, Rd    ; Mover Rd a Rb

skip1:
    ; Comparar Rb con Rc
    cmp Rb, Rc    ; Compara Rb con Rc
    jnc skip2     ; Si Rb ≤ Rc, saltar el intercambio
    mov Rd, Rb    ; Guardar Rb en Rd (temporal)
    mov Rb, Rc    ; Mover Rc a Rb
    mov Rc, Rd    ; Mover Rd a Rc

skip2:
    ; Comparar Ra con Rb nuevamente
    cmp Ra, Rb    ; Compara Ra con Rb
    jnc skip3     ; Si Ra ≤ Rb, saltar el intercambio
    mov Rd, Ra    ; Guardar Ra en Rd (temporal)
    mov Ra, Rb    ; Mover Rb a Ra
    mov Rb, Rd    ; Mover Rd a Rb

skip3:
    ; Verificar si hubo intercambio. Si no, terminar
    lod Rd, Ra    ; Cargar Ra en Rd
    cmp Rd, Rb    ; Comparar Ra con Rb
    jz .end_sort  ; Si no hubo intercambio, termina el ciclo

    ; Si hubo intercambio, repetir el ciclo
    jmp start

.end_sort:
    ; Almacenar los números ordenados de nuevo en memoria
    sto Ra, NUM1  ; Guardar el valor de Ra (el menor) en NUM1
    sto Rb, NUM2  ; Guardar el valor de Rb (el segundo menor) en NUM2
    sto Rc, NUM3  ; Guardar el valor de Rc (el mayor) en NUM3

    hlt           ; Termina la ejecución
```

# Tabla de Instrucciones del Código

| **Instrucción**     | **Descripción**                                                                                     |
|----------------------|-----------------------------------------------------------------------------------------------------|
| `lod`                | Carga el valor de una dirección de memoria en un registro.                                          |
| `sto`                | Almacena el valor de un registro en una dirección de memoria.                                       |
| `mov`                | Mueve el valor de un registro a otro.                                                               |
| `cmp`                | Compara los valores de dos registros o un registro con una constante.                               |
| `jnc`                | Salta a la etiqueta especificada si la comparación anterior no fue negativa (Carry flag no está activado). |
| `jz`                 | Salta a la etiqueta especificada si la comparación anterior fue igual a cero (Zero flag activado).  |
| `jmp`                | Salta incondicionalmente a la etiqueta especificada.                                                |
| `clr`                | Limpia el registro (lo pone en cero).                                                               |
| `rts`                | Retorna de una subrutina (especifica el final de una llamada a subrutina).                          |
| `hlt`                | Detiene la ejecución del programa.                                                                  |
