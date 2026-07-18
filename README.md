<img width="1587" height="201" alt="wallpaper_itt" src="https://github.com/user-attachments/assets/18c44887-beaf-40f4-b014-2696589a06d2" />


#  Lenguajes de Interfaz (Assembly Language)

Repositorio oficial del curso **Lenguajes de Interfaz**. Aquí encontrarás materiales, ejemplos y prácticas relacionadas con **programación en ensamblador** y **lenguajes de bajo nivel** para arquitecturas ARM (32/64 bits) y RISC‑V.


## 🎯 Objetivos del curso
- Comprender el funcionamiento de microprocesadores ARM y RISC‑V a nivel de registros e instrucciones.
- Aplicar convenciones de llamadas (ABI) y preservación de contexto en rutinas.
- Programar rutinas en ensamblador para operaciones aritméticas, manejo de memoria y periféricos.
- Desarrollar prácticas de laboratorio con simuladores y hardware real.


## 🗂 Estructura del repositorio
```plaintext
interfaz/
├── README.md            ← Presentación del curso
├── SYLLABUS.md / SCHEDULE.md / GRADING.md ← Programa, calendario y evaluación
├── AI_GUIDANCE.md       ← Uso responsable de IA en el curso
├── CLAUDE.md            ← Instrucciones para agentes (tutor, no solucionador)
├── CONTRIBUTING.md      ← Guía para colaborar (entrega por Pull Request)
├── docs/                ← Entorno, herramientas (gdb/GEF, tmux), recursos PDF,
│                          lecturas avanzadas (caché, virtualización, SO)
├── units/               ← Unidades U01–U04 del temario, con lecturas y sesiones
├── practicas/           ← Prácticas verificables (Makefile + make test en tu entorno)
├── templates/           ← Plantillas de práctica, rúbricas y formatos
├── herramientas/        ← Utilerías del docente (recolector de Gists para calificar)
└── entregas/            ← Entregas históricas de alumnos (referencia interna)
```


## 📘 Contenidos
- **ARMv7 y ARMv8 (32/64 bits)**: instrucciones, modos de direccionamiento, ABI.
- **RISC‑V (RV32I)**: panorama comparativo y retos opcionales (el curso se centra en ARM).
- **Convenciones**: preservación de registros, stack frames, llamadas C ↔ ASM.
- **Interrupciones y E/S mapeada**.


## 💻 Requisitos previos
- Conocimientos básicos de arquitectura de computadoras y del sistema operativo Linux Ubuntu (opcional Docker con Alpine Linux)
- Experiencia con programación básica en C y MicroPython
- Familiaridad con herramientas como `gcc`, `as`, `ld`, `qemu` o simuladores de RISC‑V.

## 🧭 ¿Qué entorno me toca?
Todas las prácticas corren en Linux ARM64; elige la ruta según tu equipo:

| Tu situación | Ruta recomendada |
|---|---|
| Cualquier laptop (opción del curso) | AWS EC2 Graviton vía [AWS Academy](./units/U00-AWSAcademy/) + [script de setup](./units/U01.1-setupCompilador/) |
| Raspberry Pi propia | [Setup nativo](./units/U01.1-setupCompilador/) directo en la Pi |
| PC x86 (Windows/Linux) sin nube | [Docker + toolchain cruzado y QEMU](./units/U01.2-Compilador-Docker-x86/) |
| Solo teléfono Android | [Termux](./units/U01.2-Compilador-AndroidTermux/) |
| Solo iPhone/iPad | [Acceso remoto por VPN](./units/U01.2-Compilador-Iphone-VPN/) |

Más detalles de entornos y herramientas en [`docs/`](./docs/).

## 💻 Materiales
- Raspberry Pico 2W (versión 2025) con cable USB–microUSB (~$8 USD): se usa en las prácticas de hardware de la Unidad 4; el grupo se organiza para la compra masiva y el descuento los beneficia a Uds.
- Cuenta en un asistente de IA: ChatGPT gratuito, o el plan con anuncios ChatGPT Go (~$8 USD/mes), u otro LLM equivalente.
- Para el proyecto final: acceso a API de LLM con saldo de ~$5 USD, o una alternativa gratuita (se avisa en clase cuando se necesite).

## 📚 Bibliografía recomendada
- ARM Architecture Reference Manual.
- Patterson & Hennessy – *Computer Organization and Design RISC‑V Edition*.
- Sloss, Symes & Wright – *ARM System Developer’s Guide*.
- Rizzi LLM Chat — asistente bot de programación con 10 libros integrados de ARM64


## 🤝 Contribuciones
Consulta la guía [CONTRIBUTING.md](./CONTRIBUTING.md) para aportar mejoras.


## 🔎 Uso responsable de IA
Este curso cuenta con la guía [AI_GUIDANCE.md](./AI_GUIDANCE.md), donde se explica cómo usar Inteligencia Artificial como apoyo didáctico sin sustituir el aprendizaje experimental ni comprometer la honestidad académica.


---


> 📣 Este curso es parte del esfuerzo por ofrecer materiales abiertos en ingeniería desde Latinoamérica. ¡Tu colaboración es bienvenida!
