> **Entrou 2026-10-06.** Embasou
> [`docs/organizacao-de-arquivos.md`](../docs/organizacao-de-arquivos.md) (4 regras
> de ouro, shallow hierarchy, ISO 8601, Czkawka, exiftool, runbook dos HDs antigos)
> e [`docs/biblioteca.md`](../docs/biblioteca.md) (template do Calibre, blocos
> ficção/técnico, plugins).
>
> **Confiança: alta.** Ao avaliar, **~90% já estava aplicado** no repo e
> funcionando — o padrão cronológico está de fato em `~/Pictures` (17 GB em
> `AAAA/AAAA-MM/`, zero pasta por evento, verificado 2026-10-06). Serviu mais como
> confirmação independente do que como novidade.
>
> **O que era genuinamente novo e foi absorvido:**
> - divisão do export em blocos `01_Ficcao/` (autor+série) vs.
>   `02_Nao-Ficcao_Tecnicos/` (por assunto) — registrado como decisão **pendente**,
>   porque o bloco técnico exige criar coluna `#assunto` no Calibre;
> - a observação de que o Calibre tem "duas vidas" (pasta interna intocável vs.
>   export 100% controlável) — virou aviso explícito no doc.

---

Em comunidades dedicadas a organização digital (como o **Reddit** nos fóruns `r/datacurator`, `r/productivity` e `r/selfhosted`), existe um consenso muito forte sobre o que funciona a longo prazo e o que vira bagunça.

O erro mais comum das pessoas é criar dezenas de pastas dentro de pastas (uma árvore gigante). No celular isso é um pesadelo de navegar.

Hoje, a "escola moderna" de organização segue **4 regras de ouro**:

### 1. A Regra da "Inbox" (Pasta de Downloads é lixo transitório)

Nos fóruns, ninguém guarda arquivo definitivo na pasta `Download`. Ela é tratada como a **caixa de correio da sua casa**:

- As coisas chegam lá.
- Você abre, lê ou usa.
- Depois, você **ou guarda na pasta certa ou joga no lixo**.
- *Meta recomendada:* A pasta `Download` deve estar vazia (ou quase) no final da semana.

### 2. A Regra dos "No Máximo 3 Níveis" (Shallow Hierarchy)

Se você precisa clicar em mais de 3 pastas para achar um arquivo, a estrutura está errada.

- **Ruim (profundo demais):** `Documentos > Pessoal > Saúde > Exames > 2024 > Sangue > arquivo.pdf`
- **Bom (raso e eficiente):** `Documentos > Saúde > 2024-05-10_Exame-Sangue.pdf`

Em telas pequenas como a do celular, pastas rasas com arquivos bem nomeados são infinitamente mais rápidas de achar do que "labirintos de pastas".

### 3. Padrão Universal de Nomenclatura (ISO 8601)

Os fóruns técnicos são obcecados por isso porque **resolve a busca em qualquer sistema operacional** (Ubuntu, Android, Windows ou Mac).

- **Para Documentos/Contas/Exames:** Sempre comece com `AAAA-MM-DD` (Ano-Mês-Dia):
    - `2024-03-15_NotaFiscal_Notebook.pdf`
    - `2024-08-20_Exame_Cardiologista.pdf`
    - *Por que?* O sistema ordena cronologicamente de forma perfeita sozinho, sem você precisar criar pastas para cada ano ou mês.
- **Para Livros e Textos (Padrão Calibre):**
    - `Autor - Título (Ano).epub`
    - Exemplo: `Orwell, George - 1984.epub` ou `Martin, Robert - Clean Code (2008).pdf`

---

### O erro clássico com Livros (Aviso do fórum do Calibre):

**Não tente criar pastas por microgêneros.**
Por exemplo, criar pastas como: `Livros > Ficção > Distopia > Anos 80`.
Isso falha porque você sempre vai ficar na dúvida: *"Esse livro é de Inteligência Artificial, Matemática ou Programação?"*.

A recomendação mais sólida para livros é dividir apenas em grandes blocos, por exemplo:

- `Livros/Ficcao/`
- `Livros/Tecnologia_Estudo/`
- `Livros/Nao-Ficcao_Geral/`

E, dentro dessas 3 pastas, deixar os arquivos soltos, ordenados por `Autor - Nome do Livro`. A busca do My Files ou do MiXplorer acha o livro em 1 segundo apenas digitando o nome.

---

## Vários HDs antigos cheios de fotos

Lidar com vários HDs antigos cheios de fotos é uma das tarefas mais comuns e temidas em comunidades como o `r/datacurator` e `r/photography`.

O consenso absoluto nesses fóruns é: **não tente organizar isso manualmente pasta por pasta** — você vai levar meses, vai se cansar no meio do caminho e vai acabar duplicando arquivos.

