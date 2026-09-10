# dotfiles

Backup e versionamento das minhas configurações pessoais. O repo também serve
para acompanhar a organização do computador como um todo, mesmo quando algo
não vira arquivo aqui.

## Como funciona

O gerenciador atual é o **GNU Stow**. Cada pasta de configuração na raiz é um
pacote do Stow, e sua estrutura espelha o caminho final a partir de `$HOME`.

Por exemplo, `sway/.config/sway/config` vira o symlink
`~/.config/sway/config`.

## Pacotes

Cada pasta na raiz é um **pacote** do Stow. Dentro dela, a estrutura espelha
exatamente onde o arquivo mora a partir de `$HOME` — por exemplo,
`sway/.config/sway/config` vira o symlink `~/.config/sway/config`.

Pacotes existentes:

| Pacote       | Vira                                                                  |
| ------------ | --------------------------------------------------------------------- |
| `sway/`      | `~/.config/sway/`                                                     |
| `waybar/`    | `~/.config/waybar/`                                                   |
| `alacritty/` | `~/.config/alacritty/`                                                |
| `nvim/`      | `~/.config/nvim/`                                                     |
| `xremap/`    | `~/.config/xremap/`                                                   |
| `yambar/`    | `~/.config/yambar/`                                                   |
| `tmux/`      | `~/.config/tmux/`                                                     |
| `home/`      | `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig` (dotfiles de raiz da home) |

`fonts/` e `zen/` não são pacotes do Stow:

- `fonts/` tem um script de instalação próprio (`fonts/install-fonts.sh`).
- `zen/` guarda notas; o perfil do Zen Browser fica no Flatpak e não é
  gerenciado por symlink simples.

## Instalar em uma máquina nova

```sh
sudo apt install -y stow
git clone git@github.com:gustavofsousa/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -v -t ~ sway waybar alacritty nvim xremap yambar tmux home
bash fonts/install-fonts.sh
```

## Atualizar ou remover pacotes

Depois de adicionar ou remover arquivos, rode o Stow novamente:

```sh
cd ~/dotfiles
stow -v -t ~ sway waybar alacritty nvim xremap yambar tmux home
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
