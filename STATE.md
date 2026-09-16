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
  [docs/notas-pkm.md](docs/notas-pkm.md) e [docs/livros-calibre.md](docs/livros-calibre.md).
- Gerenciador: **GNU Stow** (ver decisão abaixo). Pacotes ativos:
  `alacritty`, `environment`, `nvim`, `tmux`, `home`. Bootstrap de máquina
  nova: `bootstrap.sh`.
- **Ícones/tema do Dolphin (2026-09-15):** Fluent orange/dark, aplicado via
  `icons/install-icons.sh` (não é pacote Stow — clona upstream em
  build-time). Depende do pacote `environment/` (`QT_QPA_PLATFORMTHEME=kde`)
  + `plasma-integration` instalado via apt (manual). Ver log de decisões.
- **Cursor (2026-09-15):** Qogir-cursors, aplicado via
  `cursors/install-cursor.sh` (mesmo padrão do `icons/`). Nordzy-cursors e
  Bibata-Original-Classic documentados como 2ª/3ª opção, não instalados.
- **Sótão (`attic/`, versionado sem symlink):** `sway`, `waybar`, `yambar`,
  `xremap` — ambiente tiling abandonado ao migrar pra GNOME/Ubuntu (Wayland).
  Arquivados em 2026-09, ver log de decisões. Resolve também o antigo impasse
  `waybar` vs `yambar`: ambos saíram do fluxo ativo juntos.
- `attic/`, `fonts/`, `icons/`, `cursors/` e `zen/` não são pacotes do Stow — ver README.
- `tmux/.config/tmux/plugins/` (`tpm`, `tmux-resurrect`, `tmux-sensible`)
  são **submodules** de verdade (`.gitmodules` presente) — clone novo recupera
  com `git submodule update --init` (o `bootstrap.sh` faz isso).

## Log de decisões

### 2026-09-15 — Cursor do mouse: Qogir (1ª opção), Nordzy e Bibata-Original-Classic como alternativas

**Contexto:** seguindo a rice do Dolphin/ícones (entrada abaixo), faltava decidir o
cursor. Comparados ao vivo (troca de `gsettings cursor-theme` + `kcminputrc`
`[Mouse] cursorTheme` em sequência, sem reiniciar sessão): Breeze (já
instalado), Bibata-Modern-Classic, DMZ-White, Bibata-Original-Classic,
Nordzy-cursors, Qogir. Preferência declarada: formato comprido/pontudo
("cumpridinho"/"losango"), não o formato curto/arredondado do Bibata Modern.
"Obsidian" citado como possível 4ª opção não corresponde a nenhum tema de
cursor real encontrado (buscas no GitHub e pling/gnome-look só retornam
plugins do app de notas Obsidian) — provável confusão com o tema de
**ícones** "Obsidian" mencionado antes, nunca confirmado pelo Gustavo.

**Decisão:** **Qogir-cursors** como principal (instalado). **Nordzy-cursors**
como 2ª opção e **Bibata-Original-Classic** como 3ª — nenhuma das duas fica
instalada por padrão; comandos de reinstalação comentados no fim de
`cursors/install-cursor.sh`. Qogir vem do mesmo repo
`vinceliuice/Qogir-icon-theme` usado só pelo `install.sh` padrão (que já
inclui `cursors/`) — não trocamos o tema de ícones (continua Fluent
orange/dark), só extraímos o cursor.

**Por quê:** clutter de disco baixo — o Nordzy sozinho instala ~130
variantes (Catppuccin × 4 paletas × várias cores × lefthand); manter só o
ativo e documentar o resto como comando pronto é mais barato que vendorizar
tudo. Site de referência pra explorar mais opções:
https://www.gnome-look.org/browse?cat=107 (catálogo comunitário de cursores).

### 2026-09-15 — Rice do Dolphin: tema de ícones Fluent + fix do QT_QPA_PLATFORMTHEME

