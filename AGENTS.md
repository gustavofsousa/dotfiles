# AGENTS.md

Instruções para qualquer IA (Claude Code ou outra) que trabalha neste repo. O Claude Code lê este
arquivo como `CLAUDE.md`, por symlink.

## Constitution

```yaml
type: pessoal             # my own machine config; named by the owner on 2026-10-14
open-source: false
rigor:                      # off | designed | enforced; types, defaults and events: _hq/ia/catalogs/project-types.md
  auth: designed
  privacy: off
  tests: designed
  ci: off
  observability: off
  scale: off
```

- **Promotion is an event the owner names.** Never change `type` or raise an axis on your own.
  Types, defaults and events: `_hq/ia/catalogs/project-types.md`.

## O que é este repo

Dotfiles pessoais do Gustavo, gerenciados com **GNU Stow**. A estrutura está no `README.md`, a direção
futura no `ROADMAP.md`, e o retrato do estado atual e o log de decisões no `STATE.md`. O repo também
rastreia a organização do computador como um todo. Nem tudo em `TODO.md` vira arquivo neste git.

`docs/organizacao-de-arquivos.md` define onde cada tipo de arquivo mora no notebook (não só neste
repo). Consulte esse documento em toda decisão de pasta.

## Como a documentação é organizada

Cada arquivo tem **um** papel. Antes de escrever, escolha o lugar:

| Arquivo | Guarda | Não guarda |
| --- | --- | --- |
| `docs/<tema>.md` | o **desenho permanente** de um tema (galeria, biblioteca, backup, sincronizacao, nas, nix, notas-pkm, organizacao-de-arquivos) — estado atual, ferramentas, RFDs, caminhos de evolução, decisões | passo a passo de ação humana; lista de tarefas |
| `config.md` | **só** o que depende estritamente do humano (sudo, OAuth, celular, hardware). **Item feito é removido**, não marcado `[x]` | trabalho que a IA faz; decisão (RFD) |
| `ROADMAP.md` | o que falta fazer, em baldes, com IDs `AC*`; os RFDs abertos | o desenho; o passo a passo |
| `STATE.md` | retrato do estado atual + decisões **estruturais do repo** | decisão de tema (vai pro one-page) |
| `pesquisas/` | anotação externa datada, **texto original preservado**, com nota de confiança | conclusão minha (vai pro one-page) |
| `deposito/` | arquivo morto datado — **nada morre sem colheita** | nada que ainda esteja em uso |

## Registrar ferramenta e comando CLI definitivo

**Quando um passo novo, um comando CLI ou uma ferramenta fica definitivo no fluxo, registre-o na
seção "Ferramentas no sistema" do one-page do tema.** Nunca deixe o registro só no histórico da
conversa ou só no commit.

A seção tem duas tabelas:

- **Ferramentas:** no mínimo **ferramenta + versão**, para que serve, estado (✅ instalado / ⬜ falta)
  e **origem** (`apt`, `snap`, `flatpak`, instalador oficial, script).
- **Personalização:** o que foi configurado, onde o arquivo mora e se está versionado.

Por que isso importa:

- **A migração para o Nix depende disso.** O `home.packages` precisa da lista real do que está
  instalado e de onde veio. Descobrir isso depois, ferramenta por ferramenta, é trabalho perdido
  (`docs/nix.md`).
- Uma máquina nova precisa saber o que reinstalar e o que o `bootstrap.sh` já cobre.
- A origem não é detalhe. Um pacote de `apt`, um instalador oficial e um snap mudam a declaração no
  Nix e quem atualiza.

Regras práticas:

- **Verifique antes de escrever.** Rode o `--version` e confira a origem (`dpkg -l`, `snap list`,
  `flatpak list`, `readlink -f $(command -v x)`). Nunca presuma versão nem gerenciador. Date a
  medição.
- **Ferramenta recorrente e genérica** (diagnóstico de disco, metadados, cópia): registre-a também
  como **dependência recomendada no `bootstrap.sh`**. É o bloco que avisa e segue, sem abortar como
  `git`/`stow`.
- **Credencial e identidade de máquina nunca entram no git:** `rclone.conf`, `config.xml` do
  Syncthing, tokens. Registre na tabela *que existem e onde moram*, marcados como não versionados.

## Regras de comportamento

- **Não edite o `TODO.md` a toda hora.** Atualize quando o fluxo da conversa pedir (uma pendência
  resolvida, um item novo relevante). Nunca reescreva o arquivo a cada pequena interação. Se tiver
  dúvida, pergunte antes de persistir.
- **O `STATE.md` segue o mesmo espírito.** Só atualize o log de decisões quando a conversa tomar uma
  decisão de fato, não a cada mudança de código. Decisão nova vai no topo do log, no formato
  "Contexto / Decisão / Por quê / Consequências".
- **Nunca apague nem sobrescreva um arquivo real (não symlink) sem confirmação explícita**, mesmo que
  o conteúdo já esteja em outro lugar. Um arquivo real na home (por exemplo, antes de virar pacote do
  Stow) pode ter estado que não está no git.
- **Symlink vs. arquivo real ao reorganizar (Fases 1/2).** Antes de mover, renomear ou apagar
  qualquer coisa fora deste repo, cheque o que é:
  - **Symlink que aponta para este repo** (`ls -l` mostra `-> .../dotfiles/...`): você pode recriar
    o symlink livremente. O dado de verdade está no git.
  - **Arquivo ou pasta real** (dado pessoal, não versionado: `Documents/`, `projects/`, mídia,
    `Downloads/`): mover ou apagar **exige confirmação explícita**. Prefira mover (`mv`) a copiar e
    apagar. Nunca rode `rm -rf` sem OK. Nunca sobreponha um destino com conteúdo sem avisar.
- **Dados privados ficam fora do git.** A home tem muita coisa que não é dotfile: dados pessoais,
  projetos, mídia, caches, segredos. Só **configuração** entra neste repo. Se algo parecer dado ou
  segredo, pare e pergunte antes do commit (regra de repo público abaixo).
- **Commits atômicos, sem esperar OK.** Quando uma mudança coesa ficar pronta, faça o commit. Estas
  regras continuam:
  - Um commit por mudança coesa. Nunca junte frentes diferentes.
  - Conventional Commits.
  - **Nunca** leve mudança alheia (por exemplo, uma edição em andamento noutro arquivo) num commit
    que não é sobre ela. Antes do commit, confira `git status` e `git diff --cached`.
  - As travas de segurança abaixo (segredo em repo público, arquivo real fora do repo) continuam a
    exigir confirmação. A liberdade é só de cadência de commit.
- **Este repo é público.**
  WARNING: Nunca commite segredo, token ou credencial em texto puro. Um segredo enviado ao remoto
  público não volta. Antes de adicionar algo desse tipo, pare e pergunte. Segurança de segredo em
  repo público é decisão consciente, não default.
- **Ferramenta nova:** siga a convenção do repo. Crie uma pasta na raiz por ferramenta, com conteúdo
  que espelha o caminho real a partir de `$HOME` (por exemplo `foo/.config/foo/...`). Para dotfile
  na raiz da home, use `home/`.
- A documentação deste repo é em **PT-BR**: é uso pessoal, não open-source-facing.

## Mudança estrutural grande

Exemplos: migrar para o Nix, trocar ferramenta de novo, mexer em segredo. Trate como decisão que
precisa de confirmação antes de executar, não como tarefa de rotina. O `ROADMAP.md` diz o que já
está decidido e o que está em aberto.
