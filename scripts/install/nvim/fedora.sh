#!/usr/bin/env bash
# Install Neovim + terminal stack (tmux, fastfetch, clang-format) on Fedora.
# Calls the shared symlink script — does NOT touch any desktop env. Safe on
# a server / VM.
#
# Usage: ./scripts/install/nvim/fedora.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }
warn() { echo "[WARN]  $*"; }

# --- Prereqs ---
command -v curl &>/dev/null || sudo dnf install -y curl
command -v git  &>/dev/null || sudo dnf install -y git

# --- Core terminal stack (these MUST install or the setup is broken) ---
CORE_PKGS=(
  neovim
  tmux
  clang-tools-extra   # provides clang-format
)

info "Installing core terminal packages from dnf..."
sudo dnf install -y "${CORE_PKGS[@]}"
ok "Core packages installed."

# --- Optional packages (don't abort the script if any are missing) ---
install_optional() {
  local pkg="$1"
  if sudo dnf install -y "$pkg" 2>/dev/null; then
    ok "$pkg installed."
  else
    warn "$pkg not available on this Fedora release — skipping."
  fi
}

info "Installing optional packages..."
install_optional fastfetch
install_optional zathura
install_optional texlive-latexmk

# --- vim-plug ---
info "Installing vim-plug..."
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ok "vim-plug installed."

# --- Symlink configs (nvim + tmux + fastfetch + ~/.clang-format) ---
info "Symlinking terminal configs..."
bash "$DOTFILES_DIR/scripts/symlink/terminal.sh"

# --- Plugins ---
info "Installing nvim plugins (headless)..."
nvim --headless +PlugInstall +qall 2>/dev/null || true
ok "Plugins installed."

ok "Fedora setup complete. Open a new shell, then 'nvim' / 'tmux' / 'fastfetch' to verify."
