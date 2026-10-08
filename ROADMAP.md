<!-- FORMATO: L (Now/Next/Soon/Later) — ver ~/projects/_hq/biblioteca/roadmaps/L-now-next-soon-later.md
     Escolhido por ser infra pessoal: sem usuário externo, sem prazo, balde "frágil" central.
     Painel único do computador: dotfiles + acervo digital (fundidos em 2026-10-06). -->

# Roadmap — meu computador

> Painel único: configuração da máquina **e** acervo digital (fotos, livros, backup).
> Sem prazo — infra pessoal. Decisões por tema nos one-pages de [`docs/`](docs/);
> ações que dependem de mim em [config.md](config.md); pesquisas que embasaram em
> [`pesquisas/`](pesquisas/).

**Objetivo do momento:** poder **gravar, fotografar e baixar livro sabendo que cai no
lugar certo e não se perde.** Tudo em `Now`/`Next` serve a isso; refinamento vem
depois.

**Fundo de longo prazo:** Fase 0 (base: IA + padrão) → Fase 1 (decidir área por
área) → Fase 2 (Stow limpo) → Fase 3 (Nix). 0 e 2 fechadas; 1 em andamento.

**Baldes:** `🙋 Humano` (travado em mim) · `🔵 Now` · `🟢 Next` · `🟡 Soon` · `⚪ Later` · `🛑 RFD` · `✅ Feito` · `⚠️ Frágil` · `🚫 Não-fará`

---

## 🙋 Travado em mim *(a IA não consegue fazer — fila em [config.md](config.md))*

Item feito **sai** do `config.md`. Em ordem de impacto:

