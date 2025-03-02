# TECNOLÓGICO NACIONAL DE MÉXICO INSTITUTO TECNOLÓGICO DE TIJUANA
## Subdirección académica departamento de sistemas y computación

**Semestre:** Enero - Junio

**Carrera:** Sistemas computacionales

**Grupo:** SC6C

**Materia:** Lenguajes de interfaz SCC-1014

**Titulo:** Rotación de bits de un número en el registro A, desplazando en bucle hacia la izquierda y derecha
 
**Unidad:** 1

**Alumnado:** 
  Fonseca Novelo A. H.

**Docente:**
  Rene Solis Reyes

## Codigo de ensamblador

### Rotación de bits

```assembly
Pattern = 0b11001100

	clra
	data Ra, Pattern
	data Rc, Pattern
	
.begin:
	mvb Rc				;se operara el registro C
	lsr					;se le hace shift a la izquierda
	mvc Rb				;se guarda
	mvb Ra				;se operara el registro A
	jnc .right_begincount	;si no era un 1 salta seccion
	
.addone:		;seccion por si era un 1
	mvb Rc				;se operara el registro C
	inc Rb				;se añade un 1 al inicio
	mvc Rb				;se guarda
	
	mvb Ra				;se operara el registro A
.right_begincount:	
	mva Rb				;se guarda su dato
	
	inc Rd				;se aumenta el contador (registro D)
	mvb #8				;se coloca el numero
	cmp Rd				;se compara el contador con el numero
	
	jnn .last		;si rd es menor que sigua en el bucle
	
.right_begin:
	mvb Ra				;se operara el registro A
	lsr					;se le hace shift a la izquierda
	jnc .right_begincount	;si no era un 1 sigue adelante hasta tocar uno
	
.right_addone:	;seccion por si era un 1
	inc Rb				;se añade un 1 al inicio
	jmp .right_begincount

	
.last:
	mvb Ra
	mvd #0
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	jmp .begin
```

# Instrucciones

| **Instrucción** | **Descripcion** |
|-----------------|-----------------|
| `clra`| Limpia los registros desde Ra a Rd |
| `data`| Declara un registro |
| `mv(a,b,c,d)`| Permite mover un valor a uno de los registros |
| `lsr`| Le hace rotacion binaria hacia la izquierda a Rb |
| `jnc`| Salta a la etiqueta si el (C) bit de acarreo no esta activo |
| `inc`| Añade 1 a el registro que se mencione |
| `cmp`| Compara un registro o valor con Rb, devuelve N si es menor o Z si es igual |
| `jnn`| Salta a la etiqueta si el (N) bit de zero no esta activo |
| `nop`| Hace una pausa de 1 ciclo del reloj |
| `jmp`| Salta a la etiqueta |
