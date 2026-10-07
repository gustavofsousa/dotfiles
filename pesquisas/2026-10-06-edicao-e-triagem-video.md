> **Entrou 2026-10-06.** Embasou [`docs/edicao-video.md`](../docs/edicao-video.md)
> (triagem e corte sem recodificar) e a seção de exibição de
> [`docs/nas.md`](../docs/nas.md).
>
> **Confiança: hipótese.** **Nenhuma das ferramentas foi testada** — Auto-Editor,
> PySceneDetect, Czkawka, LosslessCut e Shutter Encoder estão todas ausentes da
> máquina (verificado 2026-10-06). `cargo`, `pip` e `uv` existem, então as CLI são
> instaláveis.
>
> **Correções e ressalvas minhas:**
> - A anotação manda `pip install auto-editor` e `pip install scenedetect[opencv]`
>   **global**. Aqui o padrão é **`uv tool install`** (ou `pipx`) — CLI Python global
>   via `pip` suja o Python do sistema e quebra em upgrade de distro.
> - `cargo install czkawka_cli` compila do zero (demorado). O snap/binário do GitHub
>   resolve igual; e o Czkawka **já estava** registrado como ferramenta de
>   deduplicação em [`docs/galeria.md`](../docs/galeria.md) antes desta pesquisa.
> - A seção 3 (projetor) descreve um **projetor que eu não tenho** — é desejo, não
>   setup. Registrada como horizonte de exibição no `nas.md`, não como fluxo atual.
> - O texto original começava truncado ("ara resolver"); marquei o `[P]` que faltava
>   e removi uma linha "**Instalação:**" duplicada. Nada mais foi editado.
>
> **O achado mais útil:** o LosslessCut **já tem o PySceneDetect embutido**
> ("Detect scenes" no menu) — o que torna a Opção 1 (CLI) desnecessária pro caso
> comum, e evita instalar duas ferramentas pra fazer o que uma faz.

---

[P]ara resolver isso no Ubuntu sem perder horas aprendendo editores de vídeo pesados e lentos (como DaVinci ou Premiere), existem duas soluções consagradas: uma focada em **automação e IA no Terminal (CLI)** e outra em uma **interface visual ultrarrápida projetada apenas para corte e triagem instantânea**.

---

### Opção 1: O Caminho da CLI + IA / Automação (Terminal)

Se você quer plugar o cartão e deixar o computador analisar, cortar e pré-selecionar os arquivos para você via scripts, esta é a combinação de ferramentas mais respeitada no ecossistema Linux:

#### 1. *Auto-Editor* (A automação inteligente de cortes)

O **Auto-Editor** analisa seus vídeos da Pocket e da GoPro e elimina trechos estáticos, silêncios ou falta de ação automaticamente, sem recodificar o vídeo.

- **O que ele faz:** Ele analisa o áudio e o **movimento** do vídeo. Se você deixou a Osmo Pocket gravando parada sobre a mesa sem ninguém falando ou sem ação relevante, ele remove essas partes e junta apenas os momentos onde há movimento ou vozes.
- **Instalação:**
    
    ```bash
    pip install auto-editor
    ```
    
- **Comando para cortar silêncios e momentos mortos:**
    
    ```bash
    auto-editor video_pocket.mp4 --edit audio:threshold=4% --margin 0.2s
    ```
    
- **Comando para cortar com base em movimento (útil para action cams):**
    
    ```bash
    auto-editor video_gopro.mp4 --edit motion:threshold=2%
    ```
    

#### 2. *PySceneDetect* (IA/Visão Computacional para fatiar vídeos longos)

Quando você grava 20 minutos contínuos na GoPro ou na Pocket com várias situações diferentes, o PySceneDetect usa algoritmos de visão computacional para detectar automaticamente onde a cena mudou drasticamente (ex: você saiu de casa e entrou no carro) e fatia o arquivo em clipes individuais.

- **Instalação:**
    
    ```bash
    pip install scenedetect[opencv]
    ```
    
- **Comando para detectar cenas e fatiar sem perder qualidade:**
    
    ```bash
    scenedetect -i video_longo.mp4 detect-content split-video
    ```
    

#### 3. *Czkawka CLI* (Limpeza instantânea de fotos duplicadas/ruins)

Feito em Rust, é o limpador mais rápido do mundo open-source. Ele compara fotos semelhantes (rajadas, fotos quase idênticas onde alguém piscou) e arquivos corrompidos.

- **Instalação (Binário único ou Cargo):**
    
    ```bash
    cargo install czkawka_cli
    # Ou baixe o binário direto do GitHub deles
    ```
    
- **Comando para encontrar fotos parecidas na sua pasta:**
    
    ```bash
    czkawka_cli image -d /caminho/do/hd/2026/ -s very_high
    ```
    

---

### Opção 2: As Interfaces Gráficas Mais Rápidas do Mundo (Zero Fricção)

Se você prefere a visão humana, mas quer uma interface cirúrgica que permita **cortar 1 hora de vídeo em 3 minutos usando apenas o teclado**, você só precisa de uma dessas duas opções:

