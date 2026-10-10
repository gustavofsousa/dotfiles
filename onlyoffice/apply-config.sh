#!/usr/bin/env bash
#
# apply-config.sh — aplica o DesktopEditors.conf versionado neste diretório na
# instalação snap do OnlyOffice.
#
# Por que copiar em vez de symlink (Stow): o snap grava a config em
# ~/snap/onlyoffice-desktopeditors/<rev>/.config/onlyoffice/, onde <rev> muda a
# cada atualização e `current` é um symlink gerenciado pelo snapd. Fazer Stow
# apontar pra dentro de `current` colide com o symlink do snapd. Mesmo padrão
# do gnome-shell/restore-dconf.sh: versiona o conteúdo, aplica por script.
#
# WARNING: feche o OnlyOffice antes de rodar. Com o app aberto, ele reescreve o
# DesktopEditors.conf ao fechar e descarta o que este script aplicou.
#
# Uso:
#   ./apply-config.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }

SRC="DesktopEditors.conf"
TARGET_DIR="$HOME/snap/onlyoffice-desktopeditors/current/.config/onlyoffice"
TARGET="$TARGET_DIR/DesktopEditors.conf"

if [ ! -e "$HOME/snap/onlyoffice-desktopeditors/current" ]; then
	warn "OnlyOffice snap não encontrado em ~/snap/. Instale e abra 1x antes:"
	warn "  sudo snap install onlyoffice-desktopeditors"
	exit 1
fi

if pgrep -x DesktopEditors >/dev/null 2>&1; then
	warn "OnlyOffice está aberto — ele sobrescreve a config ao fechar."
	warn "Feche o app e rode de novo."
	exit 1
fi

mkdir -p "$TARGET_DIR"

if [ -f "$TARGET" ]; then
	cp "$TARGET" "$TARGET.bak"
	say "Backup do atual em $TARGET.bak"
fi

cp "$SRC" "$TARGET"
say "Aplicado: $SRC -> $TARGET"
