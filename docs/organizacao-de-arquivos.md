# Organização de arquivos do notebook

Padrão de "onde cada coisa mora" para o computador inteiro — não só para o
que está neste repo. Serve de referência para as decisões de pasta das
Fases 1 e 2 do [ROADMAP.md](../ROADMAP.md). A decisão que originou este doc
está registrada no [STATE.md](../STATE.md).

> **Skill.** Existe uma skill que aplica este padrão na prática:
> `arruma-meu-not-ai` (em `~/.claude/skills/`). Ela tria pastas bagunçadas,
> decide onde arquivos moram, migra dotfiles pra XDG e audita a home. Este doc
> é a fonte de verdade; a reference da skill espelha ele.

> **Escopo.** Este doc define o *padrão*. Aplicar o padrão (mover pastas,
> renomear, ajustar apps) é trabalho das Fases 1/2 — aqui só se decide a
> convenção. Enquanto a aplicação não acontece, a realidade da home pode
> divergir deste doc; as divergências conhecidas estão listadas no fim.

## Ferramentas no sistema

Medido em 2026-10-06. Este padrão é sobretudo convenção, não ferramenta — mas duas
coisas o sustentam na prática:

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| `stow` 2.3.1 | criar os symlinks de config (Camada 1) | ✅ | apt |
| `xdg-user-dirs-update` | define as pastas de topo (Camada 2) | ✅ | apt (vem com o GNOME) |
| `trash-cli` (`trash-put`) | apagar pra lixeira pelo terminal em vez de `rm` | ⬜ **falta** | `sudo apt install trash-cli` |

**Personalização que *é* o padrão:**

| O que | Onde mora | Versionado? |
| --- | --- | --- |
| Nomes das pastas de topo em inglês | `~/.config/user-dirs.dirs` | ⬜ **não, e deveria** — é o que faz `~/Documents` em vez de `~/Documentos`; candidato a pacote Stow |
| `XDG_*_HOME` | nenhuma sobrescrita — valem os defaults | — |
| Variáveis de ambiente (ex. `QT_QPA_PLATFORMTHEME`) | pacote `environment/` | ✅ Stow |

> 💡 `user-dirs.dirs` fora do git é uma lacuna real: em máquina nova as pastas de topo
> voltam nos nomes do locale (PT-BR), contra o padrão. Item pro roadmap, barato de
> resolver (um pacote Stow de uma linha).

## Princípio

Duas camadas, cada uma com seu padrão:

