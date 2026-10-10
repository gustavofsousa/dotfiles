#!/usr/bin/env bash
#
# dump-config.sh — recaptura o valor atual de cada chave listada em
# vlcrc.overrides a partir do vlcrc real, pra versionar mudança feita pela GUI
# (Preferências do VLC). Inverso do apply-config.sh. Só toca nas chaves já
# listadas — não adiciona chave nova sozinho (edite vlcrc.overrides à mão pra
# isso).
#
# Uso:
#   ./dump-config.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }

SRC="$HOME/snap/vlc/common/vlcrc"

if [ ! -f "$SRC" ]; then
	warn "vlcrc não encontrado em $SRC"
	exit 1
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

while IFS='=' read -r key _; do
	[ -z "$key" ] && continue
	case "$key" in \#*) echo "$key" >>"$TMP"; continue ;; esac
	current="$(grep -E "^${key}=" "$SRC" | tail -1)"
	if [ -n "$current" ]; then
		echo "$current" >>"$TMP"
		say "Capturado: $current"
	else
		warn "Chave '${key}' não setada no vlcrc atual (ainda no default) — mantendo valor anterior em vlcrc.overrides."
		grep -E "^${key}=" vlcrc.overrides >>"$TMP"
	fi
done < vlcrc.overrides

mv "$TMP" vlcrc.overrides
trap - EXIT
say "vlcrc.overrides atualizado. Revise o diff (git diff vlc/) antes de commitar."
