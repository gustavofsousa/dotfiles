#!/usr/bin/env bash
#
# tag-hidden-folders.sh — marca as pastas ocultas de primeiro nível em ~/ com
# o ícone folder-grey (precisa existir no tema ativo — ver install-icons.sh),
# pulando as que guardam credenciais/chaves.
#
# Idempotente: só (re)escreve o .directory, seguro rodar de novo quando uma
# ferramenta nova criar uma pasta oculta.
#
# Decisão registrada em STATE.md (2026-09-15).
#
set -euo pipefail

# Pastas de credenciais/chaves — nunca marcadas (não é sobre esconder, é sobre
# não escrever arquivo nenhum dentro delas por padrão).
SKIP=(.ssh .gnupg .pki)

should_skip() {
	local name="$1"
	for s in "${SKIP[@]}"; do
		[ "$name" = "$s" ] && return 0
	done
	return 1
}

for d in "$HOME"/.*/; do
	name="$(basename "$d")"
	[ "$name" = "." ] && continue
	[ "$name" = ".." ] && continue
	if should_skip "$name"; then
		echo "pulando (sensível): $name"
		continue
	fi
	cat > "${d}.directory" <<-EOF
	[Desktop Entry]
	Icon=folder-grey
	EOF
	echo "marcado: $name"
done
