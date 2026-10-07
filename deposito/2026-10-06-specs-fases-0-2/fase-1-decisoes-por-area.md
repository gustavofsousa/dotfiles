# Fase 1 — Decidir, área por área

Ver [ROADMAP.md](../ROADMAP.md). Aplica o padrão definido na
[Fase 0](fase-0-preparar-base.md) a cada área listada abaixo. Esta fase é só
**decisão e registro** — a execução em si (mover arquivo, criar symlink,
configurar de fato) é a [Fase 2](fase-2-executar-stow-limpo.md).

## Objetivo

Para cada área abaixo, chegar a uma decisão registrada (em `STATE.md` ou
`TODO.md`) sobre onde/como ela vive, mesmo que a decisão seja "fica como
está por enquanto".

## Escopo

Áreas conhecidas até agora. Novas áreas podem ser adicionadas conforme
surgirem.

## Perguntas para pesquisar, por área

### Zen Browser

1. O perfil Flatpak permite exportar `zen-themes.css` e
   `zen-keyboard-shortcuts.json` de forma estável (não quebra a cada
   atualização)?
2. Vale a pena manter só notas em `zen/` (estado atual) ou trazer os
   arquivos reais do perfil para o repo?
   💡 Se o Flatpak guarda o profile em `~/.var/app/...`, um symlink do Stow
   para lá é viável e resolve sem duplicar conteúdo.

### Pastas de Drive (Google Drive e afins)

1. Qual mecanismo usar no Ubuntu: GNOME Online Accounts (integração nativa)
   ou `rclone` (mais controle, mais setup)?
   💡 GNOME Online Accounts é mais simples para uso passivo (ver arquivos no
   Nautilus); `rclone` vale se precisar sincronizar pastas específicas via
   linha de comando ou script.
2. Onde a pasta sincronizada deve morar, dado o padrão XDG/organização da
   Fase 0? (`~/Drive`, dentro de `~/Documents`, etc.)

### Pendrives / mídia externa

1. Levantar o que existe hoje: quais pendrives, o que cada um guarda, se
   ainda é necessário.
2. O que sai (descartar/reformatar) e o que fica — e, para o que fica, qual
   é o propósito declarado de cada um (backup, boot, transferência)?

### Anotações

1. Obsidian, Logseq ou continuar com arquivos soltos/projetos?
   💡 Obsidian (vault em Markdown puro) tem vantagem de portabilidade — o
   vault é só uma pasta de `.md`, fácil de versionar ou não versionar por
   decisão consciente, sem lock-in de formato.
2. O vault (se houver) entra neste repo git, fica em outro repo, ou fora de
   controle de versão?

### Atalhos de teclado

1. Levantar os atalhos atuais de Zen Browser, GNOME, VS Code, terminal
   (Alacritty/tmux), Dolphin.
2. Onde há conflito entre aplicativos (mesmo atalho, ações diferentes)?
3. Depois de consolidado: registrar em um único documento de referência
   (`zen/cheatsheet.md` já existe como precedente — replicar o formato para
   as outras ferramentas?).

### Backups (Notion e outros)

1. Notion tem export nativo (Markdown/CSV/PDF) — qual formato e frequência
   fazem sentido para backup?
2. Onde os backups ficam: pasta local sincronizada, ou serviço externo?

## Critério de pronto

Cada área acima tem uma decisão registrada no `STATE.md` (se afeta estrutura
do repo/organização geral) ou vira item fechado no `TODO.md` (se é ação
pontual sem necessidade de registrar como decisão).
