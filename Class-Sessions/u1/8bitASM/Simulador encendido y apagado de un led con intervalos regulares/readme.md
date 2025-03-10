# Codigo del problema del programa de ensendido y apagado de un led con intervalos regulares
;Simular encendido y apagado de un led con intervalos regulares.
;Perez Villa Belen, 21212579
;03/03/25
;----------------------------------------
  

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

![imagen](https://github.com/user-attachments/assets/7dc66a34-b5ef-4ecb-8107-c2557418fcfe)







