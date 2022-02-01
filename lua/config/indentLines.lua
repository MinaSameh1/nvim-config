
vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
vim.g.indentLine_fileTypeExclude = {
  'dashboard', 'packer', 'lspinfo',
  'toggleterm'
}
-- vim.g.indentLine_char_list = {'|', '¦', '┆', '┊'}
-- vim.g.indent_blankline_context_char_list = {'┃', '║', '╬', '█'}
-- vim.g.indentLine_char_list = {'┃', '║', '╬', '█'}
vim.g.indentLine_leadingSpaceEnabled = 1
vim.g.indent_blankline_use_treesitter = true
vim.g.indent_blankline_show_first_indent_level = false

require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
  -- show_current_context_start = true,
  show_current_context = true,
  show_end_of_line = true,
  space_char_blankline=" "
}
