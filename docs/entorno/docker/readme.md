![Screenshot 2025-03-30 at 7 51 51 p m](https://github.com/user-attachments/assets/dd746913-d08b-4acb-b002-114ad08b683e)


# VIDEO ACOMPAÑAMIENTO

https://www.loom.com/share/f94fb721048b4c5ba044cd4e40004784?sid=c7548de2-5347-47ff-8b93-65a152900803

## Creación de la imagen (nota tiene un punto al final)
```bash
docker build --platform linux/arm64 -t compilador_arm64:latest .
```

## Corrida de Alphine ARM64 en docker con las herramientas comentadas en setup64.sh
```bash
docker run --platform linux/arm64 -it --rm compilador_arm64:latest
```
_Si deseas limpiar completamente tu entorno Docker (contenedores, imágenes, volúmenes y redes no usadas), ten en cuenta que estas acciones son irreversibles. Asegúrate de que no necesitas nada de lo que vas a borrar. Aquí te presento algunos comandos:_

```bash
Detén todos los contenedores en ejecución:
  docker stop $(docker ps -q)
1.Borra todos los contenedores (tanto los detenidos como los que se hayan detenido):
  docker rm $(docker ps -a -q)
3. Borrar todas las imágenes
  docker rmi $(docker images -q)
4. Borrar todos los volúmenes
  docker volume rm $(docker volume ls -q)
5. Borrar redes no usadas
   docker network prune -f
6. Usar Docker System Prune (opción más general)
Para borrar contenedores detenidos, imágenes no referenciadas y redes no utilizadas:
     docker system prune -a --volumes
```
Este último comando es muy completo, ya que con la opción -a elimina todas las imágenes no utilizadas (no solo las dangling) y con --volumes también borra los volúmenes.

---




# Visual Studio Code en Docker como TERMINAL

## ✅ Requisitos previos

- Docker ya está instalado y corriendo.
- Tienes una imagen o contenedor ya en ejecución.
- VS Code ya tiene instalada la extensión de Docker de Microsoft.

---

## 🔍 Paso a paso para ver tu contenedor en VS Code

1. Abre **Visual Studio Code**.
2. En la barra lateral izquierda, haz clic en el ícono de **Docker 🐳**.
3. En la sección **Containers**, espera a que cargue la lista de contenedores.
4. Si tu contenedor ya está en ejecución, debería aparecer ahí.

---

![Screenshot 2025-03-30 at 7 57 04 p m](https://github.com/user-attachments/assets/73b16a6a-c8d4-44fd-8a93-ba4ac99471df)

## 🔄 ¿No aparece el contenedor?

Si tu contenedor no aparece:

- Asegúrate de que está corriendo con:

  ```bash
  docker ps
  ```

- Si está corriendo pero no se ve en VS Code, presiona `F1` y ejecuta el comando:

  ```
  Docker: Refresh Explorer
  ```

- O haz clic derecho en el panel de Docker > **Refresh**.

---

## 🧠 Tip extra: Abrir una terminal dentro del contenedor

- Haz clic derecho en el contenedor > **Attach Shell** o **Inspect**.
- También puedes hacer clic en **"Open in Terminal"** si está habilitado.

---

## 🧩 ¿Quieres abrir un proyecto directamente *dentro* del contenedor?

1. Instala también la extensión: **Remote - Containers**.
2. Luego haz clic en `F1` y escribe:

   ```
   Remote-Containers: Attach to Running Container...
   ```

3. Elige tu contenedor y ¡voilà! Se abre una sesión de VS Code **dentro del contenedor**, como si fuera tu sistema operativo.

   ![Screenshot 2025-03-30 at 8 02 14 p m](https://github.com/user-attachments/assets/6d7e92e1-ea28-4047-81b3-0c040081422e)

