#!/usr/bin/env bash
# Autograder mínimo: compara la salida del programa con tests/expected.txt
set -euo pipefail

RUN_CMD="${1:-./prog}"
EXPECTED_FILE="tests/expected.txt"
[ -f "$EXPECTED_FILE" ] || EXPECTED_FILE="expected.txt"   # estructura plana (Gist)

OUT="$($RUN_CMD)"
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
