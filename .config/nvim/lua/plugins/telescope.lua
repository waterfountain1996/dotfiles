return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.5",
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
        config = function()
            local telescope = require("telescope")
            telescope.setup({
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
            pcall(telescope.load_extension, "fzf")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>?", builtin.oldfiles)
            vim.keymap.set("n", "<leader><space>", builtin.buffers)
            vim.keymap.set(
                "n",
                "<leader>/",
                function()
                    builtin.current_buffer_fuzzy_find(
                        require("telescope.themes").get_dropdown({
                            winblend = 0, previewer = false,
                        })
                    )
                end
            )
            vim.keymap.set("n", "<leader>f", builtin.find_files)
            vim.keymap.set("n", "<leader>g", builtin.git_files)
            vim.keymap.set("n", "fzf", builtin.live_grep)
            vim.keymap.set("n", "<leader>sh", builtin.help_tags)
            vim.keymap.set("n", "<leader>sw", builtin.grep_string)
            vim.keymap.set("n", "<leader>cd", builtin.diagnostics)
        end,
    },
}
