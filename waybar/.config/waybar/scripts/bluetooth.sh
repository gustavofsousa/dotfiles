#!/bin/zsh

bt_status=$(bluetoothctl show 2>/dev/null | grep "Powered" | cut -d ' ' -f 2)

if [[ "$bt_status" == "yes" ]]; then
    echo '{"text": "", "tooltip": "Bluetooth ligado", "class": "on"}'
else
    echo '{"text": "󰂲", "tooltip": "Bluetooth desligado", "class": "off"}'
fi

