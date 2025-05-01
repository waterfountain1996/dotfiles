---Query the LSP server for any OrganizeImports code actions and apply edits for those.
---@param bufnr integer
local maybe_fix_imports = function(bufnr)
  local params = vim.lsp.util.make_range_params()
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

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
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
          mapkey("[d", vim.diagnostic.goto_prev)
          mapkey("]d", vim.diagnostic.goto_next)
        end,
      })

      -- Enable auto-formatting/import fixing for Go files.
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go,*.rs",
        callback = function(args)
          maybe_fix_imports(args.buf)
          vim.lsp.buf.format({ bufnr = args.buf, async = false })
        end,
      })

      local servers = { "clangd", "gopls", "lua_ls", "pyright", "ts_ls", "zls" }
      local lsp_config = require("lspconfig")

      for _, name in ipairs(servers) do
        lsp_config[name].setup({})
      end

      lsp_config.rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = false;
            },
          },
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        completion = { completeopt = "menu,menuone,noinsert,noselect" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },
}
