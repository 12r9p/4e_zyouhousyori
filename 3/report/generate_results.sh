#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

clang -O2 -Wall -Wextra "$ROOT_DIR/newton1.c" -o "$ROOT_DIR/newton1" -lm
clang -O2 -Wall -Wextra "$ROOT_DIR/newton2.c" -o "$ROOT_DIR/newton2" -lm

{
  echo "eps,x0,計算回数,解,|f(x)|"
  "$ROOT_DIR/newton1" < "$SCRIPT_DIR/q1_input.csv" | tail -n +3
} > "$SCRIPT_DIR/q1.csv"

{
  echo "eps,x0,計算回数,解,|f(x)|"
  "$ROOT_DIR/newton1" < "$SCRIPT_DIR/q2_input.csv" | tail -n +3
} > "$SCRIPT_DIR/q2.csv"

{
  echo "eps,x0,計算回数,解,|f(x)|"
  "$ROOT_DIR/newton1" < "$SCRIPT_DIR/q3_input.csv" | tail -n +3
} > "$SCRIPT_DIR/q3.csv"

{
  echo "eps,x0,計算回数,解,|f(x)|"
  "$ROOT_DIR/newton2" < "$SCRIPT_DIR/q4_input.csv" | tail -n +3
} > "$SCRIPT_DIR/q4.csv"

echo "Generated:"
echo "  $ROOT_DIR/newton1"
echo "  $ROOT_DIR/newton2"
echo "  $SCRIPT_DIR/q1.csv"
echo "  $SCRIPT_DIR/q2.csv"
echo "  $SCRIPT_DIR/q3.csv"
echo "  $SCRIPT_DIR/q4.csv"
