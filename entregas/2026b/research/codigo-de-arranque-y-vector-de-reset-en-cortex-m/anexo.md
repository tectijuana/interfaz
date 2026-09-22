# Anexo: bitácora de uso de LLM

**Alumno:** Jesus Cruz Tafoya
**No. de control:** 25210860
**Horario:** 3 pm-4 pm
**Tema:** 18. Código de arranque (startup) y vector de reset en Cortex-M
**Asistente utilizado:** Chat GPT
**Fecha:** 20 de septiembre de 2026

## Interacción 1

**Prompt:**
Le pedi que me diera links para investigar acerca de codigo de arranqye y vector de reset en cortex-m
**Resultado obtenido:**
me dio 7 u 8 links con informacion

**Reflexión crítica:**
Entre a los link ver que funcionaran y para obtener informacion sobre el tema, solo 1 link no funciono

## Interacción 2

**Prompt:**
Le pedí un codigo practico como ejemplo y que comentara lo que hace cada linea
**Resultado obtenido:**
me dio el codigo practico que se puso en la investigacion

**Reflexión crítica:**
Con arm-none-eabi-gcc y QEMU se puede probar un startup mínimo.
startup.c define la tabla de vectores y el Reset_Handler.
linker.ld describe la memoria y las secciones.
main.c contiene el programa de usuario

Al depurar con GDB se puede verificar que:
El stack pointer inicial corresponde al final de la RAM.
El Reset_Handler copia correctamente .data y limpia .bss.
Al llegar a main, las variables globales tienen los valores esperados


## Reflexión final sobre el uso de IA
La IA es una gran herramienta que te ayuda para agilizar busquedes especificas en un tema pero claro tienes 
que comprobar lo que te da ya que no es 100% exacta y tambien comete errores 
