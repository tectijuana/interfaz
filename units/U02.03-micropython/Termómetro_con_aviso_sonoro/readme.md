//La micro:bit mostrará la temperatura actual.
// Jonathan Bedoy Alvarez 21211917
//10/16/2025
import time

temp = 28  # temperatura simulada

while True:
    print(str(temp) + "C")
    if temp > 25:
        print("Temperatura alta!")
    else:
        print("Temperatura normal.")
    time.sleep(2)

<img width="1787" height="446" alt="image" src="https://github.com/user-attachments/assets/6e2d788e-27f7-435b-a8e8-51a97001818f" />
