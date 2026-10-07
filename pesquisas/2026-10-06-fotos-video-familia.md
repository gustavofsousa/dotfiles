> **Entrou 2026-10-06.** Embasou [`docs/galeria.md`](../docs/galeria.md) e
> [`docs/backup.md`](../docs/backup.md) (regra do arquivo mestre vs. acesso
> social, ingestão do Pocket, regra 3-2-1, camadas quente/morna/fria).
>
> **Confiança: hipótese.** Pesquisa externa (ChatGPT/Perplexity consolidando
> `r/DataHoarder`, `r/selfhosted`). Immich, Rapid Photo Downloader, QuickSync e
> Restic/Borg **não foram testados** por mim.
>
> **Correções minhas ao texto abaixo:**
> - O texto sugere RAID 1/ZFS como parte do 3-2-1. **Redundância não é backup** —
>   RAID protege de disco morto, não de apagar por engano ou ransomware (o erro
>   replica nos dois discos). A camada fria desconectada continua obrigatória.
> - A estrutura de pastas sugerida (`2026-07_Viagem_Praia/`) usa nome de evento,
>   que conflita com a regra cronológica. Resolvido com álbum por symlink — ver
>   [`docs/galeria.md`](../docs/galeria.md).
> - Pais fora do escopo (plano é só com a noiva); GoPro não tenho; a câmera é
>   **Osmo Pocket 4**.

---

Para criar um sistema harmonizado, seguro e sem estresse para as fotos e vídeos da família hoje, a recomendação unânime entre especialistas de tecnologia, fotógrafos e comunidades (como o *r/DataHoarder* e fóruns de tecnologia) baseia-se em resolver três problemas: **conveniência no dia a dia**, **compartilhamento fluido a dois** e **segurança contra perda definitiva a longo prazo**.

### 1. A Escolha do Ecossistema Principal (A "Nuvem Viva")

#### Casal usa Android (ou um usa iPhone e o outro Android)

- **Vencedor absoluto:** **Google Fotos + Google One**.
- **Como funciona a dois:** O recurso se chama **Compartilhamento com Parceiro (*Partner Sharing*)**.
    - Você convida o cônjuge e define para compartilhar "todas as fotos" ou apenas "a partir de uma data" ou "fotos de pessoas específicas".
    - O parceiro configura para **"Salvar automaticamente"** todas as fotos compartilhadas na conta dele.
    - **Vantagem de custo:** As fotos compartilhadas e salvas automaticamente não ocupam espaço na conta de quem recebeu enquanto estiverem na conta de quem enviou. A busca por inteligência artificial do Google Fotos (rostos, lugares, objetos, textos) ainda é a mais poderosa do mercado.

- **Ecossistema Google One Familiar dividido entre a família**.

### 3. Dinâmica Diária: Como organizar sem virar escravo de pastas

A maior armadilha moderna é tentar criar uma estrutura rígida de pastas para cada evento no smartphone. **Ninguém mantém isso a longo prazo.** As boas práticas recomendam um fluxo orgânico baseado em **Metadados + Filtro de Favoritos**:

1. **Confie na Linha do Tempo e nos Metadados:** As fotos já gravam data, hora e localização GPS automaticamente. Você não precisa criar uma pasta "2026-04 Almoço de Domingo". A busca por "restaurante", "praia" ou "abril de 2026" acha isso instantaneamente.
2. **A regra do "Coração" (Favoritos):**
    - Tirou 10 fotos da mesma pose? Escolha a melhor e aperte o ícone de **Coração/Favorito**.
    - Ao final de uma semana ou viagem, filtre apenas pelos "Favoritos". Isso reduz drasticamente o ruído e prepara o terreno para os destaques.
3. **Álbuns apenas para Eventos Marcantes:** Crie álbuns apenas para ocasiões fechadas, como:
    - *Exemplos:* `2026-07 Viagem Chile`, `Reforma da Casa`, `Aniversário 1 Ano Fulano`.
    - Ambos podem adicionar fotos ao mesmo álbum colaborativo.

### 4. Linha do Tempo: Principais fotos do Mês e de Viagens

- **O ritual mensal dos 15 minutos:** No último dia de cada mês, um de vocês (ou juntos) abre a galeria, filtra pelo mês que passou e cria um álbum chamado `2026-05 - Melhores`. Selecionem apenas de 20 a 40 fotos. É esse álbum enxuto que vocês olharão daqui a 5 anos.
- **Memórias Automáticas:** Tanto o Google quanto a Apple criam pequenos vídeos ("Recordações" / "Memórias") com trilha sonora automaticamente. Favorite essas recordações para não perdê-las.
- **Passo Físico (Altamente recomendado por especialistas):** No final do ano, use esses álbuns mensais ou de viagens para rodar um **Fotolivro** (via serviços como Phooto, Google Livros de Fotos, etc.). Uma estante com 1 fotolivro por ano supera qualquer galeria digital para folhear em família.

