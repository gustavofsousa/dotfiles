#!/usr/bin/env bash
#
# install-icons-tokyonight.sh — instala o tema de ícones Fluent (variante
# purple, light + dark) pra combinar com o tema GTK/Shell Tokyo Night, e
# aplica o modo atual (claro ou escuro conforme color-scheme).
#
# Irmão de install-icons.sh (Fluent orange/dark, decisão de 2026-09-15 pro
# combo Monokai/Dolphin) — aquele script continua intacto como registro de
# como a variante orange foi montada, caso o Gustavo volte pra ela depois.
#
# Não vendoriza o tema: clona o repo upstream num diretório temporário a
# cada execução, gera em ~/.local/share/icons/ e descarta o clone.
# Idempotente.
#
# Decisão registrada em STATE.md (2026-09-16): base visual passou a ser
# Tokyo Night; ícone acompanha com Fluent-purple (light/dark).
#
# Uso:
#   ./install-icons-tokyonight.sh
#
set -euo pipefail

UPSTREAM="https://github.com/vinceliuice/Fluent-icon-theme.git"
DEST="$HOME/.local/share/icons"
THEME_BASE="Fluent-purple"
BUILD_NAME="FluentPreview"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Clonando Fluent-icon-theme (upstream: $UPSTREAM)"
git clone --depth 1 "$UPSTREAM" "$TMP_DIR/Fluent-icon-theme" >/dev/null

cd "$TMP_DIR/Fluent-icon-theme"

say "Gerando variante purple (cria ${BUILD_NAME}-purple{,-light,-dark})"
./install.sh -n "$BUILD_NAME" -d "$DEST" purple >/dev/null

for MODE in light dark; do
	say "Promovendo ${BUILD_NAME}-purple-$MODE -> ${THEME_BASE}-${MODE}"
	rm -rf "${DEST:?}/${THEME_BASE}-${MODE}"
	mv "$DEST/${BUILD_NAME}-purple-$MODE" "$DEST/${THEME_BASE}-${MODE}"
	sed -i "s/${BUILD_NAME}-purple-$MODE/${THEME_BASE}-${MODE}/g; s/^Name=.*/Name=${THEME_BASE}-${MODE}/" \
		"$DEST/${THEME_BASE}-${MODE}/index.theme"
done
# ${BUILD_NAME}-purple (base, sem sufixo) FICA: o symlink scalable/ de cada
# variante -light/-dark aponta pra ela (mesma dependência real documentada
# em install-icons.sh pra variante orange).

say "Gerando variante grey só para extrair o ícone de pasta cinza"
./install.sh -n "$BUILD_NAME" -d "$DEST" grey >/dev/null
for MODE in light dark; do
	cp "$DEST/${BUILD_NAME}-grey-$MODE/scalable/places/default-folder.svg" \
		"$DEST/${THEME_BASE}-${MODE}/scalable/places/folder-grey.svg"
	cp "$DEST/${BUILD_NAME}-grey-$MODE/scalable/places/default-folder-open.svg" \
		"$DEST/${THEME_BASE}-${MODE}/scalable/places/folder-grey-open.svg" 2>/dev/null || true
done
rm -rf "$DEST/${BUILD_NAME}-grey" "$DEST/${BUILD_NAME}-grey-light" "$DEST/${BUILD_NAME}-grey-dark"

say "Checando symlinks pendentes"
for MODE in light dark; do
	if find "$DEST/${THEME_BASE}-${MODE}" -xtype l | grep -q .; then
		echo "AVISO: link quebrado em ${THEME_BASE}-${MODE}." >&2
		find "$DEST/${THEME_BASE}-${MODE}" -xtype l >&2
		exit 1
	fi
done

say "Aplicando conforme o color-scheme atual"
rm -f "$HOME/.cache/icon-cache.kcache"
CURRENT_SCHEME="$(gsettings get org.gnome.desktop.interface color-scheme)"
if [[ "$CURRENT_SCHEME" == "'prefer-dark'" ]]; then
	VARIANT="dark"
else
	VARIANT="light"
fi

if command -v kwriteconfig5 >/dev/null 2>&1; then
	kwriteconfig5 --file kdeglobals --group Icons --key Theme "${THEME_BASE}-${VARIANT}"
fi
gsettings set org.gnome.desktop.interface icon-theme "${THEME_BASE}-${VARIANT}"

say "Marcando pastas ocultas de primeiro nível em cinza"
"$(dirname "${BASH_SOURCE[0]}")/tag-hidden-folders.sh"

say "Pronto. ${THEME_BASE}-${VARIANT} aplicado. Reabra os apps (ex: Nautilus) pra ver."
