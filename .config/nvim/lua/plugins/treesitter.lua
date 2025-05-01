return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      ---@diagnostic disable-next-line: missing-fields
      configs.setup({
      ensure_installed = { "c", "sql", "lua", "python", "go", "html", "templ", "javascript", "typescript", "zig", "rust" },
      auto_install = false,
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      })
    end,
  }
}
