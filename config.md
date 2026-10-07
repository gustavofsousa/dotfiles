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

## 3. Plugar o HD externo e rodar o SMART

`smartmontools 7.4` já instalado ✓. Falta **plugar o HD** — ele não estava
conectado em 2026-10-06, então nada foi medido. **~20 min** (+ horas do teste
longo, que roda sozinho).

- [ ] Plugar o HD e descobrir o device:
  ```bash
  lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL,TRAN
  ```
- [ ] Ler a saúde e **me mandar a saída** (a IA interpreta os números):
  ```bash
  sudo smartctl -a /dev/sdX   # trocar X
  ```
  O que decide: `overall-health` = **PASSED**; `Reallocated_Sector_Ct`,
  `Current_Pending_Sector` e `Offline_Uncorrectable` = **0** (qualquer valor > 0
  nos dois últimos = não confie nele como cópia única); `Power_On_Hours` acima de
  ~30-40 mil = fim de vida mesmo com PASSED.
- [ ] Rodar o teste longo (lê a superfície inteira, roda em background):
  ```bash
  sudo smartctl -t long /dev/sdX
  sudo smartctl -l selftest /dev/sdX   # consultar horas depois
  ```
- [ ] Formatar depois que o filesystem for decidido (é RFD — `AC5`): **ext4**
  (só Linux) vs **exFAT** (plugar no Windows).

> Isto destrava a ingestão do Pocket 4 (`AC3`) e o desenho do 3-2-1 (`AC6`).

## 4. Instalar as ferramentas de ingestão (precisa de `sudo`)

Só a instalação é sua; configurar e validar o fluxo é trabalho da IA (`AC3`).

- [ ] ```bash
      sudo apt install rapid-photo-downloader
      flatpak install flathub no.mifi.losslesscut
      ```

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
3 (plugar HD + SMART) ──► 4 (instalar ingestão) ──► IA assume (AC3)
                     └──► destrava o 3-2-1 (AC6)
1 (Syncthing)  ─── independente
2 (rclone) ──► IA assume o timer (AC2)
5 (Notion), 6 (Google Fotos) ─── independentes
```

**Se for fazer uma coisa só: item 3.** Destrava os outros dois e responde "esse
HD antigo presta?".

Contexto e porquê: [docs/galeria.md](docs/galeria.md).
O que falta, em ordem: [ROADMAP.md](ROADMAP.md).
