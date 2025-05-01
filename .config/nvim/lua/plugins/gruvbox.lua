return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        undercurl = false,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = true,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "slugbyte/lackluster.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      local lackluster = require("lackluster")

      ---@diagnostic disable-next-line: missing-fields
      lackluster.setup({
        tweak_ui = {
          disable_undercurl = true,
        },
        tweak_highlight = {
          ["@comment"] = {
            italic = true,
            fg = lackluster.color.gray5,
          },
          ["TelescopeMatching"] = {
            italic = false,
          },
        },
      })
      -- vim.cmd.colorscheme("lackluster-hack")
    end,
  }
}
