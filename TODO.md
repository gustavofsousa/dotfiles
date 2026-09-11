# TODO

> **Nota (consolidação HQ, 2026-09-10):** o [ROADMAP.md](ROADMAP.md) foi reescrito no formato
> Now/Next/Soon/Later e **absorveu estas pendências nos baldes** — ele é agora o painel único.
> Este TODO fica como detalhamento/rascunho; ao mexer numa pendência, atualize o ROADMAP (fonte da
> vista) para os dois não divergirem. Nada aqui é fonte da verdade sozinho.

Este arquivo reúne pendências do repo e da organização do computador. Nem toda
tarefa vira um arquivo commitado. Ver [ROADMAP.md](ROADMAP.md) para como
essas pendências se encaixam no plano até Nix (fases 0–3).

## Repo

> Maioria destes itens é fechamento da **Fase 2** do ROADMAP (deixar o Stow
> limpo).

- [ ] Reduzir os binários vendorizados em `fonts/` e fazer o script baixar uma
      versão do Nerd Fonts quando necessário.
- [ ] Decidir se o `zen/` continuará apenas com notas ou também guardará os
      arquivos exportáveis do perfil Flatpak.
- [ ] Criar scripts de bootstrap para symlinks e dependências de uma máquina
      nova.
- [x] Mover pacotes de config largados (Sway/waybar/yambar/xremap, inativos no
      GNOME) pra `attic/` — feito 2026-09-11 (commit `02936fa`), arquivados sem
      perder, conforme padrão do sótão.

## Computador

> Estes itens envolvem decisão de onde arquivos moram — parte da **Fase 1**
> do ROADMAP (decidir área por área, aplicando o padrão da Fase 0).

- [ ] Revisar os atalhos de teclado do Zen Browser, GNOME, VS Code, terminal,
      Dolphin e outros aplicativos usados no dia a dia.
- [ ] Configurar o Syncthing — sincronizar só `~/Documents/livros/entrada/`
      (celular→PC) + backup da biblioteca no Drive. Estrutura pronta; instalar
      é decisão macro. Ver `docs/livros-calibre.md`.
- [ ] Ajustar os backups do Notion.
- [ ] Configurar o Google Drive para uso pelo Ubuntu, via GNOME Online Accounts
      ou `rclone`.
- [x] Anotações — **local decidido** (2026-09-11): guarda-chuva
      `~/Documents/notas-pkm/` com Logseq+Obsidian juntos. Ver
      `docs/notas-pkm.md`. Resta explorar qual serve melhor à IA.
- [x] Livros/Calibre — **local decidido** (2026-09-11):
      `~/Documents/livros/{biblioteca,entrada}`; Calibre GUI + calibre-mcp
      reapontados. Ver `docs/livros-calibre.md`.
- [ ] Faxina de restos: `metadata.db`/`lib_calib_envio1/` avulsos em Documents,
      ~109 epub/pdf no Downloads, duplicatas em `notas-pkm/logseq/pages/`.
- [ ] Decidir o que fica e o que sai de pendrives/mídia externa em uso.

## Ideias

Ainda não há ideias separadas das pendências acima.

> Para ver mudanças locais que ainda não foram commitadas, use `git status`.
