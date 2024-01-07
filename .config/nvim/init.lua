-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--depth=1",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- ==================
--  General settings
-- ==================

-- Disable errorbells
vim.o.errorbells = false

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
vim.cmd [[set guicursor=]]

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
vim.cmd [[colorscheme gruvbox]]

-- ==================
--  Basic keymaps
-- ==================

-- Shift text in visual mode
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

-- Shift current selection up or down with indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy text until EOL
vim.keymap.set("n", "Y", "yg_", { noremap = true })

-- Directory tree
vim.keymap.set("n", "<C-n>", ":NERDTreeToggle<CR>", { noremap = true })

-- Buffer controls
vim.keymap.set("n", "<C-k>", ":bn<CR>", { noremap = true })
vim.keymap.set("n", "<C-j>", ":bp<CR>", { noremap = true })
vim.keymap.set("n", "<C-x>", ":bd<CR>", { noremap = true })

-- Highlight text on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- ==================
--  Plugin settings
-- ==================

vim.g.rooter_patterns = {".git"}

-- NERDTree
vim.g.NERDTreeIgnore = {
	"egg-info$",
	"^env$",
	"^venv$",
	"__pycache__",
	".pytest_cache",
}
vim.g.NERDTreeDirArrowExpandable = "~"
vim.g.NERDTreeDirArrowCollapsible = "$"
