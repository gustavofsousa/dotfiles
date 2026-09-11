#!/bin/bash

# Pega os workspaces ativos e os monitores correspondentes
mapfile -t outputs < <(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .name')

if [ "${#outputs[@]}" -ne 2 ]; then
    echo "Este script funciona apenas com dois monitores ativos."
    exit 1
fi

# Para cada monitor, pegue o workspace visível
ws1=$(swaymsg -t get_workspaces | jq -r ".[] | select(.output == \"${outputs[0]}\") | select(.visible == true) | .name")
ws2=$(swaymsg -t get_workspaces | jq -r ".[] | select(.output == \"${outputs[1]}\") | select(.visible == true) | .name")

# Troca os workspaces
swaymsg workspace "$ws1"
swaymsg move workspace to output "${outputs[1]}"

swaymsg workspace "$ws2"
swaymsg move workspace to output "${outputs[0]}"

# Volta para o workspace original (opcional)
swaymsg workspace "$ws1"

