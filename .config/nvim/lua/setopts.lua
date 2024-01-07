-- Disable errorbells
vim.o.errorbells     = false

-- Don't follow buffer's directory
vim.o.autochdir = false

-- Hide buffers when abandoned
vim.o.hidden = true

-- Disable backups
vim.o.backup      = false
vim.o.writebackup = false
vim.o.swapfile    = false

-- Search options
vim.o.hlsearch   = false
vim.o.incsearch  = true
vim.o.showmatch  = true
vim.o.ignorecase = true
vim.o.smartcase  = true
vim.o.wrapscan   = true

-- Don't show the previous command
vim.o.showcmd   = false
vim.o.cmdheight = 1

-- Don't wrap lines
vim.o.wrap = false

-- Splits will appear on the right and below
vim.o.splitright = true
vim.o.splitbelow = true

-- Enable relative line numbering
vim.o.number         = true
vim.o.relativenumber = true

-- Display cursor position
vim.o.ruler = true

-- Highlight current line
vim.o.cursorline = true

-- EOL column
vim.o.colorcolumn = "100"

-- Indentation
local indent      = 4
vim.o.tabstop     = indent
vim.o.softtabstop = indent
vim.o.shiftwidth  = indent
vim.o.smarttab    = true

-- Keep cursor away from top or bottom of the screen
vim.o.scrolloff = 8

-- Enable mouse support
vim.o.mouse = "a"

-- Command history
vim.o.history = 100

-- Set global clipboard
vim.o.clipboard = "unnamedplus"

-- Block cursor
vim.cmd("set guicursor=")

-- Completion options
vim.o.completeopt = "menuone,noinsert,noselect"

-- Colorscheme
vim.o.termguicolors             = true
vim.g.gruvbox_italic            = true
vim.g.gruvbox_bold              = true
vim.g.gruvbox_undercurl         = true
vim.g.gruvbox_invert_selection  = false
vim.g.gruvbox_invert_signs      = true
vim.g.gruvbox_improved_warnings = true
vim.g.gruvbox_contrast_dark     = "medium"
vim.cmd("colorscheme gruvbox")
