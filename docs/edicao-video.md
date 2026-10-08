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

Medido em 2026-10-06; LosslessCut medido em 2026-10-08. **Só o LosslessCut está
instalado — e nunca foi aberto.**

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| `ffmpeg` 6.1.1 | comprimir pra nuvem (H.265), base de todo o resto | ✅ | apt (+ snap 8.1) |
| **LosslessCut** 3.69.0 | corte sem recodificar, por teclado; **detect scenes embutido** | ✅ instalado, nunca aberto | flatpak, remote `flathub`, instalação `system` (`no.mifi.losslesscut`) |
| **Auto-Editor** | remove silêncio/imobilidade automaticamente | ⬜ falta | `uv tool install auto-editor` |
| **PySceneDetect** | fatia vídeo longo por mudança de cena | ⬜ falta (**redundante** — ver abaixo) | `uv tool install 'scenedetect[opencv]'` |
| **Shutter Encoder** | canivete: corte + conversão + legenda (Whisper) numa tela | ⬜ falta | AppImage oficial (`chmod +x`) |
| **Czkawka** | dedup de foto por hash/similaridade | ⬜ falta | `sudo snap install czkawka` |

> ⚠️ **CLI Python aqui instala com `uv tool install`, não `pip install`.** A pesquisa
> original manda `pip install` global, que suja o Python do sistema e quebra em upgrade
> de distro. `uv` 0.11.17 já está instalado.
> Para o Czkawka, o `cargo install` compila do zero (demorado) — snap ou o binário do
> GitHub resolvem igual.

**Personalização a preservar:** nenhuma ainda. Por ser flatpak, a config do LosslessCut
deve nascer em `~/.var/app/no.mifi.losslesscut/config/LosslessCut/` (não em
`~/.config/`; esperado, **confirmar na primeira abertura** — hoje a pasta não existe).
Candidato a pacote Stow se eu mudar atalhos ou definir diretório de export padrão.

## O fluxo que eu quero

```
cartão → rapid-photo-downloader → ~/Media/02_Cameras/Osmo_Pocket/AAAA/AAAA-MM/
             ↓
       LosslessCut: I / O / Export      ← aqui mora a triagem
             ↓
   apaga o bruto  →  rsync pro BLACK  +  3-4 melhores → ffmpeg H.265 → Google Fotos
```

