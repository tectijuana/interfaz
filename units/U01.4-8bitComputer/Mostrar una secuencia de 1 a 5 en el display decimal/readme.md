<div align="center">

#  Sistemas Operativos en Tiempo Real (RTOS) para ARM64  

**Universidad:** [Instituto Tecnologico de Tijuana]  
**Materia:** [Lenguaje de Interfaz]  
**Tema:** Bot 8 bit Proboard computer assembler  
**Alumno:** Jose Eduardo Elizondo Romero           
        **Numero de Control:** [22210303]  
**Profesor:** [RENE SOLIS REYES]  
**Fecha:** 25 de septiembre de 2025  

</div>

---
<div align="justify">

  **Programa:   Mostrar secuencia 1 → 5 en el display decimal**

**Descripción:** 

Inicia en 1 y va incrementando hasta 5.

Al llegar a 6, el contador se reinicia en 1.

**codigo:**

**start:** 

    data Rd, 1       ; iniciar en 1

**loop:** 

    inc Rd           ; incrementar el valor en Rd
    
    data Rb, 6       ; límite (cuando llegue a 6 reinicia)
    
    cmp Rd, Rb       ; comparar Rd con 6
    
    jz reset         ; si Rd == 6, reinicia
    
    jmp loop         ; de lo contrario, sigue en bucle

**reset:** 

    data Rd, 1       ; volver a 1
    
    jmp loop         ; repetir la secuencia



**Captura de la Practica:**


https://github.com/user-attachments/assets/ec0ae46c-aa33-46d4-a77d-7c0a761e3021


