#!/usr/bin/env bash
#
# theme-sync-watcher.sh — mantém GTK theme, ícone Fluent-purple e tema do
# GNOME Shell (top bar) sincronizados com o toggle nativo claro/escuro
# (Configurações > Aparência), já que esse toggle só controla
# org.gnome.desktop.interface color-scheme e não troca gtk-theme/icon-theme
# sozinho para temas fora do Yaru.
#
# Decisão registrada em STATE.md (2026-09-16): troca claro/escuro é manual
# (toggle nativo do GNOME), esse watcher é o que faz o resto do visual
# (Tokyo Night GTK/Shell + Fluent-purple) acompanhar essa escolha.
#
# Rodado como serviço --user (ver theme-sync.service). Idempotente: pode
# rodar `apply_variant` a qualquer momento sem efeito colateral.
#
set -euo pipefail

apply_variant() {
	local scheme
	scheme="$(gsettings get org.gnome.desktop.interface color-scheme)"
	local variant_title variant_lower
	if [[ "$scheme" == "'prefer-dark'" ]]; then
		variant_title="Dark"
		variant_lower="dark"
	else
		variant_title="Light"
		variant_lower="light"
	fi

	gsettings set org.gnome.desktop.interface gtk-theme "Tokyonight-${variant_title}"
	gsettings set org.gnome.desktop.interface icon-theme "Fluent-purple-${variant_lower}"
	if gsettings list-schemas | grep -q org.gnome.shell.extensions.user-theme; then
		gsettings set org.gnome.shell.extensions.user-theme name "Tokyonight-${variant_title}"
	fi
	if command -v kwriteconfig5 >/dev/null 2>&1; then
		kwriteconfig5 --file kdeglobals --group Icons --key Theme "Fluent-purple-${variant_lower}"
	fi
}

# Aplica o estado atual assim que o watcher sobe (cobre o caso de o toggle
# ter mudado enquanto o serviço estava parado).
apply_variant

gsettings monitor org.gnome.desktop.interface color-scheme | while read -r _; do
	apply_variant
done
