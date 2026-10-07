> **Arquivado 2026-10-06.** Era o guarda-chuva de livros + fotos/vídeos + backup +
> NAS num só arquivo (348 linhas). Saiu de circulação porque misturava quatro
> assuntos com públicos e ritmos diferentes.
>
> **Colhido para:** [`docs/galeria.md`](../docs/galeria.md),
> [`docs/biblioteca.md`](../docs/biblioteca.md), [`docs/backup.md`](../docs/backup.md)
> e [`docs/nas.md`](../docs/nas.md). As pesquisas originais que o embasaram estão em
> [`pesquisas/`](../pesquisas/). Nada foi perdido — só redistribuído por tema.

---

# Acervo digital — livros, fotos/vídeos, backup e sincronização

Fonte da verdade do assunto **acervo pessoal + backup + sync entre dispositivos**:
o quê, por quê e como se encaixa. O horizonte declarado é **virar um NAS** — um
lugar central que serve o acervo, guarda o backup e sincroniza os dispositivos.

> **Onde cada coisa vive:**
> - **este doc** — o desenho (o quê e por quê);
> - [`../ROADMAP-acervo.md`](../ROADMAP-acervo.md) — o que falta fazer, em ordem,
>   e os RFDs em aberto (IDs `AC*`);
> - [`../config.md`](../config.md) — a fila do que **só o humano** pode fazer
>   (item feito sai de lá);
> - [`livros-calibre.md`](livros-calibre.md) — *onde* a biblioteca mora no disco;
> - [`organizacao-de-arquivos.md`](organizacao-de-arquivos.md) — o padrão geral
>   (3 níveis, ISO 8601, cronológico, álbuns por symlink);
> - [`syncthing.md`](syncthing.md) / [`google-drive-rclone.md`](google-drive-rclone.md)
>   — runbooks de pareamento e OAuth.
>
> **Divisão com o `_hq` (temporária, decidida 2026-10-06):** o assunto era
> `_hq/infra/livros-backup-sync.md`. Enquanto o acervo está sendo configurado,
> tudo vive aqui no `dotfiles` — é onde a mão está. Quando estabilizar, volta pro
> `_hq` (que cuida do computador como um todo) e o `ROADMAP-acervo.md` é removido.
> **Não "consertar" essa divisão sem pedido explícito.**

**Dois acervos, perfis muito diferentes, mesma infraestrutura-destino:**

| | Livros (§1) | Fotos/vídeos (§2) |
| --- | --- | --- |
| Volume | ~2.6 GB, 201 livros | centenas de GB e crescendo (4K) |
| Crescimento | lento, pontual | rápido e contínuo (Osmo Pocket 4) |
| Quem acessa | só eu | eu + noiva |
| Risco dominante | corromper o índice (`metadata.db`) | estourar cota / "lixão digital" / perder original |
| Ferramenta viva | Calibre local | Google Fotos (200 GB, Google One) |

A §3 (NAS/3-2-1) é o destino comum dos dois — e é a parte **ainda não decidida**.

---

## §1 — Livros (Calibre)

### Estado atual (2026-09-11)

- ✅ **Biblioteca consolidada:** 201 livros no Calibre (`~/Documents/livros/biblioteca`).
  Os 24 PDFs de `livros-investimento/` foram importados e a pasta-fonte **apagada**
  em 2026-09-16 (já redundante com a biblioteca).
- ✅ **Backup frio local feito:** `~/Backups/biblioteca-backup-2026-09-11/`
  (2.6 GB, verificado em 2026-10-06). **Provisório** — mesmo disco, sem redundância.
- ✅ **`~/Archive` foi eliminado em 2026-09-16** — o tier de backup deliberado é
  `~/Backups/`. Material-fonte (`calibre-envio1`) apagado de vez na mesma faxina.
- ⚠️ **`~/Backups/notion-backup-2025-03/` (1.8 GB) está com 19 meses** — é o item
  "ajustar backups do Notion" do [`config.md`](../config.md); hoje
  é a única cópia e está velha.
- ✅ **Syncthing e rclone instalados** (2026-09-11) — `syncthing v1.27.2`,
  `rclone v1.60.1`. Falta configurar — ver [`config.md`](../config.md).
- ⬜ **Backup off-site (rclone→Drive) não montado** — rclone instalado mas sem
  remote configurado (`rclone listremotes` vazio). `AC4`.

### A trava crítica (nunca esquecer)

