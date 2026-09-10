# TODO

## Contexto (pra retomar rápido — inclusive por IA)

- O que é: backup/versionamento das minhas configs pessoais (dotfiles).
- Repo: `github.com/gustavofsousa/dotfiles`, branch `master`, **público**.
- Convenção: uma pasta por ferramenta na raiz (`sway/`, `tmux/`, `nvim/`,
  `alacritty/`, `waybar/`, `xremap/`, `yambar/`, `zen/`, `fonts/`).
- Ainda não tem symlink automatizado nem gerenciador (chezmoi, stow) — hoje é
  espelho manual: edito o arquivo real no sistema e copio pra cá.
- Sem README ainda.

## Pendências detectadas automaticamente

Escaneei o repo em 2026-09-09. Validar e marcar o que já foi resolvido.

- [ ] **`tmux/plugins` sem `.gitmodules`** — `tpm`, `tmux-resurrect` e
      `tmux-sensible` estão registrados como gitlink (modo `160000`,
      submodule) mas não existe `.gitmodules` no repo. Um clone novo vai
      deixar essas 3 pastas **vazias**. Resolver com
      `git submodule add <url> tmux/plugins/<nome>` pra cada um (ou virar
      arquivo normal se não quiser usar submodule de verdade).
- [ ] **`fonts/` vendorizado como binário (232MB) num repo público** — puxa
      o `.git` pra 139MB. `fonts/install-fonts.sh` já existe e só copia os
      `.ttf` commitados; dá pra trocar por download direto (release do Nerd
      Fonts) e tirar os binários do HEAD.
- [ ] **Sem `README.md`** — repo público sem explicar o que é / como fazer
      bootstrap numa máquina nova.
- [ ] **`nvim/init.lua_bkp`** — arquivo de backup solto, decidir se apaga.
- [ ] **`zen/`** — só tem `cheatsheet.md` por enquanto. Falta decidir se vale
      trazer os arquivos reais (`zen-themes.css`, `zen-keyboard-shortcuts.json`
      do perfil Flatpak) ou deixar só como notas.

## Working tree — mudanças pendentes (ainda não commitadas)

- [ ] `alacritty/alacritty.toml` — staged
- [ ] `sway/config.d/50-statusbar.conf`, `sway/config.d/60-modes.conf` — modificado
- [ ] `waybar/config` — modificado
- [ ] `zshrc` — modificado
- [ ] `sway/config.d/05-autostart.conf` — novo, não commitado
- [ ] `waybar/style.css` — novo, não commitado
- [ ] `yambar/` (`config.yml`) — pasta inteira nova, não commitada

## Minhas pendências

Ordem não é sequencial — pode pular entre itens.

- [ ] Revisar o que já existe no repo, pasta por pasta, pra decidir o que
      permanece e o que sai (usar as pendências detectadas acima como ponto
      de partida).
- [ ] Fazer os scripts de criação/instalação — deixar tudo pronto pra rodar
      numa máquina nova do zero (bootstrap: symlinks + instalação de deps).
- [ ] Configurar/trazer as infos do Zen Browser pro repo (perfil Flatpak:
      `zen-themes.css`, `zen-keyboard-shortcuts.json` etc. — ver `zen/`).
- [ ] Decidir os melhores atalhos de teclado, sem conflito, considerando o
      conjunto todo: Zen Browser, Ubuntu GNOME, workspaces do GNOME, VSCode,
      terminal, Dolphin e outros apps do dia a dia.

## Ideias / não urgente

- [ ] Migrar pra um gerenciador de dotfiles (chezmoi) em vez de espelho manual
