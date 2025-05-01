return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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

      -- Load native fzf extension.
      pcall(telescope.load_extension, "fzf")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "fzf", builtin.live_grep)
      vim.keymap.set("n", "<leader>f", builtin.find_files)
      vim.keymap.set("n", "<leader>g", function() pcall(builtin.git_files) end)
      vim.keymap.set("n", "<leader><leader>", builtin.buffers)
      vim.keymap.set("n", "<leader>/", function()
        local themes = require("telescope.themes")
        builtin.current_buffer_fuzzy_find(themes.get_dropdown({
          windblend = 0,
          previewer = false,
        }))
      end)
      vim.keymap.set("n", "<leader>c", builtin.colorscheme)
    end,
  },
}