**Contexto:** a rice do Dolphin (tema Monokai + JetBrains Mono já em
`kdeglobals`) tinha "parado pelo caminho" — fonte e ícones não aplicavam.
Investigando: Dolphin é app Qt/KDE, mas a sessão é GNOME puro (sem Plasma).
Sem `QT_QPA_PLATFORMTHEME` setado, o Qt detecta o GNOME e carrega
automaticamente o platform theme GTK3 (`libqgtk3.so`), que ignora
`kdeglobals` por completo — confirmado com `strace`/`QT_DEBUG_PLUGINS=1`.

**Decisão (integração KDE↔GNOME):** instalado `plasma-integration` (pacote
apt, fora do repo — precisa de senha) e criado
`~/.config/environment.d/qt-platform-theme.conf` com
`QT_QPA_PLATFORMTHEME=kde`, agora versionado como pacote Stow `environment/`.
Isso faz o Qt carregar o plugin `KDEPlasmaPlatformTheme.so` (id `"kde"`), que
lê `kdeglobals` de verdade — sem isso, qualquer tentativa futura de configurar
apps Qt/KDE sob GNOME por `kdeglobals` vai continuar "não fazendo nada".

**Decisão (tema de ícones):** comparado ao vivo no Dolphin — Tela (rosa,
rejeitado), Fluent (testado em várias cores: teal/purple/orange/green) e
Zafiro (rejeitado). Escolhido **Fluent, variante orange/dark**. Script
`icons/install-icons.sh` clona o upstream
(`vinceliuice/Fluent-icon-theme`) em build-time pra `~/.local/share/icons/`
(não vendorizado — SVG de terceiros, muito volume pra versionar) e aplica em
dois lugares: `kdeglobals` (`[Icons] Theme=`, via `kwriteconfig5`, pros apps
Qt/KDE) **e** `gsettings org.gnome.desktop.interface icon-theme` (pros apps
GTK/GNOME) — os dois precisam estar setados pro visual ficar consistente
entre os dois mundos.

**Decisão (pastas ocultas em cinza):** pastas que começam com `.` na raiz da
home ganham ícone `folder-grey` (extraído da variante grey do Fluent e
registrado dentro do tema ativo) via arquivo `.directory` — mecanismo nativo
do KDE/freedesktop, funciona com qualquer tema. Script
`icons/tag-hidden-folders.sh`, idempotente. Ficam de fora `.ssh`, `.gnupg` e
`.pki` (armazenamento de chave/credencial) — não por segurança de conteúdo
(o `.directory` não expõe nada), mas por precaução de não escrever arquivo
novo dentro dessas pastas por padrão.

**Por quê:** o padrão observado (Qt/KDE app + GNOME sem Plasma = tema
ignorado silenciosamente) é genérico — vai se repetir em qualquer app
Qt/KDE futuro (Kate, Okular, etc.), não só Dolphin. Documentar aqui e na
skill `ricing-do-gustavo` evita redescobrir o mesmo problema do zero.
Ícones do tema não entram como submodule Git (fluxo de aprovação do Claude
Code bloqueou por ser dependência de código externo não pedida
explicitamente) — clone efêmero em build-time resolve sem esse trade-off.

**Consequências:** máquina nova precisa de `sudo apt install
plasma-integration` manual (não automatizável pelo `bootstrap.sh`, exige
senha interativa) antes de `./bootstrap.sh --apply --with-icons` fazer
sentido visualmente. `icons/install-icons.sh` depende de rede (clona do
GitHub) — sem internet, pula esse passo.

### 2026-09-11 — Sync/backup da biblioteca + faxina de restos de livros

**Contexto:** Fase 1 — fechar a área "livros" quanto a sincronização e backup, e
limpar os restos que sobraram da migração da biblioteca. O TODO listava
`metadata.db`/`lib_calib_envio1/` avulsos, ~109 epub/pdf no Downloads e
"duplicatas" no Logseq. Celular do Gustavo é **Android**.

