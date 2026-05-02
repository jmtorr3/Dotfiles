# tmux Config

Personal tmux setup — vim-friendly navigation, true color, and a status bar themed to match my [portfolio](https://github.com/) palette.

Config lives at [`config/tmux/tmux.conf`](../config/tmux/tmux.conf). It's symlinked to `~/.config/tmux/tmux.conf` (the XDG path tmux 3.1+ reads from), not the legacy `~/.tmux.conf`.

- **Prefix:** default `C-b` (unchanged)

## Install

Comes with the macOS and Arch installers:

```bash
./scripts/install/macos/mac.sh        # adds `tmux` to brew packages
./scripts/install/hyprland/arch.sh    # adds `tmux` to pacman packages
```

If tmux is already installed and you only want the config wired up:

```bash
./scripts/symlink/terminal.sh   # tmux + nvim, nothing else
./scripts/symlink/all.sh        # everything (desktop too)
```

Either one removes any legacy `~/.tmux.conf` (or backs it up to `.bak` if it's a real file) so the XDG path takes over cleanly. Use `terminal.sh` on shared or work machines where you don't want to overwrite someone else's window manager or status bar configs.

Reload inside an existing session with `prefix + r`.

---

## Keymap Cheatsheet

### Pane Navigation

Vim-style movement with the prefix. `Alt-hjkl` is intentionally not bound — AeroSpace owns those on macOS for window focus, so reserving Alt for the OS layer keeps tmux and the WM from fighting.

| Keys | Action |
|---|---|
| `prefix + h` | Focus pane left |
| `prefix + j` | Focus pane down |
| `prefix + k` | Focus pane up |
| `prefix + l` | Focus pane right |

### Splits & Windows

Splits and new windows inherit the current pane's working directory.

| Keys | Action |
|---|---|
| `prefix + |` | Split horizontally (side-by-side) |
| `prefix + -` | Split vertically (stacked) |
| `prefix + c` | New window in cwd |
| `prefix + r` | Reload `~/.config/tmux/tmux.conf` |

Windows and panes are 1-indexed (easier to reach than 0). Window numbers renumber automatically when one is closed.

### Copy Mode (vi-style)

Copy mode uses vi keys. Enter with `prefix + [`.

| Keys | Action |
|---|---|
| `v` | Begin selection |
| `y` | Yank selection (copies to system clipboard via OSC 52) |
| `q` / `Esc` | Exit copy mode |

OSC 52 means yanks copy back to the local clipboard even over SSH, as long as the terminal emulator supports it (Alacritty, kitty, iTerm2, WezTerm — all yes).

### Mouse

Mouse mode is on. Click to focus a pane, drag borders to resize, scroll-wheel to enter copy mode and scroll history.

---

## Theme

Colors come from the portfolio palette:

| Variable | Hex | Used for |
|---|---|---|
| accent | `#4aafd4` | Active window, active pane border, prompt, copy-mode highlight |
| bg | `#0d1520` | Status bar background |
| text | `#ddeaf5` | Status bar text |
| muted | `#7a9dba` | Inactive windows, date |
| border | `#1c3050` | Inactive pane borders |

The status bar sits at the **top** (so it doesn't fight with shell prompts at the bottom), shows the session name in a blue pill on the left, and date/time on the right. Window list is between them.

### Adjusting the color

Change every `#4aafd4` in `config/tmux/tmux.conf` to whatever accent you want — the file uses the hex directly, no palette indirection. Reload with `prefix + r`.

---

## Other Settings

| Setting | Value | Why |
|---|---|---|
| `default-terminal` | `tmux-256color` | Modern terminfo |
| `terminal-overrides` | `*:RGB` (and `xterm-256color`, `alacritty`) | True color so themes render correctly |
| `escape-time` | `10` | Otherwise nvim feels laggy when hitting `<Esc>` inside tmux |
| `history-limit` | `50000` | Bigger scrollback |
| `focus-events` | `on` | nvim's `autoread` works (file change detection) |
| `set-clipboard` | `on` | Enables OSC 52 clipboard passthrough |
| `mouse` | `on` | Click, scroll, resize |
| `base-index`, `pane-base-index` | `1` | Easier reach on the number row |
| `renumber-windows` | `on` | No gaps after closing a window |

---

## File Layout

```
config/tmux/
└── tmux.conf     # Single file — settings, keybinds, theme
```
