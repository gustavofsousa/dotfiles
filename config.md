# Config manual pendente

**Regra deste arquivo:** só entra aqui o que **depende estritamente de você**: `sudo`, OAuth no
navegador, celular na mão, hardware plugado. A IA não consegue executar nada desta lista.

**Item feito sai daqui.** Ele não vira `[x]`: ele é removido. O histórico fica no git, e a decisão vai
para o [STATE.md](STATE.md). Se o arquivo ficar vazio, nada te trava.

**O que NÃO entra aqui:**

- Trabalho que a IA faz. Vai para o [ROADMAP.md](ROADMAP.md) ou o [TODO.md](TODO.md).
- Decisão ou RFD que você toma sem mexer na máquina. Vai para o roadmap, no balde certo.

---

## 1. Syncthing — parear Android ↔ PC

Serviço `disabled`/`inactive`, sem `~/.config/syncthing/`. **~25-35 min.**

- [ ] Subir o serviço no PC:
  ```bash
  systemctl --user enable --now syncthing.service
  ```
  Abrir `http://127.0.0.1:8384` e completar o setup inicial.
- [ ] Instalar **Syncthing-Fork** no Android (F-Droid) ou *Syncthing* (Play Store).
- [ ] Parear: na UI do PC **Add Remote Device**; no Android abrir o QR do device;
  confirmar **nos dois lados**.
- [ ] Compartilhar `~/Documents/livros/entrada/` (bidirecional) e
  `~/Documents/livros/para-celular/` (**Send Only** no PC / **Receive Only** no
  Android).
- [ ] Verificar: epub baixado no celular aparece em `entrada/`; livro exportado do
  Calibre pra `para-celular/` aparece no celular.

WARNING: **Nunca compartilhe `~/Documents/livros/biblioteca/`.** O `metadata.db` é SQLite vivo. A
sincronização corrompe o índice.

Passo a passo: [docs/sincronizacao.md](docs/sincronizacao.md).

## 2. rclone → Google Drive — criar o remote (OAuth)

`rclone listremotes` vazio. **~10 min, OAuth único.**

- [ ] `rclone config` → remote `gdrive` tipo *drive* → `client_id`,
  `client_secret`, `root_folder_id` em branco → scope `1` → *Use auto config* `y`
  → autorizar com `gustavofsousa.me@gmail.com`.
- [ ] Verificar: `rclone listremotes` mostra `gdrive:`; `rclone lsd gdrive:` lista
  as pastas.

Passo a passo: [docs/sincronizacao.md](docs/sincronizacao.md).

> Depois disso a IA assume: criar o systemd timer do backup é trabalho dela
> (`AC2` no [ROADMAP.md](ROADMAP.md)), não seu.

## 3. Reteste do SMART do TRANSLUCENT *(opcional)*

O teste longo abortou **duas vezes** em 2026-10-08 (<10% lido em cada). Só vale repetir se o disco
for a 2ª cópia fria. O BLACK já está aprovado. **~110 min, disco em silêncio.**

CAUTION: Depois do início, nada pode falar com o TRANSLUCENT: nem `smartctl`, nem montar, nem
desmontar. Qualquer acesso aborta o teste. **Desmonte antes de iniciar**, não depois.

- [ ] Confirmar o device (`lsblk`, que não toca o disco), desmontar e calar o `smartd`
  (ele consulta SMART a cada ~30 min e pode abortar o teste):
  ```bash
  udisksctl unmount -b /dev/sda1
  sudo systemctl stop smartmontools
  ```
- [ ] Iniciar e **largar o disco em paz**:
  ```bash
  sudo smartctl -t long -d sat /dev/sda
  ```
- [ ] Depois de 110 min, uma única leitura, e religar o `smartd`:
  ```bash
  sudo smartctl -a -d sat /dev/sda > /tmp/claude-1000/-home-gustavo-projects--hq/ca357f24-2216-4b81-b410-451421528cd3/scratchpad/smart4-translucent.txt
  sudo systemctl start smartmontools
  ```
  A linha `# 1 Extended offline` do log deve dizer `Completed without error`. Se o teste abortar de
  novo, rode a leitura completa `sudo badblocks -sv -b 4096 /dev/sda` (~2 h, só leitura). Ela dá o
  veredito de superfície sem depender do teste do disco.

## 4. Configurar o rapid-photo-downloader e rodar o 1º cartão

As ferramentas foram instaladas em 2026-10-08. Faltam a configuração, que é interface gráfica
(~5 min), e o cartão da Pocket 4.

- [ ] Seguir o passo 0 do
  [cheatsheet](docs/edicao-video.md#cheatsheet-da-câmera-ao-cofre) (destino
  `~/Media/02_Cameras/Osmo_Pocket`, subpasta `YYYY/YYYY-MM`, nome `YYYY-MM-DD_HHMMSS`).
- [ ] Descarregar um cartão real e avisar **quais extensões apareceram** na pasta
  (`find ~/Media -type f | sed 's/.*\.//' | sort | uniq -c`). Isso confirma se a limpeza de
  `.LRV`/`.THM` basta. Depois a IA fecha o `AC3`.

## 5. Exportar o backup novo do Notion

CAUTION: A única cópia (`~/Backups/notion-backup-2025-03/`, 1.8 GB) tem **19 meses**. O que mudou
depois dela não tem backup.

O export é manual na UI. Não há API que a IA chame aqui.

- [ ] Notion → Settings → **Export all workspace content** → *Markdown & CSV*,
  "Include subpages". Chega por e-mail como zip.
- [ ] Descompactar em `~/Backups/notion-backup-2026-10/` e avisar. Depois a IA compara com o de
  2025-03 e sugere o que fazer com o antigo.

## 6. Ativar o Compartilhamento com Parceiro (Google Fotos)

- [ ] Google Fotos → Configurações → **Compartilhamento com parceiro** → convidar
  a noiva; ela marca "salvar automaticamente" do lado dela.
- [ ] Rodar um **Google Takeout** de teste (Fotos only) e cronometrar. O tempo define a cadência
  real da cópia fria no 3-2-1.

---

## Ordem

```
4 (configurar RPD + 1º cartão) ──► IA assume (AC3)
1 (Syncthing)  ─── independente
2 (rclone) ──► IA assume o timer (AC2)
3 (reteste TRANSLUCENT, opcional), 5 (Notion), 6 (Google Fotos) ─── independentes
```

**Se for fazer uma coisa só: item 4.** Ele destrava a ingestão do Pocket 4 (`AC3`). É também o que
mais valida o `~/Media` e o cheatsheet na prática.

Contexto e porquê: [docs/galeria.md](docs/galeria.md).
O que falta, em ordem: [ROADMAP.md](ROADMAP.md).
