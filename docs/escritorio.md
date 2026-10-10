# Escritório — OnlyOffice e fontes de documento

Suíte de escritório do notebook: qual app abre `.docx`/`.xlsx`/`.pptx`/PDF, e quais
fontes garantem que documento vindo do Windows abra sem desalinhar.

**Backup disso:** [backup.md](backup.md). **Migração declarativa:** [nix.md](nix.md).

## Estado hoje

- **OnlyOffice Desktop Editors** é a suíte única (Documentos, Planilhas, Apresentações, PDF).
- **LibreOffice removido** por completo em 2026-10-10 (16 pacotes `libreoffice-*` + libs órfãs).
- **Fontes de documento completas:** MS core (Arial, Times New Roman…) **+** Carlito/Caladea
  (substitutos métricos de Calibri/Cambria, a fonte padrão do Word moderno).

OnlyOffice veio por **snap**. O snap é confinado, mas enxerga as fontes do sistema
pelos plugs `home` + `desktop` — medido: 17 variantes de Arial/Times visíveis dentro
do sandbox em 2026-10-10. Logo, a instalação das fontes no host **vale** para o OnlyOffice.

## Ferramentas no sistema

Medido em 2026-10-10 (`snap list`, `dpkg -l`, `fc-list`).

| Ferramenta | Pra quê | Estado | Origem |
| --- | --- | --- | --- |
| **OnlyOffice Desktop Editors** 9.4.0 (rev 1220) | suíte: Word/Excel/PowerPoint/PDF | ✅ | **snap** (`onlyoffice-desktopeditors`, canal `latest/stable`) |
| **ttf-mscorefonts-installer** 3.8.1ubuntu1 | fontes MS core (Arial, Times New Roman, Courier New, Georgia, Verdana, Comic Sans, Impact, Trebuchet, Webdings) | ✅ | apt (baixa os `.ttf` da SourceForge, aceita a EULA) |
| **fonts-crosextra-carlito** 20230309 | substituto métrico de **Calibri** | ✅ | apt |
| **fonts-crosextra-caladea** 20200211 | substituto métrico de **Cambria** | ✅ | apt |

## A lacuna de fontes Calibri/Cambria (resolvida)

> **NOTE:** o `mscorefonts` **não** inclui Calibri nem Cambria. Desde o Office 2007, a
> fonte padrão do Word é **Calibri** (corpo) e, em alguns modelos, **Cambria** (títulos).
> Elas são fontes ClearType, licenciadas à parte, e não entram no pacote core. Sem elas, um
> `.docx` moderno substitui fonte e pode desalinhar.

Resolvido em 2026-10-10 com os **substitutos métricos** livres — mesma largura e altura de
letra, então o layout se preserva:

- **Carlito** ≈ Calibri (métrica idêntica) — `fonts-crosextra-carlito`.
- **Caladea** ≈ Cambria (métrica idêntica) — `fonts-crosextra-caladea`.

OnlyOffice e LibreOffice mapeiam Calibri→Carlito e Cambria→Caladea automaticamente via
fontconfig. Para a Calibri/Cambria **reais** (fidelidade 100%, não só métrica), só copiando
os `.ttf` de uma instalação Windows/Office — decisão de licença, não default.

## Personalização a preservar

| O que | Onde mora | Versionado? |
| --- | --- | --- |
| `DesktopEditors.conf` (tema, janela, titlebar) | `~/snap/onlyoffice-desktopeditors/current/.config/onlyoffice/` | ✅ **sim** — cópia canônica em `onlyoffice/DesktopEditors.conf` do repo |
| fontconfig interno do snap | `~/snap/.../current/.config/fontconfig/fonts.conf` | ❌ não — gerado pelo snap |

**Como é versionada** — pasta `onlyoffice/` do repo (não é pacote Stow, mesmo padrão do `gnome-shell/`):

- `onlyoffice/DesktopEditors.conf` — a cópia canônica. `UITheme=theme-system` (segue o
  claro/escuro do sistema, casa com o `theme-sync/`), `maximized=true`, `titlebar=custom`.
- `onlyoffice/apply-config.sh` — aplica a cópia no snap. **Feche o OnlyOffice antes** (ele
  reescreve a config ao fechar). Faz backup `.bak` do atual.
- `onlyoffice/dump-config.sh` — recaptura do snap pro repo depois de mudar algo na GUI;
  remove a linha `position=` (presa à resolução, não portável).
- Entra no `bootstrap.sh` como passo opcional: `./bootstrap.sh --apply --with-onlyoffice-config`.

> **NOTE:** por que script e não Stow — o snap grava sob `~/snap/.../<rev>/`, onde `<rev>`
> muda a cada atualização e `current` é symlink do snapd. Stow apontando pra dentro de
> `current` colidiria com esse symlink. Copiar por script é o caminho limpo.

## O que isso vira no Nix

Objetivo da migração (ver [nix.md](nix.md)): reinstalar tudo por configuração declarativa,
sem redescobrir app por app. Mapa pronto:

| Hoje | Vira no Nix |
| --- | --- |
| OnlyOffice via **snap** | `pkgs.onlyoffice-desktopeditors` (ou `onlyoffice-bin`) em `home.packages` — tem pacote nativo no nixpkgs, o snap **sai limpo** |
| `ttf-mscorefonts-installer` (apt) | `pkgs.corefonts` em `fonts.packages` — **exige** `nixpkgs.config.allowUnfree = true` (EULA) |
| `fonts-crosextra-carlito` (apt) | `pkgs.carlito` (livre, sem unfree) |
| `fonts-crosextra-caladea` (apt) | `pkgs.caladea` (livre, sem unfree) |

> **NOTE:** OnlyOffice **não** é um caso difícil de migração (diferente do Logseq snap,
> em [nix.md](nix.md#perguntas-abertas-rfds-quando-chegar-a-vez)): o nixpkgs tem o pacote
> nativo. Na migração, trocar snap por `pkgs.onlyoffice-desktopeditors` resolve.

## Decisões

**2026-10-10 — OnlyOffice substitui o LibreOffice.** Suíte única com melhor fidelidade a
`.docx`/`.xlsx`/`.pptx` do ecossistema Microsoft e editor/leitor de PDF nativo. *Por que
OnlyOffice:* compatibilidade com formato Office é mais alta que a do LibreOffice no uso
diário com arquivos vindos do Windows. *Consequência:* depende das fontes MS no host —
por isso entraram juntos o `mscorefonts` e os substitutos Carlito/Caladea (Calibri/Cambria).

**2026-10-10 — Fontes MS instaladas no host, não no snap.** O snap confinado enxerga as
fontes do sistema pelos plugs `home`/`desktop`. *Por quê:* instalar no host serve o
OnlyOffice **e** qualquer outro app (navegador, visualizador), sem duplicar por sandbox.

**2026-10-10 — Config do OnlyOffice versionada por script, não por Stow.** A pasta
`onlyoffice/` guarda o `DesktopEditors.conf` canônico + `apply/dump`. *Por quê:* o snap grava
num caminho com número de revisão e `current` é symlink do snapd — Stow colidiria. Tema
`theme-system` pra seguir o claro/escuro do `theme-sync/`.
