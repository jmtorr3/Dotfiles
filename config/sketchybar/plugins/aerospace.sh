#!/bin/bash
# Handles visibility, focus highlight, and app icon labels for a workspace item.
# $1 = this item's space ID

export PATH="/opt/homebrew/bin:$PATH"

source "$HOME/.config/sketchybar/plugins/app_icon.sh"
source "$HOME/.config/sketchybar/colors.sh"

SPACE_ID="$1"

##### Resolve focused workspace #####
# aerospace_workspace_change provides $FOCUSED_WORKSPACE; other events don't.
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  FOCUSED="$FOCUSED_WORKSPACE"
else
  FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
fi

##### App icons for this space #####
APPS=$(aerospace list-windows --workspace "$SPACE_ID" --json 2>/dev/null \
       | jq -r '.[]."app-name"' 2>/dev/null | sort -u)

ICONS=""
while IFS= read -r APP; do
  [ -z "$APP" ] && continue
  ICONS+="$(app_icon "$APP") "
done <<< "$APPS"
ICONS="${ICONS% }"

##### Visibility: show if focused or occupied #####
if [ "$SPACE_ID" = "$FOCUSED" ] || [ -n "$ICONS" ]; then
  sketchybar --set "$NAME" drawing=on
else
  sketchybar --set "$NAME" drawing=off
  exit 0  # nothing more to do for a hidden space
fi

##### Focus highlight #####
if [ "$SPACE_ID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" background.drawing=on \
                            background.color="$WAL_ACCENT" \
                            icon.color="$WAL_ACCENT_FG" \
                            label.color="$WAL_ACCENT_FG"
else
  sketchybar --set "$NAME" background.drawing=off \
                            icon.color="$WAL_FG" \
                            label.color="$WAL_MUTED"
fi

##### Icon label #####
if [ -z "$ICONS" ]; then
  sketchybar --set "$NAME" label.drawing=off
else
  sketchybar --set "$NAME" label="$ICONS" label.drawing=on
fi
