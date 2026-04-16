#!/bin/bash
# Updates the label of a space item with icons of the apps running in it.
# Called with the space ID as $1 (same pattern as aerospace.sh).
#
# Triggers: aerospace_workspace_change, front_app_switched

source "$HOME/.config/sketchybar/plugins/app_icon.sh"

SPACE_ID="$1"

# Query windows in this space via AeroSpace
APPS=$(aerospace list-windows --workspace "$SPACE_ID" --json 2>/dev/null \
       | jq -r '.[]."app-name"' 2>/dev/null | sort -u)

ICONS=""
while IFS= read -r APP; do
  [ -z "$APP" ] && continue
  ICONS+="$(app_icon "$APP") "
done <<< "$APPS"

# Trim trailing space; if empty, hide the label
ICONS="${ICONS% }"

if [ -z "$ICONS" ]; then
  sketchybar --set "$NAME" label.drawing=off
else
  sketchybar --set "$NAME" label="$ICONS" label.drawing=on
fi
