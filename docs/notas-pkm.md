# Notas / PKM — como está montado

Onde as anotações pessoais (PKM — *personal knowledge management*) moram.
Decisão da **Fase 1** do roadmap. Nome de pasta em PT-BR por escolha consciente
— ver a divergência registrada no [STATE.md](../STATE.md).

## Estrutura no disco

```
~/Documents/notas-pkm/     ← guarda-chuva único de PKM (é o vault do Obsidian)
└── logseq/                ← grafo original do Logseq (journals/pages/whiteboards)
```

- **`notas-pkm/`** é o guarda-chuva. Um único vault do Obsidian aberto nesta
  pasta enxerga tudo abaixo — inclusive o conteúdo do Logseq.
- **`logseq/`** é o grafo que já existia (33 pages, notas de leitura de 2025,
  journals). Movido de `~/Documents/Logseq` em 2026-09-11.

## Por que os dois no mesmo guarda-chuva (Logseq + Obsidian)

Logseq e Obsidian são **ambos markdown puro**. As pages do Logseq não usam
sintaxe pesada (0 arquivos com block-refs `((…))` ou props `key::`), então o
Obsidian lê os mesmos `.md` sem conversão nem duplicação. Um vault Obsidian
apontado pra `notas-pkm/` dá grafo + busca + leitura sobre o conteúdo que já
existe, sem mudar como o Logseq escreve.

**Decisão:** experimentar o Obsidian como janela principal, mantendo o grafo
Logseq acessível no mesmo lugar. Não é "migrar e abandonar" — é unificar o
local. O conteúdo é compartilhado; não há cópia divergente a manter em sincronia.

Alinhado com o estudo `UVW-pkm-notion-logseq-obsidian.md` (em
`~/projects/_hq/biblioteca/roadmaps/`): Obsidian como *leitor* de markdown, não
como formato-fim; a exploração de **IA sobre as notas** é o experimento aberto
(o que funciona melhor pra IA ainda é `[explorar]`).

## Reapontar o Logseq (se ele não achar o grafo)

O Logseq (Snap) guarda o índice do grafo em
`~/snap/logseq/current/.logseq/graphs/` num arquivo `.transit` cujo **nome
codifica o path** do grafo. Ao mover a pasta, o `.transit` foi renomeado de
`…++Documents++Logseq.transit` para `…++Documents++notas-pkm++logseq.transit`.
Se o Logseq ainda não reconhecer, é só reabrir a pasta `~/Documents/notas-pkm/logseq`
pela GUI — o `.transit` é índice regenerável, os `.md` são o dado real e estão
intactos.

## Configurar o vault do Obsidian

O Obsidian é Flatpak (`md.obsidian.Obsidian`). Ao abrir, escolha "Open folder
as vault" e aponte para `~/Documents/notas-pkm/`. O vault vazio de teste antigo
(`obsidian-notes`, só com `Welcome.md`) foi apagado em 2026-09-16 (junto da
eliminação do `~/Archive` — era só um vault de teste vazio, sem dado real).

## Faxina pendente

Duplicatas conhecidas dentro de `logseq/pages/` (mesmo livro, nomes variantes):
- "Em Busca de Sentido" × 2
- "Consecration to St. Joseph" × 3
- "Conquista das Virtudes" × 2 (grafia diferente)

Notas soltas em `~/Documents/` que poderiam entrar no PKM:
`Context.Engineering.md`, `.calnotes/`, `pesquisas_perplexity/`,
`clip_kindle (Copy).txt`. Triagem pendente — decisão sua.
