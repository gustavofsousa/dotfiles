# Biblioteca — livros e Calibre

Como o acervo de livros está montado: onde mora, quem aponta pra ele, como entra
livro novo e como sai pro Kindle/KOReader.

**Fonte:** [pesquisas/2026-10-06-organizacao-e-livros.md](../pesquisas/2026-10-06-organizacao-e-livros.md).
**Backup disso:** [backup.md](backup.md). **Sync:** [sincronizacao.md](sincronizacao.md).

Nomes de pasta em PT-BR por escolha consciente (conteúdo pessoal) — divergência
registrada no [STATE.md](../STATE.md).

## Estado hoje

```
~/Documents/livros/
├── biblioteca/      ← Calibre, autoritativa. 201 livros, ~2.6 GB
│   ├── metadata.db        ← índice SQLite, muda a cada edição
│   └── <Autor>/<Livro>/   ← um dir por livro (epub/pdf/opf/cover)
├── entrada/         ← staging: livro novo cai aqui antes de entrar no Calibre
└── para-celular/    ← cópias soltas pra ler no celular (vazia, pronta)
```

## A trava crítica

> ⚠️ **NUNCA sincronizar `biblioteca/` com Syncthing.** O `metadata.db` é SQLite
> vivo; sincronizar em duas pontas gera `.sync-conflict` no meio do índice e
> **corrompe a biblioteca inteira**.

Só `entrada/` e `para-celular/` entram no Syncthing — são cópias soltas de arquivo,
sem índice. A biblioteca se protege por **backup** (cópia fria), que é outra coisa.
No NAS a mesma regra vale: o Calibre roda num lugar só, clientes acessam por rede.

## Quem aponta pra biblioteca (dois lugares, sem fonte única)

Mover a `biblioteca/` exige atualizar **os dois**:

| Consumidor | Onde configura |
| --- | --- |
| Calibre (GUI) | `~/.config/calibre/global.py.json` → `library_path` |
| calibre-mcp | `~/.claude.json` → `mcpServers.calibre.env.CALIBRE_LIBRARY_PATH` |

O calibre-mcp **falha rápido** no boot se o env estiver errado (não corrompe nada).
Débito de "path duplicado sem fonte única" registrado como **AD-028** em
`~/projects/04_calibre-mcp/.specs/STATE.md`.

## Entrada: livro novo

Fluxo que evita trabalho manual de metadado:

1. Livro cai em `entrada/` (baixado no PC, ou via Syncthing do celular).
2. Arrasta pro Calibre. Nome sujo tipo `clean_code_robert_martin_v2_download.pdf`
   **não se corrige à mão** — tecla `E` (editar metadados) → **"Baixar Metadados e
   Capas"**. O Calibre busca título, autor, ano e sinopse oficiais em segundos.
3. Se for saga, preencher o campo **Série** (ex. `Duna [1]`) — Kindle e KOReader
   agrupam por esse campo, não pelo nome do arquivo.
4. Depois de importado, o arquivo pode sair de `entrada/` (é staging, não destino).

**Formato master: EPUB** (padrão aberto), mesmo que se envie outro formato pro
Kindle. PDF técnico fica PDF.

**Plugins úteis:** *Modify ePub* (limpa EPUB baixado quebrado) e *KFX Output* (envio
via cabo pro Kindle, hifenização e negrito corretos).

## Saída: nomenclatura de export/envio

A `biblioteca/` é gerenciada pelo Calibre — **nunca renomear essas pastas pelo
explorador**, quebra o `metadata.db`. A convenção abaixo vale pra quando o livro
**sai**: Kindle, KOReader, pendrive, Drive.

| Caso | Padrão | Exemplo |
| --- | --- | --- |
| Avulso | `Sobrenome, Nome - Título (Ano).ext` | `Orwell, George - 1984 (1949).epub` |
| Série | `Sobrenome, Nome - [Série NN] - Título.ext` | `Herbert, Frank - [Duna 01] - Duna.epub` |
| PDF técnico | `[Assunto] Autor - Título (Ano).pdf` | `[Docker] Silva, João - Dominando Containers (2023).pdf` |

