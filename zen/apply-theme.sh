#!/usr/bin/env bash
#
# apply-theme.sh — aplica o tema versionado em zen/theme/ no perfil Flatpak
# ativo do Zen (máquina nova ou depois de reinstalar o Zen).
#
# Zen precisa ter rodado ao menos uma vez antes (pra existir profiles.ini e
# a pasta chrome/ do perfil). Depois de aplicar, reabrir o Zen.
#
# Uso:
#   ./apply-theme.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

ZEN_ROOT="$HOME/.var/app/app.zen_browser.zen/.zen"
INSTALLS_INI="$ZEN_ROOT/installs.ini"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

if [ ! -f "$INSTALLS_INI" ]; then
	echo "Não achei $INSTALLS_INI — abra o Zen ao menos uma vez antes de rodar isto." >&2
	exit 1
fi

if [ ! -f theme/zen-themes.css ]; then
	echo "zen/theme/zen-themes.css não existe — rode export-theme.sh numa máquina que já tem o tema, primeiro." >&2
	exit 1
fi

PROFILE_DIR="$(awk -F= '/^Default=/{print $2; exit}' "$INSTALLS_INI")"
CHROME_DIR="$ZEN_ROOT/$PROFILE_DIR/chrome"

say "Perfil ativo: $PROFILE_DIR"
mkdir -p "$CHROME_DIR"
cp theme/zen-themes.css "$CHROME_DIR/"
cp -r theme/zen-themes "$CHROME_DIR/"

say "Tema aplicado. Reabra o Zen pra ver o efeito."
