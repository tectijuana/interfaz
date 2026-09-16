# Anexo — Bitácora de uso de LLM

## Herramienta utilizada
Claude (Anthropic), modelo Sonnet, a través de la interfaz web de Claude.ai.

## Prompts reales utilizados y resultados obtenidos

### Prompt 1
> "El tema #8 de la lista principal es 'Convención de llamada AAPCS64: paso
> de parámetros y valores de retorno'. Explícame en qué consiste este
> mecanismo en la arquitectura ARM64."

**Resultado:** Explicación del propósito de una convención de llamada (ABI)
para la interoperabilidad entre compiladores y lenguajes, y una introducción
a los conceptos centrales de AAPCS64: registros de argumento, valores de
retorno y preservación de registros.

### Prompt 2
> "Necesito fuentes técnicas oficiales y actualizadas sobre AAPCS64 para
> respaldar mi bibliografía en formato IEEE."

**Resultado:** Localización de la especificación oficial de ARM (repositorio
`abi-aa` en GitHub), un artículo técnico de la serie sobre AArch64 del blog
de ingeniería de Microsoft, un artículo de referencia sobre registros y
convención de llamada, y un tutorial especializado en ensamblador ARM64.

## Reflexión crítica

**¿Ayudó la IA?**
Sí, principalmente en dos aspectos: primero, para entender de forma ordenada
un tema que involucra varios conceptos entrelazados (registros de argumento,
paso por valor vs. por dirección, registro de resultado indirecto), y
segundo, para ubicar rápidamente fuentes técnicas oficiales y confiables
—como la especificación ABI de ARM— que de otra forma me hubiera tomado más
tiempo encontrar por mi cuenta.
