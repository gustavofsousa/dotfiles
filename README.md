# dotfiles

Backup e versionamento das minhas configurações pessoais. O repo também acompanha a organização
do computador como um todo, mesmo quando algo não vira arquivo aqui.

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

- `attic/` é o **sótão**: config de ferramenta que não uso mais. Hoje: `sway`, `waybar`, `yambar`,
  `xremap` (ambiente tiling, inativo no GNOME/Ubuntu). A config fica versionada sem virar symlink.
  Isso preserva o estilo para uma futura troca de distro. A decisão está no [STATE.md](STATE.md).
- `fonts/` tem um script de instalação próprio (`fonts/install-fonts.sh`).
- `icons/` tem dois scripts:
  - `install-icons.sh` instala o tema Fluent orange/dark. Ele clona o upstream em build-time e não
    vendoriza SVG de terceiros.
  - `tag-hidden-folders.sh` marca em cinza as pastas ocultas de primeiro nível. Ele pula
    `.ssh`/`.gnupg`/`.pki`. Detalhe no [STATE.md](STATE.md).
- `cursors/` tem `install-cursor.sh`. Ele instala o cursor **Qogir** (formato comprido, "losango"),
  a 1ª opção escolhida ao vivo entre Qogir, Nordzy e Bibata. As duas alternativas comparadas
  (Nordzy-cursors, Bibata-Original-Classic) não ficam instaladas por padrão. Os comandos para
  reinstalá-las estão comentados no fim do script.
- `themes/` guarda paletas de tema como referência para uma troca futura. Não é um switcher
  automático (`themes/README.md`). Hoje o Monokai é o tema ativo, aplicado direto nos arquivos de
  cada ferramenta. O Tokyo Night fica guardado como opção para retomar depois.
- `gtk-theme/` tem `install-gtk-theme.sh`. Ele instala o Tokyo Night para GTK3/GTK4/libadwaita +
  GNOME Shell e clona o upstream em build-time, no mesmo padrão do `icons/`. Detalhe no
  [STATE.md](STATE.md).
- `gnome-shell/` guarda um snapshot **declarativo** do dconf. Não é pacote Stow, porque o dconf não é
  um arquivo que aceita symlink. Arquivos: `interface.ini`, `shell.ini` (extensões habilitadas + a
  config de cada uma) e `wm-preferences.ini`.
  - `dump-dconf.sh` gera de novo os snapshots a partir da máquina atual.
  - `restore-dconf.sh` aplica os snapshots numa máquina nova
    (`./bootstrap.sh --apply --with-gnome-shell-theme`).
  - O restore cobre só a *configuração*. A instalação das extensões (apt ou extensions.gnome.org)
    continua manual. O comentário no topo do script explica.
- `zen/` guarda notas (`cheatsheet.md`) e o **tema** (ZenMods):
  - `theme/` é o snapshot versionado de `chrome/zen-themes.css` + `chrome/zen-themes/`.
  - `export-theme.sh` copia o tema do perfil Flatpak ativo para cá.
  - `apply-theme.sh` aplica o tema numa máquina nova (`./bootstrap.sh --apply --with-zen-theme`).
  - O resto do perfil (sessão, histórico, senhas, extensões do navegador) fica fora. É estado vivo,
    não config. O Zen já sincroniza parte disso pelo login (Firefox Sync/Zen Account). Detalhe no
    [STATE.md](STATE.md).

### O `kdeglobals` não usa symlink

NOTE: Os apps Qt/KDE (Dolphin, Kate, Okular...) sob GNOME só respeitam `~/.config/kdeglobals` com
duas condições:

- `QT_QPA_PLATFORMTHEME=kde` está definido. O pacote `environment/` cuida disso.
- O pacote `plasma-integration` está instalado (`sudo apt install plasma-integration`). Isso fica fora
  do escopo do Stow e precisa de senha.

Sem as duas, o Qt detecta o GNOME e usa o tema GTK3 por padrão. Ele ignora o `kdeglobals` em
silêncio. Foi isso que "parou pelo caminho" na rice do Dolphin.

