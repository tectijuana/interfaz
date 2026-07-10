#!/usr/bin/env bash
# Autograder P03: alimenta stdin desde tests/input.txt y compara la salida
set -euo pipefail

RUN_CMD="${1:-./prog}"
EXPECTED_FILE="tests/expected.txt"
INPUT_FILE="tests/input.txt"

OUT="$($RUN_CMD < "$INPUT_FILE")"
EXP="$(cat "$EXPECTED_FILE")"

echo "Entrada:"
cat "$INPUT_FILE"
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
