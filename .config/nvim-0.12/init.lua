-- [[ General options ]]
do
  -- Enable faster startup by caching compiled Lua modules.
  vim.loader.enable()

  -- Set <space> as the leader key.
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Don't change directory.
  vim.opt.autochdir = false

  -- Show (relative) line number.
  vim.o.number = true
  vim.o.relativenumber = true

  -- Highlight current line.
  vim.o.cursorline = true

  -- End of line marker.
  vim.opt.colorcolumn = "101"

  -- Disable line wrapping.
  vim.o.wrap = false

  -- Sync clipboard between the OS and Neovim.
  -- Schedule the setting after 'UiEnter' because it can increase startup time.
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Configure how new splits should be opened.
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Keep cursor away from top or bottom of the screen.
  vim.opt.scrolloff = 10

  -- Use block cursor in every mode.
  vim.cmd("set guicursor=")

  -- Configure search options.
  vim.opt.hlsearch = false
  vim.opt.incsearch = true
  vim.opt.showmatch = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.wrapscan = true

  -- Don't show current mode because we have lualine.
  vim.opt.showmode = false

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Don't show the previous command.
  vim.opt.showcmd = false
  vim.opt.cmdheight = 1

  -- Configure indentation.
  local indent = 4
  vim.opt.tabstop = indent
  vim.opt.softtabstop = indent
  vim.opt.shiftwidth = indent
  vim.opt.smarttab = true

  -- Set command history length.
  vim.opt.history = 100

  -- Set how Neovim will display certain whitespace characters in the editor.
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live
  vim.o.inccommand = 'split'

  -- Highlight text on yank.
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- [[ Basic keybindings ]]
do
  -- Shift text in visual mode.
  vim.keymap.set('v', '>', '>gv', { noremap = true })
  vim.keymap.set('v', '<', '<gv', { noremap = true })

  -- Shift current selection up or down with indentation.
  vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
  vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

  -- Yank text from current column until EOL.
  vim.keymap.set("n", "Y", "yg_", { noremap = true })
end

-- [[ vim-pack setup ]]
do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---@param repo string
---@return string
local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Plugins ]]
do
  -- [[ Guess indent ]]
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- [[ Git ]]
  vim.pack.add { gh 'tpope/vim-fugitive' }
  
  -- [[ mini.nvim ]]
  vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

  -- Surround.
  require('mini.surround').setup()

  -- Enable statusline.
  require('mini.statusline').setup {}

  -- Enable code commenting.
  require('mini.comment').setup {}

  -- [[ Neotree ]]
  vim.pack.add {
    gh 'nvim-neo-tree/neo-tree.nvim',
    gh 'nvim-tree/nvim-web-devicons',
    gh 'MunifTanjim/nui.nvim',
  }
  require('neo-tree').setup {
    close_if_last_window = false,
  }
  vim.keymap.set('n', '\\', ':Neotree toggle<CR>', { noremap = true })
end

-- [[ Colorscheme ]]
do
  vim.pack.add { gh 'ellisonleao/gruvbox.nvim' }
  require('gruvbox').setup {
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
  }
  vim.cmd.colorscheme 'gruvbox'
end

-- [[ Search & Navigation ]]
do
  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-lua/plenary.nvim',
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then
    table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim')
  end
  
  vim.pack.add(telescope_plugins)

  require('telescope').setup({
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

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', 'fzf', builtin.live_grep, { desc = '[fzf] Fuzzy find' })
  vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Search [f]iles' })
  vim.keymap.set('n', '<leader>g', function() pcall(builtin.git_files) end, { desc = 'Search [g]it files' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Search open buffers' })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local mapkey = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
      end

      mapkey('gd', builtin.lsp_definitions, '[G]o to [d]efinition')
      mapkey('gr', builtin.lsp_references, '[G]o to [r]eferences')
    end,
  })

  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
      windblend = 0,
      previewer = false,
    }))
  end, { desc = '[/] Fuzzy search in current buffer' })
end

-- [[ LSP ]]
do
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('nvim-lsp-attach', { clear = true }),
    callback = function(event)
      local mapkey = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
      end

      mapkey('gR', vim.lsp.buf.rename, '[R]ename')
      mapkey('gD', vim.lsp.buf.declaration, 'Go to [d]eclaration')
      mapkey("<leader>e", vim.diagnostic.open_float, '[e] Open floating diagnostic window')
    end,
  })

  ---@type table<string, vim.lsp.Config>
  local servers = {
    clangd = {},
    pyright = {},
    gopls = {},
    rust_analyzer = {},
    stylua = {},
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
        client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.api.nvim_get_runtime_file('', true),
          },
        })
      end,
      settings = {
        Lua = {
          format = { enable = false },
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}

  require('mason-lspconfig').setup {
    automatic_enable = false,
  }

  local ensure_installed = vim.tbl_keys(servers or {})

  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- [[ Treesitter ]]
do
  vim.pack.add { gh 'nvim-treesitter/nvim-treesitter' }

  local parsers = { 'c', 'sql', 'lua', 'python', 'go', 'html', 'templ', 'javascript', 'typescript', 'bash', 'rust' , 'markdown' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param lang string
  local function ts_try_attach(buf, lang)
    if not vim.treesitter.language.add(lang) then return end
    vim.treesitter.start(buf, lang)

    local has_indent_query = vim.treesitter.query.get(lang, 'indents') ~= nil
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local lang = vim.treesitter.language.get_lang(filetype)
      if not lang then return end

      local installed_parsers = require('nvim-treesitter').get_installed('parsers')

      if vim.tbl_contains(installed_parsers, lang) then
        ts_try_attach(buf, lang)
      elseif vim.tbl_contains(available_parsers, lang) then
        require('nvim-treesitter').install(lang):await(function() ts_try_attach(buf, lang) end)
      else
        ts_try_attach(buf, lang)
      end
    end,
  })
end

-- vim: ts=2 sts=2 sw=2 et