### 5. Preservação a Longo Prazo: A Regra de Ouro (3-2-1)

Estar apenas no Google Fotos **não é backup definitivo**, é apenas sincronização na nuvem. Se sua conta for suspensa acidentalmente, hackeada ou alguém apagar fotos por engano, elas somem.

A comunidade especializada segue estritamente a **Regra 3-2-1**:

- **3** cópias dos dados;
- **2** tipos de mídia diferentes (ex: nuvem + disco físico);
- **1** cópia fora de casa (a nuvem já serve como cópia externa).

#### O fluxo prático para manter isso:

1. **Dia a dia:** As fotos vão para a nuvem principal (Google Fotos).
2. **Rotina Semestral ou Anual (Cópia Fria Local):**
    - Baixe as fotos originais via ferramenta oficial:
        - No Google: use o **Google Takeout**.
        - Na Apple: exporte os originais sem modificações pelo app Fotos do PC ou solicite os dados via portal de privacidade da Apple.
    - Salve em um **SSD Externo ou HD Externo de mesa**.
    - Deixe esse disco guardado em local seguro (gaveta/cofre).
3. **Para quem quer automatizar 100% (Usuários Avançados):**
    - A solução mais aclamada atualmente em fóruns como *r/selfhosted* é usar um **NAS doméstico** (como Synology com o app *Synology Photos*, ou um mini-servidor com o software de código aberto **Immich**).
    - Esses sistemas funcionam como um "Google Fotos privado" dentro de casa, sincronizando direto do celular para os seus próprios discos rígidos, sem depender de assinaturas eternas.

### Resumo do "Setup Ideal" para Implantação Imediata

| Etapa | Recomendação Prática |
| --- | --- |
| **Plataforma (Se casal usa iPhone)** | Apple Fotos com *iCloud Shared Photo Library* (Plano Apple One/iCloud 2TB). |
| **Plataforma (Se aparelhos mistos)** | Google Fotos com *Compartilhamento com Parceiro* (Plano Google One 2TB). |
| **Curadoria Diária** | Usar o ícone de **Coração** na melhor foto; apagar o excesso na hora. |
| **Organização** | Linha do tempo automática + Álbuns colaborativos apenas para grandes viagens/marcos. |
| **Destaques** | Álbum "Melhores do Mês" (20 a 30 fotos) e fotolivro impresso anual. |
| **Segurança 10-30 anos** | 1 exportação anual completa para um disco rígido externo guardado em casa (Regra 3-2-1). |

---

## Câmeras dedicadas: o volume explode

A adição de uma câmera de uso diário (**Osmo Pocket**) e de uma câmera de ação (**GoPro**) muda uma regra fundamental do jogo: **o volume de dados brutos explode.**

Enquanto fotos de smartphone ocupam de 2 a 5 MB, minutos de vídeo em 4K a 60 fps da Osmo Pocket e da GoPro gravam a taxas de 80 a 130 Mbps (cerca de **600 MB a 1 GB por minuto**). Se você sincronizar esses arquivos brutos direto no Google Fotos, os seus 200 GB (já divididos com a noiva e os pais) se esgotarão em poucas semanas.

### 1. A Regra de Ouro: "Arquivo Mestre (Local)" vs. "Acesso Social (Nuvem)"

- **No HD Externo (via Ubuntu):** Ficam todos os arquivos brutos, intactos, em qualidade máxima.
- **No Google Fotos:** Entram apenas **fotos selecionadas** e **clipes curtos/editados** (os melhores 15 a 45 segundos daquele momento ou o vídeo final do evento).

### 2. A Tríade de Ferramentas no Ubuntu

#### A. Ingestão Automatizada: *Rapid Photo Downloader*

É o padrão-ouro no Linux para descarregar cartões SD. Ele lê o cartão da Osmo/GoPro, cria as pastas por data sozinho e renomeia os arquivos para você nunca ter arquivos repetidos como `DJI_0001.MP4`.

```bash
sudo apt install rapid-photo-downloader
```

- **O que configurar:** Defina para descarregar automaticamente para o seu HD externo no formato: `AAAA/AAAA-MM/AAAA-MM-DD_HH-MM-SS.ext`.

