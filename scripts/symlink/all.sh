#!/usr/bin/env bash
# Symlink all dotfile configs to ~/.config/.
# OS-detected: macOS gets aerospace + sketchybar; Linux gets the Hyprland stack.
# Terminal configs (tmux, nvim) are always linked.
#
# Usage: ./scripts/symlink/all.sh
# Safe to run multiple times (idempotent).

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$DOTFILES_DIR/scripts/symlink/_lib.sh"

OS="$(uname)"

info "Symlinking all configs from $DOTFILES_DIR"

if [[ "$OS" == "Darwin" ]]; then
  # macOS desktop
  link_config aerospace
  link_config sketchybar
else
  # Linux desktop (Hyprland)
  link_config hypr
  link_config waybar
  link_config rofi
  link_config dunst
  link_config kitty
fi

# Terminal (shared across OSes)
link_config tmux
clean_legacy_tmux
link_nvim

info "Done. All configs symlinked."
