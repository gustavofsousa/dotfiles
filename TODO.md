# TODO

> **Nota (consolidação HQ, 2026-09-10):** o [ROADMAP.md](ROADMAP.md) foi reescrito no formato
> Now/Next/Soon/Later e **absorveu estas pendências nos baldes** — ele é agora o painel único.
> Este TODO fica como detalhamento/rascunho; ao mexer numa pendência, atualize o ROADMAP (fonte da
> vista) para os dois não divergirem. Nada aqui é fonte da verdade sozinho.

Este arquivo reúne pendências do repo e da organização do computador. Nem toda
tarefa vira um arquivo commitado. Ver [ROADMAP.md](ROADMAP.md) para como
essas pendências se encaixam no plano até Nix (fases 0–3).

## Repo

> Fechamento da **Fase 2** do ROADMAP (deixar o Stow limpo) — tudo concluído.

- [x] Reduzir os binários vendorizados em `fonts/` — feito 2026-09-16:
      `install-fonts.sh` baixa JetBrainsMono + Symbols Nerd Font em build-time
      (releases oficiais, pinado em `v3.5.1`); 232MB de `.ttf` removidos do git.
- [x] Decidir o `zen/` — feito 2026-09-16: guarda o tema (ZenMods) via
      `zen/theme/` + `export-theme.sh`/`apply-theme.sh`. Sessão/histórico/senhas
      ficam de fora (sincroniza pelo próprio login Zen Account).
- [x] Criar scripts de bootstrap para symlinks e dependências de uma máquina
      nova — feito 2026-09-11 (`bootstrap.sh`, idempotente, dry-run por padrão).
- [x] Mover pacotes de config largados (Sway/waybar/yambar/xremap, inativos no
      GNOME) pra `attic/` — feito 2026-09-11 (commit `02936fa`), arquivados sem
      perder, conforme padrão do sótão.

## Computador

> Estes itens envolvem decisão de onde arquivos moram — parte da **Fase 1**
> do ROADMAP (decidir área por área, aplicando o padrão da Fase 0).

- [ ] Revisar os atalhos de teclado do Zen Browser, GNOME, VS Code, terminal,
      Dolphin e outros aplicativos usados no dia a dia.
- [ ] **Syncthing — nunca rodou.** Instalado (`v1.27.2`, apt) mas serviço
      `disabled`/`inactive`, sem `~/.config/syncthing/`. Falta: `systemctl
      --user enable --now syncthing.service` → completar setup na UI web
      (`http://127.0.0.1:8384`) → instalar Syncthing-Fork no Android → parear
      por QR → compartilhar `~/Documents/livros/entrada/` (bidirecional) e
      `~/Documents/livros/para-celular/` (Send Only no PC). **Nunca**
      `biblioteca/` (metadata.db do Calibre corrompe com sync). Runbook:
      [docs/sincronizacao.md](docs/sincronizacao.md); desenho completo em
      [`docs/backup.md`](docs/backup.md).
      *(~25-35 min, só humano — pareamento manual)*
- [ ] **rclone → Drive — remote não criado.** `rclone listremotes` vazio.
      Falta: `rclone config` → novo remote `gdrive` tipo *drive* → OAuth no
      navegador com `gustavofsousa.me@gmail.com`. Depois, agendar
      `rclone copy ~/Documents/livros/biblioteca gdrive:backup/livros-biblioteca`
      via systemd timer/cron. *(~10 min OAuth + ~15 min agendamento, só
      humano)*. Ver [`docs/backup.md`](docs/backup.md).
- [ ] Ajustar os backups do Notion.
- [x] Anotações — **local decidido** (2026-09-11): guarda-chuva
      `~/Documents/notas-pkm/` com Logseq+Obsidian juntos. Ver
      `docs/notas-pkm.md`. Resta explorar qual serve melhor à IA.
- [x] Livros/Calibre — **local decidido** (2026-09-11):
      `~/Documents/livros/{biblioteca,entrada}`; Calibre GUI + calibre-mcp
      reapontados. Ver `docs/biblioteca.md`.
- [x] Faxina de restos — feito 2026-09-11:
      - `metadata.db` + `metadata_db_prefs_backup.json` avulsos (índice Calibre
        órfão, jun/2025): **apagados**.
      - `lib_calib_envio1/` (2.5 GB, material-fonte da biblioteca de 177 livros):
        **arquivado** em `~/Archive/calibre-envio1-2025-07/`. Confirmado por
        amostragem que os livros vivem enriquecidos na biblioteca; guardado frio
        até o backup da biblioteca no Drive existir, aí pode descartar.
      - Downloads: os ~109 epub/pdf **já não existiam** (só sobraram 3 pdf úteis).
      - Logseq `pages/`: **não eram duplicatas** — são versões distintas do mesmo
        livro (conteúdo difere), curadoria manual pendente. Só `Conscreation saint
        joseh.md` (cópia hash-idêntica com typo) foi **apagado**.
- [ ] Decidir o que fica e o que sai de pendrives/mídia externa em uso.

## Ideias

Ainda não há ideias separadas das pendências acima.

> Para ver mudanças locais que ainda não foram commitadas, use `git status`.
