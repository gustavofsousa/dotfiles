# Edição e triagem de vídeo

Como transformar cartão cheio em poucos clipes que prestam — **sem aprender editor
pesado** e sem recodificar. É o passo entre descarregar
([galeria.md](galeria.md#ingestão-do-osmo-pocket-4)) e arquivar.

**Fonte:** [pesquisas/2026-10-06-edicao-e-triagem-video.md](../pesquisas/2026-10-06-edicao-e-triagem-video.md)
(hipótese — nada testado ainda).

## O problema

Vídeo 4K da Pocket grava **600 MB–1 GB por minuto**. Um fim de semana rende 50 takes
de 2 minutos onde só 25 segundos prestam — mais a tampa da lente, o chão e 10
tentativas da mesma cena. Guardar tudo é o caminho mais rápido pro "lixão digital":
terabytes pra guardar vídeo de sapato.

> **A regra:** cortar antes de arquivar, **apagar o bruto na hora**. Não acumular
> "dívida de triagem" — "depois eu edito" nunca chega.

O requisito que elimina 90% das opções: **não recodificar**. Corte sem recodificar é
instantâneo (velocidade de disco) e tem perda zero. Editor tradicional (DaVinci,
Premiere) reprocessa o arquivo — lento, pesado, e degrada.

## Ferramentas no sistema

Medido em 2026-10-06. **Nada de edição instalado ainda.**

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| `ffmpeg` 6.1.1 | comprimir pra nuvem (H.265), base de todo o resto | ✅ | apt (+ snap 8.1) |
| **LosslessCut** | corte sem recodificar, por teclado; **detect scenes embutido** | ⬜ **falta** | `flatpak install flathub no.mifi.losslesscut` |
| **Auto-Editor** | remove silêncio/imobilidade automaticamente | ⬜ falta | `uv tool install auto-editor` |
| **PySceneDetect** | fatia vídeo longo por mudança de cena | ⬜ falta (**redundante** — ver abaixo) | `uv tool install 'scenedetect[opencv]'` |
| **Shutter Encoder** | canivete: corte + conversão + legenda (Whisper) numa tela | ⬜ falta | AppImage oficial (`chmod +x`) |
| **Czkawka** | dedup de foto por hash/similaridade | ⬜ falta | `sudo snap install czkawka` |

> ⚠️ **CLI Python aqui instala com `uv tool install`, não `pip install`.** A pesquisa
> original manda `pip install` global, que suja o Python do sistema e quebra em upgrade
> de distro. `uv` 0.11.17 já está instalado.
> Para o Czkawka, o `cargo install` compila do zero (demorado) — snap ou o binário do
> GitHub resolvem igual.

**Personalização a preservar:** nenhuma ainda. Quando o LosslessCut entrar, a config
fica em `~/.config/LosslessCut/` — candidato a pacote Stow se eu mudar atalhos ou
definir diretório de export padrão.

## O fluxo que eu quero

```
cartão → rapid-photo-downloader → HD (AAAA/AAAA-MM/)
             ↓
       LosslessCut: I / O / Export      ← aqui mora a triagem
             ↓
   apaga o bruto  →  3-4 melhores → ffmpeg H.265 → Google Fotos
```

**LosslessCut operado por teclado** (é onde está a velocidade — mouse é o gargalo):

| Tecla | O quê |
| --- | --- |
| `Espaço` | play / pause |
| `J` `K` `L` | rebobina / para / avança (padrão de ilha de edição) |
| `I` | marca início do que presta |
| `O` | marca fim |
| `E` | exporta |

**O achado que simplifica tudo:** o LosslessCut tem **PySceneDetect embutido** (menu
⋮ → *Detect scenes*). Ele marca sozinho onde a cena muda, você descarta os trechos
ruins e exporta o resto num arquivo. Isso torna o PySceneDetect avulso desnecessário
pro caso comum — **uma ferramenta em vez de duas**.

**Quando o Auto-Editor ganha:** gravação longa e parada (vlog com pausas, câmera
esquecida ligada na mesa). Ele corta silêncio e imobilidade sem eu assistir:

```bash
auto-editor video.mp4 --edit audio:threshold=4% --margin 0.2s   # por áudio
auto-editor video.mp4 --edit motion:threshold=2%                # por movimento
```

## Compressão pra nuvem

Clipe bonito mas pesado demais pros 200 GB do Google One:

```bash
ffmpeg -i entrada.MP4 -c:v libx265 -crf 24 -preset fast -c:a aac -b:a 192k saida.MP4
```

H.265/HEVC com qualidade visualmente idêntica corta até 70%. Isso **recodifica** — é
pra cópia de distribuição, nunca pro arquivo mestre no HD.

## Caminhos de evolução

```
agora      nada instalado — bruto do cartão sem triagem
  ↓ instalar LosslessCut (1 flatpak)
passo 1    triagem manual rápida por teclado + detect scenes
  ↓ se a triagem manual virar gargalo
passo 2    Auto-Editor pros casos de gravação longa e parada
  ↓ se precisar legenda/conversão em lote na mesma tela
passo 3    Shutter Encoder (AppImage) como canivete
```

Deliberadamente **começar com uma ferramenta só**. A pesquisa oferece cinco; instalar
as cinco antes de ter rotina é gold-plating — e o LosslessCut sozinho entrega ~90% do
que eu preciso.

## Decisões

**2026-10-06 — Corte sem recodificar é requisito, não preferência.**
Elimina editor tradicional (DaVinci/Premiere) do fluxo de triagem. *Por que:* o
objetivo é reduzir volume em minutos, não produzir vídeo editado; recodificar custa
tempo e qualidade à toa. Editor pesado só entraria se um dia eu quiser *produzir* algo
(transição, trilha, color) — aí é outro assunto.

**2026-10-06 — LosslessCut primeiro, sozinho.**
É o que exige menos configuração e tem o detect-scenes embutido. *Rejeitado por ora:*
instalar Auto-Editor + PySceneDetect + Shutter Encoder junto — cinco ferramentas antes
de existir rotina é gold-plating. *Consequência:* se a triagem manual virar gargalo,
o Auto-Editor é o próximo, não um editor maior.

**2026-10-06 — PySceneDetect avulso: não instalar.**
Está embutido no LosslessCut. *Por que registrar:* a pesquisa recomenda os dois, e sem
essa nota alguém (eu, ou a IA) instalaria ambos.

**2026-10-06 — CLI Python via `uv tool install`, nunca `pip install` global.**
*Por que:* `pip` global suja o Python do sistema e quebra em upgrade de distro. Vale
pra qualquer CLI Python deste repo, não só edição de vídeo.
