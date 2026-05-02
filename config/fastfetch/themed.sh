#!/usr/bin/env bash
# Hostname-themed fastfetch wrapper.
# Picks the logo color based on $(hostname -s) so each machine has its own
# accent. Add new hosts as you provision them.
#
# COLOR can be:
#   - "#RRGGBB"     → emitted as truecolor escape (\033[38;2;R;G;Bm)
#   - "ansi:NN"     → emitted as ANSI palette code (\033[NNm), e.g. ansi:94
#                     for bright blue. Use this when you want the color to
#                     follow your terminal profile (e.g. pywal, base16).
#
# Usage: alias fastfetch="$HOME/.config/fastfetch/themed.sh"

HOST="$(hostname -s | tr '[:upper:]' '[:lower:]')"

case "$HOST" in
  # Main Mac — use the terminal profile's bright blue (94).
  # On the wal profile this maps to whatever wallpaper-derived blue is loaded,
  # so the logo always matches what's in the iTerm2 ANSI palette.
  alice|*-mbp|*macbook*|*mac*)
    COLOR="ansi:94" ;;
  # Homelab Proxmox/NixOS host
  layer01|layer0*|nixos*)
    COLOR="ansi:95" ;;       # bright magenta
  # Linux desktop / Arch
  arch*|hyprland*)
    COLOR="ansi:96" ;;       # bright cyan
  # Raspberry Pi / small ARM boxes
  pi*|raspberry*)
    COLOR="ansi:97" ;;       # bright white
  # Default (unknown SSH targets) — muted blue from portfolio
  *)
    COLOR="#7a9dba" ;;
esac

# Build the ANSI prefix for the chosen color.
case "$COLOR" in
  ansi:*)
    CODE="${COLOR#ansi:}"
    ANSI_PREFIX=$(printf '\033[%sm' "$CODE")
    ;;
  \#*)
    HEX="${COLOR#\#}"
    R=$((16#${HEX:0:2}))
    G=$((16#${HEX:2:2}))
    B=$((16#${HEX:4:2}))
    ANSI_PREFIX=$(printf '\033[38;2;%d;%d;%dm' "$R" "$G" "$B")
    ;;
  *)
    echo "themed.sh: unrecognized COLOR format: $COLOR" >&2
    exit 1
    ;;
esac

LOGO_FILE="$HOME/.config/fastfetch/logo.txt"
LOGO_DATA="$(printf '%s%s\033[0m' "$ANSI_PREFIX" "$(cat "$LOGO_FILE")")"

exec fastfetch \
  --logo-type data-raw \
  --logo "$LOGO_DATA" \
  "$@"
