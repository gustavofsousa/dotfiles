# Organização de arquivos do notebook

Padrão de "onde cada coisa mora" para o computador inteiro — não só para o
que está neste repo. Serve de referência para as decisões de pasta das
Fases 1 e 2 do [ROADMAP.md](../ROADMAP.md). A decisão que originou este doc
está registrada no [STATE.md](../STATE.md).

> **Skill.** Existe uma skill que aplica este padrão na prática:
> `arruma-meu-not-ai` (em `~/.claude/skills/`). Ela tria pastas bagunçadas,
> decide onde arquivos moram, migra dotfiles pra XDG e audita a home. Este doc
> é a fonte de verdade; a reference da skill espelha ele.

> **Escopo.** Este doc define o *padrão*. Aplicar o padrão (mover pastas,
> renomear, ajustar apps) é trabalho das Fases 1/2 — aqui só se decide a
> convenção. Enquanto a aplicação não acontece, a realidade da home pode
> divergir deste doc; as divergências conhecidas estão listadas no fim.

## Princípio

Duas camadas, cada uma com seu padrão:

1. **Config, dados de app, cache, estado** → seguem a
   [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
   estritamente. É o padrão de fato no Linux e a maioria das ferramentas
   modernas já respeita — adotá-lo integralmente evita reinventar convenção.
2. **Arquivos do usuário** (documentos, projetos, mídia, arquivo frio) → o
   XDG não define onde moram. Aqui vale a convenção de pastas de topo em
   **inglês**, alinhada ao `xdg-user-dirs`, descrita abaixo.

Regra geral por trás das duas: **nomes em inglês** (consistência com o repo,
que é open-source-facing) e **dados privados sempre fora do git** — só
configuração entra neste repositório.

## Camada 1 — XDG Base Directory (config, dados, cache, estado)

Quatro diretórios-base, com os defaults do XDG (nenhuma `XDG_*_HOME` está
sobrescrita neste sistema, então valem os padrões):

| Variável            | Default            | O que guarda                                   |
| ------------------- | ------------------ | ---------------------------------------------- |
| `XDG_CONFIG_HOME`   | `~/.config`        | Configuração (o que este repo versiona).       |
| `XDG_DATA_HOME`     | `~/.local/share`   | Dados de app que devem persistir (não-cache).  |
| `XDG_STATE_HOME`    | `~/.local/state`   | Estado volátil-mas-útil: logs, histórico, undo.|
| `XDG_CACHE_HOME`    | `~/.cache`         | Cache descartável — pode apagar sem perda.     |
| `XDG_RUNTIME_DIR`   | `/run/user/1000`   | Sockets/arquivos efêmeros da sessão (do sistema).|

Diretrizes:

- **Config nova mora em `~/.config/<app>/`** e, se for versionada, vira um
  pacote do Stow neste repo espelhando esse caminho (ver
  [README.md](../README.md)).
- **Evitar dotfiles soltos na raiz da home** (`~/.foo`) quando o app suporta
  XDG. Quando não suporta, o dotfile de raiz vai para o pacote `home/`.
- **`~/.cache` é sempre descartável** — nunca colocar lá nada que doa perder,
  nunca versionar.
- **Não versionar** `~/.local/share`, `~/.local/state`, `~/.cache`: são dados
  de app/estado/cache, não configuração.

## Camada 2 — Arquivos do usuário (pastas de topo)

Nomes em inglês, alinhados ao `xdg-user-dirs` (`~/.config/user-dirs.dirs`),
mais três pastas próprias para o que o XDG não cobre (`Projects`, `Archive`,
e opcionalmente `Media` como guarda-chuva).

| Pasta          | XDG user-dir?      | O que mora                                        |
| -------------- | ------------------ | ------------------------------------------------- |
| `~/Documents`  | sim                | Documentos "vivos" (em uso, editáveis).           |
| `~/Downloads`  | sim                | Zona de entrada — temporário, some/some vira lixo.|
| `~/Pictures`   | sim                | Fotos e imagens.                                  |
| `~/Music`      | sim                | Música.                                           |
| `~/Videos`     | sim                | Vídeos.                                           |
| `~/Desktop`    | sim                | Área de trabalho — manter vazia/mínima.           |
| `~/Public`     | sim                | Compartilhamento — usar só se houver necessidade. |
| `~/Templates`  | sim                | Modelos de documento.                             |
| `~/Projects`   | não (próprio)      | Código e projetos pessoais.                       |
| `~/Archive`    | não (próprio)      | Frio: raramente acessado, guardado por segurança. |
| `~/Media`      | não (opcional)     | Guarda-chuva de mídia, só se Pictures/Music/Videos não bastarem. |

Diretrizes:

- **`Downloads/` é transiente.** Nada mora ali em definitivo — ou vira lixo,
  ou é movido para o lugar "certo" (`Documents/`, `Projects/`, `Archive/`…).
- **`Projects/` é o lar do código.** Convém, mas não é obrigatório, um esquema
  de prefixo numérico para ordenar (padrão já em uso hoje: `01_...`, `02_...`).
- **`Archive/` é frio.** O que não é usado há muito tempo mas não pode ser
  apagado. Diferente de `.cache` (descartável) e de `Documents` (vivo).
- **Sincronização (Drive, Syncthing) é ortogonal à estrutura.** A pasta
  sincronizada mora dentro dessas pastas de topo (ex: um subdir de
  `Documents/` ou uma pasta própria como `~/Drive`), não substitui o padrão.
  A decisão de qual pasta sincronizar com o quê é da Fase 1.

## Config viva vs. config no sótão (`attic/`)

Nem toda config que já foi usada continua ativa. Ao largar uma ferramenta
(ex: migrar de Sway/waybar para GNOME Ubuntu), a config **não é apagada** —
vai para o **sótão**, guardada e recuperável, mas fora do caminho.

Três estados possíveis para uma config:

| Estado    | Onde mora                       | Symlink (Stow)? | Versionado? |
| --------- | ------------------------------- | --------------- | ----------- |
| **Viva**  | pacote na raiz do repo          | sim (ativo)     | sim         |
| **Sótão** | `attic/<ferramenta>/` no repo   | não             | sim         |
| **Morta** | apagada (só se realmente lixo)  | —               | —           |

- **Sótão = `attic/` no próprio repo.** A config sai do Stow ativo (não vira
  mais symlink), mas continua no git — recuperável e **portátil** se um dia
  voltar a essa ferramenta ou mudar de distro. É o "guardar sem poluir o
  fluxo ativo".
- **Por que no repo e não em `~/Archive`:** config é o que este repo existe pra
  versionar. Mandar pra `~/Archive` perderia o histórico e a portabilidade. O
  `~/Archive` da Camada 2 é pra *dados* frios, não pra config.
- **Preserva o estilo entre distros:** manter as configs antigas arquivadas
  (não deletadas) é o que garante que seu "jeito de usar" sobrevive a uma troca
  de distro — e é base pronta pra Fase 3 (Nix/home-manager), que vai declarar
  esse estilo de forma reproduzível.

## Dados privados vs. git

- **Só configuração entra neste repo.** Dados de usuário (Camada 2), dados de
  app (`.local/share`), cache, estado e segredos ficam **fora do git**.
- **Segredos** (tokens, chaves, credenciais) nunca vão para o repo em texto
  puro — ver [AGENTS.md](../AGENTS.md). A solução declarativa de segredo é
  tema da Fase 3 (ver [ROADMAP.md](../ROADMAP.md)).

## Divergências conhecidas (a resolver nas Fases 1/2)

Estado real da home que ainda não bate com este padrão:

- `~/projects` está em **minúsculo**; o padrão é `~/Projects`. Renomear é
  trabalho da Fase 2 (envolve ajustar referências, não é só `mv`).
- `~/Archive` e `~/Media` ainda não existem — criar conforme a necessidade
  aparecer nas Fases 1/2.
- Existem dotfiles/pastas de app soltos na raiz da home que poderiam seguir
  XDG (`~/.fonts`, caches de várias linguagens, etc.). Migração caso a caso,
  sem pressa, nas Fases 1/2 — muitos são criados por ferramentas que não
  respeitam XDG, então nem sempre há o que fazer.