**Decisão (sync/backup):** Syncthing sincroniza **só `~/Documents/livros/entrada/`**
(Android ↔ PC), nunca a `biblioteca/` (SQLite vivo corrompe com sync). Backup da
biblioteca fica **manual por ora** (fechar Calibre → cópia fria); automação via
`rclone` agendado é melhoria futura (`LT13` no ROADMAP-HQ). GNOME Online Accounts
serve só pra ver o Drive no Nautilus, não pra backup. Desenho completo na doc do HQ
[`_hq/infra/livros-backup-sync.md`](../_hq/infra/livros-backup-sync.md) (ver
atualização abaixo — o assunto migrou pro HQ no mesmo dia).

**Decisão (faxina):** apagados `metadata.db` + `metadata_db_prefs_backup.json`
(índice Calibre órfão, jun/2025) e `Conscreation saint joseh.md` do Logseq (cópia
hash-idêntica). `lib_calib_envio1/` (2.5 GB, material-fonte da biblioteca)
**arquivado** em `~/Archive/calibre-envio1-2025-07/` — não apagado: confiança alta
mas não item-a-item de que é redundante; descartar só depois do backup existir. Os
~109 arquivos do Downloads já não existiam; o Logseq não tinha duplicatas (o resto
são versões distintas do mesmo livro = curadoria manual, não mexida).

**Por quê:** entrada e backup são jobs diferentes com ferramentas diferentes;
misturá-los (ou sincronizar o `metadata.db`) arrisca corromper a biblioteca.
Backup manual é suficiente até valer o setup de `rclone`. Arquivar em vez de
apagar o material-fonte segue a regra do repo (não destruir dado real sem certeza
total) a custo baixo (2.5 GB frios).

**Atualização (mesmo dia, 2026-09-11):** o assunto **livros/backup/sync saiu do
dotfiles** e passou a viver no HQ (`_hq/infra/livros-backup-sync.md`), rumo a NAS —
o dotfiles fica só com *onde* a biblioteca mora no disco (organização de arquivos,
finalidade de máquina). Os 24 PDFs de `livros-investimento/` foram importados
(biblioteca 177→201) e a pasta-fonte arquivada; feito um backup frio local em
`~/Archive/biblioteca-backup-2026-09-11/` (provisório, mesmo disco).

**Consequências:** Syncthing ainda não instalado (precisa sudo; comandos na doc do
HQ). Documents limpo de todos os restos de livros. Quando o backup off-site
(`rclone`→Drive) existir, `lib_calib_envio1/` e o backup local podem ser
descartados/rotacionados.

### 2026-09-11 — PKM sob um guarda-chuva único (`~/Documents/notas-pkm/`)

**Contexto:** Logseq (Snap) e Obsidian (Flatpak) instalados; o Logseq tinha o
conteúdo real (33 pages, notas de leitura de 2025, último journal 2026-03),
o Obsidian estava vazio (vault de teste criado no mesmo dia). Ambos espalhados
em `~/Documents` (`Logseq/`, `obsidian-notes/`). O Gustavo quer experimentar o
Obsidian e usar IA sobre as notas, mas manter os dois "no mesmo guarda-chuva".

**Decisão:** criar `~/Documents/notas-pkm/` como guarda-chuva único e mover o
grafo Logseq pra `notas-pkm/logseq/`. Um único vault Obsidian aberto em
`notas-pkm/` enxerga tudo (Logseq e Obsidian são markdown puro; 0 sintaxe
Logseq pesada → sem conversão nem cópia divergente). Vault de teste vazio
arquivado em `~/Archive/`. Alinhado ao estudo `UVW` do HQ: Obsidian como
*leitor* de markdown, não como formato-fim; qual ferramenta serve melhor à IA
segue `[explorar]`. Detalhe em [docs/notas-pkm.md](docs/notas-pkm.md).

**Por quê:** o conteúdo é o mesmo markdown; unificar o *local* dá grafo/busca/IA
sobre o que já existe sem manter duas cópias em sincronia. Decisão barata agora
(nenhum dos dois em uso ativo pesado).

