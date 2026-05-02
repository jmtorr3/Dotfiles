#!/usr/bin/env bash
# Install Neovim + terminal stack (tmux, fastfetch, clang-format) on Debian.
# Neovim is downloaded from the GitHub release because Debian's apt nvim is
# usually too old. Everything else comes from apt. Calls the shared symlink
# script — does NOT touch any desktop env.
#
# Usage: ./scripts/install/nvim/debian.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }
warn() { echo "[WARN]  $*"; }

# --- Prereqs ---
command -v curl &>/dev/null || sudo apt-get install -y curl
command -v git  &>/dev/null || sudo apt-get install -y git

# --- Apt-installed terminal tools ---
APT_PKGS=(
  tmux
  clang-format
  zathura
  latexmk
)

info "Installing terminal packages from apt..."
sudo apt-get install -y "${APT_PKGS[@]}"
ok "Terminal packages installed."

# fastfetch landed in Debian 13 (trixie). On older Debian, download the .deb.
info "Installing fastfetch..."
if sudo apt-get install -y fastfetch 2>/dev/null; then
  ok "fastfetch installed via apt."
else
  warn "fastfetch not in apt on this Debian version. Install manually:"
  warn "  https://github.com/fastfetch-cli/fastfetch/releases (download the .deb)"
fi

# --- Neovim (latest stable from GitHub) ---
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
"$INSTALL_DIR/bin/nvim" --headless +PlugInstall +qall 2>/dev/null || true
ok "Plugins installed."

ok "Debian setup complete. Open a new shell, then 'nvim' / 'tmux' / 'fastfetch' to verify."
