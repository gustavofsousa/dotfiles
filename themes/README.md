# themes/

Paletas de tema salvas para referência e troca futura. **Não é um switcher automático.** É o valor
congelado de cada tema. Quando o Gustavo quiser trocar, ele cola o valor de volta na configuração de
cada ferramenta. A decisão e o contexto estão no [STATE.md](../STATE.md).

## Tema ativo hoje: Monokai (2026-09-15/16)

Aplicado diretamente nos arquivos reais de cada ferramenta — não tem cópia
aqui porque a fonte da verdade já é a config ativa:

| Ferramenta | Onde                                                    |
| ---------- | -------------------------------------------------------- |
| Alacritty  | `alacritty/.config/alacritty/alacritty.toml`              |
| Neovim     | `nvim/.config/nvim/lua/plugins/colorscheme.lua` (`tanvirtin/monokai.nvim`, `monokai`) |
| tmux       | `tmux/.config/tmux/.tmux.conf.local` (`tmux_conf_theme_colour_*`) |
| VS Code    | `vscode/.config/Code/User/settings.json` (`workbench.colorTheme`) |
| Dolphin/KDE| `~/.config/kdeglobals` (`ColorScheme=Monokai`, não versionado — ver README) |

## Guardado pra depois: Tokyo Night

Era o tema do Alacritty antes de virar Monokai (2026-09-15). Guardado aqui
porque o Gustavo achou bonito e pode querer voltar/comparar mais pra frente —
**não aplicado em nada agora**.

- `tokyo-night/alacritty-colors.toml` — bloco de cores original, pronto pra
  colar de volta em `alacritty/.config/alacritty/alacritty.toml` (troque só
  o bloco `[colors.*]`, mantenha `[font]`/`[window]`/`[terminal.shell]`).
- **Incompleto pra troca de sistema inteiro:** só o Alacritty tinha Tokyo
  Night configurado antes — Neovim, tmux e VS Code nunca tiveram. Se um dia
  o Gustavo decidir ativar Tokyo Night de verdade, falta escolher/instalar
  colorscheme equivalente pro Neovim (ex: `folke/tokyonight.nvim`, o mais
  usado), mapear as 17 cores do tmux, e trocar `workbench.colorTheme` do VS
  Code (existe extensão oficial `enkia.tokyo-night`, não vem embutida como o
  Monokai).

## Se um dia isso virar switcher de verdade

Hoje a troca de tema é manual: edite os arquivos citados acima. Um switcher de verdade
(`theme.sh monokai|tokyo-night`, que reescreve os 4 arquivos de uma vez) é candidato natural para a
Fase 3 do [ROADMAP.md](../ROADMAP.md) (Nix/home-manager). Lá o tema vira uma variável central, não 4
arquivos separados. Isso é mais robusto que um script bash ad-hoc.
