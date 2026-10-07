> **Arquivado 2026-10-06.** Runbook de configuração do rclone + Google Drive.
>
> **Colhido para:** o passo a passo (OAuth) virou o item 2 do
> [`config.md`](../config.md); a decisão "rclone, não GNOME Online Accounts" com o
> porquê completo foi pra [`docs/sincronizacao.md`](../docs/sincronizacao.md); o
> comando de backup da biblioteca está em [`docs/backup.md`](../docs/backup.md).
>
> *Motivo da saída:* mesma duplicação do runbook do Syncthing.

---

# Google Drive via rclone

Decisão (2026-09-16): Google Drive no Ubuntu via **rclone**, não GNOME Online
Accounts (GOA). Fecha o item `[pc]` do [ROADMAP.md](../ROADMAP.md).

## Por quê rclone, não GOA

GOA (Configurações > Contas Online) só monta o Drive como pasta virtual no
Nautilus/GVFS — bom pra *ver e navegar* arquivos, ruim pra *backup*: não
agenda, não sincroniza pasta local↔nuvem sozinho, e a montagem cai se a sessão
gráfica cair. `rclone` é uma ferramenta de linha de comando que fala com
dezenas de provedores de nuvem (Drive incluso), roda sem sessão gráfica,
agenda via systemd timer/cron, e serve tanto pra "copiar uma pasta pro Drive"
quanto pra "sincronizar de verdade" — mais completo pro caso de backup.

## O que já está no computador (checado em 2026-09-16)

- ✅ **rclone instalado**: `v1.60.1-DEV` via apt (pacote `noble` do Ubuntu
  24.04). Funcional, mas é uma versão antiga — o upstream já vai em `v1.75.1`.
  Não bloqueia o uso; só significa que provedores/flags muito recentes podem
  faltar. Upgrade é opcional (ver [Passo 0](#passo-0-opcional-atualizar-o-rclone)).
- ⬜ **Nenhum remote configurado** — `rclone listremotes` vem vazio,
  `~/.config/rclone/rclone.conf` não existe ainda. Isso é o que falta: criar o
  remote do Drive exige autorizar no navegador com a tua conta Google, e só
  você pode fazer esse OAuth (a IA não tem acesso à tua sessão de browser).
- ⬜ **Nenhum agendamento existe** — nem systemd timer, nem cron, pra rodar
  backup sozinho.

## O que só você (humano) pode fazer

### Passo 0 (opcional): atualizar o rclone

Se quiser a versão mais nova em vez da do apt (`v1.60.1`):

```bash
sudo -v && curl https://rclone.org/install.sh | sudo bash
```

Script oficial do próprio rclone; baixa o binário estático mais recente pra
`/usr/bin/rclone`, substituindo o do apt. Pode pular esse passo — a versão do
apt funciona pro fluxo abaixo.

### Passo 1: criar o remote do Drive (OAuth — precisa de você)

```bash
rclone config
```

Fluxo interativo:

1. `n` (new remote) → nome: `gdrive`
2. Tipo: procurar `drive` na lista (Google Drive) e digitar o número
   correspondente
3. `client_id` e `client_secret`: deixar em branco (Enter), usa as
   credenciais padrão do rclone
4. `scope`: `1` (acesso completo de leitura/escrita) — ou `2` se quiser só
   acesso a arquivos que o próprio rclone criar
5. `root_folder_id` e `service_account_file`: deixar em branco
6. `Edit advanced config?`: `n`
7. `Use auto config?`: **`y` se estiver numa máquina com navegador** (o caso
   daqui) — abre o navegador, pede login com `gustavofsousa.me@gmail.com` e
   autoriza. Se fosse SSH sem navegador, seria `n` (fluxo manual com link).
8. Confirmar e `q` pra sair do config.

Verificar que funcionou:

```bash
rclone listremotes        # deve mostrar "gdrive:"
rclone lsd gdrive:         # lista as pastas do Drive raiz
```

**Tempo estimado: ~10 min, é OAuth único** (o token fica salvo em
`~/.config/rclone/rclone.conf` e renova sozinho depois).

### Passo 2: primeiro uso — copiar uma pasta de teste

```bash
rclone copy ~/Documents/algum-arquivo-pequeno gdrive:backup/teste --progress
```

Confere no Drive (web) que a pasta `backup/teste` apareceu. Depois disso o
remote `gdrive:` está pronto pra qualquer uso — o caso concreto já desenhado
hoje é o **backup da biblioteca Calibre**, com o comando exato em
[`backup.md`](backup.md#rotinas).

### Passo 3 (depois que Passo 1 existir): agendar

Ainda não desenhado em detalhe — ideia geral, decisão de quando fica pra
depois do remote existir:

```bash
# exemplo de unidade systemd --user, criar quando for a hora:
# ~/.config/systemd/user/rclone-backup.timer (OnCalendar=daily, por exemplo)
# ~/.config/systemd/user/rclone-backup.service (ExecStart=rclone copy <origem> gdrive:backup/<nome>)
```

## Escopo: o que sincronizar

Esta doc resolve **a ferramenta** (rclone) e **o remote** (`gdrive:`). *O
que* especificamente vai pro Drive (só a biblioteca? outras pastas?) é decisão
separada, item por item — o único caso já fechado é a biblioteca Calibre (ver
link do Passo 2). Novo uso = só rodar `rclone copy <pasta> gdrive:backup/<nome>`
com o remote já pronto, sem reconfigurar nada.
