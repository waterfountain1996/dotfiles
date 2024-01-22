local function on_attach(_, bufnr)
	local function nmap(keys, func)
		vim.keymap.set("n", keys, func, { buffer = bufnr })
	end

	nmap("gd", vim.lsp.buf.definition)
	nmap("gD", vim.lsp.buf.declaration)
	nmap("gI", vim.lsp.buf.implementation)
	nmap("gr", require("telescope.builtin").lsp_references)
	nmap("gR", vim.lsp.buf.rename)
	nmap("K", vim.lsp.buf.hover)
	nmap("<leader>K", vim.lsp.buf.signature_help)
	nmap("<leader>D", vim.lsp.buf.type_definition)
	nmap("[d", vim.diagnostic.goto_prev)
	nmap("]d", vim.diagnostic.goto_next)
	nmap("<leader>e", vim.diagnostic.open_float)

	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end)
end

local servers = {
	clangd = {
		cmd = { "clangd", "--enable-config" },
	},
	pyright = {},
	tsserver = {},
	gopls = {},
	lua_ls = {
		settings = {
			Lua = {
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		}
	},
	templ = {},
}

vim.filetype.add({ extension = { templ = "templ" } })

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"folke/neodev.nvim",
	},
	config = function()
		require("neodev").setup()
		require("mason").setup()

		local capabilities = require("cmp_nvim_lsp").default_capabilities(
			vim.lsp.protocol.make_client_capabilities()
		)

		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({ ensure_installed = vim.tbl_keys(servers) })
		mason_lspconfig.setup_handlers({
			function(server_name)
				local lspconfig = require("lspconfig")
				if servers[server_name] ~= nil then
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						cmd = servers[server_name].cmd,
						settings = servers[server_name].settings,
					})
				end
			end,
		})

		local cmp = require("cmp")
		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				-- ["<CR>"] = cmp.mapping.confirm {
				-- 	behavior = cmp.ConfirmBehavior.Replace,
				-- 	select = true,
				-- },
			}),
			sources = {
				{ name = "nvim_lsp" },
			}
		})
	end,
}
