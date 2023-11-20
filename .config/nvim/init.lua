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

require("lazy").setup({
    -- Color scheme
    "morhetz/gruvbox",
    "eddyekofo94/gruvbox-flat.nvim",

    -- Code comments
    "tpope/vim-commentary",

    -- Git support
    "tpope/vim-fugitive",

    -- Auto indent
    "tpope/vim-sleuth",

    -- Parentheses, brackets, quotes etc.
    "tpope/vim-surround",

    -- Auto closing Parentheses, brackets, quotes etc.
    "windwp/nvim-autopairs",

    -- Stay in root directory
    "airblade/vim-rooter",

    -- LSP configuration and plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { "williamboman/mason.nvim", config = true },
            "williamboman/mason-lspconfig.nvim",

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/cmp-buffer",

            -- LSP completion
            "hrsh7th/cmp-nvim-lsp",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        }
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                  return vim.fn.executable "make" == 1
                end,
            },
        },
    },

    -- Highlight, edit, and navigate code
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
    },

    -- Add indentation guides even on blank lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "┊",
            },
            scope = {
                enabled = false,
            }
        },
    },

    -- Fancy status line
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = true,
                theme = "gruvbox-flat",
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    -- Directory tree
    "preservim/nerdtree",
}, {})

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

require("nvim-autopairs").setup({ check_ts = true })

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

-- telescope
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<ESC>"] = require("telescope.actions").close,
            },
        },
    },
})

pcall(require("telescope").load_extension, "fzf")

vim.keymap.set(
    "n",
    "<leader>?",
    require("telescope.builtin").oldfiles,
    { desc = "[?] Find recently opened files" }
)

vim.keymap.set(
    "n",
    "<leader><space>",
    require("telescope.builtin").buffers,
    { desc = "[ ] Find existing buffers" }
)

vim.keymap.set(
    "n",
    "<leader>/", function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown({ winblend = 0, previewer = false, })
        )
    end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set(
    "n",
    "<leader>f",
    require("telescope.builtin").find_files,
    { desc = "[S]earch [F]iles" }
)

vim.keymap.set(
    "n",
    "<leader>g",
    require("telescope.builtin").git_files,
    { desc = "[S]earch [G]it files" }
)

vim.keymap.set(
    "n",
    "fzf",
    require("telescope.builtin").live_grep,
    { desc = "[S]earch by [G]rep" }
)

vim.keymap.set(
    "n",
    "<leader>sh",
    require("telescope.builtin").help_tags,
    { desc = "[S]earch [H]elp" }
)

vim.keymap.set(
    "n",
    "<leader>sw",
    require("telescope.builtin").grep_string,
    { desc = "[S]earch current [W]ord" }
)

vim.keymap.set(
    "n",
    "<leader>cd",
    require("telescope.builtin").diagnostics,
    { desc = "[C]ode [D]iagnostics" }
)

-- Treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "cpp", "lua", "python", "rust", "typescript", "vim" },
    highlight = { enable = true },
    indent = { enable = true, },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
        },
    },
})

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- LSP settings.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gR", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<leader>K", vim.lsp.buf.signature_help, "Signature Documentation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

local servers = {
    clangd = {},
    pyright = {},
    rust_analyzer = {},
    tsserver = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })

mason_lspconfig.setup_handlers {
    function(server_name)
        if server_name == "clangd" then
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "clangd", "--enable-config" },
                settings = servers[server_name],
            }
        else
            require("lspconfig")[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
            }
        end
    end,
}

-- =================
--  Code completion
-- =================

local cmp = require "cmp"
local luasnip = require "luasnip"

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
}
