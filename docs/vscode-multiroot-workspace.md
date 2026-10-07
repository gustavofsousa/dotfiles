# VS Code — multi-root workspace dos projetos

> Como o `~/projects/` é aberto no VS Code: um único **multi-root workspace**
> em vez de abrir uma pasta por vez. Decisão `NX5` do `_hq` — **em teste desde
> 2026-09-24, adotada em 2026-09-28** (o hábito pegou dentro da janela de
> avaliação). Ver o log de decisões em [STATE.md](../STATE.md).

## Ferramentas no sistema

Medido em 2026-10-06.

| Ferramenta | Estado | Origem |
| --- | --- | --- |
| **VS Code** 1.136.1 | ✅ | apt (repo oficial da Microsoft) |

**Personalização a preservar:**

| O que | Onde mora | Versionado? |
| --- | --- | --- |
| `settings.json` do usuário | `~/.config/Code/User/` | ✅ pacote Stow `vscode/` |
| `projects.code-workspace` | `~/projects/` | ❌ **de propósito** — ver abaixo |
| Extensões instaladas | perfil do VS Code | ⬜ **não** — reinstalar à mão em máquina nova |

> Extensões fora do git é lacuna conhecida, mas não vale um pacote Stow: a lista se
> exporta com `code --list-extensions`. Em Nix vira declarativo de verdade
> (`nix-vscode-extensions`, já no roadmap do `_hq` como `LT12`).

## O que é

O arquivo `~/projects/projects.code-workspace` declara os 12 folders da raiz
(`_hq` + os 11 projetos numerados) num só workspace. Abrir esse arquivo no VS
Code monta todos os repos lado a lado, cada um com seu próprio `.git`, e aplica
`settings`/`extensions` comuns a todos de uma vez — sem precisar reabrir pasta
a cada troca de projeto.

## Por que não é pacote Stow (nem é versionado aqui)

- O arquivo mora em `~/projects/`, que é **dado real** (projetos pessoais), não
  `~/.config/` — logo não espelha um caminho sob `$HOME/.config` como os
  pacotes Stow deste repo.
- Este repo é **público**. O workspace lista os nomes de todos os projetos
  privados — não é config que se queira publicar.
- É **regenerável**: são só os folders de `~/projects/` + os `settings`
  herdados. Recriar numa máquina nova é trivial (ver abaixo), então versionar
  o artefato não paga o custo.

Por isso ele fica **fora do git** — este doc é o snapshot declarativo do que o
arquivo contém e por quê, no mesmo espírito do snapshot dconf em
`gnome-shell/`.

## Como recriar numa máquina nova

1. `code ~/projects/projects.code-workspace` — se não existir, criar com esta
   forma: um array `folders` com um `{ "name", "path" }` por pasta de
   `~/projects/` (`_hq` primeiro, depois os numerados `01_`…`11_`), mais os
   blocos `settings` e `extensions` comuns.
2. Os `settings` do workspace excluem artefatos de build da árvore e da busca
   (`node_modules`, `.next`, `out`, `dist`, `.turbo`, `src/generated`,
   `.vercel`), ligam `explorer.excludeGitIgnore` e o file-nesting de
   `package.json`/`schema.prisma`. `.env`/`.env.*` ficam **visíveis** de
   propósito.
3. `extensions.recommendations`: `dbaeumer.vscode-eslint`,
   `bradlc.vscode-tailwindcss`, `Prisma.prisma`.
4. Settings de usuário (globais, por máquina) continuam vindo do pacote Stow
   `vscode/` (`~/.config/Code/User/settings.json`). O workspace só adiciona o
   recorte multi-root por cima.

## Reverter

Se o multi-root deixar de servir, basta voltar a abrir cada pasta
individualmente (`code ~/projects/<projeto>`) e apagar o arquivo — nada mais
depende dele.