### Fase 1: A Regra de Segurança (Não mexa no HD antigo)

HDs mecânicos antigos podem pifar a qualquer momento se você ficar rodando scripts pesados de leitura e gravação neles.

1. **Copie tudo para um único lugar:** Pegue o computador com bastante espaço e copie o conteúdo de todos os HDs para uma pasta única bruta (ex: `/dados/Fotos_Bruto_Central/`).
2. **Guarde os HDs antigos na gaveta:** Eles serão o seu backup de segurança caso algo dê errado no processo.

### Fase 2: Eliminar Duplicados (A Ferramenta Campeã: Czkawka)

No Ubuntu, a melhor ferramenta do mundo para isso hoje é o **Czkawka** (código aberto, feito em Rust, ultra-rápido):

- Você instala no Ubuntu (`sudo snap install czkawka` ou via Flatpak).
- Ele compara o **hash real** do arquivo (conteúdo exato), e não apenas o nome. Se uma foto chamar `IMG_001.jpg` e a outra `foto_praia.jpg`, ele sabe que são idênticas.
- Ele tem inclusive detecção de **fotos similares** (fotos repetidas tiradas em sequência ou em resoluções diferentes).
- Com ele, você elimina gigabytes de lixo duplicado em poucos minutos.

### Fase 3: O Padrão Universal de Pastas de Fotos

Qual estrutura os fóruns recomendam? **A estrutura puramente cronológica (por Ano e Mês).**

```
Fotos/
└── 2015/
    ├── 2015-01/
    │   ├── 2015-01-14_152310.jpg
    ├── 2015-07/
    │   ├── 2015-07-20_091244.jpg
└── 2016/
```

**Por que NÃO criar pastas como "Viagem Praia", "Aniversário João"?**
Porque pastas são excludentes. Se você tem uma foto do *"Aniversário do João"* que foi na *"Praia"*, ela vai em qual pasta? Essa dúvida gera desorganização.
O local e as pessoas devem ser tratados por **busca, IA ou metadados**, nunca pela estrutura de pastas físicas.

### Fase 4: O "Trabalho Pesado" Automático com o ExifTool

Quase toda foto tirada por câmera digital ou smartphone tem gravado dentro dela o **EXIF** (a data e hora exatas do clique, independente da data em que você copiou o arquivo).

```bash
sudo apt install exiftool
```

Com **um único comando**, o ExifTool lê a pasta bagunçada, olha a data original de cada foto e já cria as pastas `Ano/Ano-Mês` e renomeia o arquivo com `Ano-Mês-Dia_Hora.ext`:

```bash
exiftool -d "%Y/%Y-%m/%Y-%m-%d_%H%M%S%%-c.%%e" "-filename<DateTimeOriginal" -r /pasta/das/fotos/brutas
```

*(Você também pode simplesmente abrir o **Claude CLI** nessa pasta e pedir: "Use o exiftool para ler os metadados das fotos e organizá-las em subpastas Ano/Mês, fazendo um dry-run primeiro").*

*E as fotos sem EXIF (como imagens de WhatsApp)?* O ExifTool ou um script em Python pode usar a data de modificação do arquivo como plano de fuga.

### Fase 5: Como navegar nessas fotos depois de pronto?

1. **DigiKam (Para quem gosta de gerenciar no PC - 100% Offline):**
    - É o programa de fotos mais robusto do Linux. Ele escaneia suas pastas, tem **reconhecimento facial offline** (ele acha o rosto das pessoas para você criar álbuns de pessoas sem mexer nas pastas) e mapa com geolocalização.
2. **Immich (O queridinho absoluto do momento):**
    - Se você tem espírito "faça você mesmo" (*self-hosted*), o Immich é uma alternativa idêntica ao **Google Fotos**, mas que roda no seu computador/servidor local.
    - Ele tem aplicativo para o seu celular Android, backup automático, busca inteligente (ex: você digita "cachorro" ou "praia" e a IA local acha a foto antiga), e funciona lendo diretamente a sua pasta do computador.

---

## Calibre, Kindle e KOReader

### 1. Padronização de Metadados no Calibre (A base de tudo)

Tanto o Kindle quanto o KOReader dependem dos metadados internos do arquivo (e não do nome do arquivo) para exibir capas e organizar listas. No Calibre, garanta três coisas:

1. **Formato Master:** Mantenha sempre o arquivo original em **EPUB** (mesmo que vá mandar em outro formato para o Kindle). O EPUB é o padrão aberto universal. PDFs ficam como PDF.
2. **Preenchimento de Séries:** Se for uma saga (ex: *Duna - Vol 1*), preencha o campo **Série** no Calibre (Duna [1]). O Kindle e o KOReader usam isso para agrupar volumes automaticamente.
3. **Plugins úteis recomendados:**
    - **Modify ePub:** Limpa códigos quebrados de EPUBs baixados.
    - **KFX Output (se usa Kindle via cabo):** Permite enviar livros no formato mais moderno da Amazon (com suporte a hifenização perfeita, fontes em negrito ajustáveis e tempo de leitura preciso).

