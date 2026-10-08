# Galeria — fotos e vídeos

Como eu guardo, acho e dou significado a foto e vídeo. Cobre o fluxo do clique até
o arquivo parado no lugar certo.

**Fonte:** [pesquisas/2026-10-06-fotos-video-familia.md](../pesquisas/2026-10-06-fotos-video-familia.md)
e [2026-10-06-curadoria-narrativa.md](../pesquisas/2026-10-06-curadoria-narrativa.md).
**Padrão geral de pastas/nomes:** [organizacao-de-arquivos.md](organizacao-de-arquivos.md).
**Backup disso:** [backup.md](backup.md).

## Estado hoje (2026-10-06)

| | |
| --- | --- |
| Nuvem viva | Google Fotos, Google One **200 GB**, compartilhado só com a noiva |
| Acervo local | `~/Media/Pictures` — **17 GB** em `AAAA/AAAA-MM/` (2015, 2019-2025) |
| Câmera | **Osmo Pocket 4** (sem GoPro) |
| HD externo | **BLACK** (exFAT, aprovado no SMART em 2026-10-08) é o cofre frio e já tem o espelho do `~/Media/Pictures`; **TRANSLUCENT** (antigo, 22 GB de dados) sem veredito — ver [backup.md](backup.md) |
| Ferramentas | `exiftool`, `ffmpeg`, `rsync`, `smartctl` ✓ · falta `rapid-photo-downloader`, LosslessCut |

## Ferramentas no sistema

Medido em 2026-10-06; `rapid-photo-downloader` e LosslessCut medidos em 2026-10-08.
A coluna "origem" é o que a migração pro Nix ([nix.md](nix.md)) vai ter que declarar.

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| `exiftool` 12.76 | ler EXIF, mover+renomear em lote pro padrão cronológico | ✅ | apt (`libimage-exiftool-perl`) |
| `ffmpeg` 6.1.1 | comprimir clipe pra nuvem (H.265) | ✅ | apt (+ snap `ffmpeg-2204` 8.1 instalado em paralelo) |
| `rsync` 3.2.7 | copiar cartão/HD com progresso e retomada | ✅ | apt |
| `rapid-photo-downloader` 0.9.36-0ubuntu3 | descarregar cartão SD criando `AAAA/AAAA-MM/` | ✅ instalado, **nunca aberto** (sem config) | apt (`rapid-photo-downloader`, repositório Ubuntu) |
| **LosslessCut** 3.69.0 | poda sem recodificar (corta take, zero perda) — uso em [edicao-video.md](edicao-video.md) | ✅ instalado, **nunca aberto** (sem config) | flatpak, remote `flathub`, instalação `system` (`no.mifi.losslesscut`) |
| **Czkawka** | deduplicar por hash de conteúdo + fotos similares | ⬜ **falta** | `sudo snap install czkawka` |
| **DigiKam** | álbum virtual, estrelas, legenda no EXIF, rosto offline | ⬜ **falta** | depende do RFD `AC8` |

**Personalização a preservar** (nada disso está versionado ainda — vira item quando
as ferramentas existirem):

