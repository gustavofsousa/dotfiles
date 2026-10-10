#!/usr/bin/env bash
#
# dump-config.sh — regenera o DesktopEditors.conf deste diretório a partir da
# config atual do snap. Rode depois de personalizar o OnlyOffice pela GUI, pra
# versionar a mudança (inverso do apply-config.sh).
#
# Remove a linha `position=` de propósito: é a posição da janela em pixels,
# presa à resolução desta tela — não deve ir pro repo nem pra uma máquina nova.
# O `maximized=true` já cobre o caso portável.
#
# Uso:
#   ./dump-config.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }

SRC="$HOME/snap/onlyoffice-desktopeditors/current/.config/onlyoffice/DesktopEditors.conf"

if [ ! -f "$SRC" ]; then
	warn "Config do OnlyOffice não encontrada em $SRC"
	warn "Abra o OnlyOffice 1x pra ele gerar o arquivo."
	exit 1
fi

grep -v '^position=' "$SRC" > DesktopEditors.conf
say "Capturado (sem a linha position=): $SRC -> DesktopEditors.conf"
say "Revise o diff (git diff onlyoffice/) antes de commitar."
