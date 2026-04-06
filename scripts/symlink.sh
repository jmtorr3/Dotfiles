#!/usr/bin/env bash
# Symlink all dotfile configs to ~/.config/
# Usage: ./scripts/symlink.sh
# Safe to run multiple times (idempotent)

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

info()  { echo "[INFO]  $*"; }
ok()    { echo "[OK]    $*"; }
warn()  { echo "[WARN]  $*"; }

link_config() {
  local src="$DOTFILES_DIR/config/$1"
  local dst="$CONFIG_DIR/$1"

  if [ ! -e "$src" ]; then
    warn "Source not found, skipping: $src"
    return
  fi

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    warn "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -sfn "$src" "$dst"
  ok "Linked $dst -> $src"
}

info "Symlinking configs from $DOTFILES_DIR"

# Hyprland + ecosystem
link_config hypr
link_config waybar
link_config rofi
link_config dunst
link_config kitty

# Neovim
mkdir -p "$CONFIG_DIR/nvim"
NVIM_SRC="$DOTFILES_DIR/config/nvim/linux/init.vim"
NVIM_DST="$CONFIG_DIR/nvim/init.vim"

if [ -L "$NVIM_DST" ]; then
  rm "$NVIM_DST"
elif [ -f "$NVIM_DST" ]; then
  warn "Backing up existing $NVIM_DST -> ${NVIM_DST}.bak"
  mv "$NVIM_DST" "${NVIM_DST}.bak"
fi

ln -sfn "$NVIM_SRC" "$NVIM_DST"
ok "Linked $NVIM_DST -> $NVIM_SRC"

info "Done. All configs symlinked."
