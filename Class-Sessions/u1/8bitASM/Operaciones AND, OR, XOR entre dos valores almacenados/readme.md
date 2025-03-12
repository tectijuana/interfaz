## Operaciones AND, OR, XOR entre dos valores almacenados (Diaz Morales Katherine Giselle 22210302)




Este programa realiza tres operaciones lógicas bit a bit (AND, OR y XOR) entre dos valores de 8 bits almacenados en memoria.  



#### Operación AND (&):
Devuelve 1 en cada posición de bit donde AMBOS bits de entrada son 1
````sql
10101010 (valor1)
11110000 (valor2)
----------
10100000 (resultado)
````

#### Operación OR (|):
Devuelve 1 en cada posición de bit donde AL MENOS UN bit de entrada es 1

````sql
10101010 (valor1)
11110000 (valor2)
----------
11111010 (resultado)
````

#### Operación XOR (^):
Devuelve 1 en cada posición de bit donde los bits de entrada son DIFERENTES
````sql
10101010 (valor1)
11110000 (valor2)
----------
01011010 (resultado)
````


![image](https://github.com/user-attachments/assets/540e08b0-c363-4802-b921-00a0d3a0e0c4)


````sql
.org 0x00       
    LDA valor1  
    STA A       
    LDA valor2  
    STA B       


AND_OP:
    LDA A       
    AND B       
    STA resultado_and  


OR_OP:
    LDA A       
    OR B        
    STA resultado_or   


XOR_OP:
    LDA A       
    XOR B       
    STA resultado_xor  


HLT

valor1:  .db 0b10101010  
valor2:  .db 0b11110000   

resultado_and: .db 0x00     
resultado_or:  .db 0x00     
resultado_xor: .db 0x00      
````

<div align="center">
<image src="https://github.com/user-attachments/assets/a2a22cf3-c572-43a9-951b-375e5cbe23d7"  width="500" height="355">
</div>