#### B. A Poda Rápida sem perda: *LosslessCut*

O maior erro com câmeras de uso diário é guardar takes de 3 minutos em que só 20 segundos prestam. O **LosslessCut** é indispensável: ele corta o início e o fim desnecessários de um vídeo **instantaneamente**, sem recodificar e sem perder 1% da qualidade original.

```bash
flatpak install flathub no.mifi.losslesscut
```

- **Uso diário:** Abriu o vídeo no Ubuntu, marcou entrada e saída com as teclas `I` e `O`, apertou `Export`. O take de 1 GB vira um trecho enxuto de 150 MB em menos de dois segundos.

#### C. Compressão Opcional para o Google Fotos: *HandBrake*

- Pelo **HandBrake** (ou um script em `ffmpeg`), converta o take selecionado usando o codec **H.265 (HEVC)** com preset de qualidade visualmente idêntica. O tamanho do arquivo cai em até 70%.

### 3. Dinâmica Diária: Como vê as gravações da Pocket no dia a dia?

- **Caminho Imediato (Sem passar pelo PC):**
    - Filmou algo especial com a Pocket? Conecte-a ao smartphone via app **DJI Mimo**, baixe o clipe para o seu Android.
    - Ele entrará na galeria do celular, o Google Fotos fará o backup e, através do **Compartilhamento com Parceiro**, sua noiva receberá o vídeo na timeline dela minutos depois.
    - *Atenção:* Use isso com parcimônia para vídeos curtos do momento, evitando lotar a nuvem.
- **Caminho Consolidado (Fim de semana no Ubuntu):**
    1. Conecte o cartão MicroSD no Ubuntu.
    2. O *Rapid Photo Downloader* joga tudo para o HD externo.
    3. Você passa o olho rápido com o *LosslessCut* e apaga o que ficou tremido ou errado.
    4. Abra o **Google Fotos no navegador** e arraste para dentro apenas os 3 ou 4 melhores momentos da semana.

### 4. Estrutura de Pastas Recomendada no HD Externo

```
[HD_EXTERNO]
├── 01_Smartphones/             <-- Dumps do Google Takeout (celulares da família)
└── 02_Cameras/
    ├── Osmo_Pocket/
    │   └── 2026/
    │       ├── 2026-05_Dia_a_Dia/
    │       └── 2026-07_Viagem_Praia/
    └── GoPro/
        └── 2026/
            └── 2026-03_Trilha/
```

### 5. O que isso muda no seu Futuro NAS ou DAS?

1. **Immich e Processamento de Vídeo:**
    - O **Immich** suporta vídeos da DJI e GoPro perfeitamente, inclusive gerando transcodes para reprodução suave no celular da sua noiva.
    - Ao montar o PC antigo como NAS, **garanta um processador Intel que tenha QuickSync** (qualquer Core de 7ª a 10ª geração baratinho no mercado de usados). No Ubuntu Server, o QuickSync faz a transcodificação de vídeos 4K por hardware com consumo quase nulo de energia.
2. **Rede Local:**
    - Como você moverá arquivos de vídeo de 10 a 30 GB com frequência, garanta que o futuro NAS esteja conectado ao roteador via **cabo de rede Gigabit (Cat 5e ou Cat 6)**, nunca via Wi-Fi.

### Script Rápido para o seu Terminal Ubuntu

```bash
ffmpeg -i entrada.MP4 -c:v libx265 -crf 24 -preset fast -c:a aac -b:a 192k saida_leve.MP4
```

*(Ele preserva a nitidez visual e corta o tamanho do arquivo drasticamente).*

---

## Ergonomia digital: não virar um "lixão digital"

Guardar absolutamente tudo o que sai de uma GoPro e de uma Osmo Pocket é a receita mais rápida para transformar seu HD externo e seu futuro NAS em um **"lixão digital"** caro de manter e impossível de navegar.

Ergonomia digital significa **acessar o que importa em 3 segundos, sem discos abarrotados de arquivos inúteis e sem o risco de derrubar fisicamente o seu equipamento**.

### 1. Elimine o "Lixo Invisível" da GoPro e DJI (Economia de 15% a 25% de espaço)

- **Arquivos .LRV (*Low Resolution Video*):** São vídeos em baixíssima qualidade gerados apenas para a telinha da câmera ou para o preview no app de celular.
- **Arquivos .THM (*Thumbnail*):** São miniaturas minúsculas para a interface da câmera.

