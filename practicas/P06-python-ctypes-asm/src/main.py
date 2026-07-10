#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════════════╗
# ║  Programa : main.py (P06 — Python llama ensamblador)      ║
# ║  Autor    : <Nombre Apellido> <No. de control>             ║
# ║  Descripción: carga libops.so (escrita en ASM ARM64) con  ║
# ║  ctypes y usa sus funciones como si fueran de Python.     ║
# ╚══════════════════════════════════════════════════════════╝

import ctypes

# La biblioteca fue generada así:  as ops.s → ops.o → gcc -shared → libops.so
lib = ctypes.CDLL("./libops.so")

# Declarar tipos según el ABI de AArch64 (long = 64 bits = registro x)
for fn in (lib.suma, lib.resta, lib.mult):
    fn.argtypes = [ctypes.c_long, ctypes.c_long]
    fn.restype = ctypes.c_long

a, b = 7, 5
print(f"suma({a},{b}) = {lib.suma(a, b)}")
print(f"resta({a},{b}) = {lib.resta(a, b)}")
print(f"mult({a},{b}) = {lib.mult(a, b)}")
