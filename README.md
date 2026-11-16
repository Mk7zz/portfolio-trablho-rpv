[![CD - Deploy no GitHub Pages](https://github.com/SEU_USUARIO/SEU_REPOSITORIO/actions/workflows/deploy.yml/badge.svg)](https://github.com/SEU_USUARIO/SEU_REPOSITORIO/actions/workflows/deploy.yml)
[![CI - Validação do Pull Request](https://github.com/SEU_USUARIO/SEU_REPOSITORIO/actions/workflows/ci.yml/badge.svg)](https://github.com/SEU_USUARIO/SEU_REPOSITORIO/actions/workflows/ci.yml)

# Portfólio Profissional

Site de portfólio (HTML + CSS) publicado automaticamente no GitHub Pages por uma esteira CI/CD no GitHub Actions.

**Site publicado:** https://SEU_USUARIO.github.io/SEU_REPOSITORIO/

## Estrutura

```
.
├── index.html
├── style.css
├── images/
├── scripts/                 # validações usadas pelo CI
├── package.json             # html-validate (linter)
├── .htmlvalidate.json
└── .github/workflows/
    ├── ci.yml               # valida Pull Requests para a main
    └── deploy.yml           # publica no GitHub Pages ao dar push na main
```

## Pipeline

**CI (`ci.yml`)** - dispara em Pull Request para a `main`:
1. Verifica se `index.html` existe na raiz (falha imediatamente se não existir)
2. Linter de HTML (html-validate), em Node 18 e Node 20 (matrix)
3. Bloqueia arquivos acima de 500KB (`find`)
4. Bloqueia TODO, FIXME, senha e password
5. Verifica URLs e caminhos das tags `link`, `img` e `a`

**CD (`deploy.yml`)** - dispara em push na `main` e publica no GitHub Pages. Se falhar, envia aviso ao Discord (secret `DISCORD_WEBHOOK`).
# portfolio-trablho-rpv
