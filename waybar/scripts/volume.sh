#!/bin/bash

# Pega o volume atual
volume=$(amixer sget Master | grep -o '[0-9]*%' | head -n 1)

# Exibe o volume no swaybar
swaymsg bar mode hide
swaymsg bar mode show
swaymsg bar command "exec echo Volume: $volume"

