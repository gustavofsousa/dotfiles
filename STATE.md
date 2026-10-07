# State

Snapshot do estado atual do repo — o que já está decidido e por quê, e o que
ainda está em aberto. Complementa [TODO.md](TODO.md) (pendências) e
[ROADMAP.md](ROADMAP.md) (direção de longo prazo): aqui é o retrato de agora.

## Estado atual

- Fase atual do [ROADMAP.md](ROADMAP.md): **Fase 1 em andamento** (decisões por
  área). Fase 0 concluída — padrão de organização definido
  ([docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md)),
  `AGENTS.md` revisado, skill `arruma-meu-not-ai` criada. Fase 2 (Stow limpo)
  fechada: submodules do tmux corrigidos, `bootstrap.sh` criado, backup nvim
  removido. Nix/home-manager fica pra Fase 3.
- **Fase 1 — áreas decididas até agora (2026-09-11):** PKM (Logseq+Obsidian sob
  `~/Documents/notas-pkm/`) e livros (Calibre em `~/Documents/livros/biblioteca`,
  entrada em `~/Documents/livros/entrada`). Ver decisões abaixo e os docs
  [docs/notas-pkm.md](docs/notas-pkm.md) e [docs/biblioteca.md](docs/biblioteca.md).
- Gerenciador: **GNU Stow** (ver decisão abaixo). Pacotes ativos:
  `alacritty`, `environment`, `home`, `nvim`, `theme-sync`, `tmux`, `vscode`.
  Bootstrap de máquina nova: `bootstrap.sh`.
- **Ícones/tema do Dolphin (2026-09-15):** Fluent orange/dark, aplicado via
  `icons/install-icons.sh` (não é pacote Stow — clona upstream em
  build-time). Depende do pacote `environment/` (`QT_QPA_PLATFORMTHEME=kde`)
  + `plasma-integration` instalado via apt (manual, já feito). Ver log de
  decisões.
- **Cursor (2026-09-15):** Qogir-cursors, aplicado via
  `cursors/install-cursor.sh` (mesmo padrão do `icons/`). Nordzy-cursors e
  Bibata-Original-Classic documentados como 2ª/3ª opção, não instalados.
- **Tema GTK/Shell/ícone (2026-09-16):** saiu do Adwaita — base virou **Tokyo
  Night** (GTK3+GTK4/libadwaita+top bar, `gtk-theme/install-gtk-theme.sh`) +
  ícone **Fluent-purple** (`icons/install-icons-tokyonight.sh`). Fluent-orange
  (Monokai/Dolphin) preservado intacto em `icons/install-icons.sh` pra voltar
  se quiser. Claro/escuro é manual (toggle nativo do GNOME); pacote Stow
  `theme-sync/` roda um watcher (`systemctl --user` service) que mantém
  gtk-theme/ícone/shell-theme sincronizados com esse toggle. Extensão GNOME
  Shell "User Themes" habilitada em 2026-09-17 (pós logout/login) — top bar
  já responde ao tema junto com o resto. Ver log de decisões.
