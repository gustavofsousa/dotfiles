#!/usr/bin/env bash
#
# restore-dconf.sh — aplica os snapshots deste diretório no dconf da máquina
# atual (tema/aparência do GNOME Shell + extensões habilitadas).
#
# IMPORTANTE — isto só restaura *configuração* (dconf), não instala nada:
#   - Tema GTK/ícone/cursor: rode gtk-theme/install-gtk-theme.sh,
#     icons/install-icons-tokyonight.sh e cursors/install-cursor.sh antes (ou
#     depois, ordem não importa) pra esses temas existirem de fato no disco.
#   - Extensões do GNOME Shell: as instaladas via apt (ding, tiling-assistant,
#     ubuntu-appindicators, ubuntu-dock, user-theme — pacote
#     gnome-shell-extensions) precisam de
#     `sudo apt install gnome-shell-extensions` antes. As instaladas via
#     extensions.gnome.org (space-bar, Vitals, tactile,
#     rounded-window-corners, no-overview) precisam ser instaladas na mão
#     pelo navegador (extensions.gnome.org) ou `gnome-extensions install
#     <arquivo.zip>` — não têm pacote apt.
#   - `pop-shell@system76.com` aparece na lista de habilitadas mas não está
#     instalada nesta máquina (achado ao escrever este script, 2026-09-16) —
#     entrada solta, o GNOME Shell ignora UUID que não existe, sem erro.
#   - GNOME Shell no Wayland só recarrega extensão de sistema nova após
#     logout/login — normal não ver efeito completo antes disso.
#
# Uso:
#   ./restore-dconf.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

say "Carregando interface.ini -> /org/gnome/desktop/interface/"
dconf load /org/gnome/desktop/interface/ < interface.ini

say "Carregando shell.ini -> /org/gnome/shell/"
dconf load /org/gnome/shell/ < shell.ini

say "Carregando wm-preferences.ini -> /org/gnome/desktop/wm/preferences/"
dconf load /org/gnome/desktop/wm/preferences/ < wm-preferences.ini

say "Feito. Se alguma extensão não aparecer, confira se está instalada (ver comentário no topo deste script) e faça logout/login."
