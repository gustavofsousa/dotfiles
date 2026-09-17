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
  Shell "User Themes" (pacote `gnome-shell-extensions`) precisa de
  logout/login pra aparecer — pendente até a próxima sessão. Ver log de
  decisões.
- **Paleta Monokai em todo o resto (2026-09-16):** Alacritty, Neovim, tmux e
  VS Code — mesma paleta do Dolphin. Terminal padrão do sistema trocado pra
  Alacritty (`update-alternatives`, manual/sudo, já feito). `themes/` guarda
  o Tokyo Night antigo do Alacritty pra retomar depois, sem aplicar. Ver log
  de decisões.
- **Sótão (`attic/`, versionado sem symlink):** `sway`, `waybar`, `yambar`,
  `xremap` — ambiente tiling abandonado ao migrar pra GNOME/Ubuntu (Wayland).
  Arquivados em 2026-09, ver log de decisões. Resolve também o antigo impasse
  `waybar` vs `yambar`: ambos saíram do fluxo ativo juntos.
- `attic/`, `fonts/`, `icons/`, `cursors/` e `zen/` não são pacotes do Stow — ver README.
- `tmux/.config/tmux/plugins/` (`tpm`, `tmux-resurrect`, `tmux-sensible`)
  são **submodules** de verdade (`.gitmodules` presente) — clone novo recupera
  com `git submodule update --init` (o `bootstrap.sh` faz isso).

## Log de decisões

### 2026-09-16 — `zen/` guarda o tema (ZenMods); sessões via Syncthing fica em aberto (risco)

**Contexto:** item Soon do ROADMAP — decidir se `zen/` fica só com notas ou
guarda exportáveis do perfil Flatpak. Gustavo: consegue sincronizar parte do
Zen pelo próprio login (Firefox Sync/Zen Account — bookmarks, provavelmente
histórico/senhas); tema e "sessões" não vêm por aí, pode salvar. Pediu
também pra preparar a pasta que o Syncthing vai sincronizar.

**Decisão (tema):** `zen/theme/` versiona o CSS gerado pelos mods
(`chrome/zen-themes.css`, 9KB) + a pasta de cada mod
(`chrome/zen-themes/<uuid>/`, preferences.json/readme.md/chrome.css) — total
44KB, texto, gerado pela extensão ZenMods a partir de config que o Gustavo
edita na UI do Zen. `zen/export-theme.sh` copia do perfil Flatpak ativo
(descoberto via `installs.ini`, não hardcoded — o nome da pasta do perfil é
aleatório) pra dentro do repo; `zen/apply-theme.sh` faz o caminho inverso
numa máquina nova (`bootstrap.sh --apply --with-zen-theme`). Testado de
ponta a ponta com `HOME` isolado (export real + apply num perfil falso).

**Decisão (resto do perfil): fica de fora, de propósito.** `zen-sessions-backup/`
(7.6MB) e `sessionstore-backups/` (5.2MB) são estado vivo — arquivos
`.jsonlz4`/`.baklz4` **reescritos toda vez que o Zen abre/fecha uma aba**,
não config. Não entram no git pelo mesmo motivo que `fonts/` não entra mais
(binário grande e volátil não pertence ao histórico) — e não vira snapshot
manual como o tema porque muda demais pra isso fazer sentido.

**Syncthing pra "sessões": NÃO preparei a pasta ainda — risco real, levei a
pergunta de volta.** Inspecionei `zen-sessions-backup/`: os arquivos
`recovery.jsonlz4`/`recovery.baklz4` são sobrescritos continuamente enquanto
o Zen roda. Sincronizar essa pasta ao vivo (bidirecional, Syncthing) enquanto
o Zen está aberto é **o mesmo padrão de risco já documentado pro
`metadata.db` do Calibre** — dois lados escrevendo o mesmo arquivo vivo gera
`.sync-conflict` e pode corromper a sessão. Antes de criar a pasta, preciso
saber: (a) é sync entre **dois computadores** (Zen não roda em Android) — se
sim, qual o segundo; (b) o objetivo é sync contínuo (mesmas abas nas duas
máquinas, ao vivo — arriscado) ou snapshot/backup periódico (seguro, mas não
é "Syncthing" no sentido usual); (c) os dois nunca rodam Zen ao mesmo tempo
(mitigaria o risco, já que o conflito só ocorre com escrita concorrente).

