return {
    -- Color scheme
    "morhetz/gruvbox",
    "eddyekofo94/gruvbox-flat.nvim",

    -- Code comments
    "tpope/vim-commentary",

    -- Git support
    "tpope/vim-fugitive",

    -- Parentheses, brackets, quotes etc.
    "tpope/vim-surround",

    -- Auto closing Parentheses, brackets, quotes etc.
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
            })
        end
    },

    -- Stay in root directory
    "airblade/vim-rooter",

    -- LSP configuration and plugins
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            "williamboman/mason.nvim",
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
}
