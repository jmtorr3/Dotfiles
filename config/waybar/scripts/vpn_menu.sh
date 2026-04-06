#!/bin/bash

# Connection Names
JP="jp758.nordvpn.com.tcp"
US_UDP="us9921.nordvpn.com.udp"
US_TCP="us9921.nordvpn.com.tcp"

options="󰇧 Japan (TCP)\n󰇧 US (UDP)\n󰇧 US (TCP)\n󰅙 Disconnect"

# Standard Rofi Flags: 
# -location 3 = North East
# -xoffset -120 = move left from corner
# -yoffset 45 = move down from bar
chosen=$(echo -e "$options" | rofi -dmenu -i -p "VPN Selector" -theme ~/.config/rofi/vpn/vpn.rasi -normal-window)

case "$chosen" in
    *"Japan (TCP)")
        nmcli connection up "$JP"
        ;;
    *"US (UDP)")
        nmcli connection up "$US_UDP"
        ;;
    *"US (TCP)")
        nmcli connection up "$US_TCP"
        ;;
    *"Disconnect")
        nmcli connection down id "$JP" 2>/dev/null
        nmcli connection down id "$US_UDP" 2>/dev/null
        nmcli connection down id "$US_TCP" 2>/dev/null
        ;;
esac

pkill -RTMIN+8 waybar
