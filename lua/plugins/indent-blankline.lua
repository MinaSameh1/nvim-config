-- TODO: look into https://github.com/lukas-reineke/indent-blankline.nvim/issues/672

-- vim.opt.list = true
-- vim.opt.listchars:append('space:⋅')
-- vim.opt.listchars:append('eol:↴')

--- Kept for chars
-- vim.g.indentLine_char_list = { '|', '¦', '┆', '┊' }
-- vim.g.indent_blankline_context_char_list = { '┃', '║', '╬', '█' }
-- vim.g.indentLine_char_list = { '┃', '║', '╬', '█' }
-- vim.g.indent_blankline_use_treesitter = true
-- vim.g.indent_blankline_show_first_indent_level = false

return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'BufReadPre',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    scope = {
      enabled = true,
      char = '│',
      show_start = true,
      show_end = true,
      show_exact_scope = true,
    },
    indent = {
      -- char = '│',
      char = { '¦', '┆', '┊' },
      -- tab_char = "│",
      smart_indent_cap = true,
    },

    whitespace = {
      highlight = { 'Whitespace', 'NonText', 'Function', 'Label' },
    },

    exclude = {
      filetypes = {
        'help',
        'dashboard',
        'TelescopePrompt',
        'TelescopeResults',
        'checkhealth',
        'packer',
        'log',
        'todoist',
        'neo-tree',
        'lspinfo',
        'toggleterm',
        'lsp-installer',
        'terminal',
      },
      buftypes = {
        'terminal',
        'prompt',
        'nofile',
        'help',
      },
    },
  },
}
