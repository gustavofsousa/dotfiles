# State

Snapshot do estado atual do repo — o que já está decidido e por quê, e o que
ainda está em aberto. Complementa [TODO.md](TODO.md) (pendências) e
[ROADMAP.md](ROADMAP.md) (direção de longo prazo): aqui é o retrato de agora.

## Estado atual

- Fase atual do [ROADMAP.md](ROADMAP.md): **Fase 0 concluída** — padrão de
  organização definido ([docs/organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md)),
  `AGENTS.md` revisado (symlink-vs-real, dados-privados-fora-do-git), e skill
  `arruma-meu-not-ai` criada em `~/.claude/skills/`. Nix/home-manager fica pra
  Fase 3. **Fase 1** (decisões por área) é a próxima.
- Gerenciador: **GNU Stow** (ver decisão abaixo). Pacotes ativos:
  `sway`, `waybar`, `alacritty`, `nvim`, `xremap`, `yambar`, `tmux`, `home`.
- `fonts/` e `zen/` não são pacotes do Stow — ver README.
- `waybar/` e `yambar/` coexistem no repo. `yambar/.config/yambar/config.yml`
  é uma config mínima/placeholder (só relógio) — parece experimento em
  andamento, não uma substituição decidida do waybar. Sem decisão registrada
  ainda sobre se um vai substituir o outro.
- `tmux/.config/tmux/plugins/` (`tpm`, `tmux-resurrect`, `tmux-sensible`)
  está commitado como gitlink (modo submodule) sem `.gitmodules` — um clone
  novo deixa essas pastas vazias. Ver TODO.

## Log de decisões

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
