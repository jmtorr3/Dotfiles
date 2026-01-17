" =============================
" Basic settings
" =============================
set number
syntax on
set mouse=a
set clipboard=unnamedplus
set termguicolors

" Use space as <leader>, backslash as <localleader> (vimtex uses this)
let mapleader = " "
let maplocalleader = "\\"

" =============================
" Vimtex settings (macOS)
" =============================
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_method = 'latexmk'
" optional: keep vimtex mappings on (default is 1)
let g:vimtex_mappings_enabled = 1

" =============================
" Plugins (vim-plug)
" =============================
call plug#begin('~/.config/nvim/plugged')
  " Theme & git
  Plug 'projekt0n/github-nvim-theme'
  Plug 'tpope/vim-fugitive'

  " LaTeX
  Plug 'lervag/vimtex'

  " Formatter
  Plug 'stevearc/conform.nvim'   " Conform.nvim for formatting

  " Telescope + deps
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " optional speed-up

  " Start screen
  Plug 'goolord/alpha-nvim'
  Plug 'nvim-tree/nvim-web-devicons' " optional, for icons (use a Nerd Font)

  " Terminals inside Neovim
  Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }

  " --- Core dev goodies ---

  " LSP + installer (Mason is still installed, but config below does NOT depend on it)
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'neovim/nvim-lspconfig'

  " Completion + snippets
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'rafamadriz/friendly-snippets'

  " Tree-sitter (better syntax & motions)
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'

  " Statusline, git signs, commenting
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'numToStr/Comment.nvim'
call plug#end()

" =============================
" Spellcheck
" =============================

" Enable spell check for writing filetypes
augroup SpellForWriting
  autocmd!
  autocmd FileType markdown,tex,text setlocal spell spelllang=en_us
augroup END

" Easy toggle in any buffer
nnoremap <silent> <leader>ss :setlocal spell! spell?<CR>

" =============================
" Telescope setup & keymaps
" =============================
lua << EOF
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  telescope.setup({})
  pcall(telescope.load_extension, "fzf")  -- loads if built
end
EOF

nnoremap <silent> <leader>ff <cmd>Telescope find_files<CR>
nnoremap <silent> <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <silent> <leader>fb <cmd>Telescope buffers<CR>
nnoremap <silent> <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <silent> <leader>fr <cmd>Telescope oldfiles<CR>
nnoremap <silent> <leader>fR <cmd>Telescope oldfiles cwd_only=true<CR>

" Alpha keymap (open dashboard any time)
nnoremap <silent> <leader>fa :Alpha<CR>

" =============================
" toggleterm setup & keymaps
" =============================
lua << EOF
local ok_toggleterm, toggleterm = pcall(require, "toggleterm")
if ok_toggleterm then
  toggleterm.setup({
    size = 12,
    open_mapping = [[<c-\>]],        -- Ctrl+\ toggles last terminal
    start_in_insert = true,
    shade_terminals = true,
    persist_mode = false,            -- always enter insert in terminal
    direction = 'float',             -- default to a floating terminal
    float_opts = { border = 'curved' }
  })
end
EOF

" Quick terminal toggles
nnoremap <silent> <leader>tt :ToggleTerm<CR>
nnoremap <silent> <leader>tf :ToggleTerm direction=float<CR>
nnoremap <silent> <leader>th :ToggleTerm direction=horizontal size=12<CR>
nnoremap <silent> <leader>tv :ToggleTerm direction=vertical size=60<CR>

" Better terminal-mode navigation (Esc to Normal; move between windows)
tnoremap <Esc>   <C-\><C-n>
tnoremap <C-h>   <C-\><C-n><C-w>h
tnoremap <C-j>   <C-\><C-n><C-w>j
tnoremap <C-k>   <C-\><C-n><C-w>k
tnoremap <C-l>   <C-\><C-n><C-w>l

" =============================
" Conform.nvim setup (formatting)
" =============================
lua << EOF
local ok, conform = pcall(require, 'conform')
if not ok then
  vim.notify('Conform.nvim not found', vim.log.levels.WARN)
