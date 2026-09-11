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
| `alacritty/` | `~/.config/alacritty/`                                                |
| `nvim/`      | `~/.config/nvim/`                                                     |
| `tmux/`      | `~/.config/tmux/`                                                     |
| `home/`      | `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig` (dotfiles de raiz da home) |

`attic/`, `fonts/` e `zen/` **não** são pacotes do Stow:

- `attic/` é o **sótão**: config de ferramenta que não uso mais (hoje: `sway`,
  `waybar`, `yambar`, `xremap` — ambiente tiling, inativo no GNOME/Ubuntu).
  Fica versionada sem virar symlink, preservando o estilo para uma futura troca
  de distro. Ver [STATE.md](STATE.md) para a decisão.

- `fonts/` tem um script de instalação próprio (`fonts/install-fonts.sh`).
- `zen/` guarda notas; o perfil do Zen Browser fica no Flatpak e não é
  gerenciado por symlink simples.

## Instalar em uma máquina nova

```sh
sudo apt install -y git stow
git clone git@github.com:gustavofsousa/dotfiles.git ~/projects/10_dotfiles
cd ~/projects/10_dotfiles
./bootstrap.sh            # dry-run: mostra o que faria, não muda nada
./bootstrap.sh --apply    # executa: submodules do tmux + symlinks
```

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

- [STATE.md](STATE.md) — retrato do estado atual e log de decisões.
- [TODO.md](TODO.md) — pendências do repo e da organização do computador.
- [ROADMAP.md](ROADMAP.md) — decisões atuais e direção de longo prazo.
- [docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md) — padrão
  de onde cada tipo de arquivo mora no notebook (XDG + pastas do usuário).
- [specs/](specs/) — spec por fase do roadmap, com perguntas de pesquisa e
  sugestões.
- [AGENTS.md](AGENTS.md) — regras para pessoas e IAs que mexerem neste repo.
