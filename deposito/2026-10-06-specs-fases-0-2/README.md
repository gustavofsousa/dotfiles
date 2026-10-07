> **Arquivado 2026-10-06.** Specs das Fases 0, 1 e 2 — escritas em setembro/2026
> como **perguntas de pesquisa** pra IA responder antes de mexer em arquivo de
> verdade. Saíram de circulação porque **todas as perguntas foram respondidas e as
> três fases estão concluídas**; o que restava era um formulário preenchido.

# Specs das Fases 0–2 (set/2026)

## Onde cada resposta foi colhida

| Pergunta da spec | Resposta | Onde vive hoje |
| --- | --- | --- |
| Fase 0 — padrão de organização: XDG estrito ou variação? | **XDG integral** + Camada 2 de pastas de usuário em inglês | [`docs/organizacao-de-arquivos.md`](../../docs/organizacao-de-arquivos.md) |
| Fase 0 — o que fica fora do XDG (docs, mídia, projetos)? | `~/Documents`, `~/Pictures`, `~/Projects`; `~/Archive` criado e depois **eliminado** (2026-09-16); `~/Backups` é o tier de backup | mesma doc, Camada 2 |
| Fase 0 — como registrar o padrão? | doc própria em `docs/` **+** skill `arruma-meu-not-ai` aplicando | doc + skill no `_hq` |
| Fase 0 — lacunas do `AGENTS.md`? | revisado; regra de confirmar antes de mover/apagar arquivo real | [`AGENTS.md`](../../AGENTS.md) |
| Fase 1 — Zen: notas ou arquivos reais? | **guarda o tema (ZenMods)**; sessão/senha fica no Zen Account | `zen/` + log de decisões |
| Fase 1 — Drive: GOA ou rclone? | **rclone** (GOA não agenda nem roda sem sessão gráfica) | [`docs/sincronizacao.md`](../../docs/sincronizacao.md) |
| Fase 1 — anotações: Obsidian ou Logseq? | **os dois** sob `~/Documents/notas-pkm/` | [`docs/notas-pkm.md`](../../docs/notas-pkm.md) |
| Fase 1 — pendrives | **ainda aberto** | item no [`ROADMAP.md`](../../ROADMAP.md) |
| Fase 2 — tmux plugins: submodule ou vendorizar? | **submodule de verdade** (`.gitmodules` recriado) | `.gitmodules` + log |
| Fase 2 — fonts: qual fonte de download? | releases oficiais, pinado em `v3.5.1`; 232 MB de `.ttf` saíram do git | `fonts/install-fonts.sh` |
| Fase 2 — `init.lua_bkp` tem valor? | não — **apagado**, histórico no git | log de decisões |
| Fase 2 — bootstrap: script ou Makefile? | **script bash simples**, idempotente, dry-run por padrão (sem gold-plating, já que Nix vem depois) | [`bootstrap.sh`](../../bootstrap.sh) |

## Por que o formato não sobreviveu

A spec-por-fase funcionou pro que foi feita: **forçar pesquisa antes de executar**.
O que não se sustentou foi mantê-la depois — virou um lugar a mais onde a mesma
decisão morava, competindo com o `STATE.md` e com os docs de tema. A Fase 3 (Nix),
que ainda tem perguntas abertas de verdade, foi **promovida a one-page**
([`docs/nix.md`](../../docs/nix.md)) em vez de continuar como spec.
