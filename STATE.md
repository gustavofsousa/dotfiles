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
  `alacritty`, `nvim`, `tmux`, `home`. Bootstrap de máquina nova: `bootstrap.sh`.
- **Sótão (`attic/`, versionado sem symlink):** `sway`, `waybar`, `yambar`,
  `xremap` — ambiente tiling abandonado ao migrar pra GNOME/Ubuntu (Wayland).
  Arquivados em 2026-09, ver log de decisões. Resolve também o antigo impasse
  `waybar` vs `yambar`: ambos saíram do fluxo ativo juntos.
- `attic/`, `fonts/` e `zen/` não são pacotes do Stow — ver README.
- `tmux/.config/tmux/plugins/` (`tpm`, `tmux-resurrect`, `tmux-sensible`)
  são **submodules** de verdade (`.gitmodules` presente) — clone novo recupera
  com `git submodule update --init` (o `bootstrap.sh` faz isso).

## Log de decisões

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
