# Fase 3 — Migrar para Nix / home-manager

Ver [ROADMAP.md](../ROADMAP.md). Só começa quando as fases 0–2 estiverem
maduras.

## Objetivo

Aprender Nix a fundo e tornar o sistema reproduzível a partir de uma
configuração declarativa (pacotes + configurações), migrando
incrementalmente a partir da estrutura organizada pelo Stow.

## Escopo

Ainda não detalhado — esta spec deve ser revisitada e expandida quando a
Fase 2 estiver perto de concluir, com as respostas das fases anteriores em
mãos.

## Perguntas para pesquisar

1. **NixOS completo ou Nix + home-manager sobre Ubuntu?**
   💡 Nix + home-manager sobre a distro atual (Ubuntu) é a migração menos
   arriscada: reproduz configs e pacotes de usuário sem trocar o sistema
   operacional inteiro de uma vez. NixOS é o passo natural depois, se fizer
   sentido.

2. **Flakes ou configuração clássica (`channels`)?**
   💡 Flakes é o caminho mais usado hoje pela comunidade e tem melhor
   reprodutibilidade (lockfile explícito), mesmo ainda sendo tecnicamente
   "experimental" no Nix.

3. **Estratégia de migração incremental:** módulo por ferramenta (um
   `.nix` por pacote Stow existente: `sway.nix`, `waybar.nix`, etc.) rodando
   em paralelo com o Stow até a troca completa, ou big-bang por categoria?
   💡 Módulo por ferramenta espelha a estrutura de pacotes que já existe,
   reduz risco (dá para migrar `alacritty` e validar antes de mexer em
   `sway`) e é consistente com "migração incremental" já declarado no
   ROADMAP.

4. **Gerenciamento de segredos:** `age` de forma independente (ex:
   `agenix`) ou integrado ao home-manager? (Já listado como "em aberto" no
   ROADMAP.)

5. **O que este repo git vira depois da migração:** o mesmo repo passa a
   conter os arquivos `.nix` (substituindo gradualmente as pastas Stow), ou
   nasce um repo novo e este vira arquivo histórico?
   💡 Mesmo repo, mesma raiz de decisões — evita perder o histórico e o
   `STATE.md`/`ROADMAP.md` acumulados; a pasta por ferramenta pode conviver
   com `.nix` durante a transição.

## Critério de pronto

Esta fase é longa o suficiente para não ter um único critério de "pronto" —
deve ser quebrada em sub-fases quando chegar a hora (ex: primeiro pacote
migrado e validado, depois os demais, depois NixOS se fizer sentido).