**Consequências:** fecha o item PKM da Fase 1 e informa o `LT7/UVW` do HQ
(ainda `[explorar]` para a parte "melhor pra IA"). Faxina de duplicatas nas
pages fica pendente. Reapontar o cache `.transit` do Logseq feito;
regenerável se preciso.

### 2026-09-11 — Livros: biblioteca local autoritativa + entrada sincronizável

**Contexto:** biblioteca Calibre (2.5G, ~170 livros) em
`~/Documents/BibliotecaCalibre`; calibre-mcp lê o path por env
`CALIBRE_LIBRARY_PATH`; o Gustavo quer um fluxo celular→PC (baixar livro no
celular, aparecer no PC pronto pro Calibre) e backup no Google Drive via
Syncthing. Havia também um bug: a config MCP apontava pra `~/projects/calibre-mcp`
(inexistente; real é `04_calibre-mcp`) — o server nem subia.

**Decisão:** estrutura `~/Documents/livros/` com `biblioteca/` (a lib Calibre,
LOCAL e autoritativa) e `entrada/` (staging). Atualizados os dois consumidores
do path (Calibre GUI + env do MCP) e corrigido o path quebrado do MCP.
Syncthing sincronizará **só `entrada/`**, nunca a `biblioteca/` inteira (o
`metadata.db` é SQLite vivo → sync geraria `.sync-conflict`/corrupção). Backup
da biblioteca é job separado (cópia fria), não sync contínuo. Instalar Syncthing
é decisão macro pendente (RFD). Detalhe em [docs/livros-calibre.md](docs/livros-calibre.md).

**Por quê:** separar entrada (pequena, volátil, boa pra sync) de biblioteca
(grande, índice vivo, ruim pra sync) dá o fluxo celular→PC sem arriscar o
índice do Calibre.

**Consequências:** calibre-mcp validado ao vivo com o novo path (config OK,
`metadata.db` encontrado). Débito "path duplicado sem fonte única" registrado
no calibre-mcp como AD-028. Restos do Calibre soltos em `~/Documents`/`Downloads`
seguem a triar. Syncthing/Drive não montados.

### 2026-09-11 — Divergência consciente: nomes PT-BR para pastas de conteúdo pessoal

**Contexto:** o padrão da Fase 0 ([docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md))
manda nomes de pasta em **inglês**. As pastas de conteúdo pessoal criadas na
Fase 1 (`notas-pkm`, `livros`, `livros/entrada`, `livros/biblioteca`) foram
nomeadas em **PT-BR** por pedido explícito do Gustavo.

**Decisão:** aceitar PT-BR para pastas de **conteúdo pessoal do usuário** (o que
mora em `~/Documents`), mantendo inglês para **config/estrutura técnica** (repo,
XDG, pacotes Stow). A regra "inglês" continua valendo para o que é
open-source-facing; conteúdo pessoal em português é escolha de dono.

**Por quê:** o custo de inglês (consistência com o repo público) não se aplica a
pastas privadas que nunca saem da home; a legibilidade em PT-BR vale mais ali.

**Consequências:** a skill `arruma-meu-not-ai` deve tratar isto como divergência
conhecida (não "corrigir" `notas-pkm`→`notes`). Atualizar a reference da skill
quando tocar nela.

### 2026-09 — Config largada vai pro sótão (`attic/`), não é apagada

**Contexto:** ao migrar de Sway/waybar/yambar para GNOME Ubuntu, várias configs
deixaram de ser usadas. O Gustavo quer "guardar sem perder" (sótão), preservar
o estilo pra uma futura troca de distro, sem poluir o fluxo ativo.

**Decisão:** config de ferramenta largada sai do Stow ativo (`stow -D`) e vai
pra `attic/<ferramenta>/` **dentro do próprio repo** — continua versionada, mas
não vira symlink. Config **não** vai pra `~/Archive` (isso é pra dados frios).
Três estados: viva (raiz + Stow), sótão (`attic/`, versionada sem symlink),
morta (apagada, só se lixo real). Ver
[docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md).

