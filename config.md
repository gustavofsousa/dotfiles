# Config manual pendente

**Regra deste arquivo:** só entra aqui o que **estritamente depende de você** —
`sudo`, OAuth no navegador, celular na mão, hardware plugado. A IA não consegue
executar nada desta lista.

**Item feito sai daqui.** Não vira `[x]`, é removido — o histórico fica no git e
a decisão vai pro [STATE.md](STATE.md). Se o arquivo ficar vazio, nada te trava.

**O que NÃO entra aqui:** trabalho que a IA faz (vai pro [ROADMAP.md](ROADMAP.md)
ou [TODO.md](TODO.md)) e decisão/RFD que você toma sem mexer na máquina (vai pro
roadmap, no balde certo).

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

⚠️ **Nunca compartilhar `~/Documents/livros/biblioteca/`** — `metadata.db` é
SQLite vivo, sincronizar corrompe o índice.

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

O teste longo dele foi abortado em 2026-10-08 (~10% lido). Só vale se for usá-lo como
2ª cópia fria; o BLACK já está aprovado. **~110 min, disco em silêncio** — nada pode
ler ou escrever no TRANSLUCENT enquanto roda. Confirmar o device antes (`lsblk`):

- [ ] ```bash
      sudo smartctl -t long -d sat /dev/sda
      ```
- [ ] Horas depois, e me avisar para eu ler:
  ```bash
  sudo smartctl -a -d sat /dev/sda
  ```
  A linha `# 1 Extended offline` do log de testes tem que dizer
  `Completed without error`.

## 4. Configurar o rapid-photo-downloader e rodar o 1º cartão

Ferramentas instaladas em 2026-10-08; falta a configuração, que é interface gráfica
(~5 min) e o cartão da Pocket 4.

- [ ] Seguir o passo 0 do
  [cheatsheet](docs/edicao-video.md#cheatsheet-da-câmera-ao-cofre) (destino
  `~/Media/02_Cameras/Osmo_Pocket`, subpasta `YYYY/YYYY-MM`, nome `YYYY-MM-DD_HHMMSS`).
- [ ] Descarregar um cartão real e me avisar **quais extensões apareceram** na pasta
  (`find ~/Media -type f | sed 's/.*\.//' | sort | uniq -c`) — é o que confirma se a
  limpeza de `.LRV`/`.THM` basta. Aí a IA fecha o `AC3`.

## 5. Exportar o backup novo do Notion

⚠️ A única cópia (`~/Backups/notion-backup-2025-03/`, 1.8 GB) tem **19 meses**.
Export é manual na UI, não tem API que a IA chame aqui.

- [ ] Notion → Settings → **Export all workspace content** → *Markdown & CSV*,
  "Include subpages". Chega por e-mail como zip.
- [ ] Descompactar em `~/Backups/notion-backup-2026-10/` e me avisar — aí a IA
  compara com o de 2025-03 e sugere o que fazer com o antigo.

## 6. Ativar o Compartilhamento com Parceiro (Google Fotos)

- [ ] Google Fotos → Configurações → **Compartilhamento com parceiro** → convidar
  a noiva; ela marca "salvar automaticamente" do lado dela.
- [ ] Rodar um **Google Takeout** de teste (Fotos only) e cronometrar — define a
  cadência real da cópia fria no 3-2-1.

---

## Ordem

```
4 (configurar RPD + 1º cartão) ──► IA assume (AC3)
1 (Syncthing)  ─── independente
2 (rclone) ──► IA assume o timer (AC2)
3 (reteste TRANSLUCENT, opcional), 5 (Notion), 6 (Google Fotos) ─── independentes
```

**Se for fazer uma coisa só: item 4.** Destrava a ingestão do Pocket 4 (`AC3`) — e é
o que mais valida o `~/Media` e o cheatsheet na prática.

Contexto e porquê: [docs/galeria.md](docs/galeria.md).
O que falta, em ordem: [ROADMAP.md](ROADMAP.md).
