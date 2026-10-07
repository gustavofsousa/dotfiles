> **Arquivado 2026-10-06.** Log cronológico de decisões de setembro/2026 e da
> primeira semana de outubro (de 2026-09 a 2026-09-28). Saiu do `STATE.md` porque
> o arquivo passou de 890 linhas e ficou impossível achar a decisão de um tema.
>
> **Colhido para:** as decisões que ainda governam o trabalho foram redistribuídas
> nos one-pages por tema — [`docs/galeria.md`](../docs/galeria.md),
> [`docs/biblioteca.md`](../docs/biblioteca.md), [`docs/backup.md`](../docs/backup.md),
> [`docs/nas.md`](../docs/nas.md), [`docs/organizacao-de-arquivos.md`](../docs/organizacao-de-arquivos.md)
> — cada um com sua seção "Decisões". O resumo do estado de tema/ricing/Stow
> continua no topo do [`STATE.md`](../STATE.md). Nada foi perdido; o git tem tudo.

# State — log de decisões arquivado (set–out/2026)

### 2026-09-28 — VS Code multi-root workspace adotado (`~/projects/projects.code-workspace`)

- **Contexto:** eu abria uma pasta por vez no VS Code e reabria a cada troca de
  projeto. Em 2026-09-24 montei um multi-root workspace com os 12 folders da
  raiz de `~/projects/` (`_hq` + 11 numerados) pra testar o hábito de ter tudo
  lado a lado. Item `NX5` do roadmap do `_hq`, com janela de avaliação de 1-2
  semanas: "se pegar o hábito, documentar; se não, arquivar e voltar a abrir
  pasta única".
- **Decisão:** o hábito pegou dentro da janela — **adotado**. Documentado em
  [docs/vscode-multiroot-workspace.md](docs/vscode-multiroot-workspace.md) como
  parte do setup de máquina.
- **Por quê:** cada repo mantém seu próprio `.git` (multi-root não funde
  histórico) e um `settings`/`extensions` comum se aplica a todos de uma vez;
  trocar de projeto virou clicar numa pasta em vez de reabrir janela.
- **Consequências:** o arquivo `.code-workspace` fica **fora do git** — mora em
  `~/projects/` (dado real, não `~/.config`), este repo é público e lista os
  nomes de projetos privados, e é regenerável a partir dos folders + settings.
  Não é pacote Stow; o doc é o snapshot declarativo (mesmo espírito do
  `gnome-shell/`). Reverter = apagar o arquivo e abrir pasta a pasta.

### 2026-09-17 — Wallpaper trocado pro símbolo real do Tokyo Night (Tokyo Tower)

**Contexto:** logo depois de aplicar o wallpaper "gnome" (pegada + listras),
Gustavo pediu "coloca o símbolo do Tokyo Night" — o repo de wallpapers não
tem nenhum arquivo pronto com esse símbolo (só variantes por SO/DE:
gnome/kde/i3wm/xfce/wordpress/stripes). Achei o símbolo de verdade no
`theme-icon.png` da raiz do mesmo repo: a **Tokyo Tower** (a torre real que
dá nome ao tema) com "function" repetido atrás nas 5 cores de sintaxe do
tema — é o logo/avatar oficial do projeto no GitHub.

**Decisão:** compor um wallpaper novo a partir desse ícone em vez de usar
algo pronto. Processo (com dois bugs no caminho, ver abaixo): isolar a arte
(torre + texto) removendo o fundo do badge original por cor
(`-transparent`), aparar uma margem residual da borda arredondada do badge
com `-shave`, montar sobre canvas sólido 3840x2160 nas cores exatas do tema
(`#1a1b26` noite, `#d5d6db` dia — mesmas do wallpaper anterior, pra manter
consistência caso troque de novo). Pra variante clara, a torre precisou ser
recolorida de `#c0c9f5` (lavender, ilegível em fundo claro) pro `#343b58`
(tom "fg" do Tokyo Night Day) — texto "function" manteve as cores originais
(pastéis do tema legíveis em ambos fundos, não precisou de mapa de recolor
completo). Substituiu as duas SVGs anteriores em
`wallpaper/backgrounds/tokyo-night-symbol-{night,light}.png` — mesmo script
`apply-wallpaper.sh`, só os nomes de arquivo mudaram.

**Dois bugs de ImageMagick no processo, pra não repetir:**
1. `-opaque "#COR" -fill none` **não produz transparência** (pinta preto
   opaco em vez de transparente) — usar sempre o operador dedicado
   `-transparent "#COR"`.
