-- TODO: look into https://github.com/lukas-reineke/indent-blankline.nvim/issues/672
local function M()
  vim.opt.list = true
  vim.opt.listchars:append('space:⋅')
  -- vim.opt.listchars:append('eol:↴')
  vim.g.indentLine_char_list = { '|', '¦', '┆', '┊' }
  vim.g.indent_blankline_context_char_list = { '┃', '║', '╬', '█' }
  vim.g.indentLine_char_list = { '┃', '║', '╬', '█' }
  vim.g.indent_blankline_use_treesitter = true
  vim.g.indent_blankline_show_first_indent_level = false

  return require('ibl').setup({
    scope = { enabled = true },
    exclude = {
      filetypes = {
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
      buftypes = {
        'terminal',
        'prompt',
        'nofile',
        'help',
      },
    },
    indent = {
      char = '│',
    },
    -- indent = {
    --   char = ' ',
    -- },

    ---- WARN: DEPRECATED:
    -- use_treesitter = true,
    -- buftype_exclude = { 'terminal', 'prompt', 'nofile', 'help' },
    -- filetype_exclude = {
    --   'TelescopePrompt',
    --   'TelescopeResults',
    --   'checkhealth',
    --   'packer',
    --   'lspinfo',
    --   'toggleterm',
    --   'lsp-installer',
    --   'terminal',
    -- },
    -- show_end_of_line = true,
    -- show_current_context_start = true,
    -- leading_space = true,
    -- show_first_indent_level = false,
    -- show_current_context = true,
  })
end

return M()
