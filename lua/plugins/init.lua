return {
  -- LUAA
  {
    'nvim-lua/plenary.nvim',
  },

  {
    'nvim-neotest/nvim-nio',
  },
  {
    -- Allows us to implement enamey popups
    'nvim-lua/popup.nvim',
    module = 'popup',
  },

  {
    -- use ysiw for example i guess
    'tpope/vim-surround',
    event = 'BufRead',
    dependencies = {
      { 'tpope/vim-repeat', event = 'BufRead' }, -- Repeats plugins with . as well
    },
  },

  {
    'nvim-lualine/lualine.nvim', -- Status line
    event = 'BufEnter',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('config.lualine.evil')
    end,
  },
  -- Syntax highlighting for certain things.
  { 'sheerun/vim-polyglot' },

  {
    -- Smooth scrolling
    'karb94/neoscroll.nvim',
    event = 'WinScrolled',
    name = 'neoscroll',
    opts = { hide_cursor = false },
    config = function(opts)
      require('neoscroll').setup(opts)
    end,
  },

  {
    -- Terminal
    'akinsho/toggleterm.nvim',
    event = 'CursorHold',
    config = function()
      require('config.toggleterm')
    end,
  },

  -- adds support for file operations using built-in LSP support.
  {
    'antosha417/nvim-lsp-file-operations',
    event = 'LspAttach',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim',
    },
    opts = {},
  },
  -- better matchit plug
  {
    'andymass/vim-matchup',
    event = 'BufRead',
  },

  -- Aligns things easly using gaip=
  {
    'junegunn/vim-easy-align',
    event = 'BufEnter',
  },

  -- Search, and fuzzy stuff, far for replace
  {
    'brooth/far.vim',
    opts = {},
    cmd = { 'F', 'Far', 'Farr', 'Fardo', 'Farundo' },
  },

  -- Shows actions menu on key press, really helpful
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('config.whichkey')
    end,
  },

  -- Best picker <3
  {
    lazy = false,
    'nvim-telescope/telescope.nvim',
    -- keys = {
    --   { 'n', '<Leader>fg' },
    --   { 'n', '<Leader>tc' },
    --   { 'n', '<Leader>ff' },
    --   { 'n', '<Leader>fh' },
    -- },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('config.telescope')
      require('telescope').load_extension('ui-select')
      require('telescope').load_extension('media_files')
      require('telescope').load_extension('dap')
    end,
  },
  -- No need to lazy load this
  {
    event = 'VeryLazy',
    'nvim-telescope/telescope-ui-select.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    event = 'VeryLazy',
    'nvim-telescope/telescope-media-files.nvim',
  },
  {
    event = 'VeryLazy',
    'nvim-telescope/telescope-dap.nvim',
  },

  -- Emmet for html
  {
    'mattn/emmet-vim',
    ft = {
      'html',
      'css',
      'typescriptreact',
      'javascriptreact',
    },
  },

  -- Linting among other things
  -- LSP Installer
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
  },
  { -- Auto setup LSPs
    'williamboman/mason-lspconfig.nvim',
  },
  { -- LSP config helper
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function()
      require('config.lsp')
    end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
    },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    module = 'null-ls',
    event = 'BufRead',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('config.lsp.null_ls')
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    name = 'refactoring',
    event = 'BufEnter',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  },
  {
    'simrat39/symbols-outline.nvim',
    event = 'BufRead',
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
    },
  },
  {
    -- typescript
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  },
  {
    -- for rust
    'simrat39/rust-tools.nvim',
    module = 'rust-tools',
    ft = { 'rust' },
  },
  -- Show lightblub on code action
  { 'kosayoda/nvim-lightbulb' },

  {
    'hrsh7th/nvim-cmp',
    -- event = { 'InsertEnter' },
    lazy = false,
    config = function()
      require('config.cmp')
    end,
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-cmdline' },
      { 'kdheepak/cmp-latex-symbols' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
  },

  {
    'ray-x/lsp_signature.nvim',
    dependencies = 'nvim-lspconfig',
    config = function()
      require('lsp_signature').setup({
        bind = true,
        handler_opts = {
          border = 'rounded',
        },
        floating_window = true,
        hint_enable = true, -- enable virtual text hint
        hi_parameter = 'IncSearch', -- highlight group used to highlight the current parameter
      })
    end,
  },

  {
    -- Debugger
    'mfussenegger/nvim-dap',
    key = {
      { 'n', '<leader>d' },
    },
    config = function()
      require('config.dap')
    end,
  },
  {
    -- For nvim lua
    'jbyuki/one-small-step-for-vimkind',
    dependencies = { { 'mfussenegger/nvim-dap', opt = true } },
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  -- Debugger UI
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  -- Shows variables and their values when debugging
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  -- For python
  {
    'mfussenegger/nvim-dap-python',
    module = 'dap-python',
    dependencies = { 'mfussenegger/nvim-dap' },
  },

  { -- For java, auto lazy loaded using ftplugin
    'mfussenegger/nvim-jdtls',
  },

  -- Git integration
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead' },
    config = function()
      require('config.gitsigns')
    end,
  },

  -- Git integration, LOVE IT! <3
  { 'tpope/vim-fugitive', event = 'VeryLazy' },

  -- Detect tabstop and shiftwidth automatically in file tree
  {
    'tpope/vim-sleuth',
    event = 'BufRead',
  },
  -- Latex stuff
  {
    -- NOTE: We don't need to lazy load this, it lazy loads itself.
    'lervag/vimtex',
    lazy = false,
  },
  {
    'jbyuki/nabla.nvim',
    event = 'BufRead',
    ft = { 'tex', 'latex', 'markdown', 'neorg' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.cmd(
        -- `single` (default), `double`, `rounded`
        'nnoremap <leader>P :lua require("nabla").popup({ border = "rounded" })<CR>'
      )
    end,
  },

  --- Syntax and languages
  -- Syntax highlighting
  {
    'phpactor/phpactor',
    ft = { 'php' },
    build = 'composer install',
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('config.treesitter')
    end,
  },
  {
    'nvim-treesitter/playground',
    opts = {},
    cmd = 'TSPlaygroundToggle',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    opts = {
      enable = true,
      max_lines = 3,
    },
    keys = {
      {
        '<leader>gtc',
        function()
          require('treesitter-context').go_to_context()
        end,
      },
    },
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {},
  },
  {
    -- comments using gc
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
    name = 'Comment',
    event = 'BufRead',
    config = function()
      vim.g.skip_ts_context_commentstring_module = true
      require('config.comments')
    end,
  },

  {
    -- pairs and autocloses and can surrond stuff too!
    'windwp/nvim-autopairs',
    dependencies = 'nvim-cmp', -- Must be Loaded after nvim-cmp
    event = 'InsertCharPre',
    config = function()
      require('config.autopairs')
    end,
  },

  {
    'folke/trouble.nvim',
    event = 'BufRead',
    opts = {
      auto_preview = false,
    },
    keys = {
      {
        '<leader>xx',
        '<cmd>TroubleToggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>xs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>xl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  }, -- pretty messages

  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    event = 'BufRead',
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
      },
    },
    opts = {
      keywords = {
        TODO = {
          'todo',
        },
        FIX = {
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
        },
        WARN = { alt = { 'WARNING', 'XXX' } },
        NOTE = { alt = { 'INFO', 'Note', 'note' } },
      },
    },
  },

  -- Icons
  {
    'kyazdani42/nvim-web-devicons',
    lazy = false,
    opts = {},
  },

  -- heighlights Colors with their color xd
  {
    'norcalli/nvim-colorizer.lua',
    event = 'CursorHold',
    config = function()
      require('colorizer').setup()
    end,
  },

  {
    -- Dims lights xd
    'folke/twilight.nvim',
    cmd = 'Twilight',
  },
  {
    -- Zen mode
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {},
  },
  {
    'Makaze/watch.nvim',
    cmd = { 'WatchStart', 'WatchStop', 'WatchFile' },
  },

  -- Takes beautiful screenshots of code
  -- use({
  --   'narutoxy/silicon.lua',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('config.silicon')
  --   end,
  -- })

  -- Themes
  { 'rktjmp/lush.nvim' }, -- used to create colorschemes
  { 'savq/melange', lazy = false, priority = 1000 },
  { 'nanotech/jellybeans.vim', lazy = false, priority = 1000 },
  {
    'dracula/vim',
    name = 'dracula',
    lazy = false,
    priority = 1000,
  },
  { 'AlexvZyl/nordic.nvim', lazy = false, priority = 1000 },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.tokyonight_style = 'storm' -- Can be storm, night or day
      vim.g.tokyonight_sidebars = {
        'TelescopePrompt',
        'neo-tree',
        'terminal',
      }
      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      vim.g.tokyonight_colors = { hint = 'orange', error = '#ff0000' }
    end,
  },
  {
    'ayu-theme/ayu-vim',
    lazy = false,
    priority = 1000,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'shaunsingh/nord.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    lazy = false,
    priority = 1000,
  },
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    name = 'rose-pine',
    opts = {
      dark_variant = 'moon',
      -- disable_background = true,
    },
  },
  {
    'Tsuzat/NeoSolarized.nvim',
    lazy = false,
    priority = 1000,
    main = 'NeoSolarized',
    --[[ config = function(opts) ]]
    --[[   require('NeoSolarized').setup(opts) ]]
    --[[   vim.cmd.colorscheme('NeoSolarized') ]]
    --[[ end, ]]
    opts = {
      style = 'dark',
      transparent = false,
    },
  },
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    },
  },
  {
    'AlphaTechnolog/pywal.nvim',
    cond = function()
      return vim.fn.executable('wal')
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    main = 'kanagawa',
    config = function(opts)
      require('kanagawa').setup(opts)
      -- vim.cmd.colorscheme('kanagawa-wave')
    end,
    opts = {
      transparent = false,
      dimInactive = true, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true,
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
    },
  },
  { 'sainnhe/sonokai', lazy = false, priority = 1000 },
  {
    'mountain-theme/vim',
    lazy = false,
    priority = 1000,
    name = 'mountain',
    branch = 'master',
  },
  {
    'EdenEast/nightfox.nvim',
    main = 'nightfox',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      terminal_colors = true,
    },
  },
  {
    'akinsho/horizon.nvim',
    version = '*',
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme('horizon')
    -- end,
  },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = true,
      terminal_colors = true,
    },
  },

  {
    -- Colors
    'tjdevries/colorbuddy.vim',
    event = 'BufRead',
    config = function()
      require('colorbuddy').setup()
    end,
  },

  {
    -- Startup time
    'tweekmonster/startuptime.vim',
    cmd = 'StartupTime',
  },

  {
    -- Github copilot
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'InsertEnter',
  },
}
