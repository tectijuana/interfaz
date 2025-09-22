/////////////////////////////////////////////////////
Nombre del alumno: Gualberto Castro Castellanos
Numero de control: 23210564
Nombre del Profesor: Rene Solis Reyes 
/////////////////////////////////////////////////////
Tema: Diferencias entre VHDL y Verilog en el desarrollo para FPGAs
/////////////////////////////////////////////////////

#INTRODUCCION:
El diseño de circuitos digitales modernos requiere herramientas que permitan describir,
simular y optimizar el comportamiento de los sistemas antes de su implementación física.
Entre los lenguajes más utilizados en este ámbito destacan VHDL y Verilog, cada uno con 
características particulares que los convierten en pilares del diseño digital.
mientras que VHDL prioriza la rigurosidad y la independencia del fabricante,
Verilog apuesta por la flexibilidad y la eficiencia en el diseño. 

*Desarrollo Tecnico*

**VHDL: enfoque robusto para el diseño**
VHDL proporciona un entorno de simulación que refleja el comportamiento de los 
circuitos digitales sincrónicos con precisión, lo que permite a los diseñadores 
examinar y refinar sus creaciones meticulosamente antes de la implementación real.

**Verilog: adaptabilidad y revolucion**
La capacidad única de Verilog para modelar circuitos analógicos y digitales 
eleva su importancia en proyectos de diseño de señal mixta, consolidando aún más su estado
como un instrumento multifacético en la caja de herramientas de un ingeniero.

**Diferencias VDHL Y Verilog:**

VHDL es el más antiguo de los dos, y se basa en ADA y Pascal,
heredando así las características de ambos idiomas.
Verilog es relativamente reciente y sigue los métodos de codificación del lenguaje
de programación C.

Este leguaje permite una descripcion de la estructura del circuito a partir de
subcircuitos mas sencillos, y tambien permite especificar la funcionalidad de 
un circuito usando un formato similar al de los lenguajes de programacion, permitiendo
a los usuarios adaptarse mas facilmente a este tipo de lenguaje.
El VHDL es un estandar de dominio publico llamado IEEE 1076-1993. Al ser un estandar 
no depende de ningun fabricante o dispositivo, es independiente; esto tambien provoca que
se puedan reutilizar los diseños; y por ultimo, al ser un estandar tiene la ventaja
de que es un diseño jerarquico, por lo que se mantiene un orden y se siguen ciertas reglas jerarquicas.

 Verilog es sensible a los casos y no reconocería una variable si el caso utilizado 
 no es consistente con lo que era anteriormente. Por otro lado, VHDL no es sensible
 a las minas, y los usuarios pueden cambiar libremente el caso,
 siempre que los caracteres en el nombre y el pedido se mantengan igual.
 Verilog proporciona un excelente procedimiento para modelar circuitos destinados a 
 implementaciones de VLSI utilizando programas de lugar y ruta. 
 Sin embargo, tambien permite a los ingenieros optimizar los circuitos y diseños logicos
 paranmaximizar la velocidad y minimizar el area del chip VLSI. Por lo tanto, 
 conocer a Verilog hace que el diseño de VLSI y sistemas digitales sea mas eficiente.

 VHDL y Verilog sirven el mismo proposito, sin embargo su uso depende de las necesidades 
 que tengan los diseñdores dehardware en el momento de codificar sus modelos de bajo nivel.
 VHDL es un lenguaje fuertemente tipado y determinista, por eso se considera mas completo 
 en su estructura, sin embargo al no ser parecido a C, puede no ser amigable con los 
 diseñadores, por otro lado Verilog es debilmente tipado y utiliza una notacion mucho mas 
 concisa y eficiente, sin mencionar que es parecido a C, esto lo convierte en una herramienta
 mas versatil para diseñadores que no estan acostumbrados a VHDL.

 *sintaxis de VDHL*
 VHDL es fuertemente tipado, más verboso y estructurado.
Su estilo se parece al Ada/Pascal.
 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AndGate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end AndGate;

architecture Behavioral of AndGate is
begin
    Y <= A and B;
end Behavioral;

*Sintaxis de Verilog*
Verilog es menos estricto, más conciso y parecido a C.
Es más rápido de escribir pero menos rígido en tipos.

module AndGate (input A, input B, output Y);
    assign Y = A & B;
endmodule


**CONCLUSION**
Tanto VHDL como Verilog son lenguajes poderosos para el desarrollo en FPGAs,
pero la elección depende del contexto y las necesidades del proyecto.
VHDL se destaca por su robustez y formalidad, ideal en aplicaciones críticas, mientras
que Verilog sobresale por su simplicidad y rapidez, preferido en la industria comercial.

VHDL resulta mas eficiente para la maquina mientras que Verilog es mas amigable con el 
programador o disenador de hardware. Sin embargo ambos cumplen su funcion y llevan 
a cabo los mismos objetivos. 

**REFERENCIAS**
[1] “FPGA Programming Languages: Choosing Between VHDL and Verilog.” Ariat-Tech, www.ariat-tech.es/blog/fpga-programming-languages-choosing-between-vhdl-and-verilog.html
.Consultado el 18 sept. 2025.

[2] Carranza, Pablo. “Diferencia entre Verilog y VHDL.” Diffexpert, es.diffexpert.com/article/difference-between-verilog-and-vhdl. Consultado el 18 sept. 2025.

[3] ArchiG01. UIS, wiki.sc3.uis.edu.co/images/f/f5/ArchiG01.pdf. Consultado el 18 sept. 2025.

[4] Gómez, Lizzy. VHDL: Resumen. Scribd, es.scribd.com/document/324249101/VHDL. Consultado el 18 sept. 2025.
 

