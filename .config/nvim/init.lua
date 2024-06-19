-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable 24-bit colors
vim.opt.termguicolors = true

-- Don't change directory
vim.opt.autochdir = false

-- Disable backups
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Search options
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- Don't show current mode because we have lualine
vim.opt.showmode = false

-- Don't show the previous command
vim.opt.showcmd = false
vim.opt.cmdheight = 1

-- Splits will appear on the right and below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Display cursor position
vim.opt.ruler = true

-- EOL column
vim.opt.colorcolumn = "100"

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Highlight current line
vim.opt.cursorline = true

-- Disable line wrapping
vim.opt.wrap = false

-- Configure indentation
local indent = 4
vim.opt.tabstop = indent
vim.opt.softtabstop = indent
vim.opt.shiftwidth = indent
vim.opt.smarttab = true

-- Keep cursor away from top or bottom of the screen
vim.opt.scrolloff = 10

-- Set command history
vim.opt.history = 100

-- Use block cursor in every mode
vim.cmd([[set guicursor=]])

-- Completion options
vim.opt.completeopt = "menuone,noinsert,noselect"

-- Highlight text when copying
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight text when copying",
	group = vim.api.nvim_create_augroup("TextHighlightYank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end
})

-- Shift text in visual mode
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

-- Shift current selection up or down with indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy text until EOL
vim.keymap.set("n", "Y", "yg_", { noremap = true })

-- Buffer controls
vim.keymap.set("n", "<C-k>", ":bn<CR>", { noremap = true })
vim.keymap.set("n", "<C-j>", ":bp<CR>", { noremap = true })
vim.keymap.set("n", "<C-x>", ":bd<CR>", { noremap = true })

-- Load plugins
require("lazy").setup("plugins")

-- vim: ts=2 sts=2 sw=2
