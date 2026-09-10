# Roadmap

Plano de longo prazo até chegar em Nix/home-manager. Não é um cronograma
fechado com datas — é uma sequência de fases, cada uma com um critério de
"pronto" para avançar para a próxima. Pendências técnicas específicas de cada
fase vivem no [TODO.md](TODO.md); decisões já tomadas vão para o
[STATE.md](STATE.md); as perguntas de pesquisa de cada fase (com sugestões)
estão em `specs/fase-N-*.md`.

As fases 0 e 1 podem avançar em paralelo com o dia a dia — não bloqueiam uso
normal do computador. A fase 2 é a execução das decisões da fase 1. A fase 3
só começa quando 0, 1 e 2 estiverem maduras.

## Fase 0 — Preparar a base

Spec com perguntas de pesquisa: [specs/fase-0-preparar-base.md](specs/fase-0-preparar-base.md).

Duas partes, ambas pré-requisito conceitual antes de mexer em arquivo de
verdade:

- **IA e regras do repo:** fortalecer `AGENTS.md` e as skills usadas neste
  projeto (organização de dotfiles, boas práticas), para que a IA consiga
  executar as fases seguintes — inclusive a migração para Nix — com
  qualidade e sem supervisão constante.
- **Padrão de organização de arquivos:** definir (e documentar no
  `STATE.md`) o padrão que vai guiar onde cada tipo de arquivo mora no
  notebook inteiro — não só o que está neste repo. Referência de partida:
  [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
  (`~/.config`, `~/.local/share`, `~/.cache`, etc.), adaptado ou substituído
  por algo melhor se fizer sentido no caso do Gustavo.

**Critério de pronto:** `AGENTS.md`/skills revisados e o padrão de
organização escrito e registrado no `STATE.md` — mesmo que a aplicação
completa dele só aconteça na fase 1/2.

## Fase 1 — Decidir, área por área

Spec com perguntas de pesquisa: [specs/fase-1-decisoes-por-area.md](specs/fase-1-decisoes-por-area.md).

Mapear e decidir onde cada coisa mora, aplicando o padrão definido na fase 0.
Só decisão e registro (em `STATE.md` ou `TODO.md`) — a execução em si é a
fase 2. Áreas conhecidas até agora:

- Zen Browser: perfil Flatpak, temas, atalhos — o que vira arquivo
  gerenciado e como.
- Pastas de Drive (Google Drive e afins): estrutura e ponto de montagem.
- Pendrives e mídia externa: o que continua em uso, o que é descartado.
- Anotações: Obsidian, Logseq ou outra — onde o vault mora.
- Atalhos de teclado: Zen, GNOME, VS Code, terminal, Dolphin — consolidados
  sem conflito, prontos para depois virar configuração declarativa.
- Backups (ex: Notion) e outras pendências de "Computador" no `TODO.md` que
  afetam onde arquivos/config moram.

**Critério de pronto:** cada área acima tem uma decisão registrada (mesmo
que a decisão seja "fica como está por enquanto").

## Fase 2 — Executar e deixar o Stow limpo

Spec com perguntas de pesquisa: [specs/fase-2-executar-stow-limpo.md](specs/fase-2-executar-stow-limpo.md).

Aplicar as decisões da fase 1 e fechar as pendências técnicas do repo listadas
em `TODO.md` (seção Repo): submodules do tmux, binários de fontes, arquivos
de backup soltos, pacote `zen/`, coexistência `waybar`/`yambar`, scripts de
bootstrap.

**Critério de pronto:** `TODO.md` (seção Repo) zerado ou só com itens
conscientemente adiados, e a estrutura de pacotes do Stow refletindo as
decisões da fase 1.

## Fase 3 — Migrar para Nix / home-manager

Spec com perguntas de pesquisa: [specs/fase-3-migrar-nix.md](specs/fase-3-migrar-nix.md).

Só começa quando as fases 0–2 estiverem maduras. Objetivo: aprender Nix a
fundo e tornar o sistema reproduzível a partir de uma configuração
declarativa (pacotes + configurações), não só organizar onde cada arquivo
mora.

Migração incremental — não é preciso jogar fora o que o Stow já organizou. A
estrutura por ferramenta (`sway/`, `waybar/`, etc.) e o padrão de organização
da fase 0 continuam servindo de referência durante a conversão.

### Em aberto

- Como gerenciar segredos quando forem necessários: `age` de forma
  independente ou uma solução integrada ao Nix/home-manager.

## Decisões já tomadas

Ver [STATE.md](STATE.md) para o log completo. Resumo: GNU Stow foi escolhido
em 2026-09 como gerenciador atual, priorizando durabilidade (symlink simples,
sem formato próprio) até que a migração para Nix esteja madura.
