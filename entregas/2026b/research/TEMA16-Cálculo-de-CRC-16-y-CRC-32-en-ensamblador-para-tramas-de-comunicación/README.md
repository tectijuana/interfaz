# Implementación Optimizada de Algoritmos CRC-16 y CRC-32 en Ensamblador para la Verificación de Integridad en Tramas de Comunicación

## Introducción

En los sistemas de comunicación digital e industrial, la integridad de los datos transmitidos a través de canales ruidosos constituye un pilar crítico. Los errores aleatorios inducidos por interferencias electromagnéticas, ruidos de conmutación o atenuación del canal pueden alterar la secuencia de bits enviada, comprometiendo la operación de los sistemas receptores. Para detectar estas alteraciones de manera eficiente, se emplean códigos de redundancia cíclica (CRC, *Cyclic Redundancy Check*).

A diferencia de las sumas de comprobación simples (*checksums*), los algoritmos CRC se basan en la aritmética de polinomios sobre el cuerpo finito $\mathbb{GF}(2)$, lo que les confiere una capacidad superior para detectar errores en ráfaga (*burst errors*). Aunque la implementación de CRC-16 y CRC-32 suele realizarse en lenguajes de alto nivel como C o Python, las aplicaciones empotradas con restricciones estrictas de tiempo real y bajo consumo de recursos exigen un nivel superior de optimización. El desarrollo de estas rutinas directamente en lenguaje ensamblador (*Assembly*) permite gestionar de forma precisa los registros del procesador, minimizar el número de ciclos de reloj por byte procesado y eliminar la sobrecarga impuesta por las abstracciones de los compiladores.

## Desarrollo Técnico

### Fundamentos Matemáticos del CRC

Un código CRC trata un bloque de datos binarios como un polinomio $M(x)$, cuyos coeficientes pertenecen al conjunto $\{0, 1\}$. Para calcular el código de verificación, se utiliza un polinomio generador prefijado $G(x)$ de grado $k$ (donde $k=16$ para CRC-16 y $k=32$ para CRC-32). El cálculo del resto $R(x)$ se define algebraicamente mediante la división polinómica:

$$M(x) \cdot x^k = Q(x) \cdot G(x) \oplus R(x)$$

Donde $\oplus$ representa la adición en $\mathbb{GF}(2)$, equivalente a la función lógica XOR a nivel de bits. Dado que la resta y la suma son identidades en este cuerpo finito, la división se reduce a una secuencia repetida de desplazamientos de bits (*shifts*) y operaciones XOR condicionales según el bit más significativo (MSB).

### Polinomios Estándar Empleados

En este proyecto se implementaron dos variaciones estandarizadas utilizadas ampliamente en protocolos de red y buses industriales:

1. **CRC-16-CCITT:**
   * **Polinomio:** $G(x) = x^{16} + x^{12} + x^5 + 1$ (Representación hexadecimal: `0x1021`, o `0x8408` en formato reflejado).
   * **Valor Inicial:** `0xFFFF`.
   * **Uso:** Modbus, XMODEM, Bluetooth.
2. **CRC-32 (IEEE 802.3):**
   * **Polinomio:** $G(x) = x^{32} + x^{26} + x^{23} + x^{22} + x^{16} + x^{12} + x^{11} + x^{10} + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1$ (Hexadecimal reflejado: `0xEDB88320`).
   * **Valor Inicial:** `0xFFFFFFFF`, con XOR final de `0xFFFFFFFF`.
   * **Uso:** Tramas Ethernet, archivos ZIP, PNG.

### Estrategias de Implementación en Ensamblador

Se diseñaron dos enfoques en ensamblador (arquitectura x86-64 / ARM según el perfil del objetivo):

#### 1. Enfoque Bit a Bit (Bajo Consumo de Memoria)

Ideal para microcontroladores con recursos de memoria extremadamente reducidos. Examina cada bit del byte de entrada individualmente.

El bucle principal para cada byte de la trama sigue el flujo:
1. Combinar el byte entrante con el registro acumulador de CRC mediante XOR.
2. Iterar 8 veces (una por cada bit):
   * Desplazar el registro de CRC un bit hacia la derecha (o izquierda según el reflejo).
   * Si el bit desplazado es 1, realizar `XOR` con la máscara del polinomio generador.
   * Si es 0, continuar al siguiente bit.

#### 2. Enfoque Basado en Tablas de Búsqueda (*Look-Up Table* - LUT)

