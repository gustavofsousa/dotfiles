# dotfiles

Backup e versionamento das minhas configs pessoais — não só do que roda no
terminal, mas de como organizo o computador como um todo.

## Ferramenta atual: GNU Stow

Cada pasta na raiz é um **pacote** do Stow. Dentro dela, a estrutura espelha
exatamente onde o arquivo mora a partir de `$HOME` — por exemplo,
`sway/.config/sway/config` vira o symlink `~/.config/sway/config`.

Pacotes existentes:

| Pacote | Vira |
|---|---|
| `sway/` | `~/.config/sway/` |
| `waybar/` | `~/.config/waybar/` |
| `alacritty/` | `~/.config/alacritty/` |
| `nvim/` | `~/.config/nvim/` |
| `xremap/` | `~/.config/xremap/` |
| `yambar/` | `~/.config/yambar/` |
| `tmux/` | `~/.config/tmux/` |
| `home/` | `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig` (dotfiles de raiz da home) |

`fonts/` e `zen/` **não** são pacotes do Stow — `fonts/` tem um script de
instalação próprio (`fonts/install-fonts.sh`), e `zen/` por enquanto só guarda
notas (Zen Browser roda de um profile Flatpak, fora do alcance de symlink
simples).

## Bootstrap numa máquina nova

```sh
sudo apt install -y stow
git clone git@github.com:gustavofsousa/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -v -t ~ sway waybar alacritty nvim xremap yambar tmux home
bash fonts/install-fonts.sh
```

## Editar uma config

Edita o arquivo direto pelo caminho real (`~/.config/sway/config`, por
exemplo) — como é symlink pro repo, a mudança já está no `git status` do
`~/dotfiles`. Não precisa copiar nada manualmente.

## Outros documentos deste repo

- [`TODO.md`](TODO.md) — tarefas pendentes, técnicas e pessoais.
- [`ROADMAP.md`](ROADMAP.md) — direção de longo prazo (Stow → Nix).
- [`AGENTS.md`](AGENTS.md) — regras pra qualquer IA (inclusive eu) que mexer
  neste repo.