> ⚠️ **NUNCA sincronizar `biblioteca/` inteira com Syncthing (nem sync contínuo).**
> O `metadata.db` é SQLite vivo; sincronizá-lo em duas pontas gera
> `.sync-conflict` no meio do índice e **corrompe a biblioteca inteira**.
> Syncthing só na `entrada/` e `para-celular/` (cópias soltas de arquivo, sem
> índice). Biblioteca se protege por **backup** (cópia fria), que é outra coisa.
> No NAS a mesma regra vale: o Calibre roda num único lugar (o NAS); os clientes
> acessam por rede, não sincronizam o `metadata.db`.

### Syncthing: Android ↔ PC, duas pastas com direção oposta

1. **`entrada/` (Android → PC, bidirecional).** Livro baixado no celular cai em
   `entrada/`, aparece no PC, você adiciona ao Calibre, o arquivo pode sair depois.
2. **`para-celular/` (PC → Android, Send Only), decidido 2026-09-16.** Pra ler no
   celular livros que já estão na biblioteca, sem sincronizar a `biblioteca/`
   inteira. Fluxo: Calibre → selecionar livros → **Save to disk** (ou
   `calibredb export`) → `~/Documents/livros/para-celular/`. Cópia solta em disco
   (epub/pdf puro, sem índice), então sincronizar é seguro. **Send Only** no PC e
   **Receive Only** no celular — o celular nunca escreve de volta.

Runbook de pareamento: [`syncthing.md`](syncthing.md).

### Backup da biblioteca

**Agora — backup frio manual** (feito, repetir periodicamente):

```bash
# Feche a GUI do Calibre antes (metadata.db consistente).
rsync -a --delete ~/Documents/livros/biblioteca/ <DESTINO>/livros-biblioteca/
```

O backup atual em `~/Backups/biblioteca-backup-2026-09-11/` é **local, mesmo
disco** — cobre erro humano/corrupção lógica, não falha de hardware.

**Futuro — off-site automatizado (`rclone` → Drive), `AC4`:**

```bash
rclone config                       # remote "gdrive" tipo drive; OAuth no navegador
rclone copy ~/Documents/livros/biblioteca gdrive:backup/livros-biblioteca --progress
```

GNOME Online Accounts continua útil só pra **ver** o Drive no Nautilus (uso
passivo) — não é feito pra backup automatizado de pasta grande.
Runbook: [`google-drive-rclone.md`](google-drive-rclone.md).

---

## §2 — Fotos e vídeos da família

> **Origem:** pesquisa externa consolidada em 2026-10-06 (ChatGPT/Perplexity),
> registrada aqui como **hipótese a verificar** — as recomendações de ferramenta
> (Immich, Rapid Photo Downloader, Restic/Borg, QuickSync) **não foram testadas
> por mim**. Decisões de hardware/SO viram RFD quando chegar a vez (§3).

### Estado atual (2026-10-06)

- ✅ **Google Fotos + Google One 200 GB** — plano pago, compartilhado **só com a
  noiva** (pais fora do escopo).
- ✅ **Osmo Pocket 4** em uso no dia a dia.
- ✅ **HD externo existe, está vazio** — e é antigo; **saúde não medida ainda**
  (não estava conectado em 2026-10-06). Primeiro passo é diagnosticar antes de
  confiar qualquer dado nele — ver [`config.md`](../config.md).
- ✅ **Já na máquina:** `smartmontools 7.4` (instalado 2026-10-06), `ffmpeg 6.1.1`,
  `exiftool`, `rsync 3.2.7`, `flatpak 1.14.6` — as quatro primeiras registradas
  como **dependências recomendadas no `bootstrap.sh`**, pra voltarem sozinhas em
  máquina nova (e virarem pacote declarado na migração pro Nix, `LT1`).
- ⬜ **Falta instalar:** `rapid-photo-downloader` (ingestão), LosslessCut (poda).
  GoPro: não tenho. DigiKam: ausente (ver `AC8`).
- ⬜ **Fluxo de ingestão não existe** — nada descarregado do Pocket 4 pro HD ainda.

### A regra de ouro: Arquivo Mestre (local) vs. Acesso Social (nuvem)

O que muda o jogo com câmera dedicada: foto de celular ocupa 2–5 MB, mas vídeo
4K/60 da Pocket grava a 80–130 Mbps — **600 MB a 1 GB por minuto**. Sincronizar
bruto no Google Fotos esgota os 200 GB em semanas.