- [ ] **OAuth do rclone** (`rclone config`) — destrava `AC2`.
- [ ] **Parear o Syncthing** (PC + Android) — destrava a entrada de livro pelo celular.
- [ ] **Export novo do Notion** — a única cópia tem 19 meses.
- [ ] **Configurar o `rapid-photo-downloader`** (interface gráfica, ~5 min) e rodar o
      1º cartão — destrava `AC3`. Passo a passo no
      [cheatsheet](docs/edicao-video.md#cheatsheet-da-câmera-ao-cofre).

## 🔵 Now *(o essencial: ter onde guardar com segurança)*

- `AC2` **Backup off-site dos livros.** systemd timer rodando
  `rclone copy biblioteca gdrive:backup/livros-biblioteca`, validado à mão primeiro.
  **Bloqueado em mim** (OAuth). Ver [backup.md](docs/backup.md).
- `AC3` **Ingestão do Osmo Pocket 4.** Ferramentas instaladas (2026-10-08, nunca
  abertas). Entrada no SSD: `~/Media/02_Cameras/Osmo_Pocket/` (`AAAA/AAAA-MM/`); depois
  `rsync` pro `BLACK/02_Cameras/`. Falta configurar o app e validar com um **cartão
  real** — inclusive se a Pocket 4 grava `.LRV`, `.LRF` ou outro (o app **não** ignora
  `.LRV` sozinho; limpeza é manual). **Bloqueado em mim** (GUI + cartão).
  Ver [galeria.md](docs/galeria.md) e o [cheatsheet](docs/edicao-video.md#cheatsheet-da-câmera-ao-cofre).

## 🟢 Next *(decidido, aguarda a vez)*

- `AC10` **Fechar o fluxo de triagem de vídeo.** **Só o LosslessCut** (instalado
  2026-10-08), aprender os atalhos `I`/`O`/`J-K-L` e testar o *detect scenes* embutido
  num take real da Pocket. Pronto quando: um cartão real virar "3-4 clipes bons + bruto
  apagado" sem abrir editor pesado. **Não** instalar Auto-Editor/PySceneDetect/Shutter
  Encoder agora — gold-plating antes de existir rotina.
  Ver [edicao-video.md](docs/edicao-video.md). Parte de `AC3`.
- `AC4` **Primeiro álbum de evento de verdade.** Convenção pronta (symlink em
  `Media/Pictures/Albuns/AAAA-MM_slug/`); nenhum álbum criado ainda. Montar um com evento
  real valida o fluxo e a pegadinha do `rsync -aL`. Ver [galeria.md](docs/galeria.md).
- `[pc]` **Atalhos de teclado** (Zen, GNOME, VS Code, terminal, Dolphin) — consolidar
  sem conflito, prontos pra virar declarativo.

## 🛑 RFD *(decisão minha, não da IA)*

- `AC8` **A foto do diário é cópia ou ponteiro?** Decide se o Obsidian embute a foto
  ou aponta pro acervo — e se DigiKam entra. Mesmo dilema dos álbuns.
  Ver [galeria.md](docs/galeria.md#rfds-em-aberto).
- **Bloco técnico do export de livros** — exige criar coluna `#assunto` no Calibre +
  segundo template. Ver [biblioteca.md](docs/biblioteca.md#rfd-em-aberto).

## 🟡 Soon *(provável, sem data)*

- `AC6` **Estratégia 3-2-1 completa.** Hoje não existe: livro tem cópia no mesmo
  disco, foto tem só o Google Fotos (que é sync, não backup). Fechar as 3 camadas +
  cadência do Google Takeout. Pré-requisito `AC1` cumprido (2026-10-08); falta rotina
  de atualizar o espelho do BLACK. Ver [backup.md](docs/backup.md).
- `[pc]` **Destino do TRANSLUCENT.** Reteste do SMART (passo em
  [config.md](config.md)) decide se vira 2ª cópia fria ou se é reformatado/aposentado.
- `[pc]` **O que fica no SSD depois de enviar ao BLACK?** *(2026-10-08)* Bruto podado de
  `~/Media/02_Cameras/` some depois do `rsync` verificado, ou fica como cópia quente? SSD
  com ~55 GB livres; vídeo 4K enche rápido. Decidir com o 1º cartão real (`AC3`).
- `[pc]` **Revisar os 14 arquivos soltos em `~/Downloads/`** *(2026-10-08)* — vieram da
  raiz do TRANSLUCENT (zips, PDFs, 2 vídeos, 2 zips do Notion de mar/2025); cada um
  vai para o lugar certo ou é descartado. Cópia deles segue em `BLACK/00_legado-translucid/`.
- `[pc]` **Backups do Notion** — definir cadência depois do export novo.
- `[pc]` **Pendrives/mídia externa** — o que fica, o que vira backup frio, o que sai.
- `[pc]` **Versionar `~/.config/user-dirs.dirs`** *(achado 2026-10-06, mais urgente
  desde 2026-10-08)* — é o arquivo que faz as pastas de topo serem `~/Documents` em
  inglês **e agora aponta `PICTURES`/`VIDEOS` pra `~/Media/…`**; **está fora do git**, então
  em máquina nova as pastas voltam nos nomes do locale (PT-BR) e o `~/Media` fica órfão.
  Pacote Stow de uma linha, barato. Ver
  [organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md#ferramentas-no-sistema).
- `[pc]` **Lista de extensões do VS Code fora do git** — `code --list-extensions`
  resolve hoje; em Nix vira declarativo (`nix-vscode-extensions`, `LT12` do `_hq`).
- `[pc]` 🛑 **Decidir o `lazy-lock.json` do Neovim** *(achado 2026-10-06)* — está no
  `.gitignore` desde o início, sem justificativa escrita. Versionar dá
  reprodutibilidade (máquina nova não pega breaking change de plugin); ignorar evita
  engessar em versão antiga. Com Neovim em `0.12.0-dev` o argumento de versionar fica
  mais forte. Trade-off escrito em [ide.md](docs/ide.md#o-trade-off-do-lazy-lockjson).
- `[pc]` **Home: alinhar o real ao padrão XDG.** `~/projects` está minúsculo (o padrão
  é `~/Projects`) — renomear exige ajustar referências, não é só `mv`. E há dotfiles
  soltos na raiz que poderiam seguir XDG (`~/.fonts`, caches de linguagens) — caso a
  caso, sem pressa, já que muitos vêm de ferramentas que não respeitam XDG. Padrão em
  [organizacao-de-arquivos.md](docs/organizacao-de-arquivos.md).

## ⚪ Later

- `AC7` `[explorar]` **Camada de narrativa ("biografia visual").** Sair do depósito
  pro diário via **regra dos 5%** (de 300 fotos, 10-15 + dois parágrafos).
  Obsidian + DigiKam é a recomendação; decidido por `AC8`.
  Ver [galeria.md](docs/galeria.md#a-camada-que-falta-narrativa).
- `AC9` `[explorar]` **NAS.** Immich pras fotos, Calibre-Web pros livros, backup
  redundante. Absorve `AC2` e `AC6` quando materializar; **5 RFDs** esperando
  hardware. Ver [nas.md](docs/nas.md).
- `AC11` `[explorar]` **Exibir o acervo numa tela grande** *(desejo, 2026-10-06)* —
  projetor ou TV com Google/Android TV: "porta-retratos gigante" com o álbum
  `AAAA-MM Melhores` no modo ambiente, e Cast do celular pra mostrar na hora. O barato
  **não depende do NAS** (Chromecast + Google Fotos resolve); só servir o bruto 4K
  exige NAS (`AC9`) e reforça os requisitos de Gigabit cabeado e QuickSync. Ver
  [nas.md](docs/nas.md#exibir-o-acervo-numa-tela-grande-desejo-não-setup).
- `[vem-depois]` **Nix / home-manager.** Fases 0-2 maduras (✅ as três), então é só
  decidir começar. 5 RFDs abertos (NixOS vs. home-manager, flakes, migração
  incremental, segredos, futuro deste repo) + o que cada ferramenta vira:
  [nix.md](docs/nix.md).
- `[explorar]` **Gestão de segredos** quando forem necessários: `age` vs. solução
  integrada ao Nix.
- `[explorar]` **Qual PKM serve melhor à IA** sobre as notas (local já decidido:
  `~/Documents/notas-pkm/`). Cruza com `AC7`.

---

## ⚠️ Frágil *(funciona mas não confio — resolver antes de empilhar em cima)*

- **Cofre frio é espelho manual.** `~/Media/Pictures` (17 GB) tem cópia no BLACK desde
  2026-10-08, mas só até a próxima foto nova: nada atualiza o espelho sozinho. Rotina
  em [backup.md](docs/backup.md); automatizar é parte de `AC6`.
- **Backup da biblioteca está no mesmo disco** (`~/Backups/…`, 2.6 GB) — cobre erro
  humano, não o SSD morrer. Resolve com `AC2`.
- **Backup do Notion tem 19 meses** (1.8 GB, março/2025) — única cópia.
- **TRANSLUCENT sem veredito de superfície** — SMART de atributos limpo, mas o teste
  longo foi abortado (~10% lido). Não confiar nele como cópia única. O BLACK está
  aprovado.

## ✅ Feito

**`AC1` + `AC5` — camada fria (2026-10-08)** — dois HDs externos diagnosticados
(SMART); **BLACK** aprovado e virou o cofre (exFAT, abre no Windows, sem `03_Albuns/`),
com espelho do `~/Pictures` (17 GB) e dump bruto do TRANSLUCENT (22 GB), ambos
verificados por checksum. Premissa "HD vazio" estava errada: o TRANSLUCENT tinha dados.
Detalhe e números em [backup.md](docs/backup.md).

**`AC12` — pasta única `~/Media` (2026-10-08)** — `~/Pictures` e `~/Videos` viraram
`~/Media/Pictures` e `~/Media/Videos` (`mv`, contagem idêntica); `user-dirs.dirs` e
favoritos repontados; BLACK intocado. Ver [galeria.md](docs/galeria.md).

**Ferramentas de ingestão (2026-10-08)** — `rapid-photo-downloader` 0.9.36 (apt) e
LosslessCut 3.69.0 (flatpak) instalados e registrados nas tabelas de ferramentas;
`~/Media/02_Cameras/Osmo_Pocket/` criada; cheatsheet escrito (hipótese, apps nunca
abertos).

**Acervo (2026-10-06)** — docs reorganizados em one-pages por tema
([galeria](docs/galeria.md), [biblioteca](docs/biblioteca.md),
[backup](docs/backup.md), [nas](docs/nas.md)); pesquisas preservadas em
[`pesquisas/`](pesquisas/); convenção de álbum sem duplicar decidida; `config.md`
virou fila efêmera só de ação humana; `smartmontools` virou check no `bootstrap.sh`;
padrão cronológico confirmado aplicado (17 GB, zero pasta por evento);
`~/Archive`→`~/Backups` corrigido nos docs.

**Fase 2 — Stow limpo (2026-09)** — `bootstrap.sh` idempotente com dry-run;
submodules do tmux reais; `fonts/` sem binário vendorizado (baixa em build-time);
dconf declarativo (`gnome-shell/`); `zen/` guarda o tema; pacotes inativos no
`attic/`; `nvim/init.lua_bkp` removido.

**Fase 1 — áreas decididas (2026-09-11/16)** — PKM sob `~/Documents/notas-pkm/`;
livros em `~/Documents/livros/{biblioteca,entrada,para-celular}`; Google Drive via
rclone (não GOA); `~/Archive` eliminado; divergência PT-BR registrada;
`waybar`/`yambar` resolvidos por arquivamento.

**Base (2026-09)** — GNU Stow escolhido; padrão de organização documentado + skill
`arruma-meu-not-ai`; VS Code multi-root workspace; tema Tokyo Night + Monokai +
ícones/cursor/wallpaper.

> Detalhe completo de cada item com contexto e alternativas rejeitadas:
> [`deposito/2026-10-06-state-log-setembro-outubro.md`](deposito/2026-10-06-state-log-setembro-outubro.md)
> e as seções "Decisões" dos one-pages em [`docs/`](docs/).

## 🚫 Não-fará (por ora)

- **Pasta por evento pra foto** — excludente, quebra ordenação. Álbum é symlink/visão.
- **Hardlink ou cópia pra álbum** — quebra silencioso / duplica bytes, duas verdades.
- **Sincronizar `biblioteca/` do Calibre** — `metadata.db` é SQLite vivo, corrompe.
- **RAID como cópia do 3-2-1** — redundância não é backup.
- **NTFS no HD externo** — driver pesado no Linux, inconsistência de permissão.

---

## Nota de leitura

Item sobe `Later → Soon → Next → Now`. O balde `⚠️ Frágil` é o central em infra
pessoal: a prioridade real é **"quanto eu perderia se isso quebrasse"**, não uso.
`🙋 Humano` existe porque a IA não pluga HD nem faz OAuth — enquanto tiver item lá,
o `Now` não anda.
