
# Uso de la pila para almacenar y recuperar valores con operaciones PUSH y POP.

### Explicacion del Programa

Introducimos 3 valores en un registro, en este caso en Ra,luego los empujamos dentro de la pila con "**PUSH**" y con "**POP**" los recuperamos de la pila, en este caso hacemos uso del regristo Rd, dado que es el que esta relacionado con el display, por lo cual nos ayudara para visualizar lo que esta ocurriendo en el programa.

>¿Qué es una pila?
>
>Una pila es una estructura de datos la cual ordena los datos mediante LIFO, primer dato en entrar es el ultimo en salir. 
>





[**Opcion #1**](https://cpu.visualrealmsoftware.com/emu/?h=37070ab00732b0071eb05e0000005e0000005e0000002f00&s=)
```.asm
;Karla Itzel Vazquez Cruz
;Uso de la pila para almacenar y recuperar valores con operaciones PUSH y POP.
.pila: 
    clra
;ALMACENAR VALORES
    mov Ra,10
    push Ra;
    mov Ra,50
    push Ra;
    mov Ra,30
    push Ra;
; RECUPERAR VALORES
    Pop Rd 
      nop
      nop
      nop ;
    Pop Rd 
      nop
      nop
      nop;
    Pop Rd 
      nop
      nop
      nop;
jmp .pila;

```

[**Opcion 2**](https://cpu.visualrealmsoftware.com/emu/?h=37b70ab732b71e5e00000000005e00000000005e00000000002f00&s=)
```.asm
;Karla Itzel Vazquez Cruz
;Uso de la pila para almacenar y recuperar valores con operaciones PUSH y POP.
.pila: 
    clra
;ALMACENAR VALORES
    push 10
    push 50
    push 30
; RECUPERAR VALORES
    Pop Rd 
      nop
      nop
      nop
      nop
      nop ;
    Pop Rd 
      nop
      nop
      nop
      nop
      nop;
    Pop Rd 
      nop
      nop
      nop
      nop
      nop;
jmp .pila;

```
## Comandos a Utilizar 

### Push  
Empuja un valor a la pila.
```.asm
Push 30 ; Valor a empujar en la pila es 30 
```
Empujar un valor de un registro a la pila.
```.asm
Mov Ra, 30 
Push Ra ; Registro a emujar dentro de la Pila 
```
### Pop
```.asm
Pop Rd ; Extrae el ultimo valor introducido a la pila y lo coloca en el registro Rd
```
### Mov
Escribe el valor inmedianto en un registro.
```.asm
Mov Ra,30 ; Escribe el valor 30  en el registro Ra
```
### Clra
Limpia todos los registros.
```.asm
Clra 
```
### nop
Pausa el proceso por unos micro-segundos
```.asm
nop 
```
### Etiquetas
Sirven para hacer referencias a una direccion. 
```.asm
.pila ; etqiueta pila
        ...
        ...
        ...
jmp .pila ; hacemos referencia a pila
```
### jmp
Realiza un salto a la direccion indicada, actualizando el contador para que se ejecute en esa direccion a continuacion. 
```.asm
pila:
    ...
    ...
    ...

jmp pila ; realiza un salto a la etiqueta "pila"
```


