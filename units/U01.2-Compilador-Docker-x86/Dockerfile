# Entorno ARM64 del curso para laptops x86_64
# Uso:
#   docker build -t interfaz-arm64 .
#   docker run --rm -it -v $PWD:/work -w /work interfaz-arm64
FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils-aarch64-linux-gnu \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    qemu-user \
    gdb-multiarch \
    make \
    python3 \
    git \
    vim \
    file \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
