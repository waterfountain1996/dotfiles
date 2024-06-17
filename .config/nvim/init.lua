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

require("setopts")
require("remaps")

-- Highlight text on yank
local augroup = vim.api.nvim_create_augroup
local highlight_group = augroup("YankHighlight", { clear = true })
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

-- vim: ts=2 sts=2 sw=2
