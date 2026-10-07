# Backup e armazenamento

O que protege o que, e contra qual tipo de perda. Vale pro acervo todo —
[galeria](galeria.md), [biblioteca](biblioteca.md), notas, Notion.

**Fonte:** [pesquisas/2026-10-06-fotos-video-familia.md](../pesquisas/2026-10-06-fotos-video-familia.md).
**Horizonte:** [nas.md](nas.md). **Ações manuais:** [`../config.md`](../config.md).

## A distinção que resolve 90% das confusões

| | Protege de | Não protege de |
| --- | --- | --- |
| **Sync** (Google Fotos, Syncthing) | perder o aparelho | apagar por engano — **replica a perda** |
| **Redundância** (RAID, ZFS) | disco morrer | erro humano, ransomware — replica também |
| **Backup** (cópia separada, histórico) | apagar, corromper, disco morrer | só se existir de verdade e for testado |

> **Google Fotos não é backup.** Conta suspensa, invadida, ou foto apagada por
> engano = a perda sincroniza pra todos os dispositivos. **RAID também não é
> backup** — o `rm` errado replica nos dois discos na mesma hora.

## Estado hoje (2026-10-06) — e o que isso significa

```
~/Backups/
├── biblioteca-backup-2026-09-11/   2.6 GB   ⚠️ mesmo disco
└── notion-backup-2025-03/          1.8 GB   ⚠️ 19 meses de idade
```

Traduzindo o risco real:

- **Biblioteca Calibre:** cópia fria existe, mas **no mesmo disco físico**. Cobre
  "apaguei errado" e corrupção lógica. **Não cobre o SSD morrer** — aí vão as duas.
- **Notion:** única cópia, de **março/2025**. Tudo que entrou depois não tem backup.
- **Fotos:** `~/Pictures` (17 GB) tem **só** o Google Fotos como segunda via — que
  é sync, não backup. Hoje é o ponto mais exposto do acervo.
- **HD externo:** existe, vazio, antigo, **saúde nunca medida**. Não é backup de
  nada ainda.

`~/Archive` foi **eliminado em 2026-09-16**; o tier de backup deliberado é
`~/Backups/`.

## A regra 3-2-1 e como se materializa aqui

**3** cópias · **2** mídias diferentes · **1** fora de casa.

| Camada | Temperatura | Onde | Status |
| --- | --- | --- | --- |
| Produção | 🔥 quente | SSD interno (238 GB NVMe), zero apego | existe |
| Arquivo ativo | 🌡️ morna | futuro NAS com Immich, espelhado | **não existe** |
| Cofre desconectado | 🧊 fria | HD externo na gaveta, plugado a cada 3-6 meses | HD existe, não validado |
| Off-site | ☁️ nuvem | Google Fotos (fotos) + `gdrive:` rclone (livros) | parcial |

**O que falta pra isso virar verdade:** HD diagnosticado e formatado, rclone com
remote, um job agendado, e a rotina do Takeout. Nenhuma das quatro existe hoje.

## Rotinas

**Biblioteca Calibre — cópia fria manual** (feita, repetir antes de operação grande):

```bash
# Feche a GUI do Calibre antes — metadata.db consistente.
rsync -a --delete ~/Documents/livros/biblioteca/ <DESTINO>/livros-biblioteca/
```

**Off-site automatizado** (`AC4`, falta o OAuth do rclone):

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
sudo smartctl -a /dev/sdX
sudo smartctl -t long /dev/sdX      # teste longo, roda em background
sudo smartctl -l selftest /dev/sdX  # ler o resultado horas depois
```

**Os 4 números que decidem:**

| Campo | Veredito |
| --- | --- |
| `SMART overall-health` | tem que ser **PASSED** |
| `Reallocated_Sector_Ct` | **> 0 já é alerta**; dezenas = aposentar |
| `Current_Pending_Sector` / `Offline_Uncorrectable` | **qualquer valor > 0 = não confie como cópia única** |
| `Power_On_Hours` | acima de ~30-40 mil = fim de vida mesmo com PASSED |

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

**`AC5` — filesystem do HD externo: ext4 vs. exFAT.** Decidir **antes de formatar**.

| | ext4 | exFAT |
| --- | --- | --- |
| Symlink (álbuns) | **preserva** | **perde** |
| Permissão/dono | preserva | perde |
| Robustez a queda de energia | journaling avançado | frágil |
| Vídeo pesado | não fragmenta | ok |
| Windows | ilegível sem driver | **nativo** |

A pergunta que decide: **vou precisar plugar esse HD num Windows algum dia?** Se
não, ext4 ganha em tudo. NTFS está fora (driver pesado no Linux, inconsistência de
permissão).

## Caminhos de evolução

```
hoje       1 cópia fria local (mesmo disco) + sync na nuvem      ← frágil
  ↓ HD validado + formatado
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
