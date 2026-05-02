#!/usr/bin/env bash
# Install Neovim + terminal stack (tmux, fastfetch, clang-format) on Ubuntu.
# Symlinks all terminal configs via scripts/symlink/terminal.sh — does NOT
# touch any desktop env. Safe on a server / VM.
#
# Usage: ./scripts/install/nvim/ubuntu.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }
warn() { echo "[WARN]  $*"; }

# --- Neovim PPA (apt's stock nvim is usually too old) ---
info "Adding neovim-ppa/unstable PPA..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update

# --- Core terminal stack ---
APT_PKGS=(
  neovim
  tmux
  clang-format
  curl
  git
  zathura
  latexmk
)

info "Installing core packages..."
sudo apt-get install -y "${APT_PKGS[@]}"
ok "Core packages installed."

# fastfetch is in Ubuntu 24.04+ apt; older releases need a manual install.
info "Installing fastfetch..."
if sudo apt-get install -y fastfetch 2>/dev/null; then
  ok "fastfetch installed via apt."
else
  warn "fastfetch not in apt on this Ubuntu version. Install manually:"
  warn "  https://github.com/fastfetch-cli/fastfetch/releases (download the .deb)"
fi

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

ok "Ubuntu setup complete. Open a new shell, then 'nvim' / 'tmux' / 'fastfetch' to verify."
