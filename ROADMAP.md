<!-- FORMATO: L (Now/Next/Soon/Later) — ver ~/projects/_hq/biblioteca/roadmaps/L-now-next-soon-later.md
     Escolhido por ser infra pessoal: sem usuário externo, sem prazo, balde "frágil" central.
     Este arquivo funde o antigo ROADMAP fase-based + o TODO num painel só. -->

# Roadmap — dotfiles

> Plano até Nix/home-manager, em formato **Now/Next/Soon/Later** (infra pessoal, sem prazo).
> As fases conceituais viram horizontes; as pendências técnicas viram itens. Perguntas de pesquisa
> por fase em `specs/fase-N-*.md`; decisões em [STATE.md](STATE.md); padrão de organização em
> [docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md).
>
> **A sequência de fundo continua:** Fase 0 (preparar base: IA+padrão) → Fase 1 (decidir área por
> área) → Fase 2 (executar + Stow limpo) → Fase 3 (migrar Nix). Fases 0/1 correm em paralelo ao
> uso; 2 executa as decisões de 1; 3 só quando 0–2 maduras.

**Baldes:** `🔵 Now` · `🟢 Next` (decidido) · `🟡 Soon` (provável, sem data) · `⚪ Later` (`[vem-depois]` / `[explorar]`) · `✅ Feito` · `⚠️ Frágil` (funciona, não confio) · `🚫 Não-fará`

---

## 🔵 Now
- **Fase 0 — fortalecer IA + padrão de organização.** `AGENTS.md`/skills revisados e o padrão de
  "onde cada arquivo mora" escrito no STATE.md. *(Pronto quando: padrão registrado, mesmo que a
  aplicação completa venha na Fase 1/2.)* — **em consolidação junto do HQ (`_hq`).**

## 🟢 Next *(decidido, aguarda vez — fechamento da Fase 2: Stow limpo)*
*(vazio — os itens de fechamento da Fase 2 foram concluídos, ver ✅ Feito)*

## 🟡 Soon *(provável — Fase 1: decidir área por área, aplicando o padrão da Fase 0)*
- `[repo]` Decidir se `zen/` fica só com notas ou guarda os exportáveis do perfil Flatpak.
- `[pc]` Revisar atalhos de teclado (Zen, GNOME, VS Code, terminal, Dolphin) — consolidar sem conflito, prontos pra virar declarativo depois.
- `[pc]` **Google Drive — decidido: rclone** (2026-09-16), não GNOME Online
  Accounts. rclone e Syncthing já estão instalados (apt) mas sem remote/pareamento —
  falta ação humana (OAuth no navegador, pareamento do celular). Runbook:
  [docs/google-drive-rclone.md](docs/google-drive-rclone.md) e
  [docs/syncthing.md](docs/syncthing.md).
- `[pc]` Ajustar backups do Notion.
- `[pc→hq]` **Livros/backup/sync saíram do dotfiles** *(2026-09-11)* — o assunto migrou pro HQ (futuro NAS): [`_hq/infra/livros-backup-sync.md`](../_hq/infra/livros-backup-sync.md). Aqui fica só *onde* a biblioteca mora no disco ([docs/livros-calibre.md](docs/livros-calibre.md)); uso concreto de Syncthing (só `entrada/`, Android→PC) descrito em [docs/syncthing.md](docs/syncthing.md), backup off-site em [docs/google-drive-rclone.md](docs/google-drive-rclone.md).

## ⚪ Later
- `[vem-depois]` **Fase 3 — migrar para Nix / home-manager.** Só começa com 0–2 maduras. Objetivo: aprender Nix a fundo, sistema reproduzível por config declarativa. Migração incremental — a estrutura por ferramenta e o padrão da Fase 0 seguem servindo. Spec: [specs/fase-3-migrar-nix.md](specs/fase-3-migrar-nix.md).
- `[explorar]` Gestão de segredos quando forem necessários: `age` independente vs solução integrada ao Nix/home-manager. *(em aberto — refinar antes de comprometer)*
- `[explorar]` Anotações: **local decidido** (guarda-chuva `~/Documents/notas-pkm/`, Logseq+Obsidian juntos — ver ✅ Feito); resta explorar **qual ferramenta serve melhor à IA** sobre as notas. *(cruza com UVW do HQ)*
- `[explorar]` Pendrives/mídia externa: o que continua em uso, o que é descartado.

