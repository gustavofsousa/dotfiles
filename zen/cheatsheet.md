# Zen Browser — cheatsheet

Notas pessoais de atalhos que valem a pena lembrar. Accel = Ctrl (Linux).

## Janelas (o que puxou essa anotação)

- `Ctrl+N` — nova janela **sincronizada**: workspaces aparecem espelhadas em
  tempo real. Serve pra multi-monitor (mesma workspace em duas telas).
- `Ctrl+Shift+N` — **New Blank Window** (não sincronizada): herda
  container/cookies da Space atual, mas as tabs são temporárias — somem no
  restart a menos que eu use "Move to..." pra jogar de volta numa workspace
  permanente. Serve pra tarefa rápida/descartável que não deve sujar a
  workspace principal.

## Tabs

- `Alt+1`…`Alt+8` — pula pra tab N | `Alt+9` — última tab
- `Ctrl+Shift+T` — reabre última tab/janela fechada
- `Ctrl+Shift+K` — fecha todas as tabs não fixadas
- `Ctrl+Shift+D` — fixa/desfixa tab

## Workspaces

- `Ctrl+Alt+→` / `Ctrl+Alt+←` — cicla entre workspaces
- Pular direto pra workspace N **não vem com atalho por padrão** — se um dia
  eu tiver 3+ workspaces, bindar em Settings → Shortcuts
  ("Switch to Workspace N") em algo tipo `Ctrl+1`, `Ctrl+2`...

## Split view

- `Ctrl+Alt+V` — split vertical | `Ctrl+Alt+H` — horizontal
- `Ctrl+Alt+G` — grid | `Ctrl+Alt+U` — desfaz split

## Compact mode

- `Ctrl+S` — liga/desliga | `Ctrl+Alt+S` — mostra sidebar temporariamente

## Outros

- `Ctrl+Shift+C` — copia URL | `Ctrl+Alt+Shift+C` — copia URL em markdown
- `Ctrl+O` — expande um "Glance" (preview de link) pra tab completa
- `Ctrl+Shift+S` — screenshot | `Ctrl+Shift+P` — aba privada

## Vimium

Sem modo vim nativo no Zen. Instalado via Firefox Add-ons, zero config.

- `j`/`k` scroll | `d`/`u` meia página | `gg`/`G` topo/fim
- `f` — hints de link (clica sem mouse) | `F` — igual, mas nova tab
- `H`/`L` — voltar/avançar histórico | `/` busca na página, `n`/`N` navega resultados
- `o` — omnibar | `yy` — copia URL atual
- Só ativa com foco na página — não conflita com os atalhos `Ctrl+...` do Zen.