- **HD externo (arquivo mestre):** todos os arquivos brutos, intactos, qualidade máxima.
- **Google Fotos (acesso social):** só fotos selecionadas e clipes curtos/editados
  (os melhores 15–45 s do momento, ou o vídeo final do evento). É o que a noiva vê.

### Curadoria diária (sem virar escravo de pastas)

Estrutura rígida de pastas por evento no celular ninguém mantém. O fluxo é
**metadados + filtro de favoritos**:

1. **Confie na linha do tempo.** Data, hora e GPS já estão gravados; a busca do
   Google Fotos acha "praia", "restaurante", "abril de 2026" sozinha.
2. **Regra do coração.** 10 fotos da mesma pose → favorita a melhor, apaga o
   excesso **na hora**. Filtrar por favoritos no fim da semana reduz o ruído.
3. **Álbuns só pra marcos fechados** — `2026-07 Viagem Chile`, `Reforma da Casa`.
   Colaborativos: os dois adicionam.
4. **Ritual mensal de 15 min.** Último dia do mês → álbum `2026-05 - Melhores`
   com 20–40 fotos. É esse álbum enxuto que vocês olham em 5 anos.
5. **Fotolivro anual impresso** a partir dos álbuns mensais — 1 por ano na
   estante supera qualquer galeria digital pra folhear em família.

### De depósito a narrativa — a camada que ainda não existe

> **Origem:** pesquisa externa, 2026-10-06. Opções registradas **pra decisão
> futura**, nenhuma testada nem escolhida.

Tudo acima (§2 até aqui) resolve **guardar e achar**. Isso é um *depósito*: o
Google Fotos acumula print de comprovante, foto repetida e recibo junto com a
memória de verdade, e em 10 anos você tem 40 mil arquivos sem contexto. Falta
uma camada de **curadoria e narrativa** — o que aconteceu, quem estava, o que
foi engraçado.

**A regra dos 5%** (o método, independente de ferramenta): de uma viagem com 300
fotos, deixe o backup automático guardar as 300, mas escolha **10 a 15** pro
diário e escreva **dois parágrafos** sobre o dia. Em 10 anos esse texto com
poucas fotos vale mais que a galeria inteira sem contexto. É o mesmo princípio
que já governa o acervo: **o arquivo mora num lugar só; a narrativa é uma visão
por cima** — igual aos álbuns por symlink e às tags do Calibre.

Quatro candidatos, e a diferença que importa entre eles:

| Opção | Modelo | A favor | Contra |
| --- | --- | --- | --- |
| **Obsidian** | nota markdown + fotos embutidas | **já está instalado e em uso** (`~/Documents/notas-pkm/`); markdown dura pra sempre, zero lock-in; Canvas/Timeline pra ver a vida interligada | a foto fica referenciada em dois lugares (acervo + vault) — definir se embute cópia ou aponta pro caminho |
| **DigiKam** | legenda/título **gravados no EXIF do arquivo** | a história viaja **dentro da foto** — troca de PC em 20 anos e o texto continua lá; estrelas pra filtrar o lixo; mapa; rosto offline | é curadoria de foto, não diário com texto longo; organização passa a viver num banco (que entra no backup) |
| **Diarium** | diário multimídia (texto + mapa + clima + fotos) | formato de diário pronto, backup no Drive sem servidor próprio, web + celular + desktop | proprietário, Linux só via web; o dado fica no formato deles |
| **Mylio Photos** | *Life Calendar* (Década → Ano → Evento) | a visão por evento de vida que você pediu, com capa e descrição | proprietário, sem cliente Linux nativo |

**Recomendação quando a decisão vier:** **Obsidian para a narrativa** (texto,
causos, quem estava — e já está em uso, sem nova ferramenta) + **DigiKam para a
curadoria da foto** (estrela pra separar as 5%, legenda no EXIF pra sobreviver a
qualquer migração). Os dois são locais, abertos e não competem: um guarda a
história escrita, o outro marca a foto. Diarium e Mylio resolvem o mesmo com
lock-in proprietário — só entram se o atrito do caminho aberto provar ser alto.

A pergunta aberta que decide isso: **a foto do diário é cópia ou ponteiro?**
Embutir no vault duplica bytes (e o vault vai pro Syncthing); apontar pro
caminho do acervo quebra se a foto mudar de lugar. Mesmo dilema dos álbuns, e a
resposta provavelmente é a mesma (ponteiro + regra de nunca mover o cronológico).
Registrado como `AC8`.

