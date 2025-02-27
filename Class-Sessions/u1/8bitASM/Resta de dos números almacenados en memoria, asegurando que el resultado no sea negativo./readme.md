    ; Definición de las variables en memoria
    Num1 = 0x50
    Num2 = 0x51
    RESULTADO = 0x52

    ; Se inicia el programa en la dirección 0x00
    #addr 0x00
        mva #44          ; Asignar 44 a Ra
        sto Ra, Num1     ; Almacenar Ra en la dirección Num1
        mvb #24          ; Asignar 24 a Rb
        sto Rb, Num2     ; Almacenar Rb en la dirección Num2

        lod Ra, Num1     ; Cargar el valor de Num1 en Ra
        lod Rb, Num2     ; Cargar el valor de Num2 en Rb

        cmp Ra, Rb       ; Comparar Ra con Rb

        jn .resultado_cero ; Saltar si Ra < Rb (resultado negativo)

        sub Ra           ; Restar Rb de Ra (Ra = Ra - Rb)
        jmp .guardar_resultado

    .resultado_cero:
        clr Ra           ; Limpiar Ra (poner a 0)

    .guardar_resultado:
        sto Ra, RESULTADO ; Almacenar el resultado

        mov Rd, Ra       ; Mostrar resultado en la pantalla decimal

        nop              ;
    .fin:
        jmp .fin         ; Bucle infinito para "detener" el programa

## Explicacion del la lógica
1. Inicialización
   - Se asignan los valores 44 y 24 a las direcciones de memoria Num1 y Num2, respectivamente.
2. Carga y comparación
   - Se cargan Num1 y Num2 en los registros Ra y Rb.
   - Se comparan ambos valores.
4. Operacion matemática
   - Si Ra es menor que Rb, se establece Ra = 0.
   - De lo contrario, se resta Rb de Ra.
6. Almacenamiento y salida
   - Se guarda el resultado en RESULTADO.
   - Se muestra el resultado en la pantalla decimal.
8. Finalización
   - Se entra en un bucle infinito para detener el programa.

## Evidencia
![image](https://github.com/user-attachments/assets/b890cd9a-4669-4cbb-b64e-460c692e8b77)