O `kdeglobals` **não** virou pacote do Stow. É um arquivo de estado do KDE com muita coisa além do
tema (cache, geometria etc.), não só configuração estável. O `icons/install-icons.sh` escreve a chave
`[Icons] Theme=` com `kwriteconfig5`, não por symlink.

## Instalar em uma máquina nova

```sh
sudo apt install -y git stow
git clone git@github.com:gustavofsousa/dotfiles.git ~/projects/10_dotfiles
cd ~/projects/10_dotfiles
./bootstrap.sh            # dry-run: mostra o que faria, não muda nada
./bootstrap.sh --apply    # executa: submodules do tmux + symlinks
```

**Passo manual obrigatório para a rice do Dolphin e dos apps Qt/KDE fazer efeito.** Não dá para
automatizar: ele precisa de senha interativa, e o `sudo` não funciona por script nem por agente:

```sh
sudo apt install -y plasma-integration
./bootstrap.sh --apply --with-icons   # aplica environment/ + tema de ícones
```

Sem o `plasma-integration`, o pacote `environment/` (variável `QT_QPA_PLATFORMTHEME=kde`) não tem
efeito prático. O Qt continua no tema GTK3 por padrão sob GNOME. Os apps Qt/KDE continuam a ignorar o
`kdeglobals` e o tema de ícones em silêncio.

O `bootstrap.sh` é **idempotente** e roda em **dry-run por padrão**. Revise a saída antes de rodar com
`--apply`. O script faz três coisas:

1. Checa as dependências.
2. Inicializa os submodules do tmux.
3. Cria os symlinks pelo Stow (`alacritty home nvim tmux`). Se ele encontrar um arquivo real onde iria
   um symlink, ele aborta com aviso.

Para instalar também as fontes (`fonts/install-fonts.sh`), use `--apply --with-fonts`.

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

Edite o arquivo pelo caminho real (por exemplo `~/.config/nvim/init.lua`). Ele é um symlink para o
repo, então a mudança já aparece no `git status` de `~/projects/10_dotfiles`. Não é preciso copiar
nada à mão.

## Documentação

Cada arquivo tem um papel. A tabela no [AGENTS.md](AGENTS.md) define qual.

- [ROADMAP.md](ROADMAP.md) — **painel único**: o que falta fazer (máquina + acervo
  digital), em baldes, com os RFDs em aberto.
- [config.md](config.md) — fila do que **só eu** posso fazer (sudo, OAuth, celular).
  Item feito sai do arquivo.
- [STATE.md](STATE.md) — retrato do estado atual + decisões estruturais do repo.
- [TODO.md](TODO.md) — rascunho de pendências (o ROADMAP é a fonte da vista).
- **[docs/](docs/)** — um one-page por tema. Cada um tem estado atual, ferramentas instaladas, RFDs
  e decisões:
  [organizacao-de-arquivos](docs/organizacao-de-arquivos.md) (XDG + pastas de topo) ·
  [galeria](docs/galeria.md) (fotos e vídeos) · [biblioteca](docs/biblioteca.md)
  (livros/Calibre) · [backup](docs/backup.md) · [sincronizacao](docs/sincronizacao.md)
  (Syncthing/rclone) · [nas](docs/nas.md) · [nix](docs/nix.md) ·
  [edicao-video](docs/edicao-video.md) (triagem/corte) · [notas-pkm](docs/notas-pkm.md) ·
  [ide](docs/ide.md) (VS Code + Neovim) ·
  [vscode-multiroot-workspace](docs/vscode-multiroot-workspace.md).
- [pesquisas/](pesquisas/) — anotações externas datadas que embasaram as decisões, com o texto
  original preservado.
- [deposito/](deposito/) — arquivo morto datado (docs e logs que cumpriram o papel). É diferente do
  [attic/](attic/), que guarda pacote Stow de ferramenta largada.
- [AGENTS.md](AGENTS.md) — regras para pessoas e IAs que mexerem neste repo.
