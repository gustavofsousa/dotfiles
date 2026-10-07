# NAS — o horizonte do acervo

Doc de **horizonte**: nada aqui existe ainda. Serve pra duas coisas — não tomar hoje
decisões que fechem portas, e ter as perguntas prontas quando o hardware aparecer.

**Fonte:** [pesquisas/2026-10-06-fotos-video-familia.md](../pesquisas/2026-10-06-fotos-video-familia.md).
**Hoje:** [galeria.md](galeria.md) · [biblioteca.md](biblioteca.md) · [backup.md](backup.md).

## Qual problema o NAS resolve (e qual não)

O requisito que puxa NAS é um só, e é concreto:

> **A noiva e os celulares precisam sincronizar e acessar o acervo mesmo com o meu
> PC desligado.**

Hoje isso só existe via Google Fotos — ou seja, dependendo de assinatura e de
política de terceiro. É o único motivo real; "ter um servidor" não é motivo.

O que o NAS **não** resolve: não é backup por si (ver a distinção em
[backup.md](backup.md)); RAID no NAS protege de disco morto, não do `rm` errado.
A camada fria na gaveta continua necessária depois do NAS.

## DAS vs. NAS

| | DAS | NAS |
| --- | --- | --- |
| O que é | gaveta de 2-4 baias por USB-C/Thunderbolt no PC | máquina no roteador, 24h na rede |
| Serve pra | espaço local rápido pra editar | **acesso de qualquer aparelho, PC desligado** |
| Atende o requisito acima? | não | **sim** |

**NAS é a escolha** pelo requisito declarado. DAS só entraria se o problema virasse
"preciso de disco rápido pra editar vídeo", que não é o caso hoje.

## Candidatos a avaliar *(nenhum testado)*

**Servir fotos/vídeo — Immich.** "Google Fotos privado": app Android com backup
automático, busca semântica local ("praia", "cachorro"), suporta vídeo DJI e gera
transcode pra reprodução suave no celular. Lê direto a pasta do disco, o que casa
com o princípio de que a pasta cronológica é a verdade.
*Alternativa:* Synology Photos, se o hardware vier pronto (caixa fechada, menos
trabalho, menos controle).

**Servir livros — Calibre-Web** ou o content server do próprio Calibre. O Calibre
roda num lugar só (o NAS); os clientes acessam por rede. **Nunca** sincronizar o
`metadata.db` — ver a trava em [biblioteca.md](biblioteca.md).

**Backup incremental** da camada morna pra fria — **Restic** ou **BorgBackup**.
Nenhum instalado, nenhum avaliado.

## Requisitos técnicos levantados *(hipóteses)*

- **CPU Intel com QuickSync** (Core 7ª-10ª geração, barato usado) — faz transcode
  4K por hardware com consumo quase nulo. **Crítico se Immich entrar**; sem isso o
  transcode de vídeo da Pocket derruba a máquina.
- **Rede Gigabit por cabo (Cat 5e/6), nunca Wi-Fi** — arquivos de 10-30 GB
  circulando com frequência.
- **Redundância** (RAID 1 / ZFS) na camada morna — lembrando que **não é backup**.

## As 5 perguntas que viram RFD quando o hardware aparecer

1. **Hardware** — PC antigo reaproveitado vs. equipamento dedicado? Tem QuickSync?
2. **SO e stack** — Ubuntu Server + Immich (controle, trabalho) vs. TrueNAS/Unraid
   (pronto, opinativo) vs. Synology (caixa fechada)?
3. **Redundância** — RAID 1? ZFS? Quantos discos, de que tamanho?
4. **Backup incremental** — Restic vs. Borg; e qual cadência da camada fria?
5. **Google One 200 GB** — continua, cresce, ou sai de cena quando o NAS existir?

Nenhuma dessas é urgente, e nenhuma deve ser decidida no improviso enquanto o
hardware não existir.

## O que já está sendo feito hoje pensando nisso

Decisões atuais que foram tomadas pra **não ter que migrar dado depois**:

- Estrutura do HD externo (`01_Smartphones/`, `02_Cameras/<cam>/AAAA/AAAA-MM/`) é
  plugável no NAS sem reorganizar nada.
- Pasta cronológica como verdade única — Immich e DigiKam leem pasta, não exigem
  importar pra formato proprietário.
- Álbum como visão (symlink hoje, álbum virtual depois) — a migração é trocar a
  camada de visão, não mover arquivo.
- `ext4` no HD externo (se o RFD `AC5` fechar assim) já é o filesystem do NAS Linux.

## Decisões

**2026-10-06 — NAS, não DAS.** O requisito é acesso com o PC desligado; DAS não
atende. *Consequência:* o projeto exige máquina ligada 24h, rede cabeada e um SO a
manter — custo aceito pelo requisito.

**2026-10-06 — Nada de hardware decidido por ora.** O horizonte fica documentado e
as decisões de hoje são tomadas pra não fechar portas. *Por que:* decidir hardware
antes de ter o problema é o jeito mais rápido de comprar a coisa errada.
