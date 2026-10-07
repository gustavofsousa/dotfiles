> **Entrou 2026-10-06.** Embasou a seção de narrativa de
> [`docs/galeria.md`](../docs/galeria.md) e o RFD `AC8` do
> [ROADMAP](../ROADMAP.md).
>
> **Confiança: hipótese.** **Nenhuma das 4 ferramentas foi testada.** Obsidian é a
> única que já está instalada (por outro motivo — PKM, ver
> [`docs/notas-pkm.md`](../docs/notas-pkm.md)); DigiKam, Diarium e Mylio não estão
> na máquina.
>
> **O que foi aceito como conceito** (independente de ferramenta): a distinção
> *depósito* vs. *curadoria/narrativa*, e a **regra dos 5%** — de 300 fotos de uma
> viagem, 10-15 no diário + dois parágrafos de texto. Esse é o valor real da
> anotação; a escolha de app é secundária e segue aberta.
>
> **Ressalvas minhas:**
> - Diarium e Mylio são proprietários e **sem cliente Linux nativo** — entram só
>   se o caminho aberto (Obsidian + DigiKam) provar atrito alto na prática.
> - O texto não resolve a pergunta que decide tudo: **a foto no diário é cópia ou
>   ponteiro?** Embutir duplica bytes (e o vault vai pro Syncthing); apontar quebra
>   se a foto mudar de lugar. É o mesmo dilema dos álbuns de evento.

---

O que você está procurando é uma mudança de conceito: sair do modelo de **"depósito de fotos"** (como é o Google Fotos, cheio de prints, comprovantes e fotos repetidas) e ir para o modelo de **"curadoria e narrativa"** (Storytelling / Diário de Vida).

Aqui estão as melhores ferramentas e métodos para criar essa "biografia visual" no Linux:

### 1. Diarium (O melhor formato de Diário Multimídia)

Se você quer algo no estilo *"O que aconteceu nesse dia/viagem, com as melhores fotos e uma história escrita"*:

- **Como funciona:** Ele cria uma linha do tempo elegante onde cada entrada pode ter um texto, localização no mapa, clima do dia e uma seleção de fotos importantes.
- **Por que é excelente:**
    - Ele se integra perfeitamente com o **Google Drive** para salvar seu backup (sem custos extras de servidores deles).
    - Tem versão Web e aplicativos para celular e desktop.
    - Funciona como um diário pessoal que vira um livro de memórias ao longo dos anos.

### 2. Obsidian (Para criar uma "Biografia / Enciclopédia da sua Vida")

O **Obsidian** é um dos aplicativos mais amados no Linux. Ele é gratuito, 100% privado e roda direto no seu computador.

- **A proposta:** Você cria "capítulos" da sua vida como se fosse um livro ou uma Wikipédia pessoal.
- **Como usar para fotos:**
    - Você cria uma pasta chamada `Viagens`, `2024`, ou `Infância`.
    - Dentro de cada página (ex: *Passeio na Serra de 2023*), você arrasta as **3 ou 4 melhores fotos**, escreve quem estava lá, o que sentiu, causos engraçados que aconteceram.
    - Com plugins gratuitos da comunidade (como o *Obsidian Canvas* ou *Timeline*), você consegue ver toda a sua vida interligada em um mapa visual ou em uma régua de tempo.

### 3. DigiKam (O rei da Curadoria Nativo do Linux/KDE)

Como você usa o ambiente do Dolphin (KDE), o **DigiKam** é o software profissional padrão do ecossistema para organizar memórias.

- **Diferença para o Google Fotos:** Ele não serve para você apenas "olhar" fotos soltas, ele foi feito para você **contar histórias através de metadados**.
- **Recursos para biografia:**
    - **Classificação por Estrelas:** Você filtra o lixo e deixa apenas as fotos "5 estrelas" (as que realmente importam).
    - **Legendas e Títulos Embutidos:** Você escreve a história dentro do próprio arquivo da foto (se você mudar de computador daqui a 20 anos, o texto ainda estará gravado na foto).
    - **Visualização por Mapa:** Ele plota seus álbuns em um globo terrestre 3D.

### 4. Mylio Photos (Linha do Tempo por "Eventos de Vida")

O **Mylio** foi desenvolvido especificamente com essa filosofia de "álbum de família e história de vida".

- Ele tem a visualização chamada **Life Calendar**: em vez de rolar infinitamente por dias aleatórios, ele agrupa sua vida por **Década → Ano → Evento**.
- Você cria eventos como *"Casamento do Carlos"*, *"Primeiro Carro"*, *"Férias no Nordeste"*, colocando uma foto de capa e uma descrição do momento.

### Dica de ouro para quem quer "história" em vez de "volume":

O segredo desse método não é o programa, mas a **regra dos 5%**:

> De uma viagem onde você tirou 300 fotos no celular, deixe o Google Fotos guardar todas no backup automático, mas **escolha apenas 10 ou 15 fotos** para o seu Diário/Álbum biográfico e escreva 2 parágrafos sobre aquele dia. Daqui a 10 anos, esse texto com poucas fotos terá 100x mais valor emocional do que uma galeria com 10.000 imagens sem contexto.
