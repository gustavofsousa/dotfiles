#!/usr/bin/env bash
#
# apply-wallpaper.sh — aplica o wallpaper Tokyo Night (variante "gnome",
# design minimalista oficial do tema) como claro/escuro nativo do GNOME.
#
# Diferente de gtk-theme/ e icons/, os SVGs aqui são **vendorizados**
# (backgrounds/, 6KB cada, estáticos, MIT) em vez de clonados em build-time —
# são só 2 arquivos de imagem, não um tema inteiro pra rebuildar. Ver
# LICENSE-upstream.txt. wallpaper/ não é pacote Stow (mesmo padrão de
# icons/ e gtk-theme/) — este script copia os arquivos pro destino.
#
# Upstream: https://github.com/tokyo-night/wallpapers (MIT), pastas
# night/minimal e light/minimal, design "gnome".
#
# GNOME troca sozinho entre picture-uri e picture-uri-dark conforme
# org.gnome.desktop.interface color-scheme — não precisa do watcher do
# theme-sync/ pra isso, é nativo.
#
# Uso:
#   ./apply-wallpaper.sh
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="$HOME/.local/share/backgrounds"
mkdir -p "$DEST_DIR"

cp "$REPO_DIR/backgrounds/tokyo-night-light.svg" "$DEST_DIR/tokyo-night-light.svg"
cp "$REPO_DIR/backgrounds/tokyo-night-night.svg" "$DEST_DIR/tokyo-night-night.svg"

gsettings set org.gnome.desktop.background picture-uri "file://$DEST_DIR/tokyo-night-light.svg"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$DEST_DIR/tokyo-night-night.svg"
gsettings set org.gnome.desktop.background picture-options "zoom"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$DEST_DIR/tokyo-night-night.svg" 2>/dev/null || true

echo "Wallpaper Tokyo Night aplicado (claro/escuro nativo do GNOME)."
