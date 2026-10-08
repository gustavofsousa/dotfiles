# Backup e armazenamento

O que protege o que, e contra qual tipo de perda. Vale pro acervo todo —
[galeria](galeria.md), [biblioteca](biblioteca.md), notas, Notion.

**Fonte:** [pesquisas/2026-10-06-fotos-video-familia.md](../pesquisas/2026-10-06-fotos-video-familia.md).
**Horizonte:** [nas.md](nas.md). **Ações manuais:** [`../config.md`](../config.md).

## Ferramentas no sistema

Medido em 2026-10-06; `smartctl` e `rsync` reconfirmados em 2026-10-08.

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| `smartctl` 7.4 | diagnóstico SMART de disco (HD em caixa USB exige `-d sat`) | ✅ | apt (`smartmontools`) |
| `rsync` 3.2.7 | cópia fria com `--delete`, progresso, retomada | ✅ | apt |
| `rclone` 1.60.1 | backup off-site pro Drive | ✅ instalado, **sem remote** | apt |
| **Restic** ou **BorgBackup** | backup incremental da camada morna pra fria | ⬜ **falta** — nenhum escolhido | decisão do NAS ([nas.md](nas.md)) |

`smartctl`, `rsync` e `ffmpeg` estão registrados como **dependências recomendadas** no
[`bootstrap.sh`](../bootstrap.sh) — avisa se faltarem, não aborta. É o que faz voltarem
sozinhas em máquina nova e virarem pacote declarado no Nix.

> O `rclone` do apt é **v1.60.1**, enquanto o upstream já vai em v1.75. Não bloqueia
> nada no fluxo atual; só significa que provedor/flag muito recente pode faltar. Se
> precisar: `curl https://rclone.org/install.sh | sudo bash` (substitui o do apt — e
> aí sai do controle do apt/Nix, decisão a registrar).

**Personalização a preservar:**

| O que | Onde mora | Versionado? |
| --- | --- | --- |
| Remote `gdrive:` (token OAuth) | `~/.config/rclone/rclone.conf` | ❌ **nunca** — contém credencial |
| Timer/service do backup | `~/.config/systemd/user/` | ⬜ não existe ainda; **candidato a pacote Stow** quando `AC2` for feito |
| Cofre frio `BLACK` (exFAT, rótulo `BLACK`, estrutura `Pictures/` · `00_legado-translucid/` · `01_Smartphones/` · `02_Cameras/`) | no disco | — decidido em 2026-10-08, ver Decisões |

> 🔒 `rclone.conf` tem token de acesso ao Drive. **Não versionar.** Se um dia a
> config de serviços entrar no Stow/Nix, o arquivo de credencial fica fora
> (gestão de segredos é RFD aberto em [nix.md](nix.md)).

## A distinção que resolve 90% das confusões

| | Protege de | Não protege de |
| --- | --- | --- |
| **Sync** (Google Fotos, Syncthing) | perder o aparelho | apagar por engano — **replica a perda** |
| **Redundância** (RAID, ZFS) | disco morrer | erro humano, ransomware — replica também |
| **Backup** (cópia separada, histórico) | apagar, corromper, disco morrer | só se existir de verdade e for testado |

> **Google Fotos não é backup.** Conta suspensa, invadida, ou foto apagada por
> engano = a perda sincroniza pra todos os dispositivos. **RAID também não é
> backup** — o `rm` errado replica nos dois discos na mesma hora.

## Estado hoje (2026-10-08) — e o que isso significa

```
~/Backups/
├── biblioteca-backup-2026-09-11/   2.6 GB   ⚠️ mesmo disco
└── notion-backup-2025-03/          1.8 GB   ⚠️ 19 meses de idade

BLACK  (HD externo, exFAT, 466 GB, 38 GB usados)
├── Pictures/                 17 GB   espelho de ~/Pictures em 2026-10-08
├── 00_legado-translucid/     22 GB   dump bruto do HD antigo, como veio
├── 01_Smartphones/                   vazio — dumps do Google Takeout
└── 02_Cameras/Osmo_Pocket/           vazio — ingestão da câmera
```

Traduzindo o risco real:

- **Biblioteca Calibre:** cópia fria existe, mas **no mesmo disco físico**. Cobre
  "apaguei errado" e corrupção lógica. **Não cobre o SSD morrer** — aí vão as duas.
- **Notion:** última versão é de **março/2025**; tudo que entrou depois não tem
  backup. Dois zips do mesmo mês também estão em `BLACK/00_legado-translucid/`
  (provavelmente o mesmo export — não comparei).
- **Fotos:** `~/Pictures` agora tem cópia fria no BLACK (**espelho manual**, verificado
  por checksum em 2026-10-08) além do Google Fotos (sync, não backup). Cada foto nova
  fica sem cópia fria até alguém rodar a rotina de espelho.