### Ingestão do Pocket 4 (quando o HD estiver validado)

Dois caminhos, cada um pro seu caso:

- **Imediato (sem PC):** Pocket → app DJI Mimo → baixa pro Android → Google Fotos
  faz backup → *Compartilhamento com Parceiro* entrega na timeline da noiva em
  minutos. Usar **com parcimônia**, só clipes curtos, pra não lotar a cota.
- **Consolidado (fim de semana no Ubuntu):**
  1. MicroSD no PC → Rapid Photo Downloader descarrega pro HD externo
     (padrão `AAAA/AAAA-MM/AAAA-MM-DD_HH-MM-SS.ext`, sem nome repetido tipo `DJI_0001`).
  2. **Poda imediata** no LosslessCut: take de 2 min onde só 25 s prestam → corta
     os 25 s (sem recodificar, instantâneo, zero perda) → **apaga o take original**.
  3. Google Fotos no navegador → arrasta só os 3–4 melhores momentos da semana.

> ⚠️ **Não acumule "dívida de triagem".** Descarregar 64 GB pensando "depois eu
> edito" = pagar terabytes pra guardar vídeo de sapato e tampa de lente. Poda
> antes de arquivar, sempre.

**Lixo invisível das câmeras de ação** (economia de 15–25%): `.LRV` (preview de
baixa resolução) e `.THM` (miniatura) não servem pra nada no PC. Configurar o
Rapid Photo Downloader pra ignorar essas extensões, ou limpar depois:

```bash
find . -type f \( -iname "*.LRV" -o -iname "*.THM" \) -delete
```

**Compressão pra nuvem** (quando um clipe bonito for pesado demais pra cota):

```bash
ffmpeg -i entrada.MP4 -c:v libx265 -crf 24 -preset fast -c:a aac -b:a 192k saida_leve.MP4
```

H.265/HEVC com qualidade visualmente idêntica corta até 70% do tamanho.

### Estrutura de pastas no HD externo

