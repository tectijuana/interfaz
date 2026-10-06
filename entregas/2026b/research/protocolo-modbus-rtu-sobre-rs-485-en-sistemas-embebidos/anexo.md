# Anexo: Bitácora de uso de IA

**Herramienta:** Claude (Anthropic), chat web.

## Prompts y resultados

| # | Prompt (resumen) | Resultado |
|---|------------------|-----------|
| 1 | Pedí ayuda para corregir mi investigación con el tema correcto (Modbus RTU sobre RS-485), con el formato de README de la rúbrica. | Propuesta de estructura y un borrador del texto, con ejemplos de tramas y CRC calculados con un script. |
| 2 | Compartí la bibliografía le pedí una revisión. | Observaciones sobre la confiabilidad de las fuentes y sugerencia de formato IEEE. |

## Reflexión

**¿Me ayudo?** Sí, sobre todo para organizar el tema, aprender como es el formato ideal para hacer un repositorio profesional y para los cálculos verificables (CRC-16 y tiempos de carácter).

**Errores detectados:** una parte de los datos de las especificaciones de Modbus salió de memoria del modelo y debe contrastarse con la fuente oficial. Uno de los sitios que consulté contradice la especificación en los bits por carácter (10 en lugar de 11), así que no lo usé como respaldo de esos datos.

**Lo que hice yo:** revisé, investigue para asegurarme, modifique algunos errores para evitar desinformación y cambié la bibliografía, corregí los datos del encabezado, armé el repositorio y el Pull Request, y ajusté el texto final.
