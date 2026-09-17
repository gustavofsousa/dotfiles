#!/usr/bin/env bash
#
# install-fonts.sh — instala JetBrainsMono Nerd Font (+ Symbols Nerd Font,
# usado como fallback de ícones em apps que não usam Nerd Font nativo).
#
# Não vendoriza as fontes (binário de terceiros, ~230MB): baixa os releases
# oficiais do ryanoasis/nerd-fonts num diretório temporário a cada execução e
# descarta o download. Mesmo padrão do icons/install-icons.sh. Idempotente.
#
# Uso:
#   ./install-fonts.sh
#
set -euo pipefail

NERD_FONTS_VERSION="v3.5.1"
JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/JetBrainsMono.zip"
SYMBOLS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/NerdFontsSymbolsOnly.zip"

USER_FONT_DIR="$HOME/.local/share/fonts"
SYSTEM_FONT_DIR="/usr/share/fonts"

if [ "$(id -u)" -eq 0 ]; then
	FONT_DEST="$SYSTEM_FONT_DIR"
else
	FONT_DEST="$USER_FONT_DIR"
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Baixando JetBrainsMono Nerd Font (${NERD_FONTS_VERSION})"
curl -sL "$JETBRAINS_URL" -o "$TMP_DIR/JetBrainsMono.zip"
mkdir -p "$FONT_DEST/JetBrainsMono"
unzip -oq "$TMP_DIR/JetBrainsMono.zip" -d "$FONT_DEST/JetBrainsMono" '*.ttf'

say "Baixando Symbols Nerd Font (fallback de ícones, ${NERD_FONTS_VERSION})"
curl -sL "$SYMBOLS_URL" -o "$TMP_DIR/NerdFontsSymbolsOnly.zip"
mkdir -p "$FONT_DEST/JetBrainsMonoSymbols"
unzip -oq "$TMP_DIR/NerdFontsSymbolsOnly.zip" -d "$FONT_DEST/JetBrainsMonoSymbols" '*.ttf'

say "Atualizando cache de fontes"
fc-cache -f "$FONT_DEST" >/dev/null

say "Instalado em $FONT_DEST"
