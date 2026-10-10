# Nix / home-manager — o horizonte declarativo

Doc de **horizonte**: nada aqui existe ainda. O objetivo não é só "usar Nix" — é
**aprender Nix a fundo** e ter um sistema reproduzível por configuração declarativa.
Era `specs/fase-3-migrar-nix.md`; virou one-page em 2026-10-06 porque as perguntas
seguem abertas de verdade (as das fases 0-2 já foram todas respondidas e
[arquivadas](../deposito/2026-10-06-specs-fases-0-2/)).

**Hoje:** GNU Stow — ver [`../README.md`](../README.md). **Pré-requisito:** fases 0-2
maduras (✅ as três).

## Ferramentas no sistema

Nada de Nix instalado ainda. O que o futuro vai **substituir**:

| Hoje | Instalação | Vira o quê no Nix |
| --- | --- | --- |
| `stow` 2.3.1 | `apt` | `home.file` / `xdg.configFile` do home-manager |
| `bootstrap.sh` | script local | `flake.nix` + `home.nix` |
| `git submodule` (plugins do tmux) | `apt` | input do flake, ou `programs.tmux.plugins` |
| scripts `install-*.sh` (fonts, icons, cursors, gtk-theme) | bash + curl | `home.packages` / `stylix` |
| `apt`/`snap`/`flatpak` manual | ver a seção "Ferramentas no sistema" de cada one-page | `home.packages` declarado |

**O que falta instalar quando a Fase 3 começar:**

```bash
# instalador oficial (multi-user), ainda NÃO rodado:
sh <(curl -L https://nixos.org/nix/install) --daemon
# habilitar flakes em ~/.config/nix/nix.conf:
#   experimental-features = nix-command flakes
```

> ⚠️ Nix instala em `/nix` e cria usuários de build — é mudança de sistema, não de
> config de usuário. Rodar com o `timeshift` já configurado (item do roadmap do `_hq`).

**Personalização a preservar na migração:** tudo que hoje vive nos pacotes Stow
(`alacritty`, `nvim`, `tmux`, `home`, `vscode`, `environment`, `theme-sync`) + os
temas aplicados por script (Tokyo Night GTK/Shell, Fluent-purple, Qogir cursor,
wallpaper). O `theme-sync/` é o caso mais delicado: hoje é um watcher systemd que
sincroniza tema claro/escuro — no Nix isso provavelmente vira
[Stylix](https://github.com/danth/stylix) (já no roadmap do `_hq` como `LT12`).

## Perguntas abertas (RFDs quando chegar a vez)

**1. NixOS completo ou Nix + home-manager sobre Ubuntu?**
💡 Nix + home-manager sobre o Ubuntu atual é a migração menos arriscada: reproduz
configs e pacotes de usuário sem trocar o SO inteiro de uma vez. NixOS é o passo
natural depois, se fizer sentido.

**2. Flakes ou configuração clássica (channels)?**
💡 Flakes é o caminho mais usado hoje e tem melhor reprodutibilidade (lockfile
explícito), mesmo ainda sendo tecnicamente "experimental".

**3. Migração incremental — módulo por ferramenta ou big-bang por categoria?**
💡 Um `.nix` por pacote Stow existente (`alacritty.nix`, `nvim.nix`…) rodando em
paralelo com o Stow até a troca completa. Espelha a estrutura que já existe e permite
migrar `alacritty`, validar, e só então mexer em algo maior.

**4. Gestão de segredos** — `agenix` independente ou integrado ao home-manager?
Já há dois arquivos que **nunca** podem ser versionados: `~/.config/rclone/rclone.conf`
(token do Drive) e `~/.config/syncthing/config.xml` (chave do device). Hoje a solução é
simplesmente deixá-los fora do git; o RFD é se isso muda com Nix.

**4b. O que fazer com o que não vem do `apt`.** Medição de 2026-10-06 mostrou três
casos que não se declaram igual:
- **Calibre 8.2.100** — instalador oficial em `/opt/calibre`, auto-atualiza. Manter
  fora do Nix (mais atual, fora do controle) ou usar o nixpkgs (declarado, pode
  atrasar)?
- **Flatpaks** (Obsidian, Foliate, Zen, **LosslessCut 3.69.0**, **Loupe**, **Amberol**,
  **Parabolic** — instalação `system`, remote `flathub`) e **snaps** (Logseq, **VLC**) —
  `nix-flatpak` declara os primeiros; snap não tem equivalente limpo. O
  `rapid-photo-downloader` 0.9.36 veio de `apt`, não de flatpak (medido em 2026-10-08,
  ver [galeria.md](galeria.md#ferramentas-no-sistema)).
  **Exceção fácil:** **OnlyOffice** e **VLC** vieram por snap mas têm pacote nativo no
  nixpkgs (`pkgs.onlyoffice-desktopeditors`, `pkgs.vlc`) — o snap sai limpo pros dois
  (ver [escritorio.md](escritorio.md), [multimidia.md](multimidia.md)). **Parabolic**
  ainda não tem pacote nativo — fica no `nix-flatpak` até checar de novo.
- `ffmpeg` está instalado **duas vezes** (apt 6.1.1 + snap 8.1) — a migração é chance
  de resolver a duplicação.

**5. O que este repo vira depois?**
💡 Mesmo repo, mesma raiz de decisões — evita perder histórico, `STATE.md` e os
one-pages acumulados. Pasta por ferramenta pode conviver com `.nix` na transição.

## Caminhos de evolução

```
hoje      GNU Stow (symlink simples, sem formato próprio, durável)
  ↓ instalar Nix + home-manager, manter Stow em paralelo
passo 1   1 pacote migrado e validado (alacritty — o mais simples)
  ↓ um por um, validando
passo 2   todos os pacotes de usuário declarados; Stow desativado
  ↓ se fizer sentido
passo 3   NixOS (sistema inteiro declarativo) — decisão separada
```

Sem critério único de "pronto": a fase é longa e se quebra em sub-fases quando
chegar a hora.

## Decisões

**2026-09 — GNU Stow como gerenciador atual, não Nix direto.**
Prioriza **durabilidade**: symlink simples, sem formato próprio, legível e
reversível à mão. *Por que não ir direto pro Nix:* exigiria aprender a ferramenta
**e** reorganizar os dotfiles ao mesmo tempo — duas frentes de risco. O Stow deixa a
estrutura por ferramenta pronta, que é exatamente o que o Nix vai consumir depois.

**2026-10-06 — spec da Fase 3 promovida a one-page.**
As fases 0-2 tiveram todas as perguntas respondidas e foram pro depósito; manter uma
pasta `specs/` com um arquivo só era estrutura sem função. *Consequência:* o tema Nix
passa a seguir o mesmo formato dos outros one-pages (estado, ferramentas, RFDs,
evolução, decisões).
