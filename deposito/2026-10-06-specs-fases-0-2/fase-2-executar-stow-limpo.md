# Fase 2 — Executar e deixar o Stow limpo

Ver [ROADMAP.md](../ROADMAP.md). Aplica as decisões da
[Fase 1](fase-1-decisoes-por-area.md) e fecha as pendências técnicas de
`TODO.md` (seção Repo).

## Objetivo

Repo 100% Stow, sem pendência técnica conhecida, refletindo as decisões
tomadas na Fase 1.

## Escopo

Itens já levantados em `TODO.md` (seção Repo):

- `tmux/plugins` sem `.gitmodules` (gitlinks órfãos).
- Binários vendorizados em `fonts/`.
- `nvim/init.lua_bkp` solto.
- `zen/` — decidido na Fase 1, executado aqui.
- Coexistência `waybar`/`yambar`.
- Scripts de bootstrap para máquina nova.

## Perguntas para pesquisar

1. **tmux plugins:** registrar como submodule de verdade
   (`git submodule add <url> tmux/.config/tmux/plugins/<nome>`) ou vendorizar
   como arquivo normal (sem gitlink)?
   💡 Submodule de verdade é mais correto (mantém histórico upstream,
   atualiza com `git submodule update`), mas exige lembrar de
   `--recurse-submodules` no clone. Vendorizar como arquivo normal é mais
   simples para um repo pessoal que provavelmente só você clona.

2. **Fonts:** o script `fonts/install-fonts.sh` já existe — qual fonte
   usar para download (release oficial do Nerd Fonts no GitHub, `curl`
   direto)? Qual(is) fonte(s) especificamente são usadas hoje (para não
   perder nenhuma ao trocar de vendorizado para baixado)?

3. **`nvim/init.lua_bkp`:** ainda tem algo de valor nele que não está no
   `init.lua` atual, ou é seguro apagar?

4. **Scripts de bootstrap:** um script `bash` chamando `stow` + instalando
   dependências (Stow, fontes, etc.) basta, ou vale a pena algo mais
   estruturado (ex: `Makefile`, `justfile`) dado que a Fase 3 vai substituir
   isso por Nix de qualquer forma?
   💡 Dado que Nix vem depois, provavelmente não vale investir em algo
   elaborado aqui — um script simples que documenta os passos do README já
   resolve, sem gold-plating.

## Critério de pronto

`TODO.md` (seção Repo) zerado ou só com itens conscientemente adiados
(registrados como tal), e a estrutura de pacotes do Stow refletindo as
decisões da Fase 1.