#### 1. *LosslessCut* configurado para "Modo Velocidade Máxima"

Você não precisa clicar com o mouse para cortar. O LosslessCut foi feito para ser operado como uma máquina de arcade.

- **O Segredo dos Atalhos (Triagem em segundos):**
    - `Espaço`: Play / Pause.
    - `J` / `K` / `L`: Rebobinar rápido / Parar / Avançar rápido (estilo profissional).
    - `I`: Marca o início do que presta.
    - `O`: Marca o fim do que presta.
    - `E`: Exporta instantaneamente.
- **O Recurso Oculto de Detecção de Cenas:**
O LosslessCut tem o motor do *PySceneDetect* embutido na interface!
    - Abra o vídeo longo da Pocket > Clique no menu de três pontos no canto > **"Detect scenes"** (Detectar cenas).
    - Ele coloca marcadores automáticos em todas as mudanças de cena. Você só aperta a tecla `D` nos trechos que não quer e aperta `Export` para juntar (*merge*) apenas os pedaços bons em um arquivo único.

#### 2. *Shutter Encoder* (A Interface Canivete-Suíço Definitiva)

Se o LosslessCut parecer simples demais e você quiser algo que una cortes rápidos, conversão leve, corte de trechos e legendagem automática com IA (Whisper) em uma tela só:

- **O que é:** Baseado em FFmpeg, mas com uma interface pensada para fotógrafos e videomakers. Roda direto via **AppImage** no Ubuntu (sem instalar nada no sistema).
- **Como usar para triagem:**
    1. Arraste 20 vídeos da Pocket para dentro dele.
    2. Escolha a função **"Cut without re-encoding"** (Cortar sem recodificar).
    3. Ele abre uma janela de visualização leve: você marca os pedaços que quer manter e ele cospe os arquivos novos no HD externo na velocidade de leitura do disco.
- **Download:** Baixe o arquivo `.AppImage` no site oficial do *Shutter Encoder*, dê permissão de execução (`chmod +x`) e clique duas vezes.

---

### Comparativo Direto: Qual escolher?

| Cenário | Melhor Escolha | O que você faz |
| --- | --- | --- |
| **"Gravei muito tempo parado / vlogs com pausas chatas"** | **Auto-Editor (CLI)** | Roda uma linha de comando e ele cospe o vídeo sem silêncios nem momentos mortos. |
| **"Tenho um vídeo de 30 min da viagem e quero tirar 5 pedacinhos bons"** | **LosslessCut (GUI)** | Abre, aperta `I` e `O` usando os atalhos e salva sem reprocessar nada em 10 segundos. |
| **"Quero cortar, renomear em lote e já deixar leve para a noiva ver"** | **Shutter Encoder (GUI)** | Recorta sem perda e, na mesma tela, já manda converter uma versão leve para o Google Fotos. |

### Minha Recomendação para o seu Dia a Dia:

Comece pelo **LosslessCut aprendendo os atalhos `I`, `O`, `J-K-L` e a função "Detect scenes"**. Essa combinação é a que menos exige configuração técnica e entrega 90% da velocidade que você procura para a sua rotina no Ubuntu com a Osmo Pocket. Se sentir necessidade de automação cega, adicione o **Auto-Editor**.

### 3. Integração com o seu Setup (Google, Android, Pocket e Ubuntu)

Aqui é onde o seu ecossistema ganha vida e se torna extremamente agradável para você e sua noiva:

#### A. O "Porta-Retratos Gigante" (Modo Ambiente do Google)

A maioria dos bons projetores atuais já roda **Google TV / Android TV** nativo.

- No Google Fotos, você seleciona o álbum AAAA-MM Melhores ou um álbum inteligente com os rostos de vocês.
- Quando o projetor não estiver em uso para filmes, ele entra no **Modo Ambiente**: a sala ganha uma galeria de arte viva de 100 polegadas passando as melhores fotos de vocês em altíssima resolução com transições suaves.

#### B. Exibição Instantânea com a Noiva (Chromecast Integrado)

Filmou algo fofo com a Osmo Pocket ou celular?

- Você ou sua noiva não precisam passar cabo nem ligar computador: basta abrir o Google Fotos no celular Android, tocar no ícone de **Transmitir (Cast)** e a gravação roda instantaneamente na tela gigante em 4K.

#### C. Conexão com o Ubuntu e Futuro NAS

- Para sessões de cinema caseiro ou apresentações de trabalho:
    - **Via Rede (Sem Fios):** Com o futuro NAS ou pastas compartilhadas no Ubuntu (via protocolo SMB/NFS), você instala o app do **VLC, Nova Video Player ou Jellyfin** direto no projetor. Ele lê os arquivos brutos da Osmo Pocket e filmes pesados em 4K direto pela rede Wi-Fi 6 ou cabo, com navegação suave por controle remoto.
    - **Via Cabo:** Deixe um cabo HDMI 2.1 passado discretamente até o seu PC de trabalho caso precise de baixa latência para apresentações ou jogos.