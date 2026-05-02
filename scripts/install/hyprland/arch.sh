#!/usr/bin/env bash
# Install Hyprland + full desktop environment on Arch Linux
# Includes: hyprland, hyprpaper, hypridle, hyprlock, waybar, rofi, dunst, kitty
# Usage: ./scripts/install/hyprland/arch.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

info()    { echo "[INFO]  $*"; }
ok()      { echo "[OK]    $*"; }
err()     { echo "[ERROR] $*" >&2; exit 1; }

# Detect AUR helper
if command -v yay &>/dev/null; then
  AUR="yay"
elif command -v paru &>/dev/null; then
  AUR="paru"
else
  AUR=""
  warn() { echo "[WARN]  $*"; }
  warn "No AUR helper (yay/paru) found. AUR packages will be skipped."
fi

PACMAN_PKGS=(
  hyprland
  hyprpaper
  hypridle
  hyprlock
  waybar
  rofi-wayland
  dunst
  kitty
  tmux
  fastfetch
  clang
  # Dependencies / utilities
  pipewire
  wireplumber
  xdg-desktop-portal-hyprland
  polkit-gnome
  qt5-wayland
  qt6-wayland
  grim
  slurp
  cliphist
  wl-clipboard
  brightnessctl
  playerctl
  network-manager-applet
  blueman
)

info "Installing packages via pacman..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
ok "Pacman packages installed."

if [ -n "$AUR" ]; then
  AUR_PKGS=(
    hyprshot
    wlogout
  )
  info "Installing AUR packages via $AUR..."
  "$AUR" -S --needed --noconfirm "${AUR_PKGS[@]}"
  ok "AUR packages installed."
fi

info "Symlinking configs..."
bash "$DOTFILES_DIR/scripts/symlink/all.sh"

ok "Hyprland setup complete. Log out and select Hyprland from your display manager."
