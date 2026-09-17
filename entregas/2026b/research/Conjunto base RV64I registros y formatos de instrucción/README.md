# Conjunto base RV64I: registros y formatos de instrucción

### Instituto Tecnológico de Tijuana
### Departamento de Sistemas y Computación

**Materia:** Lenguajes de Interfaz  
**Semestre:** 6to Semestre  
**Alumno:** Reyes Madrigal Diana María  
**Número de Control:** 24210521


## Introducción a RV64I
El **RV64I** es el conjunto de instrucciones base de enteros de 64 bits obligatorio para la arquitectura RISC-V. Sus características principales son:
* **Diseño modular:** Es el cimiento sobre el cual se construyen extensiones adicionales (como punto flotante o multiplicación).
* **Tamaño fijo:** Aunque los datos y registros son de 64 bits, **todas las instrucciones miden exactamente 32 bits**. Esto simplifica drásticamente el diseño del hardware y la decodificación.


## Banco de Registros (Register File)

La arquitectura RV64I cuenta con **32 registros de propósito general** (GPRs), nombrados del `x0` al `x31`, cada uno con un ancho de 64 bits. También incluye un registro dedicado para el Contador de Programa (`pc`).


### Registros Clave:
* **`x0` (zero):** Está conectado a tierra por hardware; siempre devuelve el valor `0`. Simplifica el diseño al evitar instrucciones redundantes (ej. mover un dato es simplemente sumar `0` al registro original).
* **`x1` (ra):** Dirección de retorno (Return Address). Guarda a dónde debe volver el flujo después de una función.
* **`x2` (sp):** Puntero de pila (Stack Pointer).
* **`x10 - x17` (a0 - a7):** Utilizados para pasar argumentos a funciones y retornar valores.
* **`s0 - s11`:** Registros guardados. Su valor debe preservarse si se llama a otra función (Callee-saved).
* **`t0 - t6`:** Registros temporales. Pueden sobrescribirse libremente (Caller-saved).


## Formatos de Instrucción

Para mantener la eficiencia y rapidez, RV64I organiza sus instrucciones de 32 bits en solo **6 formatos base**. El diseño garantiza que los registros de origen (`rs1`, `rs2`) y de destino (`rd`) siempre ocupen la misma posición en los bits, sin importar el formato.

<img width="720" height="303" alt="image" src="https://github.com/user-attachments/assets/c2b592ef-fe23-4c32-8d1e-30969f164643" />

### Los 6 Formatos Base:
1. **Formato R (Register):** 
   * **Uso:** Operaciones aritmético-lógicas entre dos registros.
   * **Ejemplos:** `add`, `sub`, `and`, `or`, `sll`.
2. **Formato I (Immediate):** 
   * **Uso:** Aritmética con constantes, cargas de memoria (loads) y saltos incondicionales.
   * **Ejemplos:** `addi`, `ld` (load doubleword), `jalr`.
3. **Formato S (Store):** 
   * **Uso:** Guardar datos desde un registro hacia la memoria (stores). El valor inmediato se divide en dos campos para no mover los bits de los registros de origen.
   * **Ejemplos:** `sd` (store doubleword), `sb` (store byte).
4. **Formato B (Branch):** 
   * **Uso:** Saltos condicionales. Codifica un desplazamiento de memoria basado en el contador de programa (`pc`).
   * **Ejemplos:** `beq` (branch if equal), `blt` (branch if less than).
5. **Formato U (Upper Immediate):** 
   * **Uso:** Cargar inmediatos grandes (20 bits) en la parte superior del registro.
   * **Ejemplos:** `lui` (load upper immediate).
6. **Formato J (Jump):** 
   * **Uso:** Saltos incondicionales con un rango amplio de direcciones (20 bits).
   * **Ejemplo:** `jal` (jump and link).


## Conclusión
El conjunto RV64I destaca por su minimalismo. Al mantener un tamaño de instrucción fijo de 32 bits y aprovechar el registro `x0` como cero constante, elimina la necesidad de instrucciones redundantes. La consistencia en la posición de los campos dentro de los seis formatos principales (R, I, S, B, U, J) optimiza el pipeline del procesador y facilita la programación en lenguaje ensamblador a bajo nivel.

## Referencias
* Waterman, A., & Asanović, K. (Eds.). *The RISC-V Instruction Set Manual, Volume I: Unprivileged ISA*. RISC-V International.
* Patterson, D. A., & Waterman, A. *The RISC-V Reader: An Open Architecture Atlas*. Strawberry Canyon.
