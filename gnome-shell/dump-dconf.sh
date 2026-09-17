#!/usr/bin/env bash
#
# dump-dconf.sh — regenera os snapshots deste diretório a partir do dconf
# atual da máquina. Rodar depois de mexer em tema/extensões do GNOME Shell
# pela GUI, pra versionar a mudança.
#
# Escopo deliberadamente estreito (não é "dconf dump /org/gnome/" inteiro):
# só as chaves de tema/aparência e a lista de extensões habilitadas +
# configuração de cada uma. Atalhos de teclado (org.gnome.desktop.wm.keybindings
# etc.) ficam de fora — são item separado no ROADMAP.
#
# Uso:
#   ./dump-dconf.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Dumping /org/gnome/desktop/interface/ -> interface.ini"
dconf dump /org/gnome/desktop/interface/ > interface.ini

say "Dumping /org/gnome/shell/ -> shell.ini (extensões habilitadas + config de cada uma)"
dconf dump /org/gnome/shell/ > shell.ini

say "Dumping /org/gnome/desktop/wm/preferences/ -> wm-preferences.ini"
dconf dump /org/gnome/desktop/wm/preferences/ > wm-preferences.ini

say "Feito. Revise o diff (git diff gnome-shell/) antes de commitar."
