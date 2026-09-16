#!/usr/bin/env bash
#
# install-gtk-theme.sh — instala o tema GTK/Shell Tokyo Night (variante
# blue/padrão, claro e escuro) e aplica o modo atual (claro ou escuro
# conforme org.gnome.desktop.interface color-scheme).
#
# Não vendoriza o tema (SVG/SCSS de terceiros): clona o repo upstream num
# diretório temporário a cada execução, gera o tema em ~/.themes e
# ~/.config/gtk-4.0, e descarta o clone. Idempotente.
#
# Decisão registrada em STATE.md (2026-09-16): saiu do Adwaita, tema base
# passou a ser Tokyo Night (GTK3 + GTK4/libadwaita + GNOME Shell/top bar).
# Troca claro/escuro é manual, sincronizada pelo watcher em theme-sync/.
#
# Requer: sassc, gnome-themes-extra, gtk2-engines-murrine (deps do tema)
# e a extensão GNOME Shell "User Themes" habilitada (pacote
# gnome-shell-extensions) para o tema valer na top bar.
#
# Uso:
#   ./install-gtk-theme.sh
#
set -euo pipefail

UPSTREAM="https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme.git"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Clonando Tokyonight-GTK-Theme (upstream: $UPSTREAM)"
git clone --depth 1 "$UPSTREAM" "$TMP_DIR/repo" >/dev/null

say "Gerando Tokyonight-Light e Tokyonight-Dark em ~/.themes (variante blue/padrão)"
bash "$TMP_DIR/repo/themes/install.sh" -l >/dev/null

say "Aplicando conforme o color-scheme atual"
CURRENT_SCHEME="$(gsettings get org.gnome.desktop.interface color-scheme)"
if [[ "$CURRENT_SCHEME" == "'prefer-dark'" ]]; then
	VARIANT="Dark"
else
	VARIANT="Light"
fi

gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-$VARIANT"
if gsettings list-schemas | grep -q org.gnome.shell.extensions.user-theme; then
	gsettings set org.gnome.shell.extensions.user-theme name "Tokyonight-$VARIANT"
else
	echo "AVISO: schema org.gnome.shell.extensions.user-theme não encontrado — habilite a extensão 'User Themes' (gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com) e rode de novo pra aplicar na top bar." >&2
fi

say "Pronto. Tokyonight-$VARIANT aplicado. Reabra os apps GTK pra ver o tema completo."