Desenhada pra ser plugada no futuro NAS **sem reorganizar nada**, e coerente
com a regra cronológica que já vale em `~/Pictures`
([`organizacao-de-arquivos.md`](organizacao-de-arquivos.md#picturesestrutura-cronológica-só-quando-é-galeria-de-verdade)):

```
[HD_EXTERNO]
├── 01_Smartphones/             <-- dumps do Google Takeout (celulares)
├── 02_Cameras/
│   └── Osmo_Pocket/
│       └── 2026/
│           ├── 2026-05/        <-- cronológico puro, nunca nome de evento
│           └── 2026-07/
└── 03_Albuns/                  <-- symlinks pros eventos conhecidos, zero byte
    └── 2026-07_viagem-chile/
```

> **Por que não `2026-07_Viagem_Praia/`:** pasta por evento é excludente (foto
> do aniversário *na praia* vai em qual?) e quebra a ordenação automática.
> Evento conhecido vira **álbum de symlinks** em `03_Albuns/` — o arquivo
> continua existindo num lugar só. Convenção completa (symlink → DigiKam →
> Immich, e a pegadinha do `rsync -aL` ao copiar pra exFAT) na
> [seção "Álbuns de evento"](organizacao-de-arquivos.md#álbuns-de-evento--sem-duplicar-arquivo)
> do doc de organização.

### Ergonomia do HD externo

- **Sistema de arquivos:** **ext4** se o HD for só pra Ubuntu + futuro NAS Linux
  (journaling robusto, não fragmenta vídeo pesado). **exFAT** se precisar plugar
  no Windows às vezes. Evitar NTFS no Linux pra vídeo pesado (driver consome mais
  CPU, inconsistência de permissão). *Decisão pendente — depende do §3.*
- **Físico:** HD mecânico sempre deitado em superfície plana e estável, nunca
  pendurado pelo cabo. Borracha/mousepad embaixo pra amortecer vibração.
- **Desmontar com segurança sempre.** O Linux faz cache de gravação em RAM — a
  barra de progresso terminar não significa que acabou de gravar.
- **Copiar com `rsync`, não arrastando no Nautilus.** 40 GB no mouse costuma
  travar a interface; o rsync mostra progresso real e retoma de onde parou:
  ```bash
  rsync -ah --progress /caminho/cartao_sd/ /caminho/hd_externo/2026/
  ```

---

## §3 — Backup 3-2-1 e o horizonte NAS *(não decidido)*

> **Esta seção é a pergunta aberta, não a resposta.** Hoje não existe estratégia
> 3-2-1 montada — o que existe é cópia fria local da biblioteca de livros (mesmo
> disco) e o Google Fotos (que é sync, não backup).

### Por que Google Fotos não é backup

Estar no Google Fotos é **sincronização**, não preservação. Conta suspensa,
hackeada, ou alguém apagando por engano = sincroniza a perda pra todos os
dispositivos. A regra que a comunidade especializada segue é **3-2-1**:

- **3** cópias dos dados;
- **2** tipos de mídia diferentes (ex: nuvem + disco físico);
- **1** cópia fora de casa (a nuvem já serve).

### Como o 3-2-1 se materializaria aqui *(a desenhar)*

Esboço, não decisão — cada linha precisa de validação:

| Camada | Temperatura | Onde | Status |
| --- | --- | --- | --- |
| Produção diária (vídeo sendo cortado) | 🔥 quente | SSD interno (238 GB NVMe), zero apego | existe |
| Arquivo doméstico ativo (fotos tratadas, cortes finais) | 🌡️ morna | futuro NAS, Immich, espelhado | **não existe** |
| Cofre desconectado (backup incremental) | 🧊 fria | HD externo na gaveta, plugado a cada 3–6 meses | HD existe, vazio, saúde não medida |
| Off-site | ☁️ nuvem | Google Fotos (fotos) + `gdrive:` via rclone (livros) | parcial |

**Rotina de cópia fria do que está na nuvem:** semestral ou anual, baixar os
originais via **Google Takeout** e salvar no HD externo (pasta `01_Smartphones/`).

**Ferramentas de backup incremental** pra camada fria: **Restic** ou **BorgBackup**
(nenhum instalado; nenhum avaliado). Decisão quando o NAS existir.

### DAS vs. NAS

| Tipo | O que é | Pra quem serve |
| --- | --- | --- |
| **DAS** | Gaveta com 2–4 baias ligada por USB-C/Thunderbolt direto no PC | Só espaço local rápido pra editar, sem acesso remoto |
| **NAS** | PC antigo/equipamento dedicado no roteador, 24h na rede | Permite que a noiva e os celulares sincronizem **mesmo com meu PC desligado** |

A pesquisa aponta **NAS** como a escolha certa pelo requisito "noiva + celulares
acessam sem depender do meu PC" — mas é `[explorar]`, não decidido.

### Requisitos técnicos levantados (hipóteses a verificar)

- **Immich** como "Google Fotos privado" — suporta vídeo DJI/GoPro e gera
  transcode pra reprodução suave no celular. Alternativa: Synology Photos (se
  hardware pronto) ou Calibre-Web/content server pros livros (§1).
- **CPU com Intel QuickSync** (Core de 7ª–10ª geração, barato em usado) — faz
  transcode 4K por hardware com consumo quase nulo. Crítico se Immich entrar.
- **Rede Gigabit por cabo (Cat 5e/6)**, nunca Wi-Fi — arquivos de 10–30 GB
  circulando com frequência.
- **RAID 1 / ZFS** pra redundância na camada morna. *Redundância não é backup* —
  protege de disco morto, não de erro humano ou ransomware; a camada fria continua
  necessária.

### Decisões que precisam de RFD quando chegar a vez

Perto (decidir já, travam trabalho concreto):

1. **Filesystem do HD externo — ext4 vs. exFAT** (`AC5`). ext4 preserva symlink
   (os álbuns) e é robusto; exFAT pluga no Windows mas perde symlink e permissão.
   Precisa ser decidido **antes de formatar**.
2. **Camada de narrativa — a foto do diário é cópia ou ponteiro?** (`AC8`).
   Decide se Obsidian embute a foto ou aponta pro acervo.

Longe (horizonte NAS, `AC10`):

3. Hardware do NAS (PC antigo reaproveitado vs. equipamento dedicado) e CPU/QuickSync.
4. SO e stack (Ubuntu Server + Immich? TrueNAS? Unraid?).
5. Esquema de redundância (RAID 1? ZFS?) — lembrando que **redundância não é
   backup**: protege de disco morto, não de erro humano ou ransomware.
6. Ferramenta de backup incremental (Restic vs. Borg) e cadência da camada fria.
7. Se o Google One 200 GB continua, cresce, ou sai de cena quando o NAS existir.

Registrar como RFD no [ROADMAP-acervo.md](../ROADMAP-acervo.md) (`AC10`), não decidir no improviso.
