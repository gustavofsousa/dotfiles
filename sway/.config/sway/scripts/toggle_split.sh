#!/bin/zsh

# Find the focused container and trace up to its parent layout
LAYOUT=$(swaymsg -t get_tree | jq -r '
  .. | select(.focused?) | .id as $id |
  (.. | select(.nodes[]?.id == $id) | .layout) // "none"
')

# Toggle between splith and splitv
if [ "$LAYOUT" = "splith" ]; then
    swaymsg splitv
else
    swaymsg splith
fi
