# Makefile para el programa hello_world en ARM64

# Variables
ASM = as
LD = ld
GDB = gdb
TARGET = hello_world
OBJECT = hello_world.o
SOURCE = hello_world.s

# Repositorio GitHub (configura tu propio repositorio)
GIT_REPO = https://github.com/tu_usuario/tu_repositorio.git

.PHONY: all build run debug clean upload help

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
	@echo
	@echo "Makefile para hello_world.s"
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
