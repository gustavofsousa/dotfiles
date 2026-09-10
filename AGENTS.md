# AGENTS.md

Instruções pra qualquer IA (Claude Code ou outra) que for mexer neste repo.
Lido como `CLAUDE.md` via symlink.

## O que é este repo

Dotfiles pessoais do Gustavo, gerenciados com **GNU Stow** (ver `README.md`
pra estrutura, `ROADMAP.md` pra direção futura). Também é onde ele rastreia
organização do computador como um todo — nem tudo em `TODO.md` vira arquivo
neste git.

## Regras de comportamento

- **Não edite `TODO.md` de forma proativa.** Só quando ele pedir
  explicitamente ("anota isso", "bota no TODO", "atualiza o arquivo"). Em
  conversa exploratória, responda no chat — não persista sozinho.
- **Nunca apague ou sobrescreva um arquivo real (não-symlink) sem
  confirmação explícita**, mesmo que o conteúdo já tenha sido incorporado em
  outro lugar. Arquivos reais na home (ex: antes de virar pacote do Stow)
  podem ter estado que não está no git.
- **Só commite quando pedido explicitamente.** Nunca leve mudança alheia
  (ex: edição em andamento noutro arquivo) junto de um commit que não foi
  sobre ela — confira `git status` e `git diff --cached` antes.
- **Este repo é público.** Nunca commite segredo, token, ou credencial em
  texto puro. Antes de adicionar algo nesse sentido, pare e pergunte —
  segurança de segredo em repo público é decisão consciente, não default.
- Ao adicionar uma ferramenta nova, siga a convenção existente: uma pasta na
  raiz por ferramenta, conteúdo espelhando o caminho real a partir de
  `$HOME` (ex: `foo/.config/foo/...` ou, pra dotfile de raiz da home, dentro
  de `home/`).
- Documentação deste repo é em **PT-BR** — é uso pessoal, não
  open-source-facing.

## Se for propor mudança estrutural grande

(ex: migrar pra Nix, trocar ferramenta de novo, mexer em segredo) — trate
como decisão que precisa de confirmação antes de executar, não como tarefa
de rotina. Ver `ROADMAP.md` pra saber o que já está decidido vs. em aberto.
