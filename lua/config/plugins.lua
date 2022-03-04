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
  },
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
  })
  use({ -- use ysiw for example i guess
    'tpope/vim-surround',
    event = 'BufRead',
    requires = { { 'tpope/vim-repeat', event = 'BufRead' } },
  })
  use({ -- Repeats plugins with . as well
    'tpope/vim-repeat',
    event = 'BufRead',
  })
  use({
    'nvim-lualine/lualine.nvim', -- Status line
    after = 'nvim-web-devicons',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('config.lualine.lualine_evil')
    end,
  })
  use({ -- Split screen management
    'beauwilliams/focus.nvim',
    module = 'focus',
    event = { 'BufRead', 'BufNewFile', 'WinEnter', 'BufWinEnter' },
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
    config = function()
      require('config.toggleterm')
    end,
  })

  use({
    'kyazdani42/nvim-tree.lua',
    -- cmd = { 'NvimTreeToggle' },
    config = function()
      require('config.nvimtree')
    end,
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
  }, {
    'nvim-telescope/telescope-ui-select.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').load_extension('ui-select')
    end,
    requires = { { 'nvim-telescope/telescope.nvim', opt = true } },
  }, {
    'nvim-telescope/telescope-media-files.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').load_extension('media_files')
    end,
    requires = { { 'nvim-telescope/telescope.nvim', opt = true } },
  }, {
    'nvim-telescope/telescope-dap.nvim',
    after = 'telescope.nvim',
    config = function()
      require('telescope').load_extension('dap')
    end,
    requires = {
      { 'nvim-telescope/telescope.nvim' },
      { 'mfussenegger/nvim-dap', opt = true },
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
      'javascript',
      'typescript',
    },
  })

  -- Bar
  use({
    'akinsho/bufferline.nvim',
    after = 'nvim-web-devicons',
    module = 'nvim-web-devicons',
    config = function()
      require('bufferline').setup({
        numbers = 'buffer_id',
        diagnostics = 'nvim_lsp',
        right_mouse_command = 'vertical sbuffer %d',
      })
    end,
  })
  -- Linting among other things
  -- LSP
  use({
    'neovim/nvim-lspconfig',
    module = 'lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    cmd = 'LspInfo',
    config = function()
      require('config.NeovimLSP')
    end,
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    after = 'nvim-lspconfig',
    module = 'null_ls',
    event = 'BufRead',
    requires = { { 'neovim/nvim-lspconfig' } },
    config = function()
      require('config.null_ls')
    end,
  })

  -- use({
  -- 	"ThePrimeagen/refactoring.nvim",
  -- 	requires = {
  -- 		{ "nvim-lua/plenary.nvim" },
  -- 		{ "nvim-treesitter/nvim-treesitter" },
  -- 	},
  -- })

  use({
    'williamboman/nvim-lsp-installer',
    requires = { { 'neovim/nvim-lspconfig' } },
  })

  -- Show lightblub on code action
  use({ 'kosayoda/nvim-lightbulb' })

  -- AutoCompletetion
  use({
    'hrsh7th/nvim-cmp',
    -- event = 'InsertEnter',
    config = function()
      require('config.cmp.cmp')
    end,
  })

  use({
    'hrsh7th/cmp-buffer',
    after = 'nvim-cmp',
    requires = { { 'hrsh7th/nvim-cmp' } },
  })

  use({
    'hrsh7th/cmp-nvim-lsp',
    event = 'BufRead',
    after = 'cmp-buffer',
    requires = { { 'hrsh7th/nvim-cmp' } },
  })

  use({
    'hrsh7th/cmp-path',
    after = 'cmp-buffer',
    requires = { { 'hrsh7th/nvim-cmp' } },
  })

  use({
    'hrsh7th/cmp-cmdline',
    after = 'cmp-path',
    requires = { { 'hrsh7th/nvim-cmp' } },
  })

  use({
    'ray-x/lsp_signature.nvim',
    after = 'nvim-lspconfig',
    module = 'lspconfig',
    config = function()
      require('lsp_signature').setup({})
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

  use({ 'vim-test/vim-test' })

  use({
    'rcarriga/vim-ultest',
    requires = { 'vim-test/vim-test' },
    cmd = { 'Ultet' },
    config = function()
      require('config.ultest')
    end,
    run = ':UpdateRemotePlugins',
  })

  -- Jest Tests debugging
  use({
    disable = true,
    'David-Kunz/jester',
    ft = { 'js', 'ts' },
  })

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
  use({
    'lervag/vimtex',
    ft = { 'tex', 'latex' },
  })
  -- Syntax and languages
  -- Syntax highlighting
  use({
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufRead', 'BufNewFile' },
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.install').compilers = { 'clang' }
      require('config.treesitter')
    end,
  }, { -- Auto close tags
    'windwp/nvim-ts-autotag',
    after = 'nvim-treesitter',
    event = 'InsertCharPre',
  }, { -- comments
    'numToStr/Comment.nvim',
    after = 'nvim-treesitter',
    config = function()
      require('Comment').setup()
    end,
  }, {
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = 'nvim-treesitter',
    requires = { { 'numToStr/Comment.nvim' } },
    config = function()
      require('config.comments')
    end,
  }, { -- pairs and autocloses and can surrond stuff too!
    'windwp/nvim-autopairs',
    event = 'InsertCharPre',
    after = 'nvim-treesitter',
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
  use({ 'folke/trouble.nvim' }) -- pretty messages

  use({ -- for rust
    'simrat39/rust-tools.nvim',
    ft = { 'rust' },
  })

  use({ -- Shows LSP progress
    'j-hui/fidget.nvim',
    after = 'nvim-lspconfig',
    module = 'lspconfig',
    config = function()
      require('fidget').setup({
        sources = {
          ['null-ls'] = {
            ignore = true,
          },
        },
      })
    end,
  })

  -- use({ -- For now use prettier tailwind
  -- 	"steelsojka/headwind.nvim",
  -- 	ft = { "css", "typescriptreact" },
  -- 	config = function()
  -- 		require("headwind").setup({})
  -- 	end,
  -- })

  -- Snippets
  use({
    'SirVer/ultisnips',
    after = 'nvim-cmp',
  })
  use({
    'quangnguyen30192/cmp-nvim-ultisnips',
    after = 'ultisnips',
    requires = { { 'hrsh7th/nvim-cmp' } },
  })
  use({
    'honza/vim-snippets',
  })
  -- Icons
  use({
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup()
    end,
  })
  -- Icons for auto complete, you can never have enough
  use({ 'onsails/lspkind-nvim', requires = { { 'hrsh7th/nvim-cmp' } } })
  -- Automatically creates missing LSP diagnostics highlight groups
  use({ 'folke/lsp-colors.nvim' })
  -- heighlights Colors with their color xd
  use({
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
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
  use({ 'catppuccin/nvim' })
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
    disable = true, -- Disable the plugin
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
