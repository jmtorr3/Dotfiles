#!/usr/bin/env bash
# Install macOS desktop config: AeroSpace + Sketchybar + Neovim
# Usage: ./scripts/install/macos/mac.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CONFIG_DIR="$HOME/.config"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }
warn() { echo "[WARN]  $*"; }

link_config() {
  local name="$1"
  local src="$DOTFILES_DIR/config/$name"
  local dst="$CONFIG_DIR/$name"

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
)

BREW_CASK_PKGS=(
  aerospace
  skim
)

TAP_PKGS=(
  "FelixKratz/formulae/sketchybar"
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

mkdir -p "$CONFIG_DIR"

link_config aerospace
link_config sketchybar

# Neovim
mkdir -p "$CONFIG_DIR/nvim"
NVIM_SRC="$DOTFILES_DIR/config/nvim/init.vim"
NVIM_DST="$CONFIG_DIR/nvim/init.vim"

if [ -L "$NVIM_DST" ]; then
  rm "$NVIM_DST"
elif [ -f "$NVIM_DST" ]; then
  warn "Backing up existing $NVIM_DST -> ${NVIM_DST}.bak"
  mv "$NVIM_DST" "${NVIM_DST}.bak"
fi

ln -sfn "$NVIM_SRC" "$NVIM_DST"
ok "Linked $NVIM_DST -> $NVIM_SRC"

# --- Make sketchybar plugins executable ---
info "Setting plugin permissions..."
chmod +x "$CONFIG_DIR/sketchybar/plugins/"*.sh
ok "Plugins are executable."

# --- Start services ---
info "Starting sketchybar service..."
brew services start sketchybar
ok "Sketchybar running."

ok "macOS setup complete. Log out and back in (or reboot) for AeroSpace to take effect."
