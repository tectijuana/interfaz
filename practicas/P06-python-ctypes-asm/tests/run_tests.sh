#!/usr/bin/env bash
# Autograder P06: corre main.py contra libops.so (requiere ARM64 nativo)
set -euo pipefail

EXPECTED_FILE="tests/expected.txt"

if [ "$(uname -m)" != "aarch64" ]; then
  echo "⚠️  SKIP: esta práctica requiere Python ARM64 nativo"
  echo "   Opciones: AWS Graviton, Raspberry Pi, Termux, o"
  echo "   docker run --platform linux/arm64 ..."
  exit 0
fi

OUT="$(python3 src/main.py)"
EXP="$(cat "$EXPECTED_FILE")"

echo "Salida real:"
echo "$OUT"
echo
echo "Salida esperada:"
echo "$EXP"
echo

if [ "$OUT" = "$EXP" ]; then
  echo "✅ OK: la salida coincide"
  exit 0
else
  echo "❌ FAIL: la salida no coincide"
  exit 1
fi
