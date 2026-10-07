#!/usr/bin/env bash
#
# bootstrap.sh — prepara uma máquina nova a partir deste repo de dotfiles.
#
# Faz, em ordem:
#   1. Checa dependências (stow, git — obrigatórias) e as recomendadas de
#      manutenção do acervo (smartmontools, exiftool, rsync, ffmpeg — avisa e segue).
#   2. Inicializa os submodules do tmux (tpm, tmux-resurrect, tmux-sensible).
#   3. Cria os symlinks dos pacotes Stow em $HOME.
#   4. (Opcional) instala as fontes via fonts/install-fonts.sh.
#   5. (Opcional) instala o tema de ícones via icons/install-icons.sh.
#   6. (Opcional) instala o cursor via cursors/install-cursor.sh.
#   7. (Opcional) restaura tema/extensões do GNOME Shell via gnome-shell/restore-dconf.sh.
#   8. (Opcional) aplica o tema do Zen (ZenMods) via zen/apply-theme.sh.
#   9. (Opcional) aplica o wallpaper Tokyo Night via wallpaper/apply-wallpaper.sh.
#
# Idempotente: rodar de novo não quebra nada. Por segurança, o padrão é
# DRY-RUN (só mostra o que faria). Use --apply para executar de verdade.
#
# Uso:
#   ./bootstrap.sh            # dry-run: mostra o que faria, não muda nada
#   ./bootstrap.sh --apply    # executa: cria symlinks e inicializa submodules
#   ./bootstrap.sh --apply --with-fonts   # também instala as fontes
#   ./bootstrap.sh --apply --with-icons   # também instala o tema de ícones
#   ./bootstrap.sh --apply --with-cursor  # também instala o cursor
#   ./bootstrap.sh --apply --with-gnome-shell-theme  # restaura tema/extensões do GNOME Shell (dconf)
#   ./bootstrap.sh --apply --with-zen-theme  # aplica o tema do Zen (precisa o Zen já ter rodado 1x)
#   ./bootstrap.sh --apply --with-wallpaper  # aplica o wallpaper Tokyo Night (claro/escuro nativo)
#
# Pré-requisito de sistema pro pacote `environment/` fazer efeito em apps
# Qt/KDE (ex: Dolphin) rodando sob GNOME: `sudo apt install plasma-integration`
# (fora do escopo deste script — precisa de senha interativa).
#
set -euo pipefail

# --- localização do repo (funciona de qualquer cwd) ------------------------
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

# Pacotes Stow ativos (uma pasta por ferramenta; espelham o caminho a partir
# de $HOME). attic/, fonts/, icons/, cursors/, gtk-theme/, gnome-shell/, zen/,
# wallpaper/, docs/, specs/ NÃO são pacotes Stow.
STOW_PACKAGES=(alacritty environment home nvim theme-sync tmux vscode)

# --- flags ------------------------------------------------------------------
APPLY=false
WITH_FONTS=false
WITH_ICONS=false
WITH_CURSOR=false
WITH_GNOME_SHELL_THEME=false
WITH_ZEN_THEME=false
WITH_WALLPAPER=false
for arg in "$@"; do
	case "$arg" in
		--apply) APPLY=true ;;
		--with-fonts) WITH_FONTS=true ;;
		--with-icons) WITH_ICONS=true ;;
		--with-cursor) WITH_CURSOR=true ;;
		--with-gnome-shell-theme) WITH_GNOME_SHELL_THEME=true ;;
		--with-zen-theme) WITH_ZEN_THEME=true ;;
		--with-wallpaper) WITH_WALLPAPER=true ;;
		-h|--help)
			# Imprime só o bloco de comentário do topo (pula o shebang, para na
			# primeira linha que não é comentário).
			sed -n '2,/^[^#]/{/^#/s/^# \{0,1\}//p}' "$0"
			exit 0
			;;
		*)
			echo "Argumento desconhecido: $arg (use --help)" >&2
			exit 2
			;;
	esac
done

# --- helpers ----------------------------------------------------------------
say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }
run()  {
	if $APPLY; then
		"$@"
	else
		printf '   [dry-run] %s\n' "$*"
	fi
}

if ! $APPLY; then
	say "DRY-RUN — nada será alterado. Rode com --apply para executar de verdade."
fi