**A boa prática no Ubuntu:** nunca copie esses arquivos para o HD. Se você usar o **Rapid Photo Downloader**, vá nas configurações de download e adicione regras para **ignorar extensões .lrv e .thm**.

```bash
find . -type f \( -name "*.LRV" -o -name "*.lrv" -o -name "*.THM" -o -name "*.thm" \) -delete
```

### 2. A "Regra da Poda Imediata" (Corte antes de Arquivar)

- **O erro comum:** Descarregar 64 GB de cartão com 50 takes de 2 minutos (onde você filmou o chão, a tampa da lente, ou 10 tentativas da mesma cena) e pensar: *"depois eu edito isso"*. Você nunca vai editar, e pagará caro em terabytes para guardar vídeo de sapato.
- **A rotina correta:**
    1. Descarregou no Ubuntu? Abra os vídeos no **LosslessCut**.
    2. O vídeo tem 2 minutos, mas o momento especial durou 25 segundos? **Corte os 25 segundos e salve.**
    3. **Delete o arquivo de 2 minutos imediatamente.**
    4. Mantenha no HD apenas os takes que você realmente teria orgulho de mostrar para alguém no futuro.

### 3. Ergonomia Física e Operacional do HD Externo (No Ubuntu)

#### Cuidados Físicos

- **Ponto Fixo na Mesa:** Nunca use o HD pendurado pelo próprio cabo na porta USB do gabinete ou notebook. Deixe o HD sempre deitado em uma superfície plana e estável, com um pedaço de borracha ou mousepad embaixo para amortecer vibrações.
- **Desconexão Segura no Ubuntu:** O Linux faz cache de gravação na memória RAM. Mesmo que a barra de progresso tenha terminado, o Ubuntu pode ainda estar gravando dados silenciosamente no HD. **Sempre clique com o botão direito no ícone do disco e selecione "Desmontar com segurança"** antes de puxar o cabo.

#### Sistema de Arquivos Recomendado

- **Se o HD for usado exclusivamente no seu Ubuntu e no futuro NAS (Linux):** Formate-o em **ext4**. Ele é nativo, muito mais robusto contra quedas de energia (tem *journaling* avançado), não fragmenta os arquivos pesados de vídeo e não corrompe à toa.
- **Se você precisar plugar no Windows eventualmente:** Use **exFAT**. Evite usar NTFS no Linux para vídeos pesados, pois o driver consome mais processamento e pode gerar inconsistências de permissão.

#### Evite copiar pelo gerenciador de arquivos (Nautilus)

Copiar 40 GB de uma vez arrastando pastas no mouse costuma travar o Nautilus ou congelar a interface. No Ubuntu, acostume-se a copiar usando o terminal com o utilitário rsync. Ele mostra o progresso real e, se a luz cair, ele retoma exatamente de onde parou:

```bash
rsync -ah --progress /caminho/do/cartao_sd/ /caminho/do/hd_externo/2026/
```

### 4. A Arquitetura do Futuro: DAS vs. NAS e as "Camadas" de Armazenamento

| **Tipo** | **O que é** | **Para quem serve** |
| --- | --- | --- |
| **DAS** (*Direct Attached Storage*) | Uma "gaveta" com 2 a 4 baias de HDs conectada via cabo USB-C/Thunderbolt direto no seu PC. | Se você quer apenas muito espaço local ultrarrápido para editar no seu Ubuntu, sem ligar para acesso remoto. |
| **NAS** (*Network Attached Storage*) | O PC antigo ou equipamento dedicado ligado no roteador, funcionando 24h na rede. | **A sua melhor escolha.** Permite que sua noiva, seus pais e seus celulares sincronizem fotos mesmo quando o seu computador de trabalho estiver desligado. |

#### O Conceito das Três Camadas (Hierarquia de Dados Enxuta)

1. **Camada Quente (Produção diária / Rápida):** Fica no **SSD interno do seu Ubuntu**. É onde ficam os vídeos da semana que você ainda está cortando ou editando. Espaço temporário, zero apego.
2. **Camada Morna (Arquivo Doméstico Ativo):** Ficará no seu **futuro NAS rodando Immich** (espelhado em RAID 1). É onde ficam as fotos de família tratadas, os cortes finais da Pocket e as melhores fotos da vida do casal. Fácil de pesquisar pelo celular ou pela TV.
3. **Camada Fria (Cofre / Backup Desconectado):** O seu **HD externo atual**. Ele fica guardado na gaveta. Uma vez a cada 3 ou 6 meses, você o pluga no NAS, roda um backup incremental com ferramentas leves (como Restic ou BorgBackup), desmonta e guarda de volta.
