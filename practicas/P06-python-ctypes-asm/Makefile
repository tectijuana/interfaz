# P06 — Python + biblioteca compartida escrita en ensamblador
# NOTA: Python debe ser ARM64 nativo (AWS Graviton, Raspberry Pi, Termux,
# o contenedor: docker run --platform linux/arm64). En x86_64 sin Python
# ARM64, `make test` se marca como SKIP.

LIB := libops.so

ARCH := $(shell uname -m)
ifeq ($(ARCH),aarch64)
  AS := as
  CC := gcc
else
  AS := aarch64-linux-gnu-as
  CC := aarch64-linux-gnu-gcc
endif

all: test

ops.o: src/ops.s
	$(AS) -o $@ $<

$(LIB): ops.o
	$(CC) -shared -o $@ ops.o

build: $(LIB)

run: build
	python3 src/main.py

test: build
	bash tests/run_tests.sh

clean:
	rm -f $(LIB) ops.o

.PHONY: all build run test clean
