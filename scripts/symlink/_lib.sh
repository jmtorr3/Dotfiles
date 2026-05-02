#!/usr/bin/env bash
# Shared symlink helpers. Sourced by sibling scripts.

CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

info() { echo "[INFO]  $*"; }
ok()   { echo "[OK]    $*"; }
warn() { echo "[WARN]  $*"; }

# link_config <name>
# Symlinks $DOTFILES_DIR/config/<name> -> ~/.config/<name>.
# Backs up any pre-existing real file/dir to <name>.bak.
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

# link_nvim
# Neovim uses a single init.vim, so we link the file rather than the directory.
link_nvim() {
  local src="$DOTFILES_DIR/config/nvim/init.vim"
  local dst="$CONFIG_DIR/nvim/init.vim"

  mkdir -p "$CONFIG_DIR/nvim"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ]; then
    warn "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi

  ln -sfn "$src" "$dst"
  ok "Linked $dst -> $src"
}

# link_clang_format
# Symlinks the Linux-kernel-style .clang-format to ~/.clang-format. clang-format
# walks parent dirs looking for a .clang-format file, so the home-dir copy is
# the lowest-priority fallback — any project with its own .clang-format wins.
link_clang_format() {
  local src="$DOTFILES_DIR/config/clang-format/linux-kernel.clang-format"
  local dst="$HOME/.clang-format"

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

# clean_legacy_tmux
# Removes ~/.tmux.conf so tmux uses the XDG path at ~/.config/tmux/tmux.conf.
clean_legacy_tmux() {
  local legacy="$HOME/.tmux.conf"
  if [ -L "$legacy" ]; then
    rm "$legacy"
    ok "Removed legacy symlink $legacy (now using XDG path)"
  elif [ -f "$legacy" ]; then
    warn "Backing up legacy $legacy -> ${legacy}.bak"
    mv "$legacy" "${legacy}.bak"
  fi
}
