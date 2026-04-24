#!/usr/bin/env bash
# Install Neovim on NixOS and copy config
# Uses nix-env (imperative) — run as your regular user, not root
# Usage: ./scripts/install/nvim/nixos.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
NVIM_CONFIG_SRC="$DOTFILES_DIR/config/nvim/init.vim"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }

command -v nix-env &>/dev/null || { echo "[ERROR] nix-env not found. Are you on NixOS?"; exit 1; }

info "Installing neovim via nix-env..."
nix-env -iA nixpkgs.neovim nixpkgs.curl nixpkgs.git
ok "Neovim installed: $(nvim --version | head -1)"

info "Installing LaTeX tooling (zathura, texlive with latexmk)..."
nix-env -iA nixpkgs.zathura nixpkgs.texlive.combined.scheme-medium
ok "LaTeX tooling installed."

info "Installing vim-plug..."
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ok "vim-plug installed."

info "Copying nvim config to ~/.config/nvim/init.vim..."
mkdir -p "$HOME/.config/nvim"
cp "$NVIM_CONFIG_SRC" "$HOME/.config/nvim/init.vim"
ok "Config copied."

info "Installing plugins (headless)..."
nvim --headless +PlugInstall +qall 2>/dev/null || true
ok "Plugins installed."

ok "Neovim setup complete. Run 'nvim' to get started."
