#!/usr/bin/env bash
# Bloqueia qualquer arquivo individual maior que 500KB
set -u

LIMITE="500k"
GRANDES=$(find . -type f -size +"$LIMITE" \
  -not -path "./.git/*" -not -path "./node_modules/*")

if [ -n "$GRANDES" ]; then
  echo "::error::Arquivos acima de 500KB encontrados:"
  echo "$GRANDES"
  exit 1
fi
echo "OK: nenhum arquivo acima de 500KB."
