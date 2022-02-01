local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path})
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local status_ok, packer = pcall(require, "packer")
    if not status_ok then
        print("Something went wrong with Packer!")
        return
    end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  use { 'wbthomason/packer.nvim' } -- Have packer manage itself
  -- LUAA
  use { 'nvim-lua/plenary.nvim' }
  use { 'nvim-lua/popup.nvim' } -- Allows us to implement easy popups
  use { 'glepnir/dashboard-nvim' } -- Main screen
  use { -- pairs and autocloses and can surrond stuff too!
    'windwp/nvim-autopairs',
    config = function()
      require('config.autopairs')
    end
  }
  use { 'tpope/vim-surround' } -- use ysiw for example i guess
  use { 'tpope/vim-repeat' } -- Repeats plugins with . as well
  use {
    'nvim-lualine/lualine.nvim', -- Status line
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('config.lualine')
    end
    }
  use { -- Split screen management
    "beauwilliams/focus.nvim",
    config = function()
      require("focus").setup()
    end
  }
  use { -- Smooth scrolling
    'karb94/neoscroll.nvim',
    config = function() require'neoscroll'.setup() end
    }
  use { -- Terminal
    'akinsho/toggleterm.nvim',
    config = function()
      require'config.toggleterm'
    end
    }
  use {
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('config.nvimtree')
    end
    }
  -- Aligns things easly using gaip=
  use { 'junegunn/vim-easy-align' }
  -- Vim MultiCurosr, use cgn instead :)
  use {
    'mg979/vim-visual-multi',
    disable = true
    }
  -- Search, and fuzzy stuff, far for replace
  use 'brooth/far.vim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('config.telescope')
    end
    }
  use {
    'nvim-telescope/telescope-ui-select.nvim',
    requires = { {'nvim-telescope/telescope.nvim'} }
  }
  -- Emmet for html
  use { 'mattn/emmet-vim' }
  -- Bar
  use {
    'akinsho/bufferline.nvim',
    config = function() require'bufferline'.setup{
      numbers = "buffer_id",
    diagnostics = "nvim_lsp",
    right_mouse_command = "vertical sbuffer %d"
    } end
    }
  -- Linting among other things
  -- LSP
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require'config.NeovimLSP'
    end
  }
  use {
    'williamboman/nvim-lsp-installer',
    requires = { {'neovim/nvim-lspconfig'} },
  }
  -- Show lightblub on code action
  use {'kosayoda/nvim-lightbulb' }
  -- AutoCompletetion
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.cmp')
    end
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    requires = { { 'hrsh7th/nvim-cmp' } }
    }
  use {'hrsh7th/cmp-buffer',
    requires = { { 'hrsh7th/nvim-cmp' } }
    }
  use {'hrsh7th/cmp-path',
    requires = { { 'hrsh7th/nvim-cmp' } }
    }
  use {'hrsh7th/cmp-cmdline',
    requires = { { 'hrsh7th/nvim-cmp' } }
    }
  -- Debugger
  use {
    'mfussenegger/nvim-dap',
    config = function()
      require('config.dap')
    end
  }
  -- use 'jbyuki/one-small-step-for-vimkind' -- For nvim lua
  -- Meh java xd, cant get it work for some reason ah well
  -- use 'mfussenegger/nvim-jdtls', { 'do':'source ~/.config/nvim/config/jdtls.lua'}
  use 'mfussenegger/nvim-dap-python'
  -- Debugger UI
  use 'rcarriga/nvim-dap-ui'
  use {
    'nvim-telescope/telescope-dap.nvim',
    requires = { { 'nvim-telescope/telescope.nvim' } }
    }
  -- Shows variables and their values when debugging
  use {
    'theHamsta/nvim-dap-virtual-text',
    requires = { { 'mfussenegger/nvim-dap' } }
    }
  -- Installs dap debuggers
  use "Pocco81/DAPInstall.nvim"
  -- Jest Tests debugging
  use {
    'David-Kunz/jester',
    ft = {'js', 'ts'}
    }
  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require'config.gitsigns'
    end
    }
  use { 'tpope/vim-fugitive' }
  -- Latex stuff
  use {
    'lervag/vimtex',
    ft = {'tex','latex'}
    }
  -- Syntax and languages
  -- Syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.install').compilers = { "clang" }
      require('config.treesitter')
    end
    }
  -- use 'sheerun/vim-polyglot' # Replaced with treesitter and other plugins
  -- comments
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
    }
  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    requires = { {'numToStr/Comment.nvim'} },
    config = function()
      require'config.comments'
    end
  }
  -- use { 'windwp/nvim-ts-autotag' } -- Auto close tags
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function ()
      require('config.indentLines')
    end
  }
  use { 'folke/trouble.nvim' } -- pretty messages
  use {
    'simrat39/rust-tools.nvim',
    }
  use { -- Shows LSP progress
    'j-hui/fidget.nvim',
    config = function ()
      require'fidget'.setup{}
    end
    }
  -- Snippets
  use { 'SirVer/ultisnips' }
  use { 'quangnguyen30192/cmp-nvim-ultisnips' }
  use { 'honza/vim-snippets' }
  -- Icons
  use {
    'kyazdani42/nvim-web-devicons',
    config = function() require'nvim-web-devicons'.setup() end
    }
  -- Icons for auto complete, you can never have enough
  use { 'onsails/lspkind-nvim',
    requires = { { 'hrsh7th/nvim-cmp' } }
    }
  -- Automatically creates missing LSP diagnostics highlight groups
  use { 'folke/lsp-colors.nvim' }
  -- heighlights Colors with their color xd
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require'colorizer'.setup() end
    }
  use("nathom/filetype.nvim")
  -- Themes
  use 'rktjmp/lush.nvim' -- used to create colorschemes
  use 'nanotech/jellybeans.vim'
  use 'ellisonleao/gruvbox.nvim'
  use 'dracula/vim'
  use 'folke/tokyonight.nvim'
  use 'shaunsingh/nord.nvim'
  use { 'catppuccin/nvim' }
  use { -- Colors
    'tjdevries/colorbuddy.vim',
    config = function() require'colorbuddy'.setup() end
    }
  use { 'overcache/NeoSolarized' }
  use { -- adds transpancy toggles
    'xiyaowong/nvim-transparent',
    disable = true,
    config = function()
      require("transparent").setup({
        enable = true, -- boolean: enable transparent
        extra_groups = { -- table/string: additional groups that should be clear
          "BufferLineTabClose",
          "BufferlineBufferSelected",
          "BufferLineFill",
          "BufferLineBackground",
          "BufferLineSeparator",
          "BufferLineIndicatorSelected",
        },
        exclude = {}, -- table: groups you don't want to clear
      })
    end
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