**Por quê:** a IA não decide sozinha um design de sync que pode corromper
dado vivo do Gustavo — mesmo princípio já aplicado à trava do Calibre
(`livros-backup-sync.md`). Preparar a pasta sem entender o padrão de uso
seria assumir um design arriscado sem confirmação.

**Consequências:** tema do Zen já é portátil (git) a partir de agora; sessão
segue dependendo só do login nativo do Zen até a decisão do Syncthing ser
tomada. Item registrado no ROADMAP (balde Soon) até a resposta.

### 2026-09-16 — Dump/restore declarativo do dconf (tema + extensões do GNOME Shell)

**Contexto:** item Soon do ROADMAP — só ícones e `kdeglobals` estavam
versionados; o resto do tema do GNOME Shell (extensões habilitadas, config de
cada uma, `gtk-theme`/`icon-theme`/`cursor-theme` do GSettings, decoração de
janela) era ajuste manual perdido na GUI, contra o princípio de estilo
portátil.

**Decisão:** pacote novo `gnome-shell/` (não é pacote Stow — dconf é banco
binário, não arquivo symlinkável). Três snapshots versionados:
`interface.ini` (`/org/gnome/desktop/interface/`), `shell.ini`
(`/org/gnome/shell/`, inclui `enabled-extensions` e a config de cada
extensão) e `wm-preferences.ini` (`/org/gnome/desktop/wm/preferences/`,
layout dos botões de janela). `dump-dconf.sh` regenera os três a partir da
máquina atual; `restore-dconf.sh` aplica (`dconf load`) numa máquina nova,
com aviso explícito de que isso só restaura *configuração* — instalar as
extensões em si (apt: `gnome-shell-extensions` pra `ding`/`tiling-assistant`/
`ubuntu-appindicators`/`ubuntu-dock`/`user-theme`; extensions.gnome.org pra
`space-bar`/`Vitals`/`tactile`/`rounded-window-corners`/`no-overview`)
continua manual. Wireado no `bootstrap.sh --with-gnome-shell-theme`.

**Escopo deliberadamente estreito:** ficaram de fora atalhos de teclado
(`org.gnome.desktop.wm.keybindings` etc. — item separado, ainda não revisado),
`/org/gnome/mutter/` (comportamento/tiling, não tema) e wallpaper
(`/org/gnome/desktop/background/` está vazio no dconf — ainda no default do
Ubuntu, nunca customizado, nada a versionar por ora).

**Achado ao escrever o script:** `pop-shell@system76.com` aparece na lista
`enabled-extensions` mas **não está instalada** nesta máquina (provável
resíduo de teste com tiling — `tactile`/`tiling-assistant` já cobrem esse
papel). Não removido agora (não foi pedido); o GNOME Shell ignora UUID
inexistente sem erro, documentado como ruído conhecido no comentário do
`restore-dconf.sh`.

**Por quê:** `dconf dump /org/gnome/` inteiro traria muito ruído (estado de
sessão, histórico de comandos, posição de janela) — escopo por tema/extensões
é o que vale a pena versionar e restaurar; o resto é descartável.

**Consequências:** próxima vez que o tema/extensões mudar pela GUI, rodar
`./gnome-shell/dump-dconf.sh` e revisar o diff antes de commitar — não é
automático. README.md também ganhou entrada faltante pra `gtk-theme/`
(lacuna de documentação de sessão anterior, corrigida de passagem por estar
na mesma lista sendo editada).

### 2026-09-16 — Google Drive: rclone escolhido, runbooks de rclone e Syncthing escritos

**Contexto:** item Soon do ROADMAP pedia decidir GNOME Online Accounts (GOA)
vs. `rclone` pro Google Drive no Ubuntu. Checado o estado real da máquina:
`rclone v1.60.1` e `syncthing v1.27.2` **já instalados via apt**, nenhum dos
dois configurado (`rclone listremotes` vazio, `syncthing.service` existe mas
`disabled`, nunca rodou).

**Decisão:** **rclone**, não GOA. GOA só monta o Drive como pasta virtual
(bom pra navegar, não agenda nem sincroniza pasta↔nuvem sozinho); rclone roda
sem sessão gráfica, agenda via systemd timer, e serve o caso de backup já
desenhado no HQ ([`_hq/infra/livros-backup-sync.md`](../_hq/infra/livros-backup-sync.md)) sem depender de GUI.

