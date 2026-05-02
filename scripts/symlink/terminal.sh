#!/usr/bin/env bash
# Symlink terminal-only configs: tmux + Neovim.
# Safe to run on shared machines — does NOT touch window manager, status bar,
# launcher, or any other desktop environment configs.
#
# Usage: ./scripts/symlink/terminal.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$DOTFILES_DIR/scripts/symlink/_lib.sh"

info "Symlinking terminal configs from $DOTFILES_DIR"

link_config tmux
clean_legacy_tmux
link_config fastfetch
link_nvim
link_clang_format

info "Done. Terminal configs symlinked."
