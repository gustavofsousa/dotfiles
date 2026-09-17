#!/usr/bin/env bash
#
# export-theme.sh — copia o tema Zen (ZenMods) do perfil Flatpak ativo pra
# zen/theme/ deste repo. Rodar depois de mexer em mods/tema pela UI do Zen
# (Configurações > Mods), pra versionar a mudança.
#
# Não vendoriza sessão/histórico/senhas — só o CSS gerado pelos mods e a
# config de cada mod (preferences.json). O resto do perfil (7.6MB de
# sessionstore, sqlite de histórico/senhas) fica de fora de propósito: é
# estado vivo, não config, e o próprio Zen já sincroniza isso via login
# (Firefox Sync/Zen Account) — ver STATE.md pra decisão completa.
#
# Uso:
#   ./export-theme.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

ZEN_ROOT="$HOME/.var/app/app.zen_browser.zen/.zen"
INSTALLS_INI="$ZEN_ROOT/installs.ini"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

if [ ! -f "$INSTALLS_INI" ]; then
	echo "Não achei $INSTALLS_INI — Zen (Flatpak) está instalado?" >&2
	exit 1
fi

# Pega o profile ativo (chave "Default=" da seção [Install...]) do installs.ini.
PROFILE_DIR="$(awk -F= '/^Default=/{print $2; exit}' "$INSTALLS_INI")"
CHROME_DIR="$ZEN_ROOT/$PROFILE_DIR/chrome"

if [ ! -f "$CHROME_DIR/zen-themes.css" ]; then
	echo "Não achei $CHROME_DIR/zen-themes.css — perfil errado ou sem mods configurados?" >&2
	exit 1
fi

say "Perfil ativo: $PROFILE_DIR"
rm -rf theme
mkdir -p theme
cp "$CHROME_DIR/zen-themes.css" theme/
cp -r "$CHROME_DIR/zen-themes" theme/

say "Copiado pra zen/theme/. Revise o diff (git diff zen/) antes de commitar."