**Documentação criada:** [docs/google-drive-rclone.md](docs/google-drive-rclone.md)
e [docs/syncthing.md](docs/syncthing.md) — runbooks passo a passo do que só o
Gustavo (humano) pode fazer: `rclone config` exige OAuth no navegador com
`gustavofsousa.me@gmail.com`; Syncthing exige parear o Android fisicamente.
Nenhum dos dois passos é executável pela IA.

**Por quê:** a IA não tem acesso ao navegador/sessão Google do Gustavo nem ao
celular físico — só dá pra levantar o que já está pronto (instalação) e deixar
o passo a passo exato do que falta, sem fingir que a configuração está feita.

**Consequências:** ambos os runbooks ficam prontos pra seguir assim que o
Gustavo tiver ~10-30 min; o caso concreto de uso (backup da biblioteca Calibre
via rclone, sync de `entrada/` via Syncthing) permanece detalhado no HQ, essas
docs novas cobrem a ferramenta em si (instalação, primeira configuração).

### 2026-09-16 — `fonts/` não vendoriza mais binário, baixa Nerd Font em build-time

**Contexto:** item Soon do ROADMAP; `fonts/JetBrainsMono/` e
`fonts/JetBrainsMonoSymbols/` tinham 232MB de `.ttf` versionados no git (131
arquivos), mesmo trade-off já resolvido em `icons/install-icons.sh` (SVG de
terceiros clonado em build-time, não vendorizado).

**Decisão:** `fonts/install-fonts.sh` reescrito pra baixar os releases oficiais
do `ryanoasis/nerd-fonts` (`JetBrainsMono.zip` + `NerdFontsSymbolsOnly.zip`,
pinado em `v3.5.1`) num diretório temporário e instalar em
`~/.local/share/fonts/`, mesmo padrão do `icons/`. `fonts/JetBrainsMono/` e
`fonts/JetBrainsMonoSymbols/` removidos do git. Testado de ponta a ponta com
`HOME` isolado (238MB instalados, `fc-cache` OK).

**Por quê:** binário de terceiro grande e reproduzível a partir de uma URL não
precisa viver no histórico do git — infla clone/fetch pra sempre (git não
esquece blob antigo) sem ganho, já que o release upstream é a fonte de verdade.

**Consequências:** clonar o repo de agora em diante já vem 232MB mais leve;
histórico antigo (commits anteriores) continua carregando esse peso — só um
`git filter-repo`/rewrite retroativo resolveria isso, não feito aqui (fora de
escopo, mexe com histórico). Instalar fonte exige rede (mesma limitação do
`icons/`).

### 2026-09-16 — Eliminado o tier `~/Archive` da Camada 2

**Contexto:** faxina de `~/Downloads` e revisão da Camada 2 (ver
`docs/organizacao-de-arquivos.md`) escancarou que `~/Archive` (criado
2026-09-11) tinha virado depósito sem curadoria — backup de biblioteca
Calibre, material-fonte já importado, vault Obsidian de teste vazio, tudo
misturado sem critério de saída. Servia só pra dar sensação de "resolvido"
por tirar da frente do Downloads.

**Decisão:** `~/Archive` deixa de existir como pasta de topo. Todo arquivo é
ou vivo num lugar categorizado (`Documents/<assunto>/`, `Projects/`) ou é
lixo — apagado. Sem meio-termo de "guardar por guardar". `docs/organizacao-de-arquivos.md`
e a reference da skill `arruma-meu-not-ai` já refletem isso.

**Por quê:** um tier "frio" sem critério de quando algo sai dele pra ser
apagado de vez tende a virar lixeira permanente — o problema não é ter dado
frio, é não ter decidido o destino final dele.

**Consequências:** conteúdo que estava em `~/Archive` foi triado nessa mesma
sessão — `calibre-envio1-2025-07/` e `livros-investimento-fonte-2026-09/`
apagados (fonte já importada e redundante com a biblioteca Calibre),
`obsidian-notes-vazio-2026-09-11/` apagado (vault de teste sem dado real).
Documentos reais que estavam em `~/Downloads` foram pra pastas próprias em
`~/Documents/` (`boletos/`, `carreira/`, `contracheque/`,
`documentos-pessoais-impostoderenda/`, `casamento/`, `geodata-rj/`,
`imoveis/`, `pessoal/`, `robozzle/`, `projetos-notas/`, mesclado em
`Marsalgado/`, `univ/tcc/`, `UFF/2026.2/`); manga fora do Calibre foi pra
`Documents/livros/entrada/` (staging).