---

## ✅ Feito
- **GNU Stow escolhido como gerenciador atual** *(2026-09)* — prioriza durabilidade (symlink simples, sem formato próprio) até o Nix amadurecer. Log em [STATE.md](STATE.md).
- Pacotes Stow versionados: `sway/ waybar/ alacritty/ nvim/ xremap/ yambar/ tmux/` + `home/` (.zshrc, .tmux.conf, .gitconfig).
- Padrão de organização de arquivos documentado (`docs/organizacao-de-arquivos.md`), com a skill `arruma-meu-not-ai` aplicando-o.
- Pacotes inativos no GNOME (`sway`/`waybar`/`yambar`/`xremap`) arquivados em `attic/` *(2026-09-11, commit `02936fa`)* — arquivados sem perder, prontos pra futura troca de distro.
- `tmux/plugins` (tpm, tmux-resurrect, tmux-sensible) registrados como **submodules** de verdade *(2026-09-11)* — `.gitmodules` recriado a partir dos gitlinks órfãos; máquina nova recupera com `git submodule update --init`.
- `nvim/init.lua_bkp` removido *(2026-09-11)* — config monolítica antiga já superada pela modular (`config/` + `plugins/`); histórico preservado no git.
- `bootstrap.sh` criado *(2026-09-11, = `NX4` do ROADMAP-HQ)* — idempotente, dry-run por padrão: checa deps, inicializa submodules do tmux e cria symlinks via Stow, abortando em conflito. Fecha o último ⚠️ Frágil (bootstrap de máquina nova).
- **Fase 1 — PKM decidido** *(2026-09-11)* — guarda-chuva `~/Documents/notas-pkm/` com o grafo Logseq movido pra dentro; Obsidian abre a pasta-mãe (markdown compartilhado, sem cópia). Doc: [docs/notas-pkm.md](docs/notas-pkm.md), decisão no [STATE.md](STATE.md).
- **Fase 1 — livros decididos** *(2026-09-11)* — `~/Documents/livros/{biblioteca,entrada}`; biblioteca Calibre movida, Calibre GUI + env do calibre-mcp atualizados, bug de path do MCP corrigido (validado ao vivo). Doc: [docs/livros-calibre.md](docs/livros-calibre.md).
- **Divergência PT-BR registrada** *(2026-09-11)* — pastas de conteúdo pessoal (`notas-pkm`, `livros`) em português por escolha; inglês segue pra config/estrutura técnica. Ver [STATE.md](STATE.md).
- **`waybar` vs `yambar` resolvido por já estarem os dois em `attic/`** *(2026-09-16)* — arquivar os dois (feito em 2026-09-11) já respondia a pergunta; confirmado que não há symlink ativo nem pasta solta na raiz pra nenhum dos dois. Item antigo do balde Soon removido por obsoleto.
- **`fonts/` não vendoriza mais binário** *(2026-09-16)* — `install-fonts.sh` baixa JetBrainsMono + Symbols Nerd Font (releases oficiais, pinado em `v3.5.1`) em build-time, mesmo padrão do `icons/`. 232MB de `.ttf` removidos do git. Ver [STATE.md](STATE.md).
- **Dump/restore declarativo do dconf** *(2026-09-16)* — pacote novo `gnome-shell/` (não-Stow): `interface.ini`/`shell.ini`/`wm-preferences.ini` versionados, `dump-dconf.sh` regenera, `restore-dconf.sh` aplica (`bootstrap.sh --with-gnome-shell-theme`). Escopo: tema + extensões habilitadas; atalhos de teclado ficam de fora (item separado). Ver [STATE.md](STATE.md).

## ⚠️ Frágil *(funciona mas não confio — resolver antes de empilhar coisa nova na mesma área)*
*(vazio — o bootstrap de máquina nova, único item aqui, foi resolvido; ver ✅ Feito)*

## 🚫 Não-fará (por ora)
- Nada explicitamente descartado ainda — itens que morrerem migram pra cá com o motivo.

---

## Nota de leitura
Item sobe `Later → Soon → Next → Now` conforme a fase de fundo permite (não dá pra fazer Fase 2
sem as decisões da Fase 1). O balde `⚠️ Frágil` é o que a versão original não tinha e é central em
infra pessoal — a prioridade real aqui é "quanto eu perderia se isso quebrasse", não métrica de uso.
