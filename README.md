# dotfiles

Backup e versionamento das minhas configurações pessoais. O repo também serve
para acompanhar a organização do computador como um todo, mesmo quando algo
não vira arquivo aqui.

## Como funciona

O gerenciador atual é o **GNU Stow**. Cada pasta de configuração na raiz é um
pacote do Stow, e sua estrutura espelha o caminho final a partir de `$HOME`.

Por exemplo, `alacritty/.config/alacritty/alacritty.toml` vira o symlink
`~/.config/alacritty/alacritty.toml`.

## Pacotes

Cada pasta na raiz é um **pacote** do Stow. Dentro dela, a estrutura espelha
exatamente onde o arquivo mora a partir de `$HOME`.

Pacotes ativos (viram symlink):

| Pacote       | Vira                                                                  |
| ------------ | --------------------------------------------------------------------- |
| `alacritty/`   | `~/.config/alacritty/`                                                |
| `environment/` | `~/.config/environment.d/` (variáveis de ambiente da sessão)         |
| `nvim/`        | `~/.config/nvim/`                                                     |
| `tmux/`        | `~/.config/tmux/`                                                     |
| `vscode/`      | `~/.config/Code/User/settings.json`                                   |
| `home/`        | `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig` (dotfiles de raiz da home) |

`attic/`, `fonts/`, `icons/`, `cursors/`, `gtk-theme/`, `gnome-shell/`,
`themes/` e `zen/` **não** são pacotes do Stow:

- `attic/` é o **sótão**: config de ferramenta que não uso mais (hoje: `sway`,
  `waybar`, `yambar`, `xremap` — ambiente tiling, inativo no GNOME/Ubuntu).
  Fica versionada sem virar symlink, preservando o estilo para uma futura troca
  de distro. Ver [STATE.md](STATE.md) para a decisão.

- `fonts/` tem um script de instalação próprio (`fonts/install-fonts.sh`).
- `icons/` tem os scripts `install-icons.sh` (instala o tema Fluent
  orange/dark, clonando o upstream em build-time — não vendoriza SVG de
  terceiros) e `tag-hidden-folders.sh` (marca pastas ocultas de primeiro
  nível em cinza, pulando `.ssh`/`.gnupg`/`.pki`). Ver [STATE.md](STATE.md).
- `cursors/` tem `install-cursor.sh` (instala o cursor **Qogir**, formato
  comprido/"losango" — 1ª opção escolhida ao vivo entre Qogir/Nordzy/Bibata).
  As duas alternativas comparadas (Nordzy-cursors, Bibata-Original-Classic)
  não ficam instaladas por padrão — os comandos pra reinstalá-las estão
  comentados no fim do script.
- `themes/` guarda paletas de tema como referência pra troca futura (não é
  switcher automático — ver `themes/README.md`). Hoje: Monokai é o tema
  ativo (aplicado direto nos arquivos de cada ferramenta), Tokyo Night fica
  guardado como opção pra retomar depois.
- `gtk-theme/` tem `install-gtk-theme.sh` (instala Tokyo Night pra
  GTK3/GTK4/libadwaita + GNOME Shell, clonando o upstream em build-time —
  mesmo padrão do `icons/`). Ver [STATE.md](STATE.md).
- `gnome-shell/` guarda um snapshot **declarativo** do dconf (não é pacote
  Stow porque dconf não é arquivo symlinkável): `interface.ini`,
  `shell.ini` (extensões habilitadas + config de cada uma) e
  `wm-preferences.ini`. `dump-dconf.sh` regenera os snapshots a partir da
  máquina atual; `restore-dconf.sh` aplica numa máquina nova
  (`./bootstrap.sh --apply --with-gnome-shell-theme`). Restaura só
  *configuração* — instalar as extensões em si (apt ou
  extensions.gnome.org) continua manual, ver comentário no topo do script.
- `zen/` guarda notas (`cheatsheet.md`) e o **tema** (ZenMods): `theme/`
  (snapshot versionado de `chrome/zen-themes.css` + `chrome/zen-themes/`),
  `export-theme.sh` (copia do perfil Flatpak ativo pra cá) e
  `apply-theme.sh` (aplica numa máquina nova —
  `./bootstrap.sh --apply --with-zen-theme`). O resto do perfil (sessão,
  histórico, senhas, extensões do navegador) fica fora — é estado vivo, não
  config, e o Zen já sincroniza parte disso via login (Firefox Sync/Zen
  Account). Ver [STATE.md](STATE.md).

### Nota: `kdeglobals` não é gerenciado por symlink

