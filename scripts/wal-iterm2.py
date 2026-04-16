#!/usr/bin/env python3
"""
Generate an iTerm2 Dynamic Profile named "wal" from the current pywal palette.
Appears as a selectable profile in iTerm2 alongside your Default profile.
Your Default profile and all its settings are untouched.

iTerm2 hot-reloads ~/Library/Application Support/iTerm2/DynamicProfiles/
so changes appear immediately without restarting.

Usage: python3 wal-iterm2.py
Run automatically via the `walset` alias.
"""

import json
import os
import sys

WAL_COLORS    = os.path.expanduser("~/.cache/wal/colors.json")
ITERM_PROFILES = os.path.expanduser("~/Library/Application Support/iTerm2/DynamicProfiles")
OUTPUT        = os.path.join(ITERM_PROFILES, "wal.json")


def hex_to_iterm(hex_color: str) -> dict:
    h = hex_color.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    return {
        "Color Space": "sRGB",
        "Red Component":   round(r / 255, 6),
        "Green Component": round(g / 255, 6),
        "Blue Component":  round(b / 255, 6),
        "Alpha Component": 1.0,
    }


def main():
    if not os.path.exists(WAL_COLORS):
        print(f"pywal colors not found at {WAL_COLORS}. Run `wal -i <wallpaper>` first.")
        sys.exit(1)

    with open(WAL_COLORS) as f:
        wal = json.load(f)

    c = wal["colors"]
    s = wal["special"]

    profile = {
        "Name": "wal",
        "Guid": "wal-pywal-dynamic-profile",
        "Rewritable": False,
        "Background Color":    hex_to_iterm(s["background"]),
        "Foreground Color":    hex_to_iterm(s["foreground"]),
        "Bold Color":          hex_to_iterm(s["foreground"]),
        "Cursor Color":        hex_to_iterm(s["cursor"]),
        "Cursor Text Color":   hex_to_iterm(s["background"]),
        "Selection Color":     hex_to_iterm(c["color1"]),
        "Selected Text Color": hex_to_iterm(s["foreground"]),
        "Link Color":          hex_to_iterm(c["color4"]),
        "Ansi 0 Color":        hex_to_iterm(c["color0"]),
        "Ansi 1 Color":        hex_to_iterm(c["color1"]),
        "Ansi 2 Color":        hex_to_iterm(c["color2"]),
        "Ansi 3 Color":        hex_to_iterm(c["color3"]),
        "Ansi 4 Color":        hex_to_iterm(c["color4"]),
        "Ansi 5 Color":        hex_to_iterm(c["color5"]),
        "Ansi 6 Color":        hex_to_iterm(c["color6"]),
        "Ansi 7 Color":        hex_to_iterm(c["color7"]),
        "Ansi 8 Color":        hex_to_iterm(c["color8"]),
        "Ansi 9 Color":        hex_to_iterm(c["color9"]),
        "Ansi 10 Color":       hex_to_iterm(c["color10"]),
        "Ansi 11 Color":       hex_to_iterm(c["color11"]),
        "Ansi 12 Color":       hex_to_iterm(c["color12"]),
        "Ansi 13 Color":       hex_to_iterm(c["color13"]),
        "Ansi 14 Color":       hex_to_iterm(c["color14"]),
        "Ansi 15 Color":       hex_to_iterm(c["color15"]),
    }

    os.makedirs(ITERM_PROFILES, exist_ok=True)
    with open(OUTPUT, "w") as f:
        json.dump({"Profiles": [profile]}, f, indent=2)

    print(f"Written: {OUTPUT}")
    print("Select 'wal' in iTerm2 → Profiles to use it.")


if __name__ == "__main__":
    main()
