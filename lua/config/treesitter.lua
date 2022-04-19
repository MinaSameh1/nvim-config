local status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

require('nvim-treesitter.install').compilers = { 'clang' }

configs.setup({
  ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { '' }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { '' }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  indent = { enable = true, disable = { 'yaml' } },
  swap = {
    enable = true,
    swap_next = {
      ['<leader>ss'] = '@parameter.inner',
    },
    swap_previous = {
      ['<leader>sS'] = '@parameter.inner',
    },
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  matchup = { enable = true },
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      [']m'] = '@function.outer',
      [']]'] = '@class.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
      [']['] = '@class.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[['] = '@class.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
      ['[]'] = '@class.outer',
    },
  },
  -- lsp_interop = {
  --   enable = true,
  --   border = 'single',
  --   peek_definition_code = {
  --     ['<leader>lg'] = '@block.outer',
  --     -- ["<leader>lG"] = "@class.outer",
  --   },
  -- },
  -- textsubjects = {
  --   enable = true,
  --   keymaps = {
  --     ['<cr>'] = 'textsubjects-smart', -- works in visual mode
  --   },
  -- },
  playground = {
    enable = true,
  },
})

-- Folding
-- vim.o.foldmethod = 'expr'
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
