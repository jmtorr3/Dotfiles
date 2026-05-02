#!/usr/bin/env bash
# Install Neovim + terminal stack (tmux, fastfetch, clang-format) on Arch.
# Calls the shared symlink script — does NOT touch any desktop env. Safe on a
# headless Arch box / VM. For a full Hyprland desktop, use
# scripts/install/hyprland/arch.sh instead.
#
# Usage: ./scripts/install/nvim/arch.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }

PACMAN_PKGS=(
  neovim
  tmux
  fastfetch
  clang        # provides clang-format
  curl
  git
  zathura
  texlive-binextra   # provides latexmk on modern Arch
)

info "Installing terminal packages via pacman..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
ok "Pacman packages installed."

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

ok "Arch terminal setup complete. Open a new shell, then 'nvim' / 'tmux' / 'fastfetch' to verify."
