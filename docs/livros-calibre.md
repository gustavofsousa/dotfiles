# Livros e Calibre — como está montado

Retrato de como a biblioteca de livros, o Calibre, o calibre-mcp e o (futuro)
Syncthing se encaixam. Decisão da **Fase 1** do roadmap. Nomes de pasta em
PT-BR por escolha consciente (conteúdo pessoal) — ver a divergência registrada
no [STATE.md](../STATE.md).

## Estrutura no disco

```
~/Documents/livros/
├── biblioteca/     ← biblioteca do Calibre (autoritativa, LOCAL)
│   ├── metadata.db        (o índice SQLite do Calibre — muda a cada edição)
│   └── <Autor>/<Livro>/   (um dir por livro, com epub/pdf/opf/cover)
└── entrada/        ← pasta de ENTRADA (staging) — livro novo cai aqui antes
                       de ser adicionado ao Calibre
```

- **`biblioteca/`** é a fonte da verdade dos livros. Só o Calibre (GUI ou
  `calibredb`) escreve nela. ~2.5 GB, ~170 livros.
- **`entrada/`** é transiente: livro baixado (no PC ou no celular) espera aqui
  até você adicioná-lo ao Calibre. Depois de adicionado, o arquivo pode sair.

## Quem aponta para a biblioteca (DOIS lugares, sem fonte única)

Mover a `biblioteca/` de lugar exige atualizar **os dois**:

| Consumidor    | Onde configura                                    | Valor atual                          |
| ------------- | ------------------------------------------------- | ------------------------------------ |
| Calibre (GUI) | `~/.config/calibre/global.py.json` → `library_path` | `~/Documents/livros/biblioteca`   |
| calibre-mcp   | `~/.claude.json` → `mcpServers.calibre.env.CALIBRE_LIBRARY_PATH` | `~/Documents/livros/biblioteca` |

O calibre-mcp **falha rápido** no boot se o env estiver errado (não corrompe
nada). O débito de "path duplicado sem fonte única" está registrado no próprio
projeto como **AD-028** (`~/projects/04_calibre-mcp/.specs/STATE.md`).

> ⚠️ O calibre-mcp vive em `~/projects/04_calibre-mcp` (com prefixo numérico).
> A config MCP no `.claude.json` (`args: --directory …`) precisa apontar pra
> esse path exato — um bug antigo apontava pra `~/projects/calibre-mcp`
> (inexistente) e o server nem subia. Corrigido em 2026-09-11.

## Sincronização (Syncthing) e backup

Este assunto **saiu do dotfiles** e vive agora no HQ (futuro NAS):
**[`_hq/infra/livros-backup-sync.md`](../../_hq/infra/livros-backup-sync.md)**.
Lá está o desenho completo — Syncthing só na `entrada/` (Android ↔ PC), a trava
de nunca sincronizar `biblioteca/` (SQLite vivo corrompe), backup e horizonte NAS.
Esta doc (dotfiles) fica só com **onde** a biblioteca mora no disco (organização
de arquivos, finalidade de máquina nova); **como** ela viaja e é resguardada é
responsabilidade do HQ.

## Restos a triar

- ✅ **Faxina feita (2026-09-11):** `metadata.db`/`metadata_db_prefs_backup.json`
  avulsos apagados; `lib_calib_envio1/` (material-fonte, 2.5 GB) arquivado em
  `~/Archive/calibre-envio1-2025-07/`; Downloads já estava limpo. Ver
  [TODO.md](../TODO.md).
- ✅ **`livros-investimento/` (24 PDFs)** importados no Calibre (2026-09-11);
  pasta-fonte arquivada em `~/Archive/livros-investimento-fonte-2026-09/`.
  Biblioteca: 177 → 201 livros. Nenhum resto pendente.
