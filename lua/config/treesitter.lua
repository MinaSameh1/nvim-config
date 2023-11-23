local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

require('nvim-treesitter.install').compilers = { 'clang' }

local status_comment_ok, comment_string_context = pcall(
  require,
  'ts_context_commentstring'
)
if not status_comment_ok then
  print('Error in comment_string_context Treesitter config')
end

comment_string_context.setup({
  enable = true,
  enable_autocmd = false,
})

configs.setup({
  ensure_installed = 'all', -- one of "all" or table of parsers.
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { '' }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { '' }, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { 'yaml', 'typescript', 'javascript', 'jsdoc' },
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  matchup = { enable = true },
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      [']f'] = '@function.outer',
      [']m'] = '@class.outer',
    },
    goto_next_end = {
      [']F'] = '@function.outer',
      [']M'] = '@class.outer',
    },
    goto_previous_start = {
      ['[f'] = '@function.outer',
      ['[m'] = '@class.outer',
    },
    goto_previous_end = {
      ['[F'] = '@function.outer',
      ['[M'] = '@class.outer',
    },
  },
  textobjects = {
    lsp_interop = {
      enable = true,
      border = 'single',
      peek_definition_code = {
        ['<leader>df'] = '@block.outer',
        ['<leader>dF'] = '@class.outer',
      },
    },
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  playground = {
    enable = true,
  },
})

---- Folding
-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
