local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer close and reopen Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  print('Something went wrong with Packer!')
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
    prompt_border = 'single',
  },
  git = {
    clone_timeout = 6000, -- seconds
  },
  auto_clean = true,
  compile_on_sync = true,
})

return packer.startup(function(use)
  use({ -- Have packer manage itself
    'wbthomason/packer.nvim',
    -- event = 'VimEnter',
  })

  -- LUAA
  use({
    'nvim-lua/plenary.nvim',
  })

  use({ -- Allows us to implement easy popups
    'nvim-lua/popup.nvim',
    module = 'popup',
  })

  use({
    'glepnir/dashboard-nvim',
    event = { 'VimEnter', 'GuiEnter' },
    config = function()
      require('config.dashboard')
    end,
  })

  use({ -- use ysiw for example i guess
    'tpope/vim-surround',
    event = 'BufRead',
    requires = {
      { 'tpope/vim-repeat', event = 'BufRead' }, -- Repeats plugins with . as well
    },
  })

  use({
    {
      'nvim-lualine/lualine.nvim', -- Status line
      event = 'BufEnter',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
      config = function()
        require('config.lualine.lualine_slanted')
      end,
    },
    { -- Shows LSP progress
      'j-hui/fidget.nvim',
      after = 'lualine.nvim',
      config = function()
        require('fidget').setup({
          sources = {
            ['null-ls'] = {
              ignore = true,
            },
          },
        })
      end,
    },
  })

  use({ -- Split screen management
    'beauwilliams/focus.nvim',
    module = 'focus',
    cmd = { 'FocusSplitNicely', 'FocusSplitCycle' },
    -- event = { 'BufRead', 'BufNewFile', 'WinEnter', 'BufWinEnter' },
    config = function()
      require('focus').setup({
        excludeded_filetypes = {
          'NvimTree',
          'toggleterm',
          'term',
          'fterm',
          'diffviewfiles',
          'dap-repl',
        },
        excludeded_buftypes = { 'help', 'nofile', 'prompt', 'popup' },
        hybridnumber = true,
        treewith = 30,
        minwidth = 20,
      })
    end,
  })
  use({ -- Smooth scrolling
    'karb94/neoscroll.nvim',
    event = 'WinScrolled',
    config = function()
      require('neoscroll').setup()
    end,
  })
  use({ -- Terminal
    'akinsho/toggleterm.nvim',
    event = 'CursorHold',
    config = function()
      require('config.toggleterm')
    end,
  })

  use({
    'jbyuki/venn.nvim',
    key = {
      { 'n', '<leader>v' },
    },
    config = function()
      require('config.venn')
    end,
  })
  use({
    'kyazdani42/nvim-tree.lua',
    -- cmd = { 'NvimTreeToggle' },
    config = function()
      require('config.nvimtree')
    end,
  })

  -- better matchit plug
  use({
    'andymass/vim-matchup',
    event = 'BufRead',
  })

  -- Aligns things easly using gaip=
  use({
    'junegunn/vim-easy-align',
    key = '<Plug>(EasyAlign)', -- Lazy load on keymap press
  })

  -- Vim MultiCurosr, use cgn instead :)
  use({
    'mg979/vim-visual-multi',
    disable = true,
  })

  -- Search, and fuzzy stuff, far for replace
  use({
    'brooth/far.vim',
    opt = true,
    cmd = { 'F', 'Far', 'Fardo', 'Farundo' },
  })

  use({
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        border = 'single', -- none, single, double, shadow
        margin = { 2, 2, 2, 2 }, -- extra window margin [top, right, bottom, left]
      })
    end,
  })
  use({
    {
      'nvim-telescope/telescope.nvim',
      module = 'telescope',
      cmd = 'Telescope',
      keys = {
        { 'n', '<Leader>fg' },
        { 'n', '<Leader>tc' },
        { 'n', '<Leader>ff' },
        { 'n', '<Leader>fh' },
      },
      requires = { { 'nvim-lua/plenary.nvim', opt = true } },
      config = function()
        require('config.telescope')
      end,
    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('ui-select')
      end,
      requires = { { 'nvim-telescope/telescope.nvim' } },
    },
    {
      'nvim-telescope/telescope-media-files.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('media_files')
      end,
      requires = { { 'nvim-telescope/telescope.nvim' } },
    },
    {
      'nvim-telescope/telescope-dap.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('dap')
      end,
      requires = { { 'nvim-telescope/telescope.nvim' } },
    },
  })

  -- Emmet for html
  use({
    'mattn/emmet-vim',
    ft = {
      'html',
      'css',
      'typescriptreact',
      'javascriptreact',
    },
  })

  -- Bar
  use({
    'akinsho/bufferline.nvim',
    after = 'nvim-web-devicons',
    config = function()
      require('config.bufferline')
    end,
  })
  -- Linting among other things
  -- LSP
  use({
    'neovim/nvim-lspconfig',
    module = 'lspconfig',
    event = { 'BufRead' },
    cmd = 'LspInfo',
    config = function()
      require('config.lsp.NeovimLSP')
    end,
    requires = {
      -- WARN: Unfortunately we won't be able to lazy load this
      {
        'hrsh7th/cmp-nvim-lsp',
      },
    },
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    after = 'nvim-lspconfig',
    module = 'null-ls',
    event = 'BufRead',
    requires = { { 'neovim/nvim-lspconfig' } },
    config = function()
      require('config.lsp.null_ls')
    end,
  })

  use({
    disable = true,
    'ThePrimeagen/refactoring.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  })

  use({
    'stevearc/aerial.nvim',
    opt = true,
    module = 'aerial',
    config = function()
      require('config.aerial')
    end,
  })

  use({
    'jose-elias-alvarez/nvim-lsp-ts-utils',
    module = 'nvim-lsp-ts-utils',
  })

  use({
    'CRAG666/code_runner.nvim',
    config = function()
      require('config.code_runner')
    end,
    requires = 'nvim-lua/plenary.nvim',
  })

  use({
    'williamboman/nvim-lsp-installer',
    requires = { { 'neovim/nvim-lspconfig' } },
  })

  -- Show lightblub on code action
  use({ 'kosayoda/nvim-lightbulb' })

  -- AutoCompletetion and snippets, replaced with luasnip
  -- use(
  --   { 'SirVer/ultisnips', after = 'nvim-cmp' },
  --   { 'quangnguyen30192/cmp-nvim-ultisnips', after = 'ultisnips' },
  --   { 'honza/vim-snippets', after = 'ultisnips' }
  -- )

  use({
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      config = function()
        require('config.cmp.cmp')
      end,
      requires = {
        {
          'L3MON4D3/LuaSnip',
          event = 'CursorHold',
          module = 'luasnip',
          config = function()
            require('config.luasnip')
          end,
          requires = { 'rafamadriz/friendly-snippets' },
        },
      },
    },
    { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
    { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
    { 'kdheepak/cmp-latex-symbols', after = 'nvim-cmp' },
    { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
  })

  use({ 'onsails/lspkind-nvim', module = 'lspkind' }) -- Icons for autocomplete, you can never have enough.
  use({
    'ray-x/lsp_signature.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('lsp_signature').setup({
        bind = true,
        handler_opts = {
          border = 'rounded',
        },
        floating_window = true,
        hint_enable = false, -- disable virtual text hint
        hi_parameter = 'IncSearch', -- highlight group used to highlight the current parameter
      })
    end,
  })

  -- Debugger
  use({
    'mfussenegger/nvim-dap',
    key = {
      { 'n', '<leader>d' },
    },
    config = function()
      require('config.dap.dap')
    end,
  })

  use({ -- For nvim lua
    'jbyuki/one-small-step-for-vimkind',
    requires = { { 'mfussenegger/nvim-dap', opt = true } },
  })

  -- use({ -- For java
  -- 	"mfussenegger/nvim-jdtls",
  -- 	ft= { 'java' },
  -- 	requires = { { "williamboman/nvim-lsp-installer" } },
  -- 	config = function ()
  -- 		require("config.jdtls")
  -- 	end
  -- })

  use({
    'mfussenegger/nvim-dap-python',
    module = 'dap-python',
    requires = { { 'mfussenegger/nvim-dap', opt = true } },
  })
  -- Debugger UI
  use({
    'rcarriga/nvim-dap-ui',
    module = 'dapui',
    requires = { { 'mfussenegger/nvim-dap', opt = true } },
  })
  -- Shows variables and their values when debugging
  use({
    'theHamsta/nvim-dap-virtual-text',
    requires = { { 'mfussenegger/nvim-dap' } },
  })

  -- Installs dap debuggers
  use({
    'Pocco81/DAPInstall.nvim',
    opt = true,
    cmd = { 'DIInstall', 'DIList', 'DIUninstall' },
    requires = { { 'mfussenegger/nvim-dap' } },
  })

  -- Fixes performance issues with cursorHold
  use({ 'antoinemadec/FixCursorHold.nvim', event = { 'CursorHold' } })

  use({
    'nvim-neotest/neotest',
    after = { 'nvim-treesitter' },
    requires = {
      'haydenmeade/neotest-jest',
      'nvim-neotest/neotest-python',
      'sidlatau/neotest-dart',
    },
    config = function()
      require('config.neotest')
    end,
  })

  -- use({ 'vim-test/vim-test' })
  --
  -- -- Jest Tests debugging
  -- use({
  --   disable = true,
  --   'David-Kunz/jester',
  --   ft = { 'js', 'ts' },
  -- })

  -- Git integration
  use({
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead' },
    config = function()
      require('config.gitsigns')
    end,
  })
  use({ 'tpope/vim-fugitive' })
  -- Latex stuff
  use({ -- NOTE: We don't need to lazy load this, it lazy loads itself.
    'lervag/vimtex',
  })
  -- Syntax and languages
  -- Syntax highlighting
  use({
    {
      'nvim-treesitter/nvim-treesitter',
      event = 'CursorHold',
      run = ':TSUpdate',
      config = function()
        require('config.treesitter')
      end,
    },
    { 'nvim-treesitter/playground', after = 'nvim-treesitter' },
    { -- Auto close tags
      'windwp/nvim-ts-autotag',
      after = 'nvim-treesitter',
      config = function()
        require('nvim-ts-autotag').setup({
          filetypes = {
            'html',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'svelte',
            'vue',
            'tsx',
            'jsx',
            'rescript',
            'xml',
            'php',
            'markdown',
            'glimmer',
            'handlebars',
            'hbs',
          },
        })
      end,
    },
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      after = 'nvim-treesitter',
      config = function()
        require('config.comments')
      end,
    },
  })

  use({ -- comments using gc
    'numToStr/Comment.nvim',
    event = 'BufRead',
    config = function()
      require('Comment').setup()
    end,
  })

  use({ -- pairs and autocloses and can surrond stuff too!
    'windwp/nvim-autopairs',
    after = 'nvim-cmp', -- Must be Loaded after nvim-cmp
    event = 'InsertCharPre',
    config = function()
      require('config.autopairs')
    end,
  })

  -- indentation highlight
  use({
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    after = { 'nvim-treesitter' },
    config = function()
      require('config.indentLines')
    end,
  })

  use({ 'folke/trouble.nvim', event = 'BufRead' }) -- pretty messages

  use({
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    event = 'BufRead',
    config = function()
      require('todo-comments').setup({
        keywords = {
          FIX = {
            alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
          },
          WARN = { alt = { 'WARNING', 'XXX' } },
          NOTE = { alt = { 'INFO' } },
        },
      })
    end,
  })

  use({ -- for rust
    'simrat39/rust-tools.nvim',
    module = 'rust-tools',
    ft = { 'rust' },
  })

  -- use({ -- For now use prettier tailwind
  -- 	"steelsojka/headwind.nvim",
  -- 	ft = { "css", "typescriptreact" },
  -- 	config = function()
  -- 		require("headwind").setup({})
  -- 	end,
  -- })

  -- Icons
  use({
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup()
    end,
  })
  -- Automatically creates missing LSP diagnostics highlight groups
  use({
    'folke/lsp-colors.nvim',
  })
  -- heighlights Colors with their color xd
  use({
    'norcalli/nvim-colorizer.lua',
    event = 'CursorHold',
    config = function()
      require('colorizer').setup()
    end,
  })
  use({
    'nathom/filetype.nvim',
    config = function()
      vim.g.did_load_filetypes = 1 -- Stop file types from loading, load them using filetypes.nvim
    end,
  })
  -- Dims lights xd
  use({
    'folke/twilight.nvim',
    cmd = 'Twilight',
  })
  -- Themes
  use('rktjmp/lush.nvim') -- used to create colorschemes
  use('nanotech/jellybeans.vim')
  use('ellisonleao/gruvbox.nvim')
  use('dracula/vim')
  use('folke/tokyonight.nvim')
  use('shaunsingh/nord.nvim')
  use({ 'catppuccin/nvim', as = 'catppuccin' })
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      require('rose-pine').setup({
        dark_variant = 'moon',
      })
    end,
  })
  use({
    'AlphaTechnolog/pywal.nvim',
    disable = true,
  })
  use({ -- Colors
    'tjdevries/colorbuddy.vim',
    event = 'BufRead',
    config = function()
      require('colorbuddy').setup()
    end,
  })
  use({ 'overcache/NeoSolarized' })
  use({ -- Startup time
    'tweekmonster/startuptime.vim',
    cmd = 'StartupTime',
  })
  use({ -- adds transpancy toggles
    'xiyaowong/nvim-transparent',
    cmd = { 'TransparentToggle', 'TransparentEnable', 'TransparentDisable' },
    config = function()
      require('transparent').setup({
        enable = true, -- boolean: enable transparent
        extra_groups = { -- table/string: additional groups that should be clear
          'BufferLineTabClose',
          'BufferlineBufferSelected',
          'BufferLineFill',
          'BufferLineBackground',
          'BufferLineSeparator',
          'BufferLineIndicatorSelected',
        },
        exclude = {}, -- table: groups you don't want to clear
      })
    end,
  })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
