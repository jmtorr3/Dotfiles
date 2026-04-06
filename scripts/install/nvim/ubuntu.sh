#!/usr/bin/env bash
# Install Neovim on Ubuntu via PPA and symlink config
# Usage: ./scripts/install/nvim/ubuntu.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
NVIM_CONFIG_SRC="$DOTFILES_DIR/config/nvim/linux/init.vim"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }

info "Adding neovim-ppa/unstable PPA..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim curl git
ok "Neovim installed: $(nvim --version | head -1)"

info "Installing vim-plug..."
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" \
  --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ok "vim-plug installed."

info "Symlinking nvim config..."
mkdir -p "$HOME/.config/nvim"
NVIM_DST="$HOME/.config/nvim/init.vim"
[ -L "$NVIM_DST" ] && rm "$NVIM_DST"
[ -f "$NVIM_DST" ] && mv "$NVIM_DST" "${NVIM_DST}.bak"
ln -sfn "$NVIM_CONFIG_SRC" "$NVIM_DST"
ok "Config linked: $NVIM_DST"

info "Installing plugins (headless)..."
nvim --headless +PlugInstall +qall 2>/dev/null || true
ok "Plugins installed."

ok "Neovim setup complete. Run 'nvim' to get started."