**Por quê:** config é o que o repo existe pra versionar; manter no git preserva
histórico e portabilidade entre distros, e é base pronta pra Fase 3 (Nix
declarar o estilo). `~/Archive` perderia isso.

**Consequências:** mover os pacotes largados pra `attic/` é execução da Fase 2
(não feito agora). A skill `arruma-meu-not-ai` já sabe arquivar nesse padrão.

### 2026-09 — Skills de organização e ricing criadas (Fase 0, pergunta 5)

**Contexto:** a Fase 0 pede decidir quais skills trazer pra a IA organizar o
notebook. As skills do Gustavo vivem no repo single-source
`~/projects/.github/claude/skills/` (symlinkado pra `~/.claude/skills`).

**Decisão:** criar duas skills carregadas sob demanda (não always-on):
- **`arruma-meu-not-ai`** — organização de arquivos: tria Downloads, decide
  onde algo mora (XDG + pastas de usuário), migra dotfile pra XDG, arquiva
  config no sótão, audita a home. Fonte de verdade = doc deste repo.
- **`ricing-do-gustavo`** — esqueleto de personalização visual do desktop, a
  ser especificado conforme o estilo se consolidar. Distinta da anterior (uma
  cuida de *onde* a config mora, a outra de *como* o desktop se parece).

Nix/home-manager adiado pra Fase 3.

**Por quê:** organização e ricing não são uso diário — skill sob demanda evita
peso morto no contexto e ainda dá auto-carregamento pelo `description`.

**Consequências:** Fase 0 concluída. A skill de ricing evolui ao longo do tempo.

### 2026-09 — Padrão de organização de arquivos do notebook (XDG + pastas em inglês)

**Contexto:** a Fase 0 do [ROADMAP.md](ROADMAP.md) exige definir, antes de
reorganizar arquivo de verdade (Fases 1/2), onde cada tipo de arquivo mora no
notebook inteiro — não só neste repo.

**Decisão:** adotar duas camadas — (1) **XDG Base Directory estrito** para
config, dados de app, cache e estado (`~/.config`, `~/.local/share`,
`~/.local/state`, `~/.cache`); (2) **pastas de topo em inglês alinhadas ao
`xdg-user-dirs`** para arquivos do usuário (`Documents`, `Downloads`,
`Pictures`, `Music`, `Videos`) mais `Projects`, `Archive` e, opcional, `Media`.
Padrão completo em [docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md).

**Por quê:** XDG é o padrão de fato no Linux e evita reinventar convenção;
inglês mantém consistência com o repo (open-source-facing) e com o
`xdg-user-dirs` que já governa a home. Só configuração entra no git; dados
privados ficam fora.

**Consequências:** guia todas as decisões de pasta das Fases 1/2. Não executa
nada agora — `~/projects` (minúsculo) e a ausência de `Archive`/`Media`
continuam divergindo do padrão até a aplicação nas próximas fases (divergências
listadas no doc). `AGENTS.md` ganhou regra de symlink-vs-arquivo-real e de
dados-privados-fora-do-git para a IA reorganizar com segurança.

### 2026-09 — Adotar GNU Stow como gerenciador de dotfiles

**Contexto:** repo era espelho manual (editar no sistema, copiar pra cá),
sem symlink automatizado.

**Decisão:** migrar para GNU Stow, com uma pasta por ferramenta na raiz
espelhando o caminho a partir de `$HOME`.

**Por quê:** prioriza durabilidade sobre feature-set — é uma ferramenta de
symlink simples, sem formato próprio, com baixa dependência de manutenção
ativa de um projeto. Ver [ROADMAP.md](ROADMAP.md) para a comparação com a
alternativa considerada (Nix/home-manager) e quando migrar faz sentido.

**Consequências:** resolve onde cada config mora; não resolve gerenciamento
de segredo em repo público (decisão consciente de não guardar segredo por
enquanto, ver [AGENTS.md](AGENTS.md)).
