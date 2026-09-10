# Change this according to your device
################
# Variables
################

# Date and time
date_and_week=$(date "+%d/%m/%Y")
current_time=$(date "+%H:%M")

#############
# Commands
#############

# Battery or charger
battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

# Audio and multimedia
default_sink=$(pactl get-default-sink)
audio_volume=$(pamixer --sink "$default_sink" --get-volume)
audio_is_muted=$(pamixer --sink "$default_sink" --get-mute)


loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')

if [ $battery_status = "discharging" ];
then
    battery_pluggedin='⚠'
else
    battery_pluggedin='⚡'
fi

if ! [ $network ]
then
   network_active="⛔"
else
   network_active="⇆"
fi

if [ $audio_is_muted = "true" ]
then
    audio_active='🔇'
else
    audio_active='🔊'
fi

echo " 🏋 $loadavg_5min | $audio_active $audio_volume% | $battery_pluggedin $battery_charge | 🕘 $current_time  - $date_and_week"

