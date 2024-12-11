return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"tpope/vim-fugitive", -- Git support
	"tpope/vim-surround", -- Surround text with parentheses, brackets etc.
	{
		"morhetz/gruvbox",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_italic = true
			vim.g.gruvbox_invert_selection = false
			vim.g.gruvbox_contrast_dark = "hard"
			vim.cmd([[colorscheme gruvbox]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = { theme = "gruvbox-material" },
				sections = {
					lualine_y = { "filesize" },
				},
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "┊" },
			scope = { enabled = false },
		},
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			ignore = "^$",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
							["<ESC>"] = require("telescope.actions").close,
						}
					}
				}
			})

			pcall(telescope.load_extension, "fzf")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "fzf", builtin.live_grep, { desc = "[fzf] Grep code" })
			vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "[F]ind files" })
			-- TODO: Don't show a flashy error when not in a git repo.
			vim.keymap.set("n", "<leader>g", builtin.git_files, { desc = "[G]it files" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 0,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("LspAttachGroup", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local builtin = require("telescope.builtin")

					map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
					map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
					map("gr", builtin.lsp_references, "[G]oto [R]eferences")
					map("gR", vim.lsp.buf.rename, "[R]e[n]ame")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>e", vim.diagnostic.open_float, "Show diagnostic [E]rror messages")
					map("[d", vim.diagnostic.goto_prev, "Goto previous [D]iagnostic message")
					map("]d", vim.diagnostic.goto_prev, "Goto next [D]iagnostic message")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						local highlight_augroup = vim.api.nvim_create_augroup("LspHighlightAugroup", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("LspDetachAugroup", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "LspHighlightAugroup", buffer = event2.buf })
							end,
						})
					end

					vim.api.nvim_create_user_command('Goimports', function()
						vim.cmd("!goimports -w %")
					end, {})

				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				clangd = {},
				pyright = {},
				gopls = {},
				templ = {},
				ts_ls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
							diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						},
					},
				},
			}

			require("mason").setup({})

			local ensure_installed = vim.tbl_keys(servers or {})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local srv = servers[server_name] or {}
						srv.capabilities = vim.tbl_deep_extend("force", {}, capabilities, srv.capabilities or {})
						require("lspconfig")[server_name].setup(srv or {})
					end,
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert,noselect" },
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				},
			})
		end,
	},
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = function()
			require('nvim-autopairs').setup {}
			-- Automatically add `(` after selecting a function or method
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local cmp = require('cmp')
			cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"c",
				"python",
				"go",
				"lua",
				"vim",
				"vimdoc",
				"html",
				"javascript",
				"typescript",
				"dockerfile",
				"json",
			},
			auto_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-space>",
					node_incremental = "<c-space>",
					scope_incremental = "<c-s>",
					node_decremental = "<c-backspace>",
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.install").prefer_git = true
			require("nvim-treesitter.configs").setup(opts)
		end
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
			})

			vim.keymap.set("n", "\\", ":Neotree toggle<CR>", { noremap = true })
		end,
	},
}

-- vim: ts=2 sts=2 sw=2
