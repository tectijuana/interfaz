# Unidad 1 – Introducción al Lenguaje Ensamblador

## 🎯 Propósito de la unidad
Esta unidad tiene como objetivo que el estudiante comprenda **la importancia del lenguaje ensamblador** en el desarrollo de sistemas, identifique los **componentes internos del procesador** y adquiera las bases necesarias para programar a nivel bajo, considerando registros, memoria e interrupciones.

## 📘 Contenidos principales
De acuerdo al temario, en esta unidad se estudiarán los siguientes aspectos:

1. **Importancia de la programación en lenguaje ensamblador**  
   - Relación con otros lenguajes de alto nivel.  
   - Casos en los que el control bajo nivel es indispensable.  

2. **El procesador y sus registros internos**  
   - Tipos de registros: de propósito general, especiales, de estado.  
   - Función de cada uno en la ejecución de instrucciones.  

3. **La memoria principal (RAM)**  
   - Organización y direccionamiento.  
   - Relación entre CPU y memoria.  

4. **El concepto de interrupciones**  
   - Tipos: internas, externas, de software.  
   - Flujo de atención y vector de interrupciones.  

5. **Llamadas a servicios del sistema**  
   - Interacción con el sistema operativo mediante interrupciones.  

6. **Modos de direccionamiento**  
   - Inmediato, directo, indirecto, indexado, relativo.  

7. **Proceso de ensamblado y ligado**  
   - Del código fuente al ejecutable.  
   - Papel del ensamblador y linker.  

8. **Desplegado de mensajes en el monitor**  
   - Primeros programas en ensamblador para interacción básica.  

## 🧠 Competencias a desarrollar
- Identificar la estructura básica de un procesador y su set de instrucciones.  
- Comprender la importancia del ensamblador en el control de hardware.  
- Usar adecuadamente modos de direccionamiento en ejemplos prácticos.  
- Implementar programas simples que interactúen con memoria y pantalla.  
  

---

> 📌 **Nota:** Esta introducción sirve como punto de partida. Los capítulos teóricos están en `lecturas/`, la lección de ARM Virtual Hardware en `labs/`, y las prácticas verificables de esta unidad en `../../practicas/`.

## 🧪 Actividades prácticas de la unidad
| Subtema | Actividad |
|---|---|
| 1.4–1.5 Interrupciones y syscalls | `lab-interrupciones-gdb.md` (sesión guiada GDB+GEF + strace) |
| 1.6 Modos de direccionamiento | `../../practicas/P02-modos-direccionamiento/` (verificable, con variante por alumno) |
| 1.7–1.8 Ensamblado, ligado y mensajes | `../../practicas/P01-hola-arm64/` (piloto `make test`) |
