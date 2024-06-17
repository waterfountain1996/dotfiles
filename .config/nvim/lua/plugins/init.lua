return {
    -- Color scheme
    "eddyekofo94/gruvbox-flat.nvim",
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("gruvbox").setup({
                italic = {
                    strings = false,
                },
                invert_signs = true,
                contrast = "soft",
            })
            vim.cmd([[colorscheme gruvbox]])
        end,
    },

    -- Code comments
    "tpope/vim-commentary",

    -- Auto indent
    "tpope/vim-sleuth",

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
                theme = "gruvbox_dark",
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    -- Directory tree
    "preservim/nerdtree",
}
