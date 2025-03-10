Alumno: Covarrubias Garcia Milco Moises #19211619
Programa que calcula el factorial de un numero pequeño (1-5) almacenado en memoria.



section .data
    number dq 5      ; Número del cual se calculará el factorial (1-5)
    result dq 0      ; Aquí se almacenará el factorial calculado

section .text
    global _start

_start:
    mov rax, 1       ; Inicializamos rax en 1 (factorial acumulado)
    mov rcx, [number] ; Cargamos el número (n) en rcx
    mov rbx, 1       ; Inicializamos rbx en 1 (contador i)

calcular_factorial:
    cmp rbx, rcx
    jg fin_calculo      ; Si el contador supera n, terminamos el bucle
    imul rax, rbx       ; rax = rax * rbx
    inc rbx             ; Incrementamos el contador (i++)
    jmp calcular_factorial

fin_calculo:
    mov [result], rax   ; Guardamos el resultado del factorial en memoria

     ; Terminamos el programa
    mov rax, 60         ; Número de llamada al sistema para exit (sys_exit)
    xor rdi, rdi        ; Código de salida 0
    syscall
