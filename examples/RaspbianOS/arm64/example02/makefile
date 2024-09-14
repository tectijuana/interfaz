# Makefile para el programa ask_name en ARM64

# Variables
ASM = as
LD = ld
GDB = gdb
CFLAGS =
LDFLAGS =
TARGET = ask_name
OBJECT = ask_name.o
SOURCE = ask_name.s
BUFFER_SIZE = 100

# Repositorio GitHub (configura tu propio repositorio)
GIT_REPO = https://github.com/tu_usuario/tu_repositorio.git

.PHONY: all build run debug clean upload

# Objetivo por defecto: construir el programa
all: build

# Compilar y enlazar el programa
build: $(OBJECT)
	$(LD) -o $(TARGET) $(OBJECT)

$(OBJECT): $(SOURCE)
	$(ASM) -o $(OBJECT) $(SOURCE)

# Ejecutar el programa
run: build
	@echo "Ejecutando el programa..."
	./$(TARGET)

# Depurar el programa con GDB
debug: build
	@echo "Iniciando GDB..."
	$(GDB) ./$(TARGET)

# Limpiar archivos generados
clean:
	@echo "Limpiando archivos generados..."
	rm -f $(OBJECT) $(TARGET)

# Subir el código fuente a GitHub
upload: 
	@echo "Subiendo el código a GitHub..."
	@git add .
	@read -p "Ingrese el mensaje del commit: " msg; \
	git commit -m "$$msg"
	@git push $(GIT_REPO) main

# Información de ayuda
help:
	@echo "┳┓                     ┓     "
	@echo "┃┃┏┓┏┳┓┏┓  ╋┓┏  ┏┓┏┓┏┳┓┣┓┏┓┏┓"
	@echo "┻┛┗┻┛┗┗┗   ┗┗┻  ┛┗┗┛┛┗┗┗┛┛ ┗ "
	@echo
	@echo "Makefile para ask_name.s"
	@echo
	@echo "Uso: make [objetivo]"
	@echo
	@echo "Objetivos disponibles:"
	@echo "  all      - Construir el programa (predeterminado)"
	@echo "  build    - Ensamblar y enlazar el programa"
	@echo "  run      - Ejecutar el programa"
	@echo "  debug    - Depurar el programa con GDB"
	@echo "  clean    - Eliminar archivos generados"
	@echo "  upload   - Subir el código fuente a GitHub"
	@echo "  help     - Mostrar esta ayuda"
