# P05 — Compilación separada: C++ (.cpp → .o) + ASM (.s → .o) → linker
# En x86_64 requiere: g++-aarch64-linux-gnu qemu-user

TARGET := prog

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
macros.o: src/macros.s
	$(AS) -o $@ $<

main.o: src/main.cpp
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
	bash tests/run_tests.sh "$(RUN)"

clean:
	rm -f $(TARGET) main.o macros.o

.PHONY: all build run test clean simbolos
