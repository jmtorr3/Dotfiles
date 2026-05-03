# Dotfiles

Personal configuration files for Neovim, tmux, Hyprland (Linux), and macOS (AeroSpace + Sketchybar).

**Docs:**
- [Neovim](docs/nvim.md) — keymap cheatsheet, plugin walkthrough, dashboard
- [tmux](docs/tmux.md) — keybinds, theme, install
- [AeroSpace](docs/aerospace.md) — keybinds, modes, gaps, behaviors
- [Sketchybar](docs/sketchybar.md) — bar layout, plugins, theming
- [Fastfetch](docs/fastfetch.md) — personal ASCII logo + per-host accent color

## Setup

### macOS (AeroSpace + Sketchybar + Neovim)

Installs all packages via Homebrew, symlinks configs, and starts the Sketchybar service:

```bash
./scripts/install/macos/mac.sh
```

**Sketchybar dependencies:** `jq`, `Monocraft` font, `Hack Nerd Font`

```bash
brew install jq
brew install --cask font-monocraft font-hack-nerd-font
```

### Full Desktop (Arch Linux)

Installs Hyprland + all dependencies (waybar, rofi, dunst, kitty, etc.) and symlinks all configs:

```bash
./scripts/install/hyprland/arch.sh
```

### Terminal Stack Only (no desktop env)

Installs Neovim, tmux, fastfetch, and clang-format; symlinks all four configs via `scripts/symlink/terminal.sh`. Safe on shared/work machines and headless VMs — does not touch window managers, status bars, or launchers.

**Ubuntu:**
```bash
./scripts/install/nvim/ubuntu.sh
```

**Debian:**
```bash
./scripts/install/nvim/debian.sh
```

**Fedora:**
```bash
./scripts/install/nvim/fedora.sh
```

**Arch (headless / no Hyprland):**
```bash
./scripts/install/nvim/arch.sh
```

**NixOS:**
```bash
./scripts/install/nvim/nixos.sh
```

### Just Symlink Configs

If packages are already installed and you just want to wire up the configs:

```bash
./scripts/symlink/all.sh         # OS-detected: full desktop + terminal
./scripts/symlink/terminal.sh    # tmux + nvim only — safe on shared/work machines
```

Use `terminal.sh` when you don't want to touch someone else's window manager, status bar, or launcher configs (e.g. on a shared Mac, or trying things out on a work laptop). Both back up any existing configs to `<name>.bak` before linking.

---

## What's Included

### macOS

| Config | Location | Description |
|--------|----------|-------------|
| AeroSpace | `config/aerospace/` | Tiling window manager — keybinds, gaps, workspace rules; fires Sketchybar triggers. See [docs/aerospace.md](docs/aerospace.md) |
| Sketchybar | `config/sketchybar/` | Status bar — dynamic workspace indicators with app icons, clock, battery, volume. Font: Monocraft (text) + Hack Nerd Font (glyphs). See [docs/sketchybar.md](docs/sketchybar.md) |

### Hyprland Desktop (Linux)

| Config | Location | Description |
|--------|----------|-------------|
| Hyprland | `config/hypr/` | Window manager (v0.53+), 2560x1440@144hz |
| Waybar | `config/waybar/` | Status bar with VPN + Bluetooth scripts |
| Rofi | `config/rofi/` | App launcher, power menu, WiFi, clipboard, emoji, and more |
| Dunst | `config/dunst/` | Notification daemon |
| Kitty | `config/kitty/` | Terminal emulator |

### Neovim

Config lives at `config/nvim/init.vim`. Uses [vim-plug](https://github.com/junegunn/vim-plug).

**See [docs/nvim.md](docs/nvim.md) for the full keymap cheatsheet and plugin walkthrough.**

**Plugins:**
- `github-nvim-theme` — colorscheme
- `telescope.nvim` — fuzzy finder
- `nvim-lspconfig` + `mason.nvim` — LSP
- `nvim-cmp` — autocompletion
- `conform.nvim` — formatting
- `vimtex` — LaTeX
- `vim-fugitive` — Git
- `toggleterm.nvim` — integrated terminal
- `alpha-nvim` — dashboard

### tmux

Config lives at `config/tmux/tmux.conf`, symlinked to `~/.config/tmux/tmux.conf` (XDG path, tmux 3.1+).

**See [docs/tmux.md](docs/tmux.md) for the full keymap cheatsheet, theme, and settings.**

Highlights: vim-style `Alt-hjkl` pane switching without the prefix, splits inherit cwd, true color, OSC 52 clipboard passthrough, and a status bar themed in the portfolio's lighter blue (`#4aafd4`).

### Fastfetch

Replaces the OS default logo with the portfolio's Braille ASCII logo on every machine, and tints it a different color depending on `$(hostname -s)` — main Mac uses the portfolio accent (`#4aafd4`), homelab/Pi/Linux boxes get their own.

**See [docs/fastfetch.md](docs/fastfetch.md) for the host → color table and how to add new hosts.**

Add this to your shell rc to pick up per-host colors:

```bash
alias fastfetch="$HOME/.config/fastfetch/themed.sh"
```

---

## Directory Structure

```
config/
├── aerospace/   # AeroSpace window manager (macOS)
├── sketchybar/  # Status bar + plugins (macOS)
│   ├── sketchybarrc
│   └── plugins/
│       ├── aerospace.sh   # Workspace visibility, focus highlight, app icon labels
│       ├── app_icon.sh    # App name → Nerd Font glyph lookup
│       ├── app_space.sh   # Standalone icon updater (reference)
│       ├── battery.sh
│       ├── clock.sh
│       ├── front_app.sh
│       ├── space.sh
│       └── volume.sh
├── hypr/        # Hyprland, hyprpaper, hypridle, hyprlock + scripts + wallpapers
├── waybar/      # Bar config, theme, scripts
├── rofi/        # Launcher + all menus
├── dunst/       # Notifications
├── kitty/       # Terminal
├── tmux/
│   └── tmux.conf    # tmux config — see docs/tmux.md
├── fastfetch/
│   ├── config.jsonc # Modules + logo source
│   ├── logo.txt     # Braille ASCII from portfolio
│   └── themed.sh    # Per-host color wrapper — see docs/fastfetch.md
└── nvim/
    └── init.vim     # Single config — see docs/nvim.md

docs/
├── nvim.md       # Neovim cheatsheet & plugin walkthrough
├── tmux.md       # tmux cheatsheet & theme
├── aerospace.md  # AeroSpace WM cheatsheet
├── sketchybar.md # Sketchybar layout, plugins, theming
└── fastfetch.md  # Fastfetch logo + per-host color

scripts/
├── symlink/
│   ├── all.sh                   # Full desktop + terminal (OS-detected)
│   ├── terminal.sh              # tmux + nvim only — safe on shared machines
│   └── _lib.sh                  # Shared link helpers
└── install/
    ├── macos/mac.sh             # Full macOS setup (brew + symlinks)
    ├── hyprland/arch.sh         # Full Arch setup
    └── nvim/                   # Terminal-only installers (no desktop env)
        ├── ubuntu.sh
        ├── debian.sh
        ├── fedora.sh
        ├── arch.sh
        └── nixos.sh
```
