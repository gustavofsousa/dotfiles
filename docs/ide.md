# IDE e editores — VS Code e Neovim

Onde eu escrevo código, e por que são dois. O que é config versionada aqui e o que
fica de fora.

**Relacionado:** [vscode-multiroot-workspace.md](vscode-multiroot-workspace.md)
(como o `~/projects/` é aberto) · [nix.md](nix.md) (o que isso vira declarativo).

## Por que dois editores, e quando cada um

Não é indecisão — são usos distintos:

| | VS Code | Neovim |
| --- | --- | --- |
| Usado para | trabalho do dia a dia, multi-root nos 13 projetos, IA integrada (Claude Code), debug | edição rápida no terminal, arquivo solto, commit/rebase, servidor sem GUI |
| Força | ecossistema de extensão, trabalhar em vários repos ao mesmo tempo | abre instantâneo, roda em SSH, não depende de GUI |
| Config | `settings.json` (1 arquivo) | Lua modular (`init.lua` + `lua/config/` + `lua/plugins/`) |

O Neovim **não** é projeto de "migrar do VS Code" — é a ferramenta do terminal. Os
dois convivem e isso é deliberado.

## Ferramentas no sistema

Medido em 2026-10-06.

| Ferramenta | Versão | Estado | Origem |
| --- | --- | --- | --- |
| **VS Code** | 1.136.1 | ✅ | apt (repo oficial da Microsoft) |
| **Neovim** | **v0.12.0-dev** | ✅ | apt (PPA/unstable — build de desenvolvimento) |
| **lazy.nvim** | — | ✅ | auto-instala no primeiro boot (`stdpath("data")/lazy/`) |
| `lua-language-server` | — | ✅ | brew (ver roadmap do `_hq`, `SN15`) |
| `stylua` | — | ⬜ falta | `brew install stylua` (`SN15` do `_hq`) |

> ⚠️ **Neovim é `0.12.0-dev`, não release estável.** Veio de pacote de desenvolvimento
> do apt. É o que permite usar `vim.lsp.config()` (API nova), mas significa que um
> `apt upgrade` pode trazer quebra de API. Em máquina nova, instalar a mesma linha
> `-dev` ou aceitar ajustar a config de LSP. Decisão a registrar no Nix: pinar versão
> (que é exatamente o que o Nix resolve bem).

## O que está versionado

| Pacote Stow | Conteúdo | Destino |
| --- | --- | --- |
| `nvim/` | `init.lua` + `lua/config/` (keymaps, options) + `lua/plugins/` (8 plugins) | `~/.config/nvim/` |
| `vscode/` | `settings.json` do usuário | `~/.config/Code/User/` |

**Plugins do Neovim** — um arquivo por plugin em `lua/plugins/`, gerenciados por
**lazy.nvim** (que se auto-instala, então máquina nova só precisa abrir o `nvim`):
`barbar` (abas), `cheatsheet`, `colorscheme` (Monokai), `comment`, `lazygit`, `lsp`,
`telescope` (busca), `treesitter` (sintaxe).

**LSPs configurados:** `lua_ls` e `omnisharp` — via `vim.lsp.config()`, a API nova
(migrada em `3b0d8ed`; o `vim.lsp.config` só existe em 0.11+, daí o Neovim `-dev`).

### O que fica de fora, e por quê

| O que | Por que não versionado |
| --- | --- |
| **Extensões do VS Code** | lista se exporta com `code --list-extensions`; em Nix vira declarativo (`nix-vscode-extensions`, `LT12` do `_hq`) |
| `lazy-lock.json` do Neovim | **ignorado de propósito** (`.gitignore:7`) — ver trade-off abaixo |
| `projects.code-workspace` | de propósito — dado real, repo público, regenerável ([doc](vscode-multiroot-workspace.md)) |
| Estado da UI, histórico, caches | `~/.local/state/nvim/`, `~/.config/Code/User/globalStorage/` — estado, não config |

### O trade-off do `lazy-lock.json`

Ele está no `.gitignore` desde o início, sem justificativa escrita — registro aqui os
dois lados, porque é decisão a revisitar, não esquecimento:

- **A favor de ignorar** (posição atual): o lock engessa plugin em versão antiga; sem
  ele, `nvim` sempre traz o mais recente, e eu uso só 8 plugins populares — risco baixo.
- **A favor de versionar:** é o que torna a config **reprodutível**. Sem o lock, máquina
  nova pode pegar uma versão com breaking change e eu descubro depurando o editor,
  justamente quando preciso dele pra trabalhar.

Com Neovim em `0.12.0-dev` (API em movimento), o argumento de versionar fica mais forte.
Fica como item do roadmap, não mudo unilateralmente — o `.gitignore` é escolha anterior.

## Caminhos de evolução

```
hoje      2 editores, config em Stow; extensões e lazy-lock fora do git
  ↓ decidir o trade-off acima
curto     versionar (ou confirmar que ignora) o lazy-lock.json
  ↓ junto da consolidação de atalhos (item do roadmap)
médio     keymaps do VS Code versionados (hoje só settings.json)
  ↓ Nix
futuro    nix-vscode-extensions + Neovim pinado por flake
```

## Decisões

**2026-09 — `nvim/init.lua_bkp` removido.** A config monolítica antiga já estava
superada pela modular (`config/` + `plugins/`). *Por que apagar e não arquivar:* o
histórico está no git; manter um `_bkp` ao lado do arquivo vivo é convite pra editar o
errado.

**2026-09-28 — VS Code multi-root adotado** para abrir os 13 projetos numa janela.
Detalhe e como recriar: [vscode-multiroot-workspace.md](vscode-multiroot-workspace.md).

**2026-10-06 — Dois editores é escolha, não transição.** VS Code pro trabalho com IA
e multi-repo; Neovim pro terminal e SSH. *Consequência:* a config de ambos é mantida,
e nenhuma decisão deve assumir que um vai substituir o outro.

**2026-10-06 — Neovim `0.12.0-dev` aceito com ressalva.** Necessário pra
`vim.lsp.config()`. *Risco registrado:* `apt upgrade` pode quebrar a API da config de
LSP. *Mitigação futura:* pinar via Nix.