`Sobrenome, Nome` evita que todo "João" caia na letra J. Série com **2 dígitos**
(`01`) pra que o volume 10 não venha antes do 2 na ordem alfabética.

**Template no Calibre** (Preferências → Salvando livros no disco / Enviar para o
dispositivo → *Modelo de Salvamento*):

```
{author_sort}/{series:||/|}{series_index:0>2s| - |}{title}
```

Gera `Herbert, Frank/Duna/01 - Duna.epub` pra série e `Orwell, George/1984.epub` pra
avulso. **Ainda não configurado** (nenhum `save_template` em
`global.py.json`) — só importa quando um fluxo de export existir. Quando o
calibre-mcp chegar na Fase 4 ("Export to a folder"), é este o template.

## Livros fora do Calibre (celular, e-reader, pasta bruta)

Vale pra ebook que **não** está na `biblioteca/` gerenciada. Erro clássico: pasta por
microgênero (`Ficcao/Distopia/Anos-80`) — sempre gera dúvida ("isso é IA, Matemática
ou Programação?"). Preferir **3 baldes grandes**, arquivos soltos, nome
`Autor - Titulo` (a busca do celular acha em 1s):

```
Livros/
├── Ficcao/
├── Tecnologia_Estudo/
└── Nao-Ficcao_Geral/
```

## RFD em aberto

**Ficção vs. técnico no export — um template não serve pros dois.** Em ficção você
lembra do autor e quer a obra reunida na ordem (`author_sort` + série resolve). Em
livro técnico você procura pelo **assunto** ("aquele de Docker"), e
`Fowler, Martin/` não ajuda. A divisão que os fóruns usam:

```
Biblioteca-export/
├── 01_Ficcao/              ← Sobrenome, Nome/[Série NN]/ — o template acima
└── 02_Nao-Ficcao_Tecnicos/ ← por assunto: [Docker] Autor - Título (Ano).pdf
```

O template atual cobre **só o bloco 1**. Pro bloco 2 o Calibre não tem "assunto"
nativo — exigiria **criar uma coluna personalizada `#assunto`** e um segundo
template. Por isso não está configurado: configurar pede essa decisão. Até lá, o
prefixo `[Assunto]` é preenchido à mão, só ao exportar.

> Dentro do Calibre, quem faz esse papel é **tag/coluna, não pasta** — mesmo
> princípio dos álbuns de foto em [galeria.md](galeria.md): a estrutura física é
> uma, as visões são várias.

## Caminhos de evolução

```
hoje      Calibre local + calibre-mcp; backup frio no mesmo disco
  ↓ rclone configurado
curto     off-site automatizado da biblioteca (AC4)
  ↓ fluxo de export existir
médio     coluna #assunto + template do bloco técnico; KOReader
  ↓ NAS
futuro    Calibre-Web/content server serve a biblioteca pela rede (ver nas.md)
```

## Decisões

**2026-09-11 — Biblioteca em `~/Documents/livros/biblioteca`.** Calibre GUI e
calibre-mcp reapontados; bug de path do MCP corrigido e validado ao vivo.

**2026-09-16 — `para-celular/` como segunda via (PC → Android, Send Only).**
Pra ler no celular livro que já está na biblioteca, sem sincronizar a `biblioteca/`.
Populada via Calibre "Save to disk". *Por que Send Only:* o celular nunca escreve de
volta, elimina chance de conflito.

**2026-10-06 — Bloco técnico do export fica pendente, não improvisado.**
Exige coluna `#assunto` no Calibre. *Por que esperar:* criar coluna e template sem
ter fluxo de export real é configurar no vazio; a convenção de nome já está
documentada e serve manualmente.
