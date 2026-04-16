#!/bin/bash
# Handles focus highlight AND app icon labels for a workspace item.
# $1 = this item's space ID

# Ensure Homebrew binaries are available (sketchybar runs with a minimal PATH)
export PATH="/opt/homebrew/bin:$PATH"

source "$HOME/.config/sketchybar/plugins/app_icon.sh"

SPACE_ID="$1"

##### Focus highlight (only on workspace change, not app switch) #####
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  if [ "$SPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on \
                              background.color=0xffffffff \
                              icon.color=0xff000000 \
                              label.color=0xff000000
  else
    sketchybar --set "$NAME" background.drawing=off \
                              icon.color=0xffffffff \
                              label.color=0xffcad3f5
  fi
fi

##### App icons for this space #####
APPS=$(aerospace list-windows --workspace "$SPACE_ID" --json 2>/dev/null \
       | jq -r '.[]."app-name"' 2>/dev/null | sort -u)

ICONS=""
while IFS= read -r APP; do
  [ -z "$APP" ] && continue
  ICONS+="$(app_icon "$APP") "
done <<< "$APPS"

ICONS="${ICONS% }"  # trim trailing space

if [ -z "$ICONS" ]; then
  sketchybar --set "$NAME" label.drawing=off
else
  sketchybar --set "$NAME" label="$ICONS" label.drawing=on
fi
