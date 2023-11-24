return {
  -- LUAA
  {
    'nvim-lua/plenary.nvim',
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
      require('config.lualine.lualine')
    end,
  },
  {
    -- Shows LSP progress
    'j-hui/fidget.nvim',
    version = 'legacy',
    dependencies = 'lualine.nvim',
    event = 'LspAttach',
    opts = {},
  },
  {
    'anuvyklack/pretty-fold.nvim',
    lazy = false,
    config = function()
      require('pretty-fold').setup()
    end,
  },
  {
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
  },

  {
    -- Smooth scrolling
    'karb94/neoscroll.nvim',
    event = 'WinScrolled',
    name = 'neoscroll',
    opts = { hide_cursor = false },
  },

  {
    -- Terminal
    'akinsho/toggleterm.nvim',
    event = 'CursorHold',
    config = function()
      require('config.toggleterm')
    end,
  },

  {
    'jbyuki/venn.nvim',
    event = 'VeryLazy',
    config = function()
      require('config.venn')
    end,
  },

  -- use({
  --   'kyazdani42/nvim-tree.lua',
  --   -- cmd = { 'NvimTreeToggle' },
  --   config = function()
  --     require('config.nvimtree')
  --   end,
  -- })

  {
    's1n7ax/nvim-window-picker',
    version = 'v1.*',
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
    event = 'InsertEnter',
    config = function()
      require('config.cmp.cmp')
    end,
    dependencies = {
      {
        'L3MON4D3/Luasnip',
        config = function()
          require('config.luasnip')
        end,
        dependencies = { 'rafamadriz/friendly-snippets' },
      },
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
        hint_enable = false, -- disable virtual text hint
        hi_parameter = 'IncSearch', -- highlight group used to highlight the current parameter
      })
    end,
  },

  -- Debugger
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

  {
    'nvim-neotest/neotest',
    event = 'BufRead',
    dependencies = {
      'haydenmeade/neotest-jest',
      'nvim-neotest/neotest-python',
      'sidlatau/neotest-dart',
      'marilari88/neotest-vitest',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('config.neotest')
    end,
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
    ft = { 'tex', 'latex' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      vim.cmd(
        -- `single` (default), `double`, `rounded`
        'nnoremap <leader>p :lua require("nabla").popup({ border = "rounded" })<CR>'
      )
    end,
  },

  --- Syntax and languages
  -- Syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('config.treesitter')
    end,
  },
  {
    'nvim-treesitter/playground',
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
    -- Auto close versions
    'windwp/nvim-autopairs',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = 'InsertEnter',
    opts = {},
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    config = function()
      require('config.comments')
    end,
  },

  {
    -- comments using gc
    'numToStr/Comment.nvim',
    name = 'Comment',
    event = 'BufRead',
    lazy = false,
    config = function()
      require('Comment').setup()
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

  { 'folke/trouble.nvim', event = 'BufRead' }, -- pretty messages

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

  -- Dims lights xd
  {
    'folke/twilight.nvim',
    cmd = 'Twilight',
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
    piority = 1000,
  },
  { 'AlexvZyl/nordic.nvim', lazy = false, piority = 1000 },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    piority = 1000,
    config = function()
      vim.g.tokyonight_style = 'storm' -- Can be storm, night or day
      vim.g.tokyonight_sidebars = {
        'TelescopePrompt',
        'NvimTree',
        'terminal',
      }
      -- Change the "hint" color to the "orange" color, and make the "error" color bright red
      vim.g.tokyonight_colors = { hint = 'orange', error = '#ff0000' }
    end,
  },
  {
    'ayu-theme/ayu-vim',
    lazy = false,
    piority = 1000,
  },
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    piority = 1000,
  },
  {
    'shaunsingh/nord.nvim',
    lazy = false,
    piority = 1000,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    piority = 1000,
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    lazy = false,
    piority = 1000,
  },
  {
    'rose-pine/neovim',
    lazy = false,
    piority = 1000,
    name = 'rose-pine',
    opts = {
      dark_variant = 'moon',
    },
  },
  {
    'Tsuzat/NeoSolarized.nvim',
    lazy = false,
    piority = 1000,
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
    piority = 1000,
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
  { 'sainnhe/sonokai', lazy = false, piority = 1000 },
  {
    'mountain-theme/vim',
    lazy = false,
    piority = 1000,
    name = 'mountain',
    branch = 'master',
  },
  {
    'EdenEast/nightfox.nvim',
    main = 'nightfox',
    lazy = false,
    pirority = 1000,
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
  {
    'nvim-neorg/neorg',
    build = ':Neorg sync-parsers',
    cmd = 'Neorg',
    config = function()
      require('config.neorg')
    end,
  },
}
