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
end

local status_ok, packer = pcall(require, "packer")
    if not status_ok then
        print("Something went wrong with Packer!")
        return
    end

return packer.startup(function(use)
    -- LUAA
    use 'nvim-lua/plenary.nvim'
    -- Dashboard
    use 'glepnir/dashboard-nvim'
    -- Pairs and close etc
    use 'windwp/nvim-autopairs' --Its actually pretty cool and can surrond stuff too!
    use 'tpope/vim-surround' -- use ysiw for example i guess
    -- Repeats plugins with . as well
    use 'tpope/vim-repeat'
    -- Status line
    use {
        'nvim-lualine/lualine.nvim',
          requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    --use 'feline-nvim/feline.nvim'
    -- Smooth scrolling
    use {
        'karb94/neoscroll.nvim',
        config = function() require'neoscroll'.setup() end
        }
    -- Terminal
    use {
        'akinsho/toggleterm.nvim',
        }
    -- Folders and stuff
    -- use 'preservim/nerdtree'
    use {
        'kyazdani42/nvim-tree.lua',
        }
    -- Aligns things easly using gaip=
    use 'junegunn/vim-easy-align'
    -- Vim MultiCurosr, use cgn instead :)
    --use 'mg979/vim-visual-multi', {'branch': 'master'}
    -- Search, and fuzzy stuff, far for replace
    use 'brooth/far.vim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
        }
    -- Emmeet for html
    use 'mattn/emmet-vim'
    -- Bar
    use {
        'akinsho/bufferline.nvim',
        config = function() require'bufferline'.setup{
            numbers = "buffer_id",
            diagnostics = "nvim_lsp",
            right_mouse_command = "vertical sbuffer %d"
        } end
        }
    -- TAG BAR
    use 'preservim/tagbar'
    -- Linting among other things
    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    -- Show lightblub on code action
    use {'kosayoda/nvim-lightbulb' }
    -- AutoCompletetion
    use 'hrsh7th/nvim-cmp'
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
    use 'mfussenegger/nvim-dap'
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
    use 'David-Kunz/jester'
    -- Git integration
    use {
        'lewis6991/gitsigns.nvim',
        }
    use 'tpope/vim-fugitive'
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
        }
    use 'sheerun/vim-polyglot'
    -- comments
    use 'JoosepAlviste/nvim-ts-context-commentstring'
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
        }
-- Auto close tags
    use { 'windwp/nvim-ts-autotag' }
    -- Shows tabs and spaces
    use 'yggdroot/indentline'
    -- pretty messages
    use 'folke/trouble.nvim'
    -- Snippets
    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'honza/vim-snippets'
    -- Icons
    use {
        'kyazdani42/nvim-web-devicons',
        config = function() require'nvim-web-devicons'.setup() end
        }
    -- ICons for auto complete, you can never have enough
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
    -- Themes
    use 'rktjmp/lush.nvim' -- used to create colorschemes
    use 'nanotech/jellybeans.vim'
    use 'ellisonleao/gruvbox.nvim'
    use 'dracula/vim'
    use 'folke/tokyonight.nvim'
    use 'shaunsingh/nord.nvim'
    use { 'catppuccin/nvim' }
    -- Colors
    use {
        'tjdevries/colorbuddy.vim',
        config = function() require'colorbuddy'.setup() end
        }
    use 'overcache/NeoSolarized'
    --
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
