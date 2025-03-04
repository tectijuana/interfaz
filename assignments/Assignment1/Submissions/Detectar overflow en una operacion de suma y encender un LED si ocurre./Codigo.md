
## Código en Ensamblador

```assembly
# Práctica de Ensamblador: Detectar overflow en una operacion de suma y encender un LED si ocurre.

**Nombre:** Perez Garcia Cesar Michael
**Número de Control:** 22210332
---

.start:
  ; Cargar valores para la suma
  data Ra, 0x7FFF  ; Cargar un valor grande en Ra (32767 en decimal)
  data Rb, 0x0001  ; Cargar 1 en Rb

  ; Realizar la suma
  add Ra, Rb       ; Sumar Ra y Rb

  ; Verificar overflow
  jno .no_overflow ; Si no hay overflow, saltar a .no_overflow

  ; Si hay overflow, encender el LED
  out 0x01, 0xFF   ; Encender el LED (asumiendo que el LED está en el puerto 0x01)

.no_overflow:
  ; Terminar el programa o continuar con otras tareas
  halt             ; Detener la ejecución
