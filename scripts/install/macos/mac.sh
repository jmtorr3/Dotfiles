#!/usr/bin/env bash
# Install macOS desktop config: AeroSpace + Sketchybar + tmux + Neovim
# Usage: ./scripts/install/macos/mac.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "$DOTFILES_DIR/scripts/symlink/_lib.sh"

# --- Homebrew check ---
if ! command -v brew &>/dev/null; then
  info "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ok "Homebrew installed."
fi

# --- Packages ---
BREW_PKGS=(
  neovim
  curl
  git
  latexmk
  tmux
  fastfetch
  clang-format
)

BREW_CASK_PKGS=(
  aerospace
  skim
)

info "Updating Homebrew..."
brew update

info "Installing brew packages..."
brew install "${BREW_PKGS[@]}"
ok "Core packages installed."

info "Tapping FelixKratz/formulae for sketchybar..."
brew tap FelixKratz/formulae
info "Installing sketchybar..."
brew install sketchybar
ok "Sketchybar installed."

info "Installing AeroSpace (cask)..."
brew install --cask "${BREW_CASK_PKGS[@]}"
ok "AeroSpace installed."

# --- vim-plug ---
info "Installing vim-plug..."
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ok "vim-plug installed."

# --- Symlink configs ---
info "Symlinking configs..."
bash "$DOTFILES_DIR/scripts/symlink/all.sh"

# --- Make sketchybar plugins executable ---
info "Setting plugin permissions..."
chmod +x "$DOTFILES_DIR/config/sketchybar/plugins/"*.sh
ok "Plugins are executable."

# --- Start services ---
info "Starting sketchybar service..."
brew services start sketchybar
ok "Sketchybar running."

ok "macOS setup complete. Log out and back in (or reboot) for AeroSpace to take effect."