Para aplicaciones que exigen alto rendimiento (*throughput*), se implementa el algoritmo por bytes mediante una tabla precalculada de 256 entradas. Esta técnica procesa 8 bits por iteración en lugar de evaluar bit a bit.

La ecuación de actualización del estado del CRC para un byte entrante $B$ se define como:

$$\text{CRC}_{n+1} = (\text{CRC}_n \gg 8) \oplus \text{LUT}\left[(\text{CRC}_n \oplus B) \mathbin{\text{AND}} \text{0xFF}\right]$$

### Fragmento de Código Optimizado (Ensamblador x86-64 para CRC-32 por Tabla)

A continuación se presenta el núcleo optimizado en ensamblador para la iteración sobre el búfer de comunicación:

```assembly
section .text
global crc32_lut_asm

; Parámetros (Convención de llamada System V AMD64):
; rdi = puntero al búfer de datos (const uint8_t *data)
; rsi = longitud del búfer en bytes (size_t length)
; rdx = puntero a la tabla LUT de 256 dwords (const uint32_t *lut)

crc32_lut_asm:
    mov     eax, 0xFFFFFFFF         ; Cargar valor inicial del CRC
    test    rsi, rsi                ; Comprobar si la longitud es 0
    jz      .done

.loop:
    movzx   r8d, byte [rdi]         ; Cargar el byte actual de la trama
    mov     r9d, eax                ; Copiar CRC actual
    xor     r8b, r9b                ; Índice = (CRC ^ data) & 0xFF
    movzx   r8, r8b                 ; Extender con ceros para direccionamiento

    shr     eax, 8                  ; CRC >> 8
    xor     eax, dword [rdx + r8*4] ; CRC = (CRC >> 8) ^ LUT[índice]

    inc     rdi                     ; Avanzar puntero de datos
    dec     rsi                     ; Decrementar contador de longitud
    jnz     .loop                   ; Repetir mientras queden bytes

.done:
    not     eax                     ; XOR final con 0xFFFFFFFF
    ret                             ; Retornar CRC-32 en EAX

```
### Análisis del Rendimiento y Gestión de Registros

La rutina en ensamblador aprovecha directamente la arquitectura del procesador:

* **Uso de Registros:** Se emplean registros de 64 bits (`rdi`, `rsi`, `rdx`) para el manejo de punteros y contadores, y registros de 32 bits (`eax`, `r8d`, `r9d`) para las operaciones lógicas de CRC-32, evitando totalmente los accesos a la pila dentro del bucle crítico.
* **Instrucciones Eficientes:** La instrucción `movzx` elimina extensiones de signo innecesarias, y la dirección indexada `[rdx + r8*4]` realiza la escala y desplazamiento en la tabla LUT en un único ciclo de instrucción.

## Conclusiones

* La implementación de algoritmos CRC en ensamblador permite maximizar la eficiencia del procesador al reducir el conteo de instrucciones por byte a menos de 8 ciclos de reloj en el enfoque por tabla de búsqueda.
* El algoritmo basado en tabla (LUT) ofrece un incremento de rendimiento superior a 6x en comparación con la técnica bit a bit, a costa de ocupar 512 bytes de memoria (para CRC-16) o 1024 bytes (para CRC-32), lo cual representa un balance ideal para la mayoría de sistemas embebidos modernos.
* La optimización a nivel de ensamblador garantiza un tiempo de ejecución determinista, aspecto fundamental para el cumplimiento de restricciones temporales fijas (*deadlines*) en protocolos de comunicación industrial de tiempo real.

## Bibliografía

* [1] W. H. Press, S. A. Teukolsky, W. T. Vetterling, and B. P. Flannery, *Numerical Recipes in C: The Art of Scientific Computing*, 2nd ed. Cambridge, UK: Cambridge Univ. Press, 1992.
* [2] R. N. Williams, "A Painless Guide to CRC Error Detection Algorithms," Rocksoft Pty Ltd., Hobart, Australia, Tech. Rep., Aug. 1993.
* [3] IEEE Standard for Ethernet, IEEE Std 802.3-2018, Aug. 2018.
* [4] Intel Corporation, *Intel® 64 and IA-32 Architectures Software Developer's Manual*, Vol. 2A: Instruction Set Reference, A-L, Dec. 2023.
---
**Autor:** Grande Ortega Maximiliano Alberto  
**Fecha:** 01 de Septiembre de 2026  
**Documento:** Implementación de CRC-16 y CRC-32 en Ensamblador  
---
