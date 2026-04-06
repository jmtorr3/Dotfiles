#!/bin/bash

# Check if ANY NordVPN connection is active
ACTIVE_VPN=$(nmcli -t -f NAME,TYPE connection show --active | grep "vpn" | cut -d: -f1)

if [ -n "$ACTIVE_VPN" ]; then
    # If it's your specific JP one, show that, otherwise show a generic US tag
    if [[ "$ACTIVE_VPN" == *"jp"* ]]; then
        LABEL="jp tcp"
    else
        LABEL="us vpn"
    fi
    echo "{\"text\": \" $LABEL\", \"class\": \"connected\"}"
else
    echo "{\"text\": \" vpn off\", \"class\": \"disconnected\"}"
fi
