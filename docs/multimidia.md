# Multimídia — visualizador de imagem, player de vídeo/áudio, música e download

Os apps que abrem, tocam e baixam mídia no dia a dia. [galeria.md](galeria.md) cobre
**onde o arquivo de foto/vídeo mora**; este one-page cobre **qual programa abre e como
ele está configurado**.

**Fontes relacionadas:** [galeria.md](galeria.md) (acervo de fotos/vídeo),
[edicao-video.md](edicao-video.md) (LosslessCut, ffmpeg), [nas.md](nas.md)
(VLC/Jellyfin como cliente de streaming futuro).

## Estado hoje

- **Loupe** é o visualizador de imagem padrão (substituiu o visualizador antigo do GNOME).
- **VLC** é o player de vídeo/áudio — amplificação de volume subida pra 200%.
- **Amberol** tocando música solta em loop (pasta de fundo, sem biblioteca).
- **Parabolic** baixa áudio/vídeo do YouTube com metadado e capa embutidos.

## Como e quando usar cada um

Guia rápido pra quem ainda não tem o hábito — qual app abrir em cada situação.

| Situação | Abra | |
| --- | --- | --- |
| Ver uma foto ou imagem solta | **Loupe** | duplo clique já abre nele (é o padrão) |
| Assistir vídeo ou ouvir um áudio avulso | **VLC** | arraste o arquivo pra janela, ou clique direito → Abrir com |
| Música de fundo tocando em loop pra estudar | **Amberol** | arraste a pasta inteira pra dentro dele |
| Baixar áudio/vídeo de um link do YouTube | **Parabolic** | cole o link, escolha o formato, baixe |

### Loupe — ver imagem

Abre sozinho ao dar duplo clique numa foto. Use as setas do teclado para passar pra
próxima/anterior na mesma pasta. `+`/`-` dá zoom, `Delete` manda pra lixeira. Não tem
conceito de "biblioteca" — ele só mostra o que está na pasta.

### VLC — vídeo e áudio avulso

Arraste o arquivo pra janela do VLC, ou abra o VLC e use `Ctrl+O`. Atalhos úteis:
`Espaço` pausa/retoma, `Setas esquerda/direita` avança/volta 10s, `Setas cima/baixo`
sobe/desce volume (agora até 200%, não só 100%).

Pra baixar legenda automaticamente: com o vídeo aberto, vá em `Exibir → VLsub`,
escolha o idioma e clique em buscar — ele baixa e já aplica, sem precisar abrir o
navegador.

Se um vídeo baixou pela metade ou corrompeu, o VLC **ainda tenta tocar** — não precisa
fazer nada diferente, é comportamento automático.

### Amberol — música de fundo em loop

Abra o Amberol e arraste a pasta com as músicas baixadas pra dentro da janela. Clique
no ícone de **aleatório** e no de **repetir** (topo da janela), depois minimize. Ele
não indexa biblioteca nem varre o disco — só toca o que você arrastou.

### Parabolic — baixar do YouTube

1. Copie o link do vídeo no YouTube (botão Compartilhar → Copiar link).
2. Abra o Parabolic, cole o link e clique em **Adicionar**.
3. Escolha o formato: **MP3** ou **M4A** pra áudio, ou um formato de vídeo se quiser
   o vídeo também.
4. Clique em **Baixar**. Ele salva com a capa e as tags (artista/título) já
   preenchidas, na pasta de downloads padrão (ajustável nas configurações do app).

## Ferramentas no sistema

Medido em 2026-10-10 (`flatpak list`, `snap list`, `vlc --longhelp`).

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| **Loupe** 51.rc | visualizador de imagem, **padrão do sistema** (`xdg-mime` confirma) | ✅ | Flatpak (`org.gnome.Loupe`, flathub) |
| **VLC** 3.0.24-rc1 (rev 4472) | player de vídeo/áudio, lê arquivo corrompido, converte, transmite | ✅ | snap (`vlc`, canal `latest/stable`) |
| **VLsub** | baixa legenda de dentro do VLC (`Exibir → VLsub`) | ✅ **já embutido no snap**, nada a instalar | vem com o VLC |
| **Amberol** 2026.1 | toca pasta de música solta, sem biblioteca, mínimo de RAM | ✅ | Flatpak (`io.bassi.Amberol`, flathub) |
| **Parabolic** 2026.5.0 (ex-Tube Converter) | baixa áudio/vídeo do YouTube com tag/capa | ✅ | Flatpak (`org.nickvision.tubeconverter`, flathub) |

> **NOTE:** nenhum `yt-dlp` (CLI) estava instalado antes do Parabolic — ele não duplica
> ferramenta existente, preenche lacuna real. Caso diferente do Amberol, ver *Decisões*.

