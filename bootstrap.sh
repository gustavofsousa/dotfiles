#!/usr/bin/env bash
#
# bootstrap.sh — prepara uma máquina nova a partir deste repo de dotfiles.
#
# Faz, em ordem:
#   1. Checa dependências (stow, git) e avisa o que falta.
#   2. Inicializa os submodules do tmux (tpm, tmux-resurrect, tmux-sensible).
#   3. Cria os symlinks dos pacotes Stow em $HOME.
#   4. (Opcional) instala as fontes via fonts/install-fonts.sh.
#
# Idempotente: rodar de novo não quebra nada. Por segurança, o padrão é
# DRY-RUN (só mostra o que faria). Use --apply para executar de verdade.
#
# Uso:
#   ./bootstrap.sh            # dry-run: mostra o que faria, não muda nada
#   ./bootstrap.sh --apply    # executa: cria symlinks e inicializa submodules
#   ./bootstrap.sh --apply --with-fonts   # também instala as fontes
#
set -euo pipefail

# --- localização do repo (funciona de qualquer cwd) ------------------------
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

# Pacotes Stow ativos (uma pasta por ferramenta; espelham o caminho a partir
# de $HOME). attic/, fonts/, zen/, docs/, specs/ NÃO são pacotes Stow.
STOW_PACKAGES=(alacritty home nvim tmux)

# --- flags ------------------------------------------------------------------
APPLY=false
WITH_FONTS=false
for arg in "$@"; do
	case "$arg" in
		--apply) APPLY=true ;;
		--with-fonts) WITH_FONTS=true ;;
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

# --- fim --------------------------------------------------------------------
if $APPLY; then
	say "Pronto. Symlinks criados. Abra um tmux novo e rode prefix + I para instalar plugins (TPM)."
else
	say "Dry-run concluído. Reveja acima e rode com --apply quando estiver ok."
fi