2. `-alpha Associate`/`-alpha Disassociate` ao redor de um `-resize`, feito
   pra tentar consertar uma franja de borda visível contra fundo vermelho de
   teste, **piorou tudo**: criou uma caixa preta sólida ao compor sobre um
   canvas escuro de verdade. A franja original só aparecia contra vermelho
   por coincidência de contraste — um `-resize` simples, sem o truque de
   associate/disassociate, já ficava limpo contra os fundos reais
   (`#1a1b26`/`#d5d6db`). A franja residual real (visível só contra fundo
   claro) era uma borda física desenhada no PNG original perto do canto
   arredondado, resolvida aparando alguns pixels com `-shave` antes de
   qualquer outra operação — não era artefato de anti-aliasing, então
   `-fuzz` alto (testado até 40%) nunca teria resolvido.

**Verificação:** cada etapa (remoção de fundo, recolor, resize, composição
final) foi conferida rasterizando e lendo o PNG resultante antes de seguir
pra próxima — pegou os dois bugs acima antes de aplicar de verdade.

**Consequências:** nenhuma mudança de fundo/paleta/processo, só troca do
motivo visual. `wallpaper/LICENSE-upstream.txt` continua válido (mesmo repo,
mesma licença MIT) — a nota do script agora deixa claro que a imagem é
**composta** a partir do `theme-icon.png` deles, não um arquivo copiado
direto do diretório de wallpapers.

### 2026-09-17 — Extensão "User Themes" habilitada + wallpaper Tokyo Night

**Contexto:** pendência deixada em 2026-09-16 — extensão instalada mas só
carrega no GNOME Shell (Wayland) depois de logout/login. Gustavo avisou que
tinha feito logout e voltado; pediu pra habilitar a extensão, revisar se
tudo ficou certo, e adicionar um wallpaper Tokyo Night.

**Decisão (extensão):** `gnome-extensions enable
user-theme@gnome-shell-extensions.gcampax.github.com` — confirmado `State:
ACTIVE`. Testado o watcher (`theme-sync.service`) de ponta a ponta depois
disso: alternar `color-scheme` agora troca `gtk-theme`, `icon-theme` **e**
`org.gnome.shell.extensions.user-theme name` juntos em ~1s (antes só os dois
primeiros respondiam, porque o schema da extensão nem existia até habilitar).

