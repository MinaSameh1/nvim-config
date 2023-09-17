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
  git = {
    clone_timeout = 6000, -- seconds
  },
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
    prompt_border = 'single',
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

  use({
    -- Allows us to implement easy popups
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

  use({
    -- use ysiw for example i guess
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
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('config.lualine.lualine_slanted')
      end,
    },
    {
      -- Shows LSP progress
      'j-hui/fidget.nvim',
      tag = 'legacy',
      after = 'lualine.nvim',
      config = function()
        require('fidget').setup({
          sources = {
            ['null-ls'] = {
              ignore = true,
            },
            ['ltex'] = {
              ignore = true,
            },
          },
        })
      end,
    },
  })

  use({
    -- Split screen management
    'beauwilliams/focus.nvim',
    module = 'focus',
    cmd = { 'FocusSplitNicely', 'FocusSplitCycle' },
    -- event = { 'BufRead', 'BufNewFile', 'WinEnter', 'BufWinEnter' },
    config = function()
      require('focus').setup({
        excludeded_filetypes = {
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

  use({
    -- Smooth scrolling
    'karb94/neoscroll.nvim',
    event = 'WinScrolled',
    config = function()
      require('neoscroll').setup({ hide_cursor = false })
    end,
  })

  use({
    -- Terminal
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

  -- use({
  --   'kyazdani42/nvim-tree.lua',
  --   -- cmd = { 'NvimTreeToggle' },
  --   config = function()
  --     require('config.nvimtree')
  --   end,
  -- })

  use({
    {
      's1n7ax/nvim-window-picker',
      tag = 'v1.*',
      config = function()
        require('window-picker').setup({
          use_winbar = 'never',
          autoselect_one = true,
          include_current_win = false,
          filter_rules = {
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', 'quickfix' },
            },
          },
          other_win_hl_color = '#e35e4f',
        })
      end,
    },
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
      },
      config = function()
        require('config.neotree')
      end,
    },
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
  -- use({
  --   'mg979/vim-visual-multi',
  --   disable = true,
  -- })

  -- Search, and fuzzy stuff, far for replace
  use({
    'brooth/far.vim',
    opt = true,
    cmd = { 'F', 'Far', 'Fardo', 'Farundo' },
  })

  -- Shows actions menu on key press, really helpful
  use({
    'folke/which-key.nvim',
    config = function()
      require('config.whichkey')
    end,
  })

  -- Best picker <3
  use({
    {
      'nvim-telescope/telescope.nvim',
      -- keys = {
      --   { 'n', '<Leader>fg' },
      --   { 'n', '<Leader>tc' },
      --   { 'n', '<Leader>ff' },
      --   { 'n', '<Leader>fh' },
      -- },
      requires = { 'nvim-lua/plenary.nvim' },
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
      requires = { 'nvim-lua/plenary.nvim' },
    },
    {
      'nvim-telescope/telescope-media-files.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('media_files')
      end,
      requires = { 'nvim-telescope/telescope.nvim' },
    },
    {
      'nvim-telescope/telescope-dap.nvim',
      after = 'telescope.nvim',
      config = function()
        require('telescope').load_extension('dap')
      end,
      requires = { 'nvim-telescope/telescope.nvim' },
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
    {
      'williamboman/mason.nvim',
    },
    {
      'williamboman/mason-lspconfig.nvim',
    },
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('config.lsp.NeovimLSP')
      end,
      requires = {
        -- WARN: Unfortunately we won't be able to lazy load this
        {
          'hrsh7th/cmp-nvim-lsp',
        },
      },
    },
    {
      'jose-elias-alvarez/null-ls.nvim',
      after = 'nvim-lspconfig',
      module = 'null-ls',
      event = 'BufRead',
      requires = { { 'neovim/nvim-lspconfig' } },
      config = function()
        require('config.lsp.null_ls')
      end,
    },
    {
      'ThePrimeagen/refactoring.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-treesitter/nvim-treesitter' },
      },
    },
    {
      'simrat39/symbols-outline.nvim',
      config = function()
        require('symbols-outline').setup()
      end,
    },
    {
      -- typescript
      'jose-elias-alvarez/typescript.nvim',
      module = 'typescript',
    },
    {
      -- for rust
      'simrat39/rust-tools.nvim',
      module = 'rust-tools',
      ft = { 'rust' },
    },
    -- Show lightblub on code action
    { 'kosayoda/nvim-lightbulb' },
  })

  -- AutoCompletetion and snippets, replaced with luasnip
  -- use(
  --   { 'SirVer/ultisnips', after = 'nvim-cmp' },
  --   { 'quangnguyen30192/cmp-nvim-ultisnips', after = 'ultisnips' },
  --   { 'honza/vim-snippets', after = 'ultisnips' }
  -- )

  use({
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('config.cmp.cmp')
      end,
      requires = {
        {
          'L3MON4D3/LuaSnip',
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
    {
      'mfussenegger/nvim-dap',
      key = {
        { 'n', '<leader>d' },
      },
      config = function()
        require('config.dap.dap')
      end,
    },
    {
      -- For nvim lua
      'jbyuki/one-small-step-for-vimkind',
      requires = { { 'mfussenegger/nvim-dap', opt = true } },
    },
    {
      'mxsdev/nvim-dap-vscode-js',
      requires = { 'mfussenegger/nvim-dap' },
    },
    -- Debugger UI
    {
      'rcarriga/nvim-dap-ui',
      requires = { 'mfussenegger/nvim-dap' },
    },
    -- Shows variables and their values when debugging
    {
      'theHamsta/nvim-dap-virtual-text',
      requires = { 'mfussenegger/nvim-dap' },
    },
    {
      'mfussenegger/nvim-dap-python',
      module = 'dap-python',
      requires = { 'mfussenegger/nvim-dap' },
    },
  })

  use({ -- For java
    'mfussenegger/nvim-jdtls',
    -- ft = { 'java' },
    -- Use ftplugin/java instead
    -- config = function()
    --   require('config.jdtls')
    -- end,
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

  --- Deprecated.
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

  -- Detect tabstop and shiftwidth automatically
  use('tpope/vim-sleuth')
  -- Latex stuff
  use({
    -- NOTE: We don't need to lazy load this, it lazy loads itself.
    'lervag/vimtex',
  })
  use({
    'jbyuki/nabla.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.cmd(
        'nnoremap <leader>p :lua require("nabla").popup({ border = "rounded" })<CR> " `single` (default), `double`, `rounded`'
      )
    end,
  })

  --- Syntax and languages
  -- Syntax highlighting
  use({
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('config.treesitter')
      end,
    },
    { 'nvim-treesitter/playground', after = 'nvim-treesitter' },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      after = 'nvim-treesitter',
    },
    {
      -- Auto close tags
      'windwp/nvim-ts-autotag',
      after = 'nvim-treesitter',
      config = function()
        require('nvim-ts-autotag').setup()
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

  use({
    -- comments using gc
    'numToStr/Comment.nvim',
    event = 'BufRead',
    config = function()
      require('Comment').setup()
    end,
  })

  use({
    -- pairs and autocloses and can surrond stuff too!
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

  ---- For now use prettier tailwind
  -- use({
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

  -- Dims lights xd
  use({
    'folke/twilight.nvim',
    cmd = 'Twilight',
  })

  -- Takes beautiful screenshots of code
  -- use({
  --   'narutoxy/silicon.lua',
  --   requires = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('config.silicon')
  --   end,
  -- })

  -- Themes
  use({
    { 'rktjmp/lush.nvim' }, -- used to create colorschemes
    { 'savq/melange' },
    { 'nanotech/jellybeans.vim' },
    { 'dracula/vim', as = 'dracula' },
    { 'AlexvZyl/nordic.nvim' },
    {
      'folke/tokyonight.nvim',
      config = function()
        require('config.colorscheme').setupTokyonight()
      end,
    },
    { 'ellisonleao/gruvbox.nvim' },
    { 'shaunsingh/nord.nvim' },
    { 'catppuccin/nvim', as = 'catppuccin' },
    { 'nyoom-engineering/oxocarbon.nvim' },
    {
      'rose-pine/neovim',
      as = 'rose-pine',
      config = function()
        require('rose-pine').setup({
          dark_variant = 'moon',
        })
      end,
    },
    {
      'Tsuzat/NeoSolarized.nvim',
      config = function()
        require('NeoSolarized').setup({
          style = 'dark',
          transparent = false,
        })
      end,
    },
    {
      'AlphaTechnolog/pywal.nvim',
      disable = true,
    },
    {
      'rebelot/kanagawa.nvim',
      config = function()
        require('kanagawa').setup({
          transparent = false,
          dimInactive = true, -- dim inactive window `:h hl-NormalNC`
          terminalColors = true,
          background = {
            dark = 'dragon',
            light = 'lotus',
          },
        })
      end,
    },
    { 'sainnhe/sonokai' },
    {
      'mountain-theme/vim',
      as = 'mountain',
      branch = 'master',
    },
    {
      'EdenEast/nightfox.nvim',
      config = function()
        require('nightfox').setup({
          transparent = false,
          terminal_colors = true,
        })
      end,
    },
  })

  use({
    -- Colors
    'tjdevries/colorbuddy.vim',
    event = 'BufRead',
    config = function()
      require('colorbuddy').setup()
    end,
  })

  use({
    -- Startup time
    'tweekmonster/startuptime.vim',
    cmd = 'StartupTime',
  })

  use({
    -- Github copilot
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'InsertEnter',
  })

  use({
    'nvim-neorg/neorg',
    run = ':Neorg sync-parsers',
    config = function()
      require('config.neorg')
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
