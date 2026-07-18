# P06 — Python + biblioteca compartida escrita en ensamblador
# NOTA: Python debe ser ARM64 nativo (AWS Graviton, Raspberry Pi, Termux,
# o contenedor: docker run --platform linux/arm64). En x86_64 sin Python
# ARM64, `make test` se marca como SKIP.

LIB := libops.so
# Funciona con la estructura del repo (src/, tests/) y con la plana de un Gist
SRC   := $(if $(wildcard src/ops.s),src/ops.s,ops.s)
MAIN  := $(if $(wildcard src/main.py),src/main.py,main.py)
TESTS := $(if $(wildcard tests/run_tests.sh),tests/run_tests.sh,run_tests.sh)

ARCH := $(shell uname -m)
ifeq ($(ARCH),aarch64)
  AS := as
  CC := gcc
else
  AS := aarch64-linux-gnu-as
  CC := aarch64-linux-gnu-gcc
endif

all: test

ops.o: $(SRC)
	$(AS) -o $@ $<

$(LIB): ops.o
	$(CC) -shared -o $@ ops.o

build: $(LIB)

run: build
	python3 $(MAIN)

test: build
	bash $(TESTS)

clean:
	rm -f $(LIB) ops.o

.PHONY: all build run test clean
