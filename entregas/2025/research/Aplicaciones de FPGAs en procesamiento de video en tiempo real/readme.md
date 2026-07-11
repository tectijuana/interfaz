# Procesamiento de Vídeo en FPGA

En este apartado se extenderán los conceptos vistos en el Capítulo 3, correspondientes al análisis y procesamiento de imágenes y vídeo, a los sistemas basados en FPGAs, haciendo especial mención de las particularidades y diferencias que éstos tienen con respecto a los sistemas basados en procesadores o DSP. Seguidamente, se estudiarán las estructuras lógicas básicas, así como los bloques más comunes para la realización de filtros y procesamiento espacial. Finalmente, se hará una evaluación de las ventajas que poseen los sistemas de lógica programable con respecto a los demás en cuanto al procesamiento de vídeo en tiempo real.

## Introducción

Las aplicaciones que cuentan con sistemas de procesamiento de imagen son cada día más complejas, y requieren de algoritmos de cálculo cada vez más rápidos y eficientes, para hacer frente a las demandas actuales, cuyos principales objetivos son el manejo de grandes cantidades de datos y la alta velocidad de procesamiento. Esto cobra especial importancia en aquellas aplicaciones en las que las imágenes tienen que ser procesadas en tiempo real o en las que su entrada es una señal de video generada por un CCD o por una videocámara.

Encontrar una solución adecuada para la implementación de este tipo de aplicaciones resulta difícil en general, ya que el coste económico para su desarrollo y fabricación suele ser muy alto. Así mismo, las dimensiones del producto final también son una clara limitación que dificulta la implementación de estos sistemas. De este modo, las potentes soluciones que basan su funcionamiento en arquitecturas de procesadores en paralelo (como por ejemplo las redes de computadores o los clústeres de microprocesadores), están limitadas a grandes industrias, y a aplicaciones muy específicas debido a su alto coste y a sus excesivas dimensiones.

## Retos del procesamiento de imágenes en tiempo real

Hoy en día son muchos los retos que todo ingeniero en hardware debe enfrentar a la hora de realizar un sistema de visión artificial. A medida que las prestaciones de los sensores y cámaras van mejorando, tanto en resolución de imagen como en tasa de fotogramas, la complejidad computacional para procesar los datos en tiempo real va creciendo rápidamente. Cada vez son más las aplicaciones que precisan de la captura y el análisis en tiempo real de imágenes de muy altas resoluciones, y las especificaciones que imponen los nuevos sistemas en campos como la medicina, o las aplicaciones aeroespaciales son cada vez más restrictivas.

Es por ello que el diseño y la implementación de un sistema de visión en tiempo real requiere de un profundo estudio y análisis previo a su implementación, teniendo en cuenta parámetros como:

- Portabilidad y escalabilidad.
- Capacidad de adaptación a diferentes resoluciones y frame rates.
- Diferentes tipos de escaneo de la imagen, y distintos espacios de blanking.
- Diferentes tipos de codificación de vídeo.
- Diferentes tipos de espacios de color, modos de representación y relación de aspecto.
- Capacidad de ofrecer aplicaciones de alto rendimiento.
- Capacidad de ofrecer protección de la propiedad intelectual.
- Capacidad de ofrecer alta seguridad frente a ataques externos o manipulación no autorizada.

## Bibliografía

- **Formato MLA:**

  *Aguiirre Dobernack, Nicolás.* *"Capítulo 4 - Procesamiento de Vídeo en FPGA."* [Documento en PDF](https://biblus.us.es/bibing/proyectos/abreproy/12112/fichero/Documento_por_capitulos%252F4_Cap%C3%ADtulo_4.pdf).

- **Formato IEEE:**

  N. Aguiirre Dobernack, *"Capítulo 4 - Procesamiento de Vídeo en FPGA,"* [Documento en PDF], disponible en: https://biblus.us.es/bibing/proyectos/abreproy/12112/fichero/Documento_por_capitulos%252F4_Cap%C3%ADtulo_4.pdf.