Apps Qt/KDE (Dolphin, Kate, Okular...) rodando sob GNOME só respeitam
`~/.config/kdeglobals` se `QT_QPA_PLATFORMTHEME=kde` estiver setado (pacote
`environment/` cuida disso) **e** o pacote `plasma-integration` estiver
instalado (`sudo apt install plasma-integration` — fora do escopo do Stow,
precisa de senha). Sem isso, o Qt detecta o GNOME e usa o tema GTK3 por
padrão, ignorando `kdeglobals` silenciosamente — foi o que "parou pelo
caminho" na rice do Dolphin antes desta sessão.

`kdeglobals` em si **não** virou pacote do Stow: é um arquivo de estado do
KDE com muita coisa além de tema (cache, geometria, etc.), não só
configuração estável. A chave `[Icons] Theme=` é escrita pelo
`icons/install-icons.sh` via `kwriteconfig5`, não por symlink.

## Instalar em uma máquina nova

```sh
sudo apt install -y git stow
git clone git@github.com:gustavofsousa/dotfiles.git ~/projects/10_dotfiles
cd ~/projects/10_dotfiles
./bootstrap.sh            # dry-run: mostra o que faria, não muda nada
./bootstrap.sh --apply    # executa: submodules do tmux + symlinks
```

**Passo manual obrigatório pra rice do Dolphin/apps Qt/KDE fazer efeito**
(não dá pra automatizar — precisa de senha interativa, `sudo` não funciona
por script/agente):

```sh
sudo apt install -y plasma-integration
./bootstrap.sh --apply --with-icons   # aplica environment/ + tema de ícones
```

Sem o `plasma-integration`, o pacote `environment/` (variável
`QT_QPA_PLATFORMTHEME=kde`) fica sem efeito prático: o Qt continua caindo no
tema GTK3 por padrão sob GNOME, e `kdeglobals`/o tema de ícones seguem
sendo ignorados silenciosamente pelos apps Qt/KDE.

O `bootstrap.sh` é **idempotente** e roda em **dry-run por padrão** — revise a
saída e só então rode com `--apply`. Ele checa dependências, inicializa os
submodules do tmux e cria os symlinks via Stow (`alacritty home nvim tmux`),
abortando com aviso se encontrar um arquivo real onde iria um symlink. Use
`--apply --with-fonts` para instalar também as fontes (`fonts/install-fonts.sh`).

## Atualizar ou remover pacotes

Depois de adicionar ou remover arquivos, rode o Stow novamente:

```sh
cd ~/projects/10_dotfiles
stow -v -t ~ alacritty nvim tmux home
```

Para remover os symlinks de um pacote sem apagar os arquivos do repo:

```sh
stow -D -t ~ nome-do-pacote
```

## Editar uma configuração

Edite o arquivo pelo caminho real (`~/.config/sway/config`, por exemplo). Como
ele é um symlink para o repo, a mudança já aparece no `git status` de
`~/dotfiles`. Não é preciso copiar nada manualmente.

## Documentação

Cada arquivo tem um papel — a tabela em [AGENTS.md](AGENTS.md) define qual.

- [ROADMAP.md](ROADMAP.md) — **painel único**: o que falta fazer (máquina + acervo
  digital), em baldes, com os RFDs em aberto.
- [config.md](config.md) — fila do que **só eu** posso fazer (sudo, OAuth, celular).
  Item feito sai do arquivo.
- [STATE.md](STATE.md) — retrato do estado atual + decisões estruturais do repo.
- [TODO.md](TODO.md) — rascunho de pendências (o ROADMAP é a fonte da vista).
- **[docs/](docs/)** — um one-page por tema, cada um com estado atual, ferramentas
  instaladas, RFDs e decisões:
  [organizacao-de-arquivos](docs/organizacao-de-arquivos.md) (XDG + pastas de topo) ·
  [galeria](docs/galeria.md) (fotos e vídeos) · [biblioteca](docs/biblioteca.md)
  (livros/Calibre) · [backup](docs/backup.md) · [sincronizacao](docs/sincronizacao.md)
  (Syncthing/rclone) · [nas](docs/nas.md) · [nix](docs/nix.md) ·
  [notas-pkm](docs/notas-pkm.md) ·
  [vscode-multiroot-workspace](docs/vscode-multiroot-workspace.md).
- [pesquisas/](pesquisas/) — anotações externas datadas que embasaram as decisões,
  texto original preservado.
- [deposito/](deposito/) — arquivo morto datado (docs e logs que cumpriram o papel).
  Diferente de [attic/](attic/), que guarda pacote Stow de ferramenta largada.
- [AGENTS.md](AGENTS.md) — regras para pessoas e IAs que mexerem neste repo.
