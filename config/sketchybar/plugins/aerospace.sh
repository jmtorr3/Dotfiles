#!/bin/bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on \
                         icon.color=0xff000000 \
                         background.color=0xffffffff
else
  sketchybar --set $NAME background.drawing=off \
                         icon.color=0xffffffff
fi
