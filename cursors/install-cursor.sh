#!/usr/bin/env bash
#
# install-cursor.sh — instala o cursor ativo (Qogir, formato "losango"/comprido)
# e aplica em KDE/Qt (kcminputrc) + GTK/GNOME (gsettings).
#
# Não vendoriza o tema (repo de terceiro): clona em diretório temporário a
# cada execução, gera em ~/.local/share/icons/ e descarta o clone.
# Idempotente — rodar de novo reconstrói do zero sem quebrar nada.
#
# Decisão + alternativas comparadas ao vivo registradas em STATE.md
# (2026-09-15): Qogir escolhido como principal; Nordzy-cursors e
# Bibata-Original-Classic ficaram como 2ª/3ª opção (não instaladas por
# padrão — ver seção "Alternativas" no fim deste arquivo pra reinstalar).
#
# Uso:
#   ./install-cursor.sh
#
set -euo pipefail

UPSTREAM="https://github.com/vinceliuice/Qogir-icon-theme.git"
DEST="$HOME/.local/share/icons"
THEME_NAME="Qogir-cursors"
BUILD_NAME="QogirPreview"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Clonando Qogir-icon-theme (upstream: $UPSTREAM) — só usamos o cursor, não os ícones"
git clone --depth 1 "$UPSTREAM" "$TMP_DIR/Qogir-icon-theme" >/dev/null

cd "$TMP_DIR/Qogir-icon-theme"

say "Gerando variante standard/default (inclui cursors/)"
./install.sh -n "$BUILD_NAME" -d "$DEST" -t default -c standard >/dev/null

say "Promovendo $BUILD_NAME -> $THEME_NAME"
rm -rf "${DEST:?}/$THEME_NAME"
mv "$DEST/$BUILD_NAME" "$DEST/$THEME_NAME"
sed -i "s/^Name=.*/Name=$THEME_NAME/" "$DEST/$THEME_NAME/index.theme"

say "Aplicando o cursor (KDE/Qt via kcminputrc + GTK/GNOME via gsettings)"
rm -f "$HOME/.cache/icon-cache.kcache"
if command -v kwriteconfig5 >/dev/null 2>&1; then
	kwriteconfig5 --file kcminputrc --group Mouse --key cursorTheme "$THEME_NAME"
else
	echo "AVISO: kwriteconfig5 não encontrado — defina manualmente [Mouse] cursorTheme=$THEME_NAME em ~/.config/kcminputrc" >&2
fi
if command -v gsettings >/dev/null 2>&1; then
	gsettings set org.gnome.desktop.interface cursor-theme "$THEME_NAME"
fi

say "Pronto. Mova o mouse pra ver o cursor aplicado."

# --- Alternativas comparadas ao vivo (não instaladas por padrão) -----------
#
# 2ª opção — Nordzy-cursors:
#   git clone --depth 1 https://github.com/alvatip/Nordzy-cursors.git
#   cd Nordzy-cursors && ./install.sh
#   # instala várias variantes; a ativa seria "Nordzy-cursors" (a base, sem
#   # sufixo catppuccin/lefthand/white)
#   gsettings set org.gnome.desktop.interface cursor-theme "Nordzy-cursors"
#   kwriteconfig5 --file kcminputrc --group Mouse --key cursorTheme "Nordzy-cursors"
#
# 3ª opção — Bibata-Original-Classic:
#   curl -sL -o Bibata-Original-Classic.tar.xz \
#     https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Original-Classic.tar.xz
#   tar -xf Bibata-Original-Classic.tar.xz -C ~/.local/share/icons
#   gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Original-Classic"
#   kwriteconfig5 --file kcminputrc --group Mouse --key cursorTheme "Bibata-Original-Classic"
#
# Outras variantes do Bibata (previews): https://www.bibata.live