else
  conform.setup({
    formatters_by_ft = {
      tex = { 'latexindent' },
      lua = { 'stylua' },
      python = { 'black' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 2000,
    },
    formatters = {
      latexindent = {
        command = "latexindent.pl",
        prepend_args = { '-m', '-l' }, -- keep comments; use .latexindent.yaml if present
        -- If latexindent is in a non-standard path, uncomment and set:
        -- command = '/usr/local/texlive/2025/bin/universal-darwin/latexindent',
      },
    },
  })

  -- Manual format keymap: <leader>lf (normal & visual)
  vim.keymap.set({ 'n', 'v' }, '<leader>lf', function()
    conform.format({ async = true, lsp_fallback = true })
  end, { desc = 'Format with Conform' })

  -- Warn once if latexindent isn't on PATH
  if vim.fn.executable('latexindent') ~= 1 then
    vim.defer_fn(function()
      vim.notify('latexindent not found on PATH. Install Tex Live or add it to PATH.', vim.log.levels.WARN)
    end, 800)
  end
end
EOF

" =============================
" Treesitter (syntax, textobjects, folding)
" =============================
lua << EOF
local ok_ts, configs = pcall(require, "nvim-treesitter.configs")
if ok_ts then
  configs.setup({
    ensure_installed = {
      "lua", "python", "javascript", "typescript",
      "c", "cpp", "markdown", "bash"
      -- "latex", -- enable this only if you install the tree-sitter CLI
    },
    ignore_install = { "latex" }, -- avoid latex requiring tree-sitter CLI
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  })
end
EOF

" Use Treesitter-based folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=99

" =============================
" LSP (new vim.lsp.config API, no require('lspconfig'))
" =============================
lua << EOF
-- Shared on_attach for all servers
local on_attach = function(_, bufnr)
  local nmap = function(lhs, rhs, desc)
    if desc then desc = "LSP: " .. desc end
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Standard LSP keymaps
  nmap("gd", vim.lsp.buf.definition, "Goto definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto declaration")
  nmap("gr", vim.lsp.buf.references, "Goto references")
  nmap("K",  vim.lsp.buf.hover, "Hover docs")
  nmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
  nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
  nmap("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
  nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
end

-- Capabilities for nvim-cmp completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Default config for ALL servers
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Extra tweaks for lua_ls only
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

-- Enable the servers you actually want
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "ts_ls",   -- new name instead of tsserver
  "clangd",
})
EOF

" =============================
" nvim-cmp (completion) + LuaSnip
" =============================
lua << EOF
local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then
  return
end

local luasnip_ok, luasnip = pcall(require, "LuaSnip")
if luasnip_ok then
  require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
end

cmp.setup({
  snippet = {
    expand = function(args)
      if luasnip_ok then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip_ok and luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip_ok and luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})
EOF

" =============================
" Statusline, Git signs, Comment.nvim
" =============================
lua << EOF
pcall(function()
  require("lualine").setup({
    options = {
      theme = "auto",
      icons_enabled = true,
      section_separators = "",
      component_separators = "",
    },
  })
end)

pcall(function()
  require("gitsigns").setup()
end)

pcall(function()
  require("Comment").setup()
end)
EOF

" =============================
" alpha-nvim setup
" =============================
lua << EOF
local ok_alpha, alpha = pcall(require, "alpha")
if not ok_alpha then
  return
end

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  [[                                                                         ]],
  [[                               :                                         ]],
  [[ L.                     ,;    t#,                                        ]],
  [[ EW:        ,ft       f#i    ;##W.              t                        ]],
  [[ E##;       t#E     .E#t    :#L:WE              Ej            ..       : ]],
  [[ E###t      t#E    i#W,    .KG  ,#D  t      .DD.E#,          ,W,     .Et ]],
  [[ E#fE#f     t#E   L#D.     EE    ;#f EK:   ,WK. E#t         t##,    ,W#t ]],
  [[ E#t D#G    t#E :K#Wfff;  f#.     t#iE#t  i#D   E#t        L###,   j###t ]],
  [[ E#t  f#E.  t#E i##WLLLLt :#G     GK E#t j#f    E#t      .E#j##,  G#fE#t ]],
  [[ E#t   t#K: t#E  .E#L      ;#L   LW. E#tL#i     E#t     ;WW; ##,:K#i E#t ]],
  [[ E#t    ;#W,t#E    f#E:     t#f f#:  E#WW,      E#t    j#E.  ##f#W,  E#t ]],
  [[ E#t     :K#D#E     ,WW;     f#D#;   E#K:       E#t  .D#L    ###K:   E#t ]],
  [[ E#t      .E##E      .D#;     G#t    ED.        E#t :K#t     ##D.    E#t ]],
  [[ ..         G#E        tt      t     t          E#t ...      #G      ..  ]],
  [[             fE                                 ,;.          j           ]],
  [[              ,                                                          ]],
  [[                                                                         ]],
}

-- color the whole header via a highlight group
dashboard.section.header.opts.hl = "AlphaHeader"

dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
  dashboard.button("g", "  Live grep", ":Telescope live_grep<CR>"),
  dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("n", "  New file", ":enew<CR>"),
  dashboard.button("c", "  Config", ":edit $MYVIMRC<CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.config)
EOF

" =============================
" Colorscheme
" =============================
colorscheme github_dark_default

" =============================
" Alpha header color (#34abeb)
" =============================
lua << EOF
vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#34abeb", bold = true })
EOF

augroup AlphaHeaderHL
  autocmd!
  autocmd ColorScheme * lua vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#34abeb", bold = true })
augroup END


