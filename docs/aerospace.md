# AeroSpace Config

Tiling window manager for macOS, configured to feel like an i3/Hyprland setup. Config lives at [`config/aerospace/aerospace.toml`](../config/aerospace/aerospace.toml).

AeroSpace runs at login and triggers a Sketchybar workspace event on every focus change, so the bar's workspace pill stays in sync with what's actually focused. See [sketchybar.md](sketchybar.md) for the bar side.

- **Modifier:** `Alt` (Option) for everything
- **Service mode trigger:** `Alt-Shift-;`

## Install

Comes with the macOS installer:

```bash
./scripts/install/macos/mac.sh
```

Installs AeroSpace via Homebrew cask, symlinks `config/aerospace` to `~/.config/aerospace`. Log out and back in (or reboot) the first time so AeroSpace can register as a launch agent.

---

## Keymap Cheatsheet

### Focus

| Keys | Action |
|---|---|
| `Alt-h` | Focus window left |
| `Alt-j` | Focus window down |
| `Alt-k` | Focus window up |
| `Alt-l` | Focus window right |

These are why `tmux` uses prefix-based pane switching instead of `Alt-hjkl` — AeroSpace owns Alt at the OS level. See [tmux.md](tmux.md).

### Move Windows

| Keys | Action |
|---|---|
| `Alt-Shift-h/j/k/l` | Move focused window left/down/up/right |

### Workspaces

10 numeric workspaces (1–9, 0). The full A–Z set is also kept persistent in config, so you can hop to letter workspaces via AeroSpace CLI without losing them.

| Keys | Action |
|---|---|
| `Alt-1` … `Alt-0` | Switch to workspace 1–10 |
| `Alt-Shift-1` … `Alt-Shift-0` | Move window to workspace 1–10 *and* follow |
| `Alt-Tab` | Toggle to previous workspace |
| `Alt-Left` / `Alt-Right` | Workspace prev / next |
| `Alt-Shift-Tab` | Move current workspace to next monitor (wraps) |

### Layout

| Keys | Action |
|---|---|
| `Alt-/` | Tiles layout (toggle horizontal / vertical) |
| `Alt-,` | Accordion layout (toggle horizontal / vertical) |
| `Alt-=` | Resize focused window +50 |
| `Alt--` | Resize focused window −50 |

Accordion padding is `30px`. Tiles are the default root layout, with auto-orientation per monitor (wide → horizontal, tall → vertical).

### Apps

| Keys | Action |
|---|---|
| `Alt-Enter` | Open iTerm2 (new window if running, else launch) |
| `Alt-f` | Open a new Firefox window |
| `Alt-q` | Close focused window |

### Service Mode

Press `Alt-Shift-;` to enter service mode. The bindings below run, then drop you back to main mode.

| Keys | Action |
|---|---|
| `Esc` | Reload config |
| `r` | Flatten workspace tree (reset layout) |
| `f` | Toggle floating ↔ tiling for focused window |
| `Backspace` | Close all windows on this workspace except the focused one |
| `Alt-Shift-h/j/k/l` | Join with neighbor in that direction |

---

## Gaps

| Gap | Value |
|---|---|
| Inner (between windows), horizontal & vertical | `12px` |
| Outer left / bottom / right | `12px` |
| Outer top | `18px` (extra space for Sketchybar) |

---

## Behaviors Worth Knowing

- **Mouse follows focus across monitors.** When the focused monitor changes, the cursor jumps to its center (`on-focused-monitor-changed = ['move-mouse monitor-lazy-center']`).
- **macOS "Hide application" is neutralized.** AeroSpace auto-unhides apps you accidentally hid with `Cmd-H` / `Cmd-Alt-H`.
- **System Settings is forced to tile.** Without this it floats by default and breaks the layout.
- **Sketchybar gets pinged on every workspace change** via `exec-on-workspace-change`, which fires the `aerospace_workspace_change` event with `$FOCUSED_WORKSPACE`. The bar's `aerospace.sh` plugin reads that to update which workspace pill is highlighted.
- **AeroSpace itself launches Sketchybar** on startup (`after-startup-command = ['exec-and-forget sketchybar']`), so you only need AeroSpace at login — Sketchybar comes along.

---

## File Layout

```
config/aerospace/
└── aerospace.toml   # Single file — modes, gaps, keybinds, on-startup hooks
```
