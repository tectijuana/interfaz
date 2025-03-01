# 1. Código fuente
Multiplicación por sumas sucesivas con valores en registros A y B. 

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

# 2. Funcionamiento
El objetivo del código es sumar un mismo número guardado en un espacio de memoria **`0x10`**, el número de veces indicadas en otro espacio
de memoria **`0x11`**. Ésto mediante un **`.loop`** que se rompe una vez el contador **`Rc`** haya igualado al número almacenado en el espacio
de memoria **`0x11`**. Mientras el **`.loop`** se ejecuta, los resultados de la sumatoria se almacenan en **`Ra`** que a su vez se muestran en pantalla
por cada ciclo, dando como resultado un conteo reflejados en la pantalla decimal iniciando desde el primer número guardado, aumentando en múltiplo del
mismo, y deteniendose en el resultado final de la operación gracias a el **`.end`**.

# 3. Demostración
<img src='https://github.com/user-attachments/assets/39877fdb-ef86-49b1-bf0c-03da425aff81'/>  <!-- imgEmulador -->
<img src='https://github.com/user-attachments/assets/dbbba895-7f67-437e-82f0-80f1e6709f05'/>  <!-- imgCodigo -->


