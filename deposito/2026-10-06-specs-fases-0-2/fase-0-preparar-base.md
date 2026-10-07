# Fase 0 — Preparar a base

Ver [ROADMAP.md](../ROADMAP.md) para como esta fase se encaixa no plano
geral. Duas frentes independentes, ambas pré-requisito conceitual antes da
Fase 1/2 mexerem em arquivo de verdade.

## Objetivo

1. Deixar `AGENTS.md`/skills deste repo maduros o bastante para a IA
   executar as fases seguintes (incluindo a migração para Nix) com qualidade
   e sem supervisão constante.
2. Definir e documentar um padrão de organização de arquivos válido para o
   notebook inteiro — não só para este repo — que vai guiar todas as
   decisões de pasta das fases 1 e 2.

## Escopo

- Não inclui executar a reorganização (isso é Fase 1/2). Aqui só se decide
  o padrão e se prepara a documentação/regras.
- Cobre o notebook como um todo: dotfiles, mas também downloads, documentos,
  projetos pessoais, mídia, backups — qualquer coisa que precise de um lugar
  "certo" para morar.

## Perguntas para pesquisar

Pesquise e volte com uma resposta (ou decisão provisória) para cada uma.
Sugestões marcadas com 💡 são ponto de partida, não recomendação fechada.

1. **Padrão de organização de arquivos:** o notebook vai seguir a
   [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
   estritamente, uma variação dela, ou outro padrão?
   💡 XDG é o padrão de fato no Linux (`~/.config`, `~/.local/share`,
   `~/.cache`, `~/.local/state`) e a maioria das ferramentas modernas já
   respeita — adotar ele integralmente evita reinventar convenção.

2. **O que fica fora do escopo do XDG:** documentos pessoais, projetos de
   código, mídia (fotos, livros, música) não têm posição definida no XDG.
   Qual convenção usar para essas pastas (`~/Documentos`, `~/Projetos`,
   `~/Media` etc.)?
   💡 Um padrão simples e comum: `~/Projects` (código), `~/Documents`
   (documentos "vivos"), `~/Archive` (frio, raramente acessado), `~/Media`
   (fotos/vídeos/música), mantendo nomes em inglês para consistência com o
   resto do repo sendo open-source-facing — mas os *dados* continuam
   privados/fora do git.

3. **Como registrar o padrão:** vira uma seção no `STATE.md` deste repo, um
   documento próprio (`specs/` ou `docs/`), ou uma skill em `~/.claude/skills/`
   que a IA carrega quando for organizar arquivos?
   💡 Registro curto no `STATE.md` (é uma decisão, não um processo) e, se o
   padrão for complexo o bastante para precisar de checklist toda vez que
   surgir uma pasta nova, uma skill dedicada.

4. **Regras da IA (`AGENTS.md`) — o que falta?** Releia o `AGENTS.md` atual
   com o plano de 4 fases em mente: alguma regra de segurança, de commit, ou
   de organização está faltando para a IA executar Fase 1/2/3 sem
   supervisão constante?
   💡 Prováveis lacunas: regra explícita sobre como lidar com arquivos que
   já existem fora do git (dados pessoais, não-dotfiles) durante a
   reorganização; critério de quando pedir confirmação ao mover/apagar
   arquivo real vs. symlink.

5. **Skills a trazer/criar:** existe skill de organização de dotfiles, XDG,
    Nix/home-manager que valha adicionar a `~/.claude/skills/` agora,
   mesmo antes da Fase 3? Pode ser também skill para organização de documentos pessoais, mídia, backups, o próprio computador, temas, ricing, etc. Tornar a IA o organizadora de arquivos do notebook inteiro é o objetivo da Fase 0, então vale trazer skills que ajudem nisso. Se necessário pode trazer skills a mais e antes de cada fase mesclar ou ir adaptando para o estilo do Gustavo.
   💡 Nix/home-manager especificamente pode esperar a Fase 3 (evita estudar
   algo que muda de opinião até lá); XDG e organização geral de arquivos
   valem a pena trazer já, pois orientam a Fase 1.

## Critério de pronto

- Padrão de organização de arquivos escrito e registrado (pergunta 1–3
  respondidas).
- `AGENTS.md` revisado com as lacunas da pergunta 4 fechadas.
- Decisão tomada sobre quais skills trazer agora vs. na Fase 3.
