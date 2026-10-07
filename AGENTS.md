# AGENTS.md

Instruções pra qualquer IA (Claude Code ou outra) que for mexer neste repo.
Lido como `CLAUDE.md` via symlink.

## O que é este repo

Dotfiles pessoais do Gustavo, gerenciados com **GNU Stow** (ver `README.md`
pra estrutura, `ROADMAP.md` pra direção futura, `STATE.md` pro retrato do
estado atual e log de decisões). Também é onde ele rastreia organização do
computador como um todo — nem tudo em `TODO.md` vira arquivo neste git.

Onde cada tipo de arquivo mora no notebook (não só neste repo) segue o padrão
documentado em `docs/organizacao-de-arquivos.md` — consulte-o para qualquer
decisão de pasta.

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

**Toda vez que um passo novo, comando CLI ou ferramenta se tornar definitivo no
fluxo, registre-o na seção "Ferramentas no sistema" do one-page do tema** — não
deixe só no histórico da conversa nem só no commit.

A seção é uma tabela com, no mínimo: **ferramenta + versão**, pra quê serve, estado
(✅ instalado / ⬜ falta) e **origem** (`apt`, `snap`, `flatpak`, instalador oficial,
script). Mais a tabela de **personalização**: o que foi configurado, onde o arquivo
mora, e se está versionado.

Por que isso importa:

- **a migração pro Nix depende disso** — `home.packages` precisa da lista real do que
  está instalado e de onde veio; descobrir isso depois, ferramenta por ferramenta, é
  trabalho perdido (ver `docs/nix.md`);
- máquina nova precisa saber o que reinstalar e o que o `bootstrap.sh` já cobre;
- "origem" não é detalhe: pacote de `apt` versus instalador oficial versus snap muda
  como se declara no Nix e quem atualiza.

Regras práticas:

- **Verifique antes de escrever.** Rode o `--version` e confira a origem
  (`dpkg -l`, `snap list`, `flatpak list`, `readlink -f $(command -v x)`). Nunca
  presuma versão nem gerenciador — e date a medição.
- **Ferramenta recorrente e genérica** (diagnóstico de disco, metadados, cópia) entra
  também como **dependência recomendada no `bootstrap.sh`** — o bloco que avisa e
  segue, sem abortar como `git`/`stow`.
- **Credencial e identidade de máquina nunca são versionadas** — `rclone.conf`,
  `config.xml` do Syncthing, tokens. Registre na tabela *que existem e onde moram*,
  marcados como não-versionados.

## Regras de comportamento

- **Não fique editando `TODO.md` a toda hora.** Pode atualizar quando fizer
  sentido no fluxo da conversa (ex: pendência resolvida, item novo relevante
  descoberto), mas sem ficar reescrevendo o arquivo a cada pequena interação.
  Em dúvida, pergunte antes de persistir.
- **`STATE.md` segue o mesmo espírito:** só atualize o log de decisões quando
  uma decisão de fato foi tomada na conversa (não a cada mudança de código).
  Decisão nova vai no topo do log, formato "Contexto / Decisão / Por quê /
  Consequências".
- **Nunca apague ou sobrescreva um arquivo real (não-symlink) sem
  confirmação explícita**, mesmo que o conteúdo já tenha sido incorporado em
  outro lugar. Arquivos reais na home (ex: antes de virar pacote do Stow)
  podem ter estado que não está no git.
- **Symlink vs. arquivo real ao reorganizar (Fases 1/2).** Antes de mover,
  renomear ou apagar qualquer coisa fora deste repo, cheque o que é:
  - **Symlink apontando pra este repo** (`ls -l` mostra `-> .../dotfiles/...`):
    pode recriar/refazer o symlink à vontade — o dado de verdade está no git.
  - **Arquivo/pasta real** (dado pessoal, não versionado — `Documents/`,
    `projects/`, mídia, `Downloads/`): mover ou apagar **exige confirmação
    explícita**. Prefira mover (`mv`) a copiar-e-apagar, nunca `rm -rf` sem
    OK, e nunca sobreponha um destino que já tem conteúdo sem avisar.
- **Dados privados ficam fora do git.** A home tem muita coisa que não é
  dotfile (dados pessoais, projetos, mídia, caches, segredos). Só entra neste
  repo o que é **configuração**. Na dúvida sobre commitar algo que pareça
  dado/segredo, pare e pergunte (ver regra de repo público abaixo).
- **Pode ir commitando em commits atômicos conforme conclui cada mudança
  coesa** — não precisa esperar OK a cada commit. Regras que continuam
  valendo: um commit por mudança coesa (não empacotar frentes diferentes
  juntas), Conventional Commits, e **nunca** levar mudança alheia (ex: edição
  em andamento noutro arquivo) junto de um commit que não foi sobre ela —
  confira `git status` e `git diff --cached` antes. As travas de segurança
  abaixo (segredo em repo público, arquivo real fora do repo) permanecem
  exigindo confirmação; a liberdade é só de cadência de commit.
- **Este repo é público.** Nunca commite segredo, token, ou credencial em
  texto puro. Antes de adicionar algo nesse sentido, pare e pergunte —
  segurança de segredo em repo público é decisão consciente, não default.
- Ao adicionar uma ferramenta nova, siga a convenção existente: uma pasta na
  raiz por ferramenta, conteúdo espelhando o caminho real a partir de
  `$HOME` (ex: `foo/.config/foo/...` ou, pra dotfile de raiz da home, dentro
  de `home/`).
- Documentação deste repo é em **PT-BR** — é uso pessoal, não
  open-source-facing.

## Se for propor mudança estrutural grande

(ex: migrar pra Nix, trocar ferramenta de novo, mexer em segredo) — trate
como decisão que precisa de confirmação antes de executar, não como tarefa
de rotina. Ver `ROADMAP.md` pra saber o que já está decidido vs. em aberto.
