# Dotfiles

Personal configuration files for Neovim, Hyprland (Linux), and macOS (AeroSpace + Sketchybar).

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

### Neovim Only

**Ubuntu:**
```bash
./scripts/install/nvim/ubuntu.sh
```

**Debian:**
```bash
./scripts/install/nvim/debian.sh
```

**NixOS:**
```bash
./scripts/install/nvim/nixos.sh
```

### Just Symlink Configs

If packages are already installed and you just want to wire up the configs:

```bash
./scripts/symlink.sh
```

Backs up any existing configs to `<name>.bak` before linking.

---

## What's Included

### macOS

| Config | Location | Description |
|--------|----------|-------------|
| AeroSpace | `config/aerospace/` | Tiling window manager — keybinds, gaps, workspace rules; fires Sketchybar triggers |
| Sketchybar | `config/sketchybar/` | Status bar — dynamic workspace indicators with app icons, clock, battery, volume. Font: Monocraft (text) + Hack Nerd Font (glyphs) |

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

**See [NVIM.md](NVIM.md) for the full keymap cheatsheet and plugin walkthrough.**

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
└── nvim/
    └── init.vim   # Single config — see NVIM.md

scripts/
├── symlink.sh                   # Symlink all configs to ~/.config/
└── install/
    ├── macos/mac.sh             # Full macOS setup (brew + symlinks)
    ├── hyprland/arch.sh         # Full Arch setup
    └── nvim/
        ├── debian.sh
        ├── ubuntu.sh
        └── nixos.sh
```
