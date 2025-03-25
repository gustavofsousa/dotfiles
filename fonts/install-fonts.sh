#!/bin/bash

# Diretório de fontes no dotfiles
FONT_DIR="$HOME/dotfiles/fonts/JetBrainsMono"

# Diretórios de fontes do sistema
USER_FONT_DIR="$HOME/.local/share/fonts"
SYSTEM_FONT_DIR="/usr/share/fonts"

# Verifica se é root (para mover para o sistema)
if [ "$(id -u)" -eq 0 ]; then
    FONT_DEST="$SYSTEM_FONT_DIR"
else
    FONT_DEST="$USER_FONT_DIR"
fi

# Cria o diretório de destino caso não exista
mkdir -p "$FONT_DEST/JetBrainsMono"

# Copia os arquivos .ttf
cp -r "$FONT_DIR"/*.ttf "$FONT_DEST/JetBrainsMono/"

# Atualiza o cache de fontes
fc-cache -fv
