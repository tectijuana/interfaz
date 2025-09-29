# SEP TecNM  
## INSTITUTO TECNOLÓGICO DE TIJUANA  
### DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN  

**Ingeniería en Sistemas Computacionales**  
**PORTAFOLIO DE EVIDENCIAS U1**  

---

## Dividir 10 entre 2 usando restas  

**LENGUAJES DE INTERFAZ SCC-1014**  
**UNIDAD POR EVALUAR: 1**  
**Presenta:** Serna Sauceda José Enrique [#23210667]  
**Docente:** René Solís Reyes  
**Tijuana, B.C. – 23 de septiembre de 2025**  

---

## CÓDIGO  

```asm
; ------------------------------------------------------------
; División por restas: 10 / 2
; Resultado esperado (cociente): 5
; Troy’s Breadboard Computer (8-bit)
; Rd se usa como "display" para mostrar el cociente.
; ------------------------------------------------------------

DIVIDENDO = 10
DIVISOR   = 2

start:
    ; Inicialización
    data Rb, DIVISOR   ; Rb = divisor fijo
    data Rc, DIVIDENDO ; Rc = dividendo (variable)
    clr  Rd            ; Rd = 0 (cociente)

.loop:
    sub  Rc            ; Rc = Rc - Rb
    jn   .fin          ; Si Rc < 0, terminamos

    inc  Rd            ; Cociente++
    jmp  .loop         ; Repetir

.fin:
    add  Rc            ; Rc = Rc + Rb (opcional: recuperar residuo)
    hlt                ; Resultado final en Rd

```
