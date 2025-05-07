


Cierre de Abril

Tarea 1: BlackMirror enviado por whazap

----
Actividad 6 de mayo:  

https://gist.github.com/IoTeacher/3db23ae2b492f204b7dbde1886f8224c


-----

Dia 7 de mayo

[![Need title card for new micro tutorial "Cat Napping" · Issue #4791 ...](https://tse2.mm.bing.net/th?id=OIP.Wi4Clo3YJUYODQ6P82YhVAHaEs\&pid=Api)](https://github.com/microsoft/pxt-microbit/issues/4791)


---

# 🐱 Práctica: Cat Napping con micro\:bit y MicroPython

## 🎯 Objetivo

Crear un programa en MicroPython que registre datos de temperatura y luz ambiental utilizando los sensores integrados del micro:bit. Los datos se almacenarán en la memoria interna del dispositivo y se podrán visualizar posteriormente en el archivo `MY_DATA.HTM`.

---

## 🧰 Materiales Necesarios

* micro:bit V2
* Cable USB
* Editor de MicroPython para micro\:bit: [python.microbit.org](https://python.microbit.org/)([Halvorsen Blog][1], [Adventures in Edutechnology][2])

---

## 📝 Código en MicroPython

```python
from microbit import *
import log

# Configurar etiquetas para las columnas del registro
log.set_labels("Temperatura (°C)", "Luz")

# Variable para controlar el estado de registro
registrando = False

# Función para alternar el estado de registro
def alternar_registro():
    global registrando
    registrando = not registrando
    if registrando:
        display.show(Image.TARGET)
    else:
        display.clear()

# Detectar presión del botón A para iniciar/detener registro
button_a.was_pressed()
alternar_registro()

while True:
    if button_a.was_pressed():
        alternar_registro()
    if registrando:
        temperatura = temperature()
        luz = display.read_light_level()
        log.add({"Temperatura (°C)": temperatura, "Luz": luz})
    sleep(60000)  # Esperar 60 segundos
```



---

# 📂 Visualización de Datos

1. Conecta el micro:bit a tu computadora mediante el cable USB.
2. Aparecerá una unidad llamada `MICROBIT`.
3. Abre el archivo `MY_DATA.HTM` en tu navegador web.
4. Podrás ver una tabla con los datos registrados y opciones para:

   * **Descargar** los datos en formato CSV.
   * **Copiar** los datos al portapapeles.
   * **Actualizar** los datos (requiere reconectar el micro:bit).
   * **Visualizar** los datos en forma de gráfico.

![oaicite:48](https://github.com/user-attachments/assets/1cf2ae46-1fd2-46a0-be43-77de55c7e08a)

---

## 📌 Notas Importantes

* El archivo `MY_DATA.HTM` se genera automáticamente cuando se utiliza la función de registro de datos en el micro:bit V2.
* Los datos permanecen almacenados en la memoria del micro:bit incluso si se desconecta la alimentación.
* Para borrar los datos registrados, es necesario cargar un nuevo programa en el micro:bit.([Help & Support][3], [Micro\:bit Educational Foundation][4])

---

## 🔗 Recursos Adicionales

* Tutorial original de "Cat Napping" en MakeCode: [Cat Napping - MakeCode](https://makecode.microbit.org/projects/v2-cat-napping)
* Documentación sobre registro de datos en MicroPython: [Data Logging V2 - BBC micro:bit MicroPython documentation](https://microbit-micropython.readthedocs.io/en/v2-docs/log.html)
* Guía para visualizar `MY_DATA.HTM`: [MY\_DATA.HTM : Help & Support](https://support.microbit.org/support/solutions/articles/19000127398-my-data-htm)([Microsoft MakeCode for micro\:bit][5], [MicroPython on micro\:bit][6], [Help & Support][7])

---

Esta práctica permite a los estudiantes familiarizarse con la recopilación y análisis de datos ambientales utilizando MicroPython en el micro:bit, fomentando habilidades en programación y manejo de sensores.

---

[1]: https://www.halvorsen.blog/documents/technology/iot/microbit/Microbit%20and%20Logging%20Sensor%20Data.pdf?utm_source=chatgpt.com "[PDF] micro:bit and Logging Sensor Data"
[2]: https://adventuresinedutechnology.blogspot.com/2018/11/microbit-light-sensor-instrument.html?utm_source=chatgpt.com "Adventures in Edutechnology: MicroBit Light Sensor Instrument"
[3]: https://support.microbit.org/support/solutions/folders/19000169185?utm_source=chatgpt.com "Data logging : Help & Support"
[4]: https://microbit.org/get-started/user-guide/data-logging/?utm_source=chatgpt.com "Data logging overview - BBC micro:bit"
[5]: https://makecode.microbit.org/projects/v2-cat-napping?utm_source=chatgpt.com "Cat Napping - MakeCode"
[6]: https://microbit-micropython.readthedocs.io/en/v2-docs/log.html?utm_source=chatgpt.com "Data Logging V2 - BBC micro:bit MicroPython documentation"
[7]: https://support.microbit.org/support/solutions/articles/19000127398-my-data-htm?utm_source=chatgpt.com "MY_DATA.HTM : Help & Support"

