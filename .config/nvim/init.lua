-- Set language to English regardless of the current locale.
vim.cmd("language en_US")

-- Bootstrap lazy.nvim.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg", },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Map leader key before loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable 24-bit colors.
vim.opt.termguicolors = true

-- Don't change directory.
vim.opt.autochdir = false

-- Disable backups.
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Search options.
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- Don't show current mode because we have lualine.
vim.opt.showmode = false

-- Don't show the previous command.
vim.opt.showcmd = false
vim.opt.cmdheight = 1

-- Configure indentation.
local indent = 4
vim.opt.tabstop = indent
vim.opt.softtabstop = indent
vim.opt.shiftwidth = indent
vim.opt.smarttab = true

-- Show (relative) line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight current line.
vim.opt.cursorline = true

-- Display cursor position.
vim.opt.ruler = true

-- Disable line wrapping.
vim.opt.wrap = false

-- End of line marker.
vim.opt.colorcolumn = "100"

-- Keep cursor away from top or bottom of the screen.
vim.opt.scrolloff = 10

-- Splits will appear on the right and below.
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Use system clipboard.
vim.opt.clipboard = "unnamedplus"

-- Use block cursor in every mode.
vim.cmd("set guicursor=")

-- Set command history.
vim.opt.history = 100

-- TODO: Do we need them?
-- Completion options.
vim.opt.completeopt = "menuone,noinsert,noselect"

-- Highlight text when yanking.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Shift text in visual mode.
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<", "<gv", { noremap = true })

-- Shift current selection up or down with indentation.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Copy text until EOL.
vim.keymap.set("n", "Y", "yg_", { noremap = true })

vim.filetype.add({
  extension = {
    tmpl = "gotmpl",
  },
})

-- Lazy-load plugins.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  }
})

-- Enable LSP servers
vim.lsp.enable({ "clangd", "gopls", "lua_ls", "pyright", "ts_ls", "rust_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local mapkey = function(keys, func)
      vim.keymap.set("n", keys, func, {
        buffer = args.buf,
      })
    end

    local builtin = require("telescope.builtin")

    mapkey("gd", builtin.lsp_definitions)
    mapkey("gr", builtin.lsp_references)
    mapkey("gR", vim.lsp.buf.rename)
    mapkey("K", vim.lsp.buf.hover)
    mapkey("<leader>e", vim.diagnostic.open_float)
    mapkey("[d", function()
      vim.diagnostic.jump({
        diagnostic = vim.diagnostic.get_prev(),
      })
    end)
    mapkey("]d", function()
      vim.diagnostic.jump({
        diagnostic = vim.diagnostic.get_next(),
      })
    end)
  end,
})

---Query the LSP server for any OrganizeImports code actions and apply edits for those.
---@param bufnr integer
local maybe_fix_imports = function(bufnr)
  local params = vim.lsp.util.make_range_params(0, "utf-8")
  params.context = { only = { "source.organizeImports" } }

  local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params)
  for client_id, requests in pairs(result or {}) do
    for _, req in pairs(requests.result or {}) do
      if req.edit then
        local encoding = (vim.lsp.get_client_by_id(client_id) or {}).offset_encoding or "utf-8"
        vim.lsp.util.apply_workspace_edit(req.edit, encoding)
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go,*.rs",
  callback = function(args)
    maybe_fix_imports(args.buf)
    vim.lsp.buf.format({ bufnr = args.buf, async = false })
  end,
})

vim.diagnostic.config({
  virtual_text = true,
})
