local function M()
  vim.opt.list = true
  -- vim.opt.listchars:append("space:⋅")
  -- vim.opt.listchars:append("eol:↴")
  -- vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
  -- vim.g.indent_blankline_context_char_list = {'┃', '║', '╬', '█'}
  -- vim.g.indentLine_char_list = {'┃', '║', '╬', '█'}
  -- vim.g.indent_blankline_use_treesitter = true
  -- vim.g.indent_blankline_show_first_indent_level = false

  return require('indent_blankline').setup({
    use_treesitter = true,
    filetype_exclude = {
      'help',
      'dashboard',
      'TelescopePrompt',
      'TelescopeResults',
      'checkhealth',
      'packer',
      'lspinfo',
      'toggleterm',
      'lsp-installer',
      'terminal',
    },
    buftype_exclude = { 'termina' },
    show_first_indent_level = false,
    leading_space = true,
    -- for example, context is off by default, use this to turn it on
    -- show_current_context_start = true,
    show_current_context = true,
    show_end_of_line = true,
    space_char_blankline = ' ',
  })
end

return M()
