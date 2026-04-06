#!/bin/bash

# Check if Bluetooth is powered on
if ! bluetoothctl show | grep -q "Powered: yes"; then
    options="󰂲 Power On"
else
    options="󰂲 Power Off"
    
    # Loop through paired devices
    while read -r line; do
        # Skip empty lines
        [ -z "$line" ] && continue
        
        mac=$(echo "$line" | awk '{print $2}')
        name=$(echo "$line" | awk '{for(i=3;i<=NF;i++) printf $i" "; print ""}' | sed 's/ *$//')
        
        # If connected, make it Green. Otherwise, normal text.
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            options+="\n<span foreground='#A6E3A1'>󰂱 $name ($mac)</span>"
        else
            options+="\n $name ($mac)"
        fi
    done <<< "$(bluetoothctl devices)"
fi

# Run Rofi with -markup-rows to enable the color tags
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Bluetooth" -theme ~/.config/rofi/vpn/vpn.rasi -no-lazy-grab -markup-rows)

# Exit if user hits Escape or clicks away
[ -z "$chosen" ] && exit

# Strip the HTML color tags so we can read the raw text
clean_chosen=$(echo "$chosen" | sed -e 's/<[^>]*>//g')

# Handle the click actions
if [[ "$clean_chosen" == *"Power On"* ]]; then
    bluetoothctl power on
elif [[ "$clean_chosen" == *"Power Off"* ]]; then
    bluetoothctl power off
else
    # Extract MAC address from parentheses
    mac=$(echo "$clean_chosen" | grep -oE '([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}')
    if [ -n "$mac" ]; then
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            bluetoothctl disconnect "$mac"
        else
            bluetoothctl connect "$mac"
        fi
    fi
fi