**Ajuste 2026-09-16 (mesmo dia):** `biblioteca-backup-2026-09-11/` (2.6 GB) —
pedido explícito de **não apagar**, é a única cópia de segurança da biblioteca
Calibre hoje (ver `docs/livros-calibre.md`). Em vez de recriar `~/Archive`
(que voltaria a ser o depósito genérico que a decisão acima eliminou),
`~/Archive` foi **renomeado pra `~/Backups`** — tier estreito e intencional,
só pra snapshots de backup de verdade, não pra "frio sem categoria". Hoje
`~/Backups` tem só esse item.

### 2026-09-16 — Tema GTK/Shell sai do Adwaita, entra Tokyo Night + Fluent-purple

**Contexto:** pedido de mexer na top bar do GNOME escalou pra "não quero ficar
no Adwaita, pode pegar um novo tema pra tudo" — visual "mais programador +
minimalista", referência dada: Tokyo Night GTK Theme
(gnome-look.org/p/1681315, upstream real é
[Fausto-Korpsvart/Tokyonight-GTK-Theme](https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme)).
Usa o desktop de dia e de noite, então precisa alternar claro/escuro sem
perder o sol de vista durante o dia.

**Decisão (tema):** Tokyo Night (variante padrão "blue", que já é a paleta
clássica do tema) para GTK3, GTK4/libadwaita e GNOME Shell (top bar via
extensão User Themes), instalado com light+dark em `~/.themes` por
`gtk-theme/install-gtk-theme.sh` (clone efêmero do upstream, mesmo padrão do
`icons/install-icons.sh` — não vendoriza).

**Decisão (ícone):** perguntado se mantinha o Fluent orange/dark (combo
Monokai/Dolphin) ou trocava pra combinar — resposta: trocar, mas preservar
como o orange foi feito caso queira voltar. Resultado: novo script irmão
`icons/install-icons-tokyonight.sh` gera **Fluent-purple** (light+dark,
combina com a paleta azul/roxa do Tokyo Night); `icons/install-icons.sh`
(orange) **não foi tocado**, continua documentando a decisão de 2026-09-15.

**Decisão (claro/escuro):** perguntado automático-por-horário vs.
manual-por-script vs. manual-pelo-toggle-nativo — escolhido o **toggle
nativo** (Configurações > Aparência). Problema: esse toggle só seta
`org.gnome.desktop.interface color-scheme` (prefer-dark/prefer-light); pra
temas fora do Yaru isso não troca `gtk-theme`/`icon-theme`/tema do shell
sozinho. Solução: pacote Stow novo `theme-sync/` com um script
(`theme-sync-watcher.sh`) rodando como `systemctl --user` service
(`theme-sync.service`, `WantedBy=graphical-session.target`) que fica em
`gsettings monitor` na chave `color-scheme` e reaplica
gtk-theme/icon-theme/shell-theme (Tokyonight-{Light,Dark} +
Fluent-purple-{light,dark}) a cada mudança. Testado: troca em ~1s.

**Dependências instaladas:** `sassc` (build do tema, faltava) e
`gnome-shell-extensions` (traz a extensão "User Themes", necessária pra tema
valer na top bar — sem ela só GTK3/GTK4 dos apps mudam, não o shell). Ambos
via apt/sudo, manual (sandbox não tem senha interativa).

**Pendência:** extensão "User Themes" instalada mas GNOME Shell no Wayland só
recarrega extensões de sistema novas depois de logout/login — não dá pra
reiniciar o shell em uso como no X11. `gnome-extensions enable
user-theme@gnome-shell-extensions.gcampax.github.com` fica pra próxima sessão
gráfica.

**Erro cometido e corrigido:** `stow theme-sync` sem `-t ~` usou o alvo
default (pai do diretório atual = `~/projects`), criando
`~/projects/.config` e `~/projects/.local` como symlinks pro pacote — pego
antes de qualquer dano (pastas não tinham conteúdo, só foram removidas e
re-stowed com `-t ~`, seguindo a convenção do README). Lição: **sempre usar
`stow -v -t ~ <pacote>`**, nunca `stow <pacote>` puro dentro do repo.

