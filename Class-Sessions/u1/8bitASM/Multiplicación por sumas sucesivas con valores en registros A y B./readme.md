<div align="center"> 
<img src='https://github.com/user-attachments/assets/557f8390-faa7-418b-a2ff-900898e2c929'  height="100" />  <!-- logoSEP -->
<img src='https://github.com/user-attachments/assets/e3f26081-87a3-4b22-8347-0abc68b2ab00'  height="100" />  <!-- logoITTazul -->
<img src='https://github.com/user-attachments/assets/c7f4b98c-6353-42c5-897d-52f96860d9d2' width="100" height="100" /><!-- logoITTverde -->

# TECNOLÓGICO NACIONAL DE MÉXICO

INSTITUTO TECNOLÓGICO DE TIJUANA  
SUBDIRECCIÓN ACADÉMICA  
DEPARTAMENTO DE SISTEMAS Y COMPUTACIÓN  
PERIODO:  Enero - Julio 2025

Ingeniería en Sistemas Computacionales  
Lenguaje de Interfaz  
**SCC-1014**  
**UNIDAD 2:**  
Programación Básica

# Introducción a los Computadores de 8 Bits y Ensamblador

**Gpo. SC06**   

**22211889** Castellon Godinez Hugo David  

**Facilitador(a):**  
Rene Solis Reyes  
**Aula: 91L6**  
**15:00 - 16:00**  
**03/03/25**  
 
</div>

## Índice
 - [Código Fuente](Codigo-Fuente)
 - [Funcionamiento Lógico](Funcionamiento-Logico)
 - [Demostración](Demostracion)

# 1. Código fuente
	
	; ===============================================
	; Multiplicación por sumas sucesivas con valores en registros A y B.
	; -----------------------------------------------
	; Troy's 8-bit computer - Emulator
	; Código realizado por Hugo David Castellon Godinez (C22211889)
	; ===============================================
	
		data Rb, 3		; ENTRADA Indica número multiplicando
		sto Rb, 0x10	; Se almacena multiplicando en memoria
		data Rb, 20		; ENTRADA Indica número multiplicador
		sto Rb, 0x11	; Se almacena multiplicador en memoria
		data Ra, 0		; Variable para guardar e imprimir sumas
		data Rc, 0		; Contador
	
	.loop:
		lod Rb, 0x10	; Se carga el número multiplicando
		add Ra			; Se suma el número
		mvd Ra			; Se imprime en pantalla decimal
		lod Rb, 0x11	; Se carga el número de veces
		inc Rc			; Se incrementa el contador
		cmp Rc			; Se compara si el contador es menor al multiplicador y se registra en N
		jn .loop		; Si es el caso, continua hasta que se iguale
	
	.end:
		mvd Ra			; Mantiene en pantalla el resultado final
		jmp .end

# 2. Funcionamiento Lógico
El objetivo del código es sumar un mismo número guardado en un espacio de memoria **`0x10`**, el número de veces indicadas en otro espacio
de memoria **`0x11`**. Ésto mediante un **`.loop`** que se rompe una vez el contador **`Rc`** haya igualado al número almacenado en el espacio
de memoria **`0x11`**. Mientras el **`.loop`** se ejecuta, los resultados de la sumatoria se almacenan en **`Ra`** que a su vez se muestran en pantalla
por cada ciclo, dando como resultado un conteo reflejados en la pantalla decimal iniciando desde el primer número guardado, aumentando en múltiplo del
mismo, y deteniendose en el resultado final de la operación gracias a el **`.end`**.

# 3. Demostración
<img src='https://github.com/user-attachments/assets/39877fdb-ef86-49b1-bf0c-03da425aff81'/>  <!-- imgEmulador -->
<img src='https://github.com/user-attachments/assets/dbbba895-7f67-437e-82f0-80f1e6709f05'/>  <!-- imgCodigo -->
