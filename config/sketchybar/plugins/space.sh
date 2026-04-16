#!/bin/bash
# This script is triggered by AeroSpace workspace changes
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on \
                         background.color=0xffeed49f \
                         label.color=0xff1e2030
else
  sketchybar --set $NAME background.drawing=off \
                         label.color=0xffcad3f5
fi
