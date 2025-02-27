# Codigo del problema del programa de ensendido y apagado de un led con intervalos regulares
;Simular encendido y apagado de un led con intervalos regulares.

  

.begin:

clra ; Limpia el acumulador

mov OUT, Ra ; Apaga el LED (OUT = 0)

  

.loop:

not Ra ; Invierte el estado del LED (si era 0 -> 1, si era 1 -> 0)

mov OUT, Ra ; Actualiza la salida del LED

call delay  ; Llama a la subrutina de retardo

jmp .loop ; Repite el proceso

;Subrutina para generar un retraso

delay:

mov Rb, #10 ; Configura un contador (ajusta el valor según la velocidad deseada)

.delayLoop:

dec Rb ; Decrementa el contador

jnz .delayLoop ; Si no es cero, sigue decrementando

ret ; Retorna al programa principal

# Imagenes de resultados
![imagen](https://github.com/user-attachments/assets/a776e25a-12df-4e0d-9216-12704fa1ec2d)
