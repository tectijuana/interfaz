# Banco de Problemas — Ensamblador 8 bits y ARM64

Enunciados consolidados de los semestres 2024–2025 (deduplicados y despersonalizados).
Cada alumno recibe una variante; la evidencia de ejecución (asciinema o corrida en simulador/hardware)
es obligatoria. Formato de entrega: `templates/README-practica.md` + declaración de IA en `ANEXO.md`.

## A. Aritmética básica
1. Sumar dos números (p. ej. 3 + 5) y mostrar el resultado.
2. Restar dos números (p. ej. 9 − 4); asegurar que el resultado no sea negativo.
3. Multiplicar dos números (p. ej. 6 × 3) por sumas sucesivas, con valores en registros o en memoria.
4. Dividir 10 entre 2 usando restas sucesivas.
5. Calcular el factorial de un número (0–8) y mostrar el resultado.
6. Calcular potencias del 1 al 15.
7. Suma acumulativa / suma de una serie aritmética almacenada en memoria.
8. Calcular la media (promedio) de un conjunto de números en memoria.
9. Sumar los dígitos de un número almacenado en memoria.
10. Generar la tabla de multiplicar de un número en memoria (1–5) por sumas sucesivas.
11. Imprimir la tabla del 2 (2×1 a 2×5).

## B. Comparación y control de flujo
12. Comparar dos números e indicar si son iguales o cuál es mayor.
13. Leer tres números de memoria y determinar el mayor.
14. Detectar si un número es par o impar y mostrar mensaje.
15. Determinar si un número es negativo, cero o positivo.
16. Verificar si un número es primo (p. ej. el 7).
17. Listar los números primos entre 1 y 20 (display) o entre 1 y 100 (pantalla).
18. Contar de 0 a 9 y reiniciar en bucle.
19. Decrementar de 255 a 0 con reinicio automático y visualización en LEDs.
20. Generar la secuencia de Fibonacci hasta un límite en memoria (y en reversa).
21. Ordenar una lista de números en memoria con el algoritmo de burbuja.
22. Juego: adivinar un número almacenado en memoria.

## C. Bits y lógica
23. Operaciones AND, OR y XOR entre dos valores en registros o memoria.
24. Desplazamientos de bits a la izquierda y derecha.
25. Simular rotación de bits en un registro.
26. Detectar/verificar overflow en una suma (p. ej. 200 + 100) y mostrar alerta.
27. Invertir un número almacenado en memoria.
28. Mostrar patrón de bits alternantes (10101010 / 01010101) en LEDs en bucle.
29. Generar un número pseudoaleatorio combinando operaciones en registros.

## D. Conversión y representación
30. Convertir un número binario a decimal y mostrarlo (pantalla, LCD o 7 segmentos).
31. Convertir de decimal a binario.
32. Convertir un número en memoria de Celsius a Fahrenheit y mostrarlo.

## E. Pila, memoria y temporización
33. Simular una pila empujando y sacando 3 valores.
34. Sumar los elementos de una lista en memoria y mostrar la suma.
35. Rutina de retardo ajustable con ciclos NOP; temporizador simulado.
36. Simular encendido/apagado de un LED a intervalos regulares con retardos.
37. Comparar dos números de memoria y encender LEDs según el resultado.

## F. Salida a pantalla / display
38. Mostrar "Hello, World!" u "HOLA" en consola, LCD o display.
39. Mostrar la palabra "TEC" (completa o letra por letra).
40. Mostrar un número fijo (p. ej. el 9) en el display; hacerlo parpadear.
41. Mostrar una secuencia de 1 a 5 en display decimal.
42. Mostrar una fecha (p. ej. 16-09) en el LCD.
43. Mostrar "FIN" al terminar un ciclo.
44. Mostrar los primeros 3 múltiplos de 2.
45. Mostrar un logo tipo Commodore.

> Nota docente: los problemas A–F aplican tanto al emulador 8 bits (Troy's Breadboard Computer)
> como a ARM64 en AWS/QEMU; ajustar el dispositivo de salida según la plataforma.
