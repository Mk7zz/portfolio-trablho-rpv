#!/usr/bin/env bash
# Verifica todas as tags <link> e <img> do index.html:
#  - caminhos locais precisam existir
#  - URLs http(s) precisam responder com sucesso
set -u

ARQUIVO="index.html"
ERROS=0

# Extrai href de <link ...> e src de <img ...>
LINKS=$(grep -oE '<link[^>]*href="[^"]*"' "$ARQUIVO" | grep -oE 'href="[^"]*"' | sed 's/href="//;s/"$//')
IMGS=$(grep -oE '<img[^>]*src="[^"]*"' "$ARQUIVO" | grep -oE 'src="[^"]*"' | sed 's/src="//;s/"$//')

# Também confere os links <a href> externos (redes sociais)
ANCORAS=$(grep -oE '<a[^>]*href="[^"]*"' "$ARQUIVO" | grep -oE 'href="[^"]*"' | sed 's/href="//;s/"$//')

verificar() {
  local alvo="$1"
  if [ -z "$alvo" ]; then
    echo "::error::URL/caminho vazio encontrado"
    ERROS=$((ERROS + 1))
  elif [[ "$alvo" =~ ^https?:// ]]; then
    codigo=$(curl -s -o /dev/null -L -A "Mozilla/5.0" --max-time 20 -w "%{http_code}" "$alvo")
    # 999 = LinkedIn bloqueando bots (o link existe)
    if [[ "$codigo" =~ ^[23] || "$codigo" =~ ^(401|403|429|999)$ ]]; then
      echo "OK  [$codigo] $alvo"
    else
      echo "::error::URL inválida [$codigo]: $alvo"
      ERROS=$((ERROS + 1))
    fi
  elif [[ "$alvo" =~ ^(#|mailto:|tel:) ]]; then
    echo "OK  (ignorado) $alvo"
  elif [ -e "$alvo" ]; then
    echo "OK  (local) $alvo"
  else
    echo "::error::Caminho local não existe: $alvo"
    ERROS=$((ERROS + 1))
  fi
}

for item in $LINKS $IMGS $ANCORAS; do
  verificar "$item"
done

if [ "$ERROS" -gt 0 ]; then
  echo "Total de problemas: $ERROS"
  exit 1
fi
echo "OK: todas as URLs e caminhos são válidos."
