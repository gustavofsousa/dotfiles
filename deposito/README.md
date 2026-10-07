# deposito/

Arquivo morto datado deste repo: docs que cumpriram o papel, logs de decisão
antigos, configs aposentadas. Nada aqui é carregado nem consultado no dia a dia —
existe pra que **nada morra sem rastro** e pra manter os docs vivos enxutos.

Mesma convenção do [`deposito/` do `_hq`](../../_hq/deposito/README.md).
Não confundir com [`attic/`](../attic/), que guarda **pacote Stow** de ferramenta
largada (sway, waybar, yambar, xremap) e pode voltar a ser usado numa troca de
distro. Aqui é texto que não volta.

## Convenção

- Nome: `AAAA-MM-DD-<assunto>.md` — a data é **quando saiu de circulação**, não
  quando foi escrito.
- Primeira linha: o que era, por que saiu, e **o que foi colhido antes** (pra onde
  o conteúdo útil foi).
- **Regra de ouro: nada morre sem colheita.** Antes de arquivar, o que ainda serve
  vai pro doc vivo. Se não há o que colher, o arquivo não precisava existir.

## Índice

| Arquivado | O que era | Colhido para |
| --- | --- | --- |
| [2026-10-06 — acervo-digital.md](2026-10-06-acervo-digital.md) | doc guarda-chuva de 348 linhas com livros+fotos+backup+NAS juntos | dividido em [galeria.md](../docs/galeria.md), [biblioteca.md](../docs/biblioteca.md), [backup.md](../docs/backup.md), [nas.md](../docs/nas.md) |
| [2026-10-06 — livros-calibre.md](2026-10-06-livros-calibre.md) | doc original de livros/Calibre | fundido em [biblioteca.md](../docs/biblioteca.md) |
| [2026-10-06 — STATE.md log set-out/2026](2026-10-06-state-log-setembro-outubro.md) | log cronológico de decisões que crescia sem limite (891 linhas) | decisões por tema migraram pros one-pages; STATE ficou só com estado atual |
| [2026-10-06 — syncthing.md](2026-10-06-syncthing.md) | runbook de pareamento | passos → [`config.md`](../config.md) item 1; desenho → [sincronizacao.md](../docs/sincronizacao.md) |
| [2026-10-06 — google-drive-rclone.md](2026-10-06-google-drive-rclone.md) | runbook de OAuth do rclone | passos → [`config.md`](../config.md) item 2; decisão "rclone ≠ GOA" → [sincronizacao.md](../docs/sincronizacao.md) |
| [2026-10-06 — specs das Fases 0-2](2026-10-06-specs-fases-0-2/) | perguntas de pesquisa de set/2026, **todas respondidas** | tabela pergunta→resposta→doc no [README de lá](2026-10-06-specs-fases-0-2/README.md); a Fase 3 (Nix) virou [docs/nix.md](../docs/nix.md) |
