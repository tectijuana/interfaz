# Plantilla de práctica verificable — ARM64 (AArch64)
# Uso:
#   make build   → ensambla y liga
#   make run     → ejecuta (nativo en ARM64, o vía QEMU en x86_64)
#   make test    → compara la salida con tests/expected.txt
#   make clean   → limpia binarios
#
# En una máquina ARM64 (AWS Graviton, Raspberry Pi) usa as/ld nativos.
# En x86_64 instala: binutils-aarch64-linux-gnu qemu-user

TARGET  := prog
# Funciona con la estructura del repo (src/, tests/) y con la plana de un Gist
SRC     := $(if $(wildcard src/main.s),src/main.s,main.s)
TESTS   := $(if $(wildcard tests/run_tests.sh),tests/run_tests.sh,run_tests.sh)

ARCH    := $(shell uname -m)
ifeq ($(ARCH),aarch64)
  AS   := as
  LD   := ld
  RUN  := ./$(TARGET)
else
  AS   := aarch64-linux-gnu-as
  LD   := aarch64-linux-gnu-ld
  RUN  := qemu-aarch64 ./$(TARGET)
endif

all: test

build: $(TARGET)

$(TARGET): $(SRC)
	$(AS) -o $(TARGET).o $(SRC)
	$(LD) -o $(TARGET) $(TARGET).o

run: build
	$(RUN)

test: build
	bash $(TESTS) "$(RUN)"

clean:
	rm -f $(TARGET) $(TARGET).o

.PHONY: all build run test clean