## VLC: configuração aplicada

| O que | Valor | Por quê |
| --- | --- | --- |
| `qt-max-volume` | `125` (default) → **`200`** | notebook com caixa de som fraca — permite amplificar até 200% no slider |

**VLsub** não precisa de configuração: já aparece em `Exibir → VLsub` assim que o VLC
abre, porque o `.luac` da extensão já vem dentro do snap
(`/snap/vlc/<rev>/usr/lib/vlc/lua/extensions/VLSub.luac`). O VLC já tem rede liberada
pro snap (`network` plug) e `metadata-network-access=1` no `vlcrc` — a busca de
legenda funciona sem passo extra.

**Interface mais limpa** (dica recebida: `Ferramentas → Personalizar interface...`) fica
**manual, não versionada**. O VLC salva o layout da toolbar no `vlcrc` como uma string
binária codificada — frágil de editar por script e de revisar num diff. Prefira fazer
pela GUI quando bater vontade.

## Personalização a preservar

| O que | Onde mora | Versionado? |
| --- | --- | --- |
| `qt-max-volume=200` | `~/snap/vlc/common/vlcrc` | ✅ **sim** — `vlc/vlcrc.overrides` no repo |
| Resto do `vlcrc` (~5300 linhas, geradas pelo VLC) | mesmo arquivo | ❌ não — ver *Como é versionada* |
| Config do Loupe | nenhuma — app sem preferências a configurar | — |
| Config do Amberol | nenhuma — app sem preferências, é "arrasta e toca" | — |
| Config do Parabolic | `~/.var/app/org.nickvision.tubeconverter/config/` | ❌ não — pasta de destino do download é local da máquina |

**Como é versionada** — pasta `vlc/` do repo (não é pacote Stow, caminho `common/` do
snap não tem número de revisão mas o arquivo é gerado, não escrito à mão):

- `vlc/vlcrc.overrides` — só as chaves intencionais (hoje, só `qt-max-volume`). Não é
  um `vlcrc` completo — o real tem ~5300 linhas, quase tudo default comentado,
  reescrito pelo próprio VLC a cada fechamento (volume salvo, geometria de janela,
  histórico). Versionar o arquivo inteiro capturaria estado de máquina junto da
  customização real.
- `vlc/apply-config.sh` — aplica cada chave de `vlcrc.overrides` no `vlcrc` real via
  `sed` (não sobrescreve o arquivo). **Feche o VLC antes** (ele reescreve o `vlcrc` ao
  fechar). Faz backup `.bak`.
- `vlc/dump-config.sh` — recaptura o valor atual de cada chave já listada, pra
  versionar mudança feita pela GUI (Preferências). Não adiciona chave nova sozinho.
- Entra no `bootstrap.sh`: `./bootstrap.sh --apply --with-vlc-config`.

## O que isso vira no Nix

| Hoje | Vira no Nix |
| --- | --- |
| Loupe (flatpak) | `pkgs.loupe` — tem pacote nativo, ou `nix-flatpak` se preferir manter flatpak |
| VLC (snap) | `pkgs.vlc` — tem pacote nativo, o snap **sai limpo** |
| Amberol (flatpak) | `pkgs.amberol` — tem pacote nativo |
| Parabolic (flatpak) | sem pacote nativo ainda no nixpkgs (checar de novo na hora da migração) — `nix-flatpak` cobre enquanto isso |
| `vlc/vlcrc.overrides` | `programs.vlc` ou `home.file` do home-manager, convertido na migração |

## Decisões

**2026-10-10 — Loupe como visualizador de imagem padrão.** Sem configuração
necessária — instalou e já assumiu os tipos MIME de imagem.

**2026-10-10 — `qt-max-volume=200` no VLC.** *Por quê:* caixa de som fraca de
notebook, 125% (default) não é alto o bastante pra alguns vídeos/podcasts.

**2026-10-10 — Amberol instalado com ressalva.** *Discordância registrada:* pro caso
de uso descrito (pasta de música solta tocando em loop de fundo, sem biblioteca), o
VLC já cobre o fluxo inteiro (abrir pasta, aleatório, repetir, minimizar) — Amberol
não resolve uma lacuna, só troca estética/RAM por um segundo app fazendo a mesma
coisa. Instalado mesmo assim por ser de baixo custo e reversível (`flatpak uninstall`),
e por ser pedido explícito. Se não pegar uso real em algumas semanas, é candidato
natural a desinstalar.

**2026-10-10 — Parabolic instalado sem ressalva.** Diferente do Amberol: não havia
`yt-dlp` nem baixador de YouTube nenhum no sistema — preenche lacuna real, não duplica
ferramenta existente.