# --- 1. dependências --------------------------------------------------------
say "Checando dependências"
missing=()
command -v git  >/dev/null 2>&1 || missing+=(git)
command -v stow >/dev/null 2>&1 || missing+=(stow)
if [ ${#missing[@]} -gt 0 ]; then
	warn "Faltando: ${missing[*]}"
	warn "Instale antes de continuar. Ex (Debian/Ubuntu): sudo apt install -y ${missing[*]}"
	exit 1
fi
echo "   git e stow presentes ✓"

# Ferramentas de manutenção do acervo: úteis, não obrigatórias pro bootstrap —
# avisa e segue (ver docs/organizacao-de-arquivos.md e _hq/infra/acervo-digital.md).
recommended=()
command -v smartctl  >/dev/null 2>&1 || recommended+=(smartmontools)   # saúde de disco (SMART)
command -v exiftool  >/dev/null 2>&1 || recommended+=(libimage-exiftool-perl)
command -v rsync     >/dev/null 2>&1 || recommended+=(rsync)
command -v ffmpeg    >/dev/null 2>&1 || recommended+=(ffmpeg)
if [ ${#recommended[@]} -gt 0 ]; then
	warn "Recomendadas ausentes: ${recommended[*]}"
	warn "  sudo apt install -y ${recommended[*]}"
else
	echo "   ferramentas de acervo (smartctl, exiftool, rsync, ffmpeg) presentes ✓"
fi

# --- 2. submodules do tmux --------------------------------------------------
say "Inicializando submodules (plugins do tmux)"
if [ -f .gitmodules ]; then
	run git submodule update --init --recursive
else
	warn ".gitmodules ausente — pulando (nenhum submodule declarado)."
fi

# --- 3. symlinks via Stow ---------------------------------------------------
say "Criando symlinks dos pacotes: ${STOW_PACKAGES[*]}"
# --restow refaz links existentes sem erro; --target garante o destino $HOME.
# Primeiro uma simulação para detectar conflitos (arquivo real no caminho).
if ! stow --no --verbose --target="$HOME" --restow "${STOW_PACKAGES[@]}" 2>/tmp/stow-check.log; then
	warn "Stow detectou conflitos (provável arquivo real onde iria o symlink):"
	cat /tmp/stow-check.log >&2
	warn "Resolva os conflitos (mova/renomeie os arquivos reais) e rode de novo."
	exit 1
fi
run stow --verbose --target="$HOME" --restow "${STOW_PACKAGES[@]}"

# --- 4. fontes (opcional) ---------------------------------------------------
if $WITH_FONTS; then
	say "Instalando fontes (fonts/install-fonts.sh)"
	if [ -x fonts/install-fonts.sh ]; then
		run ./fonts/install-fonts.sh
	else
		warn "fonts/install-fonts.sh não encontrado ou sem permissão de execução."
	fi
else
	say "Fontes: puladas (use --with-fonts para instalar)"
fi

# --- 5. ícones (opcional) ----------------------------------------------------
if $WITH_ICONS; then
	say "Instalando tema de ícones (icons/install-icons.sh)"
	if [ -x icons/install-icons.sh ]; then
		run ./icons/install-icons.sh
	else
		warn "icons/install-icons.sh não encontrado ou sem permissão de execução."
	fi
else
	say "Ícones: pulados (use --with-icons para instalar)"
fi

# --- 6. cursor (opcional) ----------------------------------------------------
if $WITH_CURSOR; then
	say "Instalando cursor (cursors/install-cursor.sh)"
	if [ -x cursors/install-cursor.sh ]; then
		run ./cursors/install-cursor.sh
	else
		warn "cursors/install-cursor.sh não encontrado ou sem permissão de execução."
	fi
else
	say "Cursor: pulado (use --with-cursor para instalar)"
fi

# --- 7. tema/extensões do GNOME Shell via dconf (opcional) ------------------
if $WITH_GNOME_SHELL_THEME; then
	say "Restaurando tema/extensões do GNOME Shell (gnome-shell/restore-dconf.sh)"
	if [ -x gnome-shell/restore-dconf.sh ]; then
		run ./gnome-shell/restore-dconf.sh
	else
		warn "gnome-shell/restore-dconf.sh não encontrado ou sem permissão de execução."
	fi
else
	say "Tema do GNOME Shell (dconf): pulado (use --with-gnome-shell-theme para restaurar)"
fi

# --- 8. tema do Zen (opcional) -----------------------------------------------
if $WITH_ZEN_THEME; then
	say "Aplicando tema do Zen (zen/apply-theme.sh)"
	if [ -x zen/apply-theme.sh ]; then
		run ./zen/apply-theme.sh
	else
		warn "zen/apply-theme.sh não encontrado ou sem permissão de execução."
	fi
else
	say "Tema do Zen: pulado (use --with-zen-theme para aplicar)"
fi

# --- 9. wallpaper Tokyo Night (opcional) -------------------------------------
if $WITH_WALLPAPER; then
	say "Aplicando wallpaper Tokyo Night (wallpaper/apply-wallpaper.sh)"
	if [ -x wallpaper/apply-wallpaper.sh ]; then
		run ./wallpaper/apply-wallpaper.sh
	else
		warn "wallpaper/apply-wallpaper.sh não encontrado ou sem permissão de execução."
	fi
else
	say "Wallpaper: pulado (use --with-wallpaper para aplicar)"
fi

# --- fim --------------------------------------------------------------------
if $APPLY; then
	say "Pronto. Symlinks criados. Abra um tmux novo e rode prefix + I para instalar plugins (TPM)."
else
	say "Dry-run concluído. Reveja acima e rode com --apply quando estiver ok."
fi
