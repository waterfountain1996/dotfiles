return {
    -- Color scheme
    {
        "morhetz/gruvbox",
        priority = 1000,
        lazy = false,
        config = function()
            vim.o.termguicolors = true
            vim.g.gruvbox_italic = true
            vim.g.gruvbox_bold = true
            vim.g.gruvbox_undercurl = true
            vim.g.gruvbox_invert_selection  = false
            vim.g.gruvbox_invert_signs = true
            vim.g.gruvbox_improved_warnings = true
            vim.g.gruvbox_contrast_dark = "medium"
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
                theme = "gruvbox-material",
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    -- Directory tree
    "preservim/nerdtree",
}
