# Syncthing — sincronização celular ↔ PC

Fecha o item `[pc]` do [ROADMAP.md](../ROADMAP.md). Uso concreto já desenhado
hoje: **Android ↔ PC, só `~/Documents/livros/entrada/`** (nunca a
`biblioteca/` — ver a trava crítica abaixo). Desenho completo e contexto de
por quê em
[`_hq/infra/livros-backup-sync.md`](../../_hq/infra/livros-backup-sync.md);
esta doc é o runbook de instalação/pareamento em si.

## O que já está no computador (checado em 2026-09-16)

- ✅ **Syncthing instalado**: `v1.27.2` via apt (pacote `noble` do Ubuntu
  24.04, com patch de segurança ESM).
- ✅ **Unidade systemd de usuário existe** (`/usr/lib/systemd/user/syncthing.service`,
  vem no pacote), mas está **`disabled`** — nunca foi ligada.
- ⬜ **Nunca rodou** — sem `~/.config/syncthing/`, sem device ID gerado, sem
  pasta compartilhada.
- ⬜ **Celular não pareado** — precisa instalar o app Syncthing no Android e
  parear via QR code, ação só seu (a IA não tem acesso ao teu celular).

## O que só você (humano) pode fazer

### Passo 1: subir o Syncthing no PC pela primeira vez

```bash
systemctl --user enable --now syncthing.service
```

Sobe em background e já fica ligado no login. A UI web abre em
`http://127.0.0.1:8384` (abrir no navegador manualmente na primeira vez pra
completar o setup inicial — Syncthing pede confirmação de algumas configs de
segurança na primeira execução).

Alternativa sem systemd (só pra testar, roda em primeiro plano):

```bash
syncthing
```

### Passo 2: instalar no Android

**Syncthing-Fork** via F-Droid (mais mantido que o app oficial na Play
Store) — ou *Syncthing* direto na Play Store se preferir não usar F-Droid.

### Passo 3: parear os dois dispositivos

1. Na UI web do PC (`http://127.0.0.1:8384`): **Add Remote Device**
2. No Android, abrir o QR code do device (Settings → mostrar ID) e escanear
   pelo PC, ou colar o Device ID manualmente
3. Confirmar a conexão **nos dois lados** (o Android também vai perguntar se
   aceita o PC como device conhecido)

### Passo 4: compartilhar só a pasta certa

1. No PC, na UI web: **Add Folder** → path `~/Documents/livros/entrada/`
2. Em **Sharing**, marcar o device do Android
3. No Android: aceitar a pasta compartilhada, escolher onde ela fica no
   armazenamento do celular (ex: pasta de Downloads do app de leitura)

> ⚠️ **Nunca compartilhar `~/Documents/livros/biblioteca/`.** O `metadata.db`
> do Calibre é SQLite vivo — sincronizar em duas pontas gera conflito
> (`.sync-conflict`) no meio do índice e corrompe a biblioteca inteira. Só
> `entrada/` (pequena, volátil, pensada pra isso) entra no Syncthing. Backup
> da biblioteca é outro mecanismo — ver
> [`docs/google-drive-rclone.md`](google-drive-rclone.md).

**Tempo estimado: ~20-30 min na primeira vez** (a maior parte é o pareamento
manual nas duas pontas).

### Verificar que está funcionando

Baixar um epub de teste no celular pra pasta compartilhada → checar que
aparece em `~/Documents/livros/entrada/` no PC em segundos.

## Depois de configurado

Fluxo normal: baixar livro no Android → aparece em `entrada/` no PC →
importar pro Calibre (`biblioteca/`) → pode apagar de `entrada/` (staging,
não é o lugar definitivo).
