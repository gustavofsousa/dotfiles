#!/usr/bin/env bash
#
# apply-config.sh — aplica as chaves de vlcrc.overrides no vlcrc real do VLC
# (snap). Só mexe nas linhas das chaves listadas em vlcrc.overrides — não
# sobrescreve o arquivo inteiro (ver comentário em vlcrc.overrides pra o porquê).
#
# WARNING: feche o VLC antes de rodar. Com o app aberto, ele reescreve o vlcrc
# ao fechar e descarta o que este script aplicou.
#
# Uso:
#   ./apply-config.sh
#
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }

TARGET="$HOME/snap/vlc/common/vlcrc"

if [ ! -f "$TARGET" ]; then
	warn "vlcrc não encontrado em $TARGET"
	warn "Abra o VLC 1x pra ele gerar o arquivo, ou instale: sudo snap install vlc"
	exit 1
fi

if pgrep -x vlc >/dev/null 2>&1; then
	warn "VLC está aberto — ele sobrescreve o vlcrc ao fechar."
	warn "Feche o app e rode de novo."
	exit 1
fi

cp "$TARGET" "$TARGET.bak"
say "Backup em $TARGET.bak"

while IFS='=' read -r key value; do
	[ -z "$key" ] && continue
	case "$key" in \#*) continue ;; esac
	if grep -qE "^#?${key}=" "$TARGET"; then
		sed -i -E "s/^#?${key}=.*/${key}=${value}/" "$TARGET"
		say "Aplicado: ${key}=${value}"
	else
		warn "Chave '${key}' não encontrada no vlcrc — pulando (versão do VLC pode ter mudado a chave)."
	fi
done < vlcrc.overrides
