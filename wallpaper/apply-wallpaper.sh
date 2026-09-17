#!/usr/bin/env bash
#
# apply-wallpaper.sh — aplica o wallpaper com o símbolo do Tokyo Night (a
# Tokyo Tower, dá nome ao tema) como claro/escuro nativo do GNOME.
#
# Diferente de gtk-theme/ e icons/, as imagens aqui são **vendorizadas**
# (backgrounds/, ~420KB cada, PNG 4K estático) em vez de clonadas em
# build-time — são só 2 arquivos de imagem, não um tema inteiro pra
# rebuildar. wallpaper/ não é pacote Stow (mesmo padrão de icons/ e
# gtk-theme/) — este script copia os arquivos pro destino.
#
# Composto a partir de theme-icon.png do repo
# https://github.com/tokyo-night/wallpapers (MIT, ver LICENSE-upstream.txt)
# — o logo oficial do projeto (torre + "function" repetido nas cores da
# paleta), recortado, com a borda residual do badge original aparada
# (-shave) e reaplicado num canvas sólido nas cores de fundo do tema
# (#1a1b26 noite, #d5d6db dia). A variante clara tem a torre recolorida pro
# tom "fg" do Tokyo Night Day (#343b58) — o lavender original (#c0c9f5) não
# tinha contraste em fundo claro.
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

cp "$REPO_DIR/backgrounds/tokyo-night-symbol-light.png" "$DEST_DIR/tokyo-night-symbol-light.png"
cp "$REPO_DIR/backgrounds/tokyo-night-symbol-night.png" "$DEST_DIR/tokyo-night-symbol-night.png"

gsettings set org.gnome.desktop.background picture-uri "file://$DEST_DIR/tokyo-night-symbol-light.png"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$DEST_DIR/tokyo-night-symbol-night.png"
gsettings set org.gnome.desktop.background picture-options "zoom"
gsettings set org.gnome.desktop.screensaver picture-uri "file://$DEST_DIR/tokyo-night-symbol-night.png" 2>/dev/null || true

echo "Wallpaper Tokyo Night (símbolo) aplicado (claro/escuro nativo do GNOME)."
