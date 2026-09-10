# Roadmap

Direção de longo prazo pra esse repo, não um cronograma fechado.

## Agora — GNU Stow

Escolhido em 2026-09 priorizando durabilidade sobre feature-set: é só
symlink, existe desde 1996, sem formato próprio, sem mantenedor único do
qual depender. Se o projeto parar de existir amanhã, os symlinks já criados
continuam funcionando exatamente igual.

Cobre a organização estrutural (onde cada config mora). Não resolve segredo
em repo público — hoje não guardamos nenhum, e isso é decisão consciente,
não limitação ignorada (ver `AGENTS.md`).

## Próximo — Nix / home-manager

Objetivo declarado: aprender Nix a fundo, construindo essa skill fazendo a
configuração junto com IA em vez de sozinho no escuro. Não é só trocar de
gerenciador de dotfiles — é adotar gerenciamento declarativo do sistema
inteiro (pacotes + config), categoria diferente do que o Stow resolve.

Sem data prevista. Sinal de que chegou a hora: quando o objetivo for menos
"organizar arquivo" e mais "todo o sistema reproduzível a partir de uma
config só".

Quando começar, a migração é incremental — não precisa jogar fora o que o
Stow já organizou. A estrutura por ferramenta (`sway/`, `waybar/`, etc.)
continua fazendo sentido como referência mesmo depois de convertida pra Nix.

## Não decidido ainda

- Se o gerenciamento de segredo (quando existir) vai ser via `age` avulso ou
  via o que o Nix/home-manager oferecer nativamente — depende de como a
  migração andar.