LosslessCut é operado por teclado (é onde está a velocidade — mouse é o gargalo):
tabela de atalhos e passo a passo no [cheatsheet](#cheatsheet-da-câmera-ao-cofre).

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

## Cheatsheet: da câmera ao cofre

> **Confiança.** Atalhos do LosslessCut conferidos na doc oficial
> ([`docs/index.md`](https://github.com/mifi/lossless-cut/blob/master/docs/index.md));
> `J`/`K`/`L` vêm de fonte secundária. Tokens do rapid-photo-downloader conferidos no
> código instalado (0.9.36). **Nenhum dos dois apps foi aberto ainda** — nomes de menu
> podem variar. No LosslessCut, **`Shift` + `/`** lista e edita todos os atalhos *da
> sua versão* e vale mais que esta tabela.

### 0. Uma vez só — configurar o rapid-photo-downloader (~5 min, interface gráfica)

Abrir o app com o cartão plugado → *Preferences*. A config nasce em
`~/.config/Rapid Photo Downloader/` (hoje não existe).

| Onde | Valor |
| --- | --- |
| Destino de fotos **e** de vídeos | `~/Media/02_Cameras/Osmo_Pocket` |
| Subpastas (*Custom*) | nível 1: `YYYY` · nível 2: `YYYY` + texto `-` + `MM` → `2026/2026-07` |
| Nome do arquivo (*Custom*) | `YYYY-MM-DD` + texto `_` + `HHMMSS` → `2026-07-20_091244.mp4` (igual ao `~/Media/Pictures`) |
| Backup / Job code | desligados |

> *Ignored Paths* **não** serve para pular `.LRV`: filtra pastas, não extensão
> (ver [galeria.md](galeria.md#ferramentas-no-sistema)). A limpeza é o passo 1.

### 1. Cada cartão

1. Plugar o microSD → o app lista os arquivos → marcar tudo → *Download*.
2. Ver e depois apagar as sobras de preview (rodar o `find` com `-print` antes):

   ```bash
   cd ~/Media/02_Cameras/Osmo_Pocket
   find . -type f \( -iname '*.LRV' -o -iname '*.THM' \) -print
   find . -type f \( -iname '*.LRV' -o -iname '*.THM' \) -delete
   ```

   Se o `-print` mostrar `.LRF` ou outra extensão que você não reconhece, **não apague
   às cegas** — é o primeiro cartão da Pocket 4 e nada disso foi testado nela.

### 2. Triagem no LosslessCut (ver [por que sem recodificar](#o-problema))

Abrir o clipe (`Ctrl` + `O` ou arrastar). Para cada take: achar o trecho bom → `I` →
avançar até o fim dele → `O` → `E`. Cria arquivo novo; **toque o corte antes de apagar
o original** (na lixeira, não `rm`).

| Tecla | O quê |
| --- | --- |
| `Espaço` | play / pause |
| `J` `K` `L` | mais lento / pausa / mais rápido *(fonte secundária)* |
| `←` `→` · `,` `.` | pulo de ~1 s · passo mínimo |
| `I` / `O` | início / fim do segmento atual |
| `+` | novo segmento (vários cortes no mesmo take) |
| `B` | divide o segmento no cursor |
| `Backspace` | remove o segmento / ponto de corte |
| `E` | abre o resumo de exportação (e exporta) |
| `C` | foto do frame atual |
| `Shift` + `/` | todos os atalhos |

- **Vários segmentos → um arquivo só:** no resumo do `E`, trocar o modo para
  *Merge cuts*. **Inverter** (símbolo yin-yang) exporta o que *não* marquei.
- **Detect scenes:** no menu de ferramentas, marca sozinho onde a cena muda; descarta
  os ruins e exporta o resto. *(Caminho de menu não conferido nesta versão.)*
- Corte sem recodificar só cai em quadro-chave: pode errar por frações de segundo.
  Aceito para triagem; para corte exato é outro assunto.

### 3. Enviar para o BLACK

Com o BLACK plugado (`lsblk` — confirmar que ainda é `sdb`):

```bash
rsync -rt --no-perms --no-owner --no-group --info=progress2 \
  ~/Media/02_Cameras/ /media/gustavo/BLACK/02_Cameras/
# conferir — lista vazia = idêntico (lê os dois lados, demora):
rsync -rc -n -i --no-perms --no-owner --no-group --modify-window=2 \
  ~/Media/02_Cameras/ /media/gustavo/BLACK/02_Cameras/
sync && udisksctl unmount -b /dev/sdb1 && udisksctl power-off -b /dev/sdb
```

Sem `--delete` de propósito (igual ao espelho de fotos em [backup.md](backup.md)).
exFAT é frágil a queda de energia: **sempre** a última linha antes de desplugar.

### 4. Pro Google Fotos

Os 3-4 melhores da semana, arrastados pelo navegador. Se pesar demais, comprimir
(próxima seção) — nunca o arquivo mestre.

## Compressão pra nuvem

Clipe bonito mas pesado demais pros 200 GB do Google One:

```bash
ffmpeg -i entrada.MP4 -c:v libx265 -crf 24 -preset fast -c:a aac -b:a 192k saida.MP4
```

H.265/HEVC com qualidade visualmente idêntica corta até 70%. Isso **recodifica** — é
pra cópia de distribuição, nunca pro arquivo mestre no HD.

## Caminhos de evolução

```
agora      LosslessCut instalado (2026-10-08), nunca usado num cartão real
  ↓ abrir, configurar o rapid-photo-downloader, rodar o 1º cartão
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

**2026-10-08 — LosslessCut instalado; o cheatsheet mora aqui.**
Uma tabela de atalhos só, neste arquivo, em vez de uma por one-page. *Por que aqui:*
é o dono do passo de triagem; [galeria.md](galeria.md) só aponta. *Consequência:* o
cheatsheet cobre também a configuração do rapid-photo-downloader e o envio ao BLACK,
porque o fluxo é um só (câmera → `~/Media` → poda → BLACK). Tudo ainda **hipótese**:
nenhum dos dois apps foi aberto.
