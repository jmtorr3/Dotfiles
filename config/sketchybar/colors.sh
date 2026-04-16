#!/bin/bash
# Loads pywal palette and exposes sketchybar-ready color variables.
# Falls back to hardcoded values if pywal hasn't been run yet.

if [ -f "$HOME/.cache/wal/colors.sh" ]; then
  # shellcheck disable=SC1090
  source "$HOME/.cache/wal/colors.sh"
else
  background='#12151c'
  foreground='#c3c4c6'
  color4='#477AA6'
  color8='#5d6371'
fi

# Convert #RRGGBB → 0xffRRGGBB (sketchybar format)
_wal() { echo "0xff${1#'#'}"; }

# Bar background — 60% opacity version of background
# Sketchybar uses 0xAARRGGBB; AA=99 ≈ 60%
WAL_BAR_BG="0x99${background#'#'}"

WAL_BG=$(_wal "$background")
WAL_FG=$(_wal "$foreground")
WAL_ACCENT=$(_wal "$color4")        # focused workspace bg
WAL_ACCENT_FG=$(_wal "$background") # text on top of accent
WAL_MUTED=$(_wal "$color8")         # unfocused label color
WAL_SPACE_BG="0x40${foreground#'#'}" # subtle space background tint