- **Wallpaper Tokyo Night (2026-09-17, trocado no mesmo dia):** primeira
  versão era o design oficial "gnome" (pegada do GNOME + listras). Gustavo
  pediu pra trocar pelo **símbolo do Tokyo Night** — a Tokyo Tower (dá nome
  ao tema), composta a partir do `theme-icon.png` do upstream
  [tokyo-night/wallpapers](https://github.com/tokyo-night/wallpapers) (MIT).
  Variantes claro/escuro vendorizadas como PNG 4K em
  `wallpaper/backgrounds/tokyo-night-symbol-{night,light}.png` (torre+texto
  "function" sobre canvas sólido `#1a1b26`/`#d5d6db`; variante clara com a
  torre recolorida pro tom "fg" do Tokyo Night Day `#343b58`, já que o
  lavender original não tinha contraste em fundo claro). Aplicado via
  `wallpaper/apply-wallpaper.sh` em `picture-uri`/`picture-uri-dark` — GNOME
  troca sozinho entre os dois conforme `color-scheme`, sem precisar do
  watcher do `theme-sync/`. `wallpaper/` não é pacote Stow (mesmo padrão de
  `icons/`/`gtk-theme/`).
- **Paleta Monokai em todo o resto (2026-09-16):** Alacritty, Neovim, tmux e
  VS Code — mesma paleta do Dolphin. Terminal padrão do sistema trocado pra
  Alacritty (`update-alternatives`, manual/sudo, já feito). `themes/` guarda
  o Tokyo Night antigo do Alacritty pra retomar depois, sem aplicar. Ver log
  de decisões.
- **Sótão (`attic/`, versionado sem symlink):** `sway`, `waybar`, `yambar`,
  `xremap` — ambiente tiling abandonado ao migrar pra GNOME/Ubuntu (Wayland).
  Arquivados em 2026-09, ver log de decisões. Resolve também o antigo impasse
  `waybar` vs `yambar`: ambos saíram do fluxo ativo juntos.
- `attic/`, `fonts/`, `icons/`, `cursors/`, `gtk-theme/`, `wallpaper/` e `zen/`
  não são pacotes do Stow — ver README.
- `tmux/.config/tmux/plugins/` (`tpm`, `tmux-resurrect`, `tmux-sensible`)
  são **submodules** de verdade (`.gitmodules` presente) — clone novo recupera
  com `git submodule update --init` (o `bootstrap.sh` faz isso).

## Log de decisões

> **Decisões por tema vivem nos one-pages de [`docs/`](docs/)** — cada um com sua
> seção "Decisões" (o quê, por quê, alternativa rejeitada, consequência):
> [galeria](docs/galeria.md) · [biblioteca](docs/biblioteca.md) ·
> [backup](docs/backup.md) · [nas](docs/nas.md) ·
> [organizacao-de-arquivos](docs/organizacao-de-arquivos.md).
> Aqui ficam só as decisões **estruturais do repo** que não pertencem a um tema.

### 2026-10-06 (2) — "Ferramentas no sistema" em cada one-page; `specs/` extinta

- **Toda doc de tema ganhou seção "Ferramentas no sistema"** — tabela com ferramenta +
  **versão medida**, pra quê, estado (✅/⬜) e **origem** (apt/snap/flatpak/instalador
  oficial), mais uma tabela de personalização (o que, onde mora, versionado?).
  *Por que a origem importa:* `apt` vs. instalador oficial vs. snap muda como se
  declara no Nix e quem atualiza. Achados ao medir:
  - **Calibre 8.2.100 não vem do apt** — instalador oficial em `/opt/calibre`, que
    auto-atualiza. Decisão a tomar no Nix (manter fora do controle declarativo ou
    aceitar o nixpkgs possivelmente atrasado).
  - **`~/.config/user-dirs.dirs` está fora do git** — é o arquivo que faz as pastas de
    topo serem em inglês; em máquina nova voltam no locale PT-BR, **contra o próprio
    padrão**. Virou item do roadmap (pacote Stow de uma linha).
  - `ffmpeg` existe duas vezes (apt 6.1.1 + snap 8.1); extensões do VS Code fora do git.
- **Regra nova no `AGENTS.md`:** todo passo/comando CLI/ferramenta que se tornar
  definitivo **é registrado na seção "Ferramentas no sistema" do tema**, com
  verificação real da versão e origem antes de escrever (nunca presumir). Junto, uma
  tabela de "qual arquivo guarda o quê" pra não voltar a espalhar a mesma informação.
- **`specs/` extinta.** Eram 4 arquivos de setembro com *perguntas de pesquisa*:
  - Fases 0, 1 e 2 → **todas as perguntas respondidas e as fases concluídas**;
    arquivadas em `deposito/2026-10-06-specs-fases-0-2/` com uma tabela
    pergunta → resposta → onde a resposta vive hoje.
  - Fase 3 (Nix) → **promovida a [docs/nix.md](docs/nix.md)**, porque as perguntas
    seguem abertas de verdade. Ganhou o formato dos outros one-pages (estado,
    ferramentas, RFDs, evolução, decisões) e registra o que cada ferramenta atual vira
    em Nix.
  - *Por que o formato não sobreviveu:* a spec-por-fase serviu pra forçar pesquisa
    antes de executar. Mantê-la depois virou um lugar a mais onde a mesma decisão
    morava, competindo com o `STATE.md` e os docs de tema.

### 2026-10-06 — Docs reorganizados: one-page por tema + pesquisas + depósito

- **Problema:** `STATE.md` passou de 890 linhas e o `acervo-digital.md` juntava
  quatro assuntos (livros, fotos, backup, NAS) em 348 linhas. Achar "o que eu
  decidi sobre galeria" exigia ler tudo.
- **Estrutura adotada:**
  - **one-page por tema** em `docs/` ([galeria](docs/galeria.md),
    [biblioteca](docs/biblioteca.md), [backup](docs/backup.md), [nas](docs/nas.md)),
    cada um livre pra se organizar como o assunto pede — com estado atual, RFDs em
    aberto, caminhos de evolução e uma seção "Decisões" no fim fazendo papel de ADR
    curto. É a "identidade" de como eu organizo o computador, e a base pra uma
    skill futura;
  - **[`pesquisas/`](pesquisas/)** — anotações externas datadas, **texto original
    preservado**, com nota de confiança e minhas discordâncias no topo. O one-page
    cita a fonte em vez de repeti-la;
  - **[`deposito/`](deposito/)** — arquivo morto datado (mesma convenção do `_hq`),
    regra "nada morre sem colheita".
- **Alternativa rejeitada:** ADR em arquivos separados numerados
  (`decisoes/0003-*.md`). Mais fiel ao padrão clássico, mas dobraria o número de
  arquivos e forçaria pular entre tema e decisão pra entender um assunto só.
- **Roadmap unificado:** `ROADMAP.md` + `ROADMAP-acervo.md` fundidos num painel só
  do computador, com IDs `AC*` e dois baldes que o formato L não tem — `🙋 Humano`
  (travado em mim) e `🛑 RFD` (decisão minha). `Now` ficou focado no essencial:
  ter onde guardar foto/vídeo/livro com segurança.
- **Divisão com o `_hq` segue temporária e deliberada** — o acervo mora aqui
  enquanto está sendo configurado; volta pro `_hq` quando estabilizar. Registrado
  no `SN5` do roadmap-hq com aviso de **não "consertar" sem pedido explícito**.
- **`smartmontools 7.4`** (instalado por mim) virou check de dependência
  **recomendada** no `bootstrap.sh` — avisa e segue, junto de `exiftool`, `rsync` e
  `ffmpeg`; não aborta como `git`/`stow`. Verificado em dry-run. É o que faz voltar
  sozinho em máquina nova e virar pacote declarado no Nix.
- **Docs antigos revisados** na mesma passada, com um critério: *doc de tema guarda o
  desenho permanente; passo a passo de ação humana mora no `config.md`; o que falta
  fazer mora no `ROADMAP.md`.*
  - `syncthing.md` + `google-drive-rclone.md` → **fundidos em
    [sincronizacao.md](docs/sincronizacao.md)** (decisão rclone≠GOA, as duas pastas,
    trava do `metadata.db`). Os passos duplicavam o `config.md` e iam divergir.
  - `organizacao-de-arquivos.md` (349 linhas) **perdeu as 4 seções de foto** pro
    [galeria.md](docs/galeria.md) (cronológico, álbuns, Czkawka, runbook de HD
    antigo) e as "divergências conhecidas" pro `ROADMAP.md` — pendência não é padrão.
    Ficou com o padrão geral: XDG, 3 níveis, ISO 8601, camadas, `attic/`, P.A.R.A.
  - `notas-pkm.md` e `vscode-multiroot-workspace.md` **mantidos como estão** — já são
    one-pages de tema, enxutos (62 e 52 linhas), nada a desmembrar.

---

> **Log anterior a 2026-09-28** (setembro inteiro: tema Tokyo Night, Monokai,
> ícones, cursor, wallpaper, dconf, `~/Archive` eliminado, PKM, Stow, sótão)
> foi arquivado em
> [`deposito/2026-10-06-state-log-setembro-outubro.md`](deposito/2026-10-06-state-log-setembro-outubro.md).
> As decisões por tema vivem nos one-pages de [`docs/`](docs/).
