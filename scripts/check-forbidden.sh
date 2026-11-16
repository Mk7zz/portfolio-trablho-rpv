#!/usr/bin/env bash
# Impede que TODO, FIXME, senha e password cheguem à produção
set -u

TERMOS='TODO|FIXME|senha|password'

# Só varre os arquivos do site (não os scripts e workflows, que citam os termos)
ACHADOS=$(grep -rniE "$TERMOS" \
  --include="*.html" --include="*.css" --include="*.svg" --include="*.js" \
  --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=scripts --exclude-dir=.github \
  . || true)

if [ -n "$ACHADOS" ]; then
  echo "::error::Termos proibidos encontrados:"
  echo "$ACHADOS"
  exit 1
fi
echo "OK: nenhum termo proibido encontrado."
