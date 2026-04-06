# Dotfiles

Personal configuration files for my Hyprland desktop and Neovim setup.

## Setup

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

### Hyprland Desktop

| Config | Location | Description |
|--------|----------|-------------|
| Hyprland | `config/hypr/` | Window manager (v0.53+), 2560x1440@144hz |
| Waybar | `config/waybar/` | Status bar with VPN + Bluetooth scripts |
| Rofi | `config/rofi/` | App launcher, power menu, WiFi, clipboard, emoji, and more |
| Dunst | `config/dunst/` | Notification daemon |
| Kitty | `config/kitty/` | Terminal emulator |

### Neovim

Config lives at `config/nvim/linux/init.vim`. Uses [vim-plug](https://github.com/junegunn/vim-plug).

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
├── hypr/        # Hyprland, hyprpaper, hypridle, hyprlock + scripts + wallpapers
├── waybar/      # Bar config, theme, scripts
├── rofi/        # Launcher + all menus
├── dunst/       # Notifications
├── kitty/       # Terminal
└── nvim/
    ├── linux/   # Linux config (used by install scripts)
    └── macos/   # macOS config

scripts/
├── symlink.sh                   # Symlink all configs to ~/.config/
└── install/
    ├── hyprland/arch.sh         # Full Arch setup
    └── nvim/
        ├── debian.sh
        ├── ubuntu.sh
        └── nixos.sh
```