**Consequências:** Alacritty/Neovim/tmux/VS Code continuam em Monokai (não
foram tocados — decisão de 2026-09-16 abaixo é sobre esses, separada da
mudança de tema do sistema aqui). `themes/tokyo-night/` (paleta antiga do
Alacritty) fica sem uso direto por enquanto — é uma paleta diferente da usada
pelo tema GTK (esse veio do repo Tokyonight-GTK-Theme direto, não do arquivo
local).

### 2026-09-16 — Monokai em Alacritty/Neovim/tmux/VS Code + Alacritty terminal padrão

**Contexto:** ícones e cursor do Dolphin já estavam em Monokai (2026-09-15), mas
o resto do sistema não: Alacritty estava em Tokyo Night, Neovim sem colorscheme
nenhum (cores cruas do terminal), tmux no tema cinza padrão do oh-my-tmux, VS
Code sem tema nem fonte definidos (apesar de ter 4 extensões monokai-* instaladas
e nunca ativadas). `$EDITOR`/`$VISUAL` também nunca tinham sido setados (só
`git core.editor=nvim`, isolado).

**Decisão (paleta):** Monokai clássico aplicado em todo o resto:
- Alacritty: bloco `[colors.*]` reescrito com a paleta clássica (mesmos hex
  usados no `kdeglobals`: bg `#272822`, fg `#f8f8f2`, etc.).
- Neovim: plugin `tanvirtin/monokai.nvim` adicionado
  (`lua/plugins/colorscheme.lua`), colorscheme `monokai` (não `monokai_classic`
  — nome errado tentado primeiro, corrigido depois de testar headless).
- tmux: as 17 `tmux_conf_theme_colour_*` do `.tmux.conf.local` remapeadas pra
  Monokai.
- VS Code: `workbench.colorTheme=Monokai` (tema **embutido**, sem precisar de
  extensão) + `editor.fontFamily`/`terminal.integrated.fontFamily` = JetBrains
  Mono. `settings.json` virou pacote Stow (`vscode/`) — antes só existia solto
  em `~/.config/Code/User/`.

**Decisão (padrão pra abrir algo):** `EDITOR`/`VISUAL=nvim` adicionados ao
`.zshrc` (pacote `home/`). `git core.editor` já era `nvim`, sem mudança.
Terminal padrão do sistema (`x-terminal-emulator`, usado por GNOME Files
"abrir terminal aqui", `Super+T`, etc.) trocado de `gnome-terminal` pra
`alacritty` via `update-alternatives --install` + `--set` — **manual, exige
sudo**, rodado pelo Gustavo diretamente (fora do escopo do bootstrap.sh).
**Deixado de fora, decisão consciente:** duplo-clique em arquivo de
texto/código no Dolphin/Nautilus continua abrindo GNOME Text Editor (GUI),
não terminal+nvim — mudar isso mudaria o fluxo de clique duplo de forma mais
invasiva do que o pedido cobria.

**Decisão (Tokyo Night guardado, não aplicado):** Gustavo achou o Tokyo Night
bonito também — bloco de cores original do Alacritty salvo em
`themes/tokyo-night/alacritty-colors.toml` pra retomar/comparar depois, sem
aplicar agora. `themes/README.md` documenta que só o Alacritty tem snapshot
completo (Neovim/tmux/VS Code nunca tiveram Tokyo Night configurado) e que um
switcher de verdade fica mais natural na Fase 3 (Nix/home-manager) do que um
script bash ad-hoc reescrevendo 4 arquivos.

**Por quê:** o objetivo declarado é "mesma cara entre todos os apps" — com
ícones/cursor decididos mas terminal/editor/multiplexador/IDE cada um numa
paleta diferente, a rice ficava pela metade. Testado headless (`nvim
--headless -c "colorscheme monokai"`) antes de declarar pronto, não só
assumido.

**Consequências:** próxima sessão tmux já abre com o tema novo (não havia
sessão ativa pra recarregar ao vivo). VS Code precisa reabrir (ou "Reload
Window") pra pegar tema/fonte novos — não testado ao vivo por não ter acesso
de screenshot no ambiente (mesma limitação já registrada na rice do Dolphin).

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
