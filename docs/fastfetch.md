# Fastfetch Config

Personal fastfetch setup — replaces the default Apple logo with the [portfolio](https://github.com/) ASCII art on every machine, and tints it a different color depending on which host I'm on.

Config lives at [`config/fastfetch/`](../config/fastfetch/):

| File | Purpose |
|---|---|
| `logo.txt` | The Braille-character ASCII logo (lifted from `Hero.tsx`) |
| `config.jsonc` | Module list + tells fastfetch to load the logo from `logo.txt` |
| `themed.sh` | Hostname-aware wrapper that picks `--logo-color-1` per machine |

## Install

The macOS and Arch installers add `fastfetch` to their package lists; the symlink scripts wire `~/.config/fastfetch` to the dotfile dir:

```bash
./scripts/install/macos/mac.sh        # brews fastfetch + symlinks
./scripts/install/hyprland/arch.sh    # pacman fastfetch + symlinks
./scripts/symlink/terminal.sh         # if fastfetch is already installed
```

### Hook up the wrapper

Add an alias to your shell rc so plain `fastfetch` picks up the per-host color:

```bash
# ~/.zshrc or ~/.bashrc
alias fastfetch="$HOME/.config/fastfetch/themed.sh"
```

Without the alias, `fastfetch` still uses the personal logo (since the config is symlinked) but renders it in fastfetch's default color.

---

## Per-Host Colors

`themed.sh` matches `$(hostname -s)` against case patterns and picks a color. Two `COLOR` formats are supported:

- **`ansi:NN`** — uses ANSI escape code `NN` (e.g. `ansi:94` for bright blue). Goes through your terminal's color profile, so on iTerm2 with the pywal profile it'll render whatever `wal -i <wallpaper>` derived for that slot. Use this when you want the logo to track the active terminal theme.
- **`#RRGGBB`** — emitted as a raw truecolor escape (`\033[38;2;R;G;Bm`). Renders the exact RGB regardless of terminal profile.

Defaults shipped:

| Pattern | Format | Value | What |
|---|---|---|---|
| `alice`, `*-mbp`, `*macbook*`, `*mac*` | ansi | `94` (bright blue) | Main Mac — matches the iTerm2 wal profile's "Blue Bright" swatch |
| `layer01`, `layer0*`, `nixos*` | ansi | `95` (bright magenta) | Homelab NixOS / Proxmox host |
| `arch*`, `hyprland*` | ansi | `96` (bright cyan) | Linux desktop |
| `pi*`, `raspberry*` | ansi | `97` (bright white) | Raspberry Pi / small ARM |
| anything else | hex | `#7a9dba` | Unknown SSH targets — muted blue from portfolio |

### Adding a new host

Edit `config/fastfetch/themed.sh` and drop a new branch into the `case` block, using either format:

```bash
homelab-prod|prod-*)
  COLOR="#ff6b6b" ;;          # specific hex
work-laptop)
  COLOR="ansi:93" ;;          # bright yellow from terminal profile
```

Match against whatever `hostname -s` reports on that machine.

### Changing the main Mac's color

Edit the first case branch in `themed.sh` — change `#4aafd4` to whatever you want. Reload with the next shell prompt.

---

## Modules Shown

`config.jsonc` enables these modules in this order:

```
title  →  separator  →  os  →  host  →  kernel  →  uptime
       →  packages   →  shell  →  terminal  →  cpu  →  gpu
       →  memory     →  disk   →  localip   →  battery
       →  break      →  colors
```

Drop any you don't care about by removing them from the `"modules"` array. Add new ones from [the fastfetch module list](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration).

---

## Replacing the Logo

`logo.txt` is just a UTF-8 text file — fastfetch renders whatever's in it. Two ways to swap art:

1. **Same source as the portfolio:** the original is in `Hero.tsx` between lines 73–94 inside the `<pre className="hero-ascii">` block. Re-extract any time the portfolio art changes.
2. **Try anything else:** drop a new logo into `logo.txt` (Nerd Font glyphs, Braille, plain ASCII — all fine). For colored regions inside the logo, use fastfetch's color placeholders like `$1`, `$2` and reference them via `--logo-color-1`, `--logo-color-2` (which `themed.sh` already passes).

To temporarily skip the custom logo on a machine: `fastfetch --logo none` or `fastfetch --logo apple` for the OS default.

---

## File Layout

```
config/fastfetch/
├── config.jsonc   # Modules + logo source
├── logo.txt       # Braille ASCII (from portfolio Hero.tsx)
└── themed.sh      # Hostname → color wrapper. Alias `fastfetch` to this.
```
