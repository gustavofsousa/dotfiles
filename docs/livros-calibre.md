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

## Fluxo desejado com Syncthing (AINDA NÃO montado — decisão macro)

Objetivo declarado: **baixar um livro no celular → ele aparece no PC → fácil de
adicionar ao Calibre**, e ter **backup em outro lugar (Google Drive)**.

Desenho recomendado (a decidir com RFD antes de instalar):

- Syncthing sincroniza **só `~/Documents/livros/entrada/`** entre celular ↔ PC.
  A pasta de entrada é pequena e volátil; sincronizá-la resolve o
  celular→PC sem risco.
- **NÃO** sincronizar `biblioteca/` inteira: o `metadata.db` é SQLite vivo —
  editar em duas pontas gera `.sync-conflict` no meio do índice, que pode
  corromper a biblioteca. Backup da biblioteca é um job separado (cópia fria
  pro Drive/HD externo), não sincronização contínua.
- Backup no Google Drive: pode ser (a) uma pasta do Syncthing que também
  espelha pro Drive, ou (b) um `rclone`/cópia periódica da `biblioteca/`.
  Decidir na hora de implementar (item `[pc]` do roadmap).

## Restos a triar (faxina pendente)

Ainda soltos em `~/Documents/` (não movidos ainda — decisão sua):

- `metadata.db` + `metadata_db_prefs_backup.json` avulsos (fora de qualquer lib)
- `lib_calib_envio1/` (500 arquivos de um envio antigo)
- ~109 `.epub`/`.pdf` soltos em `~/Downloads/`
- `livros-investimento/` (24 PDFs) — decidir se entram no Calibre ou ficam à parte

Candidatos a `~/Archive/` (frio) ou à `entrada/` (pra adicionar ao Calibre).