- `rapid-photo-downloader`: destino `~/Media/02_Cameras/Osmo_Pocket/`, subpasta
  `AAAA/AAAA-MM/`, nome `AAAA-MM-DD_HHMMSS.ext` (o mesmo do `~/Media/Pictures` real). Config
  ainda **não existe** — o app nunca foi aberto; ela nascerá em
  `~/.config/Rapid Photo Downloader/` e o passo a passo está no
  [cheatsheet](edicao-video.md#cheatsheet-da-câmera-ao-cofre).
- ⚠️ **`.LRV` não é ignorado por padrão — o contrário.** Medido no código instalado
  (`raphodo/metadata/fileformats.py`): `lrv` está em `VIDEO_EXTENSIONS` (importa como
  vídeo) e `thm` é a miniatura que acompanha o vídeo. A preferência *Ignored Paths* do
  app filtra **pastas**, não extensão (`scan.py`), então não resolve. Caminho que vale:
  importar e rodar a limpeza do `find` abaixo. Se a Pocket 4 grava `.LRF` em vez de
  `.LRV`, o app nem o enxerga — conferir no primeiro cartão real (não testado).
- Nenhum dotfile de galeria é pacote Stow hoje. Quando houver config que valha
  versionar, ela entra como pacote espelhando `~/.config/<app>/`.

## O princípio: um arquivo, um lugar

Tudo aqui decorre de uma regra só:

> **O arquivo existe num lugar só — a pasta cronológica. Todo o resto (álbum,
> tag, diário, nuvem) é uma *visão* por cima dela, nunca uma segunda cópia.**

Por isso nunca há pasta por evento: pasta é excludente, e a foto do aniversário
*na praia* não tem onde ir. Data é fato objetivo, lugar e pessoa são busca.

## Onde cada coisa mora

```
~/Media/Pictures/
├── 2026/
│   └── 2026-07/
│       └── 2026-07-20_091244.jpg     ← o arquivo real, único
├── Albuns/
│   └── 2026-07_viagem-chile/
│       └── 2026-07-20_091244.jpg →   ← symlink, zero byte
├── Screenshots/                       ← utilitário, não é "foto"
└── wallpaper/
```

No HD externo (BLACK, exFAT), mesma lógica, com a origem separada:

```
[BLACK]
├── Pictures/                ← espelho do ~/Media/Pictures (rotina em backup.md)
├── 00_legado-translucid/    ← dump bruto do HD antigo, como veio
├── 01_Smartphones/          ← dumps do Google Takeout
└── 02_Cameras/Osmo_Pocket/2026/2026-07/
```

Não há `03_Albuns/`: exFAT perde symlink (decisão `AC5`, 2026-10-08).

No SSD, toda a mídia mora em **`~/Media`** (decisão 2026-10-08) e repete os nomes do
BLACK, de modo que enviar vira um `rsync` de uma linha por pasta:

```
~/Media/
├── Pictures/                   ← o bloco de cima (ex-~/Pictures)
├── Videos/                     ← ex-~/Videos
└── 02_Cameras/Osmo_Pocket/     ← destino do rapid-photo-downloader (AAAA/AAAA-MM/ dentro)
```

`02_Cameras/` é **entrada e trânsito**: descarrega, poda no LosslessCut, envia pro BLACK
e confere. O que fica no SSD depois de enviado é decisão em aberto — o SSD tem ~55 GB
livres e vídeo 4K enche rápido.

## Álbum de evento sem duplicar

Três formas, em ordem de preferência. A primeira funciona hoje, sem instalar nada:

**1. Symlink.** Álbum é pasta de ponteiros; apagar o álbum não toca nas fotos.

```bash
mkdir -p ~/Media/Pictures/Albuns/2026-07_viagem-chile
ln -s ~/Media/Pictures/2026/2026-07/2026-07-2*.jpg ~/Media/Pictures/Albuns/2026-07_viagem-chile/
```

Nome começa com `AAAA-MM` (ordena sozinho) + slug do evento.

> ⚠️ Symlink **não sobrevive** a exFAT/FAT (pendrive, cartão) nem ao Google Fotos.
> Pra levar um álbum pra fora: `rsync -aL` ou `cp -rL` (resolve o link, copia o
> arquivo). No backup, o inverso: `rsync -a` **sem** `-L`, pra não inflar.

**2. DigiKam** — álbum virtual no banco, uma foto em vários álbuns sem cópia nem
symlink, + estrelas e rosto offline. O caminho quando symlink a mão virar trabalho.
Custo: a organização passa a viver num banco, que entra no backup.

**3. Immich** — mesmo modelo, com app no celular e busca semântica. Amarrado ao NAS
([nas.md](nas.md)).

**Rejeitados:** hardlink (quebra silencioso se um editor reescrever o arquivo; não
cruza filesystem) e cópia (duplica bytes, cria duas verdades — qual vale quando
você edita uma?).

## Ingestão do Osmo Pocket 4

O que muda com câmera dedicada: foto de celular tem 2-5 MB, mas **vídeo 4K/60 grava
600 MB–1 GB por minuto**. Sincronizar bruto na nuvem esgota os 200 GB em semanas.

Daí a divisão:

- **HD externo = arquivo mestre.** Bruto, intacto, qualidade máxima.
- **Google Fotos = acesso social.** Só seleção e clipes curtos/editados (15-45 s).
  É o que a noiva vê.

**Dois caminhos de entrada:**

*Imediato, sem PC* — Pocket → app DJI Mimo → Android → Google Fotos → Partner
Sharing entrega na timeline dela em minutos. **Com parcimônia**, só clipe curto.

*Consolidado, no fim de semana* —
1. MicroSD no PC → `rapid-photo-downloader` descarrega pra
   `~/Media/02_Cameras/Osmo_Pocket/` (padrão `AAAA/AAAA-MM/AAAA-MM-DD_HHMMSS.ext`).
   Depois, apagar `.LRV`/`.THM` (preview e miniatura da câmera, 15-25% de lixo) com o
   `find` abaixo — o app não os pula sozinho, ver "Personalização a preservar".
2. **Poda imediata** no LosslessCut: take de 2 min onde só 25 s prestam → corta
   (sem recodificar, instantâneo) → **apaga o bruto**. Atalhos, detect-scenes e
   automação: **[edicao-video.md](edicao-video.md)**.
3. **Envia pro BLACK** (`rsync`, comando no cheatsheet).
4. Arrasta os 3-4 melhores da semana pro Google Fotos no navegador.

> ⚠️ **Não acumule dívida de triagem.** Descarregar 64 GB pensando "depois eu
> edito" = pagar terabytes pra guardar vídeo de sapato e tampa de lente.

Limpeza manual e compressão pra nuvem, quando precisar:

```bash
find . -type f \( -iname "*.LRV" -o -iname "*.THM" \) -delete
ffmpeg -i entrada.MP4 -c:v libx265 -crf 24 -preset fast -c:a aac -b:a 192k saida_leve.MP4
```

## Organizar em massa (dump de HD antigo, pasta bagunçada)

**Automatizar com `exiftool`** — lê a data original do EXIF e já move+renomeia pro
padrão cronológico. **Sempre dry-run antes:**

```bash
exiftool -d "%Y/%Y-%m/%Y-%m-%d_%H%M%S%%-c.%%e" "-filename<DateTimeOriginal" -r /pasta/bruta
```

Foto sem EXIF (print de WhatsApp): cair pra data de modificação como plano B.

**Deduplicar antes de organizar, nunca depois** (senão duplica o trabalho):
**Czkawka** (`sudo snap install czkawka`) compara **hash de conteúdo**, não nome —
acha `IMG_001.jpg` e `foto_praia.jpg` idênticas, e tem detecção de fotos similares
(mesma cena re-tirada, resoluções diferentes).

**Runbook — vários HDs antigos** (cenário clássico de `r/datacurator`: a mesma foto
repetida em "Backup 2012", "Fotos Celular Antigo"). **Não organizar manualmente pasta
por pasta** — cansa no meio e duplica trabalho. Nesta ordem:

1. **Segurança primeiro.** HD mecânico antigo pode falhar sob script pesado de
   leitura. Copiar **tudo** pra uma pasta bruta única num disco com espaço sobrando,
   **antes** de qualquer processamento. Os HDs antigos vão pra gaveta como rede de
   segurança até o processo terminar.
2. **Deduplicar** com Czkawka na pasta bruta — elimina gigabytes antes de organizar.
3. **Estrutura cronológica** com o `exiftool` acima.
4. **Navegar depois de pronto** — DigiKam (offline, rosto, mapa) ou Immich
   (self-hosted, app, busca semântica). Não fazem parte da estrutura de pastas.

> A pasta `AAAA/AAAA-MM/` **só se paga com volume real** (centenas de fotos, celular
> sincronizando, dump de HD). Pra poucas dezenas de fotos soltas é over-engineering:
> arquivo na raiz de `Pictures/` com a data no nome já ordena.

## Curadoria: separar memória de ruído

O fluxo é **metadado + favorito**, não pasta:

1. **Linha do tempo.** Data, hora e GPS já estão na foto; a busca acha "praia",
   "abril de 2026" sozinha.
2. **Regra do coração.** 10 fotos da mesma pose → favorita a melhor, **apaga o
   excesso na hora**.
3. **Ritual mensal de 15 min.** Fim do mês → álbum `2026-05 - Melhores`, 20-40
   fotos. É esse que você olha em 5 anos.
4. **Fotolivro anual impresso.** Um por ano na estante vence qualquer galeria
   digital pra folhear em família.

## A camada que falta: narrativa

Tudo acima resolve **guardar e achar** — isso é um *depósito*. Em 10 anos você tem
40 mil arquivos sem contexto, misturados com print de comprovante.

**A regra dos 5%:** de uma viagem com 300 fotos, o backup guarda as 300, mas o
diário recebe **10-15 + dois parágrafos**. Em 10 anos esse texto vale mais que a
galeria inteira.

Quatro candidatos, nenhum testado:

| | Modelo | A favor | Contra |
| --- | --- | --- | --- |
| **Obsidian** | nota markdown + fotos | **já instalado**; markdown eterno, zero lock-in; Canvas/Timeline | a foto fica em dois lugares — cópia ou ponteiro? (RFD) |
| **DigiKam** | legenda **no EXIF do arquivo** | a história viaja **dentro da foto** — troca de PC em 20 anos e continua lá; estrelas; mapa; rosto offline | é curadoria de foto, não diário com texto longo |
| **Diarium** | diário multimídia (texto+mapa+clima) | formato pronto, backup no Drive | proprietário, Linux só via web |
| **Mylio** | *Life Calendar* (Década→Ano→Evento) | a visão por evento de vida | proprietário, sem cliente Linux |

**Recomendação quando decidir:** **Obsidian** pra narrativa (já em uso) +
**DigiKam** pra curadoria da foto (estrela separa as 5%, legenda no EXIF sobrevive
a qualquer migração). Os dois são locais, abertos e não competem. Diarium/Mylio
resolvem igual com lock-in — só se o caminho aberto provar atrito alto.

## RFDs em aberto

**`AC8` — a foto do diário é cópia ou ponteiro?** Embutir no vault duplica bytes
(e o vault vai pro Syncthing); apontar pro acervo quebra se a foto mudar de lugar.
Provável resposta: ponteiro + regra de nunca mover o cronológico, igual aos álbuns.
Decide também se DigiKam entra.

*(`AC5` — filesystem do HD externo — foi decidido em 2026-10-08: exFAT, sem
`03_Albuns/`. Ver [backup.md](backup.md#decisões).)*

## Caminhos de evolução

```
hoje            symlink a mão + Google Fotos
  ↓ volume crescer / symlink virar trabalho
médio           DigiKam local (banco, estrelas, rosto, legenda no EXIF)
  ↓ querer acesso do celular sem depender do meu PC
NAS             Immich (ver nas.md) — álbum virtual, app, busca semântica
```

Cada degrau é aditivo: a pasta cronológica continua sendo a verdade em todos eles.
Isso é o que permite trocar de ferramenta sem migrar dado.

## Decisões

**2026-10-06 — Cronológico é a única estrutura; álbum é visão.**
Pasta por evento é excludente e quebra ordenação. Álbum vira symlink
(`Pictures/Albuns/AAAA-MM_slug/`). *Rejeitados:* hardlink (frágil, não cruza FS) e
cópia (duplica bytes, duas verdades). *Consequência:* o filesystem do HD passa a
importar (`AC5`, decidido: exFAT, então o álbum vive só no SSD), e levar álbum pra
fora exige `rsync -aL`.

**2026-10-06 — Arquivo mestre local vs. acesso social na nuvem.**
Vídeo 4K a 600 MB-1 GB/min torna impossível subir bruto nos 200 GB. Bruto fica no
HD; nuvem recebe seleção e clipe curto. *Consequência:* exige o ritual de poda no
LosslessCut, senão o HD vira lixão.

**2026-10-06 — Conceito de narrativa aceito, ferramenta não escolhida.**
Regra dos 5% adotada como método. Obsidian+DigiKam é a recomendação, pendente do
RFD `AC8`. *Por que não decidir agora:* a pergunta cópia-ou-ponteiro muda qual
ferramenta serve, e ela não é urgente — nada se perde esperando.

**2026-10-06 — `~/Pictures` confirmado em dia.** 17 GB em `AAAA/AAAA-MM/`, zero
pasta por evento. O padrão não é teoria; a convenção de álbuns encaixa sem migração.

**2026-10-08 — `~/Media` nasce como entrada da câmera, espelhando o BLACK.**
Pergunta: onde caem foto e vídeo da câmera antes de ir pro cofre? *Decisão:*
`~/Media/02_Cameras/Osmo_Pocket/`, o mesmo caminho relativo do BLACK, então enviar é
`rsync ~/Media/02_Cameras/ /media/gustavo/BLACK/02_Cameras/`. *Por que não `~/Pictures`
ou `~/Videos`:* misturariam bruto de câmera (GB por minuto) com o acervo já curado e com
screenshots/wallpaper. *Consequência:* revoga a regra "`~/Media` só se `Pictures`/
`Videos` deixarem de bastar" de [organizacao-de-arquivos.md](organizacao-de-arquivos.md);
se `~/Media` também absorve o `~/Pictures` foi decidido logo depois (ver abaixo).

**2026-10-08 — Corrigido: `.LRV` não é ignorado pelo rapid-photo-downloader.**
A nota anterior dizia "regra de ignorar `.LRV` e `.THM`" como se fosse configuração do
app. No código instalado (0.9.36) `lrv` é extensão de vídeo importável e *Ignored Paths*
só filtra pastas. *Consequência:* a limpeza é um passo manual pós-importação.

**2026-10-08 (2) — `~/Media` é a pasta única de mídia (`AC12`, opção B).**
`~/Pictures` (17 GB, 1.819 arquivos) e `~/Videos` viraram `~/Media/Pictures` e
`~/Media/Videos` com um `mv` no mesmo filesystem (instantâneo, contagem de arquivos e
bytes idêntica antes e depois). O `user-dirs.dirs` e os favoritos do GNOME/Dolphin foram
repontados, então screenshots e diálogos de arquivo seguem o caminho novo. *Supera em
parte* a decisão acima: o bruto da câmera não mistura com o acervo curado porque mora em
`02_Cameras/`, não por estar numa pasta de topo à parte. *Rejeitado:* manter `~/Pictures`
como symlink pra `~/Media/Pictures` — duas portas pro mesmo lugar contradiz "pasta
única". *Consequência:* o BLACK **não foi tocado** — o espelho de 2026-10-08 continua
valendo como foto daquele dia; a rotina de espelho agora parte de `~/Media/Pictures/`.