- **BLACK:** aprovado no SMART, ver [Diagnóstico medido](#diagnóstico-medido-2026-10-08).
- **TRANSLUCENT** (o HD antigo de onde veio o legado): 22 GB de dados do Gustavo,
  **sem veredito de superfície**. Não faz parte do 3-2-1.
- **Dump do TRANSLUCENT:** vive no próprio TRANSLUCENT e em
  `BLACK/00_legado-translucid/` (checksum idêntico). A cópia intermediária no SSD
  (`~/media/backup-translucid/`) foi apagada em 2026-10-08; os 14 arquivos soltos da
  raiz dela (3,2 GB: zips, PDFs, 2 vídeos, `IMG_*`, os 2 zips do Notion) foram para
  `~/Downloads/` aguardando revisão — as cópias deles continuam no legado do BLACK.

`~/Archive` foi **eliminado em 2026-09-16**; o tier de backup deliberado é
`~/Backups/`.

## A regra 3-2-1 e como se materializa aqui

**3** cópias · **2** mídias diferentes · **1** fora de casa.

| Camada | Temperatura | Onde | Status |
| --- | --- | --- | --- |
| Produção | 🔥 quente | SSD interno (238 GB NVMe), zero apego | existe |
| Arquivo ativo | 🌡️ morna | futuro NAS com Immich, espelhado | **não existe** |
| Cofre desconectado | 🧊 fria | BLACK (exFAT) na gaveta, plugado a cada 3-6 meses | ✅ validado em 2026-10-08; conteúdo é espelho manual |
| Off-site | ☁️ nuvem | Google Fotos (fotos) + `gdrive:` rclone (livros) | parcial |

**O que falta pra isso virar verdade:** rclone com remote, um job agendado, a rotina
do Takeout e uma rotina de atualizar o espelho do BLACK. O HD diagnosticado e com
estrutura já existe (2026-10-08).

## Rotinas

**Biblioteca Calibre — cópia fria manual** (feita, repetir antes de operação grande):

```bash
# Feche a GUI do Calibre antes — metadata.db consistente.
rsync -a --delete ~/Documents/livros/biblioteca/ <DESTINO>/livros-biblioteca/
```

**Fotos — espelho pro cofre BLACK** (manual, com o HD plugado):

```bash
# exFAT não guarda dono nem permissão: -rt, sem -a. Sem --delete de propósito —
# foto apagada por engano no SSD não deve sumir do cofre; limpar o cofre é manual.
rsync -rt --no-perms --no-owner --no-group ~/Pictures/ /media/gustavo/BLACK/Pictures/
# conferir: lista vazia = idêntico
rsync -rc -n -i --no-perms --no-owner --no-group --modify-window=2 \
  ~/Pictures/ /media/gustavo/BLACK/Pictures/
```

**Off-site automatizado** (`AC2`, falta o OAuth do rclone):

```bash
rclone config    # remote "gdrive" tipo drive — OAuth no navegador, uma vez
rclone copy ~/Documents/livros/biblioteca gdrive:backup/livros-biblioteca --progress
```

Depois: systemd timer `--user`. Runbook: [sincronizacao.md](sincronizacao.md).
GNOME Online Accounts serve só pra **ver** o Drive no Nautilus, não pra backup.

**Fotos da nuvem pro frio** — Google Takeout semestral ou anual → `01_Smartphones/`
no HD externo. Cadência se define medindo quanto tempo leva (`config.md`).

**Notion** — export manual na UI (Settings → Export all workspace content →
Markdown & CSV) → `~/Backups/notion-backup-AAAA-MM/`.

## Diagnosticar o HD antes de confiar nele

`smartmontools 7.4` instalado ✓. Um HD antigo sem SMART lido é o pior lugar possível
pra "cópia de segurança".

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL,TRAN   # achar o device
sudo smartctl -a -d sat /dev/sdX    # -d sat: a ponte USB não passa o SMART sem isso
sudo smartctl -t long -d sat /dev/sdX      # teste longo, roda em background
sudo smartctl -a -d sat /dev/sdX    # horas depois: o log de testes vem junto
```

> ⚠️ **Teste longo exige disco quieto.** Em 2026-10-08 o do TRANSLUCENT foi
> `Aborted by host` com ~10% lido, depois de uma cópia e um checksum lendo o mesmo
> disco (causa provável, não confirmada). O "PASSED" atrás de ponte USB vem de checagem
> de atributos (`SMART Status not supported`) — serve, mas só o teste longo lê a
> superfície inteira e acha setor ruim latente. Leitura da coluna final do log:
> `Remaining` é o que **faltava**, não o que foi lido (`90%` = parou cedo).

**Os 4 números que decidem:**

| Campo | Veredito |
| --- | --- |
| `SMART overall-health` | tem que ser **PASSED** |
| `Reallocated_Sector_Ct` | **> 0 já é alerta**; dezenas = aposentar |
| `Current_Pending_Sector` / `Offline_Uncorrectable` | **qualquer valor > 0 = não confie como cópia única** |
| `Power_On_Hours` | acima de ~30-40 mil = fim de vida mesmo com PASSED |

### Diagnóstico medido (2026-10-08)

Dois Seagate/Samsung SpinPoint M8 `ST500LM012` (2,5", 5400 rpm, 500 GB), mesmo modelo.

| | **BLACK** | **TRANSLUCENT** |
| --- | --- | --- |
| Overall-health | PASSED | PASSED |
| Realocados · pendentes · incorrigíveis | 0 · 0 · 0 | 0 · 0 · 0 |
| `UDMA_CRC` · log de erros | 0 · vazio | 0 · vazio |
| `Power_On_Hours` | 1.841 h | 9.987 h |
| `Load_Cycle_Count` (nota normalizada) | 16.370 (99/100) | 152.965 (85/100) |
| `G-Sense_Error_Rate` (choques) | 72 | 290 |
| Temperatura máxima já registrada | 58 °C | 53 °C |
| **Teste longo** | ✅ `Completed without error` | ⚠️ `Aborted by host`, ~10% lido |
| **Veredito** | **aprovado como cofre frio** | **sem veredito de superfície** |

`Raw_Read_Error_Rate` e `Multi_Zone_Error_Rate` têm raw alto no TRANSLUCENT (1993 e
122.479) com nota normalizada 100/100 — nesse modelo o raw é específico do fabricante;
não tratei como alarme (confiança média). Para dar veredito ao TRANSLUCENT: repetir o
teste longo (~110 min) **sem ler o disco** durante ele.

## Ergonomia do HD externo

- **Físico:** sempre deitado em superfície plana, nunca pendurado pelo cabo.
  Borracha/mousepad amortece vibração.
- **Desmontar com segurança sempre.** O Linux faz cache de escrita em RAM — barra
  de progresso cheia não significa que acabou de gravar.
- **Copiar com `rsync`, não arrastando no Nautilus** — 40 GB no mouse travam a
  interface; o rsync mostra progresso real e retoma de onde parou:
  ```bash
  rsync -ah --progress /caminho/cartao_sd/ /caminho/hd_externo/2026/
  ```

## RFD em aberto

Nenhum. `AC5` (filesystem do HD externo) foi decidido em 2026-10-08 — ver Decisões.

## Caminhos de evolução

```
hoje       cofre frio manual (BLACK, fotos) + biblioteca no mesmo disco + sync   ← parcial
  ↓ rclone com remote + rotina de atualizar o espelho
curto      camada fria real na gaveta + off-site dos livros      ← 3-2-1 de pé
  ↓ NAS existir
futuro     camada morna espelhada; backup incremental (Restic/Borg)
           do NAS pro HD a cada 3-6 meses
```

## Decisões

**2026-09-16 — Google Drive via rclone, não GNOME Online Accounts.**
GOA só monta pasta virtual pra navegar; não agenda, não sincroniza sozinho, cai com
a sessão gráfica. rclone roda sem sessão, agenda por systemd/cron.

**2026-09-16 — `~/Archive` eliminado; `~/Backups` é o tier único.**
Dois tiers pra "guardar coisa" geravam dúvida sobre onde pôr. Backup deliberado tem
um lugar só.

**2026-10-06 — Redundância não entra como cópia do 3-2-1.**
Contra a sugestão da pesquisa de contar RAID/ZFS como camada. RAID protege de disco
morto, não de erro humano — a camada fria desconectada continua obrigatória.

**2026-10-06 — Diagnosticar o HD é pré-requisito, não etapa paralela.**
Nada é arquivado nele antes do SMART. *Por que:* arquivar primeiro e descobrir
depois que o disco está morrendo é perder o trabalho e a confiança na cópia.

**2026-10-08 — Cofre frio em exFAT (BLACK), sem `03_Albuns/`.**
A pergunta que decidia (*vou plugar num Windows?*) foi respondida: pelo menos um HD
precisa abrir no Windows. Symlink de álbum deixou de pesar — não há álbum hoje. Só um
HD é backup; o outro não precisa espelhar. *Rejeitado:* ext4 (preserva symlink e é mais
robusto a queda de energia, mas não abre no Windows sem driver); NTFS (já fora).
*Consequência:* álbum, se um dia existir, vive no SSD e sai com `rsync -aL`; exFAT é
frágil a queda de energia, então **desmontar sempre antes de desplugar**; o BLACK já
vinha em exFAT e vazio, então **não foi preciso formatar**.

**2026-10-08 — BLACK é o cofre; TRANSLUCENT fica fora do 3-2-1 até ter veredito.**
BLACK: 1.841 h, 16 mil ciclos de cabeça, teste longo sem erro. TRANSLUCENT: 9.987 h,
153 mil ciclos, teste abortado. *Por que não usar os dois:* um cofre validado vale mais
que dois pela metade; o TRANSLUCENT só entra como 2ª cópia se o reteste passar.
*Consequência:* o dump dele foi copiado para `BLACK/00_legado-translucid/` (bruto,
checksum idêntico) antes de qualquer decisão sobre o disco antigo.

**2026-10-08 — As fotos que só existiam no HD antigo não voltam pro acervo.**
Comparando tamanho + data EXIF, 92% da mídia do TRANSLUCENT (1.521 de 1.652) já estava
no `~/Pictures`; as 131 restantes são fotos apagadas de propósito. *Consequência:*
`~/Pictures` não recebe mesclagem; elas seguem só no legado bruto.
