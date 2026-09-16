#!/usr/bin/env bash
#
# install-icons.sh — instala o tema de ícones Fluent (variante orange/dark) e
# aplica a cor cinza nas pastas ocultas de primeiro nível da home.
#
# Não vendoriza o tema (SVGs de terceiros): clona o repo upstream num diretório
# temporário a cada execução, gera o tema em ~/.local/share/icons/ e descarta o
# clone. Idempotente — rodar de novo reconstrói do zero sem quebrar nada.
#
# Decisão registrada em STATE.md (2026-09-15): Fluent escolhido no lugar do
# Papirus-Dark depois de comparar Tela/Fluent/Zafiro ao vivo no Dolphin.
#
# Uso:
#   ./install-icons.sh
#
set -euo pipefail

UPSTREAM="https://github.com/vinceliuice/Fluent-icon-theme.git"
DEST="$HOME/.local/share/icons"
THEME_NAME="Fluent-orange-dark"
BUILD_NAME="FluentPreview"   # nome interno usado durante o build (ver nota abaixo)
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Clonando Fluent-icon-theme (upstream: $UPSTREAM)"
git clone --depth 1 "$UPSTREAM" "$TMP_DIR/Fluent-icon-theme" >/dev/null

cd "$TMP_DIR/Fluent-icon-theme"

say "Gerando variante orange (cria ${BUILD_NAME}-orange{,-light,-dark})"
./install.sh -n "$BUILD_NAME" -d "$DEST" orange >/dev/null

say "Promovendo ${BUILD_NAME}-orange-dark -> $THEME_NAME"
rm -rf "${DEST:?}/$THEME_NAME"
mv "$DEST/${BUILD_NAME}-orange-dark" "$DEST/$THEME_NAME"
sed -i "s/${BUILD_NAME}-orange-dark/$THEME_NAME/g; s/^Name=.*/Name=$THEME_NAME/" \
	"$DEST/$THEME_NAME/index.theme"
# A variante -light não é usada; ${BUILD_NAME}-orange (base, sem sufixo) FICA:
# o symlink scalable/ de $THEME_NAME aponta pra ela (ver nota de dependência).
rm -rf "$DEST/${BUILD_NAME}-orange-light"

say "Gerando variante grey só para extrair o ícone de pasta cinza"
./install.sh -n "$BUILD_NAME" -d "$DEST" grey >/dev/null
cp "$DEST/${BUILD_NAME}-grey/scalable/places/default-folder.svg" \
	"$DEST/$THEME_NAME/scalable/places/folder-grey.svg"
cp "$DEST/${BUILD_NAME}-grey/scalable/places/default-folder-open.svg" \
	"$DEST/$THEME_NAME/scalable/places/folder-grey-open.svg" 2>/dev/null || true
rm -rf "$DEST/${BUILD_NAME}-grey" "$DEST/${BUILD_NAME}-grey-light" "$DEST/${BUILD_NAME}-grey-dark"

say "Checando symlinks pendentes dentro de $THEME_NAME"
if find "$DEST/$THEME_NAME" -xtype l | grep -q .; then
	echo "AVISO: link quebrado encontrado — não apague ${BUILD_NAME}-orange/ (dependência real do tema)." >&2
	find "$DEST/$THEME_NAME" -xtype l >&2
	exit 1
fi

say "Aplicando o tema (KDE/Qt via kdeglobals + GTK/GNOME via gsettings)"
rm -f "$HOME/.cache/icon-cache.kcache"
if command -v kwriteconfig5 >/dev/null 2>&1; then
	kwriteconfig5 --file kdeglobals --group Icons --key Theme "$THEME_NAME"
else
	echo "AVISO: kwriteconfig5 não encontrado — defina manualmente [Icons] Theme=$THEME_NAME em ~/.config/kdeglobals" >&2
fi
if command -v gsettings >/dev/null 2>&1; then
	gsettings set org.gnome.desktop.interface icon-theme "$THEME_NAME"
fi

say "Marcando pastas ocultas de primeiro nível em cinza"
"$(dirname "${BASH_SOURCE[0]}")/tag-hidden-folders.sh"

say "Pronto. Reabra os apps (ex: Dolphin) para ver o tema aplicado."
