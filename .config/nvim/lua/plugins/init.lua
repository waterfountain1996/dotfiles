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
