# P05 — Compilación separada: C++ (.cpp → .o) + ASM (.s → .o) → linker
# En x86_64 requiere: g++-aarch64-linux-gnu qemu-user

TARGET := prog
# Funciona con la estructura del repo (src/, tests/) y con la plana de un Gist
SRC_S   := $(if $(wildcard src/macros.s),src/macros.s,macros.s)
SRC_CPP := $(if $(wildcard src/main.cpp),src/main.cpp,main.cpp)
TESTS   := $(if $(wildcard tests/run_tests.sh),tests/run_tests.sh,run_tests.sh)

ARCH := $(shell uname -m)
ifeq ($(ARCH),aarch64)
  AS   := as
  CXX  := g++
  NM   := nm
  RUN  := ./$(TARGET)
else
  AS   := aarch64-linux-gnu-as
  CXX  := aarch64-linux-gnu-g++
  NM   := aarch64-linux-gnu-nm
  RUN  := qemu-aarch64 -L /usr/aarch64-linux-gnu ./$(TARGET)
endif

all: test

# Cada mundo produce su objeto por separado…
macros.o: $(SRC_S)
	$(AS) -o $@ $<

main.o: $(SRC_CPP)
	$(CXX) -c -o $@ $<

# …y el linker (via g++) los une en un ejecutable
$(TARGET): main.o macros.o
	$(CXX) -o $@ main.o macros.o

build: $(TARGET)

# Inspección didáctica: ¿qué símbolos hay en cada objeto?
simbolos: main.o macros.o
	@echo "--- macros.o (T = definido aquí) ---"
	@$(NM) macros.o
	@echo "--- main.o (U = indefinido, lo resuelve el linker) ---"
	@$(NM) main.o | grep -E "suma|resta|mult" || true

run: build
	$(RUN)

test: build
	bash $(TESTS) "$(RUN)"

clean:
	rm -f $(TARGET) main.o macros.o

.PHONY: all build run test clean simbolos