**Decisão (wallpaper):** design oficial "gnome" do repo
[tokyo-night/wallpapers](https://github.com/tokyo-night/wallpapers) (MIT) —
minimalista, pegada do GNOME com listras na paleta do tema, casa com o pedido
original de visual "mais programador + minimalista". Pasta `night/minimal` e
`light/minimal`, formato SVG (`_scalable`, lossless — evita escolher
resolução fixa). Vendorizado direto em `wallpaper/backgrounds/*.svg` (6KB
cada) em vez de clone efêmero — são só 2 imagens estáticas, não um tema pra
rebuildar, então vendorizar é mais simples e sem trade-off real.
`wallpaper/apply-wallpaper.sh` copia pra `~/.local/share/backgrounds/` e seta
`org.gnome.desktop.background picture-uri`/`picture-uri-dark`. **GNOME troca
sozinho entre os dois conforme o toggle nativo claro/escuro** — descoberta
importante: essa chave já existe nativamente
(`org.gnome.desktop.background picture-uri-dark`), então o wallpaper não
precisou entrar no watcher do `theme-sync/` como o resto precisou.

**Erro cometido e corrigido:** primeira tentativa colocou
`wallpaper/apply-wallpaper.sh` dentro da árvore que o Stow espelha
(`wallpaper/.local/share/backgrounds/...` + o script solto na raiz do
pacote) e rodei `stow -t ~ wallpaper` — isso criou um symlink solto direto em
`~/apply-wallpaper.sh` (script na raiz do pacote não tem prefixo de pasta
oculta, então o Stow espelha ele direto pra raiz da home). Desfeito com
`stow -D -t ~ wallpaper` e reestruturado: `wallpaper/` **não é pacote Stow**
(mesmo padrão de `icons/`/`gtk-theme/`), o script copia os arquivos ele
mesmo. Lição: pacote Stow só deve conter caminhos que já espelham `$HOME`
corretamente (`.config/...`, `.local/...`) — qualquer arquivo solto na raiz
do pacote vaza pra raiz da home.

**Verificação:** rasterizei as duas SVGs com `convert` (ImageMagick) e li as
PNGs geradas pra conferir visualmente — captura de tela direta não funcionou
(`gnome-screenshot` ausente, D-Bus `org.gnome.Shell.Screenshot` negado por
sandbox, `grim` incompatível com Mutter/Wayland). As duas variantes
renderizaram corretamente antes de aplicar.

**Consequências:** ricing do sistema (tema+ícone+shell+wallpaper) fechado
ponta a ponta, claro e escuro, tudo versionado e reaplicável num
`bootstrap.sh --apply --with-wallpaper` numa máquina nova. Falta só o item
de mood/referência visual do backlog da skill `ricing-do-gustavo` (não
pedido nesta conversa).

### 2026-09-16 — `zen/` guarda o tema (ZenMods); Syncthing não tem nada a ver com o Zen

**Contexto:** item Soon do ROADMAP — decidir se `zen/` fica só com notas ou
guarda exportáveis do perfil Flatpak. Gustavo esclareceu: o Zen sincroniza
sozinho pelo próprio login (Firefox/Zen Account) — Syncthing não entra nessa
história. Tema não vem pelo login, pode salvar no repo. O pedido de
"preparar a pasta que o Syncthing vai sincronizar" era sobre **livros**, não
Zen (ver decisão separada abaixo) — cheguei a interpretar errado e preparei
uma pergunta sobre sync de sessão do Zen que não fazia sentido; o Gustavo
corrigiu antes de eu seguir com isso.

**Decisão (tema):** `zen/theme/` versiona o CSS gerado pelos mods
(`chrome/zen-themes.css`, 9KB) + a pasta de cada mod
(`chrome/zen-themes/<uuid>/`, preferences.json/readme.md/chrome.css) — total
44KB, texto, gerado pela extensão ZenMods a partir de config que o Gustavo
edita na UI do Zen. `zen/export-theme.sh` copia do perfil Flatpak ativo
(descoberto via `installs.ini`, não hardcoded — o nome da pasta do perfil é
aleatório) pra dentro do repo; `zen/apply-theme.sh` faz o caminho inverso
numa máquina nova (`bootstrap.sh --apply --with-zen-theme`). Testado de
ponta a ponta com `HOME` isolado (export real + apply num perfil falso).

**Decisão (resto do perfil): fica de fora.** Sessão/histórico/senhas/extensões
do navegador continuam fora do dotfiles — é estado vivo do Zen, e o próprio
Zen já resolve a portabilidade disso via login. Nada a preparar aqui.

**Por quê:** só o que não tem outro mecanismo de portabilidade (o tema, que
o login do Zen não cobre) precisa de solução própria; duplicar o que o login
já resolve seria refazer trabalho.

### 2026-09-16 — Syncthing dos livros: segunda pasta `para-celular/` (PC → Android)

**Contexto:** Gustavo quer ler no celular livros que já estão na biblioteca
do Calibre, além do fluxo já desenhado de `entrada/` (celular → PC, pra
entrar no Calibre). Sincronizar a `biblioteca/` inteira pra isso é a mesma
armadilha já documentada (`metadata.db` SQLite vivo → `.sync-conflict` →
corrupção).

**Decisão:** pasta nova `~/Documents/livros/para-celular/` (criada, vazia),
via oposta a `entrada/` — PC → Android. Populada manualmente pelo Calibre
("Save to disk" ou `calibredb export`, CLI já instalada): cópias soltas de
epub/pdf, sem o índice do Calibre, mesmo raciocínio de segurança que já
protege a `entrada/`. No Syncthing, configurada como **Send Only** no PC e
**Receive Only** no celular — o celular nunca escreve nessa pasta, elimina
qualquer chance de conflito mesmo se o uso crescer. Documentado em
[docs/syncthing.md](docs/syncthing.md) (runbook) e
[`docs/acervo-digital.md`](docs/acervo-digital.md)
(desenho completo, Peça 1 atualizada — editado mas **não commitado**, é
outro repo com mudanças próprias em andamento que não me cabe tocar).

**Por quê:** a trava do `metadata.db` já ensinou que sync bidirecional de
índice vivo corrompe; a solução que já funciona pra `entrada/` (arquivo
solto, não índice) se generaliza pra via contrária sem reinventar nada.
Send Only/Receive Only é reforço extra — mesmo que `para-celular/` nunca
tenha risco de índice vivo, elimina qualquer escrita acidental do lado do
celular.

**Consequências:** falta só a ação manual do Gustavo (pareamento Syncthing,
ver runbook) — pasta e desenho já prontos dos dois lados (dotfiles + HQ).

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
desenhado no HQ ([`docs/acervo-digital.md`](docs/acervo-digital.md)) sem depender de GUI.

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
[`docs/acervo-digital.md`](docs/acervo-digital.md) (ver
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
dotfiles** e passou a viver no HQ (`_hq/infra/acervo-digital.md`), rumo a NAS —
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