1. **Config, dados de app, cache, estado** → seguem a
   [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
   estritamente. É o padrão de fato no Linux e a maioria das ferramentas
   modernas já respeita — adotá-lo integralmente evita reinventar convenção.
2. **Arquivos do usuário** (documentos, projetos, mídia, arquivo frio) → o
   XDG não define onde moram. Aqui vale a convenção de pastas de topo em
   **inglês**, alinhada ao `xdg-user-dirs`, descrita abaixo.

Regra geral por trás das duas: **nomes em inglês** (consistência com o repo,
que é open-source-facing) e **dados privados sempre fora do git** — só
configuração entra neste repositório.

## Regra dos no máximo 3 níveis (shallow hierarchy)

Se é preciso abrir mais de 3 pastas pra achar um arquivo, a estrutura está
errada. Nome de arquivo bem feito (ver nomenclatura abaixo) substitui pasta.

- **Ruim:** `Documents/Pessoal/Saude/Exames/2024/Sangue/arquivo.pdf`
- **Bom:** `Documents/saude/2024-05-10_exame-sangue.pdf`

Vale pra toda a Camada 2 (`Documents`, `Pictures`…), não só pra documentos.
Categoria vira **um** nível de pasta; tempo e assunto viram parte do **nome
do arquivo**, não de mais pastas.

## Nomenclatura de arquivos — ISO 8601

Documento, conta, exame, recibo: nome começa com `AAAA-MM-DD`.

```
2024-03-15_nota-fiscal-notebook.pdf
2024-08-20_exame-cardiologista.pdf
```

Por quê: o sistema de arquivos ordena cronologicamente sozinho, sem pasta por
ano/mês. Convenção específica pra ebooks (Calibre) fica em
[`biblioteca.md`](biblioteca.md#saída-nomenclatura-de-exportenvio).

## Camada 1 — XDG Base Directory (config, dados, cache, estado)

Quatro diretórios-base, com os defaults do XDG (nenhuma `XDG_*_HOME` está
sobrescrita neste sistema, então valem os padrões):

| Variável            | Default            | O que guarda                                   |
| ------------------- | ------------------ | ---------------------------------------------- |
| `XDG_CONFIG_HOME`   | `~/.config`        | Configuração (o que este repo versiona).       |
| `XDG_DATA_HOME`     | `~/.local/share`   | Dados de app que devem persistir (não-cache).  |
| `XDG_STATE_HOME`    | `~/.local/state`   | Estado volátil-mas-útil: logs, histórico, undo.|
| `XDG_CACHE_HOME`    | `~/.cache`         | Cache descartável — pode apagar sem perda.     |
| `XDG_RUNTIME_DIR`   | `/run/user/1000`   | Sockets/arquivos efêmeros da sessão (do sistema).|

Diretrizes:

- **Config nova mora em `~/.config/<app>/`** e, se for versionada, vira um
  pacote do Stow neste repo espelhando esse caminho (ver
  [README.md](../README.md)).
- **Evitar dotfiles soltos na raiz da home** (`~/.foo`) quando o app suporta
  XDG. Quando não suporta, o dotfile de raiz vai para o pacote `home/`.
- **`~/.cache` é sempre descartável** — nunca colocar lá nada que doa perder,
  nunca versionar.
- **Não versionar** `~/.local/share`, `~/.local/state`, `~/.cache`: são dados
  de app/estado/cache, não configuração.

## Camada 2 — Arquivos do usuário (pastas de topo)

Nomes em inglês, alinhados ao `xdg-user-dirs` (`~/.config/user-dirs.dirs`),
mais uma pasta própria para o que o XDG não cobre (`Projects`).

| Pasta          | XDG user-dir?      | O que mora                                        |
| -------------- | ------------------ | ------------------------------------------------- |
| `~/Documents`  | sim                | Documentos "vivos" (em uso, editáveis).           |
| `~/Downloads`  | sim                | Zona de entrada — temporário, some/some vira lixo.|
| `~/Pictures`   | sim                | Fotos e imagens.                                  |
| `~/Music`      | sim                | Música.                                           |
| `~/Videos`     | sim                | Vídeos.                                           |
| `~/Desktop`    | sim                | Área de trabalho — manter vazia/mínima.           |
| `~/Public`     | sim                | Compartilhamento — usar só se houver necessidade. |
| `~/Templates`  | sim                | Modelos de documento.                             |
| `~/Projects`   | não (próprio)      | Código e projetos pessoais.                       |

Diretrizes:

- **Regra da Inbox.** `Downloads/` é a caixa de correio, não um armário: chega,
  você abre/usa, e ou guarda no lugar certo ou joga fora. Meta: **vazia (ou
  quase) no fim da semana** — se tem arquivo de mês passado ali, virou sinal
  de triagem atrasada, não "arquivo que mora lá".
- **`Downloads/` é transiente.** Nada mora ali em definitivo — ou vira lixo,
  ou é movido para o lugar "certo" (`Documents/`, `Projects/`…).
- **`Projects/` é o lar do código.** Convém, mas não é obrigatório, um esquema
  de prefixo numérico para ordenar (padrão já em uso hoje: `01_...`, `02_...`).
- **Sem tier de "frio" (decisão 2026-09-16): não existe `~/Archive`.** Todo
  arquivo é ou vivo num lugar categorizado (`Documents/<assunto>/`,
  `Projects/`) ou é lixo — apagado. Nada de guardar "porque não sei se um dia
  preciso": sem categoria clara e sem uso, a resposta é apagar, não uma gaveta
  de esquecimento. Motivo: `~/Archive` virou depósito sem curadoria
  (fotos, livros-fonte já importados, backup, vault vazio, tudo misturado) e
  dava a falsa sensação de "resolvido" só por ter tirado da frente do
  Downloads.
- **`~/Backups` é diferente: tier estreito, só pra backup de verdade.**
  Snapshot manual de algo que já tem categoria clara em outro lugar (ex:
  cópia da biblioteca do Calibre) é uma cópia de segurança deliberada, não
  "frio sem saber o que fazer" — não vira gaveta: cada item ali precisa
  justificar por que é backup e não apenas o original movido pra lá. Hoje só
  tem `biblioteca-backup-2026-09-11/` (ver `biblioteca.md`).
- **Sincronização (Drive, Syncthing) é ortogonal à estrutura.** A pasta
  sincronizada mora dentro dessas pastas de topo (ex: um subdir de
  `Documents/` ou uma pasta própria como `~/Drive`), não substitui o padrão.
  A decisão de qual pasta sincronizar com o quê é da Fase 1.

### Fotos, vídeos e álbuns → [`galeria.md`](galeria.md)

A aplicação deste padrão a foto e vídeo (estrutura cronológica `AAAA/AAAA-MM/`,
álbuns de evento por symlink, deduplicação com Czkawka, runbook de recuperar HD
antigo com `exiftool`) vive no one-page do tema: **[galeria.md](galeria.md)**.

Aqui fica só a regra geral: **nunca pasta por evento/pessoa** — pasta é excludente
(a foto do aniversário *na praia* vai em qual das duas?). Local e pessoa são
busca/metadado. E `Screenshots/` segue como pasta própria em `Pictures/` por não ser
"foto", e sim utilitário transiente.

### Método P.A.R.A. (referência avaliada, **não adotado**)

Modelo popular (Tiago Forte) pra organizar vida digital em 4 blocos —
registrado aqui como opção conhecida, não como padrão em vigor. Adotar
implicaria renomear/reestruturar pastas de topo já em uso (`Documents`,
`Projects`) — é decisão estrutural grande (Fase 1/2), não uma aplicação de
rotina da skill. Fica documentado pra quando a decisão for tomada
conscientemente:

1. **Projects** — coisas com prazo curto, ativas agora (`Reforma-Casa`, `TCC`).
   Sai da pasta quando o projeto acaba.
2. **Areas** — responsabilidades contínuas, sem fim (`Financas`, `Saude`,
   `Veiculo`, `Contratos`).
3. **Resources** — interesses/biblioteca de consulta sem prazo (livros,
   cursos, manuais) — **é aqui que `livros/` cairia** se PARA for adotado.
4. **Archive** — histórico frio. **Sem equivalente hoje** (decisão 2026-09-16
   eliminou o `~/Archive` — ver Camada 2 acima); se PARA for adotado um dia,
   esse bloco 4 precisaria de critério de saída definido (quando algo sai do
   Archive pra apagar de vez), não só "guardar pra sempre".

Mapeamento aproximado com o que já existe: `~/Projects` ≈ *Projects* (mas hoje
só cobre código; PARA também inclui projeto não-técnico), `~/Documents` hoje
mistura o que PARA separaria em *Areas* e *Resources*. **Não implementar sem
discussão explícita** — é reestruturação, não faxina.

### Organização de livros fora do Calibre (celular, e-reader, pasta bruta)

Vale só pra ebooks que **não** estão na `biblioteca/` gerenciada pelo Calibre
(cópia no celular, pen drive, pasta de entrada antes de importar). Erro
clássico: pasta por microgênero (`Ficcao/Distopia/Anos-80`) — sempre gera
dúvida ("isso é IA, Matemática ou Programação?"). Preferir **3 baldes
grandes**, arquivos soltos dentro, nomeados `Autor - Titulo` (busca do
celular acha em 1s, não precisa de pasta funda):

```
Livros/
├── Ficcao/
├── Tecnologia_Estudo/
└── Nao-Ficcao_Geral/
```

## Config viva vs. config no sótão (`attic/`)

Nem toda config que já foi usada continua ativa. Ao largar uma ferramenta
(ex: migrar de Sway/waybar para GNOME Ubuntu), a config **não é apagada** —
vai para o **sótão**, guardada e recuperável, mas fora do caminho.

Três estados possíveis para uma config:

| Estado    | Onde mora                       | Symlink (Stow)? | Versionado? |
| --------- | ------------------------------- | --------------- | ----------- |
| **Viva**  | pacote na raiz do repo          | sim (ativo)     | sim         |
| **Sótão** | `attic/<ferramenta>/` no repo   | não             | sim         |
| **Morta** | apagada (só se realmente lixo)  | —               | —           |

- **Sótão = `attic/` no próprio repo.** A config sai do Stow ativo (não vira
  mais symlink), mas continua no git — recuperável e **portátil** se um dia
  voltar a essa ferramenta ou mudar de distro. É o "guardar sem poluir o
  fluxo ativo".
- **Por que no repo e não solto na home:** config é o que este repo existe pra
  versionar. Deixar solto fora do git perderia o histórico e a portabilidade —
  e a home não tem mais um tier de "frio" pra dados nem pra config (ver
  Camada 2 acima).
- **Preserva o estilo entre distros:** manter as configs antigas arquivadas
  (não deletadas) é o que garante que seu "jeito de usar" sobrevive a uma troca
  de distro — e é base pronta pra Fase 3 (Nix/home-manager), que vai declarar
  esse estilo de forma reproduzível.

## Dados privados vs. git

- **Só configuração entra neste repo.** Dados de usuário (Camada 2), dados de
  app (`.local/share`), cache, estado e segredos ficam **fora do git**.
- **Segredos** (tokens, chaves, credenciais) nunca vão para o repo em texto
  puro — ver [AGENTS.md](../AGENTS.md). A solução declarativa de segredo é
  tema da Fase 3 (ver [ROADMAP.md](../ROADMAP.md)).

## Onde o real ainda não bate com o padrão

As divergências conhecidas da home (`~/projects` minúsculo, dotfiles soltos que
poderiam seguir XDG) são **pendências, não exceções ao padrão** — vivem como item
no [ROADMAP.md](../ROADMAP.md), que é onde o que falta fazer mora.

Duas regras que são decisão fechada, não divergência:

- **`~/Archive` não deve ser recriado** (decisão 2026-09-16, ver Camada 2) —
  virou depósito sem curadoria. Backup deliberado vai em `~/Backups/`.
- **`~/Media` só se `Pictures`/`Music`/`Videos` deixarem de bastar** — hoje bastam.
