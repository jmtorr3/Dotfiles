#!/usr/bin/env bash
# Install Neovim on Debian and symlink config
# Downloads latest stable release from GitHub (apt version is too old)
# Usage: ./scripts/install/nvim/debian.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
NVIM_CONFIG_SRC="$DOTFILES_DIR/config/nvim/linux/init.vim"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }
err()  { echo "[ERROR] $*" >&2; exit 1; }

command -v curl &>/dev/null || sudo apt-get install -y curl
command -v git  &>/dev/null || sudo apt-get install -y git

info "Installing Neovim (latest stable) from GitHub releases..."

NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
INSTALL_DIR="$HOME/.local"

mkdir -p "$INSTALL_DIR"
curl -L "$NVIM_URL" | tar -xz -C "$INSTALL_DIR" --strip-components=1
ok "Neovim $NVIM_VERSION installed to $INSTALL_DIR/bin/nvim"

# Ensure ~/.local/bin is on PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  info "Adding ~/.local/bin to PATH in ~/.bashrc"
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  export PATH="$HOME/.local/bin:$PATH"
fi

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
"$INSTALL_DIR/bin/nvim" --headless +PlugInstall +qall 2>/dev/null || true
ok "Plugins installed."

ok "Neovim setup complete. Run 'nvim' to get started."