> **O Calibre tem duas "vidas":**
>
> 1. **A pasta interna dele:** Ele gerencia sozinho (usa `Autor/Livro/arquivo.ext`). Você **não** deve renomear essas pastas no explorador de arquivos, senão corrompe o banco.
> 2. **A exportação / envio (Kindle, KOReader e Backup):** Aqui você tem **100% de controle**. Você pode definir uma regra (um *template*) para o Calibre gerar pastas e nomes perfeitos e legíveis automaticamente ao enviar para o dispositivo ou salvar no disco.

### 1. A Estrutura de Pastas Ideal

Para leitura no **KOReader** (que navega diretamente por pastas) e para manter uma visualização limpa, a comunidade divide a biblioteca em dois grandes blocos:

```
Biblioteca/
├── 01_Ficcao/
│   └── Sobrenome, Nome/
│       ├── [Saga Duna]/
│       │   ├── 01 - Duna.epub
│       │   └── 02 - O Messias de Duna.epub
│       └── Livro Avulso (Ano).epub
│
└── 02_Nao-Ficcao_Tecnicos/
    └── Assunto/
        ├── [Python] Ramalho, Luciano - Fluent Python (2022).pdf
        └── [Finanças] Bogle, John - O Pequeno Livro do Investimento.epub
```

#### Por que essa divisão funciona tão bem?

- **Ficção e Literatura:** O que importa é o **Autor** e a **Série**. Você quer ver a obra do autor reunida e os volumes na ordem de leitura.
- **Livros Técnicos e PDFs:** Dificilmente você lembra o nome do autor de um livro de cálculo ou programação; você procura pelo **Assunto** (ex: *Python*, *História*, *Medicina*).

### 2. O Padrão de Nomenclatura de Arquivos

#### A. Livro avulso (sem continuação)

> `Sobrenome, Nome - Título da Obra (Ano).ext`
>
> *Exemplo:* `Orwell, George - 1984 (1949).epub`

*Usar `Sobrenome, Nome` evita que todos os autores chamados "John" ou "Carlos" fiquem juntos na letra J ou C.*

#### B. Livro que faz parte de uma Saga / Série

> `Sobrenome, Nome - [Nome da Série 01] - Título do Livro.ext`
>
> *Exemplo:* `Herbert, Frank - [Duna 01] - Duna.epub`
> *Exemplo:* `Herbert, Frank - [Duna 02] - O Messias de Duna.epub`

*O número com dois dígitos (`01`, `02`... em vez de apenas `1`) garante que o volume `10` não fique listado antes do volume `2` por ordem alfabética.*

#### C. PDFs e Documentos Técnicos

> `[Assunto] Autor - Título (Ano).pdf`
>
> *Exemplo:* `[Docker] Silva, João - Dominando Containers (2023).pdf`

### 3. Como automatizar isso no Calibre (A Mágica)

Quando você for enviar livros para o **KOReader** ou salvar uma cópia para o Google Drive:

1. No Calibre, vá em **Preferências > Importando/Exportando > Salvando livros no disco** (ou *Enviar para o dispositivo*).
2. No campo **Modelo de Salvamento**, cole esta fórmula clássica da comunidade:

```
{author_sort}/{series:||/|}{series_index:0>2s| - |}{title}
```

#### O que essa fórmula faz sozinha:

- Cria uma pasta com o nome do autor ordenado por sobrenome (`author_sort`).
- Se o livro tiver uma **Série** preenchida no Calibre, ele cria uma subpasta com o nome da saga. Se for livro avulso, não cria pasta extra.
- Adiciona o número do volume com dois dígitos e traço (`01 -` , `02 -` ) antes do título.

**Resultado real gerado pelo Calibre:**

- Se for Duna: cria a pasta `Herbert, Frank / Duna / 01 - Duna.epub`
- Se for um livro avulso: cria `Orwell, George / 1984.epub`

### 4. Dica para novos arquivos que você baixa (A "Inbox")

Antes de jogar o arquivo no Calibre, se ele vier da internet com um nome poluído (ex: `clean_code_robert_martin_v2_pdf_download.pdf`):

- Não gaste muito tempo editando manualmente.
- Apenas arraste para o Calibre, aperte a tecla **`E`** (atalho para *Editar Metadados*) e clique no botão **"Baixar Metadados e Capas"**.
- O Calibre busca o nome oficial, o autor correto, a data original de publicação e a sinopse em segundos na internet. A partir desse momento, o livro já está catalogado no padrão perfeito para sempre.
