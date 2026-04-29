# Neovim Config

A documented walkthrough of this Neovim setup — every keybind, every plugin, what does what.

Config lives at [`config/nvim/init.vim`](config/nvim/init.vim). It's a single Vimscript file with embedded `lua` blocks. Plugins are managed with [vim-plug](https://github.com/junegunn/vim-plug).

- **Leader:** `<Space>`
- **LocalLeader:** `\` (used by vimtex)

## Install

```bash
./scripts/install/nvim/ubuntu.sh   # or debian.sh / nixos.sh
```

On macOS, `./scripts/install/macos/mac.sh` handles Neovim along with the rest of the desktop. After install, open Neovim and run `:PlugInstall`.

---

## Keymap Cheatsheet

### Tabs

| Keys | Action |
|---|---|
| `<leader>tn` | New tab |
| `<leader>tc` | Close current tab |
| `<leader>to` | Close all other tabs |
| `<leader>H` | Previous tab |
| `<leader>L` | Next tab |
| `<leader><Left>` | Move tab left |
| `<leader><Right>` | Move tab right |

Every new tab opens the Alpha dashboard automatically.

### File Explorer (Neo-tree)

| Keys | Action |
|---|---|
| `<leader>e` | Toggle Neo-tree sidebar |

Neo-tree shows hidden files (dotfiles included), follows the file you're currently editing, and closes itself if it's the last window.

### Fuzzy Finder (Telescope)

| Keys | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep across project |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Search help tags |
| `<leader>fr` | Recent files (all) |
| `<leader>fR` | Recent files (current cwd only) |
| `<leader>fa` | Open Alpha dashboard |

### Terminal (toggleterm)

The default toggle is `<C-\>` (Ctrl+Backslash). Always opens floating with curved borders by default.

| Keys | Action |
|---|---|
| `<C-\>` | Toggle last terminal |
| `<leader>tt` | Toggle terminal |
| `<leader>tf` | Floating terminal |
| `<leader>th` | Horizontal split terminal (size 12) |
| `<leader>tv` | Vertical split terminal (size 60) |

Inside a terminal:

| Keys | Action |
|---|---|
| `<Esc>` | Exit terminal mode → Normal |
| `<C-h/j/k/l>` | Jump to window left/down/up/right |

### LSP

Active servers: `lua_ls`, `pyright`, `ts_ls`, `clangd`. Configured via the new `vim.lsp.config` API (no `require('lspconfig')` calls).

| Keys | Action |
|---|---|
| `gd` | Goto definition |
| `gD` | Goto declaration |
| `gr` | Find references |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>ld` | Show line diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Completion (nvim-cmp)

| Keys | Action |
|---|---|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` | Next item / expand snippet / jump |
| `<S-Tab>` | Previous item / jump back |

Sources: LSP, LuaSnip, buffer, path. Snippets from `friendly-snippets`.

### Formatting (Conform)

Formats on save automatically. Manual format:

| Keys | Action |
|---|---|
| `<leader>lf` | Format buffer (or visual selection) |

Formatters by filetype:

| Filetype | Formatter |
|---|---|
| `tex` | `latexindent` |
| `lua` | `stylua` |
| `python` | `black` |
| `javascript`, `typescript` | `prettier` |

### Treesitter

Incremental selection — start with `gnn`, then expand/shrink:

| Keys | Action |
|---|---|
| `gnn` | Init selection |
| `grn` | Expand by node |
| `grc` | Expand by scope |
| `grm` | Shrink |

Text objects (work with `d`, `y`, `c`, `v`, etc.):

| Keys | Selects |
|---|---|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |

Folding uses Treesitter expressions. Default fold level is 99 (everything open).

### Spellcheck

Auto-enabled for `markdown`, `tex`, and `text` filetypes.

| Keys | Action |
|---|---|
| `<leader>ss` | Toggle spellcheck in current buffer |

### LaTeX (vimtex)

PDF viewer is auto-detected: **Skim** on macOS, **Zathura** elsewhere. Compiler is `latexmk`. Default vimtex mappings are enabled — see `:help vimtex-default-mappings`. Common ones:

| Keys | Action |
|---|---|
| `<localleader>ll` | Start/stop continuous compilation |
| `<localleader>lv` | Forward search to PDF |
| `<localleader>lc` | Clean aux files |
| `<localleader>lk` | Stop compilation |

(`<localleader>` is `\`.)

### Clipboard

Uses the system clipboard by default (`unnamedplus`). Over SSH, an OSC 52 provider kicks in so yanks copy back to the local machine's clipboard.

---

## Plugins

| Plugin | What it does |
|---|---|
| [`github-nvim-theme`](https://github.com/projekt0n/github-nvim-theme) | Colorscheme — `github_dark_default` |
| [`neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer sidebar |
| [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder with `fzf-native` for speed |
| [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) + [`mason.nvim`](https://github.com/williamboman/mason.nvim) | LSP setup + server installer |
| [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) + LuaSnip | Completion + snippets |
| [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) | Better syntax, motions, folds |
| [`conform.nvim`](https://github.com/stevearc/conform.nvim) | Format-on-save |
| [`vimtex`](https://github.com/lervag/vimtex) | LaTeX editing |
| [`vim-fugitive`](https://github.com/tpope/vim-fugitive) | Git inside Neovim (`:Git`, `:Gblame`, etc.) |
| [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) | Git change indicators in the gutter |
| [`toggleterm.nvim`](https://github.com/akinsho/toggleterm.nvim) | Integrated terminals (float / horizontal / vertical) |
| [`alpha-nvim`](https://github.com/goolord/alpha-nvim) | Custom start dashboard |
| [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [`Comment.nvim`](https://github.com/numToStr/Comment.nvim) | `gcc` / `gc{motion}` to comment lines |
| [`indent-blankline.nvim`](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |

### Comment.nvim quick reference

| Keys | Action |
|---|---|
| `gcc` | Toggle current line comment |
| `gc{motion}` | Comment a motion (e.g. `gcap` paragraph) |
| `gc` (visual) | Toggle selection |

---

## Alpha Dashboard

Custom ASCII header with a blue (`#34abeb`) highlight. Shortcuts on the dashboard:

| Key | Action |
|---|---|
| `f` | Find file |
| `g` | Live grep |
| `r` | Recent files |
| `n` | New file |
| `c` | Edit `$MYVIMRC` |
| `q` | Quit |

The dashboard re-opens automatically on every new tab.

---

## File Layout

```
config/nvim/
└── init.vim     # Everything — settings, plugins, keymaps, Lua setup
```

A single `init.vim` keeps the config easy to copy onto a new machine. All Lua configuration lives inside `lua << EOF ... EOF` blocks within it.
