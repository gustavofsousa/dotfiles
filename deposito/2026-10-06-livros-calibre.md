> **Arquivado 2026-10-06.** Doc original de livros/Calibre.
>
> **Colhido para:** [`docs/biblioteca.md`](../docs/biblioteca.md), que absorveu tudo
> (estrutura no disco, os dois consumidores do path, trava do `metadata.db`,
> template de export, plugins) e acrescentou o fluxo de entrada e o RFD do bloco
> técnico.

---

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

O desenho completo (por quê só `entrada/`, trava do SQLite, horizonte NAS) vive
no HQ: **[`acervo-digital.md`](acervo-digital.md)**.
O runbook de instalação/pareamento em si (o que já está no computador, passo a
passo do que falta) está em [`docs/syncthing.md`](syncthing.md) (Syncthing) e
[`docs/google-drive-rclone.md`](google-drive-rclone.md) (backup off-site via
rclone). Esta doc (dotfiles) fica só com **onde** a biblioteca mora no disco.

**Snapshot manual existente:** `~/Backups/biblioteca-backup-2026-09-11/`
(2.6 GB, cópia completa da `biblioteca/` feita antes da faxina de 2026-09-11).
`~/Backups` é o tier estreito só pra backup deliberado — não confundir com o
extinto `~/Archive` (ver `organizacao-de-arquivos.md`). Continua sendo a única
cópia de segurança da biblioteca até o desenho de backup do HQ existir de
fato.

## Nomenclatura para export / envio

`biblioteca/` é gerenciada pelo Calibre sozinho — **nunca renomear essas
pastas pelo explorador de arquivos** (`<Autor>/<Livro (id)>/`), quebra o
`metadata.db`. A convenção abaixo vale pra quando o livro **sai** da
biblioteca: enviar pro Kindle/KOReader, exportar cópia, backup em outro disco.

**Formato master:** manter o original em **EPUB** (padrão aberto); PDF técnico
fica PDF. Preencher o campo **Série** no Calibre quando o livro fizer parte de
uma saga — Kindle e KOReader agrupam por esse campo, não pelo nome do arquivo.

| Caso | Template | Exemplo |
| --- | --- | --- |
| Avulso | `Sobrenome, Nome - Título (Ano).ext` | `Orwell, George - 1984 (1949).epub` |
| Série | `Sobrenome, Nome - [Série NN] - Título.ext` | `Herbert, Frank - [Duna 01] - Duna.epub` |
| PDF técnico | `[Assunto] Autor - Título (Ano).pdf` | `[Docker] Silva, João - Dominando Containers (2023).pdf` |

Número de série com **2 dígitos** (`01`, `02`) pra não quebrar ordenação
alfabética no volume 10+.

**Modelo de salvamento no Calibre** (Preferências → Salvando livros no disco /
Enviar para o dispositivo → *Modelo de Salvamento*) automatiza isso na hora de
exportar/enviar:

```
{author_sort}/{series:||/|}{series_index:0>2s| - |}{title}
```

Gera `Herbert, Frank/Duna/01 - Duna.epub` pra livro de série e
`Orwell, George/1984.epub` pra avulso — sem pasta de série quando não há
série. **Ainda não configurado** neste sistema (nenhum `save_template` em
`~/.config/calibre/global.py.json`) — só importa quando um fluxo de
export/envio (Kindle, Drive, KOReader) existir de fato; hoje é só convenção
documentada. Quando o calibre-mcp chegar na Fase 4 ("Export to a folder", ver
`ARCHITECTURE.md`/`ROADMAP.md` do projeto), este é o template a usar.

### Ficção vs. técnico: por que o export não usa um template só

Tensão real, decidir quando o fluxo de export existir: **ficção e técnico se
procuram de formas diferentes.** Em ficção você lembra do autor e quer a obra
dele reunida, com os volumes na ordem (`author_sort` + série resolve). Em livro
técnico você raramente lembra o autor — procura pelo **assunto** ("aquele de
Docker"), e `Fowler, Martin/` não ajuda.

A convenção de fóruns de arquivamento (MobileRead, `r/koreader`) divide em dois
blocos no destino:

```
Biblioteca-export/
├── 01_Ficcao/              <-- Sobrenome, Nome/[Série NN]/ — template acima
└── 02_Nao-Ficcao_Tecnicos/ <-- por assunto: [Docker] Autor - Título (Ano).pdf
```

O template `{author_sort}/…` cobre **só o bloco 1**. Pro bloco 2 o Calibre não
tem "assunto" nativo — precisaria de uma coluna personalizada (ex. `#assunto`)
e um segundo template usando `{#assunto}`. Por isso: **não está configurado, e
configurar pede a decisão de criar a coluna**. Até lá, o prefixo `[Assunto]` da
tabela acima é preenchido na mão, só quando exportar.

> Isso vale **só no destino do export** (Kindle, KOReader, pendrive, Drive). A
> `biblioteca/` interna continua `<Autor>/<Livro>/` gerenciada pelo Calibre, e
> dentro do Calibre quem faz esse papel é **tag/coluna**, não pasta — mesmo
> princípio dos álbuns de foto: a estrutura física é uma, as visões são várias.
> Ver [`organizacao-de-arquivos.md`](organizacao-de-arquivos.md#álbuns-de-evento--sem-duplicar-arquivo).

**Ebook baixado com nome sujo:** não editar nome/metadado na mão — arrastar
pro Calibre, `E` (editar metadados) → "Baixar Metadados e Capas". Plugins
úteis: **Modify ePub** (limpa EPUB baixado) e **KFX Output** (envio via cabo
pro Kindle, hifenização e negrito corretos).

## Restos a triar

- ✅ **Faxina feita (2026-09-11):** `metadata.db`/`metadata_db_prefs_backup.json`
  avulsos apagados; `lib_calib_envio1/` (material-fonte, 2.5 GB) importado no
  Calibre, arquivado temporariamente e depois **apagado de vez em
  2026-09-16** (`~/Archive` foi eliminado — fonte já estava redundante com a
  biblioteca). Downloads já estava limpo. Ver [TODO.md](../TODO.md).
- ✅ **`livros-investimento/` (24 PDFs)** importados no Calibre (2026-09-11);
  pasta-fonte apagada em 2026-09-16 (mesma faxina do `~/Archive`, já redundante
  com a biblioteca). Biblioteca: 177 → 201 livros. Nenhum resto pendente.
