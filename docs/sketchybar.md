# Sketchybar Config

Status bar for macOS. Pairs with [AeroSpace](aerospace.md) for workspace indicators that show focus + the apps living on each workspace.

Config lives at [`config/sketchybar/sketchybarrc`](../config/sketchybar/sketchybarrc); plugins at [`config/sketchybar/plugins/`](../config/sketchybar/plugins/); the color palette is loaded from [`config/sketchybar/colors.sh`](../config/sketchybar/colors.sh).

## Install

Comes with the macOS installer:

```bash
./scripts/install/macos/mac.sh
```

That step taps `FelixKratz/formulae`, brews `sketchybar`, symlinks `config/sketchybar` to `~/.config/sketchybar`, marks the plugins executable, and starts the launch agent (`brew services start sketchybar`).

### Required fonts & deps

```bash
brew install jq
brew install --cask font-monocraft font-hack-nerd-font
```

- **Monocraft** — used for the bar's text/numbers (the chunky pixel look)
- **Hack Nerd Font** — used for app icon glyphs in workspace pills
- **jq** — `aerospace.sh` uses it to parse `aerospace list-windows --json`

---

## Layout

```
┌────────────────────────────────┐  ┌──────────────────────────────────┐
│ 1 [icons]  2 [icons]  3 …      │  │  clock      volume   battery   cpu │
└────────────────────────────────┘  └──────────────────────────────────┘
        left pill (workspaces)            right pill (system info)
```

- **Position:** top, height 40, 5px below the screen edge, 10px side margin
- **Background:** transparent bar; each pill draws its own rounded background
- **Pills:** corner radius 15, full-height, no border. Workspace pills only draw when there's something to show (focused or has windows).

---

## Workspace Indicators (left pill)

One item per AeroSpace workspace 1–10. Driven by [`plugins/aerospace.sh`](../config/sketchybar/plugins/aerospace.sh):

- **Visibility:** a workspace pill draws only if it's focused *or* has windows. Empty unfocused workspaces are hidden so the bar stays uncluttered.
- **Focus highlight:** the focused workspace gets `WAL_ACCENT` background with `WAL_ACCENT_FG` text. Others use the muted foreground color.
- **App icons:** for each workspace, `aerospace list-windows --workspace $i --json` is piped through `jq` to get app names, then [`plugins/app_icon.sh`](../config/sketchybar/plugins/app_icon.sh) maps each name to a Nerd Font glyph (terminal, browser, editor, chat, etc.) which gets concatenated into the pill's label.
- **Click:** clicking a workspace pill runs `aerospace workspace $i` to switch.

The plugin re-runs on two triggers:

| Event | When it fires |
|---|---|
| `aerospace_workspace_change` | AeroSpace's `exec-on-workspace-change` (focus moved to a different workspace) |
| `front_app_switched` | macOS frontmost app changed (handles app launches/quits within a workspace) |

---

## Right Pill (system info)

| Item | Plugin | Update |
|---|---|---|
| `clock` | [`clock.sh`](../config/sketchybar/plugins/clock.sh) | every 10s |
| `volume` | [`volume.sh`](../config/sketchybar/plugins/volume.sh) | on `volume_change` event |
| `battery` | [`battery.sh`](../config/sketchybar/plugins/battery.sh) | every 120s, plus `system_woke` and `power_source_change` |
| `cpu` | [`cpu.sh`](../config/sketchybar/plugins/cpu.sh) | every 2s |

All four sit inside a single `right_pill` bracket so they share one rounded background.

---

## Theming (pywal-driven)

[`colors.sh`](../config/sketchybar/colors.sh) sources `~/.cache/wal/colors.sh` if present, otherwise falls back to a hardcoded palette (`#12151c` bg, `#477AA6` accent). The pywal hex values are converted to sketchybar's `0xAARRGGBB` format and exposed as:

| Var | Used for |
|---|---|
| `WAL_BG` | Pill backgrounds |
| `WAL_FG` | Default text/icon color |
| `WAL_ACCENT` | Focused workspace background |
| `WAL_ACCENT_FG` | Text on top of accent |
| `WAL_MUTED` | Inactive labels |
| `WAL_SPACE_BG` | Subtle tint when a workspace pill draws its bg |
| `WAL_BAR_BG` | 60%-opacity bar background (`0x99` alpha prefix) |

Run `wal -i <wallpaper>` and the bar reskins on next reload (`brew services restart sketchybar`).

The companion script [`scripts/wal-iterm2.py`](../scripts/wal-iterm2.py) regenerates an iTerm2 profile from the same wal palette so terminal and bar stay in sync.

---

## Adding a new app icon

Open [`plugins/app_icon.sh`](../config/sketchybar/plugins/app_icon.sh) and add a case branch with the app's macOS name (what shows in the menu bar / `aerospace list-windows`) and a Nerd Font hex sequence:

```bash
"Linear")  printf '\xef\x8a\xae' ;;   # whatever Nerd Font glyph fits
```

Find glyphs and their hex bytes at [nerdfonts.com/cheat-sheet](https://www.nerdfonts.com/cheat-sheet). Anything not matched falls through to the `*)` case (an empty-square glyph) so unknown apps still appear, just generically.

---

## File Layout

```
config/sketchybar/
├── sketchybarrc           # Bar shape + items + brackets
├── colors.sh              # pywal palette → WAL_* variables
└── plugins/
    ├── aerospace.sh       # Per-workspace pill: visibility, focus, app icons
    ├── app_icon.sh        # App name → Nerd Font glyph table (sourced by aerospace.sh)
    ├── app_space.sh       # Standalone icon updater (reference / unused by main config)
    ├── battery.sh
    ├── clock.sh
    ├── cpu.sh
    ├── front_app.sh
    ├── space.sh
    └── volume.sh
```
