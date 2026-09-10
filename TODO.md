# TODO

Este arquivo reúne pendências do repo e da organização do computador. Nem toda
tarefa vira um arquivo commitado. Ver [ROADMAP.md](ROADMAP.md) para como
essas pendências se encaixam no plano até Nix (fases 0–3).

## Repo

> Maioria destes itens é fechamento da **Fase 2** do ROADMAP (deixar o Stow
> limpo).

- [ ] Corrigir `tmux/plugins`: os três diretórios parecem submodules, mas não
      existe `.gitmodules`. Escolher entre registrar os submodules corretamente ou
      transformar o conteúdo em arquivos normais.
- [ ] Reduzir os binários vendorizados em `fonts/` e fazer o script baixar uma
      versão do Nerd Fonts quando necessário.
- [ ] Revisar `nvim/init.lua_bkp` e decidir se o backup deve continuar no repo.
- [ ] Decidir se o `zen/` continuará apenas com notas ou também guardará os
      arquivos exportáveis do perfil Flatpak.
- [ ] Criar scripts de bootstrap para symlinks e dependências de uma máquina
      nova.
- [ ] Decidir entre `waybar` e `yambar` (hoje coexistem; `yambar/` tem só um
      config mínimo/placeholder) — ou documentar por que os dois ficam. No GNOME
      Ubuntu ambos estão inativos: candidatos ao sótão (`attic/`, ver
      `docs/organizacao-de-arquivos.md`).
- [ ] Mover pacotes de config largados (Sway/waybar/yambar, inativos no GNOME)
      pra `attic/` — arquivar sem perder, conforme padrão do sótão.

## Computador

> Estes itens envolvem decisão de onde arquivos moram — parte da **Fase 1**
> do ROADMAP (decidir área por área, aplicando o padrão da Fase 0).

- [ ] Revisar os atalhos de teclado do Zen Browser, GNOME, VS Code, terminal,
      Dolphin e outros aplicativos usados no dia a dia.
- [ ] Configurar o Syncthing para sincronizar a pasta de livros.
- [ ] Ajustar os backups do Notion.
- [ ] Configurar o Google Drive para uso pelo Ubuntu, via GNOME Online Accounts
      ou `rclone`.
- [ ] Organizar as anotações e decidir entre Obsidian, Logseq e projetos.
- [ ] Decidir o que fica e o que sai de pendrives/mídia externa em uso.

## Ideias

Ainda não há ideias separadas das pendências acima.

> Para ver mudanças locais que ainda não foram commitadas, use `git status`.
