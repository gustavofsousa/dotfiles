# Sincronização — Syncthing e rclone/Drive

Quais ferramentas sincronizam o quê, e por quê cada uma. **Os passos de instalação e
pareamento vivem em [`../config.md`](../config.md)** (dependem de mim, saem de lá
quando feitos); aqui fica o desenho e o que foi decidido.

**Relacionado:** [backup.md](backup.md) (sync ≠ backup) ·
[biblioteca.md](biblioteca.md) (o que é sincronizado) · [nas.md](nas.md) (onde isso vai parar).

## Ferramentas no sistema

Medido em 2026-10-06. **Ambas instaladas, nenhuma configurada** — o que falta é só
ação humana ([`../config.md`](../config.md) itens 1 e 2).

| Ferramenta | Estado | Origem |
| --- | --- | --- |
| `syncthing` 1.27.2 | ✅ instalado · serviço **`disabled`/`inactive`**, `~/.config/syncthing/` não existe | apt |
| `rclone` 1.60.1 | ✅ instalado · **`listremotes` vazio** | apt |
| Syncthing-Fork (Android) | ⬜ falta — F-Droid | fora desta máquina |

**Unidade systemd já existe** mas nunca foi ligada:
`/usr/lib/systemd/user/syncthing.service` (vem no pacote). Subir com
`systemctl --user enable --now syncthing.service`.

**Personalização a preservar:**

| O que | Onde mora | Versionado? |
| --- | --- | --- |
| Device ID, pastas e peers do Syncthing | `~/.config/syncthing/config.xml` | ❌ **não** — contém chave do device e é específico da máquina |
| Remote `gdrive:` (token OAuth) | `~/.config/rclone/rclone.conf` | ❌ **nunca** — credencial |
| `syncthing.service` habilitado | estado do systemd `--user` | ⬜ candidato a linha no `bootstrap.sh` |

> 🔒 Nenhum dos dois arquivos de config entra no git: um tem credencial, o outro tem
> identidade de máquina. Em Nix/home-manager, o serviço é declarado
> (`services.syncthing.enable`) mas o pareamento continua sendo ato manual — ver
> [nix.md](nix.md).

## A regra que separa as duas

| | Syncthing | rclone → Drive |
| --- | --- | --- |
| Faz | espelha pasta entre **meus** dispositivos, P2P, contínuo | copia pasta pra nuvem, agendado |
| Serve pra | **circular arquivo** (celular ↔ PC) | **guardar cópia** off-site |
| Direção | bidirecional ou unidirecional | uma via (PC → nuvem) |
| É backup? | **não** — apagar propaga | sim, se agendado e verificado |

## Syncthing — celular ↔ PC

Duas pastas, direções opostas, **nunca a `biblioteca/`**:

| Pasta | Direção | Pra quê |
| --- | --- | --- |
| `~/Documents/livros/entrada/` | Android → PC, **bidirecional** | livro baixado no celular aparece no PC pra entrar no Calibre |
| `~/Documents/livros/para-celular/` | PC → Android, **Send Only / Receive Only** | ler no celular livro que já está na biblioteca |

> ⚠️ **Nunca compartilhar `~/Documents/livros/biblioteca/`.** O `metadata.db` é
> SQLite vivo; sincronizar em duas pontas gera `.sync-conflict` no meio do índice e
> **corrompe a biblioteca inteira**. Só pastas de cópia solta (epub/pdf sem índice)
> entram no Syncthing.

**Por que `para-celular/` é Send Only:** o celular nunca escreve de volta, o que
elimina qualquer chance de conflito mesmo se a pasta crescer. Populada via Calibre
(selecionar livros → **Save to disk**) ou `calibredb export`.

**Estado:** instalado (`v1.27.2`, apt), serviço **nunca ligado**, celular não pareado.
Passos em [`../config.md`](../config.md) item 1 (~25-35 min, pareamento manual).

## rclone → Google Drive

**Por que rclone e não GNOME Online Accounts:** GOA só monta o Drive como pasta
virtual no Nautilus/GVFS — bom pra *ver e navegar*, ruim pra *backup*: não agenda,
não sincroniza pasta local↔nuvem sozinho, e a montagem cai se a sessão gráfica cair.
O rclone roda sem sessão gráfica, agenda por systemd timer/cron, e serve tanto pra
"copiar pasta" quanto pra "sincronizar de verdade". GOA fica útil só pro uso passivo
(ver o Drive no Nautilus).

**Estado:** instalado (`v1.60.1` do apt — upstream já em v1.75, não bloqueia nada),
**sem remote configurado**, sem agendamento. O que falta é o OAuth no navegador —
[`../config.md`](../config.md) item 2 (~10 min, uma vez só).

Depois do remote existir, qualquer uso novo é só:

```bash
rclone copy <pasta-local> gdrive:backup/<nome> --progress
```

O primeiro caso concreto é a biblioteca Calibre — comando e agendamento em
[backup.md](backup.md#rotinas).

**Escopo:** este doc resolve *a ferramenta* e *o remote*. **O que** vai pro Drive é
decisão por item; o único fechado hoje é a biblioteca de livros.

## Caminhos de evolução

```
hoje     nada rodando — ambos instalados, nenhum configurado
  ↓ config.md itens 1 e 2
curto    Syncthing circulando livro celular↔PC; rclone com remote pronto
  ↓ AC2
médio    backup off-site dos livros agendado por systemd timer
  ↓ NAS (AC9)
futuro   Syncthing roda no NAS (always-on, não depende do meu PC ligado)
```

## Decisões

**2026-09-16 — Google Drive via rclone, não GNOME Online Accounts.**
GOA não agenda nem sincroniza sozinho e cai com a sessão gráfica. *Consequência:*
exige OAuth manual uma vez e um systemd timer depois — mais trabalho inicial, mas é
o único caminho que roda sem eu estar logado na interface.

**2026-09-16 — `para-celular/` como segunda via, Send Only.**
Pra ler no celular sem sincronizar a `biblioteca/`. *Rejeitado:* sincronizar a
biblioteca inteira (corromperia o `metadata.db`). *Consequência:* exportar é um passo
manual no Calibre, aceito em troca de não arriscar o índice.

**2026-10-06 — passo a passo saiu daqui pro `config.md`.**
Os dois runbooks (`syncthing.md` + `google-drive-rclone.md`) duplicavam o checklist.
*Por que:* instrução de ação humana tem um lugar só — o `config.md`, que esvazia
quando a tarefa é feita. Este doc guarda o desenho, que é permanente.
